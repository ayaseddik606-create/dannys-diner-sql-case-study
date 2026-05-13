# Danny's Diner SQL Case Study | 8 Week SQL Challenge

## Project Overview
Danny loves Japanese food and opened a small restaurant in early 2021 selling sushi, curry, and ramen. After a few months of operation, he needs help analysing his customer data to understand spending habits, visiting frequency, and menu preferences — so he can improve his loyalty programme and grow the business.
This project answers 10 business questions + 2 bonus queries using real-world SQL techniques across three related tables.

### Database Schema
### sales
- customer_id
- order_date
- product_id

### menu
- product_id
- product_name
- price

### members
- customer_id
- join_date

## Relationships:
sales.product_id → menu.product_id (Foreign Key)
sales.customer_id → members.customer_id (Joined on query level)

## Database Tables

- sales
- menu
- members

## Skills Used
- JOINs
- GROUP BY
- Aggregate Functions
- CASE WHEN
- CTEs
- Window Functions
- RANK
- ROW_NUMBER
- DATE Functions

## Business Questions Solved
1. Total amount spent by each customer
2. Customer visit frequency
3. First item purchased
4. Most purchased item
5. Most popular item per customer
6. First purchase after membership
7. Purchase before membership
8. Spending before membership
9. Customer points calculation
10. Join All The Things
11. Rank All The Things

## Concepts Demonstrated

- Relational Database Design
- Primary & Foreign Keys
- SQL Joins
- Aggregation & Grouping
- Window Functions
- Common Table Expressions (CTEs)
- Conditional Logic
- Ranking & Partitioning
- Date Calculations

 ## Project Structure
Danny_Diner_SQL_Project/
│
├── dannys_diner.sql      ← Full SQL: setup, inserts, all 12 queries
├── README.md             ← This file
├── notes.md              ← Learning notes and key concepts
└── screenshots/          ← Query result screenshots (add after running)
    ├── q1_total_spent.png
    ├── q2_visit_days.png
    └── ...

## Key Learnings
1. CTEs make complex queries readable — breaking a problem into named steps is cleaner than nesting subqueries.
2. ROW_NUMBER() vs RANK() — use ROW_NUMBER() when you want exactly one row per group; use RANK() when ties should all be included.
3. LEFT JOIN for optional relationships — customer C has no membership row, so LEFT JOIN prevents them from disappearing from results.
4. COUNT(DISTINCT ...) matters — counting raw rows vs unique values gives different (and sometimes wrong) answers.
5. CASE WHEN inside SUM() — a powerful pattern for conditional aggregation without needing multiple queries.
6. Date arithmetic with DATEADD() — calculating rolling windows (like a 7-day bonus period) is a common real-world pattern.


## How to Run
1. Open SQL Server Management Studio (SSMS)
2. Open dannys_diner.sql
3. Run the file top to bottom — it creates the database, inserts data, then runs all queries
4. Each query is separated by a comment block for easy navigation

## Tools Used
- SQL Server
- SSMS
- VS Code

## Author
Aya Seddik Helmy Seddik
Aspiring Data Analyst | SQL • Excel • Power BI
## LinkedIn:www.linkedin.com/in/aya-seddik-helmy
## GitHub:https://github.com/ayaseddik606-create/dannys-diner-sql-case-study
