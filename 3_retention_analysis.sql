/*
Retention Analysis

This query analyzes customer retention and churn by:
1. Identifying each customer's last purchase date
2. Classifying customers as 'Active' or 'Churned' based on 6-month inactivity
3. Analyzing retention rates by cohort year
4. Calculating customer distribution across statuses

Key metrics:
- Customer status (Active/Churned)
- Last purchase dates
- Retention rates by cohort
- Customer distribution percentages
*/

WITH customer_last_purchase AS (
   
    SELECT
        customerkey,
        cleaned_name,
        orderdate,
        ROW_NUMBER() OVER (PARTITION BY customerkey ORDER BY cohort_year DESC) AS rn,  
        first_purchase_date,
        cohort_year
    FROM cohort_analysis
), churned_customers as(  
    -- A customer is considered churned if their last purchase was more than 6 months ago
    SELECT
        customerkey,
        cleaned_name,   
        orderdate AS last_purchase_date,
        CASE
            WHEN orderdate < (SELECT MAX(orderdate) FROM sales) - INTERVAL '6 months' THEN 'Churned'
            ELSE 'Active' 
        END AS customer_status,
        cohort_year
    FROM customer_last_purchase
    WHERE rn = 1  -- Only consider the most recent purchase
        AND first_purchase_date < (SELECT MAX(orderdate) FROM sales) - INTERVAL '6 months'
)
-- Calculate retention metrics by cohort
SELECT
    cohort_year,
    customer_status,
    COUNT(customerkey) AS customer_count,                         
    SUM(COUNT(customerkey)) OVER (PARTITION BY cohort_year) AS total_customers,  
    ROUND(
        COUNT(customerkey) / 
        SUM(COUNT(customerkey)) OVER (PARTITION BY cohort_year) * 100, 
        2
    ) AS status_percentage  -- Percentage of customers in each status within their cohort
FROM churned_customers
GROUP BY 
    cohort_year,
    customer_status




