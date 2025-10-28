select * from ad_events

select * from ads

select * from campaigns

select * from users

/*
  ALll Kpis Queries
*/

------------------------------------------   1 Count of Impressinos  -------------------------

SELECT
    adds.ad_platform as Platforms,
    COUNT(add_event.event_type) AS Impression_count
FROM
    ad_events AS add_event
INNER JOIN
    ads AS adds
ON
    add_event.ad_id = adds.ad_id
WHERE
    add_event.event_type = 'Impression'
GROUP BY
    adds.ad_platform



    ------------------------------------------   2 Count of Clicks  -------------------------

SELECT
    adds.ad_platform as Platforms,
    COUNT(add_event.event_type) AS Click_count
FROM
    ad_events AS add_event
INNER JOIN
    ads AS adds
ON
    add_event.ad_id = adds.ad_id
WHERE
    add_event.event_type = 'Click'
GROUP BY
    adds.ad_platform

        ------------------------------------------   3 Count of Share  -------------------------

SELECT
    adds.ad_platform as Platforms,
    COUNT(add_event.event_type) AS Share_count
FROM
    ad_events AS add_event
INNER JOIN
    ads AS adds
ON
    add_event.ad_id = adds.ad_id
WHERE
    add_event.event_type = 'Share'
GROUP BY
    adds.ad_platform


     ------------------------------------------   4 Count of Comment  -------------------------

SELECT
    adds.ad_platform as Platforms,
    COUNT(add_event.event_type) AS Comment_count
FROM
    ad_events AS add_event
INNER JOIN
    ads AS adds
ON
    add_event.ad_id = adds.ad_id
WHERE
    add_event.event_type = 'Comment'
GROUP BY
    adds.ad_platform



     ------------------------------------------   5 Count of Purchase  -------------------------

SELECT
    adds.ad_platform as Platforms,
    COUNT(add_event.event_type) AS Purchase_count
FROM
    ad_events AS add_event
INNER JOIN
    ads AS adds
ON
    add_event.ad_id = adds.ad_id
WHERE
    add_event.event_type = 'Purchase'
GROUP BY
    adds.ad_platform


 ------------------------------------------   6 Count of Engagment (Click,Share,Comment)  -------------------------

SELECT
    adds.ad_platform as Platforms,
    COUNT(add_event.event_type) AS Engagment_count
FROM
    ad_events AS add_event
INNER JOIN
    ads AS adds
ON
    add_event.ad_id = adds.ad_id
WHERE
    add_event.event_type = 'Click' or 
    add_event.event_type = 'Comment' or
    add_event.event_type = 'Share'
GROUP BY
    adds.ad_platform


     ------------------------------------------   7 CTR (Click Through Rate)  -------------------------
     -- (Clicks ÷ Impressions) × 100

SELECT 
    adds.ad_platform,
     SUM(CASE WHEN ad_event.event_type = 'impression' THEN 1 ELSE 0 END) AS impressions,
    SUM(CASE WHEN ad_event.event_type = 'click' THEN 1 ELSE 0 END) AS clicks,
    ROUND(
         (SUM(CASE WHEN ad_event.event_type = 'click' THEN 1 ELSE 0 END)   
            * 100.0 /
            NULLIF
            (SUM(CASE WHEN ad_event.event_type = 'impression' THEN 1 ELSE 0 END), 0)
         ),
        2
    ) AS ctr_percentage
FROM ad_events ad_event
JOIN ads adds
    ON ad_event.ad_id = adds.ad_id
GROUP BY adds.ad_platform;

 ------------------------------------------   8 Engagement Rate  -------------------------
 ---(Engagements ÷ Impressions) × 100 
 ---(Engagement = Clicks + Shares + Comments)


SELECT 
    adds.ad_platform,
    SUM(CASE WHEN ad_event.event_type = 'impression' THEN 1 ELSE 0 END) AS impressions,
    SUM(CASE WHEN ad_event.event_type In ('click','Share','Comment') THEN 1 ELSE 0 END) AS Engagement,
    ROUND(
         (SUM(CASE WHEN ad_event.event_type In ('click','Share','Comment') THEN 1 ELSE 0 END)   
            * 100.0 /
            NULLIF
            (SUM(CASE WHEN ad_event.event_type = 'impression' THEN 1 ELSE 0 END), 0)
         ),
        2
    ) AS Eng_percentage
FROM ad_events ad_event
JOIN ads adds
    ON ad_event.ad_id = adds.ad_id
GROUP BY adds.ad_platform;


------------------------------------------   9 Conversion Rate  -------------------------
 ---(Purchases ÷ Clicks) × 100
 
SELECT 
    adds.ad_platform,
    SUM(CASE WHEN ad_event.event_type = 'Purchase' THEN 1 ELSE 0 END) AS Purchase,
    ROUND(
         (SUM(CASE WHEN ad_event.event_type = 'Purchase' THEN 1 ELSE 0 END)   
            * 100.0 /
            NULLIF
            (SUM(CASE WHEN ad_event.event_type = 'Click' THEN 1 ELSE 0 END), 0)
         ),
        2
    ) AS Conversion_percentage
FROM ad_events ad_event
JOIN ads adds
    ON ad_event.ad_id = adds.ad_id
GROUP BY adds.ad_platform;


------------------------------------------   10 Purchase Rate  -------------------------
 --- (Purchases ÷ Impressions) × 100
 
SELECT 
    adds.ad_platform,
    SUM(CASE WHEN ad_event.event_type = 'Purchase' THEN 1 ELSE 0 END) AS Purchase,
    ROUND(
         (SUM(CASE WHEN ad_event.event_type = 'Purchase' THEN 1 ELSE 0 END)   
            * 100.0 /
            NULLIF
            (SUM(CASE WHEN ad_event.event_type = 'Impression' THEN 1 ELSE 0 END), 0)
         ),
        2
    ) AS Purchase_Rate
FROM ad_events ad_event
JOIN ads adds
    ON ad_event.ad_id = adds.ad_id
GROUP BY adds.ad_platform;


------------------------------------------   11 Total Budget  -------------------------

select sum(total_budget) as TotalBudget from campaigns
select count(total_budget) as TotalBudget from campaigns


------------------------------------------   12 Avg. Budget per Campaign  -------------------------
----Total Budget ÷ Campaign Count


select (SUM(total_budget)/ COUNT(total_budget))
         as AvgBudget from campaigns






























