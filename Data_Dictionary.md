# Data Dictionary

## Dataset Overview

- **Dataset:** Reporting Carrier On-Time Performance
- **Source:** U.S. Department of Transportation, Bureau of Transportation Statistics
- **Time period:** January 1–31, 2026
- **Number of records:** 544,003 flight records
- **Number of selected columns:** 36
- **Source page:** [BTS On-Time Performance Data](https://transtats.bts.gov/DL_SelectFields.aspx?QO_fu146_anzr=&gnoyr_VQ=FGJ)

The dataset contains information about scheduled domestic flights in the United States, including airlines, airports, departure and arrival times, delays, cancellations, diversions, flight duration, and distance.

## Column Definitions

The following columns were selected and downloaded for this project:

| Column Name | Suggested SQL Type | Description |
|---|---|---|
| `DAY_OF_WEEK` | `TINYINT` | Day of the week. Values range from 1 to 7, where 1 represents Monday and 7 represents Sunday. |
| `FL_DATE` | `DATE` | Date on which the flight was scheduled to operate. |
| `OP_UNIQUE_CARRIER` | `VARCHAR(10)` | Unique code identifying the operating airline. |
| `OP_CARRIER_AIRLINE_ID` | `INT` | Permanent identification number assigned by the U.S. Department of Transportation to the operating airline. |
| `TAIL_NUM` | `VARCHAR(10)` | Tail number identifying the aircraft used for the flight. It may be missing when an aircraft was not assigned or the flight was cancelled. |
| `OP_CARRIER_FL_NUM` | `VARCHAR(10)` | Flight number assigned by the operating airline. |
| `ORIGIN_AIRPORT_ID` | `INT` | Permanent U.S. DOT identification number for the origin airport. |
| `ORIGIN` | `CHAR(3)` | Three-letter code of the origin airport. |
| `ORIGIN_CITY_NAME` | `VARCHAR(100)` | City and state associated with the origin airport. |
| `ORIGIN_STATE_ABR` | `CHAR(2)` | Two-letter state abbreviation of the origin airport. |
| `DEST_AIRPORT_ID` | `INT` | Permanent U.S. DOT identification number for the destination airport. |
| `DEST` | `CHAR(3)` | Three-letter code of the destination airport. |
| `DEST_CITY_NAME` | `VARCHAR(100)` | City and state associated with the destination airport. |
| `DEST_STATE_ABR` | `CHAR(2)` | Two-letter state abbreviation of the destination airport. |
| `CRS_DEP_TIME` | `CHAR(4)` | Scheduled departure time in local time using the `HHMM` format. |
| `DEP_TIME` | `CHAR(4)` | Actual departure time in local time using the `HHMM` format. It may be NULL for cancelled flights. |
| `DEP_DELAY` | `DECIMAL(8,2)` | Difference in minutes between the scheduled and actual departure times. Positive values indicate a delay, while negative values indicate an early departure. |
| `CRS_ARR_TIME` | `CHAR(4)` | Scheduled arrival time in local time using the `HHMM` format. |
| `ARR_TIME` | `CHAR(4)` | Actual arrival time in local time using the `HHMM` format. It may be NULL for cancelled or diverted flights. |
| `ARR_DELAY` | `DECIMAL(8,2)` | Difference in minutes between the scheduled and actual arrival times. Positive values indicate a delay, while negative values indicate an early arrival. |
| `ARR_DELAY_NEW` | `DECIMAL(8,2)` | Arrival delay in minutes, with early arrivals recorded as zero instead of a negative number. |
| `ARR_DEL15` | `TINYINT` | Indicates whether the flight arrived at least 15 minutes late. A value of 1 means yes, and 0 means no. |
| `ARR_DELAY_GROUP` | `INT` | Category representing the arrival delay in 15-minute intervals. Negative values represent early arrivals. |
| `ARR_TIME_BLK` | `VARCHAR(20)` | Hourly block containing the scheduled arrival time, such as `0900-0959`. |
| `CANCELLED` | `TINYINT` | Indicates whether the flight was cancelled. A value of 1 means cancelled, and 0 means not cancelled. |
| `CANCELLATION_CODE` | `CHAR(1)` | Reason for cancellation. `A` represents carrier, `B` represents weather, `C` represents the National Air System, and `D` represents security. It is NULL when the flight was not cancelled. |
| `DIVERTED` | `TINYINT` | Indicates whether the flight was diverted to a different airport. A value of 1 means diverted, and 0 means not diverted. |
| `CRS_ELAPSED_TIME` | `DECIMAL(8,2)` | Scheduled total elapsed flight time in minutes. |
| `ACTUAL_ELAPSED_TIME` | `DECIMAL(8,2)` | Actual total elapsed flight time in minutes. It may be NULL for cancelled or diverted flights. |
| `AIR_TIME` | `DECIMAL(8,2)` | Number of minutes the aircraft spent in the air. It may be NULL for cancelled or diverted flights. |
| `DISTANCE` | `DECIMAL(8,2)` | Distance between the origin and destination airports in miles. |
| `CARRIER_DELAY` | `DECIMAL(8,2)` | Number of delay minutes caused by circumstances within the airline’s control. |
| `WEATHER_DELAY` | `DECIMAL(8,2)` | Number of delay minutes caused by significant weather conditions. |
| `NAS_DELAY` | `DECIMAL(8,2)` | Number of delay minutes caused by the National Air System, such as air traffic control or airport operations. |
| `SECURITY_DELAY` | `DECIMAL(8,2)` | Number of delay minutes caused by security-related events. |
| `LATE_AIRCRAFT_DELAY` | `DECIMAL(8,2)` | Number of delay minutes caused by the aircraft arriving late from a previous flight. |

## Missing Values

Missing values are expected in several columns:

- `TAIL_NUM` may be missing when an aircraft was not assigned.
- `DEP_TIME` and `DEP_DELAY` may be missing for cancelled flights.
- `ARR_TIME`, `ARR_DELAY`, `ACTUAL_ELAPSED_TIME`, and `AIR_TIME` may be missing for cancelled or diverted flights.
- `CANCELLATION_CODE` is normally NULL when a flight was not cancelled.
- The five delay-cause columns may be NULL when a flight did not have a qualifying delay.

## Notes

- Scheduled and actual times use local airport time.
- Time values are stored in `HHMM` format rather than as standard SQL time values.
- `ARR_DELAY_NEW`, `ARR_DEL15`, `ARR_DELAY_GROUP`, and `ARR_TIME_BLK` are derived fields. They may be retained in the raw-data table but do not all need to be stored in the final normalized database.
- The complete dataset is not stored in this repository because of its size. A smaller sample may be included for testing and demonstration.
