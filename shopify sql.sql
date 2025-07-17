create database shopify_db;

use shopify_db;

create table shopify(
Admin_Graphql_Api_Id varchar(50),
Order_Number bigint primary key,	
Billing_Address_Country	varchar(20),
Billing_Address_First_Name	varchar(50),
Billing_Address_Last_Name	varchar(50),
Billing_Address_Province	varchar(50),
Billing_Address_Zip	bigint,
CITY	varchar(50),
Currency varchar(10),
Customer_Id bigint,	
Invoice_Date datetime,
Gateway	varchar(30),
Product_Id	bigint,
Product_Type varchar(40),	
Variant_Id bigint,	
Quantity tinyint,
Subtotal_Price	mediumint,
Total_Price_Usd	mediumint,
Total_Tax mediumint
);

alter table shopify modify invoice_date date;

desc shopify;

-- truncate table shopify;

select count(*) from shopify;

--  Basic (Level 1) – Business KPIs & Overview 
-- These help understand basic operations, totals, and customers.

-- Q1. How many total orders have been placed?

select count(order_number) as Total_order
from shopify;

-- Q2. What is the total revenue generated (in USD)?

select sum(total_price_usd) as Total_Revenue
from shopify;

-- Q3. How many unique customers have made a purchase?

select count(distinct customer_id ) as unique_customer
from shopify;

-- Q4. Which country has the highest number of orders?

select billing_address_country, count(*) as Total_orders
from shopify
group by billing_address_country;

-- Q5. What is the total tax collected?

select sum(Total_tax) as total_tax
from shopify;

-- Q6. What is the most sold product (by quantity)?

select product_type, sum(quantity) as total_quantity
from shopify
group by 1
order by sum(quantity) desc;

-- Business Value: Understand revenue, top products, customer base, and tax compliance.



-- Intermediate (Level 2) – Product & Customer Insights
-- These help identify patterns and guide product/customer strategy.

-- Q1. Which product type has generated the highest revenue?

select product_type, sum(total_price_usd) as total_quantity
from shopify
group by 1
order by sum(total_price_usd) desc;

-- Q2. What is the average order value (AOV)?

select avg(total_price_usd) as AOV
from shopify;

-- Q3. Which province or city has the highest revenue per order?

select billing_address_province, SUM(total_price_usd) as revenue
from shopify
group by billing_address_province
order by SUM(total_price_usd) desc;

-- Q4. How many returning customers placed more than 1 order?

select customer_id, count(*) as place_order
from shopify
group by customer_id
having count(*) > 1
order by count(*) desc;

-- Q5. Which payment gateways are used most often?

select gateway, count(*) as no_of_gateway
from shopify
group by 1
order by 2 desc;

-- Q6. In which month was the highest revenue generated?

select monthname(invoice_date) as month , sum(total_price_usd) as revenue_by_month
from shopify
group by 1;

--  Business Value: Helps marketing teams target top locations, upsell to repeat buyers, and choose payment options that convert best.

--  Advanced (Level 3) – Optimization & Growth
-- These are used to optimize pricing, operations, and business growth.

-- Q1. Which product variants are performing best (based on profit per unit)?

select Product_type, (sum(total_price_usd)/sum(quantity)) as revenue_per_unit
from shopify
group by 1
order by 2 desc;

-- Q2. Which customers contributed to the top 10% of revenue?

with top_10_customer as(
select customer_id,
       sum(total_price_usd) as customer_spent,
       row_number() over(order by sum(total_price_usd) desc) as ranking
from shopify
group by 1)
select * 
from top_10_customer
where ranking <= (select count( distinct customer_id) from shopify) * 0.10;


-- Q2. Are there any customers who made high-value purchases but only once?

select customer_id, sum(total_price_usd) ,count(*) as orders
from shopify
group by 1
having  count(*) = 1
order by 2 desc;

-- Q4. What is the monthly revenue growth rate over the last 6 months?

with monthly_revenue as (
select date_format(invoice_date, "%Y-%M") as month , sum(total_price_usd) as total_revenue
from shopify
where invoice_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 6 MONTH)
group by 1)
select *,
       lag(total_revenue) over(order by month) as pm_revenue,
       round(((total_revenue -  lag(total_revenue) over(order by month)) / lag(total_revenue) over(order by month)),2) as monthly_growth
from monthly_revenue;

-- Q5. Which  have high order volume but low revenue per order?

select billing_address_province,
       count(order_number) as order_valume , 
	   sum(total_price_usd) as total_revenue,
       ROUND(SUM(total_price_usd) / COUNT(order_number), 2) AS revenue_per_order
from shopify
group by 1
order by 2 desc, 3 asc;

select * from shopify;

-- Q6. Identify possible fraud cases where multiple orders were made to the same zip code with different customer IDs.

select distinct billing_address_zip ,
	   count(distinct customer_id) as customer, 
       count(*) as total_orders
from shopify
group by 1
having count(distinct customer_id)  > 1;

-- 🔎 Business Value: Supports customer segmentation, churn detection, fraud prevention, and revenue forecasting.


