-- Create instructions go here

-- Create the Countries table
CREATE TABLE Countries (
    CountryID INT IDENTITY(1,1) PRIMARY KEY,
    CountryName NVARCHAR(100) NOT NULL,
    Continent NVARCHAR(50),
    Currency NVARCHAR(50)
);
GO

-- Create the Destinations table
CREATE TABLE Destinations (
    DestinationID INT IDENTITY(1,1) PRIMARY KEY,
    DestinationName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    CountryID INT NOT NULL,
    AverageTemperature DECIMAL(5,2),
    AttractionType NVARCHAR(100),
    FOREIGN KEY (CountryID) REFERENCES Countries(CountryID)
);
GO

-- Create the VacationPackages table
CREATE TABLE VacationPackages (
    PackageID INT IDENTITY(1,1) PRIMARY KEY,
    PackageName NVARCHAR(150) NOT NULL,
    DestinationID INT NOT NULL,
    Price DECIMAL(10,2),
    DurationInDays INT,
    AccommodationType NVARCHAR(100),
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (DestinationID) REFERENCES Destinations(DestinationID)
);
GO

-- Create the Customers table
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Phone NVARCHAR(20),
    DateOfBirth DATE
);
GO

-- Create the Bookings table
CREATE TABLE Bookings (
    BookingID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    PackageID INT NOT NULL,
    BookingDate DATE NOT NULL,
    TotalCost DECIMAL(10,2),
    PaymentStatus NVARCHAR(50) CHECK (PaymentStatus IN ('Pending', 'Paid', 'Cancelled')),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (PackageID) REFERENCES VacationPackages(PackageID)
);
GO

-- Create the Reviews table
CREATE TABLE Reviews (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    PackageID INT NOT NULL,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    ReviewText NVARCHAR(MAX),
    ReviewDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (PackageID) REFERENCES VacationPackages(PackageID)
);
GO

-- Create the TravelAgents table
CREATE TABLE TravelAgents (
    AgentID INT IDENTITY(1,1) PRIMARY KEY,
    AgentName NVARCHAR(100) NOT NULL,
    ContactEmail NVARCHAR(100) NOT NULL,
    ContactPhone NVARCHAR(20)
);
GO

-- Create the SavedQueries table
CREATE TABLE SavedQueries (
  id INT IDENTITY(1,1) PRIMARY KEY,
  queryName NVARCHAR(255) NOT NULL,
  queryText NVARCHAR(MAX) NOT NULL,
  createdAt DATETIME DEFAULT GETDATE()
);
GO

-- User Table: Stores user information with password hash for secure storage
CREATE TABLE Users (
    id INT PRIMARY KEY IDENTITY,
    username NVARCHAR(50) UNIQUE NOT NULL,
    password_hash NVARCHAR(255) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- Sessions Table: Tracks active sessions for users
CREATE TABLE Sessions (
    session_id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    user_id INT FOREIGN KEY REFERENCES Users(id) ON DELETE CASCADE,
    created_at DATETIME DEFAULT GETDATE(),
    expires_at DATETIME
);
GO

-- Optional: User Preferences Table to save individual user settings
CREATE TABLE UserPreferences (
    user_id INT FOREIGN KEY REFERENCES Users(id) ON DELETE CASCADE,
    theme NVARCHAR(50),
    default_query NVARCHAR(MAX)
);
GO

-- Alters instructions go here

-- Alter the Destinations table to add PopularityScore (e.g., based on bookings or reviews)
ALTER TABLE Destinations
ADD PopularityScore INT DEFAULT 0;
GO

-- Alter VacationPackages to add a TravelAgentID foreign key
ALTER TABLE VacationPackages
ADD TravelAgentID INT,
FOREIGN KEY (TravelAgentID) REFERENCES TravelAgents(AgentID);
GO

-- Alter SavedQueries to ensure user_id field is used to associate queries with specific users
ALTER TABLE SavedQueries
ADD user_id INT FOREIGN KEY REFERENCES Users(id) ON DELETE CASCADE;

-- Alter Users to add firstname, lastname, and role columns
ALTER TABLE Users
ADD firstName NVARCHAR(50),
    lastName NVARCHAR(50),
    role NVARCHAR(50);
