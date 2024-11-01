-- Create schema for the sample database
CREATE SCHEMA VacationDestinations;
GO

-- VacationDestinations tables

-- Countries table
CREATE TABLE Countries (
    CountryID INT IDENTITY(1,1) PRIMARY KEY,
    CountryName NVARCHAR(100) NOT NULL,
    Continent NVARCHAR(50),
    Currency NVARCHAR(50)
);
GO

-- TravelAgents table
CREATE TABLE TravelAgents (
    AgentID INT IDENTITY(1,1) PRIMARY KEY,
    AgentName NVARCHAR(100) NOT NULL,
    ContactEmail NVARCHAR(100) NOT NULL,
    ContactPhone NVARCHAR(20)
);
GO

-- Destinations table
CREATE TABLE Destinations (
    DestinationID INT IDENTITY(1,1) PRIMARY KEY,
    DestinationName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    CountryID INT NOT NULL,
    AverageTemperature DECIMAL(5,2),
    AttractionType NVARCHAR(100),
    PopularityScore INT DEFAULT 0,
    FOREIGN KEY (CountryID) REFERENCES Countries(CountryID)
);
GO

-- VacationPackages table
CREATE TABLE VacationPackages (
    PackageID INT IDENTITY(1,1) PRIMARY KEY,
    PackageName NVARCHAR(150) NOT NULL,
    DestinationID INT NOT NULL,
    Price DECIMAL(10,2),
    DurationInDays INT,
    AccommodationType NVARCHAR(100),
    StartDate DATE,
    EndDate DATE,
    TravelAgentID INT,
    FOREIGN KEY (DestinationID) REFERENCES Destinations(DestinationID),
    FOREIGN KEY (TravelAgentID) REFERENCES TravelAgents(AgentID)
);
GO

-- Customers table
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Phone NVARCHAR(20),
    DateOfBirth DATE
);
GO

-- Bookings table
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

-- Reviews table
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

-- Hotels table
CREATE TABLE Hotels (
    HotelID INT IDENTITY(1,1) PRIMARY KEY,
    HotelName NVARCHAR(100) NOT NULL,
    Location NVARCHAR(100),
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    RoomPrice DECIMAL(10,2),
    DestinationID INT,
    FOREIGN KEY (DestinationID) REFERENCES Destinations(DestinationID)
);
GO

-- Flights table
CREATE TABLE Flights (
    FlightID INT IDENTITY(1,1) PRIMARY KEY,
    Airline NVARCHAR(100) NOT NULL,
    DepartureCity NVARCHAR(100),
    ArrivalCity NVARCHAR(100),
    Price DECIMAL(10,2),
    TravelAgentID INT,
    FOREIGN KEY (TravelAgentID) REFERENCES TravelAgents(AgentID)
);
GO

-- Transportation table
CREATE TABLE Transportation (
    TransportID INT IDENTITY(1,1) PRIMARY KEY,
    Type NVARCHAR(50) NOT NULL, -- (e.g., Car Rental, Bus, Shuttle)
    Provider NVARCHAR(100) NOT NULL,
    DestinationID INT NOT NULL,
    PricePerDay DECIMAL(10,2),
    FOREIGN KEY (DestinationID) REFERENCES Destinations(DestinationID)
);
GO

-- Restaurants table
CREATE TABLE Restaurants (
    RestaurantID INT IDENTITY(1,1) PRIMARY KEY,
    RestaurantName NVARCHAR(100) NOT NULL,
    CuisineType NVARCHAR(50),
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    AverageCost DECIMAL(10,2),
    DestinationID INT,
    FOREIGN KEY (DestinationID) REFERENCES Destinations(DestinationID)
);
GO

-- Sample data for VacationDestinations schema

-- Countries
INSERT INTO Countries (CountryName, Continent, Currency)
VALUES 
('Italy', 'Europe', 'Euro'),
('Japan', 'Asia', 'Yen'),
('Brazil', 'South America', 'Brazilian Real'),
('Canada', 'North America', 'Canadian Dollar'),
('Australia', 'Oceania', 'Australian Dollar');
GO

-- TravelAgents
INSERT INTO TravelAgents (AgentName, ContactEmail, ContactPhone)
VALUES 
('Best Travel Co', 'info@besttravel.com', '111-222-3333'),
('Explore Adventures', 'contact@exploreadventures.com', '222-333-4444'),
('Global Tours', 'support@globaltours.com', '333-444-5555');
GO

-- Destinations
INSERT INTO Destinations (DestinationName, Description, CountryID, AverageTemperature, AttractionType)
VALUES 
('Rome', 'The capital city of Italy, known for its rich history and architecture.', 1, 18.5, 'Historical'),
('Kyoto', 'Famous for its classical Buddhist temples and gardens.', 2, 15.2, 'Cultural'),
('Rio de Janeiro', 'Known for its beautiful beaches and the annual Carnival festival.', 3, 25.0, 'Beach'),
('Toronto', 'A bustling metropolis in Canada with a multicultural population.', 4, 10.5, 'Urban'),
('Sydney', 'Australia’s largest city, famous for the Opera House and Bondi Beach.', 5, 20.1, 'Urban');
GO

-- VacationPackages
INSERT INTO VacationPackages (PackageName, DestinationID, Price, DurationInDays, AccommodationType, StartDate, EndDate, TravelAgentID)
VALUES
('Rome Historical Tour', 1, 1500.00, 7, 'Hotel', '2024-05-01', '2024-05-08', 1),
('Kyoto Cultural Experience', 2, 2200.00, 10, 'Ryokan', '2024-04-10', '2024-04-20', 2),
('Rio Beach Getaway', 3, 1800.00, 5, 'Resort', '2024-07-15', '2024-07-20', 3),
('Toronto City Adventure', 4, 1000.00, 4, 'Hotel', '2024-06-05', '2024-06-09', 1),
('Sydney Outdoor Exploration', 5, 2500.00, 8, 'Resort', '2024-09-12', '2024-09-20', 2);
GO

-- Customers
INSERT INTO Customers (FirstName, LastName, Email, Phone, DateOfBirth)
VALUES 
('John', 'Doe', 'john.doe@example.com', '123-456-7890', '1985-03-15'),
('Jane', 'Smith', 'jane.smith@example.com', '234-567-8901', '1990-06-22'),
('Mike', 'Johnson', 'mike.johnson@example.com', '345-678-9012', '1978-12-09'),
('Emily', 'Davis', 'emily.davis@example.com', '456-789-0123', '1992-04-10'),
('Sarah', 'Brown', 'sarah.brown@example.com', '567-890-1234', '1989-11-15');
GO

-- Bookings
INSERT INTO Bookings (CustomerID, PackageID, BookingDate, TotalCost, PaymentStatus)
VALUES 
(1, 1, '2024-02-10', 1500.00, 'Paid'),
(2, 2, '2024-03-05', 2200.00, 'Pending'),
(3, 3, '2024-06-25', 1800.00, 'Cancelled'),
(4, 4, '2024-05-10', 1000.00, 'Paid'),
(5, 5, '2024-08-12', 2500.00, 'Paid');
GO

-- Reviews
INSERT INTO Reviews (CustomerID, PackageID, Rating, ReviewText, ReviewDate)
VALUES 
(1, 1, 5, 'Amazing experience! Highly recommend the Rome Historical Tour.', '2024-06-10'),
(2, 2, 4, 'Kyoto was beautiful, but the package was a bit expensive.', '2024-07-01'),
(3, 3, 2, 'Disappointed with the Rio beach package; it wasn’t well organized.', '2024-08-20'),
(4, 4, 3, 'Toronto is great, but the tour felt a bit rushed.', '2024-06-12'),
(5, 5, 5, 'Sydney Outdoor Exploration was fantastic! Loved every moment.', '2024-10-01');
GO

-- Hotels
INSERT INTO Hotels (HotelName, Location, Rating, RoomPrice, DestinationID)
VALUES
('The Grand Rome', 'Rome', 5, 150.00, 1),
('Kyoto Ryokan', 'Kyoto', 4, 120.00, 2),
('Rio Beach Resort', 'Rio de Janeiro', 4, 200.00, 3),
('Toronto Suites', 'Toronto', 3, 100.00, 4),
('Sydney Sun Hotel', 'Sydney', 5, 180.00, 5);
GO

-- Flights
INSERT INTO Flights (Airline, DepartureCity, ArrivalCity, Price, TravelAgentID)
VALUES
('Delta Airlines', 'New York', 'Rome', 600.00, 1),
('Japan Airlines', 'Los Angeles', 'Kyoto', 700.00, 2),
('LATAM', 'Miami', 'Rio de Janeiro', 500.00, 3),
('Air Canada', 'Toronto', 'Sydney', 1200.00, 2),
('Qantas', 'Sydney', 'Toronto', 1100.00, 1);
GO

-- Transportation
INSERT INTO Transportation (Type, Provider, DestinationID, PricePerDay)
VALUES
('Car Rental', 'Hertz', 1, 50.00),
('Shuttle', 'Kyoto Shuttle Services', 2, 30.00),
('Car Rental', 'Rio Rentals', 3, 60.00),
('Bike Rental', 'Toronto Bikes', 4, 15.00),
('Car Rental', 'Sydney Drives', 5, 55.00);
GO

-- Restaurants
INSERT INTO Restaurants (RestaurantName, CuisineType, Rating, AverageCost, DestinationID)
VALUES
('Trattoria da Luigi', 'Italian', 5, 25.00, 1),
('Sakura Bistro', 'Japanese', 4, 30.00, 2),
('Carnival Delights', 'Brazilian', 4, 20.00, 3),
('Maple Leaf Grill', 'Canadian', 3, 15.00, 4),
('Sydney Sizzlers', 'Australian', 5, 35.00, 5);
GO
