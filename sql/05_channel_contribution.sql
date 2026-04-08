CREATE OR REPLACE VIEW vw_channel_contribution AS
WITH channel_sales AS (
    SELECT 
        YEAR(f.date) AS sales_year,
        c.platform,
        c.channel,
        SUM(f.net_sales_amount) AS revenue
    FROM 
        vw_clean_fact_sales f
    JOIN 
        dim_customer c ON f.customer_code = c.customer_code
    WHERE 
        f.transaction_type = 'Sale'
    GROUP BY 
        YEAR(f.date), c.platform, c.channel
)
SELECT 
    sales_year,
    platform,
    channel,
    revenue,
    ROUND((revenue / SUM(revenue) OVER(PARTITION BY sales_year)) * 100, 2) AS pct_of_yearly_total
FROM 
    channel_sales
ORDER BY 
    sales_year DESC, revenue DESC;