USE FlightReliabilityDB;

/*
Research Question 1:
Which airlines have the highest average departure and arrival delays?

Research Question 2:
Which airlines have the highest percentage of flights arriving at least
15 minutes late?
*/


-- Basic Query 1: Average departure delays and arrival delays by airline

SELECT
    a.CarrierCode AS Airline,
    COUNT(*) AS TotalFlights,
    AVG(f.DepDelay) AS AverageDepartureDelay,
    AVG(f.ArrDelay) AS AverageArrivalDelay
FROM Flight AS f
JOIN Airline AS a
    ON f.AirlineID = a.AirlineID
WHERE f.Cancelled = 0
  AND f.Diverted = 0
  AND f.ArrDelay IS NOT NULL
GROUP BY a.CarrierCode
ORDER BY AverageArrivalDelay DESC;


-- Basic Query 2: Percentage of late arrivals by airline

SELECT
    a.CarrierCode AS Airline,
    COUNT(*) AS TotalFlights,
    SUM(f.ArrDelay >= 15) AS FlightsArrivingLate,
    ROUND(
        SUM(f.ArrDelay >= 15) * 100.0 / COUNT(*),
        2
    ) AS LateArrivalRate
FROM Flight AS f
JOIN Airline AS a
    ON f.AirlineID = a.AirlineID
WHERE f.Cancelled = 0
  AND f.Diverted = 0
  AND f.ArrDelay IS NOT NULL
GROUP BY a.CarrierCode
ORDER BY LateArrivalRate DESC;


-- Advanced Query 1: Airlines above the overall average arrival delay

SELECT
    a.CarrierCode AS Airline,
    COUNT(*) AS TotalFlights,
    AVG(f.ArrDelay) AS AverageArrivalDelay
FROM Flight AS f
JOIN Airline AS a
    ON f.AirlineID = a.AirlineID
WHERE f.Cancelled = 0
  AND f.Diverted = 0
  AND f.ArrDelay IS NOT NULL
GROUP BY a.CarrierCode
HAVING AVG(f.ArrDelay) > (
    SELECT AVG(f2.ArrDelay)
    FROM Flight AS f2
    WHERE f2.Cancelled = 0
      AND f2.Diverted = 0
      AND f2.ArrDelay IS NOT NULL
)
ORDER BY AverageArrivalDelay DESC;


-- Advanced Query 2: Airlines above the overall late-arrival rate

SELECT
    a.CarrierCode AS Airline,
    COUNT(*) AS TotalFlights,
    SUM(f.ArrDelay >= 15) AS FlightsArrivingLate,
    ROUND(SUM(f.ArrDelay >= 15) * 100.0 / COUNT(*), 2) AS LateArrivalRate
FROM Flight AS f
JOIN Airline AS a ON f.AirlineID = a.AirlineID
WHERE f.Cancelled = 0 AND f.Diverted = 0 AND f.ArrDelay IS NOT NULL
GROUP BY a.CarrierCode
HAVING
    SUM(f.ArrDelay >= 15) * 1.0 / COUNT(*) >
    (
        SELECT
            SUM(f2.ArrDelay >= 15) * 1.0 / COUNT(*)
        FROM Flight AS f2
        WHERE f2.Cancelled = 0 AND f2.Diverted = 0 AND f2.ArrDelay IS NOT NULL
    )
ORDER BY LateArrivalRate DESC;