WITH last_order AS (
    SELECT 
        c.customer_unique_id,
        MAX(o.order_purchase_timestamp) AS last_order_date
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1
)
SELECT 
    CASE 
        WHEN last_order_date >= '2018-06-01' THEN 'active_90d'
        WHEN last_order_date >= '2018-03-01' THEN 'inactive_90_180d'
        ELSE 'lost'
    END AS segment,
    COUNT(*) AS customer_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS percent
FROM last_order
GROUP BY 1
ORDER BY 2 DESC;