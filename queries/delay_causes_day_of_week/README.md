# Arin: delay causes and weekday patterns

- [SQL](Arin_Delay_Causes_Day_Of_Week.sql): two basic aggregates and two advanced subqueries.
- [Results](results.tsv): actual MySQL output; PNG exports show each result set.
- Run: MySQL 8.4.8, `FlightReliabilityDB.Flight` and `CalendarDate`; full January 2026 dataset.
- Weekday queries join `Flight` to `CalendarDate` on `FlightDate`. The overall cause-total query only needs `Flight`.
- Scope: DATA 201 Lectures 5-7. Advanced 1 uses HAVING with a scalar subquery; Advanced 2 uses a correlated scalar subquery. No CTEs or window functions.
- Verified October 8, 2026: 544,003 normalized flights, 544,003 unique FlightIDs, and 544,003 rows after the calendar join. All query input fields match the cleaned staging table, and all four query outputs exactly match the earlier staging results.
- Findings: Sunday, Monday and Saturday exceed the overall mean of 6.410360 minutes. Carrier and late-aircraft delays have the largest overall reported totals; late-aircraft totals exceed carrier totals on Monday and Sunday.
- Days 1-7 mean Monday-Sunday. Means are displayed to two decimals on slides. Arrival delay includes early arrivals as negative values. Cause totals are reported minutes, not proof of why weekday differences occurred.
