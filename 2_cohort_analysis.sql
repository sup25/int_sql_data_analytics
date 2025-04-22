/* 
CREATE OR REPLACE VIEW public.cohort_analysis AS
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
    cr.*,
    MIN(cr.orderdate) OVER (PARTITION BY cr.customerkey) AS first_purchase_date,
    EXTRACT(YEAR FROM MIN(cr.orderdate) OVER (PARTITION BY cr.customerkey)) AS cohort_year
FROM customer_revenue cr;
 */


/* SELECT 
    cohort_year,
    COUNT(DISTINCT customerkey) AS total_customers,
    SUM(total_net_revenue) AS total_revenue,
    SUM(total_net_revenue) / COUNT(DISTINCT customerkey) AS customer_revenue
FROM cohort_analysis
WHERE orderdate = first_purchase_date
GROUP BY cohort_year */

/* WITH sales_data AS(
    SELECT 
        customerkey,
        SUM(quantity*netprice*exchangerate) AS net_revenue
    FROM sales
    GROUP BY customerkey
)

SELECT 
   
    AVG(s.net_revenue) AS spending_customer_avg_net_revenue,
   AVG(COALESCE(s.net_revenue, 0)) AS all_customer_avg_net_revenue

FROM customer c
LEFT JOIN sales_data s on c.customerkey = s.customerkey */


/* "customerkey","net_revenue"
15,2217.4064388
23,""
36,""
120,""
180,2510.2152567999997
185,1395.5234436
189,""
210,""
225,""
243,287.66755741500003 */

/* SELECT LOWER ('SUPARNA ADHIKARI') */

/* DROP VIEW cohort_analysis;
CREATE OR REPLACE VIEW public.cohort_analysis AS 
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
FROM customer_revenue cr; */