-- ga4_landing_pages_2020.sql
-- Порівняння конверсії між різними посадковими сторінками (page path)
-- TODO: заміни `project.dataset.events_*` на свій шлях
WITH base AS (
  SELECT
    user_pseudo_id,
    (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS session_id,
    event_name,
    (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'page_location') AS page_location,
    TIMESTAMP_MICROS(event_timestamp) AS event_ts
  FROM `project.dataset.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20200101' AND '20201231'
    AND event_name IN ('session_start','purchase','page_view')
),
starts AS (
  SELECT
    user_pseudo_id, session_id, event_ts,
    REGEXP_EXTRACT(page_location, r'https?://[^/]+(/[^?#]*)') AS page_path
  FROM base
  WHERE event_name = 'session_start'
),
purchases AS (
  SELECT DISTINCT user_pseudo_id, session_id
  FROM base
  WHERE event_name = 'purchase'
)
SELECT
  page_path,
  COUNT(DISTINCT CONCAT(s.user_pseudo_id, '-', s.session_id)) AS sessions_unique,
  COUNT(DISTINCT IF(p.user_pseudo_id IS NOT NULL, CONCAT(s.user_pseudo_id, '-', s.session_id), NULL)) AS purchases_unique,
  SAFE_DIVIDE(
    COUNT(DISTINCT IF(p.user_pseudo_id IS NOT NULL, CONCAT(s.user_pseudo_id, '-', s.session_id), NULL)),
    COUNT(DISTINCT CONCAT(s.user_pseudo_id, '-', s.session_id))
  ) AS visit_to_purchase
FROM starts s
LEFT JOIN purchases p USING (user_pseudo_id, session_id)
GROUP BY 1
ORDER BY sessions_unique DESC;
