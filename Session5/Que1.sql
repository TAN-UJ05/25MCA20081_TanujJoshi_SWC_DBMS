SELECT EXTRACT(MONTH FROM current_month.event_date) AS month, 
COUNT(DISTINCT current_month.user_id) AS monthly_active_users
FROM user_actions current_month
WHERE EXTRACT(MONTH FROM current_month.event_date) = 7
AND EXTRACT(YEAR FROM current_month.event_date) = 2022
AND EXISTS (
SELECT 1 
FROM user_actions AS previous_month
WHERE previous_month.user_id = current_month.user_id
AND EXTRACT(MONTH FROM previous_month.event_date) = 6
AND EXTRACT(YEAR FROM previous_month.event_date) = 2022
)
GROUP BY EXTRACT(MONTH FROM current_month.event_date);
