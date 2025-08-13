
DELETE FROM [db_dev].[dbo].[Scaling_Path_PBI_Attribution2];

-- From file: Update Table 3 Attribution Updated.sql
INSERT INTO [db_dev].[dbo].[Scaling_Path_PBI_Attribution2] (
  [Date]
      ,[Source]
      ,[Platform_In]
      ,[Account_Id]
      ,[AccountGroup_Id]
      ,[Account_Ds]
      ,[SourceMedium]
      ,[Source_Nm]
      ,[Medium_Nm]
      ,[Campaign_Nm]
      ,[New_mapping]
      ,[Sessions]
      ,[Transactions]
      ,[NewUsers]
      ,[Cost]
      ,[Revenue]
	  ,[Attributed_Revenue]
      ,[GA_last_click_revenue]
      ,[embedded_awareness]
      ,[Revenue_minus_embedded_awareness]
      ,[map_query_id]
      ,[map_query_type]
      ,[Attributed_Transactions]
	  ,[Impressions]
      ,[Link_Clicks]
      ,[Engaged_Sessions]
	  ,[lock_status]
	  ,[click_status])

	  
SELECT        
  Date, 
  Source, 
  Platform_In, 
  Account_Id, 
  AccountGroup_Id, 
  Account_Ds, 
  SourceMedium, 
  Source_Nm, 
  Medium_Nm, 
  Campaign_Nm, 
  New_mapping, 
  Sessions, 
  Transactions, 
  NewUsers, 
  Cost, 
  Revenue, 
  -- Attributed_Revenue
  CASE 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('Paid Social - Iris') THEN GA_last_click_revenue * 1 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('Paid Social Awareness') THEN GA_last_click_revenue * 1 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('Paid Social - Iris - B') THEN GA_last_click_revenue * 1 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('Paid Social Awareness - B') THEN GA_last_click_revenue * 1 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('Non-Coupon Affiliate(s)') THEN GA_last_click_revenue * 1 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('Youtube Prospecting') THEN GA_last_click_revenue * 2 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('Referral') THEN GA_last_click_revenue * 1 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('Misc/Uncategorized') THEN GA_last_click_revenue * 1 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('eMail', 'Email') THEN GA_last_click_revenue * 0.75 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('Coupon Affiliate(s)') THEN GA_last_click_revenue * 0.1 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('Attentive - SMS/Text') THEN GA_last_click_revenue * 0.5 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('TikTok Remarketing') THEN GA_last_click_revenue * 2 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('Facebook Remarketing') THEN GA_last_click_revenue * 2 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('Pinterest Remarketing') THEN GA_last_click_revenue * 3 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('Google Display and Video Retargeting') THEN GA_last_click_revenue * 1.5  
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('Direct', 'Not Set / Not Set', 'Not Set', 'Miscellaneous Payment Redirect', 'Organic - Brand') THEN 0 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('Google Brand Text', 'Microsoft Brand Text') THEN GA_last_click_revenue * 0.5 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('Google Brand Shopping', 'Microsoft Brand Shopping') THEN GA_last_click_revenue * 0.8 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('Facebook Prospecting') THEN cost * 6
    WHEN AccountGroup_Id >= 0 THEN GA_last_click_revenue 
  END AS Attributed_Revenue,

  GA_last_click_revenue,  
  embedded_awareness, 
  GA_last_click_revenue - (GA_last_click_revenue * 0.133) AS Revenue_minus_embedded_awareness, 
  map_query_id, 
  map_query_type,

  -- Attributed_Transactions
  CASE 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('Paid Social - Iris') THEN Transactions * 1 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('Paid Social Awareness') THEN Transactions * 1 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('Non-Coupon Affiliate(s)') THEN Transactions * 1 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('Youtube Prospecting') THEN Transactions * 2 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('Referral') THEN Transactions * 1 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('Misc/Uncategorized') THEN Transactions * 1 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('eMail', 'Email') THEN Transactions * 0.75 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('Coupon Affiliate(s)') THEN Transactions * 0.1 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('Attentive - SMS/Text') THEN Transactions * 0.5 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('TikTok Remarketing') THEN Transactions * 2 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('Facebook Remarketing') THEN Transactions * 2 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('Facebook Prospecting') THEN Transactions 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('Google Display and Video Retargeting') THEN Transactions * 1.5  
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('Direct', 'Not Set / Not Set', 'Not Set', 'Miscellaneous Payment Redirect', 'Organic - Brand') THEN 0 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('Google Brand Text', 'Microsoft Brand Text') THEN Transactions * 0.5 
    WHEN AccountGroup_Id = 2 AND New_mapping IN ('Google Brand Shopping', 'Microsoft Brand Shopping') THEN Transactions * 0.8 
    WHEN AccountGroup_Id >= 0 THEN Transactions 
  END AS Attributed_Transactions,

  Impressions,
  Link_Clicks,
  Engaged_Sessions,
  'Locked' AS lock_status,
  NULL AS click_status
FROM [db_dev].[dbo].[Scaling_Path_PBI_Campaigns]
WHERE AccountGroup_Id = 2

UNION ALL
SELECT        Date, Source, Platform_In, Account_Id, AccountGroup_Id, Account_Ds, SourceMedium, Source_Nm, Medium_Nm, Campaign_Nm, 'Organic Brand' AS New_mapping, 
Sessions * .81 AS Sessions, 
 Transactions * .81 AS Transactions, 
 NewUsers * .81 AS NewUsers, 
 Cost * .81 AS Cost, 
 Revenue *.81 AS Revenue, 
 0 AS Attributed_Revenue, 
 GA_last_click_revenue * .81 AS GA_last_click_revenue, 
 embedded_awareness, 
 Revenue_minus_embedded_awareness, map_query_id, map_query_type, 
   0 AS  Attributed_Transactions, 
 Impressions* .81 as Impressions,Link_Clicks* .81 as Link_Clicks,Engaged_Sessions* .81 as Engaged_Sessions, 'Locked' AS lock_status, null as click_status
  FROM [db_dev].[dbo].[Scaling_Path_PBI_Campaigns]
WHERE        New_mapping IN ('Organic Brand and Non-Brand') AND AccountGroup_Id=2

UNION ALL
SELECT        Date, Source, Platform_In, Account_Id, AccountGroup_Id, Account_Ds, SourceMedium, Source_Nm, Medium_Nm, Campaign_Nm, 'Organic Non-Brand' AS New_mapping, 
Sessions *.19 AS Sessions, 
Transactions *.19 AS Transactions, 
NewUsers *.19 AS NewUsers, 
Cost *.19 AS Cost, 
Revenue *.19 AS Revenue, 
GA_last_click_revenue *.19 AS Attributed_Revenue, 
GA_last_click_revenue *.19 AS GA_last_click_revenue, 
 embedded_awareness, Revenue_minus_embedded_awareness, map_query_id, map_query_type,
 Transactions *.19 AS Attributed_Transactions,
 Impressions* .19 as Impressions,Link_Clicks* .19 as Link_Clicks,Engaged_Sessions* .19 as Engaged_Sessions, 'UnLocked' AS lock_status, null as click_status
  FROM [db_dev].[dbo].[Scaling_Path_PBI_Campaigns]
WHERE        New_mapping IN ('Organic Brand and Non-Brand') AND AccountGroup_Id=2

UNION ALL
SELECT        Date, Source, Platform_In, Account_Id, AccountGroup_Id, Account_Ds, SourceMedium, Source_Nm, Medium_Nm, Campaign_Nm, 'Coupon Affiliate(s)' AS New_mapping, 
Sessions * .5 AS Sessions, 
 Transactions * .5 AS Transactions, 
 NewUsers * .5 AS NewUsers, 
 Cost * .5 AS Cost, 
 Revenue *.5 AS Revenue, 
 (GA_last_click_revenue * .5)*.15 AS Attributed_Revenue, 
 GA_last_click_revenue * .5 AS GA_last_click_revenue, 
 embedded_awareness, 
 Revenue_minus_embedded_awareness, map_query_id, map_query_type, 
   (Transactions * .5)*.15 AS  Attributed_Transactions, 
Impressions* .5 as Impressions,Link_Clicks* .5 as Link_Clicks,Engaged_Sessions* .5 as Engaged_Sessions, 'Locked' AS lock_status, null as click_status
  FROM [db_dev].[dbo].[Scaling_Path_PBI_Campaigns]
WHERE        New_mapping IN ('Affiliate Split') AND AccountGroup_Id=2

UNION ALL
SELECT        Date, Source, Platform_In, Account_Id, AccountGroup_Id, Account_Ds, SourceMedium, Source_Nm, Medium_Nm, Campaign_Nm, 'Non-Coupon Affiliate(s)' AS New_mapping, 
Sessions * .5 AS Sessions, 
 Transactions * .5 AS Transactions, 
 NewUsers * .5 AS NewUsers, 
 Cost * .5 AS Cost, 
 Revenue *.5 AS Revenue, 
  GA_last_click_revenue * .5 AS Attributed_Revenue, 
 GA_last_click_revenue * .5 AS GA_last_click_revenue, 
 embedded_awareness, 
 Revenue_minus_embedded_awareness, map_query_id, map_query_type, 
   Transactions * .5 AS  Attributed_Transactions, 
Impressions* .5 as Impressions,Link_Clicks* .5 as Link_Clicks,Engaged_Sessions* .5 as Engaged_Sessions, 'UnLocked' AS lock_status, null as click_status
  FROM [db_dev].[dbo].[Scaling_Path_PBI_Campaigns]
WHERE        New_mapping IN ('Affiliate Split') AND AccountGroup_Id=2

UNION ALL
SELECT        Date, Source, Platform_In, Account_Id, AccountGroup_Id, Account_Ds, SourceMedium, Source_Nm, Medium_Nm, Campaign_Nm, 
'Google Non-Brand Text' AS New_mapping, 
Sessions *.19 AS Sessions, 
Transactions *.19 AS Transactions, 
NewUsers *.19 AS NewUsers, 
Cost *.19 AS Cost, 
Revenue *.19 AS Revenue, 
GA_last_click_revenue *.19 AS Attributed_Revenue, 
GA_last_click_revenue *.19 AS GA_last_click_revenue, 
 embedded_awareness, Revenue_minus_embedded_awareness, map_query_id, map_query_type, 
 Transactions*.19 AS  Attributed_Transactions,
Impressions* .19 as Impressions,Link_Clicks* .19 as Link_Clicks,Engaged_Sessions* .19 as Engaged_Sessions, 'UnLocked' AS lock_status, null as click_status
  FROM [db_dev].[dbo].[Scaling_Path_PBI_Campaigns]
WHERE New_mapping IN ('CPC') AND AccountGroup_Id=2

UNION ALL
SELECT        Date, Source, Platform_In, Account_Id, AccountGroup_Id, Account_Ds, SourceMedium, Source_Nm, Medium_Nm, Campaign_Nm, 
'Google Non-Brand Shopping' AS New_mapping, 
Sessions *.55 AS Sessions, 
Transactions *.55 AS Transactions, 
NewUsers *.55 AS NewUsers, 
Cost *.55 AS Cost, 
Revenue *.55 AS Revenue, 
GA_last_click_revenue *.55 AS Attributed_Revenue, 
GA_last_click_revenue *.55 AS GA_last_click_revenue, 
 embedded_awareness, Revenue_minus_embedded_awareness, map_query_id, map_query_type, 
 Transactions*.55 AS  Attributed_Transactions,
Impressions* .55 as Impressions,Link_Clicks* .55 as Link_Clicks,Engaged_Sessions* .55 as Engaged_Sessions, 'UnLocked' AS lock_status, null as click_status
  FROM [db_dev].[dbo].[Scaling_Path_PBI_Campaigns]
WHERE New_mapping IN ('CPC') AND AccountGroup_Id=2

UNION ALL
SELECT        Date, Source, Platform_In, Account_Id, AccountGroup_Id, Account_Ds, SourceMedium, Source_Nm, Medium_Nm, Campaign_Nm, 
'Google Brand Shopping' AS New_mapping, 
Sessions *.10 AS Sessions, 
Transactions *.10 AS Transactions, 
NewUsers *.10 AS NewUsers, 
Cost *.10 AS Cost, 
Revenue *.10 AS Revenue, 
(GA_last_click_revenue *.10)*.8 AS Attributed_Revenue, 
GA_last_click_revenue *.10 AS GA_last_click_revenue, 
 embedded_awareness, Revenue_minus_embedded_awareness, map_query_id, map_query_type, 
 (Transactions*.10)*.8 AS  Attributed_Transactions,
Impressions* .10 as Impressions,Link_Clicks* .10 as Link_Clicks,Engaged_Sessions* .10 as Engaged_Sessions, 'Locked' AS lock_status, null as click_status
  FROM [db_dev].[dbo].[Scaling_Path_PBI_Campaigns]
WHERE New_mapping IN ('CPC') AND AccountGroup_Id=2

UNION ALL
SELECT
  Date, Source, Platform_In, Account_Id, AccountGroup_Id, Account_Ds,
  SourceMedium, Source_Nm, Medium_Nm, Campaign_Nm,
  'Google Brand Text' AS New_mapping,
  Sessions * 0.16 AS Sessions,
  Transactions * 0.16 AS Transactions,
  NewUsers * 0.16 AS NewUsers,
  Cost * 0.16 AS Cost,
  Revenue * 0.16 AS Revenue,
  (GA_last_click_revenue * 0.16) * 0.5 AS Attributed_Revenue,
  GA_last_click_revenue * 0.16 AS GA_last_click_revenue,
  embedded_awareness,
  Revenue_minus_embedded_awareness,
  map_query_id,
  map_query_type,
  (Transactions * 0.16) * 0.5 AS Attributed_Transactions,
  Impressions * 0.16 AS Impressions,
  Link_Clicks * 0.16 AS Link_Clicks,
  Engaged_Sessions * 0.16 AS Engaged_Sessions,
  'Locked' AS lock_status,
  NULL AS click_status
FROM [db_dev].[dbo].[Scaling_Path_PBI_Campaigns]
WHERE New_mapping IN ('CPC') AND AccountGroup_Id = 2;
