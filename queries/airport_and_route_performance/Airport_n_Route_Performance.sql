USE FlightReliabilityDB;


-- Basic Query 1: Airport arrival performance
SELECT
    dest.AirportCode AS airport,
    COUNT(*) AS total_flights,
    ROUND(AVG(f.ArrDelay), 2) AS average_arrival_delay,
    SUM(CASE WHEN f.ArrDelay > 15 THEN 1 ELSE 0 END) AS delayed_flights
FROM Flight AS f
JOIN Route AS r
    ON f.RouteID = r.RouteID
JOIN Airport AS dest
    ON r.DestinationAirportID = dest.AirportID
WHERE f.Cancelled = 0
  AND f.Diverted = 0
GROUP BY dest.AirportCode
ORDER BY average_arrival_delay ASC;


-- Basic Query 2: Route performance
SELECT
    origin.AirportCode AS ORIGIN,
    dest.AirportCode   AS DEST,
    COUNT(*) AS total_flights,
    ROUND(AVG(f.ArrDelay), 2) AS average_arrival_delay
FROM Flight AS f
JOIN Route AS r
    ON f.RouteID = r.RouteID
JOIN Airport AS origin
    ON r.OriginAirportID = origin.AirportID
JOIN Airport AS dest
    ON r.DestinationAirportID = dest.AirportID
WHERE f.Cancelled = 0
  AND f.Diverted = 0
GROUP BY origin.AirportCode, dest.AirportCode
ORDER BY average_arrival_delay DESC;


-- Advanced Query 1: Rank airports by overall performance
SELECT
    airport,
    total_flights,
    average_delay,
    on_time_percentage,
    RANK() OVER (ORDER BY on_time_percentage DESC, average_delay ASC) AS performance_rank
FROM (
    SELECT
        dest.AirportCode AS airport,
        COUNT(*) AS total_flights,
        ROUND(AVG(f.ArrDelay), 2) AS average_delay,
        ROUND(
            SUM(CASE WHEN f.ArrDelay <= 15 THEN 1 ELSE 0 END) * 100.0
            / NULLIF(COUNT(f.ArrDelay), 0),
            2
        ) AS on_time_percentage
    FROM Flight AS f
    JOIN Route AS r
        ON f.RouteID = r.RouteID
    JOIN Airport AS dest
        ON r.DestinationAirportID = dest.AirportID
    WHERE f.Cancelled = 0
      AND f.Diverted = 0
    GROUP BY dest.AirportCode
) AS airport_stats
WHERE total_flights >= 10
ORDER BY performance_rank;


-- Advanced Query 2: Find the most unreliable routes
SELECT
    origin.AirportCode AS ORIGIN,
    dest.AirportCode   AS DEST,
    COUNT(*) AS total_flights,
    ROUND(
        AVG(CASE WHEN f.Cancelled = 0 AND f.Diverted = 0 THEN f.ArrDelay END),
        2
    ) AS average_arrival_delay,
    ROUND(
        SUM(CASE WHEN f.Cancelled = 0 AND f.Diverted = 0 AND f.ArrDelay > 15
                 THEN 1 ELSE 0 END) * 100.0
        / NULLIF(
            COUNT(CASE WHEN f.Cancelled = 0 AND f.Diverted = 0
                        AND f.ArrDelay IS NOT NULL
                       THEN 1 END),
            0
        ),
        2
    ) AS delay_percentage,
    ROUND(
        SUM(CASE WHEN f.Cancelled = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS cancellation_percentage
FROM Flight AS f
JOIN Route AS r
    ON f.RouteID = r.RouteID
JOIN Airport AS origin
    ON r.OriginAirportID = origin.AirportID
JOIN Airport AS dest
    ON r.DestinationAirportID = dest.AirportID
GROUP BY origin.AirportCode, dest.AirportCode
HAVING COUNT(*) >= 2
ORDER BY delay_percentage DESC, cancellation_percentage DESC
LIMIT 10;