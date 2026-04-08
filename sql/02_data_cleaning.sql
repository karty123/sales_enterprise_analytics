-- Create a cleaned, standardized view of the fact table for Tableau
CREATE OR REPLACE VIEW vw_clean_fact_sales AS
SELECT 
    date,
    product_code,
    customer_code,
    -- Handle Returns: Create a flag so we can filter returns in the dashboard
    CASE 
        WHEN sold_quantity < 0 THEN 'Return'
        ELSE 'Sale'
    END AS transaction_type,
    
    -- Absolute value for quantity to measure true volume moved
    ABS(sold_quantity) AS true_quantity,
    
    -- Keep the original for financial reconciliation
    sold_quantity AS original_quantity,
    
    net_sales_amount
FROM 
    fact_sales_monthly
WHERE 
    -- Basic sanity check: remove rows where date is completely missing
    date IS NOT NULL;