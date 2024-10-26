// server/index.js

const express = require("express");
const sql = require("mssql");
const cors = require("cors");
const bodyParser = require("body-parser");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const { v4: uuidv4 } = require("uuid");

const app = express();
const SECRET_KEY = "your-secret-key"; // Replace with a secure secret key

// Middleware setup
app.use(cors()); // Enables Cross-Origin Resource Sharing
app.use(bodyParser.json()); // Parses incoming JSON requests

// SQL Server connection configuration
const config = {
  user: "blui",
  password: "test123!",
  server: "localhost",
  database: "VacationDestinations",
  options: {
    encrypt: false,
    trustServerCertificate: true,
  },
};

// Establish connection to SQL Server
sql
  .connect(config)
  .then(() => console.log("Connected to SQL Server"))
  .catch((err) => console.error("Database connection failed: ", err));

// Register a new user
app.post("/register", async (req, res) => {
  const { username, password, email } = req.body;
  const hashedPassword = await bcrypt.hash(password, 10); // Hash the password for security

  try {
    await sql.query`INSERT INTO Users (username, password_hash, email) VALUES (${username}, ${hashedPassword}, ${email})`;
    res.status(201).json({ message: "User registered successfully" });
  } catch (error) {
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
      return res.status(401).json({ error: "Invalid credentials" });
    }

    // Generate JWT token
    const token = jwt.sign({ userId: user.id }, SECRET_KEY, {
      expiresIn: "1h",
    });
    const sessionId = uuidv4();
    const expiresAt = new Date(Date.now() + 3600000); // 1 hour expiry

    await sql.query`INSERT INTO Sessions (session_id, user_id, expires_at) VALUES (${sessionId}, ${user.id}, ${expiresAt})`;

    res.json({ token, sessionId });
  } catch (error) {
    res.status(500).json({ error: "Login failed" });
  }
});

// Middleware to authenticate and verify user session
const authenticate = async (req, res, next) => {
  const token = req.headers.authorization?.split(" ")[1];
  if (!token) return res.status(401).json({ error: "Unauthorized" });

  try {
    const { userId } = jwt.verify(token, SECRET_KEY);
    const sessionId = req.headers["x-session-id"];

    const sessionResult =
      await sql.query`SELECT * FROM Sessions WHERE session_id = ${sessionId} AND user_id = ${userId}`;
    if (!sessionResult.recordset.length)
      return res.status(401).json({ error: "Invalid session" });

    req.userId = userId;
    next();
  } catch (error) {
    res.status(401).json({ error: "Unauthorized" });
  }
};

// Save a query specific to the authenticated user
app.post("/save-query", authenticate, async (req, res) => {
  const { queryName, queryText } = req.body;
  const userId = req.userId;

  try {
    await sql.query`INSERT INTO SavedQueries (queryName, queryText, user_id) VALUES (${queryName}, ${queryText}, ${userId})`;
    res.json({ message: "Query saved successfully" });
  } catch (err) {
    res.status(500).json({ error: "Could not save query" });
  }
});

// Fetch user-specific saved queries
app.get("/saved-queries", authenticate, async (req, res) => {
  const userId = req.userId;

  try {
    const result =
      await sql.query`SELECT * FROM SavedQueries WHERE user_id = ${userId}`;
    res.json(result.recordset);
  } catch (error) {
    res.status(500).json({ error: "Could not fetch saved queries" });
  }
});

// Execute SQL query (does not require user authentication)
app.post("/execute-query", async (req, res) => {
  const { query } = req.body;

  try {
    const result = await sql.query(query);
    res.json(result.recordset);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// Start the server
const PORT = 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
