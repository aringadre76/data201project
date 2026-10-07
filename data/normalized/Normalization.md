## Objective

Normalize the cleaned flight data into a 3NF relational schema. The source data is the `CleanFlight` table created by `03_clean_flight_data.sql`.

## Functional Dependencies

The current design includes the following dependencies:

- `FlightID → all flight-specific attributes`
- `AirlineID → CarrierCode`
- `AirportID → AirportCode`
- `FlightDate → DayOfWeek`
- `(OriginAirportID, DestinationAirportID) → Distance`

## Proposed 3NF Tables

- `Airline(AirlineID PK, CarrierCode)`
- `Airport(AirportID PK, AirportCode)`
- `FlightDate(FlightDate PK, DayOfWeek)`
- `Route(RouteID PK, OriginAirportID FK, DestinationAirportID FK, Distance)`
- `Flight(FlightID PK, FlightDate FK, AirlineID FK, RouteID FK, flight number, tail number, times, delays, cancellation, and diversion information)`

## Normalization Explanation

- **1NF:** The cleaned data contains atomic values and no repeating groups.
- **2NF:** `FlightID` is a single-column primary key, so there are no partial dependencies.
- **3NF:** Airline, airport, date, and route information should be separated because they depend on their own identifiers rather than directly on `FlightID`.

## Tasks

- [ ] Review and confirm the functional dependencies.
- [ ] Complete the written 1NF → 2NF → 3NF explanation.
- [ ] Create the final relational schema.
- [ ] Create an ER/EER diagram showing the tables and relationships.
- [ ] Create `04_create_normalized_schema.sql`.
- [ ] Add all primary keys, foreign keys, and unique constraints.
- [ ] Insert data into the normalized tables from `CleanFlight`.
- [ ] Verify the row counts and relationships.
- [ ] Upload the SQL file, diagram, and validation evidence to GitHub.

The sample data may be used while developing and testing the schema. The final version should also be tested against the complete cleaned dataset.
