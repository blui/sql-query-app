// server/index.js

const express = require("express");
const sql = require("mssql");
const cors = require("cors");
const bodyParser = require("body-parser");

const app = express();

// Middleware to handle CORS and parse JSON bodies
app.use(cors());
app.use(bodyParser.json());

// SQL Server connection configuration
const config = {
  user: "blui", // SQL Server username
  password: "test123!", // SQL Server password
  server: "localhost", // SQL Server instance (localhost for local)
  database: "VacationDestinations", // The database you're connecting to
  options: {
    encrypt: false, // Disable encryption if it's a local instance
    trustServerCertificate: true, // Allow self-signed certificates (for local dev)
  },
};

// Establish SQL Server connection
sql
  .connect(config)
  .then(() => {
    console.log("Connected to SQL Server");
  })
  .catch((err) => {
    console.error("Database connection failed: ", err);
  });

// API endpoint for executing SQL queries
app.post("/execute-query", async (req, res) => {
  const { query } = req.body; // Extract query from request body

  try {
    const result = await sql.query(query); // Execute the SQL query
    res.json(result.recordset); // Send the result back to the client
  } catch (err) {
    res.status(400).json({ error: err.message }); // Send error response if query fails
  }
});

// Start the server
const PORT = 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
