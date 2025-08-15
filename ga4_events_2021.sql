-- ga4_events_2021.sql
-- TODO: заміни `project.dataset.events_*` на свій шлях до таблиць GA4
WITH events AS (
  SELECT
    TIMESTAMP_MICROS(event_timestamp) AS event_timestamp,
    user_pseudo_id,
    -- session_id з параметра ga_session_id
    (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS session_id,
    event_name,
    geo.country AS country,
    device.category AS device_category,
    traffic_source.source AS source,
    traffic_source.medium AS medium,
    traffic_source.name AS campaign
  FROM `project.dataset.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20210101' AND '20211231'
    AND event_name IN (
      'session_start','view_item','add_to_cart',
      'begin_checkout','add_shipping_info','add_payment_info','purchase'
    )
)
SELECT * FROM events;
