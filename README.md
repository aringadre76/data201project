# DATA 201 Group Project

## U.S. Domestic Flight Reliability Analysis

This project analyzes delays, cancellations, diversions, and operational patterns in U.S. domestic flights using the U.S. Bureau of Transportation Statistics (BTS) Reporting Carrier On-Time Performance dataset.

## Dataset

- **Source:** [BTS Reporting Carrier On-Time Performance](https://transtats.bts.gov/DL_SelectFields.aspx?gnoyr_VQ=FGJ)
- **Period:** January 1-31, 2026
- **Downloaded subset:** 544,003 flight records with 36 selected fields
- **Sample:** [1,000 flight records](data/samples/flights_sample_1000.csv) for development, not full-month findings
- **Fields:** [Data Dictionary](docs/Data_Dictionary.md)
- **Shared data:** The repository already includes the source ZIP, cleaned ZIP, and normalized CSV bundles. New local downloads and processed outputs remain ignored under `data/raw/` and `data/processed/`; existing tracked files remain shared. Keep credentials and local database files out of Git.

## MySQL Setup

Use MySQL 8 and the `FlightReliabilityDB` database. MySQL Workbench is an optional client; it does not replace the database server.

### Build from source records

1. Run [01_create_rawflight.sql](data/samples/01_create_rawflight.sql) to create the database and the 36-column `RawFlight` staging table.
2. Extract the [source ZIP](data/raw/T_ONTIME_REPORTING_20261002_193237.zip). Import `T_ONTIME_REPORTING.csv` into `RawFlight`, mapping the header names to the existing columns. `Term.csv` and `Documentation.csv` contain metadata, not flight records. Use the [sample CSV](data/samples/flights_sample_1000.csv) only for a small development database.
3. Run [02_data_quality_checks.sql](data/samples/02_data_quality_checks.sql) to inspect the import.
4. Run [03_clean_flight_data.sql](data/processed/03_clean_flight_data.sql) to populate the typed `CleanFlight` staging table.
5. Run [04_create_normalized_schema.sql](data/normalized/04_create_normalized_schema.sql) to create and populate `Airline`, `Airport`, `CalendarDate`, `Route`, and `Flight` from `CleanFlight`. The script also reports table counts and joined sample records.

These setup scripts drop and recreate their target tables. Run them when building a development database, not before every analysis query. If the normalized tables are already loaded, go directly to the analysis scripts below.

### Expected full-month counts

| Table | Rows |
|---|---:|
| Airline | 13 |
| Airport | 342 |
| CalendarDate | 31 |
| Route | 5,812 |
| Flight | 544,003 |

The sample database will have smaller counts. See the [ER diagram](data/normalized/Normalized_EER_diagram.png), [normalization notes](data/normalized/Normalization.md), and [validation evidence](data/normalized/normalized_validation.png).

## Analysis Scripts

Each member retains two basic and two advanced queries in the repository. The presentation selects one query per member.

| Area | SQL to use | Results and notes |
|---|---|---|
| Arin: delay causes and weekdays | [Normalized queries](queries/delay_causes_day_of_week/Arin_Delay_Causes_Day_Of_Week.sql) | [Verified results and PNGs](queries/delay_causes_day_of_week/README.md) |
| Audrey: airline delay and on-time performance | [Full normalized dataset queries](queries/airline_delay_on_time_performance/Normalized%20full%20dataset%20outputs/airline_delay_queries.sql) | [Full dataset outputs](queries/airline_delay_on_time_performance/Normalized%20full%20dataset%20outputs/) |
| Yanyu: cancellations and diversions | [Normalized queries](queries/cancellation_diversion/Cancellation_diversion_analysis.sql) | [Results and notes](queries/cancellation_diversion/README.md) |
| Bao: airports and routes | [Airport and route queries](queries/airport_and_route_performance/Airport_n_Route_Performance.sql) | [Query outputs](queries/airport_and_route_performance/) |

`CleanFlight` and `RawFlight` are staging tables. In the normalized schema, weekday information is in `CalendarDate`, carrier codes are in `Airline`, and airport codes are in `Airport` through `Route`. Join only the tables needed for the research question.

The earlier `delay_dayofweek_analysis.sql` files at the root and directly under `queries/` are retained development drafts. Use Arin's linked four-query script for the current weekday analysis. Root-level airline SQL copies are also earlier drafts; use the full normalized dataset script linked above.

## Repository Map

| Location | Contents |
|---|---|
| `data/raw/` | Source dataset ZIP and local downloads |
| `data/processed/` | Cleaned data and staging-table cleaning script |
| `data/normalized/` | Normalized schema SQL, table CSVs, ER diagram, and validation evidence |
| `data/samples/` | Small development sample and staging-table setup/check scripts |
| `queries/` | Member analysis scripts, outputs, and interpretations |
| `database/erd/` | Reserved for additional database design diagrams |
| `scripts/` | Import or validation utilities |
| `docs/` | Data dictionary and team planning |
| `report/` | Written analysis and report figures |

`archive/local_exploration/` is ignored local reference work and is not part of the shared deliverables.

## Work Tracking and Presentation

Use the [GitHub Project board](https://github.com/users/aringadre76/projects/2) as the live Kanban tracker. [Team Tasks](docs/Team_tasks.md) records analysis areas and midterm requirements.

The [midterm presentation](https://docs.google.com/presentation/d/1MckoCKnu-uFCegQ1mkwLg-TU8M8-AYmbMmK-LxDQj_w/edit) covers the dataset, schema, normalization, MySQL import, selected SQL results, challenges, and contributions. The full four-query sets remain in this repository for instructor review.

## Team Members

- Arin Gadre
- Bao Nguyen
- Audrey Wu
- Yanyu Zhu
