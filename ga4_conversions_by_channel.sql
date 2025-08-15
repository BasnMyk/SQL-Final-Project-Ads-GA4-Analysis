-- ga4_conversions_by_channel.sql
-- Таблиця конверсій від старту сесії до подій cart/checkout/purchase
With Hm_1 as ( 
SELECT DATE(timestamp_micros(event_timestamp)) as event_date,
     traffic_source.source as source,
     traffic_source.medium as medium,
     traffic_source.name as campaign,
     Concat(
     user_pseudo_id,
     (select value. int_value from Unnest(event_params) where key = 'ga_session_id')  
     ) as user_sessions_id,
     event_name
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
Where event_name IN ('session_start', 'add_to_cart', 'begin_checkout', 'purchase')
),
Hm_2 as ( 
Select event_date, source, medium, campaign,
Count(Distinct Case When event_name = 'session_start' Then user_sessions_id End) as sessions_start_count,
Count(Distinct Case When event_name = 'add_to_cart' Then user_sessions_id End) as add_to_cart_count,
Count(Distinct Case When event_name = 'begin_checkout' Then user_sessions_id End) as begin_checkout_count,
Count(Distinct Case When event_name = 'purchase' Then user_sessions_id End) as purchase_count
from Hm_1
Group by event_date, source, medium, campaign
)
Select event_date, source, medium, campaign,
      sessions_start_count as user_sessions_count,
      (add_to_cart_count / sessions_start_count) * 100 as visit_to_cart, 
      (begin_checkout_count / sessions_start_count) * 100 as visit_to_checkout,
      (purchase_count / sessions_start_count) * 100 as visit_to_purchase
from Hm_2;
