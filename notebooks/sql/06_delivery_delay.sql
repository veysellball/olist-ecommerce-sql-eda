SELECT 
    strftime(order_purchase_timestamp, '%Y-%m') AS month,
    COUNT(*) AS total_orders,
    COUNT(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date 
               THEN 1 END) AS late_orders,
    ROUND(100.0 * COUNT(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date 
                              THEN 1 END) / COUNT(*), 1) AS late_pct,
    ROUND(AVG(
        DATEDIFF('day', order_purchase_timestamp, order_delivered_customer_date)
    ), 1) AS avg_delivery_days
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
GROUP BY 1
ORDER BY 1;