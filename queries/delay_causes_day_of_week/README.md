# Arin: delay causes and weekday patterns

- **SQL:** [Four queries](Arin_Delay_Causes_Day_Of_Week.sql), two basic and two advanced.
- **Results:** [MySQL output](results.tsv) and four PNG result exports, in query order.
- **Run:** MySQL 8, database FlightReliabilityDB, table CleanFlight.
- **Data:** January 2026; 544,003 rows loaded and 517,222 eligible arrivals.
- **Findings:** Sunday and Monday have the highest mean arrival delays. Carrier and late-aircraft delays have the largest reported totals each weekday.
- **Limit:** Descriptive results on the cleaned flat table; final normalized schema not verified.
