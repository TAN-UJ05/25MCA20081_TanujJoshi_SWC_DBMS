WITH RECURSIVE calendar AS (
    SELECT '2025-04-15'::DATE AS transaction_date
    UNION ALL
    SELECT (transaction_date + INTERVAL '1 day')::DATE
    FROM calendar
    WHERE transaction_date < '2025-04-28'
),
eligible_purchases AS (
    SELECT 
        transaction_id,
        transaction_date,
        amount
    FROM product_sales
    WHERE product_id = 'PROD-2891'
      AND country = 'US'
      AND type = 'purchase'
      AND status = 'completed'
      AND transaction_date BETWEEN '2025-04-15' AND '2025-04-28'
),
eligible_refunds AS (
    SELECT 
        p.transaction_date,  
        -r.amount AS amount  
    FROM product_sales r
    JOIN eligible_purchases p ON r.original_transaction_id = p.transaction_id
    WHERE r.type = 'refund'
      AND r.status = 'completed'
),
all_financial_activities AS (
    SELECT transaction_date, amount FROM eligible_purchases
    UNION ALL
    SELECT transaction_date, amount FROM eligible_refunds
)
SELECT 
    c.transaction_date,
    COALESCE(SUM(f.amount), 0) AS daily_net_revenue
FROM calendar c
LEFT JOIN all_financial_activities f ON c.transaction_date = f.transaction_date
GROUP BY c.transaction_date
ORDER BY c.transaction_date;
