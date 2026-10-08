-- Arin Gadre: delay causes and weekday patterns
-- DATA 201 Lectures 5-7: joins, aggregation, HAVING, scalar/correlated subqueries.
-- Run in MySQL against FlightReliabilityDB.Flight and CalendarDate.
-- DayOfWeek: 1=Monday, ..., 7=Sunday. Means display to 2 decimals on slides.
-- SUM ignores unreported NULLs; totals are reported minutes, not causal proof.
USE FlightReliabilityDB;

-- BASIC 1: What is the average arrival delay for each weekday?
SELECT d.DayOfWeek AS day, AVG(f.ArrDelay) AS mean
FROM Flight AS f
JOIN CalendarDate AS d ON f.FlightDate = d.FlightDate
WHERE f.Cancelled = 0 AND f.Diverted = 0
  AND f.ArrDelay IS NOT NULL
GROUP BY d.DayOfWeek
ORDER BY day;

-- BASIC 2: Which causes contribute the most reported minutes overall?
SELECT SUM(CarrierDelay) AS carrier,
       SUM(LateAircraftDelay) AS late_aircraft,
       SUM(NASDelay) AS nas, SUM(WeatherDelay) AS weather,
       SUM(SecurityDelay) AS security
FROM Flight
WHERE Cancelled = 0 AND Diverted = 0;

-- ADVANCED 1: Which weekdays have mean arrival delays above the overall mean?
-- Scalar subquery in HAVING, following Lecture 7 Slides 30-33/43.
SELECT d.DayOfWeek AS day, AVG(f.ArrDelay) AS mean
FROM Flight AS f
JOIN CalendarDate AS d ON f.FlightDate = d.FlightDate
WHERE f.Cancelled = 0 AND f.Diverted = 0
  AND f.ArrDelay IS NOT NULL
GROUP BY d.DayOfWeek
HAVING AVG(f.ArrDelay) > (
    SELECT AVG(ArrDelay) FROM Flight
    WHERE Cancelled = 0 AND Diverted = 0 AND ArrDelay IS NOT NULL
)
ORDER BY mean DESC;

-- ADVANCED 2: On which weekdays do late-aircraft minutes exceed carrier minutes?
-- Correlated scalar subquery: compare totals for the SAME weekday.
-- Lecture 7 Slides 17/30-32 cover correlated aggregate subqueries.
SELECT d.DayOfWeek AS day, SUM(f.LateAircraftDelay) AS late_aircraft
FROM Flight AS f
JOIN CalendarDate AS d ON f.FlightDate = d.FlightDate
WHERE f.Cancelled = 0 AND f.Diverted = 0
GROUP BY d.DayOfWeek
HAVING SUM(f.LateAircraftDelay) > (
    SELECT SUM(c.CarrierDelay)
    FROM Flight AS c
    JOIN CalendarDate AS cd ON c.FlightDate = cd.FlightDate
    WHERE cd.DayOfWeek = d.DayOfWeek
      AND c.Cancelled = 0 AND c.Diverted = 0
)
ORDER BY day;
