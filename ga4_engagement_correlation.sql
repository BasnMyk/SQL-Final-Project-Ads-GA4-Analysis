-- ga4_engagement_correlation.sql
-- Перевірка кореляції між залученістю та покупками по сесіях
-- TODO: заміни `project.dataset.events_*` на свій шлях
WITH base AS (
  SELECT
    user_pseudo_id,
    (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS session_id,
    event_name,
    -- session_engaged (string '1'/'0') і engagement_time_msec (int) з параметрів
    (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'session_engaged') AS session_engaged_str,
    COALESCE((SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'engagement_time_msec'), 0) AS engagement_time_msec
  FROM `project.dataset.events_*`
),
sessions AS (
  SELECT DISTINCT user_pseudo_id, session_id FROM base WHERE event_name = 'session_start'
),
agg AS (
  SELECT
    s.user_pseudo_id, s.session_id,
    -- Наявність взаємодії у сесії
    MAX(CASE WHEN b.session_engaged_str = '1' THEN 1 ELSE 0 END) AS session_engaged,
    -- Сумарний час взаємодії у мс
    SUM(b.engagement_time_msec) AS engagement_time_msec,
    -- Покупка в межах сесії
    MAX(CASE WHEN b.event_name = 'purchase' THEN 1 ELSE 0 END) AS is_purchase
  FROM sessions s
  JOIN base b USING (user_pseudo_id, session_id)
  GROUP BY 1,2
)
SELECT
  CORR(CAST(session_engaged AS FLOAT64), CAST(is_purchase AS FLOAT64)) AS corr_engaged_purchase,
  CORR(CAST(engagement_time_msec AS FLOAT64), CAST(is_purchase AS FLOAT64)) AS corr_time_purchase
FROM agg;
