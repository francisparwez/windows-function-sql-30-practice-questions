-- 18. Compare Today's Sales With Yesterday's Sales
-- Scenario:
-- A company records daily sales.
-- Task:
-- Show:
--     date
--     sales
--     previous_day_sales
-- Use LAG() .
-- Concept: LAG()

USE WindowFunctionsPracticeDB;
GO

SELECT
    sales_date AS [date],
    sales_amount AS sales,
    LAG(sales_amount, 1) OVER (
        ORDER BY sales_date ASC
    ) AS previous_day_sales
FROM daily_sales;