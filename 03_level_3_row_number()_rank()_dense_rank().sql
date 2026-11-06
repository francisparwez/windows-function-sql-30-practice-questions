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
    salary_rank <= 3

-- 13. Rank Products by Sales
-- Scenario:
-- A retailer wants to rank products based on total sales.
-- Task:
-- Rank products from highest sales to lowest sales.
-- Concept: RANK()

USE WindowFunctionsPracticeDB;
GO

WITH ProductSales AS (
    SELECT
        p.product_id,
        p.product_name,
        SUM(o.amount) AS total_sales
    FROM dbo.orders o
    INNER JOIN dbo.products p
        ON o.product_id = p.product_id
    GROUP BY
        p.product_id,
        p.product_name
),
RankedProducts AS (
    SELECT
        product_id,
        product_name,
        total_sales,
        RANK() OVER (
            ORDER BY total_sales DESC
        ) AS sales_rank
    FROM ProductSales
)
SELECT
    product_id,
    product_name,
    total_sales,
    sales_rank
FROM RankedProducts
ORDER BY sales_rank;