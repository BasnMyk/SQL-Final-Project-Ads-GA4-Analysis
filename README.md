# Online Advertising Campaign Analysis

## Overview
This project contains SQL scripts and analysis results for evaluating the performance of online advertising campaigns on **Facebook** and **Google Ads**.  
The analysis includes campaign performance metrics, ROMI calculation, reach analysis, and conversion funnels using **PostgreSQL (DBeaver)** and **Google BigQuery**.

## Dataset
- **facebook_ads_basic_daily** and **google_ads_basic_daily**: daily ad performance data
- **facebook_adset** and **facebook_campaign**: campaign and ad set details
- Google Analytics 4 (GA4) event data

## Tools & Technologies
- **PostgreSQL** (DBeaver)
- **Google BigQuery**
- **Google Analytics 4**
- SQL (CTEs, aggregation, joins, window functions)

## Project Tasks
1. **Aggregated Spend Analysis**  
   Calculate average, max, and min daily spend for each ad platform.
2. **Top 5 Days by ROMI**  
   Find the top 5 days with the highest ROMI across Facebook and Google Ads.
3. **Best Weekly Campaign**  
   Identify the campaign with the highest weekly total value.
4. **Reach Growth Analysis**  
   Determine the campaign with the largest month-over-month reach growth.
5. **Adset Longest Continuous Display** *(Optional)*  
   Find the longest daily continuous display period for any adset.

## Conversion Analysis (GA4 Data)
- Calculate conversion rates from session start to:
  - Add to Cart
  - Checkout
  - Purchase

## Results
- Determined top 5 ROMI days across all channels.
- Identified most effective campaign based on weekly value.
- Built conversion funnel metrics and provided actionable recommendations for campaign optimization.

## Repository Structure
```
Online_Ads_Analysis_SQL/
│── sql/              # SQL scripts for PostgreSQL tasks
│── bigquery/         # SQL scripts for BigQuery tasks
│── README.md         # Project documentation
```

## Author
Basenko Mykola  
Junior Data Analyst  
[LinkedIn](https://linkedin.com/in/yourprofile) | [Email](mailto:basnkonkolia6@gmail.com)
