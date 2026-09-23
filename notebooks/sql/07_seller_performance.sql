SELECT 
    s.seller_id,
    s.seller_state,
    COUNT(DISTINCT oi.order_id) AS order_count,
    COUNT(DISTINCT oi.product_id) AS product_variety,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(AVG(r.review_score), 2) AS avg_rating
FROM sellers s
JOIN order_items oi ON s.seller_id = oi.seller_id
JOIN orders o ON oi.order_id = o.order_id
LEFT JOIN reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1, 2
HAVING COUNT(DISTINCT oi.order_id) >= 20
ORDER BY total_revenue DESC
LIMIT 30;