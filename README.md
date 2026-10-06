# DATA 201 Group Project

## U.S. Domestic Flight Reliability Analysis

This project analyzes delays, cancellations, diversions, and operational patterns in U.S. domestic flights using the U.S. Bureau of Transportation Statistics (BTS) Reporting Carrier On-Time Performance dataset.

## Dataset

- **Source:** [BTS Reporting Carrier On-Time Performance](https://transtats.bts.gov/DL_SelectFields.aspx?gnoyr_VQ=FGJ)
- **Initial period:** January 2026
- **Repository policy:** The full raw dataset is kept out of Git because of its size. Use `data/samples/` for small shareable examples; keep downloaded and generated data in the ignored raw/processed locations.
- **Field reference:** [Data Dictionary](docs/Data_Dictionary.md)

## Repository Map

| Location | Put here |
|---|---|
| `data/raw/` | Downloaded source files; local and ignored by Git |
| `data/processed/` | Cleaned or transformed datasets; local and ignored by Git |
| `data/samples/` | Small examples suitable for sharing and testing |
| `database/` | MySQL schema and database implementation materials |
| `database/erd/` | ERD and database design diagrams |
| `queries/` | The team MySQL analysis queries |
| `scripts/` | Data import, cleaning, or validation scripts |
| `report/` | Written analysis and report materials |
| `report/figures/` | Figures used in the report |
| `docs/` | Dataset documentation, project planning notes, and requirements references |

The local `archive/local_exploration/` directory contains exploratory reference work and is ignored by Git. It is not part of the shared project deliverables.

## Work Tracking

Use the GitHub Project board as the live Kanban tracker for assignments and progress. [Team Tasks](docs/Team_tasks.md) is a planning reference; keep task status current on the board.

## Research Questions

- Which airlines have the highest average delays?
- Which airports and routes experience the most delays?
- How do delays vary by time of day and day of week?
- What are the major causes of flight delays?
- Which airlines and airports have the highest cancellation rates?

## Team Members

- Arin Gadre
- Bao Nguyen
- Audrey Wu
- Yanyu Zhu
