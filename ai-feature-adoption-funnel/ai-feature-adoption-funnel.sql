WITH funnel_data AS (
    SELECT
        user_id,
        MAX(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END) AS
            impression,
        MAX(CASE WHEN event_type = 'first_use' THEN 1 ELSE 0 END) AS
            first_use,
        MAX(CASE WHEN event_type = 'repeat_use' THEN 1 ELSE 0 END) AS
            repeat_use
    FROM ai_funnel_events
    GROUP BY user_id
)

SELECT
    'impression' AS funnel_stage,
    COUNT(user_id) AS unique_users
FROM funnel_data
WHERE impression = 1

UNION ALL

-- Backfills first_use if repeat_use is present:
SELECT
    'first_use' AS funnel_stage,
    COUNT(user_id) AS unique_users
FROM funnel_data
WHERE first_use = 1 OR repeat_use = 1

UNION ALL

SELECT
    'repeat_use' AS funnel_stage,
    COUNT(user_id) AS unique_users
FROM funnel_data
WHERE repeat_use = 1;
