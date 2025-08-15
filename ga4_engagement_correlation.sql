-- ga4_engagement_correlation.sql
-- Перевірка кореляції між залученістю та покупками по сесіях
WITH Hm_1 as (
  SELECT Concat (
   user_pseudo_id,
   (select value. int_value from Unnest(event_params) where key = 'ga_session_id')  
   ) as user_sessions_id,
  Max(CAST((SELECT value.string_value FROM Unnest(event_params) WHERE key = 'session_engaged') AS INT64)) AS session_engaged,
  SUM(
    COALESCE((SELECT value.int_value FROM Unnest(event_params) WHERE key = 'engagement_time_msec'), 0)
    ) AS engagement_time_msec
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  group by user_sessions_id
),
Hm_2 as (
Select DISTINCT Concat (
  user_pseudo_id,
  (select value. int_value from Unnest(event_params) where key = 'ga_session_id')  
  ) as user_sessions_id,
  True as purchase_happened
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
Where event_name IN ('purchase')
)
SELECT
CORR(session_engaged, if (purchase_happened, 1, 0)) AS corr_engaged_purchase,
CORR(engagement_time_msec, if (purchase_happened, 1, 0)) AS corr_time_purchase
FROM Hm_1 as H_1
Left Join Hm_2 as H_2 On H_1.user_sessions_id = H_2.user_sessions_id;
