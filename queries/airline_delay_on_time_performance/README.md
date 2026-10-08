# Airline Delay and On-Time Performance Analysis

## Overview

This analysis examines airline departure delays, arrival delays, and late-arrival rates for U.S. domestic flights during January 2026.

The queries use the normalized `Flight` and `Airline` tables in `FlightReliabilityDB`.

## Research Questions

1. Which airlines have the highest average departure and arrival delays?
2. Which airlines have the highest percentage of flights arriving at least 15 minutes late?
3. Which airlines have an average arrival delay above the overall average?
4. Which airlines have a late-arrival rate above the overall late-arrival rate?

## Key Findings

- American Airlines (AA) had the highest average departure delay at 52.79 minutes and the highest average arrival delay at 45.73 minutes.
- AA also had the highest late-arrival rate, with 30.71% of flights arriving at least 15 minutes late.
- F9 had the lowest average arrival delay at -2.77 minutes, meaning its flights arrived slightly early on average.
- MQ had the lowest late-arrival rate at 11.76%.
- The overall average arrival delay was approximately 8.93 minutes. 
- The overall late-arrival rate was approximately 21.18%. Eight airlines had late-arrival rates above this overall rate.


## Files

- `airline_delay_on_time_performance.sql` — SQL analysis queries
- `README.md` — Analysis description, findings, and limitations
- `airlines_above_avg_arrival_delay.png` - Airlines with average arrival delays above the overall average
- `airlines_above_overall_late-arrival_rate.png` - Airlines with late-arrival rates above the overall late-arrival rate
- `avg_delay_by_airline.png` - Average departure and arrival delays by airline
- `percentage_late_arrivals_by_airline.png` - Percentage of flights arriving at least 15 minutes late by airline
