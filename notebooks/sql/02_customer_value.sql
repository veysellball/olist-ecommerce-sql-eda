SELECT 
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS total_spend,
    ROUND(AVG(p.payment_value), 2) AS avg_order_value,
    MIN(o.order_purchase_timestamp) AS first_order,
    MAX(o.order_purchase_timestamp) AS last_order
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY total_spend DESC
LIMIT 100;