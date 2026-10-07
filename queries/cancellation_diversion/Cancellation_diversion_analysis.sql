USE FlightReliabilityDB;

/*
Research Question 1:
How do cancellation and diversion rates differ across airlines?

Research Question 2:
Which origin airports have the highest cancellation and diversion rates?
*/


-- Basic Query 1: Cancellation and diversion rates by airline

SELECT
    a.CarrierCode AS Airline,
    COUNT(*) AS TotalFlights,
    SUM(f.Cancelled = 1) AS CancelledFlights,
    ROUND(SUM(f.Cancelled = 1) * 100.0 / COUNT(*), 2) AS CancellationRate,
    SUM(f.Diverted = 1) AS DivertedFlights,
    ROUND(SUM(f.Diverted = 1) * 100.0 / COUNT(*), 2) AS DiversionRate
FROM Flight AS f
JOIN Airline AS a
    ON f.AirlineID = a.AirlineID
GROUP BY a.CarrierCode
ORDER BY CancellationRate DESC;


-- Basic Query 2: Cancellation and diversion rates by origin airport

SELECT
    origin.AirportCode AS Airport,
    COUNT(*) AS TotalFlights,
    SUM(f.Cancelled = 1) AS CancelledFlights,
    ROUND(SUM(f.Cancelled = 1) * 100.0 / COUNT(*), 2) AS CancellationRate,
    SUM(f.Diverted = 1) AS DivertedFlights,
    ROUND(SUM(f.Diverted = 1) * 100.0 / COUNT(*), 2) AS DiversionRate
FROM Flight AS f
JOIN Route AS r
    ON f.RouteID = r.RouteID
JOIN Airport AS origin
    ON r.OriginAirportID = origin.AirportID
GROUP BY origin.AirportCode
HAVING COUNT(*) >= 500
ORDER BY CancellationRate DESC
LIMIT 10;


-- Advanced Query 1: Airlines with cancellation rates above overall rate

SELECT
    a.CarrierCode AS Airline,
    COUNT(*) AS TotalFlights,
    SUM(f.Cancelled = 1) AS CancelledFlights,
    ROUND(SUM(f.Cancelled = 1) * 100.0 / COUNT(*), 2) AS CancellationRate
FROM Flight AS f
JOIN Airline AS a
    ON f.AirlineID = a.AirlineID
GROUP BY a.CarrierCode
HAVING
    SUM(f.Cancelled = 1) * 1.0 / COUNT(*) >
    (SELECT SUM(f2.Cancelled = 1) * 1.0 / COUNT(*)
	 FROM Flight AS f2)
ORDER BY CancellationRate DESC;


-- Advanced Query 2: Airports above both overall cancellation and diversion rates

SELECT
    origin.AirportCode AS Airport,
    COUNT(*) AS TotalFlights,
    ROUND(SUM(f.Cancelled = 1) * 100.0 / COUNT(*), 2) AS CancellationRate,
    ROUND(SUM(f.Diverted = 1) * 100.0 / COUNT(*), 2) AS DiversionRate
FROM Flight AS f
JOIN Route AS r
    ON f.RouteID = r.RouteID
JOIN Airport AS origin
    ON r.OriginAirportID = origin.AirportID
GROUP BY origin.AirportCode
HAVING
    COUNT(*) >= 500
    AND SUM(f.Cancelled = 1) * 1.0 / COUNT(*) >
        (SELECT SUM(f2.Cancelled = 1) * 1.0 / COUNT(*)
		 FROM Flight AS f2)
    AND SUM(f.Diverted = 1) * 1.0 / COUNT(*) >
        (SELECT SUM(f3.Diverted = 1) * 1.0 / COUNT(*)
		 FROM Flight AS f3)
ORDER BY CancellationRate DESC;
