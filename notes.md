# SQL Learning Notes – Danny's Diner Case Study

## Project Overview
This project focused on analyzing customer behavior using SQL Server.
Throughout the project, I practiced real-world SQL concepts including joins,
aggregations, CTEs, window functions, ranking, conditional logic, and date calculations.

The project helped me understand not only SQL syntax,
but also how to think like a data analyst and solve business problems step by step.

---

# 1. Database Design Concepts

## Primary Key
A Primary Key uniquely identifies each row in a table.

Example:
- product_id in the menu table
- sale_id in the sales table

Important:
A table can only have ONE primary key.

---

## Foreign Key
A Foreign Key creates a relationship between tables.

Example:
sales.product_id references menu.product_id

This allows SQL to connect customer orders with menu details.

---

# 2. JOINs

## INNER JOIN
Returns only matching records from both tables.

Used when:
We only want rows that exist in both tables.

Example:
Joining sales with menu.

---

## LEFT JOIN
Returns all rows from the left table,
even if no matching record exists in the right table.

Used when:
Some customers are not members yet,
but we still want to keep their orders in the result.

Important Example:
Customer C had no membership record,
so LEFT JOIN prevented customer C from disappearing.

---

# 3. GROUP BY

GROUP BY is used to aggregate data by categories.

Used with:
- COUNT()
- SUM()
- AVG()
- MAX()
- MIN()

Example:
Calculating total amount spent by each customer.

Important Rule:
Any non-aggregated column inside SELECT
must also exist inside GROUP BY.

---

# 4. Aggregate Functions

## COUNT(*)
Counts all rows.

## COUNT(column)
Counts non-null values only.

## COUNT(DISTINCT column)
Counts unique values only.

Important:
COUNT(order_date) is NOT the same as
COUNT(DISTINCT order_date).

---

## SUM()
Adds numeric values together.

Used for:
- Total spending
- Total points
- Total purchases

---

# 5. CASE WHEN

CASE WHEN adds conditional logic inside SQL queries.

Example Uses:
- Membership status (Y/N)
- Loyalty points calculation
- Bonus week logic

Pattern:
CASE
    WHEN condition THEN value
    ELSE value
END

Important:
CASE WHEN is extremely useful inside SUM().

Example:
Conditional aggregation.

---

# 6. Common Table Expressions (CTEs)

## What is a CTE?
A temporary named result set.

Syntax:
WITH CTE_Name AS (
    query
)

Used when:
- Breaking complex logic into steps
- Improving readability
- Avoiding nested subqueries

Important Lesson:
CTEs make SQL cleaner and easier to debug.

---

# 7. Window Functions

Window Functions perform calculations across related rows
without collapsing the result set.

Unlike GROUP BY:
Window functions keep all original rows visible.

Most Important Window Functions Learned:
- ROW_NUMBER()
- RANK()

---

# 8. ROW_NUMBER()

Assigns a unique sequential number to rows.

Syntax:
ROW_NUMBER() OVER(
    PARTITION BY column
    ORDER BY column
)

Used when:
We want EXACTLY one row per group.

Example:
Finding the first purchase for each customer.

Important:
ROW_NUMBER() never repeats numbers.

---

# 9. RANK()

Assigns ranking values while allowing ties.

If two rows share the same rank,
the next rank is skipped.

Example:
1, 1, 3

Used when:
Multiple rows can share the same ranking.

Example:
Most popular item per customer.

---

# 10. PARTITION BY

PARTITION BY splits data into groups
before applying a window function.

Example:
PARTITION BY customer_id

Meaning:
Each customer gets separate ranking/order numbering.

Without PARTITION BY:
The ranking would apply to the entire table.

---

# 11. ORDER BY Inside Window Functions

Controls the sorting logic used by:
- ROW_NUMBER()
- RANK()

Example:
ORDER BY order_date

Meaning:
Ranking starts from earliest order.

ORDER BY order_date DESC
Means:
Ranking starts from latest order.

---

# 12. Date Functions

## DATEADD()

Used to add time intervals to dates.

Example:
DATEADD(day, 6, join_date)

Meaning:
Add 6 days to the join date.

Used in:
Calculating the first membership bonus week.

---

## BETWEEN

Checks whether a value exists inside a range.

Example:
WHERE order_date BETWEEN '2021-01-01' AND '2021-01-31'

Important:
BETWEEN includes both start and end values.

---

# 13. Business Logic Learned

## Membership Analysis
Customers behave differently after becoming members.

Important:
Membership status changes:
- spending behavior
- loyalty points
- purchasing patterns

---

## Loyalty Points System
Points were calculated using:
- Normal items = price × 10
- Sushi = double points
- First membership week = 2x points on all items

This introduced:
- conditional calculations
- date-based logic
- business rule implementation

---

# 14. Common Mistakes I Learned From

## Mistake:
Using GROUP BY incorrectly.

Fix:
Every non-aggregated column must be grouped.

---

## Mistake:
Confusing ROW_NUMBER() and RANK().

Fix:
- ROW_NUMBER() = unique sequence
- RANK() = allows ties

---

## Mistake:
Using INNER JOIN instead of LEFT JOIN.

Fix:
LEFT JOIN preserves unmatched rows.

---

## Mistake:
Using ORDER BY incorrectly inside ranking functions.

Fix:
Ascending = earliest first
Descending = latest first

---

## Mistake:
Counting rows instead of distinct values.

Fix:
Use COUNT(DISTINCT column) when necessary.

---

# 15. Real Skills Practiced

- Writing clean SQL queries
- Solving business questions
- Thinking analytically
- Understanding customer behavior
- Using SQL Server professionally
- Debugging SQL syntax errors
- Reading query results
- Working with relational databases

---

# 16. Final Takeaways

This project helped me transition from
writing basic SQL queries
to solving realistic business problems using SQL.

Most valuable concepts learned:
- CTEs
- Window Functions
- Ranking Logic
- Conditional Aggregation
- Date Calculations
- Business Thinking in SQL

The project also improved:
- query organization
- debugging skills
- logical thinking
- project structuring
- portfolio preparation