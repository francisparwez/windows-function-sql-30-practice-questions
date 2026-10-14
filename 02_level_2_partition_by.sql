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
		employee_id,
		employee_name,
		department,
		salary,
		RANK() OVER(
		PARTITION BY department
		ORDER BY salary DESC
		) rnk
	FROM employees
) AS salary_rank
WHERE rnk = 1;