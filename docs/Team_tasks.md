# Team Tasks

## Project Overview

**Project title:** U.S. Domestic Flight Reliability Analysis  
**Dataset:** Reporting Carrier On-Time Performance, January 2026

The project examines the reliability of domestic flights in the United States. The analysis will focus on airline and airport performance, departure and arrival delays, cancellations, diversions, and the causes of flight delays.

## Work Allocation

| Main Area | Deliverables | Status |
|---|---|---|
| Dataset preparation and documentation | Dataset description, data dictionary, data cleaning, sample data, and GitHub documentation | In progress |
| Database design | Functional dependencies, normalization to 3NF, relational schema, and ER/EER diagram | Schema and ER diagram published; written dependency review remains |
| Database implementation | MySQL tables, primary and foreign keys, data import, testing, and row-count evidence | Five normalized tables loaded; full-month row-count evidence published |
| SQL analysis and presentation | Coordinate SQL queries, interpret query results, document challenges and next steps, and organize presentation slides | Query sets and slides available; Arin normalized results verified October 8 |

All members will also create their own SQL queries, contribute work through GitHub, review the database design, and participate in the presentation.

## Mid-presentation Requirements and Query Count

- **Presentation:** 10 minutes maximum; the instructor will stop the presentation at 10 minutes, followed by 3 minutes of Q&A. Submit the presentation file and the project repository link.
- **Query work:** Each member must develop at least 2 basic and 2 advanced SQL queries. With four members, that is at least 16 queries in the project code overall, not 4 queries for the whole team.
- **Queries shown:** The rubric says the team does not need to present every query and should select the most useful ones. The class Discord clarification was one query per member, so our four-person team should plan to show 4 queries total, one selected query from each member. Keep each member's full set of 4 queries and results in the repository for instructor verification.
- **Query evidence:** Show the selected query code and its actual results, then briefly explain the insight. Use a range of SQL techniques covered in class, such as joins, aggregation, subqueries, CTEs, or window functions.
- **Dataset and motivation:** Explain the dataset source, size, feature count, project relevance, complexity, and cleaning or preprocessing needs.
- **Schema and MySQL:** Show the initial ER/EER diagram and relational mapping; explain primary keys, foreign keys, relationships, and normalization through at least 3NF. Include evidence that data was imported into MySQL, such as row counts and sample queries. The provided midterm wording requires schema and normalization evidence plus a successful MySQL import; it does not explicitly say that the final normalized schema must already be fully loaded or that separate foreign-key validation results must be presented. Describe the implementation status accurately.
- **Challenges and next steps:** Discuss issues encountered and planned improvements, such as cleaning, schema mapping, performance, indexes, advanced queries, or visualizations.
- **Contribution evidence:** The last slide must show each member's contribution, for example through GitHub commit history.

## Project Workflow

1. Prepare, sample, and profile the raw dataset.
2. Finalize the 3NF schema and ER/EER diagram.
3. Create and populate the normalized MySQL tables.
4. Validate row counts, primary keys, and foreign keys.
5. Complete four SQL queries per member.
6. Combine query results, screenshots, and interpretations into the presentation.

## Research and SQL Tasks

Each team member will develop two research questions within an assigned analysis area. 
Each member will use at least two basic and two advanced SQL queries to investigate these questions for the mid-project presentation. The team will decide together who takes each analysis area.

| Member | Analysis Area | Research Questions | Minimum SQL Queries |
|---|---|---:|---:|
| Audrey Wu | Airline delay and on-time performance | 2 | 4 |
| Bao Nguyen | Airport and route performance | 2 | 4 |
| Yanyu Zhu | Cancellation and diversion analysis | 2 | 4 |
| Arin Gadre | Delay causes and day-of-week patterns | 2 | 4 |

Tasks:
- Develop two research questions
- Write two basic SQL queries
- Write two advanced SQL queries
- Include results and interpretations

## Shared Team Responsibilities

- Commit their own work to GitHub so that contributions and version history can be tracked.
- Participate in reviewing the database schema and SQL queries.
- Contribute to the presentation and be prepared to explain their work.
- Help review the final slides and verify that all SQL queries run successfully.


