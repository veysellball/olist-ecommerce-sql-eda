
WITH rfm_raw AS (
    SELECT
        c.customer_unique_id,
        DATEDIFF('day', MAX(o.order_purchase_timestamp), '2018-09-01') AS recency,
        COUNT(DISTINCT o.order_id) AS frequency,
        ROUND(SUM(p.payment_value), 2) AS monetary
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN payments p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1
),
rm_scores AS (
    SELECT *,
        6 - CAST(CEIL(CUME_DIST() OVER (ORDER BY recency) * 5) AS INT) AS r_score,
        CAST(CEIL(CUME_DIST() OVER (ORDER BY monetary) * 5) AS INT)    AS m_score
    FROM rfm_raw
)
SELECT
    CASE
        WHEN r_score >= 4 AND m_score >= 4 THEN 'Champions'      
        WHEN r_score >= 4 AND m_score  = 3 THEN 'Promising'     
        WHEN r_score >= 4 AND m_score <= 2 THEN 'New Low-Spend'  
        WHEN r_score <= 3 AND m_score >= 4 THEN 'At-Risk High-Value'
        WHEN r_score <= 2 AND m_score <= 3 THEN 'Lost'           
        ELSE 'Dormant'                                           
    END AS segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(monetary), 2) AS avg_spend,
    ROUND(AVG(recency), 0) AS avg_recency_days,
    ROUND(100.0 * AVG((frequency > 1)::INT), 2) AS repeat_order_rate
FROM rm_scores
GROUP BY 1
ORDER BY customer_count DESC;


/* core difference with other approaches is this query doesn't use NTILE and instead uses CUME_DIST to avoid the issues with the F (frequency) dimension in this specific dataset. It also uses case statements to define the segments instead of NTILE, ensuring that the same scoring logic is applied consistently regardless of the data distribution. This approach is more robust and reliable for datasets with skewed distributions or low cardinality dimensions, such as the Olist dataset where a large portion of customers have only one order. */
/* also segmentation done with R x M dimensions not F because dataset has low F values. 97% of customers have only one order */