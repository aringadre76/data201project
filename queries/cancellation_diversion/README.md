# Cancellation and Diversion Analysis

## Overview

This analysis examines cancellation and diversion patterns in U.S. domestic flights during January 2026. The queries use the normalized `Flight`, `Airline`, `Route`, and `Airport` tables.

## Research Questions

1. Which airlines have the highest cancellation and diversion rates?
2. Which origin airports have the highest cancellation and diversion rates?
3. Which airlines have cancellation rates above the overall average?
4. Which origin airports have both cancellation and diversion rates above the overall averages?

## Key Findings

- OH had the highest airline cancellation rate at 11.60%, followed by AA 8.93% and YX 8.18%.
- Among origin airports with at least 500 flights, CLT had the highest cancellation rate at 10.98%, followed by DFW with 9.85%.
- 6 airlines had cancellation rates above the overall average.
- 27 origin airports had both cancellation and diversion rates above the overall averages.

## Files

- `Cancellation_diversion_analysis.sql` — SQL queries
- `airline_cancellation_diversion.png` — airline query result
- `airport_cancellation_diversion.png` — airport query result
- `airline_above_overall.png` — airlines above the overall cancellation rate
- `airport_above_overall.png` — airports above both overall cancellation and diversion rates
