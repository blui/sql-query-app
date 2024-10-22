-- Example Query: Get All Bookings for a Specific Customer
SELECT 
    b.BookingID,
    p.PackageName,
    b.BookingDate,
    b.TotalCost,
    b.PaymentStatus
FROM 
    Bookings b
JOIN 
    VacationPackages p ON b.PackageID = p.PackageID
WHERE 
    b.CustomerID = 1;  -- Replace with the customer ID you want to query

--Example Query: Get Average Rating for a Vacation Package
SELECT 
    p.PackageName,
    AVG(r.Rating) AS AverageRating
FROM 
    Reviews r
JOIN 
    VacationPackages p ON r.PackageID = p.PackageID
WHERE 
    p.PackageID = 1  -- Replace with the package ID you want to query
GROUP BY 
    p.PackageName;

--Example Query: Get All Bookings for a Specific Travel Agent
SELECT 
    t.AgentName,
    p.PackageName,
    b.BookingDate,
    b.TotalCost
FROM 
    TravelAgents t
JOIN 
    VacationPackages p ON t.AgentID = p.TravelAgentID
JOIN 
    Bookings b ON p.PackageID = b.PackageID
WHERE 
    t.AgentID = 1;  -- Replace with the travel agent ID you want to query

--Example Query: Get the Most Popular Destinations by Bookings
SELECT 
    d.DestinationName,
    COUNT(b.BookingID) AS NumberOfBookings
FROM 
    Bookings b
JOIN 
    VacationPackages p ON b.PackageID = p.PackageID
JOIN 
    Destinations d ON p.DestinationID = d.DestinationID
GROUP BY 
    d.DestinationName
ORDER BY 
    NumberOfBookings DESC;

--Example Query: List Vacation Packages With Reviews
SELECT 
    p.PackageName,
    r.Rating,
    r.ReviewText,
    r.ReviewDate
FROM 
    VacationPackages p
JOIN 
    Reviews r ON p.PackageID = r.PackageID;
