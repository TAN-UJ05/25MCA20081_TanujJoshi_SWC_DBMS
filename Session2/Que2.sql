WITH max_date_cte AS (
    SELECT MAX(registration_date) AS max_reg_date 
    FROM accounts
),
user_segments AS (
    SELECT 
        user_id,
        CASE 
            WHEN (SELECT max_reg_date FROM max_date_cte) - registration_date <= 30 THEN 'new'
            ELSE 'existing'
        END AS user_segment
    FROM accounts
),
first_clicks AS (
    SELECT 
        s1.user_id,
        s1.event_id AS search_id,
        MIN(s2.event_timestamp) AS first_click_time,
        s1.event_timestamp AS search_time
    FROM search_events s1
    LEFT JOIN search_events s2 
        ON s1.session_id = s2.session_id
        AND s1.user_id = s2.user_id
        AND s2.event_type = 'click'
        AND s2.event_timestamp >= s1.event_timestamp
    WHERE s1.event_type = 'search'
    GROUP BY s1.user_id, s1.event_id, s1.event_timestamp
),
search_success AS (
    SELECT 
        user_id,
        search_id,
        CASE 
            WHEN first_click_time <= search_time + INTERVAL '30 seconds' THEN 1 
            ELSE 0 
        END AS is_successful
    FROM first_clicks
)
SELECT 
    u.user_segment,
    COUNT(s.search_id) AS total_searches,
    SUM(s.is_successful) AS successful_searches,
    SUM(s.is_successful)::FLOAT / COUNT(s.search_id) AS success_rate
FROM search_success s
JOIN user_segments u ON s.user_id = u.user_id
GROUP BY u.user_segment;
