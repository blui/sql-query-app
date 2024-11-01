-- Create schema for the application
CREATE SCHEMA SQLQueryExplorer;
GO

-- SQLQueryExplorer tables

-- Users table
CREATE TABLE Users (
    id INT PRIMARY KEY IDENTITY,
    username NVARCHAR(50) UNIQUE NOT NULL,
    password_hash NVARCHAR(255) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    firstName NVARCHAR(50),
    lastName NVARCHAR(50),
    role NVARCHAR(50),
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- Sessions table
CREATE TABLE Sessions (
    session_id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    user_id INT FOREIGN KEY REFERENCES Users(id) ON DELETE CASCADE,
    created_at DATETIME DEFAULT GETDATE(),
    expires_at DATETIME
);
GO

-- UserPreferences table
CREATE TABLE UserPreferences (
    user_id INT FOREIGN KEY REFERENCES Users(id) ON DELETE CASCADE,
    theme NVARCHAR(50),
    default_query NVARCHAR(MAX)
);
GO

-- SavedQueries table
CREATE TABLE SavedQueries (
    id INT IDENTITY(1,1) PRIMARY KEY,
    queryName NVARCHAR(255) NOT NULL,
    queryText NVARCHAR(MAX) NOT NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    user_id INT FOREIGN KEY REFERENCES Users(id) ON DELETE CASCADE
);
GO

-- Optional: Insert initial data for testing
-- hashed_password is test123
INSERT INTO Users (username, password_hash, email, firstName, lastName, role)
VALUES 
('testUser', '$2b$12$WTEazAP0onu4q4ZX/saOIO8DdBFNHsXYix0PbbU0cBJ/zpz8R7/we', 'testuser@example.com', 'Test', 'User', 'Admin');
GO
