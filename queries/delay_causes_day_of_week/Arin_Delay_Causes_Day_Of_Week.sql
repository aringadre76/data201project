-- Arin Gadre: delay causes and weekday patterns
-- DATA 201 Lectures 5-7: aggregation, HAVING, scalar/correlated subqueries.
-- Run in MySQL against FlightReliabilityDB.CleanFlight.
-- DAY_OF_WEEK: 1=Monday, ..., 7=Sunday. Results display means to 2 decimals.
-- SUM ignores unreported NULLs; totals are reported minutes, not causal proof.
USE FlightReliabilityDB;

-- BASIC 1: What is the average arrival delay for each weekday?
SELECT DAY_OF_WEEK AS day, AVG(ARR_DELAY) AS mean
FROM CleanFlight
WHERE CANCELLED=0 AND DIVERTED=0
  AND ARR_DELAY IS NOT NULL
GROUP BY DAY_OF_WEEK ORDER BY day;

-- BASIC 2: Which causes contribute the most reported minutes overall?
SELECT SUM(CARRIER_DELAY) AS carrier,
 SUM(LATE_AIRCRAFT_DELAY) AS late_aircraft,
 SUM(NAS_DELAY) AS nas, SUM(WEATHER_DELAY) AS weather,
 SUM(SECURITY_DELAY) AS security
FROM CleanFlight WHERE CANCELLED=0 AND DIVERTED=0;

-- ADVANCED 1: Which weekdays have mean arrival delays above the overall mean?
-- Scalar subquery in HAVING, following Lecture 7 Slides 30-33/43.
SELECT DAY_OF_WEEK AS day, AVG(ARR_DELAY) AS mean
FROM CleanFlight WHERE CANCELLED=0 AND DIVERTED=0
 AND ARR_DELAY IS NOT NULL GROUP BY DAY_OF_WEEK
HAVING AVG(ARR_DELAY) > (
 SELECT AVG(ARR_DELAY) FROM CleanFlight
 WHERE CANCELLED=0 AND DIVERTED=0
 AND ARR_DELAY IS NOT NULL)
ORDER BY mean DESC;

-- ADVANCED 2: On which weekdays do late-aircraft minutes exceed carrier minutes?
-- Correlated scalar subquery: compare totals for the SAME weekday.
-- Lecture 7 Slides 17/30-32 cover correlated aggregate subqueries.
SELECT f.DAY_OF_WEEK, SUM(f.LATE_AIRCRAFT_DELAY)
FROM CleanFlight f WHERE CANCELLED=0 AND DIVERTED=0
GROUP BY f.DAY_OF_WEEK
HAVING SUM(f.LATE_AIRCRAFT_DELAY) > (
 SELECT SUM(c.CARRIER_DELAY) FROM CleanFlight c
 WHERE c.DAY_OF_WEEK=f.DAY_OF_WEEK
 AND c.CANCELLED=0 AND c.DIVERTED=0)
ORDER BY f.DAY_OF_WEEK;
