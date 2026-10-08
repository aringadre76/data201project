USE FlightReliabilityDB;


DROP TABLE IF EXISTS Flight;
DROP TABLE IF EXISTS Route;
DROP TABLE IF EXISTS CalendarDate;
DROP TABLE IF EXISTS Airport;
DROP TABLE IF EXISTS Airline;


-- 1. Airline table
CREATE TABLE Airline (
    AirlineID INT PRIMARY KEY,
    CarrierCode VARCHAR(10) NOT NULL UNIQUE
);


-- 2. Airport table
CREATE TABLE Airport (
    AirportID INT PRIMARY KEY,
    AirportCode VARCHAR(10) NOT NULL UNIQUE
);


-- 3. Calendar date table
CREATE TABLE CalendarDate (
    FlightDate DATE PRIMARY KEY,
    DayOfWeek TINYINT NOT NULL
);


-- 4. Route table
CREATE TABLE Route (
    RouteID INT AUTO_INCREMENT PRIMARY KEY,
    OriginAirportID INT NOT NULL,
    DestinationAirportID INT NOT NULL,
    Distance DECIMAL(10,2),

    UNIQUE (
        OriginAirportID,
        DestinationAirportID
    ),

    FOREIGN KEY (OriginAirportID)
        REFERENCES Airport(AirportID),

    FOREIGN KEY (DestinationAirportID)
        REFERENCES Airport(AirportID)
);


-- 5. Flight table
CREATE TABLE Flight (
    FlightID BIGINT PRIMARY KEY,
    FlightDate DATE NOT NULL,
    AirlineID INT NOT NULL,
    RouteID INT NOT NULL,
    FlightNumber INT,
    TailNumber VARCHAR(20),

    CRSDepTime SMALLINT,
    DepTime SMALLINT,
    DepDelay DECIMAL(10,2),

    CRSArrTime SMALLINT,
    ArrTime SMALLINT,
    ArrDelay DECIMAL(10,2),

    Cancelled TINYINT,
    CancellationCode VARCHAR(5),
    Diverted TINYINT,

    CRSElapsedTime DECIMAL(10,2),
    ActualElapsedTime DECIMAL(10,2),
    AirTime DECIMAL(10,2),

    CarrierDelay DECIMAL(10,2),
    WeatherDelay DECIMAL(10,2),
    NASDelay DECIMAL(10,2),
    SecurityDelay DECIMAL(10,2),
    LateAircraftDelay DECIMAL(10,2),

    FOREIGN KEY (FlightDate)
        REFERENCES CalendarDate(FlightDate),

    FOREIGN KEY (AirlineID)
        REFERENCES Airline(AirlineID),

    FOREIGN KEY (RouteID)
        REFERENCES Route(RouteID)
);


-- Insert airline records
INSERT INTO Airline (
    AirlineID,
    CarrierCode
)
SELECT DISTINCT
    OP_CARRIER_AIRLINE_ID,
    OP_UNIQUE_CARRIER
FROM CleanFlight
WHERE OP_CARRIER_AIRLINE_ID IS NOT NULL
  AND OP_UNIQUE_CARRIER IS NOT NULL;


-- Insert airport records from both origin and destination columns
INSERT INTO Airport (
    AirportID,
    AirportCode
)
SELECT
    ORIGIN_AIRPORT_ID,
    ORIGIN
FROM CleanFlight
WHERE ORIGIN_AIRPORT_ID IS NOT NULL
  AND ORIGIN IS NOT NULL

UNION

SELECT
    DEST_AIRPORT_ID,
    DEST
FROM CleanFlight
WHERE DEST_AIRPORT_ID IS NOT NULL
  AND DEST IS NOT NULL;


-- Insert date records
INSERT INTO CalendarDate (
    FlightDate,
    DayOfWeek
)
SELECT DISTINCT
    FL_DATE,
    DAY_OF_WEEK
FROM CleanFlight
WHERE FL_DATE IS NOT NULL;


-- Insert route records
INSERT INTO Route (
    OriginAirportID,
    DestinationAirportID,
    Distance
)
SELECT
    ORIGIN_AIRPORT_ID,
    DEST_AIRPORT_ID,
    MAX(DISTANCE)
FROM CleanFlight
WHERE ORIGIN_AIRPORT_ID IS NOT NULL
  AND DEST_AIRPORT_ID IS NOT NULL
GROUP BY
    ORIGIN_AIRPORT_ID,
    DEST_AIRPORT_ID;


-- Insert flight records
INSERT INTO Flight (
    FlightID,
    FlightDate,
    AirlineID,
    RouteID,
    FlightNumber,
    TailNumber,
    CRSDepTime,
    DepTime,
    DepDelay,
    CRSArrTime,
    ArrTime,
    ArrDelay,
    Cancelled,
    CancellationCode,
    Diverted,
    CRSElapsedTime,
    ActualElapsedTime,
    AirTime,
    CarrierDelay,
    WeatherDelay,
    NASDelay,
    SecurityDelay,
    LateAircraftDelay
)
SELECT
    cf.FlightID,
    cf.FL_DATE,
    cf.OP_CARRIER_AIRLINE_ID,
    r.RouteID,
    cf.OP_CARRIER_FL_NUM,
    cf.TAIL_NUM,
    cf.CRS_DEP_TIME,
    cf.DEP_TIME,
    cf.DEP_DELAY,
    cf.CRS_ARR_TIME,
    cf.ARR_TIME,
    cf.ARR_DELAY,
    cf.CANCELLED,
    cf.CANCELLATION_CODE,
    cf.DIVERTED,
    cf.CRS_ELAPSED_TIME,
    cf.ACTUAL_ELAPSED_TIME,
    cf.AIR_TIME,
    cf.CARRIER_DELAY,
    cf.WEATHER_DELAY,
    cf.NAS_DELAY,
    cf.SECURITY_DELAY,
    cf.LATE_AIRCRAFT_DELAY
FROM CleanFlight AS cf
JOIN Route AS r
    ON cf.ORIGIN_AIRPORT_ID = r.OriginAirportID
   AND cf.DEST_AIRPORT_ID = r.DestinationAirportID;


-- Check the number of rows in each normalized table
SELECT 'Airline' AS TableName, COUNT(*) AS RowCount
FROM Airline

UNION ALL

SELECT 'Airport', COUNT(*)
FROM Airport

UNION ALL

SELECT 'CalendarDate', COUNT(*)
FROM CalendarDate

UNION ALL

SELECT 'Route', COUNT(*)
FROM Route

UNION ALL

SELECT 'Flight', COUNT(*)
FROM Flight;


-- Confirm that all cleaned flights were transferred
SELECT
    (SELECT COUNT(*) FROM CleanFlight) AS CleanFlightRows,
    (SELECT COUNT(*) FROM Flight) AS NormalizedFlightRows;


-- Display ten joined records
SELECT
    f.FlightID,
    c.FlightDate,
    c.DayOfWeek,
    a.CarrierCode,
    origin.AirportCode AS Origin,
    destination.AirportCode AS Destination,
    f.DepDelay,
    f.ArrDelay,
    f.Cancelled,
    f.Diverted
FROM Flight AS f
JOIN Airline AS a
    ON f.AirlineID = a.AirlineID
JOIN CalendarDate AS c
    ON f.FlightDate = c.FlightDate
JOIN Route AS r
    ON f.RouteID = r.RouteID
JOIN Airport AS origin
    ON r.OriginAirportID = origin.AirportID
JOIN Airport AS destination
    ON r.DestinationAirportID = destination.AirportID
LIMIT 10;