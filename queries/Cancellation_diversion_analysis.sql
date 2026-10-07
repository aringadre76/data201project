USE FlightReliabilityDB;

/*
Research Question 1:
How do cancellation and diversion rates differ across airlines?

Research Question 2:
Which origin airports have the highest cancellation and diversion rates?
*/


-- Basic Query 1: Cancellation and diversion rates by airline

SELECT
    OP_UNIQUE_CARRIER AS Airline,
    COUNT(*) AS TotalFlights,
    SUM(CANCELLED = 1) AS CancelledFlights,
    ROUND(SUM(CANCELLED = 1) * 100.0 / COUNT(*),2) AS CancellationRate,
    SUM(DIVERTED = 1) AS DivertedFlights,
    ROUND(SUM(DIVERTED = 1) * 100.0 / COUNT(*),2) AS DiversionRate
FROM CleanFlight
GROUP BY OP_UNIQUE_CARRIER
ORDER BY CancellationRate DESC;

-- Basic Query 2: Cancellation and diversion rates by origin airport

SELECT
    ORIGIN AS Airport,
    COUNT(*) AS TotalFlights,
    SUM(CANCELLED = 1) AS CancelledFlights,
    ROUND(SUM(CANCELLED = 1) * 100.0 / COUNT(*), 2) AS CancellationRate,
    SUM(DIVERTED = 1) AS DivertedFlights,
    ROUND(SUM(DIVERTED = 1) * 100.0 / COUNT(*),2) AS DiversionRate
FROM CleanFlight
GROUP BY ORIGIN
HAVING COUNT(*) >= 500
ORDER BY CancellationRate DESC
LIMIT 10;


-- Advanced Query 1: Airlines with cancellation rates above overall rate

SELECT
    OP_UNIQUE_CARRIER AS Airline,
    COUNT(*) AS TotalFlights,
    SUM(CANCELLED = 1) AS CancelledFlights,
    ROUND(SUM(CANCELLED = 1) * 100.0 / COUNT(*),2) AS CancellationRate
FROM CleanFlight
GROUP BY OP_UNIQUE_CARRIER
HAVING
    SUM(CANCELLED = 1) * 1.0 / COUNT(*) >
    (SELECT SUM(CANCELLED = 1) * 1.0 / COUNT(*)
	 FROM CleanFlight)
ORDER BY CancellationRate DESC;

-- Advanced Query 2: Airports above both overall cancellation and diversion rates
SELECT
    ORIGIN AS Airport,
    COUNT(*) AS TotalFlights,
    ROUND(SUM(CANCELLED = 1) * 100.0 / COUNT(*),2) AS CancellationRate,
    ROUND(SUM(DIVERTED = 1) * 100.0 / COUNT(*),2) AS DiversionRate
FROM CleanFlight
GROUP BY ORIGIN
HAVING
    COUNT(*) >= 500
    AND SUM(CANCELLED = 1) * 1.0 / COUNT(*) >
        (SELECT SUM(CANCELLED = 1) * 1.0 / COUNT(*)
		 FROM CleanFlight)
    AND SUM(DIVERTED = 1) * 1.0 / COUNT(*) >
        (SELECT
		 SUM(DIVERTED = 1) * 1.0 / COUNT(*)
		 FROM CleanFlight)
ORDER BY CancellationRate DESC;








