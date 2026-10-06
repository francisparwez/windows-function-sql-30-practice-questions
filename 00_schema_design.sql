/* ============================================================
SQL WINDOW FUNCTIONS - BEGINNER PRACTICE DATABASE
SQL Server / T-SQL
Designed for the 30 beginner questions supplied by the user.
Every main practice table contains 50+ records.

Main entities:
customers       = 60
employees       = 60
products        = 60
orders          = 180
daily_sales     = 90
monthly_revenue = 60
price_history   = 60

The data intentionally contains:
- repeated salaries for RANK vs DENSE_RANK
- multiple departments/categories/customers
- repeated customer orders
- chronological order history
- daily and monthly sales
- changing product prices
============================================================ */

IF DB_ID (N'WindowFunctionsPracticeDB') IS NULL BEGIN
CREATE DATABASE WindowFunctionsPracticeDB;

END;
GO

USE WindowFunctionsPracticeDB;
GO

/* -------------------------
DROP TABLES
------------------------- */
DROP TABLE IF EXISTS dbo.price_history;

DROP TABLE IF EXISTS dbo.orders;

DROP TABLE IF EXISTS dbo.products;

DROP TABLE IF EXISTS dbo.daily_sales;

DROP TABLE IF EXISTS dbo.monthly_revenue;

DROP TABLE IF EXISTS dbo.employees;

DROP TABLE IF EXISTS dbo.customers;
GO

/* ============================================================
1. CUSTOMERS - 60 records
============================================================ */
CREATE TABLE dbo.customers (
    customer_id INT NOT NULL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    signup_date DATE NOT NULL
);
GO

;
WITH
    n AS (
        SELECT TOP (60) ROW_NUMBER() OVER (
                ORDER BY (
                        SELECT NULL
                    )
            ) AS n
        FROM sys.all_objects a
            CROSS JOIN sys.all_objects b
    )
INSERT INTO
    dbo.customers (
        customer_id,
        customer_name,
        city,
        signup_date
    )
SELECT
    n,
    CONCAT('Customer ', n),
    CASE ((n - 1) % 6)
        WHEN 0 THEN 'Karachi'
        WHEN 1 THEN 'Lahore'
        WHEN 2 THEN 'Islamabad'
        WHEN 3 THEN 'Rawalpindi'
        WHEN 4 THEN 'Faisalabad'
        ELSE 'Multan'
    END,
    DATEADD (
        DAY,
        - (n * 5),
        CAST('2026-06-30' AS DATE)
    )
FROM n;
GO

/* ============================================================
2. EMPLOYEES - 60 records
Includes duplicate salaries intentionally for RANK/DENSE_RANK.
============================================================ */
CREATE TABLE dbo.employees (
    employee_id INT NOT NULL PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL,
    salary DECIMAL(12, 2) NOT NULL,
    hire_date DATE NOT NULL
);
GO

;
WITH
    n AS (
        SELECT TOP (60) ROW_NUMBER() OVER (
                ORDER BY (
                        SELECT NULL
                    )
            ) AS n
        FROM sys.all_objects a
            CROSS JOIN sys.all_objects b
    )
INSERT INTO
    dbo.employees (
        employee_id,
        employee_name,
        department,
        salary,
        hire_date
    )
SELECT
    n,
    CONCAT('Employee ', n),
    CASE ((n - 1) % 5)
        WHEN 0 THEN 'IT'
        WHEN 1 THEN 'HR'
        WHEN 2 THEN 'Finance'
        WHEN 3 THEN 'Sales'
        ELSE 'Marketing'
    END,
    CASE
    /* Deliberate ties */
        WHEN n IN (1, 6, 11, 16, 21) THEN 90000
        WHEN n IN (2, 7, 12, 17, 22) THEN 80000
        WHEN n IN (3, 8, 13, 18, 23) THEN 70000
        WHEN n IN (4, 9, 14, 19, 24) THEN 60000
        ELSE 50000 + ((n * 2500) % 30001)
    END,
    DATEADD (
        DAY,
        - (n * 12),
        CAST('2026-06-30' AS DATE)
    )
FROM n;
GO

/* ============================================================
3. PRODUCTS - 60 records
============================================================ */
CREATE TABLE dbo.products (
    product_id INT NOT NULL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);
GO

;
WITH
    n AS (
        SELECT TOP (60) ROW_NUMBER() OVER (
                ORDER BY (
                        SELECT NULL
                    )
            ) AS n
        FROM sys.all_objects a
            CROSS JOIN sys.all_objects b
    )
INSERT INTO
    dbo.products (
        product_id,
        product_name,
        category,
        price
    )
SELECT
    n,
    CONCAT('Product ', n),
    CASE ((n - 1) % 6)
        WHEN 0 THEN 'Electronics'
        WHEN 1 THEN 'Home'
        WHEN 2 THEN 'Clothing'
        WHEN 3 THEN 'Sports'
        WHEN 4 THEN 'Books'
        ELSE 'Beauty'
    END,
    CAST(
        500 + ((n * 137) % 9501) AS DECIMAL(10, 2)
    )
FROM n;
GO

/* ============================================================
4. ORDERS - 180 records
Each customer receives multiple orders.
Product/category/sales data are therefore usable for
ROW_NUMBER, RANK, LAG, LEAD, SUM, etc.
============================================================ */
CREATE TABLE dbo.orders (
    order_id INT NOT NULL PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    order_date DATE NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    CONSTRAINT FK_orders_customers FOREIGN KEY (customer_id) REFERENCES dbo.customers (customer_id),
    CONSTRAINT FK_orders_products FOREIGN KEY (product_id) REFERENCES dbo.products (product_id)
);
GO

;
WITH
    n AS (
        SELECT TOP (180) ROW_NUMBER() OVER (
                ORDER BY (
                        SELECT NULL
                    )
            ) AS n
        FROM sys.all_objects a
            CROSS JOIN sys.all_objects b
    )
INSERT INTO
    dbo.orders (
        order_id,
        customer_id,
        product_id,
        order_date,
        amount
    )
SELECT 1000 + n, ((n - 1) % 60) + 1, ((n * 7 - 1) % 60) + 1, DATEADD (
        DAY, (n * 2) % 170, CAST('2026-01-01' AS DATE)
    ), CAST(
        500 + (
            (
                (n * 347) + (((n - 1) % 60) * 83)
            ) % 9501
        ) AS DECIMAL(10, 2)
    )
FROM n;
GO

/* ============================================================
5. DAILY SALES - 90 records
Used for LAG, running SUM/AVG/MAX and daily sales change.
============================================================ */
CREATE TABLE dbo.daily_sales (
    sales_date DATE NOT NULL PRIMARY KEY,
    sales_amount DECIMAL(12, 2) NOT NULL
);
GO

;
WITH
    n AS (
        SELECT TOP (90) ROW_NUMBER() OVER (
                ORDER BY (
                        SELECT NULL
                    )
            ) AS n
        FROM sys.all_objects a
            CROSS JOIN sys.all_objects b
    )
INSERT INTO
    dbo.daily_sales (sales_date, sales_amount)
SELECT DATEADD (
        DAY, n - 1, CAST('2026-01-01' AS DATE)
    ), CAST(
        5000 + ((n * 137) % 7001) + CASE
            WHEN n % 10 = 0 THEN 5000
            ELSE 0
        END AS DECIMAL(12, 2)
    )
FROM n;
GO

/* ============================================================
6. MONTHLY REVENUE - 60 records
Used for LAG and month-over-month analysis.
Five years x 12 months.
============================================================ */
CREATE TABLE dbo.monthly_revenue (
    revenue_month DATE NOT NULL PRIMARY KEY,
    revenue DECIMAL(14, 2) NOT NULL
);
GO

;
WITH
    n AS (
        SELECT TOP (60) ROW_NUMBER() OVER (
                ORDER BY (
                        SELECT NULL
                    )
            ) AS n
        FROM sys.all_objects a
            CROSS JOIN sys.all_objects b
    )
INSERT INTO
    dbo.monthly_revenue (revenue_month, revenue)
SELECT DATEADD (
        MONTH, n - 1, CAST('2022-01-01' AS DATE)
    ), CAST(
        150000 + ((n * 17321) % 180001) + CASE
            WHEN n % 12 = 12 THEN 25000
            ELSE 0
        END AS DECIMAL(14, 2)
    )
FROM n;
GO

/* ============================================================
7. PRICE HISTORY - 60 records
One product tracked across 60 dates.
Used for running minimum price.
============================================================ */
CREATE TABLE dbo.price_history (
    price_history_id INT NOT NULL PRIMARY KEY,
    product_id INT NOT NULL,
    price_date DATE NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    CONSTRAINT FK_price_history_products FOREIGN KEY (product_id) REFERENCES dbo.products (product_id)
);
GO

;
WITH
    n AS (
        SELECT TOP (60) ROW_NUMBER() OVER (
                ORDER BY (
                        SELECT NULL
                    )
            ) AS n
        FROM sys.all_objects a
            CROSS JOIN sys.all_objects b
    )
INSERT INTO
    dbo.price_history (
        price_history_id,
        product_id,
        price_date,
        price
    )
SELECT n, 1, DATEADD (
        DAY, n - 1, CAST('2026-01-01' AS DATE)
    ), CAST(
        12000 + CASE
            WHEN n IN (10, 25, 40, 55) THEN -3500
            WHEN n IN (15, 30, 45, 60) THEN -1800
            ELSE 0
        END + ((n * 211) % 1601) AS DECIMAL(10, 2)
    )
FROM n;
GO

/* ============================================================
OPTIONAL INDEXES
Helpful for practicing realistic analytics queries.
============================================================ */
CREATE INDEX IX_orders_customer_date ON dbo.orders (customer_id, order_date);

CREATE INDEX IX_orders_product ON dbo.orders (product_id);

CREATE INDEX IX_orders_date ON dbo.orders (order_date);

CREATE INDEX IX_employees_department_salary ON dbo.employees (department, salary);

CREATE INDEX IX_products_category_price ON dbo.products (category, price);

CREATE INDEX IX_price_history_product_date ON dbo.price_history (product_id, price_date);
GO

/* ============================================================
QUICK DATA CHECK
============================================================ */
SELECT 'customers' AS table_name, COUNT(*) AS record_count
FROM dbo.customers
UNION ALL
SELECT 'employees', COUNT(*)
FROM dbo.employees
UNION ALL
SELECT 'products', COUNT(*)
FROM dbo.products
UNION ALL
SELECT 'orders', COUNT(*)
FROM dbo.orders
UNION ALL
SELECT 'daily_sales', COUNT(*)
FROM dbo.daily_sales
UNION ALL
SELECT 'monthly_revenue', COUNT(*)
FROM dbo.monthly_revenue
UNION ALL
SELECT 'price_history', COUNT(*)
FROM dbo.price_history;
GO

/* ============================================================
TABLE RELATIONSHIP / PRACTICE MAP

customers
|
+----< orders >---- products
|
+----< price_history

employees        -> salary / department ranking
daily_sales      -> daily LAG + running calculations
monthly_revenue  -> monthly LAG + MoM analysis
============================================================ */