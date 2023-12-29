
-- dataset was downloaded from kaggle, it contains sales info from a pizza restaurant --
-- the data spreads across 4 tables, order_details, orders, pizza_types and pizzas --

-- we will answer the following questions --

-- What is the total revenue of the restaurant?--
-- Which are the best selling pizzas? --
-- Which pizzas generate the highest and lowest revenue? --
-- When is the restaurant the busiest? --
-- what is the Average revenue of each order? --
-- Which are the most populr pizza toppings? -- 
-- Distribue the revenue per category. --
-- Is there a favourite pizza size? --
-- How many pizzas are in a order? --

-- find the total total revenue--


SELECT COUNT(*) as total_orders, SUM(od.quantity) as total_pizzas_sold, ROUND(SUM(od.quantity * p.price),1) as total_revenue

FROM order_details od
JOIN pizzas p 
ON  od.pizza_id = p.pizza_id



-- find the top 10 best selling pizzas --

WITH top10 as (
SELECT  py.name,SUM(od.quantity) as total_sold, rank() OVER (ORDER BY  SUM(od.quantity) desc) as rnk

FROM order_details od 
JOIN  pizzas p
ON od.pizza_id = p.pizza_id
JOIN  pizza_types py
ON p.pizza_type_id = py.pizza_type_id

GROUP BY py.name
)

SELECT name, total_sold 
FROM top10 
WHERE rnk <=10



---pizzas with highest revenue generated---

WITH highest_revenue AS(

SELECT p.pizza_type_id AS name, COUNT(*) as total_orders, ROUND(SUM(od.quantity * p.price),1) as total_revenue, RANK() OVER (ORDER BY SUM(od.quantity * p.price) desc) as rnk
		

FROM order_details od
JOIN pizzas p 
ON  od.pizza_id = p.pizza_id

GROUP BY 		p.pizza_type_id
)

SELECT name, total_orders, total_revenue
FROM highest_revenue 
WHERE rnk <=10


---pizzas with lowest revenue generated---
WITH lowest_revenue AS(

SELECT p.pizza_type_id AS name, COUNT(*) as total_orders, ROUND(SUM(od.quantity * p.price),1) as total_revenue, RANK() OVER (ORDER BY SUM(od.quantity * p.price) ) as rnk
		

FROM order_details od
JOIN pizzas p 
ON  od.pizza_id = p.pizza_id

GROUP BY 		p.pizza_type_id
)

SELECT name, total_orders, total_revenue
FROM lowest_revenue 
WHERE rnk <=10



--distribution of total sales per month--

SELECT  MONTH(o.date) as month, COUNT(*) as no_orders, ROUND(SUM(od.quantity * p.price), 1) as total_revenue
FROM order_details od
JOIN pizzas p 
ON  od.pizza_id = p.pizza_id
JOIN orders o
ON od.order_id = o.order_id

GROUP BY MONTH(o.date)
ORDER BY total_revenue desc



-- revenue by day of week --

SELECT  datename(weekday,date) as day, ROUND(SUM(od.quantity * p.price), 1) as total_revenue,  COUNT(DISTINCT od.order_id) as total_orders
FROM order_details od
JOIN pizzas p 
ON  od.pizza_id = p.pizza_id
JOIN orders o
ON od.order_id = o.order_id

GROUP BY datename(weekday,date)
ORDER BY total_revenue desc



--distribution of orders per day  --



SELECT date, COUNT(*) no_orders

FROM order_details od
JOIN orders o
ON od.order_id = o.order_id

GROUP BY date
ORDER BY no_orders desc



--distribution of orders per hour --


SELECT  DATEPART(HOUR,o.time) as hour,count(DISTINCT od.order_id) as total_orders, SUM(od.quantity) as quantity_ordered
FROM order_details od
JOIN pizzas p 
ON  od.pizza_id = p.pizza_id
JOIN orders o
ON od.order_id = o.order_id

GROUP BY DATEPART(HOUR,o.time)
ORDER BY total_orders desc



--average order value--


 SELECT ROUND(AVG(od.quantity * p.price),2) as average_value

FROM order_details od 
JOIN pizzas p 
ON od.pizza_id = p.pizza_id 




-- finding most popular pizza toppings -- 


SELECT py.ingredients AS topping, COUNT(*) AS topping_count
FROM
    pizzas p
JOIN pizza_types py ON p.pizza_type_id = py.pizza_type_id

GROUP BY
    py.ingredients
ORDER BY
    topping_count desc


--total orders and revenue per category--


SELECT py.category, COUNT(od.order_details_id) total_orders, ROUND(SUM(od.quantity * p.price),1) as revenue
FROM order_details od 
JOIN  pizzas p
ON od.pizza_id = p.pizza_id
JOIN  pizza_types py
ON p.pizza_type_id = py.pizza_type_id

GROUP BY py.category
ORDER BY total_orders desc




-- most popular pizza size --

SELECT p.size, COUNT(od.order_details_id) total_orders
FROM order_details od 
JOIN  pizzas p
ON od.pizza_id = p.pizza_id
JOIN  pizza_types py
ON p.pizza_type_id = py.pizza_type_id

GROUP BY p.size
ORDER BY total_orders desc




-- quantity of pizzas per order --

SELECT quantity, COUNT(*) no_pizzas
FROM order_details 

GROUP BY quantity
ORDER BY no_pizzas desc