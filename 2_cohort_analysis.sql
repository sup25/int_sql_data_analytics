/*
Cohort Analysis

This query creates a comprehensive view of customer behavior and demographics by:
1. Calculating revenue metrics per customer
2. Tracking first purchase dates to establish cohorts
3. Combining sales data with customer demographics
4. Grouping customers by their cohort year (year of first purchase)

The analysis helps understand:
- Customer spending patterns over time
- Order frequency
- Geographic distribution of customers
- Age demographics
- Revenue trends by cohort
*/

WITH customer_revenue AS (
    
    SELECT 
        s.customerkey,
        s.orderdate,
        SUM(quantity*netprice*exchangerate) AS total_net_revenue,  
        COUNT(s.orderkey) AS num_orders,                          
        c.countryfull,                                            
        c.age,                                                    
        c.givenname,
        c.surname
       
        FROM sales s
        LEFT JOIN customer c ON c.customerkey = s.customerkey
        GROUP BY 
            s.customerkey,
            s.orderdate,
            c.countryfull,
            c.age,
            c.givenname,
            c.surname
)


SELECT 
    customerkey,
    total_net_revenue,
    num_orders,
    countryfull,
    age,
    CONCAT(TRIM(givenname), ' ', TRIM(surname)) AS cleaned_name,
    MIN(cr.orderdate) OVER (PARTITION BY cr.customerkey) AS first_purchase_date,    -- Identify first purchase date
    EXTRACT(YEAR FROM MIN(cr.orderdate) OVER (PARTITION BY cr.customerkey)) AS cohort_year    -- Determine cohort year
FROM customer_revenue cr;


