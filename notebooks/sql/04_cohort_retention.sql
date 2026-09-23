WITH first_order AS (
    SELECT 
        c.customer_unique_id,
        MIN(strftime(o.order_purchase_timestamp, '%Y-%m')) AS first_month
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY 1
),
customer_activity AS (
    SELECT 
        c.customer_unique_id,
        strftime(o.order_purchase_timestamp, '%Y-%m') AS order_month
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
)
SELECT 
    f.first_month AS cohort,
    COUNT(DISTINCT f.customer_unique_id) AS cohort_size,
    COUNT(DISTINCT CASE 
        WHEN a.order_month > f.first_month THEN a.customer_unique_id 
    END) AS repeat_buyers,
    ROUND(100.0 * COUNT(DISTINCT CASE 
        WHEN a.order_month > f.first_month THEN a.customer_unique_id 
    END) / COUNT(DISTINCT f.customer_unique_id), 1) AS retention_pct
FROM first_order f
LEFT JOIN customer_activity a ON f.customer_unique_id = a.customer_unique_id
GROUP BY 1
ORDER BY 1;