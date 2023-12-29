

--USA CAR SALES--


--inspecting dataset--

SELECT *
FROM car_sales

SELECT Count(*)
FROM car_sales

SELECT Count(*) 
FROM information_schema.columns
WHERE table_name = 'car_sales'

-- There are 157 entries in the database and 16 columns




--find top manufacturer by sales--

WITH top_sales as (
SELECT manufacturer, CAST(Sum(sales_in_thousands) AS decimal (10,3)) AS total_sales, RANK()OVER(Order by Sum(sales_in_thousands) desc) AS rnk
FROM car_sales
Group by manufacturer
)

SELECT manufacturer, total_sales 
FROM top_sales 
WHERE rnk <= 10


-- how many models does each manufacture produce in this dataset? --

SELECT  manufacturer, Count(model) as no_models
FROM car_sales 
Group by manufacturer
Order by no_models desc

--manufacturer distribution--

SELECT manufacturer, COUNT(*)
FROM car_sales
Group by manufacturer


--distribution of vehicle types--
SELECT vehicle_type, Count(*) AS no_vehicles
FROM car_sales
Group by vehicle_type

SELECT vehicle_type,CAST(AVG(price_in_thousands) AS decimal (10,3)) AS average_price, Count(*) AS no_vehicles
FROM car_sales
Group by vehicle_type



--what is the average resale value per manufacturer--

SELECT manufacturer, CAST(AVG(year_resale_value) AS decimal (10,3)) AS average_resale_value_in_thousands
FROM car_sales 
Where year_resale_value IS NOT NULL
Group by manufacturer
Order by average_resale_value_in_thousands DESC



--distribution of fuel efficiency--

SELECT fuel_efficiency, Count(*) AS no_vehicles
FROM car_sales 
Where fuel_efficiency IS NOT NULL
Group by fuel_efficiency


--price to fuel efficiency--
SELECT CAST(price_in_thousands AS decimal(10,2)) AS price_in_thousands, fuel_efficiency
FROM car_sales 
WHERE price_in_thousands IS NOT NULL AND fuel_efficiency IS NOT NULL


--average vehicle price per manufacturer--

SELECT manufacturer, CAST(AVG(price_in_thousands)AS decimal(10,2)) AS avg_price
FROM car_sales 
Group by manufacturer


--relation between engine size and horsepower --

SELECT CAST(engine_size AS decimal (10,2)) AS engine_size, horsepower
FROM car_sales


--relation between engine size and price--

SELECT CAST(engine_size AS decimal (10,2)) AS engine_size, CAST(AVG(price_in_thousands) AS decimal (10,2)) AS price_in_thousands
FROM car_sales 
WHERE engine_size IS NOT NULL
Group by engine_size




--distribution of horsepower over manufacturers ---

SELECT manufacturer,MIN(horsepower) AS min_horsepower,MAX(horsepower) AS max_horsepower,AVG(horsepower) AS avg_horsepower,COUNT(*) AS num_models
FROM car_sales
Where
    horsepower IS NOT NULL
Group by
    manufacturer
Order by manufacturer
    
SELECT manufacturer, AVG(horsepower) AS avg_horsepower
FROM car_sales 
Group by manufacturer
--distributions --

SELECT sales_in_thousands
FROM car_sales
Order by sales_in_thousands DESC


SELECT price_in_thousands
FROM car_sales
Order by price_in_thousands DESC


SELECT engine_size
FROM car_sales
Order by engine_size DESC


SELECT horsepower
FROM car_sales
Order by horsepower DESC

SELECT length
FROM car_sales 
Order by length DESC


SELECT curb_weight
FROM car_sales 
Order by length DESC


SELECT fuel_capacity
FROM car_sales 
Order by fuel_capacity  DESC

SELECT fuel_efficiency
FROM car_sales
Order by fuel_efficiency DESC

--horsepower range by manufacturer--
SELECT manufacturer, horsepower
FROM car_sales

-- replaced null value in horsepower with average of column --
DECLARE @average smallint
SELECT @average = AVG(horsepower)
FROM car_sales
WHERE horsepower IS NOT NULL

UPDATE car_sales
SET horsepower = Coalesce(horsepower, @average)


--maximum and minimum price of each manufacturer vehicle--
SELECT manufacturer,  CAST(MAX(price_in_thousands) AS DECIMAL(10, 3)) AS max_price, CAST(MIN(price_in_thousands) AS DECIMAL(10, 3)) AS min_price
FROM car_sales 
Group by manufacturer

--difference between max and min price --
WITH price_diff AS (
SELECT manufacturer, CAST(MAX(price_in_thousands) AS DECIMAL(10, 3)) AS max_price, CAST(MIN(price_in_thousands) AS DECIMAL(10, 3)) AS min_price
FROM car_sales 
Group by manufacturer)

SELECT manufacturer, max_price - min_price AS difference
FROM price_diff

--latest launches--
SELECT manufacturer, model, latest_launch
FROM car_sales
ORDER BY latest_launch DESC


--top 10 vehicles with highest depreciation rate --

WITH highest_depreciation AS (
SELECT manufacturer, model,CAST(price_in_thousands - year_resale_value AS decimal (10,3)) AS resale_difference,
		RANK() OVER (Order by price_in_thousands - year_resale_value DESC) AS rnk
FROM  car_sales
WHERE year_resale_value IS NOT NULL AND Price_in_thousands IS NOT NULL)


SELECT manufacturer, model, resale_difference
FROM highest_depreciation
WHERE rnk <=10

--top 10 vehicles with lowest depreciation rate --


WITH lowest_depreciation AS (
SELECT manufacturer, model,CAST(price_in_thousands - year_resale_value AS decimal (10,3)) AS resale_difference,
		RANK() OVER (Order by price_in_thousands - year_resale_value ) AS rnk
FROM  car_sales
WHERE year_resale_value IS NOT NULL AND Price_in_thousands IS NOT NULL)


SELECT manufacturer, model, resale_difference
FROM lowest_depreciation
WHERE rnk <=10


--revenue of each manufacturer--

SELECT manufacturer, CAST(SUM(sales_in_thousands * price_in_thousands )AS decimal (10,3)) AS revenue
FROM car_sales
Group by manufacturer
Order by revenue desc



--manufacturer market share --


WITH manufacture_revenue AS (
   SELECT manufacturer, CAST(Sum(sales_in_thousands * price_in_thousands)AS decimal (10,3)) AS revenue
	FROM car_sales
	Group by manufacturer

)

SELECT
    manufacturer,revenue,
    CAST((revenue / (SELECT Sum(revenue) FROM manufacture_revenue)) * 100 AS decimal (10,3)) AS market_share
FROM manufacture_revenue
    
Order by market_share desc





