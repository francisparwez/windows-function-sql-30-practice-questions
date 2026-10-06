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
INSERT INTO
    dbo.customers (
        customer_id,
        customer_name,
        city,
        signup_date
    )
VALUES (
        1,
        'Ahmed Raza',
        'Karachi',
        '2026-06-25'
    ),
    (
        2,
        'Ayesha Khan',
        'Lahore',
        '2026-06-20'
    ),
    (
        3,
        'Hassan Ali',
        'Islamabad',
        '2026-06-15'
    ),
    (
        4,
        'Fatima Sheikh',
        'Rawalpindi',
        '2026-06-10'
    ),
    (
        5,
        'Bilal Hussain',
        'Faisalabad',
        '2026-06-05'
    ),
    (
        6,
        'Sara Ahmed',
        'Multan',
        '2026-05-31'
    ),
    (
        7,
        'Usman Malik',
        'Karachi',
        '2026-05-26'
    ),
    (
        8,
        'Mahnoor Siddiqui',
        'Lahore',
        '2026-05-21'
    ),
    (
        9,
        'Hamza Iqbal',
        'Islamabad',
        '2026-05-16'
    ),
    (
        10,
        'Zainab Raza',
        'Rawalpindi',
        '2026-05-11'
    ),
    (
        11,
        'Omer Farooq',
        'Faisalabad',
        '2026-05-06'
    ),
    (
        12,
        'Hira Aslam',
        'Multan',
        '2026-05-01'
    ),
    (
        13,
        'Danish Khan',
        'Karachi',
        '2026-04-26'
    ),
    (
        14,
        'Mariam Tariq',
        'Lahore',
        '2026-04-21'
    ),
    (
        15,
        'Talha Ahmed',
        'Islamabad',
        '2026-04-16'
    ),
    (
        16,
        'Iqra Javed',
        'Rawalpindi',
        '2026-04-11'
    ),
    (
        17,
        'Saad Hassan',
        'Faisalabad',
        '2026-04-06'
    ),
    (
        18,
        'Alina Shah',
        'Multan',
        '2026-04-01'
    ),
    (
        19,
        'Fahad Mustafa',
        'Karachi',
        '2026-03-27'
    ),
    (
        20,
        'Kiran Malik',
        'Lahore',
        '2026-03-22'
    ),
    (
        21,
        'Arslan Qureshi',
        'Islamabad',
        '2026-03-17'
    ),
    (
        22,
        'Sana Iqbal',
        'Rawalpindi',
        '2026-03-12'
    ),
    (
        23,
        'Waleed Ahmed',
        'Faisalabad',
        '2026-03-07'
    ),
    (
        24,
        'Muneeb Raza',
        'Multan',
        '2026-03-02'
    ),
    (
        25,
        'Nimra Khan',
        'Karachi',
        '2026-02-25'
    ),
    (
        26,
        'Asad Ali',
        'Lahore',
        '2026-02-20'
    ),
    (
        27,
        'Laiba Hussain',
        'Islamabad',
        '2026-02-15'
    ),
    (
        28,
        'Rehan Siddiqui',
        'Rawalpindi',
        '2026-02-10'
    ),
    (
        29,
        'Maha Tariq',
        'Faisalabad',
        '2026-02-05'
    ),
    (
        30,
        'Shahzaib Malik',
        'Multan',
        '2026-01-31'
    ),
    (
        31,
        'Eman Fatima',
        'Karachi',
        '2026-01-26'
    ),
    (
        32,
        'Yousuf Khan',
        'Lahore',
        '2026-01-21'
    ),
    (
        33,
        'Anaya Ahmed',
        'Islamabad',
        '2026-01-16'
    ),
    (
        34,
        'Rayan Iqbal',
        'Rawalpindi',
        '2026-01-11'
    ),
    (
        35,
        'Komal Shah',
        'Faisalabad',
        '2026-01-06'
    ),
    (
        36,
        'Abdullah Farooq',
        'Multan',
        '2026-01-01'
    ),
    (
        37,
        'Mehwish Raza',
        'Karachi',
        '2025-12-27'
    ),
    (
        38,
        'Haris Javed',
        'Lahore',
        '2025-12-22'
    ),
    (
        39,
        'Maham Khan',
        'Islamabad',
        '2025-12-17'
    ),
    (
        40,
        'Shayan Ahmed',
        'Rawalpindi',
        '2025-12-12'
    ),
    (
        41,
        'Maryam Iqbal',
        'Faisalabad',
        '2025-12-07'
    ),
    (
        42,
        'Adeel Hussain',
        'Multan',
        '2025-12-02'
    ),
    (
        43,
        'Sabeen Malik',
        'Karachi',
        '2025-11-27'
    ),
    (
        44,
        'Rizwan Ahmed',
        'Lahore',
        '2025-11-22'
    ),
    (
        45,
        'Areeba Siddiqui',
        'Islamabad',
        '2025-11-17'
    ),
    (
        46,
        'Imran Khan',
        'Rawalpindi',
        '2025-11-12'
    ),
    (
        47,
        'Misha Raza',
        'Faisalabad',
        '2025-11-07'
    ),
    (
        48,
        'Kamran Ali',
        'Multan',
        '2025-11-02'
    ),
    (
        49,
        'Saira Ahmed',
        'Karachi',
        '2025-10-28'
    ),
    (
        50,
        'Noman Qureshi',
        'Lahore',
        '2025-10-23'
    ),
    (
        51,
        'Zoya Hassan',
        'Islamabad',
        '2025-10-18'
    ),
    (
        52,
        'Farhan Malik',
        'Rawalpindi',
        '2025-10-13'
    ),
    (
        53,
        'Maham Raza',
        'Faisalabad',
        '2025-10-08'
    ),
    (
        54,
        'Shahzaib Ahmed',
        'Multan',
        '2025-10-03'
    ),
    (
        55,
        'Rabia Khan',
        'Karachi',
        '2025-09-28'
    ),
    (
        56,
        'Samiullah Farooq',
        'Lahore',
        '2025-09-23'
    ),
    (
        57,
        'Hafsa Iqbal',
        'Islamabad',
        '2025-09-18'
    ),
    (
        58,
        'Adnan Hussain',
        'Rawalpindi',
        '2025-09-13'
    ),
    (
        59,
        'Aiman Javed',
        'Faisalabad',
        '2025-09-08'
    ),
    (
        60,
        'Shehryar Khan',
        'Multan',
        '2025-09-03'
    );
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
INSERT INTO
    dbo.employees (
        employee_id,
        employee_name,
        department,
        salary,
        hire_date
    )
VALUES (
        1,
        'Ahmed Raza',
        'IT',
        90000,
        '2022-01-15'
    ),
    (
        2,
        'Ayesha Khan',
        'HR',
        80000,
        '2022-02-10'
    ),
    (
        3,
        'Hassan Ali',
        'Finance',
        70000,
        '2022-03-05'
    ),
    (
        4,
        'Fatima Sheikh',
        'Sales',
        60000,
        '2022-04-12'
    ),
    (
        5,
        'Bilal Hussain',
        'Marketing',
        62500,
        '2022-05-20'
    ),
    (
        6,
        'Sara Ahmed',
        'IT',
        90000,
        '2022-06-18'
    ),
    (
        7,
        'Usman Malik',
        'HR',
        80000,
        '2022-07-08'
    ),
    (
        8,
        'Mahnoor Siddiqui',
        'Finance',
        70000,
        '2022-08-14'
    ),
    (
        9,
        'Hamza Iqbal',
        'Sales',
        60000,
        '2022-09-22'
    ),
    (
        10,
        'Zainab Raza',
        'Marketing',
        75000,
        '2022-10-11'
    ),
    (
        11,
        'Omer Farooq',
        'IT',
        90000,
        '2022-11-03'
    ),
    (
        12,
        'Hira Aslam',
        'HR',
        80000,
        '2022-12-19'
    ),
    (
        13,
        'Danish Khan',
        'Finance',
        70000,
        '2023-01-07'
    ),
    (
        14,
        'Mariam Tariq',
        'Sales',
        60000,
        '2023-02-16'
    ),
    (
        15,
        'Talha Ahmed',
        'Marketing',
        57500,
        '2023-03-12'
    ),
    (
        16,
        'Iqra Javed',
        'IT',
        90000,
        '2023-04-21'
    ),
    (
        17,
        'Saad Hassan',
        'HR',
        80000,
        '2023-05-09'
    ),
    (
        18,
        'Alina Shah',
        'Finance',
        70000,
        '2023-06-17'
    ),
    (
        19,
        'Fahad Mustafa',
        'Sales',
        60000,
        '2023-07-04'
    ),
    (
        20,
        'Kiran Malik',
        'Marketing',
        72500,
        '2023-08-13'
    ),
    (
        21,
        'Arslan Qureshi',
        'IT',
        90000,
        '2023-09-25'
    ),
    (
        22,
        'Sana Iqbal',
        'HR',
        80000,
        '2023-10-18'
    ),
    (
        23,
        'Waleed Ahmed',
        'Finance',
        70000,
        '2023-11-06'
    ),
    (
        24,
        'Muneeb Raza',
        'Sales',
        60000,
        '2023-12-14'
    ),
    (
        25,
        'Nimra Khan',
        'Marketing',
        67500,
        '2024-01-22'
    ),
    (
        26,
        'Asad Ali',
        'IT',
        88500,
        '2024-02-10'
    ),
    (
        27,
        'Laiba Hussain',
        'HR',
        77500,
        '2024-03-15'
    ),
    (
        28,
        'Rehan Siddiqui',
        'Finance',
        68500,
        '2024-04-19'
    ),
    (
        29,
        'Maha Tariq',
        'Sales',
        59000,
        '2024-05-08'
    ),
    (
        30,
        'Shahzaib Malik',
        'Marketing',
        65000,
        '2024-06-16'
    ),
    (
        31,
        'Eman Fatima',
        'IT',
        86000,
        '2024-07-12'
    ),
    (
        32,
        'Yousuf Khan',
        'HR',
        76000,
        '2024-08-21'
    ),
    (
        33,
        'Anaya Ahmed',
        'Finance',
        67500,
        '2024-09-14'
    ),
    (
        34,
        'Rayan Iqbal',
        'Sales',
        58500,
        '2024-10-05'
    ),
    (
        35,
        'Komal Shah',
        'Marketing',
        64000,
        '2024-11-18'
    ),
    (
        36,
        'Abdullah Farooq',
        'IT',
        84500,
        '2024-12-09'
    ),
    (
        37,
        'Mehwish Raza',
        'HR',
        74500,
        '2025-01-13'
    ),
    (
        38,
        'Haris Javed',
        'Finance',
        66500,
        '2025-02-17'
    ),
    (
        39,
        'Maham Khan',
        'Sales',
        57500,
        '2025-03-11'
    ),
    (
        40,
        'Shayan Ahmed',
        'Marketing',
        63000,
        '2025-04-06'
    ),
    (
        41,
        'Maryam Iqbal',
        'IT',
        83000,
        '2025-05-15'
    ),
    (
        42,
        'Adeel Hussain',
        'HR',
        73500,
        '2025-06-19'
    ),
    (
        43,
        'Sabeen Malik',
        'Finance',
        65500,
        '2025-07-22'
    ),
    (
        44,
        'Rizwan Ahmed',
        'Sales',
        56500,
        '2025-08-10'
    ),
    (
        45,
        'Areeba Siddiqui',
        'Marketing',
        62000,
        '2025-09-14'
    ),
    (
        46,
        'Imran Khan',
        'IT',
        81500,
        '2025-10-18'
    ),
    (
        47,
        'Misha Raza',
        'HR',
        72500,
        '2025-11-07'
    ),
    (
        48,
        'Kamran Ali',
        'Finance',
        64500,
        '2025-12-12'
    ),
    (
        49,
        'Saira Ahmed',
        'Sales',
        55500,
        '2026-01-09'
    ),
    (
        50,
        'Noman Qureshi',
        'Marketing',
        61000,
        '2026-01-21'
    ),
    (
        51,
        'Zoya Hassan',
        'IT',
        80500,
        '2026-02-14'
    ),
    (
        52,
        'Farhan Malik',
        'HR',
        71500,
        '2026-03-08'
    ),
    (
        53,
        'Maham Raza',
        'Finance',
        63500,
        '2026-03-21'
    ),
    (
        54,
        'Shahzaib Ahmed',
        'Sales',
        54500,
        '2026-04-11'
    ),
    (
        55,
        'Rabia Khan',
        'Marketing',
        60000,
        '2026-04-25'
    ),
    (
        56,
        'Samiullah Farooq',
        'IT',
        79500,
        '2026-05-03'
    ),
    (
        57,
        'Hafsa Iqbal',
        'HR',
        70500,
        '2026-05-12'
    ),
    (
        58,
        'Adnan Hussain',
        'Finance',
        62500,
        '2026-05-20'
    ),
    (
        59,
        'Aiman Javed',
        'Sales',
        53500,
        '2026-06-02'
    ),
    (
        60,
        'Shehryar Khan',
        'Marketing',
        59000,
        '2026-06-15'
    );
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
INSERT INTO
    dbo.products (
        product_id,
        product_name,
        category,
        price
    )
VALUES

/* =========================
ELECTRONICS
========================= */
(
    1,
    'Samsung Galaxy A55',
    'Electronics',
    89999
),
(
    2,
    'Apple iPhone 15',
    'Electronics',
    249999
),
(
    3,
    'Google Pixel 8a',
    'Electronics',
    139999
),
(
    4,
    'Dell Inspiron 15',
    'Electronics',
    154999
),
(
    5,
    'HP Pavilion 15',
    'Electronics',
    164999
),
(
    6,
    'Lenovo IdeaPad Slim 3',
    'Electronics',
    124999
),
(
    7,
    'Sony WH-1000XM5',
    'Electronics',
    89999
),
(
    8,
    'JBL Tune 770NC',
    'Electronics',
    24999
),
(
    9,
    'Apple iPad 10th Gen',
    'Electronics',
    119999
),
(
    10,
    'Samsung Galaxy Tab S9 FE',
    'Electronics',
    99999
),

/* =========================
HOME
========================= */
(
    11,
    'Philips Air Fryer HD9200',
    'Home',
    24999
),
(
    12,
    'Dawlance Microwave Oven',
    'Home',
    29999
),
(
    13,
    'Haier 43 Inch Smart TV',
    'Home',
    89999
),
(
    14,
    'Kenwood Blender',
    'Home',
    14999
),
(
    15,
    'Westpoint Electric Kettle',
    'Home',
    7999
),
(
    16,
    'PEL Inverter Refrigerator',
    'Home',
    164999
),
(
    17,
    'Dawlance Washing Machine',
    'Home',
    104999
),
(
    18,
    'Anex Sandwich Maker',
    'Home',
    6999
),
(
    19,
    'National Rice Cooker',
    'Home',
    8499
),
(
    20,
    'Orient Room Cooler',
    'Home',
    44999
),

/* =========================
CLOTHING
========================= */
(
    21,
    'Levis 511 Slim Jeans',
    'Clothing',
    9999
),
(
    22,
    'Levis 501 Original Jeans',
    'Clothing',
    11999
),
(
    23,
    'Nike Sports T-Shirt',
    'Clothing',
    7499
),
(
    24,
    'Adidas Essentials Hoodie',
    'Clothing',
    10999
),
(
    25,
    'Uniqlo Oxford Shirt',
    'Clothing',
    6499
),
(
    26,
    'Junaid Jamshed Kurta',
    'Clothing',
    5999
),
(
    27,
    'Khaadi Cotton Kurta',
    'Clothing',
    4999
),
(
    28,
    'Outfitters Denim Jacket',
    'Clothing',
    8999
),
(
    29,
    'Breakout Casual Shirt',
    'Clothing',
    4499
),
(
    30,
    'Sapphire Lawn Suit',
    'Clothing',
    7999
),

/* =========================
SPORTS
========================= */
(
    31,
    'Nike Revolution Running Shoes',
    'Sports',
    17999
),
(
    32,
    'Adidas Ultraboost Shoes',
    'Sports',
    32999
),
(
    33,
    'Yonex Badminton Racket',
    'Sports',
    12999
),
(
    34,
    'Wilson Tennis Racket',
    'Sports',
    19999
),
(
    35,
    'Spalding Basketball',
    'Sports',
    8999
),
(
    36,
    'Adidas Football',
    'Sports',
    6499
),
(
    37,
    'Decathlon Yoga Mat',
    'Sports',
    4999
),
(
    38,
    'Nike Training Gloves',
    'Sports',
    3999
),
(
    39,
    'Fitness Resistance Bands',
    'Sports',
    2999
),
(
    40,
    'Adjustable Dumbbell Set',
    'Sports',
    15999
),

/* =========================
BOOKS
========================= */
(
    41,
    'Atomic Habits',
    'Books',
    2499
),
(
    42,
    'The Psychology of Money',
    'Books',
    2299
),
(
    43,
    'Rich Dad Poor Dad',
    'Books',
    1999
),
(
    44,
    'Deep Work',
    'Books',
    2199
),
(
    45,
    'Clean Code',
    'Books',
    3499
),
(
    46,
    'Python Crash Course',
    'Books',
    3999
),
(
    47,
    'Hands-On Machine Learning',
    'Books',
    5499
),
(
    48,
    'SQL for Data Analysis',
    'Books',
    2999
),
(
    49,
    'Data Science from Scratch',
    'Books',
    4299
),
(
    50,
    'The Pragmatic Programmer',
    'Books',
    4499
),

/* =========================
BEAUTY
========================= */
(
    51,
    'LOréal Paris Shampoo',
    'Beauty',
    2199
),
(
    52,
    'Head & Shoulders Shampoo',
    'Beauty',
    1699
),
(
    53,
    'Nivea Men Face Wash',
    'Beauty',
    1299
),
(
    54,
    'Garnier Vitamin C Serum',
    'Beauty',
    2499
),
(
    55,
    'Neutrogena Hydro Boost',
    'Beauty',
    3499
),
(
    56,
    'Maybelline Fit Me Foundation',
    'Beauty',
    2799
),
(
    57,
    'The Ordinary Niacinamide Serum',
    'Beauty',
    3999
),
(
    58,
    'Dove Body Wash',
    'Beauty',
    1599
),
(
    59,
    'Vaseline Body Lotion',
    'Beauty',
    1899
),
(
    60,
    'Gillette Fusion Razor',
    'Beauty',
    2999
);
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