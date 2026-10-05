SELECT
    user_id,
    AVG(TIMESTAMPDIFF(second, page_load, page_exit)) AS
        avg_session_duration
FROM(
    SELECT
        user_id,
        DATE(timestamp),
        MAX(CASE WHEN action = 'page_load' THEN TIME(timestamp) END)
            AS page_load,
        MIN(CASE WHEN action = 'page_exit' THEN TIME(timestamp) END)
            AS page_exit
    FROM facebook_web_log
    GROUP BY user_id, DATE(timestamp)
) AS sub
WHERE page_exit > page_load
GROUP BY user_id;
