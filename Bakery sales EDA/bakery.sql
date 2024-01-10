
--inspect data--

SELECT *
FROM bakery


--drop unnecessarily column--

ALTER TABLE bakery
DROP COLUMN column1

--converting unit_price column to decimal--

UPDATE bakery 
SET unit_price = REPLACE(unit_price, '€', '')

UPDATE bakery
SET unit_price =  LTRIM(RTRIM(unit_price))

UPDATE bakery
SET unit_price = REPLACE(unit_price,',', '.')


ALTER TABLE bakery
ALTER COLUMN unit_price DECIMAL(18,2)


--most profitable products--


WITH top_sold AS (
SELECT article, ROUND(SUM(quantity * unit_price),2) as total, RANK() OVER (ORDER BY SUM(quantity * unit_price) desc) as rnk
FROM bakery
GROUP BY article)

SELECT article, total
FROM top_sold 
WHERE rnk <=10


--sales distribution--


SELECT article, ROUND(SUM(quantity * unit_price),2) as total
FROM bakery
GROUP BY article
ORDER BY total desc


--revenue by month--


SELECT FORMAT(date, 'MMMM yyyy') AS month_year, ROUND(SUM(quantity * unit_price),1) as total_revenue
FROM bakery
GROUP BY FORMAT(date, 'MMMM yyyy') 
ORDER BY total_revenue desc



--revenue by quarter--

SELECT DATEPART(year,date) as year,DATEPART(quarter,date) as quarter, ROUND(SUM(quantity * unit_price),1) as total
FROM bakery
GROUP BY DATEPART(year,date),DATEPART(quarter,date)
ORDER BY total desc



--revenue by day--


SELECT DATENAME(weekday,date) as day, ROUND(SUM(quantity * unit_price),1) as total
FROM bakery
GROUP BY DATENAME(weekday,date)
ORDER BY total desc

---revenue per time of day ---


SELECT FORMAT(transaction_time, 'HH:mm:ss') as time_of_day, ROUND(SUM(quantity * unit_price),1) as total
FROM bakery
GROUP BY transaction_time
ORDER BY total desc




--distribution of sales for the top 4 products by month --


	WITH top4 as (
	SELECT article, SUM(quantity*unit_price) as total_sales, RANK() OVER (ORDER BY SUM(quantity * unit_price) desc) as rnk
	FROM bakery
	GROUP BY article )


	SELECT article, FORMAT(date, 'MMMM-yyyy') as month_year, ROUND(SUM(quantity * unit_price),1) as sales
	FROM bakery 
	WHERE article IN (SELECT article from top4 where rnk <= 4)
	GROUP BY article,FORMAT(date, 'MMMM-yyyy')


--order frequency by day--


SELECT DATENAME(weekday,date) as day, COUNT(DISTINCT ticket_number) as ct
FROM bakery
GROUP BY DATENAME(weekday,date)



--order frequency by month--


SELECT FORMAT(date, 'MMMM yyyy') AS month_year, COUNT(DISTINCT ticket_number) AS ct
FROM  bakery
GROUP BY FORMAT(date, 'MMMM yyyy')
ORDER BY ct desc



-- busiest time of bakery--


SELECT FORMAT(transaction_time, 'HH:mm:ss') as time, COUNT(distinct ticket_number) as no_transactions
FROM bakery
GROUP BY  FORMAT(transaction_time, 'HH:mm:ss')
ORDER BY no_transactions desc



--quantity sold for each product--


SELECT article, SUM(quantity) as quantity
FROM bakery 
GROUP BY article
ORDER BY quantity desc






