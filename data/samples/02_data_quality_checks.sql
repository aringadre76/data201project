USE FlightReliabilityDB;

-- Confirm total number of rows
SELECT COUNT(*) AS TotalRows
FROM RawFlight;

-- Check date range
SELECT
    MIN(FL_DATE) AS EarliestDate,
    MAX(FL_DATE) AS LatestDate
FROM RawFlight;

-- Count cancelled/diverted flights
SELECT
    SUM(CANCELLED = '1.00') AS CancelledFlights,
    SUM(DIVERTED = '1.00') AS DivertedFlights
FROM RawFlight;

-- Check important missing values
SELECT
    SUM(NULLIF(TRIM(TAIL_NUM), '') IS NULL) AS MissingTailNumber,
    SUM(NULLIF(TRIM(DEP_TIME), '') IS NULL) AS MissingDepartureTime,
    SUM(NULLIF(TRIM(ARR_TIME), '') IS NULL) AS MissingArrivalTime,
    SUM(NULLIF(TRIM(ARR_DELAY), '') IS NULL) AS MissingArrivalDelay,
    SUM(NULLIF(TRIM(CANCELLATION_CODE), '') IS NULL) AS MissingCancellationCode
FROM RawFlight;

-- Check possible duplicate flights
SELECT
    FL_DATE,
    OP_CARRIER_AIRLINE_ID,
    OP_CARRIER_FL_NUM,
    ORIGIN_AIRPORT_ID,
    DEST_AIRPORT_ID,
    COUNT(*) AS DuplicateCount
FROM RawFlight
GROUP BY
    FL_DATE,
    OP_CARRIER_AIRLINE_ID,
    OP_CARRIER_FL_NUM,
    ORIGIN_AIRPORT_ID,
    DEST_AIRPORT_ID
HAVING COUNT(*) > 1;

-- Check invalid scheduled flight durations
SELECT *
FROM RawFlight
WHERE CAST(NULLIF(CRS_ELAPSED_TIME, '') AS DECIMAL(10,2)) <= 0;

-- Check whether one airport ID has multiple airport codes
SELECT
    ORIGIN_AIRPORT_ID,
    COUNT(DISTINCT ORIGIN) AS CodeCount
FROM RawFlight
GROUP BY ORIGIN_AIRPORT_ID
HAVING COUNT(DISTINCT ORIGIN) > 1;