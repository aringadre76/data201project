# Arin: delay causes and weekday patterns

- [SQL](Arin_Delay_Causes_Day_Of_Week.sql): two basic aggregates and two advanced subqueries.
- [Results](results.tsv): actual MySQL output; PNG exports show each result set.
- Scope: DATA 201 Lectures 5-7. Advanced 1 uses HAVING with a scalar subquery; Advanced 2 uses a correlated scalar subquery. No CTEs or window functions.
- Run: MySQL 8, FlightReliabilityDB.CleanFlight; January 2026 data.
- Findings: Sunday, Monday and Saturday exceed the overall mean. Carrier and late-aircraft delays have the largest overall reported totals; late-aircraft totals exceed carrier totals on Monday and Sunday.
- Means are displayed to two decimals on slides. Cleaned flat-table execution does not verify final normalized-schema import.
