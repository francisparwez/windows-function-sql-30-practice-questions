-- 🟢 LEVEL 2 — PARTITION BY
-- 6. Number Orders for Each Customer
-- Scenario:
--	A company wants to know the order sequence for every customer.
-- Task:
--	For each customer, number their orders based on order_date .
-- Example:
--	Customer 101
--	Order 1
--	Order 2
--	Order 3
--	Customer 102
--	Order 1
--	Order 2
-- Concept:
--	ROW_NUMBER() + PARTITION BY

USE WindowFunctionsPracticeDB;
GO

SELECT
    o.customer_id,
    o.order_id,
    o.order_date,
    o.amount,
    ROW_NUMBER() OVER (
        PARTITION BY
            o.customer_id
        ORDER BY o.order_date, o.order_id
    ) AS customer_order_number
FROM orders o;

-- 7. Rank Employees Within Each Department
-- Scenario:
--     HR wants to know who has the highest salary within each department.
-- Task:
--     Rank employees by salary within their department.
-- Concept: RANK() + PARTITION BY

SELECT
    employee_id,
    employee_name,
    department,
    salary
FROM (
        SELECT
            employee_id, employee_name, department, salary, RANK() OVER (
                PARTITION BY
                    department
                ORDER BY salary DESC
            ) rnk
        FROM employees
    ) AS salary_rank
WHERE
    rnk = 1;

-- 8. Number Products Within Each Category
-- Scenario:
-- 	An e-commerce company has multiple product categories.
-- Task:
-- 	Number products from most expensive to least expensive within each category.
-- Concept:
-- 	ROW_NUMBER() + PARTITION BY

SELECT
    product_id,
    product_name,
    category,
    price,
    ROW_NUMBER() OVER (
        PARTITION BY
            category
        ORDER BY price desc
    ) AS product_rank_within_category
FROM products;

-- 9. Average Salary by Department
-- Scenario:
-- 	HR wants every employee's salary displayed alongside the average salary of their
-- 	department.
-- Task:
-- Return:
-- 	employee
-- 	department
-- 	salary
-- 	department_average_salary
-- Concept: AVG() OVER(PARTITION BY ...)

SELECT
    employee_name AS employee,
    department,
    salary,
    CAST(
        AVG(salary) OVER (
            PARTITION BY
                department
        ) AS DECIMAL(10, 2)
    ) AS department_average_salary
FROM employees;

-- MOVING AVERAGE (OUT OF SCOPE QUESTION)

SELECT
    employee_name AS employee,
    department,
    salary,
    CAST(
        AVG(salary) OVER (
            PARTITION BY
                department
            ORDER BY
                hire_date,
                employee_id ROWS BETWEEN 2 PRECEDING
                AND CURRENT ROW
        ) AS DECIMAL(10, 2)
    ) AS moving_average_salary
FROM employees;