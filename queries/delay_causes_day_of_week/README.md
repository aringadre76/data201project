# Arin Gadre: delay causes and weekday patterns

The portfolio contains two basic and two advanced queries in
`Arin_Delay_Causes_Day_Of_Week.sql`. Their actual MySQL output is saved in
`results.tsv`, in query order. All four ran successfully on October 7, 2026,
using MySQL 8.4.8 and `FlightReliabilityDB.CleanFlight`.

The cleaned January 2026 input contains 544,003 flight operations. Arrival-delay
queries exclude cancellations, diversions, and missing arrival delay, leaving
517,222 eligible arrivals. Day codes are 1=Monday through 7=Sunday. Early
arrivals retain their negative delay values.

| Query | Question | Techniques | Finding |
|---|---|---|---|
| Basic 1 | How do arrival delays vary by weekday? | Filtering, grouping, AVG, conditional aggregation | Sunday averages 13.75 minutes and Monday 12.81, the highest two weekday means. |
| Basic 2 | How many reported minutes belong to each cause by weekday? | SUM, COALESCE, GROUP BY | Carrier and late-aircraft delays have the two largest totals each weekday. |
| Advanced 1 | Which weekday means exceed the overall mean? | CTEs, grouped/global aggregates, CROSS JOIN | Sunday, Monday, and Saturday exceed the 6.41-minute overall mean by 7.34, 6.40, and 0.52 minutes. |
| Advanced 2 | Which two reported causes rank highest within each weekday? | UNION ALL, CTE, ROW_NUMBER with PARTITION BY | Late aircraft ranks first on Monday and Sunday; carrier ranks first on the other days. |

## Selected slide query

This is a shorter projection of Basic 1, sorted for presentation. It is valid
SQL and uses the same population and calculation as the portfolio query.

```sql
SELECT DAY_OF_WEEK,
 ROUND(AVG(ARR_DELAY), 2) AS mean_min
FROM CleanFlight
WHERE CANCELLED = 0
  AND DIVERTED = 0
  AND ARR_DELAY IS NOT NULL
GROUP BY DAY_OF_WEEK
ORDER BY mean_min DESC;
```

| Weekday | Mean arrival delay (minutes) |
|---|---:|
| Sunday | 13.75 |
| Monday | 12.81 |
| Saturday | 6.93 |
| Friday | 6.12 |
| Thursday | 3.79 |
| Tuesday | 1.37 |
| Wednesday | 0.54 |

## Run

Import the team's cleaned CSV into `FlightReliabilityDB.CleanFlight` using the
matching table definition, then run the SQL file with a MySQL 8 client or
Workbench. The advanced queries require MySQL 8 features. Do not use SQLite
results as MySQL evidence.

## Interpretation and limits

The results describe January 2026 and do not establish that a weekday causes
delays. Carrier/route mix, weather, and flight volume may differ. Cause totals
measure reported minutes, so missing cause values are treated as zero reported
minutes only for totaling; they are not proof that no delay occurred. The
overall mean is weighted by individual flights rather than by seven equally
weighted weekday averages.

Execution against the cleaned flat table is verified. This evidence does not
verify the team's final normalized schema or foreign-key enforcement. Adapt
and rerun these queries if that schema changes.

## Speaking script (about 45-50 seconds)

My area is delay causes and weekday patterns. I ran two basic and two advanced
queries in MySQL. This example groups completed, non-diverted flights by
weekday and averages their arrival delay. Sunday averaged 13.75 minutes and
Monday 12.81, compared with 6.41 minutes overall. A CTE comparison identifies
Sunday, Monday, and Saturday as above the overall average. My cause totals and
window ranking also show that carrier and late-aircraft delays are the top
two reported categories each weekday. These are descriptive results for
January, so they do not prove that the weekday itself causes delays.
