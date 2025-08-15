-- tasks_postgres.sql
--- Daily Ad Spend Metrics by Platform ---
select date_trunc('days', ad_date)::DATE as ad_days, 
	'Facebook Ads' as media_source,
	Round(AVG(spend), 2) as avg_spend, 
	MAX(spend) as max_spend, Min(spend) as min_spend
from facebook_ads_basic_daily
where spend is not NULL
group by ad_days 
union all
select date_trunc('days', ad_date)::DATE as ad_days, 
	'Google Ads' as media_source,
	Round(AVG(spend), 2) as avg_spend, 
	MAX(spend) as max_spend, Min(spend) as min_spend
from google_ads_basic_daily
where spend is not NULL
group by ad_days
order by ad_days; 

--- Top 5 ROMI Days Across Platforms ---
with Hm_1 as (
select date_trunc('days', ad_date)::DATE as ad_days, 
	'Facebook Ads' as media_source,
	SUM(value) as total_value, 
	Sum(spend) as total_spend
from facebook_ads_basic_daily
group by ad_days 
having Sum(spend) > 0
union all
select date_trunc('days', ad_date)::DATE as ad_days, 
	'Google Ads' as media_source,
	SUM(value) as total_value,
	Sum(spend) as total_spend
from google_ads_basic_daily
group by ad_days
having Sum(spend) > 0
)
select ad_days, Round(Sum(total_value::numeric) / Sum(total_spend), 2) as Romi
from Hm_1 
group by ad_days
order by Romi Desc
limit 5;

--- Highest Weekly Campaign Value ---
with Hm_1 as (select date_trunc('week', ad_date)::DATE as ad_week, 
	campaign_name, 
	Sum(value) as total_value
from facebook_ads_basic_daily as F1
join facebook_campaign as F2 on F1.campaign_id = F2.campaign_id
where value is not NULL
group by ad_week, campaign_name
union all
select date_trunc('week', ad_date)::DATE as ad_week, 
	campaign_name,
	Sum(value) as total_value
from google_ads_basic_daily
where value is not NULL
group by ad_week, campaign_name
)
select ad_week, campaign_name, Sum(total_value) as total_value
from Hm_1
group by ad_week, campaign_name
order by total_value Desc
limit 1;


--- Month-over-Month Reach Growth by Campaign ---
with Hm_1 as (
select date_trunc('month', ad_date)::DATE as ad_month, 
	campaign_name,
	Sum(reach) as total_reach
from facebook_ads_basic_daily as F1
join facebook_campaign as F2 on F1.campaign_id = F2.campaign_id
where reach is not NULL
group by ad_month, campaign_name
union all
select date_trunc('month', ad_date)::DATE as ad_month, 
	campaign_name,
	Sum(reach) as total_reach
from google_ads_basic_daily
where reach is not NULL
group by ad_month, campaign_name
),
Hm_2 as (
select ad_month, campaign_name, 
	Sum(total_reach) as total_reach
from Hm_1
group by ad_month, campaign_name
),
Hm_3 as (
select *, 
	Lag(total_reach) over(partition by campaign_name order by ad_month) as prv_month
from Hm_2
)
select ad_month, campaign_name, total_reach, prv_month, 
	total_reach - prv_month as change_reach
from Hm_3
where prv_month > 0
order by change_reach desc
limit 1;

--- Longest Continuous AdSet Display ---
with Hm_1 as (
select Distinct date_trunc('day', ad_date)::DATE as ad_days, 
	adset_name
from (select ad_date, adset_name
from facebook_ads_basic_daily as F1
join facebook_adset as F2 on F1.adset_id = F2.adset_id
union all
select ad_date, adset_name
from google_ads_basic_daily
) as P_1
),
Hm_2 as (
select *,
ROW_NUMBER() over(partition by adset_name order by ad_days) as rank_1
from Hm_1
), 
Hm_3 AS (
  SELECT ad_days, adset_name, rank_1,
    ad_days - rank_1 * INTERVAL '1 day' AS change_rank
  FROM Hm_2
), 
Hm_4 AS (
  SELECT adset_name,
    MIN(ad_days) AS first_date,
    MAX(ad_days) AS last_date,
    COUNT(ad_days) AS adset_days
  FROM Hm_3
  GROUP BY adset_name, change_rank
) 
SELECT adset_name, adset_days, first_date, last_date
FROM Hm_4
ORDER BY adset_days DESC
LIMIT 1;

