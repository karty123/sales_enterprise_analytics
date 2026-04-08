CREATE database sales_db;
use sales_db;


-- 1. Create Dimension Tables First (No foreign key dependencies)

CREATE TABLE dim_market (
    market VARCHAR(50) PRIMARY KEY,
    sub_zone VARCHAR(50),
    region VARCHAR(50)
);

CREATE TABLE dim_customer (
    customer_code INT PRIMARY KEY,
    customer_name VARCHAR(100),
    platform VARCHAR(50),
    channel VARCHAR(50),
    market VARCHAR(50),
    FOREIGN KEY (market) REFERENCES dim_market(market)
);

CREATE TABLE dim_product (
    product_code VARCHAR(50) PRIMARY KEY,
    division VARCHAR(50),
    segment VARCHAR(50),
    category VARCHAR(50),
    product_name VARCHAR(150),
    variant VARCHAR(100)
);

-- 2. Create the Fact Table (Depends on Dimension tables)

CREATE TABLE fact_sales_monthly (
    date DATE,
    product_code VARCHAR(50),
    customer_code INT,
    sold_quantity INT,
    net_sales_amount DECIMAL(15, 2), -- Assuming this column exists or we calculate it later
    PRIMARY KEY (date, product_code, customer_code),
    FOREIGN KEY (product_code) REFERENCES dim_product(product_code),
    FOREIGN KEY (customer_code) REFERENCES dim_customer(customer_code)
);


-- data load check --
SELECT 'dim_market' AS table_name, COUNT(*) AS row_count FROM dim_market UNION ALL
SELECT 'dim_product', COUNT(*) FROM dim_product UNION ALL
SELECT 'dim_customer', COUNT(*) FROM dim_customer UNION ALL
SELECT 'fact_sales_monthly', COUNT(*) FROM fact_sales_monthly;