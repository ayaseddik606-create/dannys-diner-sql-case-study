-- =============================================================
--  Danny's Diner — SQL Case Study
--  Author  : Aya Seddik Helmy Seddik 
--  Tool    : SQL Server (T-SQL)
--  Date    : 13 May 2026
--  Source  : Danny Ma — 8 Week SQL Challenge (Week 1)
-- =============================================================
-- =============================================================
--  SECTION 1: DATABASE & TABLE SETUP
-- =============================================================
create database Dannys_Diner
USE Dannys_Diner;
CREATE Table menu(
product_id INT primary key,
product_name varchar (255) unique,
price INT NOT NULL
);
CREATE Table sales(
sale_id INT IDENTITY(1,1) PRIMARY KEY,
customer_id varchar (2),
order_date DATE Not null,
product_id INT,
Foreign key (product_id) 
REFERENCES menu (product_id)
);
CREATE Table members(
customer_id varchar (2),
join_date DATE Not null
);
-- =============================================================
--  SECTION 2: DATA INSERTION
-- =============================================================

INSERT INTO menu (product_id ,product_name ,price)
values
(1,'sushi',10),
(2,'curry',15),
(3,'ramen',12)

INSERT INTO sales(customer_id,order_date,product_id)
VALUES 
('A','2021-01-01',01),
('A','2021-01-01',02),
('A','2021-01-07',02),
('A','2021-01-10',03),
('A','2021-01-11',03),
('B','2021-01-01',02),
('B','2021-01-02',02),
('B','2021-01-04',01),
('B','2021-01-11',01),
('B','2021-01-16',03),
('B','2021-02-01',03),
('C','2021-01-01',03),
('C','2021-01-01',03),
('C','2021-01-07',03)
insert into members(customer_id,join_date)
values('A','2021-01-07'),('B','2021-01-09')

SELECT * FROM menu;
SELECT * FROM sales;
SELECT * FROM members;

ALTER TABLE sales
DROP CONSTRAINT PK__sales__E1EB00B2B4C9D767;
ALTER TABLE sales
DROP COLUMN sale_id;

SELECT product_name FROM menu
WHERE price > 10;
SELECT product_name AS p,customer_id AS C
FROM sales s
left join menu m
on m.product_id =s.product_id
where customer_id = 'A';

-- =============================================================
--  SECTION 3: CASE STUDY QUESTIONS
-- =============================================================

--1-What is the total amount each customer spent at the restaurant?
--Concepts: JOIN, SUM aggregate, GROUP BY
----------------------------------------------------------------------
SELECT S.customer_id ,  Sum (price) AS Total_Amount, count (S.product_id) AS Total_Products
from sales S
join menu M 
ON S.product_id = M.product_id
group by S.customer_id;

--2-How many days has each customer visited the restaurant?
--Concepts: COUNT DISTINCT, GROUP BY
-- Note: Using COUNT(DISTINCT order_date) so repeat visits on
--       the same day count as one visit.
----------------------------------------------------------------------
select customer_id ,COUNT(order_date) as total_days from sales
Group by customer_id;

--3-What was the first item from the menu purchased by each customer?
---- Concepts: CTE, ROW_NUMBER window function, PARTITION BY
----------------------------------------------------------------------
WITH first_Order AS
(Select S.customer_id C,M.product_name AS p ,S.order_date,
ROW_NUMBER()OVER(PARTITION BY S.customer_id ORDER BY S.order_date) AS "RN"
FROM sales S
JOIN menu M
ON S.product_id = M.product_id)
SELECT * FROM  first_Order
WHERE RN = 1;

--4-What is the most purchased item on the menu and how many times was it been purchased by all customers?
-- Concepts: TOP, COUNT aggregate, ORDER BY DESC
----------------------------------------------------------------------
SELECT TOP 1 (M.product_name),COUNT (S.product_id) total_purchases FROM sales S
JOIN menu M
ON S.product_id = M.product_id
GROUP BY M.product_name
ORDER BY total_purchases DESC;

--5- Which item was the most popular for each customer?
--Concepts: CTE, RANK window function, PARTITION BY
-- Note: RANK is used so ties are handled (both items returned
--       if a customer ordered two items the same number of times)
----------------------------------------------------------------------
with Customers as (
select S.customer_id,count(*) as total_orders,M.product_name,
Rank()over (partition by customer_id order by count (*) desc) as ranking from sales S
JOIN menu M
ON S.product_id = M.product_id
GROUP BY M.product_name,S.customer_id)
Select * from Customers 
where ranking =1;

--6-Which item was purchased first by the customer after they became a member?
-- Concepts: CTE, ROW_NUMBER, three-table JOIN, date filter
-- Note: ORDER BY order_date ASC gives us the earliest purchase
--       on or after the join date.
----------------------------------------------------------------------
With jion_members as(
select S.product_id ,M.product_name,S.customer_id,S.order_date,J.join_date,
Row_NUMBER()OVER(Partition by S.customer_id Order by order_date desc) as RN
from sales S
JOIN menu M
ON S.product_id = M.product_id
JOIN members J
ON S.customer_id = J.customer_id
WHERE S.order_date > J.join_date)
Select * from jion_members 
where rn=1;

--7-Which item was purchased just before the customer became a member?
-- Concepts: CTE, ROW_NUMBER, date filter (strictly before join)
-- Note: ORDER BY order_date DESC so the row closest to join
--       date gets rn = 1.
----------------------------------------------------------------------
With jion_members as(
select S.product_id ,M.product_name,S.customer_id,S.order_date,J.join_date,
Row_NUMBER()OVER(Partition by S.customer_id Order by S.order_date DESC,S.product_id DESC) as RN
from sales S
JOIN menu M
ON S.product_id = M.product_id
JOIN members J
ON S.customer_id = J.customer_id
WHERE S.order_date < J.join_date)
Select * from jion_members 
where rn=1;

---8-What is the total items and amount spent on each member before they became a member?
-- Concepts: COUNT, SUM, three-table JOIN, date filter
----------------------------------------------------------------------
select Count (S.product_id) total_items,sum (M.price)  total_amount,S.customer_id
from sales S
JOIN menu M
ON S.product_id = M.product_id
JOIN members J
ON S.customer_id = J.customer_id
WHERE S.order_date < J.join_date
group by S.customer_id;

--9-If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- Concepts: CTE, CASE WHEN conditional logic, SUM
----------------------------------------------------------------------
WITH Customer_point1 as(
select S.customer_id,
SUM(case when M.product_name ='sushi'then M.price*20 ELSE M.price*10 END) AS TOTAL_POINTS
FROM menu M
join sales S 
ON S.product_id = M.product_id
GROUP BY S.customer_id)
SELECT * FROM Customer_point1;

--10-.In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
-- Concepts: CASE WHEN, DATEADD, BETWEEN, multi-condition logic
-- Business Rule:
--   • First 7 days after join → all items earn 2× (price × 20)
--   • Sushi always earns 2×
--   • Everything else → 1× (price × 10)
----------------------------------------------------------------------
Select S.customer_id,SUM(Case when S.order_date Between J.join_date and Dateadd(day,6,J.join_date) then M.price*20
when M.product_name='sushi'then M.price*20 ELSE M.price*10 END) AS total_points
from sales S
JOIN menu M
ON S.product_id = M.product_id
JOIN members J
ON S.customer_id = J.customer_id
WHERE S.order_date between '2021-1-1' and '2021-1-31' And S.customer_id in ('A','B')
group by S.customer_id;


--11- --Bonus Question 1
--Join All The Things
--Create a combined table showing all customer orders,
--menu details, and membership status (Y/N)
--at the time of each purchase.
----------------------------------------------------------------------
Select S.customer_id,S.product_id, M.product_name,M.price,S.order_date,J.join_date ,
Case when S.order_date >=J.join_date Then 'Y' ELSE 'N'END  member
from sales S
JOIN menu M
ON S.product_id = M.product_id
LEFT JOIN members J
ON S.customer_id = J.customer_id
ORDER BY S.order_date,S.customer_id ;

--12---Bonus Question 2
--Rank All The Things
--Create a table showing all customer orders
--with a member status (Y/N)
--and a ranking for member purchases only.
--Non-member purchases should have NULL ranking.
----------------------------------------------------------------------
WITH Member_Status AS(
select S.customer_id,S.product_id,M.product_name,M.price,S.order_date,J.join_date,
Case
when S.order_date >= J.join_date Then 'Y' ELSE 'N'END AS "member"
from sales S
JOIN menu M
ON S.product_id = M.product_id
LEFT JOIN members J
ON S.customer_id = J.customer_id),
Member_Rank As(
select *,
case
when "member" ='Y' Then RANK()OVER(Partition by customer_id,"member" Order by order_date) ELSE NULL END AS Ranking 
from Member_Status)
select * from Member_Rank
ORDER BY customer_id,order_date;


