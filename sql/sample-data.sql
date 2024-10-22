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
