# ONLINE ADS ANALYSIS REPO
👇 Collection of SQL & BigQuery projects for online advertising campaigns

---

## PROJECT 1: Facebook & Google Ads Daily Spend & ROMI | [view code](https://github.com/BasnMyk/SQL-Final-Project-Ads-GA4-Analysis/blob/main/tasks_postgres.sql)
Analysis of daily ad spend and ROMI for Google and Facebook campaigns using PostgreSQL (DBeaver).

**The Project**  
Aggregate daily spend, calculate average, min, max, find top-5 days by ROMI, identify campaigns with highest weekly value and month-to-month reach growth.

**Analysis Steps**  
- Daily spend metrics by platform  
- Top-5 ROMI days overall  
- Weekly campaign value ranking  
- Monthly reach growth by campaign  
- Longest continuous adset display (optional)

**Key Insights**  
- Highlights best-performing days and campaigns  
- Tracks campaign growth trends  
- Identifies high-performing ad sets  

---

## PROJECT 2: GA4 Events Extraction | [view code](https://github.com/BasnMyk/SQL-Final-Project-Ads-GA4-Analysis/blob/main/ga4_events_2021.sql)
Extraction of user sessions and event data from Google Analytics 4 using BigQuery.

**The Project**  
Prepare a clean table with events, users, sessions, and campaign data for 2021, including: session_start, view_item, add_to_cart, begin_checkout, add_shipping_info, add_payment_info, purchase.

**Analysis Steps**  
- Extract GA4 event data  
- Map user sessions with events  
- Filter for 2021 and key events only  

**Key Learnings**  
- Handling nested GA4 event parameters  
- Creating unique session identifiers  
- Preparing data for conversion analysis  

---

## PROJECT 3: Conversion Funnel Analysis by Traffic Source | [view code](https://github.com/BasnMyk/SQL-Final-Project-Ads-GA4-Analysis/blob/main/ga4_conversions_by_channel.sql)
Calculate session-to-purchase conversion rates by traffic source, medium, and campaign.

**The Project**  
Aggregates session-level data to calculate: visit_to_cart, visit_to_checkout, visit_to_purchase for each date and channel.

**Analysis Steps**  
- Combine user ID and session ID as unique session key  
- Aggregate by date, source, medium, campaign  
- Calculate conversion percentages  

**Key Learnings**  
- Funnel analysis for e-commerce  
- Understanding conversion drop-offs  
- Aggregation and ratio calculations  

---

## PROJECT 4: Landing Page Conversion Comparison | [view code](https://github.com/BasnMyk/SQL-Final-Project-Ads-GA4-Analysis/blob/main/ga4_landing_pages_2020.sql)
Compare conversion performance across landing pages in 2020.

**The Project**  
Compute number of sessions, purchases, and conversion rates per landing page by combining session_start and purchase events.

**Analysis Steps**  
- Extract page_path from session_start events  
- Join with purchase events by session ID  
- Aggregate metrics per page  

**Key Learnings**  
- Identifying high-converting pages  
- Session-level data merging  
- Yearly aggregated metrics  

---

## PROJECT 5: Engagement vs Purchase Correlation | [view code](https://github.com/BasnMyk/SQL-Final-Project-Ads-GA4-Analysis/blob/main/ga4_engagement_correlation.sql)
Optional advanced analysis to understand user engagement impact on purchases.

**The Project**  
Calculate correlation between session engagement and purchase occurrence.

**Analysis Steps**  
- Compute engagement_time_msec and session_engaged per session  
- Join with purchase events  
- Calculate correlation coefficients  

**Key Learnings**  
- Advanced GA4 session metrics  
- Statistical correlation in SQL  
- Insight into engagement-driven conversions  

---

## Credentials
**Mykola Basenko**  
Junior Data Analyst 
