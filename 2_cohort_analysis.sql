-- Description: This script creates a view for cohort analysis, which includes customer revenue, number of orders, and other customer details.

WITH customer_revenue  AS (

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
    MIN(cr.orderdate) OVER (PARTITION BY cr.customerkey) AS first_purchase_date,
    EXTRACT(YEAR FROM MIN(cr.orderdate) OVER (PARTITION BY cr.customerkey)) AS cohort_year
FROM customer_revenue cr;


