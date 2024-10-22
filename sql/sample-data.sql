-- Insert sample data into Countries
INSERT INTO Countries (CountryName, Continent, Currency)
VALUES 
('Italy', 'Europe', 'Euro'),
('Japan', 'Asia', 'Yen'),
('Brazil', 'South America', 'Brazilian Real'),
('Canada', 'North America', 'Canadian Dollar');
GO

-- Insert sample data into Destinations
INSERT INTO Destinations (DestinationName, Description, CountryID, AverageTemperature, AttractionType)
VALUES 
('Rome', 'The capital city of Italy, known for its rich history and architecture.', 1, 18.5, 'Historical'),
('Kyoto', 'Famous for its classical Buddhist temples and gardens.', 2, 15.2, 'Cultural'),
('Rio de Janeiro', 'Known for its beautiful beaches and the annual Carnival festival.', 3, 25.0, 'Beach'),
('Toronto', 'A bustling metropolis in Canada with a multicultural population.', 4, 10.5, 'Urban');
GO

-- Insert sample data into VacationPackages
INSERT INTO VacationPackages (PackageName, DestinationID, Price, DurationInDays, AccommodationType, StartDate, EndDate)
VALUES
('Rome Historical Tour', 1, 1500.00, 7, 'Hotel', '2024-05-01', '2024-05-08'),
('Kyoto Cultural Experience', 2, 2200.00, 10, 'Ryokan', '2024-04-10', '2024-04-20'),
('Rio Beach Getaway', 3, 1800.00, 5, 'Resort', '2024-07-15', '2024-07-20'),
('Toronto City Adventure', 4, 1000.00, 4, 'Hotel', '2024-06-05', '2024-06-09');
GO

-- Insert sample data into Customers
INSERT INTO Customers (FirstName, LastName, Email, Phone, DateOfBirth)
VALUES 
('John', 'Doe', 'john.doe@example.com', '123-456-7890', '1985-03-15'),
('Jane', 'Smith', 'jane.smith@example.com', '234-567-8901', '1990-06-22'),
('Mike', 'Johnson', 'mike.johnson@example.com', '345-678-9012', '1978-12-09'),
('Emily', 'Davis', 'emily.davis@example.com', '456-789-0123', '1992-04-10');
GO

-- Insert sample data into Bookings
INSERT INTO Bookings (CustomerID, PackageID, BookingDate, TotalCost, PaymentStatus)
VALUES 
(1, 1, '2024-02-10', 1500.00, 'Paid'),
(2, 2, '2024-03-05', 2200.00, 'Pending'),
(3, 3, '2024-06-25', 1800.00, 'Cancelled'),
(4, 4, '2024-05-10', 1000.00, 'Paid');
GO

-- Insert sample data into Reviews
INSERT INTO Reviews (CustomerID, PackageID, Rating, ReviewText, ReviewDate)
VALUES 
(1, 1, 5, 'Amazing experience! Highly recommend the Rome Historical Tour.', '2024-06-10'),
(2, 2, 4, 'Kyoto was beautiful, but the package was a bit expensive.', '2024-07-01'),
(4, 4, 3, 'Toronto is great, but the tour felt a bit rushed.', '2024-06-12');
GO

-- Insert sample data into TravelAgents
INSERT INTO TravelAgents (AgentName, ContactEmail, ContactPhone)
VALUES 
('Best Travel Co', 'info@besttravel.com', '111-222-3333'),
('Explore Adventures', 'contact@exploreadventures.com', '222-333-4444'),
('Global Tours', 'support@globaltours.com', '333-444-5555');
GO

-- Update VacationPackages with sample TravelAgentID
UPDATE VacationPackages
SET TravelAgentID = 1 WHERE PackageID = 1;
UPDATE VacationPackages
SET TravelAgentID = 2 WHERE PackageID = 2;
UPDATE VacationPackages
SET TravelAgentID = 3 WHERE PackageID = 3;
GO
