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
