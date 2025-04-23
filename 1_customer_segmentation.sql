/*
Customer Segmentation Analysis

This query segments customers into three value tiers based on their Lifetime Value (LTV):
- Low Value: Customers below 25th percentile of total LTV
- Mid Value: Customers between 25th and 75th percentile
- High Value: Customers above 75th percentile

The analysis uses CTEs (Common Table Expressions) to:
1. Calculate total LTV per customer
2. Determine percentile thresholds
3. Assign segments
4. Calculate metrics per segment
*/

WITH customer_ltv AS (
    
    SELECT
        customerkey,
        cleaned_name,
        SUM(total_net_revenue) AS total_ltv
    FROM cohort_analysis
    GROUP BY 
        customerkey,
        cleaned_name

), customer_segments AS(
 
    SELECT 
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_ltv) AS  ltv_25th_percentile,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_ltv) AS  ltv_75th_percentile
        
    FROM customer_ltv
), segment_values AS (
   
    SELECT
        c.*,
        CASE 
            WHEN c.total_ltv < cs.ltv_25th_percentile THEN '1 - Low Value'
            WHEN c.total_ltv <= cs.ltv_75th_percentile  THEN '2 - Mid Value'
            ELSE '3 - High Value'
        END AS customer_segment
    FROM
        customer_ltv c,
        customer_segments cs
)

SELECT
    customer_segment,
    SUM(total_ltv) AS total_ltv,              
    COUNT(customerkey) AS customer_count,      
    SUM(total_ltv) / COUNT(customerkey) AS avg_ltv_per_customer 
FROM segment_values
GROUP BY customer_segment
ORDER BY customer_segment DESC;