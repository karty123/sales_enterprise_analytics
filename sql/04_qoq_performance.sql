CREATE OR REPLACE VIEW vw_quarterly_performance AS
WITH quarterly_totals AS (
    SELECT 
        YEAR(date) AS fiscal_year,
        QUARTER(date) AS fiscal_quarter,
        SUM(net_sales_amount) AS total_revenue,
        SUM(true_quantity) AS total_volume
    FROM 
        vw_clean_fact_sales
    WHERE 
        transaction_type = 'Sale'
    GROUP BY 
        YEAR(date), QUARTER(date)
),
qoq_calc AS (
    SELECT 
        *,
        LAG(total_revenue) OVER(ORDER BY fiscal_year, fiscal_quarter) AS prev_qtr_revenue
    FROM 
        quarterly_totals
)
SELECT 
    fiscal_year,
    fiscal_quarter,
    total_revenue,
    total_volume,
    prev_qtr_revenue,
    CASE 
        WHEN prev_qtr_revenue IS NULL OR prev_qtr_revenue = 0 THEN 0
        ELSE ROUND(((total_revenue - prev_qtr_revenue) / prev_qtr_revenue) * 100, 2)
    END AS qoq_growth_pct
FROM 
    qoq_calc;