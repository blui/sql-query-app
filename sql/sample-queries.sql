-- Get all vacation packages with their respective destination names and prices
SELECT 
    p.PackageName,
    d.DestinationName,
    p.Price,
    p.DurationInDays,
    p.AccommodationType
FROM 
    VacationDestinations.VacationPackages p
JOIN 
    VacationDestinations.Destinations d ON p.DestinationID = d.DestinationID;
GO

-- Find all destinations in a specific continent (e.g., Europe)
SELECT 
    d.DestinationName,
    c.CountryName,
    c.Continent
FROM 
    VacationDestinations.Destinations d
JOIN 
    VacationDestinations.Countries c ON d.CountryID = c.CountryID
WHERE 
    c.Continent = 'Europe';
GO

-- Retrieve average temperature for each destination type (e.g., Beach, Urban, Historical)
SELECT 
    AttractionType,
    AVG(AverageTemperature) AS AvgTemperature
FROM 
    VacationDestinations.Destinations
GROUP BY 
    AttractionType;
GO

-- Get all bookings made by a specific customer, including package name, booking date, and total cost
SELECT 
    b.BookingID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    p.PackageName,
    b.BookingDate,
    b.TotalCost,
    b.PaymentStatus
FROM 
    VacationDestinations.Bookings b
JOIN 
    VacationDestinations.Customers c ON b.CustomerID = c.CustomerID
JOIN 
    VacationDestinations.VacationPackages p ON b.PackageID = p.PackageID
WHERE 
    c.CustomerID = 1; -- Replace with the desired CustomerID
GO

-- Find the average rating and number of reviews for each vacation package
SELECT 
    p.PackageName,
    AVG(r.Rating) AS AvgRating,
    COUNT(r.ReviewID) AS NumberOfReviews
FROM 
    VacationDestinations.Reviews r
JOIN 
    VacationDestinations.VacationPackages p ON r.PackageID = p.PackageID
GROUP BY 
    p.PackageName;
GO

-- List all transportation options available at each destination with their prices
SELECT 
    d.DestinationName,
    t.Type AS TransportType,
    t.Provider,
    t.PricePerDay
FROM 
    VacationDestinations.Transportation t
JOIN 
    VacationDestinations.Destinations d ON t.DestinationID = d.DestinationID
ORDER BY 
    d.DestinationName;
GO

-- Find the most popular destinations based on the number of bookings
SELECT 
    d.DestinationName,
    COUNT(b.BookingID) AS NumberOfBookings
FROM 
    VacationDestinations.Bookings b
JOIN 
    VacationDestinations.VacationPackages p ON b.PackageID = p.PackageID
JOIN 
    VacationDestinations.Destinations d ON p.DestinationID = d.DestinationID
GROUP BY 
    d.DestinationName
ORDER BY 
    NumberOfBookings DESC;
GO

-- Retrieve all vacation packages along with the name of the travel agent responsible
SELECT 
    p.PackageName,
    d.DestinationName,
    a.AgentName AS TravelAgent
FROM 
    VacationDestinations.VacationPackages p
JOIN 
    VacationDestinations.Destinations d ON p.DestinationID = d.DestinationID
JOIN 
    VacationDestinations.TravelAgents a ON p.TravelAgentID = a.AgentID;
GO

-- Get all customers who have booked a specific package
SELECT 
    c.FirstName,
    c.LastName,
    p.PackageName,
    b.BookingDate,
    b.TotalCost
FROM 
    VacationDestinations.Bookings b
JOIN 
    VacationDestinations.Customers c ON b.CustomerID = c.CustomerID
JOIN 
    VacationDestinations.VacationPackages p ON b.PackageID = p.PackageID
WHERE 
    p.PackageID = 2; -- Replace with desired PackageID
GO

-- List all hotels available at each destination with their ratings and room prices
SELECT 
    h.HotelName,
    d.DestinationName,
    h.Rating,
    h.RoomPrice
FROM 
    VacationDestinations.Hotels h
JOIN 
    VacationDestinations.Destinations d ON h.DestinationID = d.DestinationID
ORDER BY 
    d.DestinationName;
GO

-- Find the highest-rated restaurant in each destination
SELECT 
    d.DestinationName,
    r.RestaurantName,
    r.CuisineType,
    r.Rating
FROM 
    VacationDestinations.Restaurants r
JOIN 
    VacationDestinations.Destinations d ON r.DestinationID = d.DestinationID
WHERE 
    r.Rating = (SELECT MAX(Rating) FROM VacationDestinations.Restaurants WHERE DestinationID = d.DestinationID)
ORDER BY 
    d.DestinationName;
GO

-- Get the average price of flights offered by each airline
SELECT 
    Airline,
    AVG(Price) AS AvgFlightPrice
FROM 
    VacationDestinations.Flights
GROUP BY 
    Airline
ORDER BY 
    AvgFlightPrice DESC;
GO

-- List all bookings that were canceled along with customer details
SELECT 
    c.FirstName,
    c.LastName,
    p.PackageName,
    b.BookingDate,
    b.TotalCost
FROM 
    VacationDestinations.Bookings b
JOIN 
    VacationDestinations.Customers c ON b.CustomerID = c.CustomerID
JOIN 
    VacationDestinations.VacationPackages p ON b.PackageID = p.PackageID
WHERE 
    b.PaymentStatus = 'Cancelled';
GO

-- Find the total revenue generated from all bookings per travel agent
SELECT 
    a.AgentName,
    SUM(b.TotalCost) AS TotalRevenue
FROM 
    VacationDestinations.Bookings b
JOIN 
    VacationDestinations.VacationPackages p ON b.PackageID = p.PackageID
JOIN 
    VacationDestinations.TravelAgents a ON p.TravelAgentID = a.AgentID
GROUP BY 
    a.AgentName
ORDER BY 
    TotalRevenue DESC;
GO

-- List all flights departing from a specific city along with their arrival destinations and prices
SELECT 
    Airline,
    ArrivalCity,
    Price
FROM 
    VacationDestinations.Flights
WHERE 
    DepartureCity = 'New York'; -- Replace with desired DepartureCity
GO

-- Retrieve the names and emails of customers who have given a rating of 5 for any package
SELECT 
    DISTINCT c.FirstName,
    c.LastName,
    c.Email
FROM 
    VacationDestinations.Reviews r
JOIN 
    VacationDestinations.Customers c ON r.CustomerID = c.CustomerID
WHERE 
    r.Rating = 5;
GO

-- Get the total number of restaurants available in each destination
SELECT 
    d.DestinationName,
    COUNT(r.RestaurantID) AS NumberOfRestaurants
FROM 
    VacationDestinations.Restaurants r
JOIN 
    VacationDestinations.Destinations d ON r.DestinationID = d.DestinationID
GROUP BY 
    d.DestinationName;
GO

-- List customers with their average spending on bookings
SELECT 
    c.FirstName,
    c.LastName,
    AVG(b.TotalCost) AS AvgSpending
FROM 
    VacationDestinations.Customers c
JOIN 
    VacationDestinations.Bookings b ON c.CustomerID = b.CustomerID
GROUP BY 
    c.FirstName,
    c.LastName;
GO

-- Retrieve all destinations with at least one package above $2000
SELECT 
    d.DestinationName,
    p.PackageName,
    p.Price
FROM 
    VacationDestinations.Destinations d
JOIN 
    VacationDestinations.VacationPackages p ON d.DestinationID = p.DestinationID
WHERE 
    p.Price > 2000
ORDER BY 
    d.DestinationName;
GO

-- List all transportation options for each destination with their daily cost
SELECT 
    d.DestinationName,
    t.Type AS TransportationType,
    t.Provider,
    t.PricePerDay
FROM 
    VacationDestinations.Transportation t
JOIN 
    VacationDestinations.Destinations d ON t.DestinationID = d.DestinationID
ORDER BY 
    d.DestinationName;
GO

-- Count the number of bookings per package and sort by popularity
SELECT 
    p.PackageName,
    COUNT(b.BookingID) AS NumberOfBookings
FROM 
    VacationDestinations.Bookings b
JOIN 
    VacationDestinations.VacationPackages p ON b.PackageID = p.PackageID
GROUP BY 
    p.PackageName
ORDER BY 
    NumberOfBookings DESC;
GO
