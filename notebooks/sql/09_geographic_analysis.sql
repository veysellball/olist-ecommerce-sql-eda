SELECT 
    c.customer_state,
    COUNT(DISTINCT c.customer_unique_id) AS customer_count,
    COUNT(DISTINCT o.order_id) AS order_count,
    ROUND(SUM(p.payment_value), 2) AS total_revenue,
    ROUND(SUM(p.payment_value) / COUNT(DISTINCT c.customer_unique_id), 2) AS revenue_per_customer
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY total_revenue DESC;