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