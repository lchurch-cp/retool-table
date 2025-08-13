DELETE FROM [db_dev].[dbo].[Scaling_Path_PBI];

-- From file: Update Table 1 Scaling Path PBI.sql
INSERT INTO [db_dev].[dbo].[Scaling_Path_PBI](
  
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
      ,[Sessions]
      ,[Transactions]
      ,[NewUsers]
      ,[Cost]
      ,[Revenue]
      ,[GA_last_click_revenue]
      ,[map_query_id]
      ,[map_query_type]
	   ,[Impressions]
	   ,[Link_Clicks]
	   ,[Engaged_Sessions])

SELECT        t .date AS Date, 'Google Analytics' AS Source, ALU.Platform_In, t .account_id AS Account_Id, ALU.AccountGroup_Id, ALU.Account_Ds AS Account_Ds, t .sourceMedium AS SourceMedium/*  (VarChar(100)*/ , 
                         CASE WHEN t .SourceMedium IS NOT NULL AND t.SourceMedium != '' AND charindex('/', t .SourceMedium) - 1 > 0 THEN TRIM(LEFT(t .SourceMedium, charindex('/', t .SourceMedium) - 1)) 
                         ELSE t .SourceMedium /* mh changed 2023-06-23 was this ''*/ END AS Source_Nm, CASE WHEN t .SourceMedium IS NOT NULL AND t .SourceMedium != '' AND charindex('/ ', (REVERSE(t .SourceMedium))) 
                         - 1 > 0 THEN TRIM(RIGHT(t .SourceMedium, charindex('/ ', (REVERSE(t .SourceMedium))) - 1)) ELSE 'SP-none' /* mh changed 2023-06-23 was this ''*/ END AS Medium_Nm, t .campaign AS Campaign_Nm, sum(t .sessions) 
                         AS Sessions, sum(t .Transactions) AS Transactions, SUM(t .newUsers) AS NewUsers, 0 AS Cost, sum(cast(t .transactionRevenue AS FLOAT)) Revenue, sum(cast(t .transactionRevenue AS FLOAT)) AS GA_last_click_revenue, 
                         map_query_id = NULL, map_query_type = NULL, 0 as Impressions,null as Link_Clicks,--SUM(b.engagedSessions) 
						null as Engaged_Sessions
FROM            ga_conversion_path.dbo.tbl_custom_view4 t /************  Before change*****
INNER JOIN db_dev.dbo.LU_Account ALU 
  on t.account_id =  ALU.Account_Id
  and ALU.Report_In = 'Y'
  and ALU.Active_In = 1
  and ALU.Platform_In = 'N'
**********************************/ INNER
                          JOIN
                         db_dev.dbo.LU_Account ALU ON t .account_id = ALU.Account_Id AND ALU.Report_In = 'Y' AND ALU.Active_In = 1 AND ALU.Platform_In = 'N' AND ALU.Effective_Dt <= t .date AND ALU.Expiration_Dt >= t .date
--INNER JOIN ga_conversion_path.dbo.SCALINGPATH_INGESTION01_PRODUCTION as b on t.account_id=b.account_id and t.date=b.date and t.campaign=b.campaign
WHERE        t .[date] BETWEEN '2023-01-01' AND GETDATE() /* Gets last 2 full years + current year to date*/ AND t .campaign IS NOT NULL
/* and sourceMedium like '%/%'  --mh modified 2023-06-23*/ GROUP BY t .date, ALU.Platform_In, t .account_id, ALU.Account_Ds, ALU.AccountGroup_Id, t .sourceMedium, t .campaign


UNION
/**********************************************************************************************************************************************/ 
SELECT  t .date AS Date, 'Facebook' AS Source, ALU.Platform_In, cast(t .account_id AS BIGINT) 
                         AS Account_Id, ALU.AccountGroup_Id, tt2.name AS Account_Ds, '' AS SourceMedium, '' AS Source_Nm, '' AS Medium_Nm, campaign_name AS Campaign_Nm, 0 /* sum(Clicks) */ AS Sessions, 
                         0 /* sum(tt.conversions) */ AS Transactions, 0 AS NewUsers, sum(spend) Cost, sum(isnull(ttt.[1d_view], 0) + isnull(ttt.[7d_click], 0)) Revenue, NULL AS GA_last_click_revenue,
						 map_query_id = NULL, map_query_type = NULL, SUM(t.impressions) as Impressions,SUM(t.inline_link_clicks) as Link_Clicks,null as Engaged_Sessions
FROM            facebook_conversion_path..cp7d1d_insights t LEFT JOIN
                         facebook_conversion_path..adaccounts tt2 ON concat('act_', t .account_id) = tt2.id LEFT JOIN
                         facebook_conversion_path..cp7d1d_insights_actions tt ON t .key_id = tt.key_id AND tt.action_type = 'omni_purchase' LEFT JOIN
                         facebook_conversion_path..cp7d1d_insights_action_values ttt ON t .key_id = ttt.key_id AND ttt.action_type = 'omni_purchase' INNER JOIN
                         db_dev.dbo.LU_Account ALU ON cast(t .account_id AS BIGINT) = ALU.Account_Id AND ALU.Report_In = 'Y' AND ALU.Active_In = 1 AND ALU.Platform_In = 'Y'
WHERE        t .[date] BETWEEN '2023-01-01' AND GETDATE() /* Gets last 2 full years + current year to date*/ AND [campaign_name] IS NOT NULL
GROUP BY t .date, ALU.Platform_In, t .account_id, ALU.AccountGroup_Id, tt2.name, campaign_name
UNION
/**********************************************************************************************************************************************/ SELECT t .date AS Date, 'Google AdWords' AS Source, ALU.Platform_In, t .account_id AS Account_Id, 
                         ALU.AccountGroup_Id, tt.account_name AS Account_Ds, '' AS SourceMedium, '' AS Source_Nm, '' AS Medium_Nm, campaign_name AS Campaign_Nm, 0 /*sum(Clicks) */ AS Sessions, 0 /* sum(conversions) */ AS Transactions, 
                         0 AS NewUsers, sum(cost) Cost, sum(ConversionsValue) Revenue, NULL AS GA_last_click_revenue, 
						 map_query_id = NULL, map_query_type = NULL, SUM(t.impressions) as Impressions,SUM(t.clicks) as Link_Clicks,null as Engaged_Sessions
FROM            google_ads_conversion_path..Campaign_Performance_Report t LEFT JOIN
                         google_ads_conversion_path..tbl_accounts tt ON t .account_id = tt.account_id INNER JOIN
                         db_dev.dbo.LU_Account ALU ON t .account_id = ALU.Account_Id AND ALU.Report_In = 'Y' AND ALU.Active_In = 1 AND ALU.Platform_In = 'Y' AND (ALU.Expiration_Dt IS NULL OR
                         ALU.Expiration_Dt >= t .date)
WHERE        t .[date] BETWEEN '2023-01-01' AND GETDATE() /* Gets last 2 full years + current year to date*/ AND [campaign_name] IS NOT NULL
GROUP BY t .date, ALU.Platform_In, t .account_id, ALU.AccountGroup_Id, tt.account_name, campaign_name
UNION
/**********************************************************************************************************************************************/ SELECT t .TimePeriod AS Date, 'Microsoft Ads' AS Source, ALU.Platform_In, CAST(t .AccountId AS BIGINT) 
                         AS Account_Id, ALU.AccountGroup_Id, tt.name AS Account_Ds, '' AS SourceMedium, '' AS Source_Nm, '' AS Medium_Nm, campaignname AS Campaign_Nm, 0 /*  sum(Clicks) */ AS Sessions, 
                         0 /*sum(conversions) */ AS Transactions, 0 AS NewUsers, sum(Spend) Cost, sum(revenue) AS Revenue, NULL AS GA_last_click_revenue, 
						 map_query_id = NULL, map_query_type = NULL, SUM(t.impressions) as Impressions,SUM(t.clicks) as Link_Clicks,null as Engaged_Sessions
FROM            ms_ads_conversion_path..CampaignPerformanceReport t LEFT JOIN
                         ms_ads_conversion_path..accounts tt ON t .AccountId = tt.id INNER JOIN
                         db_dev.dbo.LU_Account ALU ON CAST(t .AccountId AS BIGINT) = ALU.Account_Id AND ALU.Report_In = 'Y' AND ALU.Active_In = 1 AND ALU.Platform_In = 'Y'
WHERE        t .TimePeriod BETWEEN '2023-01-01' AND GETDATE() /* Gets last 2 full years + current year to date*/ AND [campaignname] IS NOT NULL
GROUP BY t .TimePeriod, ALU.Platform_In, t .AccountId, ALU.AccountGroup_Id, tt.name, campaignname
UNION
/**********************************************************************************************************************************************/ SELECT t .date AS Date, 'TikTok' AS Source, ALU.Platform_In, cast(t .AccountID AS BIGINT) AS Account_Id, 
                         ALU.AccountGroup_Id, ALU.Account_Ds AS Account_Ds, '' AS SourceMedium, '' AS Source_Nm, '' AS Medium_Nm, t .campaign AS Campaign_Nm, sum(t .Clicks) AS Sessions, sum(t .conversions) AS Transactions, 0 AS NewUsers,
                          sum(t .cost) AS Cost, sum(t .Revenue) AS Revenue, NULL AS GA_last_click_revenue,
						  map_query_id = NULL, map_query_type = NULL, SUM(t.impressions) as Impressions,SUM(t.clicks) as Link_Clicks,null as Engaged_Sessions
FROM            [DATA_ZEN_V3_1].[dbo].[DZ_GV3_BASICADVERTISING_CAMPAIGNS] AS t INNER JOIN
                         db_dev.dbo.LU_Account ALU ON cast(t .AccountID AS BIGINT) = ALU.Account_Id AND ALU.Report_In = 'Y' AND ALU.Active_In = 1 AND ALU.Platform_In = 'Y'
WHERE        t .[date] BETWEEN '2023-01-01' AND GETDATE() AND /* Gets last 2 full years + current year to date*/ t .campaign IS NOT NULL AND t .DataSource IN ('TikTok')
GROUP BY t .date, ALU.Platform_In, t .AccountID, ALU.AccountGroup_Id, ALU.Account_Ds, t .campaign
UNION
/**********************************************************************************************************************************************/ SELECT t .date AS Date, 'Pinterest' AS Source, ALU.Platform_In, t .accountId AS Account_Id, 
                         ALU.AccountGroup_Id, t .[Account Name] AS Account_Ds, ' ' AS SourceMedium, ' ' AS Source_Nm, ' ' AS Medium_Nm, t .[Campaign Name] AS Campaign_Nm, 0 /*sum(Clicks) */ AS Sessions, 
                         0 /* sum(conversions) */ AS Transactions, 0 AS NewUsers, sum(t .[Cost]) Cost, sum(t .[Revenue]) Revenue, NULL AS GA_last_click_revenue, 
						 map_query_id = NULL, map_query_type = NULL, SUM(t.impressions) as Impressions,SUM(t.clicks) as Link_Clicks,null as Engaged_Sessions
FROM            [golden_model].[dbo].[v_GoldenModel_ConversionPathSQLBreakdown] t INNER JOIN
                         db_dev.dbo.LU_Account ALU ON t .accountid = ALU.Account_Id AND ALU.Report_In = 'Y' AND ALU.Active_In = 1 AND ALU.Platform_In = 'Y'
WHERE        t .[date] BETWEEN '2023-01-01' AND GETDATE() /* Gets last 2 full years + current year to date*/ AND t .[Campaign Name] IS NOT NULL AND t .Platform = 'PINTEREST' AND t .[Campaign Name] != 'Conversions November'
GROUP BY t .date, ALU.Platform_In, t .accountid, ALU.AccountGroup_Id, t .[Account Name], t .[Campaign Name]

UNION 
/**********************************************************************************************************************************************/
SELECT TOP 100
t.Date as date,
 'Google Analytics' as Source,
ALU.Platform_In,
t.Account_Id as Account_Id,
ALU.AccountGroup_Id,
ALU.Account_Ds,
t.SourceMedium as SourceMedium,
CASE WHEN t.SourceMedium  IS NOT NULL AND t.SourceMedium  != '' AND charindex('/', t.SourceMedium ) - 1 > 0 THEN TRIM(LEFT(t.SourceMedium , charindex('/', t.SourceMedium ) - 1)) ELSE t.SourceMedium   END AS  Source_Nm,
CASE WHEN t.SourceMedium  IS NOT NULL  AND t.SourceMedium  != '' AND charindex('/ ', (REVERSE(t.SourceMedium ))) 
- 1 > 0 THEN TRIM(RIGHT(t.SourceMedium , charindex('/ ', (REVERSE(t.SourceMedium ))) - 1)) ELSE 'SP-none'  END AS Medium_Nm,
t.Campaign as Campaign_Nm,
null as Sessions,
null as Transactions,
null as NewUsers,
null as Cost,
null as Revenue,
null as GA_last_click_revenue,
null as map_query_id,
null as map_query_type,
null as Impressions,
null as Link_Clicks,
sum(t.total_engaged_Sessions) as Engaged_Sessions
FROM ga_conversion_path.dbo.SCALINGPATH_INGESTION01_PRODUCTION as t 
INNER JOIN  db_dev.dbo.LU_Account ALU ON t.account_id  = ALU.Account_Id and t.account_id=6440405
AND ALU.Report_In = 'Y' AND ALU.Active_In = 1 AND ALU.Platform_In = 'N' AND ALU.Effective_Dt <= t.date AND ALU.Expiration_Dt >= t.date 
WHERE t.[date] BETWEEN '2023-01-01' AND GETDATE() AND  LEN(t.SourceMedium)<363 and ALU.AccountGroup_Id=2 --AND t.sessionSourceMedium NOT LIKE 'facebook_utm%' AND t.sessionSourceMedium NOT LIKE 'facebook&utm_%' 
GROUP BY t .date, ALU.Platform_In, t.account_id, ALU.Account_Ds, ALU.AccountGroup_Id, t.SourceMedium, t.Campaign;