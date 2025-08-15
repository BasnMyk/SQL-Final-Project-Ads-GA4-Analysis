-- ga4_conversions_by_channel.sql
-- Таблиця конверсій від старту сесії до подій cart/checkout/purchase
-- TODO: заміни `project.dataset.events_*` на свій шлях
WITH base AS (
  SELECT
    DATE(TIMESTAMP_MICROS(event_timestamp)) AS event_date,
    user_pseudo_id,
    (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS session_id,
    event_name,
    traffic_source.source AS source,
    traffic_source.medium AS medium,
    traffic_source.name AS campaign
  FROM `project.dataset.events_*`
  WHERE event_name IN ('session_start','add_to_cart','begin_checkout','purchase')
),
sessions AS (
  SELECT DISTINCT event_date, user_pseudo_id, session_id, source, medium, campaign
  FROM base
  WHERE event_name = 'session_start'
),
cart AS (
  SELECT DISTINCT user_pseudo_id, session_id FROM base WHERE event_name = 'add_to_cart'
),
checkout AS (
  SELECT DISTINCT user_pseudo_id, session_id FROM base WHERE event_name = 'begin_checkout'
),
purchase AS (
  SELECT DISTINCT user_pseudo_id, session_id FROM base WHERE event_name = 'purchase'
)
SELECT
  s.event_date,
  s.source, s.medium, s.campaign,
  COUNT(DISTINCT CONCAT(s.user_pseudo_id, '-', s.session_id)) AS user_sessions_count,
  SAFE_DIVIDE(COUNT(DISTINCT IF(c.user_pseudo_id IS NOT NULL, CONCAT(s.user_pseudo_id, '-', s.session_id), NULL)),
              COUNT(DISTINCT CONCAT(s.user_pseudo_id, '-', s.session_id))) AS visit_to_cart,
  SAFE_DIVIDE(COUNT(DISTINCT IF(ch.user_pseudo_id IS NOT NULL, CONCAT(s.user_pseudo_id, '-', s.session_id), NULL)),
              COUNT(DISTINCT CONCAT(s.user_pseudo_id, '-', s.session_id))) AS visit_to_checkout,
  SAFE_DIVIDE(COUNT(DISTINCT IF(p.user_pseudo_id IS NOT NULL, CONCAT(s.user_pseudo_id, '-', s.session_id), NULL)),
              COUNT(DISTINCT CONCAT(s.user_pseudo_id, '-', s.session_id))) AS visit_to_purchase
FROM sessions s
LEFT JOIN cart c USING (user_pseudo_id, session_id)
LEFT JOIN checkout ch USING (user_pseudo_id, session_id)
LEFT JOIN purchase p USING (user_pseudo_id, session_id)
GROUP BY 1,2,3,4
ORDER BY 1,2,3,4;
