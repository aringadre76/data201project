## Objective

Normalize the cleaned flight data into a 3NF relational schema. The source data is the `CleanFlight` table created by `03_clean_flight_data.sql`.

## Functional Dependencies

The current design includes the following dependencies:

- `FlightID → all flight-specific attributes`
- `AirlineID → CarrierCode`
- `AirportID → AirportCode`
- `FlightDate → DayOfWeek`
- `(OriginAirportID, DestinationAirportID) → Distance`

## Normalization Process

- **1NF:** The cleaned data contains atomic values and no repeating groups.
- **2NF:** `FlightID` is a single-column primary key, so there are no partial dependencies.
- **3NF:** Airline, airport, date, and route information is stored in separate tables using their own identifiers.

## Implemented Tables

- `Airline(AirlineID PK, CarrierCode)`
- `Airport(AirportID PK, AirportCode)`
- `CalendarDate(FlightDate PK, DayOfWeek)`
- `Route(RouteID PK, OriginAirportID FK, DestinationAirportID FK, Distance)`
- `Flight(FlightID PK, FlightDate FK, AirlineID FK, RouteID FK, flight number, tail number, times, delays, cancellation, and diversion information)`


## Tasks

- [ ] Review and confirm the functional dependencies.
- [ ] Complete the written 1NF → 2NF → 3NF explanation.
- [x] Create the relational schema.
- [x] Create an ER/EER diagram showing the tables and relationships.
- [x] Create `04_create_normalized_schema.sql`.
- [x] Add primary keys, foreign keys, and unique constraints.
- [x] Insert data into the normalized tables from `CleanFlight`.
- [x] Verify table counts and the Flight-to-CalendarDate relationship on the full dataset.
- [x] Upload the SQL file, diagram, and validation evidence to GitHub.

The sample data may be used while developing and testing the schema. The final version should also be tested against the complete cleaned dataset.

## Implementation Evidence

[Schema and load script](04_create_normalized_schema.sql), [ER diagram](Normalized_EER_diagram.png), and [table-count evidence](normalized_validation.png). Full-month counts are Airline 13, Airport 342, CalendarDate 31, Route 5,812, and Flight 544,003. Arin's October 8 MySQL validation confirmed 544,003 unique flight IDs, 544,003 rows after joining CalendarDate, and unchanged values for all fields used by his four queries.
