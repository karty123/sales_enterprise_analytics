-- Calculate YoY Net Sales Growth by Market
CREATE OR REPLACE VIEW vw_market_yoy_growth AS
WITH yearly_sales AS (
    SELECT 
        m.market,
        m.region,
        YEAR(f.date) AS sales_year,
        SUM(f.net_sales_amount) AS total_net_sales
    FROM 
        vw_clean_fact_sales f
    JOIN 
        dim_customer c ON f.customer_code = c.customer_code
    JOIN 
        dim_market m ON c.market = m.market
    WHERE 
        f.transaction_type = 'Sale' -- Only look at actual sales, not returns
    GROUP BY 
        m.market, m.region, YEAR(f.date)
),
growth_calc AS (
    SELECT 
        market,
        region,
        sales_year,
        total_net_sales,
        LAG(total_net_sales) OVER(PARTITION BY market ORDER BY sales_year) AS previous_year_sales
    FROM 
        yearly_sales
)
SELECT 
    market,
    region,
    sales_year,
    total_net_sales,
    previous_year_sales,
    -- Calculate YoY Growth Percentage safely (handling divide by zero)
    CASE 
        WHEN previous_year_sales IS NULL OR previous_year_sales = 0 THEN 0
        ELSE ROUND(((total_net_sales - previous_year_sales) / previous_year_sales) * 100, 2)
    END AS yoy_growth_pct
FROM 
    growth_calc;