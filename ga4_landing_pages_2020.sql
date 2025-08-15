-- ga4_landing_pages_2020.sql
-- Порівняння конверсії між різними посадковими сторінками (page path)
With Hm_1 as (Select Replace( 
(select value. string_value from Unnest(event_params) where key = 'page_location'),
'https://shop.googlemerchandisestore.com/', ''
) as page_path,
Concat (
   user_pseudo_id,
   (select value. int_value from Unnest(event_params) where key = 'ga_session_id')  
   ) as user_sessions_id,
   event_name
   FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20200101' AND '20201231'
  AND event_name IN ('session_start') 
    ),
Hm_2 as (
  SELECT Distinct Concat (
   user_pseudo_id,
   (select value. int_value from Unnest(event_params) where key = 'ga_session_id')  
   ) as user_sessions_id
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20200101' AND '20201231'
    AND event_name = 'purchase'
),
Hm_3 as (
  SELECT
    H_1.page_path,
    H_1.user_sessions_id,
  CASE WHEN H_2.user_sessions_id is not null then 1 else 0 end as purchase_1
  FROM Hm_1 as H_1
  LEFT join Hm_2 as H_2 ON H_1.user_sessions_id = H_2.user_sessions_id
)
SELECT
  page_path,
  COUNT(Distinct user_sessions_id) as sessions_start_count,
  SUM(purchase_1) as purchase_count,
  (SUM(purchase_1) / COUNT(Distinct user_sessions_id)) * 100 as visit_to_purchase
FROM Hm_3
Group by page_path;
