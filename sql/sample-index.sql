-- Create an index on the DestinationName for faster searching
CREATE INDEX IX_DestinationName ON Destinations(DestinationName);

-- Create an index on the PackageName for faster searching
CREATE INDEX IX_PackageName ON VacationPackages(PackageName);
GO
