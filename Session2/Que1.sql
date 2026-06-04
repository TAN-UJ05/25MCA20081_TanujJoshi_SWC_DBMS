WITH ranked_transactions AS (
    SELECT 
        user_id,
        created_at,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_at ASC) as rn
    FROM amazon_transactions
)
SELECT DISTINCT 
    t1.user_id
FROM ranked_transactions t1
INNER JOIN ranked_transactions t2 
    ON t1.user_id = t2.user_id 
    AND t2.rn > 1                       
WHERE t1.rn = 1                      
AND t2.created_at - t1.created_at BETWEEN 1 AND 7;
