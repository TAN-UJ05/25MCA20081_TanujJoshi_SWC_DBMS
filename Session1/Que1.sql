SELECT 
    s.date,
    COUNT(a.date)::DECIMAL / COUNT(s.date) AS percentage_acceptance
FROM 
    fb_friend_requests s
LEFT JOIN 
    fb_friend_requests a 
    ON s.user_id_sender = a.user_id_sender 
    AND s.user_id_receiver = a.user_id_receiver 
    AND a.action = 'accepted'
WHERE 
    s.action = 'sent'
GROUP BY 
    s.date
HAVING 
    COUNT(a.date) > 0
ORDER BY 
    s.date;
