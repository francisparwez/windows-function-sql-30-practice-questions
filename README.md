# 30 Window Functions Beginner Practice Questions

## 📊 SQL Window Functions Practice Database

This project contains a **SQL Server / T-SQL practice database** designed specifically for the **30 Beginner SQL Window Function Practice Questions**.

The database is built around realistic Data Analyst scenarios such as:

- Employee salary analysis
- Department rankings
- Product/category analysis
- Customer purchasing behavior
- Daily sales analysis
- Monthly revenue analysis
- Product price history

The goal is to practice window functions on a dataset that is large enough to produce meaningful results instead of working with only a few sample rows.

---

# 🎯 Project Goal

The purpose of this project is to become comfortable with the fundamental window-function pattern:

```sql
FUNCTION() OVER(
    PARTITION BY ...
    ORDER BY ...
)
```

For each problem, think about three questions:

1. **What am I calculating?**
2. **What group should the calculation operate within?**
3. **What order should the calculation follow?**

---

# 🛠️ Technologies

- SQL Server
- T-SQL
- SQL Server Management Studio (SSMS)
- Git / GitHub

---

# 🗄️ Database

The SQL script creates the following database:

```text
WindowFunctionsPracticeDB
```

The script automatically creates the database if it does not already exist.

```sql
IF DB_ID(N'WindowFunctionsPracticeDB') IS NULL
BEGIN
    CREATE DATABASE WindowFunctionsPracticeDB;
END;
```

Then it switches to the database:

```sql
USE WindowFunctionsPracticeDB;
```

---

# 📁 Project Files

```text
30_window_functions_beginner/
│
├── 00_schema_design.sql
└── README.md
```

`00_schema_design.sql` contains:

- Database creation
- Table creation
- Sample data generation
- Foreign keys
- Indexes
- Record-count verification

---

# 📦 Dataset Overview

All main practice tables contain **50+ records**.

| Table             | Records | Purpose                                 |
| ----------------- | ------: | --------------------------------------- |
| `customers`       |      60 | Customer information                    |
| `employees`       |      60 | Employee salary and department analysis |
| `products`        |      60 | Product/category analysis               |
| `orders`          |     180 | Customer purchasing and order analysis  |
| `daily_sales`     |      90 | Daily sales and running calculations    |
| `monthly_revenue` |      60 | Monthly revenue and MoM analysis        |
| `price_history`   |      60 | Historical product price analysis       |

---

# 🔗 Table Relationships

```text
customers
    │
    │ 1
    │
    └──────────< orders >──────────┐
                    many           │
                                   │
                                   │ many
                                   ▼
                               products
                                   │
                                   │ 1
                                   │
                                   └──────────< price_history
```

### Independent analytical tables

```text
employees
daily_sales
monthly_revenue
```

These tables do not need to be joined to the customer/order model for the beginner exercises.

---

# 👥 1. Customers

### Table

```text
dbo.customers
```

### Records

**60**

### Columns

| Column          | Data Type      | Description          |
| --------------- | -------------- | -------------------- |
| `customer_id`   | `INT`          | Unique customer ID   |
| `customer_name` | `VARCHAR(100)` | Customer name        |
| `city`          | `VARCHAR(50)`  | Customer city        |
| `signup_date`   | `DATE`         | Customer signup date |

### Cities included

- Karachi
- Lahore
- Islamabad
- Rawalpindi
- Faisalabad
- Multan

### Example

```text
customer_id | customer_name | city       | signup_date
------------|---------------|------------|------------
1           | Customer 1    | Karachi    | ...
2           | Customer 2    | Lahore     | ...
3           | Customer 3    | Islamabad  | ...
```

### Main use

The table provides the customer dimension for the `orders` table.

It is especially useful when analyzing:

- Customer order history
- Customer spending
- Customer purchase behavior

---

# 👨‍💼 2. Employees

### Table

```text
dbo.employees
```

### Records

**60**

### Columns

| Column          | Data Type       | Description         |
| --------------- | --------------- | ------------------- |
| `employee_id`   | `INT`           | Unique employee ID  |
| `employee_name` | `VARCHAR(100)`  | Employee name       |
| `department`    | `VARCHAR(50)`   | Employee department |
| `salary`        | `DECIMAL(12,2)` | Employee salary     |
| `hire_date`     | `DATE`          | Employee hire date  |

### Departments included

- IT
- HR
- Finance
- Sales
- Marketing

### Important dataset feature

The dataset intentionally contains **duplicate salaries**.

For example, several employees have:

```text
90000
80000
70000
60000
```

This is intentional so that you can clearly practice the difference between:

```sql
RANK()
```

and

```sql
DENSE_RANK()
```

### Main use

Employee salary analysis and department-level ranking.

---

# 🛍️ 3. Products

### Table

```text
dbo.products
```

### Records

**60**

### Columns

| Column         | Data Type       | Description       |
| -------------- | --------------- | ----------------- |
| `product_id`   | `INT`           | Unique product ID |
| `product_name` | `VARCHAR(100)`  | Product name      |
| `category`     | `VARCHAR(50)`   | Product category  |
| `price`        | `DECIMAL(10,2)` | Product price     |

### Categories included

- Electronics
- Home
- Clothing
- Sports
- Books
- Beauty

### Main use

Product and category analysis.

Examples:

- Highest-priced product
- Lowest-priced product
- Product ranking
- Ranking products within categories
- Product sales analysis

---

# 🧾 4. Orders

### Table

```text
dbo.orders
```

### Records

**180**

This is the main transactional table in the project.

### Columns

| Column        | Data Type       | Description                   |
| ------------- | --------------- | ----------------------------- |
| `order_id`    | `INT`           | Unique order ID               |
| `customer_id` | `INT`           | Customer who placed the order |
| `product_id`  | `INT`           | Product purchased             |
| `order_date`  | `DATE`          | Date of order                 |
| `amount`      | `DECIMAL(10,2)` | Order amount                  |

### Relationships

```text
orders.customer_id
        ↓
customers.customer_id
```

and

```text
orders.product_id
        ↓
products.product_id
```

Foreign keys are created to enforce these relationships.

### Data characteristics

The 180 records are distributed across the 60 customers, meaning customers have multiple orders.

This makes the table suitable for:

```sql
ROW_NUMBER()
RANK()
SUM()
LAG()
LEAD()
```

combined with:

```sql
PARTITION BY customer_id
ORDER BY order_date
```

### Main use

Customer purchase analytics.

Examples:

- Customer order sequence
- Total customer spending
- Previous order amount
- Next order amount
- Running customer spending

---

# 📈 5. Daily Sales

### Table

```text
dbo.daily_sales
```

### Records

**90**

### Columns

| Column         | Data Type       | Description             |
| -------------- | --------------- | ----------------------- |
| `sales_date`   | `DATE`          | Sales date              |
| `sales_amount` | `DECIMAL(12,2)` | Total sales for the day |

The data covers **90 consecutive days starting from 2026-01-01**.

### Main use

Daily time-series analysis.

This table is designed for:

```sql
LAG()
```

and:

```sql
SUM() OVER()
AVG() OVER()
MAX() OVER()
```

### Example analytical questions

- What were yesterday's sales?
- How much did sales change from yesterday?
- What is the running sales total?
- What is the running average?
- What is the highest sales amount achieved so far?

---

# 📅 6. Monthly Revenue

### Table

```text
dbo.monthly_revenue
```

### Records

**60**

The data covers **60 consecutive months starting from January 2022**.

### Columns

| Column          | Data Type       | Description            |
| --------------- | --------------- | ---------------------- |
| `revenue_month` | `DATE`          | First day of the month |
| `revenue`       | `DECIMAL(14,2)` | Monthly revenue        |

### Main use

Monthly time-series analysis.

Especially useful for:

```sql
LAG()
```

and month-over-month analysis.

Example:

```text
Month
Revenue
Previous Month Revenue
Revenue Change
```

---

# 💰 7. Price History

### Table

```text
dbo.price_history
```

### Records

**60**

### Columns

| Column             | Data Type       | Description                 |
| ------------------ | --------------- | --------------------------- |
| `price_history_id` | `INT`           | Unique price-history record |
| `product_id`       | `INT`           | Product being tracked       |
| `price_date`       | `DATE`          | Date of price               |
| `price`            | `DECIMAL(10,2)` | Historical price            |

The current dataset tracks **Product 1 across 60 consecutive dates**.

### Main use

Historical price analysis.

It is specifically designed for:

```sql
MIN() OVER(
    ORDER BY price_date
)
```

to calculate the lowest price recorded so far.

---

# 🪟 Window Functions Covered

The dataset supports the beginner practice questions across these functions and concepts:

| Function / Concept         | Practice                     |
| -------------------------- | ---------------------------- |
| `OVER()`                   | Basic window calculations    |
| `ORDER BY` inside `OVER()` | Ordering window calculations |
| `PARTITION BY`             | Calculations within groups   |
| `ROW_NUMBER()`             | Sequential numbering         |
| `RANK()`                   | Ranking with ties            |
| `DENSE_RANK()`             | Ranking without gaps         |
| `LAG()`                    | Previous row                 |
| `LEAD()`                   | Next row                     |
| `SUM() OVER()`             | Totals and running totals    |
| `AVG() OVER()`             | Average and running average  |
| `MIN() OVER()`             | Minimum and running minimum  |
| `MAX() OVER()`             | Maximum and running maximum  |
| Multiple window functions  | Combined analytics           |

---

# 📝 Beginner Practice Questions

## Level 1 — Understanding `OVER()`

### 01. Number Every Order

Use `ROW_NUMBER()` to assign a sequential number to orders based on `order_date`.

**Table:** `orders`

---

### 02. Number Employees by Salary

Use `ROW_NUMBER()` to number employees from highest salary to lowest salary.

**Table:** `employees`

---

### 03. Employee Salary vs Company Average

Show each employee's salary alongside the company's average salary.

**Table:** `employees`

**Concept:**

```sql
AVG() OVER()
```

---

### 04. Product Price vs Maximum Price

Show each product's price alongside the highest product price.

**Table:** `products`

**Concept:**

```sql
MAX() OVER()
```

---

### 05. Product Price vs Minimum Price

Show each product's price alongside the cheapest product price.

**Table:** `products`

**Concept:**

```sql
MIN() OVER()
```

---

# Level 2 — `PARTITION BY`

### 06. Number Orders for Each Customer

Number each customer's orders according to `order_date`.

**Table:** `orders`

**Concept:**

```sql
ROW_NUMBER()
PARTITION BY
ORDER BY
```

---

### 07. Rank Employees Within Each Department

Rank employees according to salary within each department.

**Table:** `employees`

**Concept:**

```sql
RANK()
PARTITION BY
```

---

### 08. Number Products Within Each Category

Number products from most expensive to least expensive within each category.

**Table:** `products`

**Concept:**

```sql
ROW_NUMBER()
PARTITION BY
```

---

### 09. Average Salary by Department

Show every employee's salary alongside the average salary of their department.

**Table:** `employees`

**Concept:**

```sql
AVG() OVER(PARTITION BY ...)
```

---

### 10. Total Sales by Customer

Show every order alongside the customer's total spending.

**Table:** `orders`

**Concept:**

```sql
SUM() OVER(PARTITION BY ...)
```

---

# Level 3 — Ranking

### 11. Highest-Paid Employee

Use a window function to identify the highest-paid employee.

**Table:** `employees`

**Concept:**

```sql
ROW_NUMBER()
```

---

### 12. Top 3 Highest-Paid Employees

Rank employees by salary and return the top 3.

**Table:** `employees`

---

### 13. Rank Products by Sales

Rank products based on their sales.

**Tables:**

```text
orders
products
```

**Concept:**

```sql
RANK()
```

---

### 14. Rank Customers by Spending

Rank customers based on their total spending.

**Table:**

```text
orders
```

**Concept:**

```sql
RANK()
```

---

### 15. Understand Tied Rankings

Use the repeated salaries in `employees` to compare:

```sql
RANK()
DENSE_RANK()
```

Observe how ties affect the ranking numbers.

---

### 16. Rank Employees Within Departments

Create a salary leaderboard for every department.

**Table:** `employees`

---

### 17. Highest-Paid Employee in Each Department

Rank employees within each department and identify rank 1.

**Table:** `employees`

---

# Level 4 — `LAG()` and `LEAD()`

### 18. Today's Sales vs Yesterday's Sales

Show:

```text
sales_date
sales_amount
previous_day_sales
```

**Table:** `daily_sales`

**Concept:**

```sql
LAG()
```

---

### 19. Daily Sales Change

Calculate the difference between today's sales and the previous day's sales.

**Table:** `daily_sales`

**Concept:**

```sql
LAG()
```

---

### 20. Employee Salary vs Previous Employee

Order employees from lowest salary to highest and compare each salary with the previous salary.

**Table:** `employees`

**Concept:**

```sql
LAG()
```

---

### 21. Next Order for Each Customer

Show each customer's next order date.

**Table:** `orders`

**Concept:**

```sql
LEAD()
PARTITION BY
```

---

### 22. Days Until Next Order

Calculate the number of days between each order and the customer's next order.

**Table:** `orders`

**Concept:**

```sql
LEAD()
```

---

### 23. Monthly Revenue vs Previous Month

Show monthly revenue alongside the previous month's revenue.

**Table:** `monthly_revenue`

**Concept:**

```sql
LAG()
```

---

### 24. Month-over-Month Revenue Change

Calculate the difference between current monthly revenue and previous monthly revenue.

**Table:** `monthly_revenue`

**Concept:**

```sql
LAG()
```

---

# Level 5 — Running Calculations

### 25. Running Total of Sales

Calculate cumulative daily sales.

**Table:** `daily_sales`

**Concept:**

```sql
SUM() OVER(
    ORDER BY sales_date
)
```

---

### 26. Running Total for Each Customer

Calculate each customer's cumulative spending over time.

**Table:** `orders`

**Concept:**

```sql
SUM()
PARTITION BY
ORDER BY
```

---

### 27. Running Average of Sales

Calculate the average sales value accumulated up to each day.

**Table:** `daily_sales`

**Concept:**

```sql
AVG() OVER(
    ORDER BY sales_date
)
```

---

### 28. Running Maximum Sales

Calculate the highest daily sales achieved so far.

**Table:** `daily_sales`

**Concept:**

```sql
MAX() OVER(
    ORDER BY sales_date
)
```

---

### 29. Running Minimum Product Price

Calculate the lowest recorded price so far.

**Table:** `price_history`

**Concept:**

```sql
MIN() OVER(
    ORDER BY price_date
)
```

---

# ⭐ 30. Customer Purchase Analytics Dashboard

This is the final beginner exercise.

Use the `orders` table to return:

```text
customer_id
order_id
order_date
order_amount
order_number
customer_total_spending
previous_order_amount
next_order_amount
running_customer_spending
```

Calculate:

```text
order_number
→ customer's order sequence

customer_total_spending
→ total amount spent by customer

previous_order_amount
→ previous order amount

next_order_amount
→ next order amount

running_customer_spending
→ cumulative customer spending
```

### Concepts combined

```sql
ROW_NUMBER()
SUM()
LAG()
LEAD()
PARTITION BY
ORDER BY
```

---

# 📊 Practice Map

| Question | Main Table(s)         | Main Concept                     |
| -------: | --------------------- | -------------------------------- |
|       01 | `orders`              | `ROW_NUMBER()`                   |
|       02 | `employees`           | `ROW_NUMBER()`                   |
|       03 | `employees`           | `AVG() OVER()`                   |
|       04 | `products`            | `MAX() OVER()`                   |
|       05 | `products`            | `MIN() OVER()`                   |
|       06 | `orders`              | `ROW_NUMBER()` + `PARTITION BY`  |
|       07 | `employees`           | `RANK()` + `PARTITION BY`        |
|       08 | `products`            | `ROW_NUMBER()` + `PARTITION BY`  |
|       09 | `employees`           | `AVG()` + `PARTITION BY`         |
|       10 | `orders`              | `SUM()` + `PARTITION BY`         |
|       11 | `employees`           | `ROW_NUMBER()`                   |
|       12 | `employees`           | `ROW_NUMBER()`                   |
|       13 | `orders` + `products` | `RANK()`                         |
|       14 | `orders`              | `RANK()`                         |
|       15 | `employees`           | `RANK()` vs `DENSE_RANK()`       |
|       16 | `employees`           | `RANK()` + `PARTITION BY`        |
|       17 | `employees`           | `RANK()` + `PARTITION BY`        |
|       18 | `daily_sales`         | `LAG()`                          |
|       19 | `daily_sales`         | `LAG()`                          |
|       20 | `employees`           | `LAG()`                          |
|       21 | `orders`              | `LEAD()` + `PARTITION BY`        |
|       22 | `orders`              | `LEAD()`                         |
|       23 | `monthly_revenue`     | `LAG()`                          |
|       24 | `monthly_revenue`     | `LAG()`                          |
|       25 | `daily_sales`         | Running `SUM()`                  |
|       26 | `orders`              | Running `SUM()` + `PARTITION BY` |
|       27 | `daily_sales`         | Running `AVG()`                  |
|       28 | `daily_sales`         | Running `MAX()`                  |
|       29 | `price_history`       | Running `MIN()`                  |
|       30 | `orders`              | Multiple window functions        |

---

# 🔍 Useful Verification Queries

## Check all record counts

```sql
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
```

Expected counts:

```text
customers        60
employees        60
products         60
orders          180
daily_sales      90
monthly_revenue  60
price_history    60
```

---

# 🔎 Inspect the Main Tables

```sql
SELECT *
FROM dbo.customers;
```

```sql
SELECT *
FROM dbo.employees
ORDER BY salary DESC;
```

```sql
SELECT *
FROM dbo.products
ORDER BY category, price DESC;
```

```sql
SELECT *
FROM dbo.orders
ORDER BY customer_id, order_date;
```

```sql
SELECT *
FROM dbo.daily_sales
ORDER BY sales_date;
```

```sql
SELECT *
FROM dbo.monthly_revenue
ORDER BY revenue_month;
```

```sql
SELECT *
FROM dbo.price_history
ORDER BY price_date;
```

---

# ⚡ Indexes

The database also includes indexes intended to make the practice dataset more realistic:

```text
IX_orders_customer_date
IX_orders_product
IX_orders_date
IX_employees_department_salary
IX_products_category_price
IX_price_history_product_date
```

These support common filtering, grouping, joining, and ordering patterns used by the exercises.

---

# 🧠 Beginner Learning Strategy

Do **not** immediately look at solutions.

For every question, first identify:

### 1. What am I calculating?

Examples:

```text
Sequence       → ROW_NUMBER()
Ranking        → RANK()
Ranking no gap → DENSE_RANK()
Previous row   → LAG()
Next row       → LEAD()
Total          → SUM()
Average        → AVG()
Minimum        → MIN()
Maximum        → MAX()
```

### 2. What group does it operate within?

If the calculation needs to restart for every:

- customer
- department
- category

use:

```sql
PARTITION BY
```

### 3. What order should it follow?

If the calculation depends on:

- salary
- order date
- sales date
- price date

use:

```sql
ORDER BY
```

inside `OVER()`.

---

# 🏆 Progression

This repository is intentionally the **Beginner Level** of a larger progression:

```text
30 Beginner
     ↓
30 Intermediate
     ↓
30 Advanced
```

The beginner level focuses on building confidence with the fundamental window-function syntax and analytical thinking.

Future levels can build toward:

- Top-N per group
- Moving averages
- Percentage change
- More complex ranking
- Multiple dimensions
- Gaps and islands
- Advanced time-series analysis
- CTE + window-function combinations
- Subquery + window-function combinations
- Real-world Data Analyst interview problems

---

# 📌 Database Reset

The SQL script uses:

```sql
DROP TABLE IF EXISTS
```

before recreating the tables.

Therefore, rerunning the script will recreate the practice tables and regenerate the 60+ record datasets.

---

# 🚀 Start Practicing

```sql
USE WindowFunctionsPracticeDB;
```

Then begin with:

```text
01 → 02 → 03 → ... → 30
```

Try to solve every question yourself before checking a solution.

The objective is not just to memorize:

```sql
ROW_NUMBER() OVER(...)
```

The objective is to understand **why** a window function is the correct analytical tool for the problem.
