USE FlightReliabilityDB;

-- 1. Count imported rows
SELECT COUNT(*) AS TotalRows
FROM RawFlight;


-- 2. Check the actual date range
SELECT
    MIN(STR_TO_DATE(FL_DATE, '%m/%d/%Y %h:%i:%s %p')) AS EarliestDate,
    MAX(STR_TO_DATE(FL_DATE, '%m/%d/%Y %h:%i:%s %p')) AS LatestDate
FROM RawFlight;


-- 3. Count cancelled and diverted flights
SELECT
    SUM(CAST(NULLIF(CANCELLED, '') AS DECIMAL(5,2)) = 1) AS CancelledFlights,
    SUM(CAST(NULLIF(DIVERTED, '') AS DECIMAL(5,2)) = 1) AS DivertedFlights
FROM RawFlight;


-- 4. Check important missing values
SELECT
    SUM(NULLIF(TRIM(TAIL_NUM), '') IS NULL) AS MissingTailNumber,
    SUM(NULLIF(TRIM(DEP_TIME), '') IS NULL) AS MissingDepartureTime,
    SUM(NULLIF(TRIM(ARR_TIME), '') IS NULL) AS MissingArrivalTime,
    SUM(NULLIF(TRIM(ARR_DELAY), '') IS NULL) AS MissingArrivalDelay,
    SUM(NULLIF(TRIM(CANCELLATION_CODE), '') IS NULL) AS MissingCancellationCode
FROM RawFlight;


-- 5. Check whether cancelled flights explain missing times
SELECT
    CANCELLED,
    COUNT(*) AS FlightCount,
    SUM(NULLIF(TRIM(DEP_TIME), '') IS NULL) AS MissingDepartureTime,
    SUM(NULLIF(TRIM(ARR_TIME), '') IS NULL) AS MissingArrivalTime,
    SUM(NULLIF(TRIM(ARR_DELAY), '') IS NULL) AS MissingArrivalDelay
FROM RawFlight
GROUP BY CANCELLED;


-- 6. Check possible duplicate flights
SELECT
    FL_DATE,
    OP_CARRIER_AIRLINE_ID,
    OP_CARRIER_FL_NUM,
    ORIGIN_AIRPORT_ID,
    DEST_AIRPORT_ID,
    CRS_DEP_TIME,
    COUNT(*) AS DuplicateCount
FROM RawFlight
GROUP BY
    FL_DATE,
    OP_CARRIER_AIRLINE_ID,
    OP_CARRIER_FL_NUM,
    ORIGIN_AIRPORT_ID,
    DEST_AIRPORT_ID,
    CRS_DEP_TIME
HAVING COUNT(*) > 1;


-- 7. Count invalid scheduled durations
SELECT COUNT(*) AS InvalidDurationCount
FROM RawFlight
WHERE CAST(NULLIF(TRIM(CRS_ELAPSED_TIME), '') AS DECIMAL(10,2)) <= 0;


-- 8. Display invalid scheduled-duration records
SELECT
    FL_DATE,
    OP_UNIQUE_CARRIER,
    OP_CARRIER_FL_NUM,
    ORIGIN,
    DEST,
    CRS_DEP_TIME,
    CRS_ARR_TIME,
    CRS_ELAPSED_TIME
FROM RawFlight
WHERE CAST(NULLIF(TRIM(CRS_ELAPSED_TIME), '') AS DECIMAL(10,2)) <= 0;


-- 9. Check airport ID-to-code consistency
SELECT
    ORIGIN_AIRPORT_ID,
    COUNT(DISTINCT ORIGIN) AS CodeCount
FROM RawFlight
GROUP BY ORIGIN_AIRPORT_ID
HAVING COUNT(DISTINCT ORIGIN) > 1;
