-- 1. Importing Data
CREATE DATABASE Showroom_Sales
;
USE showroom_sales;
SHOW TABLES;

SELECT *
FROM showroom_sales;

-- 2. Data Cleaning
SELECT `ï»¿sales_date`,
STR_TO_DATE(`ï»¿sales_date`, '%Y-%m-%d')
FROM showroom_sales;

UPDATE showroom_sales
SET `ï»¿sales_date` = STR_TO_DATE(`ï»¿sales_date`, '%Y-%m-%d');

ALTER TABLE showroom_sales
MODIFY COLUMN `ï»¿sales_date` DATE;

SELECT *
FROM showroom_sales;

ALTER TABLE showroom_sales
RENAME COLUMN `ï»¿sales_date` TO sales_date;

-- 3. Data Exploratory
# data cabang
SELECT DISTINCT branch
FROM showroom_sales;

# mengurutkan transaksi berdasarkan tanggal penjualan
SELECT *
FROM showroom_sales
ORDER BY sales_date ASC;

# menghitung total transaksi
SELECT COUNT(*) AS total_sales
FROM showroom_sales
;

# total penjualan
SELECT SUM(total_sales) AS total_sales
FROM showroom_sales
;

# total penjualan berdasarkan kategori mobil
SELECT 
    category,
    COUNT(*) AS total_sales
FROM showroom_sales
GROUP BY category
ORDER BY total_sales DESC;

# status transaksi
SELECT
    status,
    COUNT(*) AS total_transactions
FROM showroom_sales
GROUP BY status
ORDER BY total_transactions DESC;

# status transaksi: completed
CREATE OR REPLACE VIEW completed_sales AS
SELECT
    sales_date,
    order_id,
    customer_name,
    branch,
    product_name,
    category,
    color,
    price,
    quantity,
    payment_type,
    trade_in,
    discount,
    total,
    total_sales,
    `status`,
    branch address
FROM showroom_sales
WHERE status = 'Completed';

-- 4. Analyze Data

# 1. Total penjualan menurut kategori mobil
SELECT
    category,
    COUNT(*) AS total_sales,
    SUM(price) AS total_revenue,
    AVG(price) AS average_price
FROM completed_sales
GROUP BY category
ORDER BY total_revenue DESC;

# 2. Cabang dengan penjualan tertinggi
WITH brand_sales AS (
    SELECT
        branch,
        COUNT(*) AS total_sales,
        SUM(price) AS total_revenue
    FROM completed_sales
    GROUP BY branch
)
SELECT
    branch,
    total_sales,
    total_revenue
FROM brand_sales
ORDER BY total_revenue DESC;

# 3. Cabang yang bergantung pada transaksi Trade In
SELECT DISTINCT payment_type
FROM showroom_sales;

SELECT
    branch,
    COUNT(*) AS total_trade_in,
    SUM(
        CASE
            WHEN payment_type = 'Cash + Trade In' THEN 1
            ELSE 0
        END
    ) AS trade_in_cash,
    SUM(
        CASE
            WHEN payment_type = 'Kredit + Trade In' THEN 1
            ELSE 0
        END
    ) AS trade_in_credit
FROM showroom_sales
WHERE payment_type IN ('Cash + Trade In', 'Kredit + Trade In')
GROUP BY branch
ORDER BY total_trade_in DESC;

