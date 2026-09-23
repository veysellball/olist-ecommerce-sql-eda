SELECT 
    payment_type,
    COUNT(*) AS transaction_count,
    ROUND(AVG(payment_installments), 1) AS avg_installments,
    ROUND(AVG(payment_value), 2) AS avg_amount,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS market_share
FROM payments
WHERE payment_type != 'not_defined'
GROUP BY 1
ORDER BY transaction_count DESC;