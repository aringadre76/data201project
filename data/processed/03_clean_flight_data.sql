USE FlightReliabilityDB;

-- Delete the old CleanFlight table if it already exists
DROP TABLE IF EXISTS CleanFlight;

-- Create a new table for the cleaned flight data
CREATE TABLE CleanFlight (
    FlightID BIGINT AUTO_INCREMENT PRIMARY KEY,
    DAY_OF_WEEK TINYINT,
    FL_DATE DATE,
    OP_UNIQUE_CARRIER VARCHAR(10),
    OP_CARRIER_AIRLINE_ID INT,
    OP_CARRIER_FL_NUM INT,
    TAIL_NUM VARCHAR(20),
    ORIGIN_AIRPORT_ID INT,
    ORIGIN VARCHAR(10),
    DEST_AIRPORT_ID INT,
    DEST VARCHAR(10),
    CRS_DEP_TIME SMALLINT,
    DEP_TIME SMALLINT,
    DEP_DELAY DECIMAL(10,2),
    CRS_ARR_TIME SMALLINT,
    ARR_TIME SMALLINT,
    ARR_DELAY DECIMAL(10,2),
    CANCELLED TINYINT,
    CANCELLATION_CODE VARCHAR(5),
    DIVERTED TINYINT,
    CRS_ELAPSED_TIME DECIMAL(10,2),
    ACTUAL_ELAPSED_TIME DECIMAL(10,2),
    AIR_TIME DECIMAL(10,2),
    DISTANCE DECIMAL(10,2),
    CARRIER_DELAY DECIMAL(10,2),
    WEATHER_DELAY DECIMAL(10,2),
    NAS_DELAY DECIMAL(10,2),
    SECURITY_DELAY DECIMAL(10,2),
    LATE_AIRCRAFT_DELAY DECIMAL(10,2)
);

-- Insert cleaned data from RawFlight
INSERT INTO CleanFlight (
    DAY_OF_WEEK,
    FL_DATE,
    OP_UNIQUE_CARRIER,
    OP_CARRIER_AIRLINE_ID,
    OP_CARRIER_FL_NUM,
    TAIL_NUM,
    ORIGIN_AIRPORT_ID,
    ORIGIN,
    DEST_AIRPORT_ID,
    DEST,
    CRS_DEP_TIME,
    DEP_TIME,
    DEP_DELAY,
    CRS_ARR_TIME,
    ARR_TIME,
    ARR_DELAY,
    CANCELLED,
    CANCELLATION_CODE,
    DIVERTED,
    CRS_ELAPSED_TIME,
    ACTUAL_ELAPSED_TIME,
    AIR_TIME,
    DISTANCE,
    CARRIER_DELAY,
    WEATHER_DELAY,
    NAS_DELAY,
    SECURITY_DELAY,
    LATE_AIRCRAFT_DELAY
)
SELECT
    CAST(NULLIF(TRIM(DAY_OF_WEEK), '') AS DECIMAL(10,2)),

    STR_TO_DATE(
        NULLIF(TRIM(FL_DATE), ''),
        '%m/%d/%Y %h:%i:%s %p'
    ),

    NULLIF(TRIM(OP_UNIQUE_CARRIER), ''),

    CAST(
        NULLIF(TRIM(OP_CARRIER_AIRLINE_ID), '')
        AS DECIMAL(10,2)
    ),

    CAST(
        NULLIF(TRIM(OP_CARRIER_FL_NUM), '')
        AS DECIMAL(10,2)
    ),

    NULLIF(TRIM(TAIL_NUM), ''),

    CAST(
        NULLIF(TRIM(ORIGIN_AIRPORT_ID), '')
        AS DECIMAL(10,2)
    ),

    NULLIF(TRIM(ORIGIN), ''),

    CAST(
        NULLIF(TRIM(DEST_AIRPORT_ID), '')
        AS DECIMAL(10,2)
    ),

    NULLIF(TRIM(DEST), ''),

    CAST(
        NULLIF(TRIM(CRS_DEP_TIME), '')
        AS DECIMAL(10,2)
    ),

    CAST(
        NULLIF(TRIM(DEP_TIME), '')
        AS DECIMAL(10,2)
    ),

    CAST(
        NULLIF(TRIM(DEP_DELAY), '')
        AS DECIMAL(10,2)
    ),

    CAST(
        NULLIF(TRIM(CRS_ARR_TIME), '')
        AS DECIMAL(10,2)
    ),

    CAST(
        NULLIF(TRIM(ARR_TIME), '')
        AS DECIMAL(10,2)
    ),

    CAST(
        NULLIF(TRIM(ARR_DELAY), '')
        AS DECIMAL(10,2)
    ),

    CAST(
        NULLIF(TRIM(CANCELLED), '')
        AS DECIMAL(10,2)
    ),

    NULLIF(TRIM(CANCELLATION_CODE), ''),

    CAST(
        NULLIF(TRIM(DIVERTED), '')
        AS DECIMAL(10,2)
    ),

    CASE
        WHEN CAST(
            NULLIF(TRIM(CRS_ELAPSED_TIME), '')
            AS DECIMAL(10,2)
        ) <= 0
        THEN NULL

        ELSE CAST(
            NULLIF(TRIM(CRS_ELAPSED_TIME), '')
            AS DECIMAL(10,2)
        )
    END,

    CAST(
        NULLIF(TRIM(ACTUAL_ELAPSED_TIME), '')
        AS DECIMAL(10,2)
    ),

    CAST(
        NULLIF(TRIM(AIR_TIME), '')
        AS DECIMAL(10,2)
    ),

    CAST(
        NULLIF(TRIM(DISTANCE), '')
        AS DECIMAL(10,2)
    ),

    CAST(
        NULLIF(TRIM(CARRIER_DELAY), '')
        AS DECIMAL(10,2)
    ),

    CAST(
        NULLIF(TRIM(WEATHER_DELAY), '')
        AS DECIMAL(10,2)
    ),

    CAST(
        NULLIF(TRIM(NAS_DELAY), '')
        AS DECIMAL(10,2)
    ),

    CAST(
        NULLIF(TRIM(SECURITY_DELAY), '')
        AS DECIMAL(10,2)
    ),

    CAST(
        NULLIF(TRIM(LATE_AIRCRAFT_DELAY), '')
        AS DECIMAL(10,2)
    )

FROM RawFlight;


-- Check the number of cleaned rows
SELECT COUNT(*) AS CleanRowCount
FROM CleanFlight;


-- Check the cleaned date range
SELECT
    MIN(FL_DATE) AS FirstDate,
    MAX(FL_DATE) AS LastDate
FROM CleanFlight;


-- Check cancelled and diverted flights
SELECT
    SUM(CANCELLED = 1) AS CancelledFlights,
    SUM(DIVERTED = 1) AS DivertedFlights
FROM CleanFlight;


-- Confirm that invalid scheduled durations were changed to NULL
SELECT COUNT(*) AS InvalidDurationCount
FROM CleanFlight
WHERE CRS_ELAPSED_TIME <= 0;