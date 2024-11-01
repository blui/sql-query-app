// server/index.js

const express = require("express");
const sql = require("mssql");
const cors = require("cors");
const bodyParser = require("body-parser");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const { v4: uuidv4 } = require("uuid");
const winston = require("winston");
const fs = require("fs");
const path = require("path");

// Load configuration from config.json
const configPath = path.join(__dirname, "config.json");
let configData = JSON.parse(fs.readFileSync(configPath, "utf8"));
const { sqlConfig, SECRET_KEY } = configData;

// Initialize connection config for SQLQueryExplorer
const defaultConnectionConfig = sqlConfig.SQLQueryExplorer;

// Set up logger using Winston
const logger = winston.createLogger({
  level: "info",
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [
    new winston.transports.Console(),
    new winston.transports.File({ filename: "app.log" }),
  ],
});

// Initialize Express app and middleware
const app = express();
app.use(cors());
app.use(bodyParser.json());

// Connect to SQLQueryExplorer database for internal app use
async function connectToDefaultDatabase() {
  try {
    await sql.connect(defaultConnectionConfig);
    logger.info("Connected to SQLQueryExplorer database");
  } catch (err) {
    logger.error("Database connection failed:", err);
  }
}
connectToDefaultDatabase();

// Authentication middleware to verify user session
const authenticate = async (req, res, next) => {
  const token = req.headers.authorization?.split(" ")[1];
  if (!token) return res.status(401).json({ error: "Unauthorized" });

  try {
    const { userId } = jwt.verify(token, SECRET_KEY);
    const sessionId = req.headers["x-session-id"];
    const sessionResult = await sql.query`
      SELECT * FROM SQLQueryExplorer.dbo.Sessions WHERE session_id = ${sessionId} AND user_id = ${userId}`;

    if (!sessionResult.recordset.length) {
      logger.warn(`Invalid session for user ID: ${userId}`);
      return res.status(401).json({ error: "Invalid session" });
    }

    req.userId = userId;
    next();
  } catch (error) {
    logger.error(`Authentication failed - ${error.message}`);
    res.status(401).json({ error: "Unauthorized" });
  }
};

// Route to get VacationDestinations configuration for SqlConnectionConfig.vue
app.get("/config", authenticate, (req, res) => {
  try {
    const vacationConfig = configData.sqlConfig.VacationDestinations;
    res.json({ sqlConfig: { VacationDestinations: vacationConfig } });
  } catch (error) {
    logger.error("Failed to load configuration:", error);
    res.status(500).json({ error: "Failed to load configuration." });
  }
});

// Route to update only VacationDestinations configuration in config.json
app.put("/config", authenticate, async (req, res) => {
  const { sqlConfig } = req.body;

  if (sqlConfig && sqlConfig.VacationDestinations) {
    configData.sqlConfig.VacationDestinations = sqlConfig.VacationDestinations;
    try {
      fs.writeFileSync(configPath, JSON.stringify(configData, null, 2));
      logger.info("Updated VacationDestinations configuration");
      res.json({ message: "Configuration updated successfully." });
    } catch (error) {
      logger.error("Failed to save configuration:", error);
      res.status(500).json({ error: "Failed to save configuration." });
    }
  } else {
    logger.warn("Invalid configuration update request");
    res.status(400).json({ error: "Invalid configuration update request." });
  }
});

// Route to get user profile (for fetchUserData in App.vue)
app.get("/profile", authenticate, async (req, res) => {
  try {
    const result = await sql.query`
      SELECT firstName, username FROM SQLQueryExplorer.dbo.Users WHERE id = ${req.userId}`;
    if (result.recordset.length > 0) {
      res.json(result.recordset[0]);
    } else {
      res.status(404).json({ error: "User not found" });
    }
  } catch (error) {
    logger.error("Failed to fetch user profile:", error);
    res.status(500).json({ error: "Failed to fetch profile" });
  }
});

// Route to retrieve saved queries (for fetchSavedQueries in App.vue)
app.get("/saved-queries", authenticate, async (req, res) => {
  try {
    const result = await sql.query`
      SELECT id, queryName, queryText FROM SQLQueryExplorer.dbo.SavedQueries WHERE user_id = ${req.userId}`;
    res.json(result.recordset);
  } catch (error) {
    logger.error("Failed to fetch saved queries:", error);
    res.status(500).json({ error: "Failed to fetch saved queries" });
  }
});

// Endpoint to test a given vendor database connection
app.post("/test-connection", authenticate, async (req, res) => {
  const testConfig = req.body;
  try {
    const pool = new sql.ConnectionPool(testConfig);
    await pool.connect();
    await pool.close();
    res.json({ message: "Connection test succeeded!" });
  } catch (error) {
    logger.error("Test connection failed:", error);
    res.status(500).json({ error: "Connection test failed." });
  }
});

// Endpoint to execute SQL query on specified vendor database configuration
app.post("/execute-query", authenticate, async (req, res) => {
  const { query, dbConfig } = req.body;

  if (!dbConfig || !query) {
    return res
      .status(400)
      .json({ error: "Database configuration and query are required" });
  }

  const tempPool = new sql.ConnectionPool(dbConfig);

  try {
    await tempPool.connect();
    const result = await tempPool.request().query(query);
    logger.info(`Executed query: ${query}`);
    res.json(result.recordset);
  } catch (err) {
    logger.error(`Failed to execute query: ${query} - ${err.message}`);
    res.status(400).json({ error: err.message });
  } finally {
    await tempPool.close();
  }
});

// Route to register a new user
app.post("/register", async (req, res) => {
  const { username, password, email } = req.body;
  const hashedPassword = await bcrypt.hash(password, 10);

  try {
    await sql.query`
      INSERT INTO SQLQueryExplorer.dbo.Users (username, password_hash, email) VALUES (${username}, ${hashedPassword}, ${email})`;
    logger.info(`User registered successfully: ${username}`);
    res.status(201).json({ message: "User registered successfully" });
  } catch (error) {
    logger.error(`Registration failed for ${username}: ${error.message}`);
    res.status(500).json({ error: "Registration failed" });
  }
});

// Route to log in a user and start a session
app.post("/login", async (req, res) => {
  const { username, password } = req.body;

  try {
    const result = await sql.query`
      SELECT * FROM SQLQueryExplorer.dbo.Users WHERE username = ${username}`;
    const user = result.recordset[0];

    if (!user || !(await bcrypt.compare(password, user.password_hash))) {
      logger.warn(`Invalid login attempt for username: ${username}`);
      return res.status(401).json({ error: "Invalid credentials" });
    }

    // Generate JWT token and session ID
    const token = jwt.sign({ userId: user.id }, SECRET_KEY, {
      expiresIn: "1h",
    });
    const sessionId = uuidv4();
    const expiresAt = new Date(Date.now() + 3600000);

    await sql.query`
      INSERT INTO SQLQueryExplorer.dbo.Sessions (session_id, user_id, expires_at) VALUES (${sessionId}, ${user.id}, ${expiresAt})`;

    logger.info(`User logged in successfully: ${username}`);
    res.json({ token, sessionId });
  } catch (error) {
    logger.error(`Login failed for username: ${username} - ${error.message}`);
    res.status(500).json({ error: "Login failed" });
  }
});

// Start the server
const PORT = 5000;
app.listen(PORT, () => {
  logger.info(`Server running on port ${PORT}`);
  console.log(`Server is running on http://localhost:${PORT}`);
});
