-- CREATE NEW TABLE
CREATE TABLE retail_sales_info(
    transaction_id INT PRIMARY KEY,
    sales_date DATE,
    sales_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

--- For Refactoring the existing name of a given column
--- Query:- ALTER TABLE retail_sales_info RENAME COLUMN sales_id TO sales_date;
--- Query:- ALTER TABLE retail_sales_info RENAME COLUMN transactions_id TO transaction_id;

-- Query:- first 50 row records
SELECT * FROM retail_sales_info
LIMIT 50;

-- Query:- count the actual no. of row records
SELECT 
	COUNT(*)
	FROM retail_sales_info;

--- DATA CLEANING
--- TASK-1:- check all columns to verify if they have null row values.

-- Query:- check for null row values in any column.
SELECT * FROM retail_sales_info
WHERE 
	transactions_id IS NULL
	OR
	sales_id IS NULL
	OR
	sales_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

--- TASK-2:- Delete all the row records for columns(quantity, price_per_unit, cogs, total_sale) IS NULL.

DELETE FROM retail_sales_info
WHERE 
	 quantity IS NULL
	 OR
	 price_per_unit IS NULL
	 OR
	 cogs IS NULL
	 OR
	 total_sale IS NULL;

-- Query:- Check the remaining count of row records after deletion of null row records.
SELECT COUNT(*) FROM retail_sales_info;

--- DATA EXPLORATION
--- TASK-1:- Count the number of row-values per column.

-- Query:- How many sales we have?
SELECT COUNT(total_sale) AS total_sales_done
FROM retail_sales_info; 

-- Query:- How many unique customers we have?
SELECT COUNT(DISTINCT(customer_id)) AS num_of_customers
FROM retail_sales_info;

-- Query:- How many unique category we have?
SELECT COUNT(DISTINCT(category)) AS num_of_categories
FROM retail_sales_info;

-- Query:- Display the categories we have available in our store.
SELECT DISTINCT category FROM retail_sales_info;

--- DATA ANALYSIS & BUSINESS KEY PROBLEMS AND ANSWERS

-- Query-1:- Write a SQL query to retrieve all columns for sales made on '2022-11-05.
SELECT * FROM retail_sales_info
WHERE sales_date = '2022-11-05';

-- Query-2:- Write a SQL query to retrieve all transactions where the category is 'Clothing' and
--   		 the quantity sold is more than or equals 4 in the month of Nov-2022.
SELECT
	 *
FROM 
	retail_sales_info
WHERE 
	category = 'Clothing'
	AND
	TO_CHAR(sales_date, 'YYYY-MM') = '2022-11'
	AND
	quantity >= 4;

-- Query-3:- Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
	category,
	SUM(total_sale) AS net_sale,
	COUNT(transaction_id) AS total_orders
FROM retail_sales_info
GROUP BY 1;

-- Query-4:- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT
	 ROUND(AVG(age), 2) AS average_customer_age
FROM 
	retail_sales_info
WHERE
	category = 'Beauty';
 
-- Query-5:- Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT 
	*
FROM
	retail_sales_info
WHERE
	total_sale > 1000;

-- Query-6:- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT
	category,
	gender,
	COUNT(DISTINCT(transaction_id)) AS num_of_transactions
FROM
	retail_sales_info
GROUP BY category, gender
ORDER BY 1;

-- Query-7:- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
-- Tip:- the 1, 2 are the column numbers in the GROUP BY and ORDER BY clause.
-- Seperate the queries and run them individually and in combine subquery.
SELECT 
	year,
	month,
	average_sale
FROM
(
	SELECT
		EXTRACT(YEAR FROM sales_date) AS year,
		EXTRACT(MONTH FROM sales_date) AS month,
		AVG(total_sale) AS average_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sales_date) ORDER BY AVG(total_sale) DESC)
	FROM 
		retail_sales_info
	GROUP BY 1, 2
) AS best_selling_month
WHERE rank = 1;

-- Query-8:- Write a SQL query to find the top 5 customers based on the highest total sales.

SELECT 
	customer_id AS customer,
	SUM(total_sale) AS total_sales
FROM 
	retail_sales_info
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Query-9:- Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
	category,
	COUNT(DISTINCT customer_id) AS num_of_unique_customers
FROM
	retail_sales_info
GROUP BY category;

-- Query-10:- Write a SQL query to create each shift and number of orders (Example Morning < 12, Afternoon Between 12 & 17, Evening >17).
-- Using case-statements AND common table expression(CTE)

WITH hourly_sales
AS (
	SELECT
		*,
		CASE
			WHEN EXTRACT(HOUR FROM sales_time) < 12 THEN 'Morning-shift'
			WHEN EXTRACT(HOUR FROM sales_time) BETWEEN 12 AND 17 THEN 'Afternoon-shift'
			ELSE 'Evening-shift'
		END AS shift
	FROM retail_sales_info
)
SELECT
	shift,
	COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift;
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	














-- Query:- check for null values in customer_id column.
SELECT * FROM 
