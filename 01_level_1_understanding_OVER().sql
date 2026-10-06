-- 1. Number Every Order
-- Scenario:
-- An e-commerce company wants to give every order a sequential number based on when the
-- order was placed.
-- Table:
--     orders
--     order_id customer_id order_date amount
--     101 1 2026-01-03 500
--     102 2 2026-01-05 750
--     103 1 2026-01-07 300
-- Task:
-- Assign a sequential number to every order based on order_date .
-- Concept: ROW_NUMBER()

USE WindowFunctionsPracticeDB;
GO

SELECT
    order_id,
    customer_id,
    order_date,
    amount,
    ROW_NUMBER() OVER (
        ORDER BY order_date, order_id
    ) AS order_row
FROM orders;

-- 2. Number Employees by Salary
-- Scenario:
-- HR wants to number all employees from the highest salary to the lowest salary.
-- Table: employees
-- Task:
-- Assign each employee a number based on salary descending.
-- Concept: ROW_NUMBER() + ORDER BY

SELECT
    employee_id,
    employee_name,
    department,
    salary,
    hire_date,
    ROW_NUMBER() OVER (
        ORDER BY salary DESC
    ) AS salary_row_number
FROM employees;

-- 3. Show Each Employee's Salary and Company Average
-- Scenario:
-- HR wants to compare every employee's salary with the average salary of the entire company.
-- Task:
-- Return:
--     employee_name
--     salary
--     company_average_salary
-- Concept: AVG() OVER()

SELECT
    employee_name,
    salary,
    CAST(
        AVG(salary) OVER (
            PARTITION BY
                employee_name
        ) AS DECIMAL(10, 2)
    ) AS company_average_salary
FROM employees;

-- 4. Show Each Product's Price and Maximum Product Price
-- Scenario:
-- A product manager wants to see every product alongside the highest product price in the
-- catalog.
-- Task:
-- Return:
--  product_name
--  price
--  maximum_price
-- Concept: MAX() OVER()

SELECT
    product_name,
    price,
    MAX(price) OVER () AS maximum_price
FROM products;

-- 5. Show Each Product's Price and Minimum Product Price
-- Scenario:
-- Management wants to compare each product against the cheapest product in the catalog.
-- Task:
-- Return:
-- 	product_name
-- 	price
-- 	minimum_price
-- Concept: MIN() OVER()

SELECT
	product_name,
	price,
	MIN(price) OVER() AS minimum_price
FROM
	products;