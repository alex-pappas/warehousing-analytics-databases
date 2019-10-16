--- Get the top 3 product types that have proven most profitable

SELECT product_line, SUM(profit)
FROM product_logs
INNER JOIN fact_table
USING product_code
GROUP BY product_line
ORDER BY SUM(profit) DESC
LIMIT 3;

--- Get the top 3 products by most items sold

SELECT product_name, product_code, SUM(quantity_ordered)
FROM product_logs
INNER JOIN fact_table
USING product_code
GROUP BY product_code
ORDER BY SUM(quantity_ordered) DESC
LIMIT 3;

--- Get the top 3 products by items sold per country of customer for: USA, Spain, Belgium

(SELECT product_name, product_code, SUM(quantity_ordered)
FROM product_logs
INNER JOIN fact_table
USING product_code
INNER JOIN customer_logs
USING customer_number
WHERE country = 'USA'
GROUP BY product_code, country
ORDER BY SUM(quantity_ordered) DESC
LIMIT 3)
UNION ALL
(SELECT product_name, product_code, SUM(quantity_ordered)
FROM product_logs
INNER JOIN fact_table
USING product_code
INNER JOIN customer_logs
USING customer_number
WHERE country = 'Spain'
GROUP BY product_code, country
ORDER BY SUM(quantity_ordered) DESC
LIMIT 3)
UNION ALL
(SELECT product_name, product_code, SUM(quantity_ordered)
FROM product_logs
INNER JOIN fact_table
USING product_code
INNER JOIN customer_logs
USING customer_number
WHERE country = 'Belgium'
GROUP BY product_code, country
ORDER BY SUM(quantity_ordered) DESC
LIMIT 3);

--- Get the most profitable day of the week
SELECT order_day, SUM(profit)
FROM order_logs
INNER JOIN fact_table
USING order_number
GROUP BY order_day
ORDER BY SUM(profit)
LIMIT 1; 

--- Get the top 3 city-quarters with the highest average profit margin in their sales
SELECT city, quarter, AVG(margin)
FROM office_logs
INNER JOIN fact_table
USING office_code
INNER JOIN order_logs
USING order_number
GROUP BY city,quarter
ORDER BY AVG(margin) DESC
LIMIT 3;

-- List the employees who have sold more goods (in $ amount) than the average employee.
SELECT first_name, SUM(revenue)
FROM employee_logs
INNER JOIN fact_table
USING employee_number
GROUP BY employee_number
HAVING SUM(revenue) > (
	SELECT SUM(revenue)/COUNT(DISTINCT employee_number)
	FROM employee_logs
	INNER JOIN fact_table
	USING employee_number);


-- List all the orders where the sales amount in the order is in the top 10% of all order sales amounts (BONUS: Add the employee number)
SELECT order_number, employee_number, SUM(revenue)
FROM fact_table
GROUP BY order_number, employee_number
ORDER BY SUM(revenue) DESC
LIMIT (SELECT COUNT(DISTINCT order_number) FROM facts_table)*0.1;













