USE FlightReliabilityDB;

/*
Analysis Area: Airline delay and on-time performance

Research Question 1:
Which airlines have the highest average departure and arrival delays?

Research Question 2:
Which airlines have the highest percentage of flights arriving at least
15 minutes late?
*/


-- BASIC 1:
-- What are the average departure and arrival delays for each airline?

SELECT
    a.CarrierCode AS Airline,
    COUNT(*) AS CompletedFlights,
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


-- BASIC 2:
-- Which airlines have the highest percentage of flights
-- arriving at least 15 minutes late?

SELECT
    a.CarrierCode AS Airline,
    COUNT(*) AS CompletedFlights,
    SUM(f.ArrDel15 = 1) AS FlightsArrivingLate,
    ROUND(
        SUM(f.ArrDel15 = 1) * 100.0 / COUNT(*),
        2
    ) AS LateArrivalRate
FROM Flight AS f
JOIN Airline AS a
    ON f.AirlineID = a.AirlineID
WHERE f.Cancelled = 0
  AND f.Diverted = 0
GROUP BY a.CarrierCode
ORDER BY LateArrivalRate DESC;


-- ADVANCED 1:
-- Which airlines have an average arrival delay above
-- the overall average arrival delay?

SELECT
    a.CarrierCode AS Airline,
    COUNT(*) AS CompletedFlights,
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


-- ADVANCED 2:
-- Which airlines have a late-arrival rate above
-- the overall late-arrival rate?

SELECT
    a.CarrierCode AS Airline,
    COUNT(*) AS CompletedFlights,
    SUM(f.ArrDel15 = 1) AS FlightsArrivingLate,
    ROUND(
        SUM(f.ArrDel15 = 1) * 100.0 / COUNT(*),
        2
    ) AS LateArrivalRate
FROM Flight AS f
JOIN Airline AS a
    ON f.AirlineID = a.AirlineID
WHERE f.Cancelled = 0
  AND f.Diverted = 0
GROUP BY a.CarrierCode
HAVING
    SUM(f.ArrDel15 = 1) * 1.0 / COUNT(*) >
    (
        SELECT
            SUM(f2.ArrDel15 = 1) * 1.0 / COUNT(*)
        FROM Flight AS f2
        WHERE f2.Cancelled = 0
          AND f2.Diverted = 0
    )
ORDER BY LateArrivalRate DESC;