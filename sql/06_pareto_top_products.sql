CREATE OR REPLACE VIEW vw_top_products_by_category AS
WITH product_sales AS (
    SELECT 
        YEAR(f.date) AS sales_year,
        p.category,
        p.product_name,
        SUM(f.net_sales_amount) AS total_revenue
    FROM 
        vw_clean_fact_sales f
    JOIN 
        dim_product p ON f.product_code = p.product_code
    WHERE 
        f.transaction_type = 'Sale'
    GROUP BY 
        YEAR(f.date), p.category, p.product_name
),
ranked_products AS (
    SELECT 
        *,
        DENSE_RANK() OVER(PARTITION BY sales_year, category ORDER BY total_revenue DESC) as revenue_rank
    FROM 
        product_sales
)
SELECT * FROM ranked_products 
WHERE revenue_rank <= 5;