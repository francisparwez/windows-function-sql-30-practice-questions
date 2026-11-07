-- 11. Find the Highest-Paid Employee
-- Scenario:
--     HR wants to identify the employee with the highest salary.
-- Task:
--     Use a window function to assign rankings and identify the highest-paid employee.
-- Concept: ROW_NUMBER()

USE WindowFunctionsPracticeDB;
GO

WITH
    RankedEmployees AS (
        SELECT
            employee_id,
            employee_name,
            department,
            salary,
            ROW_NUMBER() OVER (
                ORDER BY salary DESC
            ) AS salary_rank
        FROM employees
    )
SELECT
    employee_id,
    employee_name,
    department,
    salary
FROM RankedEmployees
WHERE
    salary_rank = 1;

-- 12. Find the Top 3 Highest-Paid Employees
-- Scenario:
--     Management wants to identify the three highest-paid employees.
-- Task:
--     Rank employees by salary and return the top 3.
-- Concept: ROW_NUMBER()

SELECT
    TOP 3 employee_id,
    employee_name,
    department,
    salary,
    ROW_NUMBER() OVER (
        ORDER BY salary DESC
    ) AS salary_rank
FROM employees
ORDER BY salary_rank;

-- 13. Rank Products by Sales
-- Scenario:
-- A retailer wants to rank products based on total sales.
-- Task:
-- Rank products from highest sales to lowest sales.
-- Concept: RANK()

USE WindowFunctionsPracticeDB;
GO

SELECT
    p.product_id,
    p.product_name,
    SUM(o.amount) AS total_sales,
    RANK() OVER (
        ORDER BY SUM(o.amount) DESC
    ) AS sales_rank
FROM dbo.orders o
    INNER JOIN dbo.products p ON o.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY sales_rank;

-- 14. Rank Customers by Spending
-- Scenario:
-- A loyalty program wants to rank customers based on their total spending.
-- Task:
-- Rank customers from highest spender to lowest spender.
-- Concept: RANK()

USE WindowFunctionsPracticeDB;
GO

SELECT
    c.customer_id,
    c.customer_name,
    SUM(o.amount) AS total_spending,
    RANK() OVER (
        ORDER BY SUM(o.amount) DESC
    ) AS spending_rank
FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY spending_rank;

-- 15. Understand Tied Rankings
-- Consider:
--     Salary
--     100000
--     90000
--     90000
--     80000
-- Task:
-- Rank these salaries using:
--     1. RANK()
--     2. DENSE_RANK()
-- Then observe the difference.
-- Concept: Understanding RANK() vs DENSE_RANK()

USE WindowFunctionsPracticeDB;
GO

SELECT
    salary,
    RANK() OVER (
        ORDER BY salary DESC
    ) as salary_rank,
    DENSE_RANK() OVER (
        ORDER BY salary DESC
    ) as salary_dense_rank
FROM employees
ORDER BY salary DESC;