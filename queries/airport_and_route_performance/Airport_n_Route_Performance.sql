USE FlightReliabilityDB;


-- Basic Query 1: Airport arrival performance
SELECT
    DEST AS airport,
    COUNT(*) AS total_flights,
    ROUND(AVG(ARR_DELAY), 2) AS average_arrival_delay,
    SUM(CASE WHEN ARR_DELAY > 15 THEN 1 ELSE 0 END) 
        AS delayed_flights
FROM rawflight
WHERE CANCELLED = 0
  AND DIVERTED = 0
GROUP BY DEST
ORDER BY average_arrival_delay ASC;

-- Basic Query 2: Route performance
SELECT
    ORIGIN,
    DEST,
    COUNT(*) AS total_flights,
    ROUND(AVG(ARR_DELAY), 2) AS average_arrival_delay
FROM rawflight
WHERE CANCELLED = 0
  AND DIVERTED = 0
GROUP BY ORIGIN, DEST
ORDER BY average_arrival_delay DESC;

-- Advanced Query 1: Rank airports by overall performance
SELECT
    airport,
    total_flights,
    average_delay,
    on_time_percentage
FROM (
    SELECT
        DEST AS airport,
        COUNT(*) AS total_flights,
        ROUND(
            AVG(CAST(NULLIF(TRIM(ARR_DELAY), '') AS DECIMAL(10,2))),
            2
        ) AS average_delay,
        ROUND(
            SUM(
                CASE
                    WHEN CAST(NULLIF(TRIM(ARR_DELAY), '') AS DECIMAL(10,2)) <= 15
                    THEN 1 ELSE 0
                END
            ) * 100.0 / COUNT(
                NULLIF(TRIM(ARR_DELAY), '')
            ),
            2
        ) AS on_time_percentage
    FROM RawFlight
    WHERE CAST(NULLIF(TRIM(CANCELLED), '') AS DECIMAL(5,2)) = 0
      AND CAST(NULLIF(TRIM(DIVERTED), '') AS DECIMAL(5,2)) = 0
      AND NULLIF(TRIM(DEST), '') IS NOT NULL
    GROUP BY DEST
) AS airport_stats
WHERE total_flights >= 10
ORDER BY on_time_percentage DESC, average_delay ASC;


-- Advanced Query 2: Find the most unreliable routes
SELECT
    ORIGIN,
    DEST,
    COUNT(*) AS total_flights,
    ROUND(
        AVG(
            CASE
                WHEN CAST(NULLIF(TRIM(CANCELLED), '') AS DECIMAL(5,2)) = 0
                 AND CAST(NULLIF(TRIM(DIVERTED), '') AS DECIMAL(5,2)) = 0
                THEN CAST(NULLIF(TRIM(ARR_DELAY), '') AS DECIMAL(10,2))
            END
        ),
        2
    ) AS average_arrival_delay,
    ROUND(
        SUM(
            CASE
                WHEN CAST(NULLIF(TRIM(CANCELLED), '') AS DECIMAL(5,2)) = 0
                 AND CAST(NULLIF(TRIM(DIVERTED), '') AS DECIMAL(5,2)) = 0
                 AND CAST(NULLIF(TRIM(ARR_DELAY), '') AS DECIMAL(10,2)) > 15
                THEN 1 ELSE 0
            END
        ) * 100.0 /
        COUNT(
            CASE
                WHEN CAST(NULLIF(TRIM(CANCELLED), '') AS DECIMAL(5,2)) = 0
                 AND CAST(NULLIF(TRIM(DIVERTED), '') AS DECIMAL(5,2)) = 0
                 AND NULLIF(TRIM(ARR_DELAY), '') IS NOT NULL
                THEN 1
            END
        ),
        2
    ) AS delay_percentage,
    ROUND(
        SUM(
            CASE
                WHEN CAST(NULLIF(TRIM(CANCELLED), '') AS DECIMAL(5,2)) = 1 THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS cancellation_percentage
FROM RawFlight
WHERE NULLIF(TRIM(ORIGIN), '') IS NOT NULL
  AND NULLIF(TRIM(DEST), '') IS NOT NULL
GROUP BY ORIGIN, DEST
HAVING COUNT(*) >= 2
ORDER BY delay_percentage DESC, cancellation_percentage DESC
LIMIT 10;