SELECT 
    p.PackageName,
    d.DestinationName,
    c.CountryName,
    p.Price,
    p.DurationInDays,
    p.AccommodationType,
    p.StartDate,
    p.EndDate
FROM 
    VacationPackages p
JOIN 
    Destinations d ON p.DestinationID = d.DestinationID
JOIN 
    Countries c ON d.CountryID = c.CountryID;
GO
