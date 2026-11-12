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

-- 16. Rank Employees Within Departments
-- Scenario:
--     Each department wants its own salary leaderboard.
-- Task:
--     Rank employees by salary within each department.
-- Example:
--     IT
--     John 100k → 1
--     Ali 90k → 2
--     HR
--     Sarah 80k → 1
--     Emma 70k → 2
-- Concept: RANK() + PARTITION BY

USE WindowFunctionsPracticeDB;
GO

SELECT
    department,
    employee_id,
    employee_name,
    salary,
    DENSE_RANK() OVER (
        PARTITION BY
            department
        ORDER BY salary DESC
    ) AS dept_salary_dense_rank,
    RANK() OVER (
        PARTITION BY
            department
        ORDER BY salary DESC
    ) AS dept_salary_rank
FROM employees
ORDER BY department, salary DESC;

-- 17. Find the Highest-Paid Employee in Each Department
-- Scenario:
-- HR wants to identify the highest-paid employee from every department.
-- Task:
-- Use a window function to rank employees within departments and return rank 1.
-- Concept: RANK() + PARTITION BY

USE WindowFunctionsPracticeDB;
GO

SELECT
    employee_id,
    employee_name,
    department,
    salary,
    salary_rank
FROM (
        SELECT
            employee_id, employee_name, department, salary, DENSE_RANK() OVER (
                PARTITION BY
                    department
                ORDER BY salary DESC
            ) AS salary_rank
        FROM employees
    ) AS RankedEmployees
WHERE
    salary_rank = 1;