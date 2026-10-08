-- Arin Gadre: delay causes and day-of-week patterns
-- Source table: FlightReliabilityDB.CleanFlight
-- Dataset: BTS Reporting Carrier On-Time Performance, January 2026
-- DAY_OF_WEEK uses 1=Monday through 7=Sunday in this cleaned dataset.
-- For arrival-delay queries, cancellations/diversions and missing ARR_DELAY
-- are excluded. Cause columns are reported delay minutes, not causal proof;
-- NULL cause values are treated as zero only when totaling reported minutes.

USE FlightReliabilityDB;

-- BASIC 1: Are arrival delays more frequent on particular weekdays?
-- Reports operated flights with usable arrival delay, mean delay, and the
-- share arriving at least 15 minutes late.
SELECT
    DAY_OF_WEEK,
    CASE DAY_OF_WEEK
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
        WHEN 7 THEN 'Sunday'
    END AS weekday_name,
    COUNT(*) AS operated_flights,
    ROUND(AVG(ARR_DELAY), 2) AS avg_arrival_delay_min,
    ROUND(100.0 * SUM(ARR_DELAY >= 15) / COUNT(*), 2) AS pct_15min_late
FROM CleanFlight
WHERE CANCELLED = 0
  AND DIVERTED = 0
  AND ARR_DELAY IS NOT NULL
GROUP BY DAY_OF_WEEK
ORDER BY DAY_OF_WEEK;

-- BASIC 2: How many reported delay minutes are attributed to each cause
-- category on each weekday?
SELECT
    DAY_OF_WEEK,
    CASE DAY_OF_WEEK
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
        WHEN 7 THEN 'Sunday'
    END AS weekday_name,
    COUNT(*) AS operated_flights,
    SUM(COALESCE(CARRIER_DELAY, 0)) AS carrier_delay_min,
    SUM(COALESCE(WEATHER_DELAY, 0)) AS weather_delay_min,
    SUM(COALESCE(NAS_DELAY, 0)) AS nas_delay_min,
    SUM(COALESCE(SECURITY_DELAY, 0)) AS security_delay_min,
    SUM(COALESCE(LATE_AIRCRAFT_DELAY, 0)) AS late_aircraft_delay_min,
    SUM(COALESCE(CARRIER_DELAY, 0) + COALESCE(WEATHER_DELAY, 0)
      + COALESCE(NAS_DELAY, 0) + COALESCE(SECURITY_DELAY, 0)
      + COALESCE(LATE_AIRCRAFT_DELAY, 0)) AS total_reported_cause_min
FROM CleanFlight
WHERE CANCELLED = 0
  AND DIVERTED = 0
GROUP BY DAY_OF_WEEK
ORDER BY DAY_OF_WEEK;

-- ADVANCED 1: Which weekdays have a higher average arrival delay than the
-- overall operated-flight average? Uses CTEs to compare grouped and global
-- aggregates.
WITH operated_flights AS (
    SELECT DAY_OF_WEEK, ARR_DELAY
    FROM CleanFlight
    WHERE CANCELLED = 0
      AND DIVERTED = 0
      AND ARR_DELAY IS NOT NULL
),
weekday_averages AS (
    SELECT DAY_OF_WEEK, AVG(ARR_DELAY) AS avg_delay_min
    FROM operated_flights
    GROUP BY DAY_OF_WEEK
),
overall_average AS (
    SELECT AVG(ARR_DELAY) AS avg_delay_min
    FROM operated_flights
)
SELECT
    w.DAY_OF_WEEK,
    CASE w.DAY_OF_WEEK
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
        WHEN 7 THEN 'Sunday'
    END AS weekday_name,
    ROUND(w.avg_delay_min, 2) AS weekday_avg_delay_min,
    ROUND(o.avg_delay_min, 2) AS overall_avg_delay_min,
    ROUND(w.avg_delay_min - o.avg_delay_min, 2) AS difference_from_overall_min
FROM weekday_averages AS w
CROSS JOIN overall_average AS o
WHERE w.avg_delay_min > o.avg_delay_min
ORDER BY difference_from_overall_min DESC;

-- ADVANCED 2: What are the two largest reported delay causes by weekday?
-- UNION ALL reshapes the five cause columns into rows, then ROW_NUMBER ranks
-- causes independently within each weekday.
WITH cause_minutes AS (
    SELECT DAY_OF_WEEK, 'Carrier' AS cause, SUM(COALESCE(CARRIER_DELAY, 0)) AS minutes
    FROM CleanFlight WHERE CANCELLED = 0 AND DIVERTED = 0 GROUP BY DAY_OF_WEEK
    UNION ALL
    SELECT DAY_OF_WEEK, 'Weather', SUM(COALESCE(WEATHER_DELAY, 0))
    FROM CleanFlight WHERE CANCELLED = 0 AND DIVERTED = 0 GROUP BY DAY_OF_WEEK
    UNION ALL
    SELECT DAY_OF_WEEK, 'NAS', SUM(COALESCE(NAS_DELAY, 0))
    FROM CleanFlight WHERE CANCELLED = 0 AND DIVERTED = 0 GROUP BY DAY_OF_WEEK
    UNION ALL
    SELECT DAY_OF_WEEK, 'Security', SUM(COALESCE(SECURITY_DELAY, 0))
    FROM CleanFlight WHERE CANCELLED = 0 AND DIVERTED = 0 GROUP BY DAY_OF_WEEK
    UNION ALL
    SELECT DAY_OF_WEEK, 'Late aircraft', SUM(COALESCE(LATE_AIRCRAFT_DELAY, 0))
    FROM CleanFlight WHERE CANCELLED = 0 AND DIVERTED = 0 GROUP BY DAY_OF_WEEK
),
ranked_causes AS (
    SELECT
        DAY_OF_WEEK,
        cause,
        minutes,
        ROW_NUMBER() OVER (
            PARTITION BY DAY_OF_WEEK
            ORDER BY minutes DESC, cause
        ) AS cause_rank
    FROM cause_minutes
)
SELECT
    DAY_OF_WEEK,
    CASE DAY_OF_WEEK
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
        WHEN 7 THEN 'Sunday'
    END AS weekday_name,
    cause_rank,
    cause,
    minutes AS reported_delay_minutes
FROM ranked_causes
WHERE cause_rank <= 2
ORDER BY DAY_OF_WEEK, cause_rank;
