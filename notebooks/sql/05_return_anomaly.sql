WITH category_stats AS (
    SELECT 
        p.product_category_name,
        COUNT(DISTINCT o.order_id) AS total_orders,
        COUNT(DISTINCT CASE WHEN o.order_status = 'canceled' THEN o.order_id END) AS canceled,
        ROUND(100.0 * COUNT(DISTINCT CASE WHEN o.order_status = 'canceled' THEN o.order_id END) 
              / COUNT(DISTINCT o.order_id), 2) AS cancel_pct
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    GROUP BY 1
    HAVING COUNT(DISTINCT o.order_id) >= 50
)
SELECT *,
    AVG(cancel_pct) OVER () AS overall_avg,
    ROUND(cancel_pct - AVG(cancel_pct) OVER (), 2) AS deviation
FROM category_stats
ORDER BY cancel_pct DESC
LIMIT 20;

