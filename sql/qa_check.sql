-- QA Check 1: Are there any orphaned products?
SELECT COUNT(*) AS orphaned_products
FROM fact_sales_monthly f
LEFT JOIN dim_product p ON f.product_code = p.product_code
WHERE p.product_code IS NULL;

-- QA Check 2: Are there any orphaned customers?
SELECT COUNT(*) AS orphaned_customers
FROM fact_sales_monthly f
LEFT JOIN dim_customer c ON f.customer_code = c.customer_code
WHERE c.customer_code IS NULL;