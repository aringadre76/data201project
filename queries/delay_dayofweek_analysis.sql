-- Basic Query 1: Total delay minutes by cause
USE FlightReliabilityDB;

SELECT
    ROUND(SUM(COALESCE(CAST(NULLIF(TRIM(CARRIER_DELAY), '') AS DECIMAL(10,2)), 0)), 2)
        AS CarrierDelayMinutes,
    ROUND(SUM(COALESCE(CAST(NULLIF(TRIM(WEATHER_DELAY), '') AS DECIMAL(10,2)), 0)), 2)
        AS WeatherDelayMinutes,
    ROUND(SUM(COALESCE(CAST(NULLIF(TRIM(NAS_DELAY), '') AS DECIMAL(10,2)), 0)), 2)
        AS NASDelayMinutes,
    ROUND(SUM(COALESCE(CAST(NULLIF(TRIM(SECURITY_DELAY), '') AS DECIMAL(10,2)), 0)), 2)
        AS SecurityDelayMinutes,
    ROUND(SUM(COALESCE(CAST(NULLIF(TRIM(LATE_AIRCRAFT_DELAY), '') AS DECIMAL(10,2)), 0)), 2)
        AS LateAircraftDelayMinutes
FROM RawFlight
WHERE TRIM(CANCELLED) = '0.00';

-- Basic query 2: Delays by day of week
SELECT
    CAST(NULLIF(TRIM(DAY_OF_WEEK), '') AS UNSIGNED) AS DayOfWeek,
    COUNT(*) AS CompletedFlights,
    ROUND(AVG(
        CAST(NULLIF(TRIM(DEP_DELAY), '') AS DECIMAL(10,2))
    ), 2) AS AverageDepartureDelay,
    ROUND(AVG(
        CAST(NULLIF(TRIM(ARR_DELAY), '') AS DECIMAL(10,2))
    ), 2) AS AverageArrivalDelay,
    ROUND(100 * AVG(
        CAST(NULLIF(TRIM(ARR_DEL15), '') AS DECIMAL(10,2))
    ), 2) AS PercentArrivingAtLeast15MinutesLate
FROM RawFlight
WHERE TRIM(CANCELLED) = '0.00'
  AND NULLIF(TRIM(ARR_DELAY), '') IS NOT NULL
GROUP BY CAST(NULLIF(TRIM(DAY_OF_WEEK), '') AS UNSIGNED)
ORDER BY DayOfWeek;

-- Advanced query 1: Rank days by average arrival delay
WITH DailyPerformance AS (
    SELECT
        CAST(NULLIF(TRIM(DAY_OF_WEEK), '') AS UNSIGNED) AS DayOfWeek,
        COUNT(*) AS CompletedFlights,
        AVG(
            CAST(NULLIF(TRIM(ARR_DELAY), '') AS DECIMAL(10,2))
        ) AS AverageArrivalDelay,
        AVG(
            CAST(NULLIF(TRIM(ARR_DEL15), '') AS DECIMAL(10,2))
        ) * 100 AS LatePercentage
    FROM RawFlight
    WHERE TRIM(CANCELLED) = '0.00'
      AND NULLIF(TRIM(ARR_DELAY), '') IS NOT NULL
    GROUP BY CAST(NULLIF(TRIM(DAY_OF_WEEK), '') AS UNSIGNED)
)
SELECT
    DayOfWeek,
    CompletedFlights,
    ROUND(AverageArrivalDelay, 2) AS AverageArrivalDelay,
    ROUND(LatePercentage, 2) AS LatePercentage,
    RANK() OVER (
        ORDER BY AverageArrivalDelay DESC
    ) AS DelayRank
FROM DailyPerformance
ORDER BY DelayRank;

-- Advanced query 2: Compare delay causes by day of week
SELECT
    CAST(NULLIF(TRIM(DAY_OF_WEEK), '') AS UNSIGNED) AS DayOfWeek,

    ROUND(SUM(
        COALESCE(CAST(NULLIF(TRIM(CARRIER_DELAY), '') AS DECIMAL(10,2)), 0)
    ), 2) AS CarrierDelayMinutes,

    ROUND(SUM(
        COALESCE(CAST(NULLIF(TRIM(WEATHER_DELAY), '') AS DECIMAL(10,2)), 0)
    ), 2) AS WeatherDelayMinutes,

    ROUND(SUM(
        COALESCE(CAST(NULLIF(TRIM(NAS_DELAY), '') AS DECIMAL(10,2)), 0)
    ), 2) AS NASDelayMinutes,

    ROUND(SUM(
        COALESCE(CAST(NULLIF(TRIM(SECURITY_DELAY), '') AS DECIMAL(10,2)), 0)
    ), 2) AS SecurityDelayMinutes,

    ROUND(SUM(
        COALESCE(CAST(NULLIF(TRIM(LATE_AIRCRAFT_DELAY), '') AS DECIMAL(10,2)), 0)
    ), 2) AS LateAircraftDelayMinutes

FROM RawFlight
WHERE TRIM(CANCELLED) = '0.00'
GROUP BY CAST(NULLIF(TRIM(DAY_OF_WEEK), '') AS UNSIGNED)
ORDER BY DayOfWeek;
