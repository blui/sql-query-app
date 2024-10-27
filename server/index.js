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
const path = require("path"); // Import the path module

// Load configuration from config.json
const configPath = path.join(__dirname, "config.json");
const configData = JSON.parse(fs.readFileSync(configPath, "utf8"));
const { sqlConfig, SECRET_KEY } = configData;

// Initialize logger
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

// Middleware setup
const app = express();
app.use(cors());
app.use(bodyParser.json());

let connectionConfig = sqlConfig;

// Establish connection to SQL Server
function connectToDatabase() {
  return sql
    .connect(connectionConfig)
    .then(() => logger.info("Connected to SQL Server"))
    .catch((err) => logger.error("Database connection failed:", err));
}

connectToDatabase();

// Middleware to authenticate and verify user session
const authenticate = async (req, res, next) => {
  const token = req.headers.authorization?.split(" ")[1];
  if (!token) return res.status(401).json({ error: "Unauthorized" });

  try {
    const { userId } = jwt.verify(token, SECRET_KEY);
    const sessionId = req.headers["x-session-id"];

    // Check session validity
    const sessionResult =
      await sql.query`SELECT * FROM Sessions WHERE session_id = ${sessionId} AND user_id = ${userId}`;
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

// Endpoint to get SQL connection configuration
app.get("/config", authenticate, (req, res) => {
  try {
    const configData = JSON.parse(fs.readFileSync(configPath, "utf8"));
    res.json(configData);
  } catch (error) {
    logger.error("Failed to load configuration:", error);
    res.status(500).json({ error: "Failed to load configuration." });
  }
});

// Endpoint to update SQL connection configuration
app.put("/config", authenticate, async (req, res) => {
  const newConfig = req.body;
  configData.sqlConfig = newConfig;

  // Save the new configuration to config.json
  fs.writeFileSync(configPath, JSON.stringify(configData, null, 2));

  // Update in-memory connection config
  connectionConfig = newConfig;

  // Reconnect with new config
  await sql.close();
  await connectToDatabase();

  res.json({ message: "Configuration updated and reconnected" });
});

// Register a new user
app.post("/register", async (req, res) => {
  const { username, password, email } = req.body;
  const hashedPassword = await bcrypt.hash(password, 10);

  try {
    await sql.query`INSERT INTO Users (username, password_hash, email) VALUES (${username}, ${hashedPassword}, ${email})`;
    logger.info(`User registered successfully: ${username}`);
    res.status(201).json({ message: "User registered successfully" });
  } catch (error) {
    logger.error(`Registration failed for ${username}: ${error.message}`);
    res.status(500).json({ error: "Registration failed" });
  }
});

// Login route for users
app.post("/login", async (req, res) => {
  const { username, password } = req.body;

  try {
    const result =
      await sql.query`SELECT * FROM Users WHERE username = ${username}`;
    const user = result.recordset[0];

    if (!user || !(await bcrypt.compare(password, user.password_hash))) {
      logger.warn(`Invalid login attempt for username: ${username}`);
      return res.status(401).json({ error: "Invalid credentials" });
    }

    const token = jwt.sign({ userId: user.id }, SECRET_KEY, {
      expiresIn: "1h",
    });
    const sessionId = uuidv4();
    const expiresAt = new Date(Date.now() + 3600000);

    await sql.query`INSERT INTO Sessions (session_id, user_id, expires_at) VALUES (${sessionId}, ${user.id}, ${expiresAt})`;

    logger.info(`User logged in successfully: ${username}`);
    res.json({ token, sessionId });
  } catch (error) {
    logger.error(`Login failed for username: ${username} - ${error.message}`);
    res.status(500).json({ error: "Login failed" });
  }
});

// Get user profile information
app.get("/profile", authenticate, async (req, res) => {
  try {
    const userId = req.userId;
    if (!userId) throw new Error("User ID not found in session.");

    const result =
      await sql.query`SELECT firstName, lastName, role, email FROM Users WHERE id = ${userId}`;
    const profile = result.recordset[0];

    if (profile) {
      logger.info(`Fetched profile for user ID: ${userId}`);
      res.json(profile);
    } else {
      logger.warn(`Profile not found for user ID: ${userId}`);
      res.status(404).json({ error: "Profile not found" });
    }
  } catch (error) {
    logger.error(
      `Failed to get profile for user ID: ${req.userId} - ${error.message}`
    );
    res.status(500).json({ error: "Failed to get profile" });
  }
});

// Update user profile information
app.put("/profile", authenticate, async (req, res) => {
  try {
    const userId = req.userId;
    const { firstName, lastName, role, email } = req.body;

    await sql.query`UPDATE Users SET firstName = ${firstName}, lastName = ${lastName}, role = ${role}, email = ${email} WHERE id = ${userId}`;

    logger.info(`Updated profile for user ID: ${userId}`);
    res.json({ message: "Profile updated successfully" });
  } catch (error) {
    logger.error(
      `Failed to update profile for user ID: ${req.userId} - ${error.message}`
    );
    res.status(500).json({ error: "Failed to update profile" });
  }
});

// Save a query specific to the authenticated user
app.post("/save-query", authenticate, async (req, res) => {
  const { queryName, queryText } = req.body;
  const userId = req.userId;

  try {
    await sql.query`INSERT INTO SavedQueries (queryName, queryText, user_id) VALUES (${queryName}, ${queryText}, ${userId})`;
    logger.info(`Query saved by user ID: ${userId}, Query Name: ${queryName}`);
    res.json({ message: "Query saved successfully" });
  } catch (err) {
    logger.error(
      `Failed to save query for user ID: ${userId} - ${err.message}`
    );
    res.status(500).json({ error: "Could not save query" });
  }
});

// Fetch user-specific saved queries
app.get("/saved-queries", authenticate, async (req, res) => {
  const userId = req.userId;

  try {
    const result =
      await sql.query`SELECT * FROM SavedQueries WHERE user_id = ${userId}`;
    logger.info(`Fetched saved queries for user ID: ${userId}`);
    res.json(result.recordset);
  } catch (error) {
    logger.error(
      `Failed to fetch queries for user ID: ${userId} - ${error.message}`
    );
    res.status(500).json({ error: "Could not fetch saved queries" });
  }
});

// Execute SQL query (does not require user authentication)
app.post("/execute-query", async (req, res) => {
  const { query } = req.body;

  try {
    const result = await sql.query(query);
    logger.info(`Executed query: ${query}`);
    res.json(result.recordset);
  } catch (err) {
    logger.error(`Failed to execute query: ${query} - ${err.message}`);
    res.status(400).json({ error: err.message });
  }
});

// Start the server
const PORT = 5000;
app.listen(PORT, () => {
  logger.info(`Server running on port ${PORT}`);
  console.log(`Server is running on http://localhost:${PORT}`);
});
