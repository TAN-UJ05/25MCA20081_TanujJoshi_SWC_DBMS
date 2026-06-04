WITH monthly_metrics AS (
    SELECT 
        product_id,
        product_name,
        month_start,
        monthly_active_users AS m0,
        LAG(monthly_active_users, 1) OVER (PARTITION BY product_id ORDER BY month_start) AS m_minus1,
        LAG(monthly_active_users, 2) OVER (PARTITION BY product_id ORDER BY month_start) AS m_minus2,
        LAG(month_start, 2) OVER (PARTITION BY product_id ORDER BY month_start) AS decline_start_month,
        LEAD(monthly_active_users, 1) OVER (PARTITION BY product_id ORDER BY month_start) AS m_plus1,
        LEAD(monthly_active_users, 2) OVER (PARTITION BY product_id ORDER BY month_start) AS m_plus2
    FROM product_engagement
)
SELECT 
    product_name,
    decline_start_month AS month_decline_started,
    month_start AS month_growth_resumed,
    ((m_plus2::numeric - m0) / m0) AS growth_ratio
FROM monthly_metrics
WHERE 
    m_minus2 > m_minus1 AND m_minus1 > m0
    AND m0 < m_plus1 AND m_plus1 < m_plus2
ORDER BY 
    product_name, 
    month_decline_started;
