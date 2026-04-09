-- Tell MySQL to allow up to 10,000 loops instead of the default 1,000
SET SESSION cte_max_recursion_depth = 10000;

-- Now build the table
DROP TABLE IF EXISTS dim_date;

CREATE TABLE dim_date AS
WITH RECURSIVE DateGenerator AS (
    SELECT MIN(date) AS calendar_date FROM vw_clean_fact_sales
    UNION ALL
    SELECT calendar_date + INTERVAL 1 DAY
    FROM DateGenerator
    WHERE calendar_date < (SELECT MAX(date) FROM vw_clean_fact_sales)
)
SELECT 
    calendar_date AS date,
    YEAR(calendar_date) AS calendar_year,
    QUARTER(calendar_date) AS fiscal_quarter,
    MONTH(calendar_date) AS month_number,
    MONTHNAME(calendar_date) AS month_name,
    DAYNAME(calendar_date) AS day_of_week,
    CASE WHEN DAYOFWEEK(calendar_date) IN (1, 7) THEN 1 ELSE 0 END AS is_weekend
FROM DateGenerator;

-- Add the Primary Key
ALTER TABLE dim_date ADD PRIMARY KEY (date);