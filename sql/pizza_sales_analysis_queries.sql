-----------------------------------------
-----------------------------------------
PIZZA SALES ANALYSIS PROJECT (SQL + POWER BI)
AUTHOR: Shubham Kumar Bhakta
-----------------------------------------
-----------------------------------------
--Create Table pizza_Sales before importing the data from CSV File

CREATE TABLE pizza_sales (
    pizza_id INT,
    order_id INT,
    pizza_name_id VARCHAR(50),
    quantity INT,
    order_date DATE,
    order_time TIME,
    unit_price NUMERIC(6,2),
    total_price NUMERIC(6,2),
    pizza_size VARCHAR(50),
    pizza_category VARCHAR(50),
    pizza_ingredients VARCHAR(200),
    pizza_name VARCHAR(200)
);

--Data Exploration
SELECT * FROM pizza_sales LIMIT 10;

-- Row count
SELECT COUNT(*) FROM pizza_sales;
--48620 rows

--Column Exploration
SELECT DISTINCT pizza_category FROM pizza_sales;

SELECT DISTINCT pizza_size FROM pizza_sales;

--Null OR missing values check
SELECT * FROM pizza_sales
WHERE order_id IS NULL
   OR pizza_name IS NULL;

--Duplicate values check
SELECT order_id, COUNT(*) FROM pizza_sales
GROUP BY order_id
HAVING COUNT(*) > 1;

--Date range check
SELECT MIN(order_date), MAX(order_date)
FROM pizza_sales;

----------------KPIs---------------

--TOTAL REVENUE
SELECT sum(total_price) as total_revenue
FROM pizza_sales;

--AVERAGE ORDER VALUE
SELECT 
round(sum(total_price) / COUNT(DISTINCT order_id),2) as avg_order_value 
FROM pizza_sales;

--TOTAL PIZZAS SOLD
SELECT sum(quantity) as total_pizza_sold 
FROM pizza_sales;

--TOTAL ORDERS
SELECT count(DISTINCT order_id) as total_orders
FROM pizza_sales

--AVG PIZZA PER ORDER
SELECT CAST(CAST(sum(quantity) AS DECIMAL(10,2)) / 
       CAST(count(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2)) as avg_pizza_per_order
FROM pizza_sales

--------------CHARTS---------------

--DAILY TREND FOR TOTAL ORDERS
SELECT TO_CHAR(order_date, 'FMDay') as dayname,
       count(DISTINCT order_id) as total_orders
  FROM pizza_sales
  GROUP BY TO_CHAR(order_date, 'FMDay')
  ORDER BY total_orders DESC;

-- HOURLY TREND FOR TOTAL ORDERS
SELECT EXTRACT(HOUR FROM order_time) as hour,
       count(DISTINCT order_id) as total_orders
  FROM pizza_sales
  GROUP BY hour 
  ORDER BY hour;

-- MONTHLY TREND FOR TOTAL ORDERS
SELECT TO_CHAR(order_date, 'FMMonth') as mon_name,
       count(DISTINCT order_id) as total_orders
  FROM pizza_sales
  GROUP BY TO_CHAR(order_date, 'FMMonth')
  ORDER BY total_orders DESC;

-- PERCENTAGE SALES BY PIZZA CATEGORY
SELECT pizza_category, sum(total_price) as total_sales,
      ROUND(sum(total_price) * 100 / (SELECT sum(total_price) FROM pizza_sales),2) as pct
FROM pizza_sales
GROUP BY pizza_category
ORDER BY pct DESC ;

-- PERCENTAGE SALES BY PIZZA SIZE
SELECT pizza_size, sum(total_price) as total_sales,
    ROUND(sum(total_price) * 100 / (SELECT sum(total_price) FROM pizza_sales),2) as PCT
FROM pizza_sales
GROUP BY pizza_size
ORDER BY PCT DESC;

-- TOTAL PIZZA SOLD PER PIZZA CATEGORY
SELECT pizza_category, sum(quantity) as totalpizza_sold
FROM pizza_sales
GROUP BY pizza_category
ORDER BY totalpizza_sold DESC;

-- TOP 5 Best sellers by Revenue
SELECT pizza_name, sum(total_price) as total_revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_revenue DESC
LIMIT 5;

-- BOTTOM 5 sellers by Revenue
SELECT pizza_name, sum(total_price) as total_revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_revenue ASC
LIMIT 5;

--Top 5 pizza sellers by quantity
SELECT pizza_name, sum(quantity) as total_quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_quantity DESC
LIMIT 5;

-- Bottom 5 pizza sellers by quantity
SELECT pizza_name, sum(quantity) as total_quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_quantity ASC
LIMIT 5;

-- TOP 5 Pizzas by Orders
SELECT pizza_name, count(DISTINCT order_id) as total_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_orders DESC
LIMIT 5;

-- Bottom 5 Pizzas by Orders
SELECT pizza_name, count(DISTINCT order_id) as total_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_orders ASC
LIMIT 5;
