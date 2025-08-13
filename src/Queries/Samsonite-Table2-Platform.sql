  DELETE FROM [db_dev].[dbo].[Scaling_Path_PBI_Campaigns_Platform];

INSERT INTO [db_dev].[dbo].[Scaling_Path_PBI_Campaigns_Platform] (
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
      ,[GA_last_click_revenue]
      ,[Platform_Revenue]
      ,[embedded_awareness]
      ,[Revenue_minus_embedded_awareness]
      ,[map_query_id]
      ,[map_query_type]
	  ,[Impressions]
	  ,[Link_Clicks]
	  ,[Engaged_Sessions])

SELECT Date, Source, Platform_In, Account_Id, AccountGroup_Id, Account_Ds, SourceMedium, Source_Nm, Medium_Nm, Campaign_Nm, 

CASE  
WHEN Campaign_Nm LIKE ('%GOO | SHOP | NBR |%') THEN 'Google Non-Brand Shopping'
WHEN Campaign_Nm LIKE '%| GOO | PMAX | NBR |%' THEN 'Performance Max - NBR'
WHEN Campaign_Nm LIKE '%| GOO | PMAX | BR |%' THEN 'Performance Max - BR'
WHEN Campaign_Nm LIKE '%| BNG | SHOP | NBR |%' THEN 'Microsoft Non-Brand Shopping'
WHEN Campaign_Nm LIKE ('%BNG | SHOP | BR%') THEN 'Microsoft Brand Shopping'
WHEN Campaign_Nm LIKE ('%BING | SHOP | BR%') THEN 'Microsoft Brand Shopping'
WHEN Campaign_Nm LIKE ('%| BNG | TXT | NBR |%') THEN 'Microsoft Non-Brand Text'
WHEN Campaign_Nm LIKE ('%| BNG | TXT | BR |%') THEN 'Microsoft Brand Text'
WHEN Campaign_Nm LIKE ('%BR | Local Shopping Ads -%') THEN 'Google NBR Shop - Local Storefront'

WHEN AccountGroup_Id=2 AND Campaign_Nm LIKE ('%CP | FB | MF | REM%') THEN 'Meta - Remarketing - Mid Funnel PM'

WHEN Campaign_Nm LIKE ('%| GOO | SHOP | BR |%') THEN 'Google Brand Shopping'
WHEN Campaign_Nm LIKE ('%CP | LF | GOO | REM | DYN |%') THEN 'Google Display and Video Retargeting'
WHEN Campaign_Nm LIKE ('%CP | LF | GOO | REM | ST | Static Remarketing%') THEN 'Google Display and Video Retargeting'



WHEN AccountGroup_Id=2 AND  Campaign_Nm LIKE ('%GOO | Demand Gen%') THEN 'Google Demand Gen'
WHEN AccountGroup_Id=2 AND Campaign_Nm LIKE ('%DABA%') THEN 'Facebook Prospecting - DABA'
WHEN AccountGroup_Id=2 AND Campaign_Nm LIKE ('%daba%') THEN 'Facebook Prospecting - DABA'

WHEN Campaign_Nm IN ('FB - Dynamic Remarketing') THEN 'Facebook Remarketing'
WHEN Campaign_Nm LIKE ('%| FB | REM |%') THEN 'Facebook Remarketing'
WHEN Campaign_Nm LIKE ('%| FB | PRO |%') THEN 'Facebook Prospecting'
WHEN Campaign_Nm LIKE ('%| UF | PIN | PRO |%') THEN 'Pinterest Paid Prospecting'
WHEN Source_Nm in ('email','email,email') THEN 'Email'
WHEN Source_Nm in ('(direct)') THEN 'Direct'

WHEN Campaign_Nm LIKE ('%PM | PIN | CON | TRAF |%') THEN 'Pinterest - Acquisition - Mid Funnel PM'
WHEN Campaign_Nm LIKE ('%PM | LF | PIN |%') THEN 'Pinterest - REM - Mid Funnel PM'


WHEN Campaign_Nm LIKE ('%| TT | PRO |%') THEN 'TikTok Prospecting'
WHEN Campaign_Nm LIKE ('%| TT | REM |%') THEN 'TikTok Remarketing'


WHEN Source_Nm in ('attentive') AND Medium_Nm in ('sms') THEN 'Attentive - SMS/Text'


WHEN Campaign_Nm LIKE ('%| GOO | REM | VID |%') THEN 'Youtube Remarketing'
WHEN Campaign_Nm LIKE ('%| GOO | TXT | NBR |%') THEN 'Google Non-Brand Text'
WHEN Campaign_Nm LIKE ('%| GOO | TXT | _NB |%') THEN 'Google Non-Brand Text'
WHEN Campaign_Nm LIKE ('%| GOO | TXT | BR |%') THEN 'Google Brand Text'
WHEN Campaign_Nm LIKE ('%CP | UF | GOO | PRO | ST |%') THEN 'Google Display Ads'
WHEN Campaign_Nm LIKE ('%| UF | PIN | PRO |%') THEN 'Pinterest Paid Prospecting'
WHEN Source_Nm in ('email','email,email') THEN 'Email'
WHEN Source_Nm in ('(direct)') AND Campaign_Nm IN ('(direct)') THEN 'Direct'
WHEN Source_Nm in ('attentive') AND Medium_Nm in ('sms') THEN 'Attentive - SMS/Text'
WHEN Campaign_Nm IN ('referral') AND Source_Nm IN ('youtube.com','m.youtube.com','consent.youtube.com') THEN 'Youtube Organic'
WHEN Campaign_Nm IN ('(not set)') AND SourceMedium in ('(not set)') THEN 'Not Set / Not Set'



WHEN Campaign_Nm IN ('organic') AND Campaign_Nm IN ('(organic)','(not set)','(referral)','Shopping Free Listings') THEN 'Organic Brand and Non-Brand'

--WHEN Source_Nm in ('(not set)') AND Medium_Nm in ('SP-none') THEN 'Not Set / Not Set'

WHEN Campaign_Nm LIKE ('%| FB | REM |%') THEN 'Facebook Remarketing'
WHEN Campaign_Nm LIKE ('%| FB | PRO |%') THEN 'Facebook Prospecting'
WHEN Campaign_Nm LIKE ('%| YouTube | Prospecting |%') THEN 'Youtube Prospecting '
WHEN Campaign_Nm LIKE ('%| YouTube | Remarketing |%') THEN 'Youtube Remarketing'
WHEN Campaign_Nm LIKE ('%| YTB | PRO | VID |%') THEN 'Youtube Prospecting'
WHEN Campaign_Nm LIKE ('%| FB | STA | DYN |%') THEN 'Facebook Prospecting'
WHEN Campaign_Nm LIKE ('%| GOO | YTB | PRO |%') THEN 'Youtube Prospecting'
WHEN Campaign_Nm LIKE ('%| PIN | PRO |%') THEN 'Pinterest Paid Prospecting'
WHEN Campaign_Nm LIKE ('%daba%') THEN 'Facebook Prospecting - DABA'
WHEN Campaign_Nm LIKE ('%PMax_Brand%') THEN 'Performance Max - BR'

WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('pla_nonbrand_allproducts') THEN 'Coupon Affiliate(s)'
WHEN AccountGroup_Id=2 AND Campaign_Nm LIKE ('PM | TT | RE%') THEN 'TikTok - Remarketing'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('CP | MF | TT | REM | DYN | Bring It | Conversion') THEN 'TikTok - Remarketing'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('CP | FB | MF | CON | TRAF') THEN 'Meta - Acquisition - Mid Funnel PM'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('CP | FB | MF | CON | TRAF - Creative Testing') THEN 'Meta - Acquisition - Mid Funnel PM'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('CP | TT | MF | CON | TRAF') THEN 'TikTok - Acquisition - Mid Funnel PM'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('CP | MF | GOO | Demand Gen - Non-Offer Version') THEN 'Google Demand Gen'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('CP | UF | GOO | PRO | DISC | Discovery Ads') THEN 'Google Demand Gen'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('CP | MF | GOO | Demand Gen Offers') THEN 'Google Demand Gen'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('[SB] Tier Brand: Brand (US)') THEN 'Microsoft Brand Text'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('CP | UF | GOO | REM | DISC | Discovery + Feed') THEN 'Google Display and Video Retargeting'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('{PM | PIN | CON | TRAF | Modern Style}') THEN 'Pinterest - Acquistition - Mid Funnel PM'
WHEN AccountGroup_Id= 2 AND Campaign_Nm IN ('{PM | PIN | RETA | CONV | Catalog Sales}') THEN 'Pinterest - Remarketing - Mid Funnel PM'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('PM | PIN | CON | TRAF | Modern Style') THEN 'Pinterest - Acquistition - Mid Funnel PM'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('PM | PIN | RETA | CONV | Catalog Sales') THEN 'Pinterest - Remarketing - Mid Funnel PM'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('(referral)') AND Medium_Nm IN ('referral') AND Source_Nm LIKE ('%pinterest%') THEN 'Pinterest Organic'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('[CP | UF | PIN | PRO | ST | Static_Video | Conversion | Q1_22]') THEN 'Pinterest Paid Prospecting' 
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('[CP | UF | PIN | PRO | ST | Static_Video | Web Sessions | Q1_22]') THEN 'Pinterest Paid Prospecting' 
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('[CP | UF | PIN | PRO | ST | Static | Awareness | Q1_22]') THEN 'Pinterest Paid Prospecting' 
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('[CP | LF | PIN | REM | ST | Static_Video | Conversion | Q1_22]') THEN 'Pinterest Remarketing' 
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('| PIN | REM') THEN 'Pinterest Remarketing' 
WHEN AccountGroup_Id=2 AND Campaign_Nm LIKE ('PM | TT | CON |%') THEN 'TikTok - Acquisition - Mid Funnel PM' 
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('PM | TT | REMA |') THEN 'TikTok - Remarketing - Mid Funnel PM' 
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('PM | TT | RETA |') THEN 'TikTok - Remarketing - Mid Funnel PM' 
WHEN AccountGroup_Id=2 AND  Campaign_Nm IN ('PM | YT | CON |') THEN 'YouTube - Acquisition - Mid Funnel PM' 
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('[PM | YT | CON | TRAF | Casual Travel]') THEN 'YouTube - Acquisition - Mid Funnel PM' 
WHEN AccountGroup_Id=2 AND Campaign_Nm LIKE ('%| PIN | PRO |%') THEN 'Pinterest Paid Prospecting'
WHEN AccountGroup_Id=2 AND Campaign_Nm LIKE ('%| PIN | REM%') THEN 'Pinterest Remarketing'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('CP | MF | TT | PRO | VSA | Product Sales') THEN 'TikTok Prospecting' 
WHEN AccountGroup_Id=2 AND SourceMedium IN ('bing rebates by microsoft / affiliate') THEN 'Non-Coupon Affiliate(s)'

WHEN AccountGroup_Id=2 AND Source_Nm IN ('google') AND Medium_Nm IN ('cpc') AND Campaign_Nm IN ('(direct)') THEN 'CPC'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('google') AND Medium_Nm IN ('cpc') AND Campaign_Nm IN ('(organic)') THEN 'CPC'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('facebook') AND Medium_Nm IN ('paidsocial-prospecting') AND Campaign_Nm IN ('CP | UF | FB') THEN 'Facebook Prospecting'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('fb-ig') AND Medium_Nm LIKE ('%paidsocial%') AND Campaign_Nm LIKE ('%retargeting%') THEN 'Facebook Remarketing'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('google') AND Medium_Nm IN ('cpc') AND Campaign_Nm IN ('(not set)','Branded > Core','Branded > Department','Branded > Collections','Branded > Generic') THEN 'Google Brand Shopping'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('google') AND Medium_Nm IN ('cpc') AND Campaign_Nm IN ('pla_brand') THEN 'Google Brand Shopping'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('google') AND Medium_Nm IN ('cpc') AND Campaign_Nm LIKE ('%txt_brand%') THEN 'Google Brand Text'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('google') AND Medium_Nm IN ('cpc') AND Campaign_Nm LIKE ('% GOO | SHOP | NBR %') THEN 'Google Non-Brand Shopping'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('google') AND Medium_Nm IN ('cpc') AND Campaign_Nm LIKE ('%Non-Branded >%') THEN 'Google Non-Brand Shopping'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('google') AND Medium_Nm IN ('cpc') AND Campaign_Nm LIKE ('%pla_non%') THEN 'Google Non-Brand Shopping'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('google') AND Medium_Nm IN ('cpc') AND Campaign_Nm LIKE ('%txt_nonbrand%') THEN 'Google Non-Brand Text'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('chrome') AND Medium_Nm IN ('app') AND Campaign_Nm IN ('chrome-cart') THEN 'Miscellaneous Payment Redirect'
WHEN AccountGroup_Id=2 AND Source_Nm LIKE ('%ibotta%') AND Medium_Nm IN ('affiliate') AND Campaign_Nm IN ('(not set)') THEN 'Non-Coupon Affiliate(s)'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('Capital One Shopping') AND Medium_Nm IN ('affiliate') AND Campaign_Nm IN ('(referral)') THEN 'Non-Coupon Affiliate(s)'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('Capital One Shopping') AND Medium_Nm IN ('affiliate') AND Campaign_Nm IN ('(not set)') THEN 'Non-Coupon Affiliate(s)'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('capitaloneshopping.com') AND Medium_Nm IN ('referral') AND Campaign_Nm IN ('(referral)') THEN 'Non-Coupon Affiliate(s)'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('Travel Away') AND Medium_Nm IN ('affiliate') AND Campaign_Nm IN ('(not set)') THEN 'Non-Coupon Affiliate(s)'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('Travel Away') AND Medium_Nm IN ('affiliate') AND Campaign_Nm IN ('(referral)') THEN 'Non-Coupon Affiliate(s)'
WHEN AccountGroup_Id=2 AND Source_Nm LIKE ('%pinterest.com%') AND Medium_Nm IN ('referral') AND Campaign_Nm IN ('(referral)') THEN 'Organic Social'
WHEN AccountGroup_Id=2 AND Source_Nm LIKE ('%instagram.com%') AND Medium_Nm IN ('referral') AND Campaign_Nm IN ('(referral)') THEN 'Organic Social'
WHEN AccountGroup_Id=2 AND Source_Nm LIKE ('%reddit.com%') AND Medium_Nm IN ('referral') AND Campaign_Nm IN ('(referral)') THEN 'Organic Social'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('instagram') AND Medium_Nm IN ('social') AND Campaign_Nm IN ('holiday') THEN 'Organic Social'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('l.facebook.com') AND Medium_Nm IN ('referral') AND Campaign_Nm IN ('(referral)') THEN 'Organic Social'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('m.facebook.com') AND Medium_Nm IN ('referral') AND Campaign_Nm IN ('(referral)') THEN 'Organic Social'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('tiktok') AND Medium_Nm IN ('social') AND Campaign_Nm IN ('amplification') THEN 'Organic Social'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('tiktok') AND Medium_Nm IN ('social') AND Campaign_Nm IN ('holiday') THEN 'Organic Social'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('(not set)') AND Medium_Nm IN ('paidsocial_pm_outlinepro') AND Campaign_Nm IN ('{PM | PIN | RETA | CONV | Catalog Sales}') THEN 'Pinterest - REM - Mid Funnel PM'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('pinterest') AND Medium_Nm LIKE ('%paidsocial-prospecting%') AND Campaign_Nm LIKE ('%| PIN | PRO |%') THEN 'Pinterest Paid Prospecting'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('pinterest') AND Medium_Nm IN ('"paidsocial-prospecting"') AND Campaign_Nm IN ('prospecting-static') THEN 'Pinterest Paid Prospecting'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('pinterest') AND Medium_Nm LIKE ('%paidsocial-prospecting%') AND Campaign_Nm LIKE ('%web_sessions%') THEN 'Pinterest Paid Prospecting'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('tiktok') AND Medium_Nm IN ('paidsocial_pm_ecodiver') AND Campaign_Nm IN ('PM | TT | RETA | CONV | Casual Travel') THEN 'TikTok - Remarketing - Mid Funnel PM'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('youtube.com') AND Medium_Nm IN ('social') AND Campaign_Nm IN ('(not set)') THEN 'Youtube Organic'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('bouncex') AND Campaign_Nm LIKE ('%email%') THEN 'Email'
WHEN AccountGroup_Id=2 AND Source_Nm LIKE ('%facebook%') AND Medium_Nm LIKE ('%remarketing%') THEN 'Facebook Remarketing'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('google') AND Medium_Nm IN ('nonbrandpla') THEN 'Google Non-Brand Shopping'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('shopping') AND Medium_Nm IN ('google_cpc') THEN 'Google Non-Brand Shopping'
WHEN AccountGroup_Id=2 AND Source_Nm LIKE ('%bing%') AND Campaign_Nm LIKE ('%bng | shop | br%') THEN 'Microsoft Brand Shopping'
WHEN AccountGroup_Id=2 AND Source_Nm LIKE ('%bing%') AND Campaign_Nm LIKE ('%Branded > Core%') THEN 'Microsoft Brand Shopping'
WHEN AccountGroup_Id=2 AND Source_Nm LIKE ('%bing%') AND Campaign_Nm LIKE ('%Branded > Department%') THEN 'Microsoft Brand Shopping'
WHEN AccountGroup_Id=2 AND Source_Nm LIKE ('%bing%') AND Campaign_Nm LIKE ('%Branded > Collections%') THEN 'Microsoft Brand Shopping'
WHEN AccountGroup_Id=2 AND Source_Nm LIKE ('%bing%') AND Campaign_Nm LIKE ('%Branded > Generic%') THEN 'Microsoft Brand Shopping'
WHEN AccountGroup_Id=2 AND Source_Nm LIKE ('%mntn%') AND Medium_Nm LIKE ('%prospecting%') THEN 'Mountain Prospecting'
WHEN AccountGroup_Id=2 AND Source_Nm LIKE ('%mntn%') AND Campaign_Nm LIKE ('%prospecting%') THEN 'Mountain Prospecting'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('mntn') AND Medium_Nm LIKE ('%retargeting%') THEN 'Mountain Retargeting'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('mntn') AND Campaign_Nm LIKE ('%retargeting%') THEN 'Mountain Retargeting'
WHEN AccountGroup_Id=2 AND Source_Nm LIKE ('%ebates per%') AND Medium_Nm LIKE ('%affiliate%') THEN 'Non-Coupon Affiliate(s)'
WHEN AccountGroup_Id=2 AND Source_Nm LIKE ('%marketplace%') AND Medium_Nm LIKE ('%affiliate%') THEN 'Non-Coupon Affiliate(s)'
WHEN AccountGroup_Id=2 AND Source_Nm LIKE ('%rakuten.com%') AND Medium_Nm LIKE ('%affiliate%') THEN 'Non-Coupon Affiliate(s)'
WHEN AccountGroup_Id=2 AND Source_Nm LIKE ('%shop.com marketplace, inc%') AND Medium_Nm LIKE ('%affiliate%') THEN 'Non-Coupon Affiliate(s)'
WHEN AccountGroup_Id=2 AND Source_Nm LIKE ('%travel away%') AND Medium_Nm LIKE ('%Travel Away%') THEN 'Non-Coupon Affiliate(s)'
WHEN AccountGroup_Id=2 AND Source_Nm LIKE ('%travelzoo%') AND Medium_Nm LIKE ('%affiliate%') THEN 'Non-Coupon Affiliate(s)'
WHEN AccountGroup_Id=2 AND Source_Nm LIKE ('%pricetrace%') AND Medium_Nm LIKE ('%affiliate%') THEN 'Non-Coupon Affiliate(s)'
WHEN AccountGroup_Id=2 AND Source_Nm LIKE ('%rakuten%') AND Medium_Nm IN ('referral')  THEN 'Non-Coupon Affiliate(s)'
WHEN AccountGroup_Id=2 AND Source_Nm LIKE ('%Travel Away%') AND Medium_Nm IN ('affiliate')  THEN 'Non-Coupon Affiliate(s)'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('Capital One Shopping') AND Medium_Nm IN ('affiliate') THEN 'Non-Coupon Affiliate(s)'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('(not set)') AND Medium_Nm IN ('SP-none') THEN 'Not Set / Not Set '
WHEN AccountGroup_Id=2 AND Medium_Nm IN ('') AND Campaign_Nm IN ('(not set)') THEN 'Organic Social'
WHEN AccountGroup_Id=2 AND Medium_Nm IN ('') AND Campaign_Nm IN ('(not set)') THEN 'Organic Social'
WHEN AccountGroup_Id=2 AND Medium_Nm IN ('') AND Campaign_Nm IN ('(not set)') THEN 'Organic Social'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('instagram') AND Medium_Nm LIKE ('%link in bio%') THEN 'Organic Social'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('social') AND Medium_Nm IN ('instagram') THEN 'Organic Social'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('t.co') AND Campaign_Nm IN ('(not set)') THEN 'Organic Social'
WHEN AccountGroup_Id=2 AND Medium_Nm IN ('') AND Campaign_Nm IN ('(not set)') THEN 'Organic Social'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('upfluence') AND Medium_Nm IN ('social') THEN 'Organic Social'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('igshopping') AND Medium_Nm IN ('social') THEN 'Organic Social'
WHEN AccountGroup_Id=2 AND Source_Nm LIKE ('%facebook.com%') AND Medium_Nm IN ('social')  THEN 'Organic Social'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('attentive') THEN 'Attentive - SMS/Text'
WHEN AccountGroup_Id=2 AND Medium_Nm IN ('sms') THEN 'Attentive - SMS/Text'
WHEN AccountGroup_Id=2 AND Medium_Nm IN ('text') THEN 'Attentive - SMS/Text'
WHEN AccountGroup_Id=2 AND Medium_Nm IN ('affiliate') THEN 'Coupon Affiliate(s)'
WHEN AccountGroup_Id=2 AND Source_Nm IN ('wunderkind') THEN 'Email'
WHEN AccountGroup_Id=2 AND Campaign_Nm LIKE ('%UF | FB | PRO | ST | Samsonite | Evergreen Prospecting | Conversion new%') THEN 'Facebook Prospecting'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('CP | MF | FB | PRO | Video | MF1 Link Clicks') THEN 'Facebook Prospecting'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('CP | MF | FB | ST | 2022 Holiday MF 1 Prospecting Link Clicks') THEN 'Facebook Prospecting'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('CP | UF | FB | PRO | ST | Samsonite | Evergreen Prospecting | Conversion new') THEN 'Facebook Prospecting'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('Brand - Organic Social') THEN 'Facebook Prospecting'
WHEN AccountGroup_Id=2 AND Campaign_Nm LIKE ('%daba%') THEN 'Facebook Prospecting - DABA'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('CP | UF | FB | PRO | DYN | Dynamic Prospecting DABA new') THEN 'Facebook Prospecting - DABA'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('CP | UF | FB | PRO | DYN | Dynamic Prospecting DABA') THEN 'Facebook Prospecting - DABA'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('cp | lf | fb | rem | dyn | dynamic retargeting dpa') THEN 'Facebook Remarketing'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('cp | lf | fb | rem | st | promo retargeting') THEN 'Facebook Remarketing'
WHEN AccountGroup_Id=2 AND Campaign_Nm LIKE ('%lf | fb | rem%') THEN 'Facebook Remarketing'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('CP | MF | FB | REM | Video | MF1 Link Clicks') THEN 'Facebook Remarketing'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('cp | lf | goo | shop | br | gs+: brand') THEN 'Google Brand Shopping'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('cp | lf | goo | txt | br | branded collections - control group 1') THEN 'Google Brand Text'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('cp | lf | goo | txt | br | branded core - control group 1') THEN 'Google Brand Text'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('cp | lf | goo | txt | br | branded department - control group 1') THEN 'Google Brand Text'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('cp | lf | goo | txt | br | branded generic - control group 1') THEN 'Google Brand Text'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('discovery') THEN 'Google Discovery'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('cp | lf | goo | rem | dyn | dyr responsive: apps/yt') THEN 'Google Display and Video Retargeting'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('cp | lf | goo | rem | dyn | dyr: responsive') THEN 'Google Display and Video Retargeting'
WHEN AccountGroup_Id=2 AND Campaign_Nm LIKE ('%YTB | REM%') THEN 'Google Display and Video Retargeting'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('cp | lf | ytb | rem | vid | merchant center remarketing') THEN 'Google Display and Video Retargeting'
WHEN AccountGroup_Id=2 AND Campaign_Nm LIKE ('%NBR | GS%') THEN 'Google Non-Brand Shopping'
WHEN AccountGroup_Id=2 AND Campaign_Nm LIKE ('%PM | META | CON |%') THEN 'Meta - Acquisition - Mid Funnel PM '
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('PM | META | CON | TRAF | Casual Travel') THEN 'Meta - Acquisition - Mid Funnel PM '
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('CP | FB | MF | CON | SALES') THEN 'Meta - Acquisition - Mid Funnel PM '
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('PM | META | CON | TRAF | Lightweight') THEN 'Meta - Acquisition - Mid Funnel PM '
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('PM | META | CON | TRAF | Modern Style') THEN 'Meta - Acquisition - Mid Funnel PM '
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('PM | META | REMA | TRAF | Modern Style') THEN 'Meta - Remarketing - Mid Funnel PM'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('PM | META | REMA | TRAF | Lightweight') THEN 'Meta - Remarketing - Mid Funnel PM'
WHEN AccountGroup_Id=2 AND Campaign_Nm LIKE ('%"PM | META | REMA |"%') THEN 'Meta - Remarketing - Mid Funnel PM'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('PM | META | REMA | TRAF | Casual Travel') THEN 'Meta - Remarketing - Mid Funnel PM'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('PM | META | RETA | CONV | Casual Travel') THEN 'Meta - Remarketing - Mid Funnel PM'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('PM | META | RETA | CONV | Lightweight') THEN 'Meta - Remarketing - Mid Funnel PM'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('PM | META | RETA | CONV | Modern Style') THEN 'Meta - Remarketing - Mid Funnel PM'
WHEN AccountGroup_Id=2 AND Campaign_Nm LIKE ('%BNG | SHOP | BR%') THEN 'Microsoft Brand Shopping'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('cp | lf | bng | shop | br | bs: brand') THEN 'Microsoft Brand Shopping'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('cp | lf | BNG | shop | br | bs: brand') THEN 'Microsoft Brand Shopping'
WHEN AccountGroup_Id=2 AND Campaign_Nm LIKE ('%BNG | TXT | BR%') THEN 'Microsoft Brand Text'
WHEN AccountGroup_Id=2 AND Campaign_Nm LIKE ('%BNG | SHOP | NBR%') THEN 'Microsoft Non-Brand Shopping '
WHEN AccountGroup_Id=2 AND Campaign_Nm LIKE ('%BNG | TXT | NBR%') THEN 'Microsoft Non-Brand Text'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('CP | MF | BING | TXT | NBR | DSA') THEN 'Microsoft Non-Brand Text'
WHEN AccountGroup_Id=2 AND Source_Nm LIKE ('%bing rebates%') THEN 'Non-Coupon Affiliate(s)'
WHEN AccountGroup_Id=2 AND Medium_Nm IN ('SP-none') THEN 'Not Set / Not Set '
WHEN AccountGroup_Id=2 AND Medium_Nm IN ('organic') THEN 'Organic Brand and Non-Brand'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('2023 | Owned | Engagement | Back Up') THEN 'Paid Social - Iris'
WHEN AccountGroup_Id=2 AND Campaign_Nm LIKE ('%iris%') THEN 'Paid Social - Iris'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('2023 | Owned | Engagement - Views/Awareness') THEN 'Paid Social - Iris'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('2023 | Owned | Engagement') THEN 'Paid Social - Iris'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('2.0 | SON | 2023 |  | US | Holiday | GM | Consideration | SOC_Instagram') THEN 'Paid Social - Iris'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('2.0 | SON | 2023 |  | US | Holiday | GM | Consideration | SOC_Facebook') THEN 'Paid Social - Iris'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('2.0 | SON | 2023 | | US | Holiday | GM | Consideration | SOC_Traffic') THEN 'Paid Social - Iris'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('2.0 | SON | 2023 | | US | Summer | GM | Awareness | SOC_Video Views') THEN 'Paid Social - Iris'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('2023 | Owned | Traffic') THEN 'Paid Social - Iris'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('CP + Brand Team - Prospecting - Traffic - Travel Interest') THEN 'Paid Social - Iris'
WHEN AccountGroup_Id=2 AND Campaign_Nm LIKE ('%2.0 | SON | 2022 |  | US | Summer | GM | Awareness |%') THEN 'Paid Social - Iris'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('2.0 | SON | 2022 |  | US | Away | GM | Awareness | SOC_Video Views') THEN 'Paid Social - Iris'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('2.0 | SON | 2022 |  | US | Holiday | GM | Consideration | SOC_Traffic') THEN 'Paid Social - Iris'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('2.0 | SON | 2022 |  | US | Holiday | GM | Conversion | SOC_Engagement Facebook') THEN 'Paid Social - Iris'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('2.0 | SON | 2022 |  | US | Holiday | GM | Conversion | SOC_Engagement Instagram Stories') THEN 'Paid Social - Iris'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('2.0 | SON | 2022 |  | US | Holiday | GM | Conversion | SOC_Engagement Instagram') THEN 'Paid Social - Iris'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('2.0 | SON | 2022 |  | US | Summer | GM | Awareness | SOC_Reach') THEN 'Paid Social - Iris'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('2.0 | SON | 2022 |  | US | Summer | GM | Awareness | SOC_Traffic') THEN 'Paid Social - Iris'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('2.0 | SON | 2022 |  | US | Summer | GM | Awareness | SOC_Video Views') THEN 'Paid Social - Iris'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('2.0 | SON | 2022 | | US | Holiday | GM | Consideration | SOC_Traffic Influencer CYBER WEEK') THEN 'Paid Social - Iris'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('2.0 | SON | 2023 |  | US | Holiday | GM | Consideration | SOC_Traffic') THEN 'Paid Social - Iris'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('2.0 | SON | 2023 |  | US | Summer | GM | Awareness | SOC_Video Views') THEN 'Paid Social - Iris'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('2023 | BRAND | VV | 24 HOURS WITH SAM') THEN 'Paid Social Awareness'
WHEN AccountGroup_Id=2 AND Campaign_Nm LIKE ('%2025 | Boosting | Payton |%') THEN 'Paid Social Awareness'
WHEN AccountGroup_Id=2 AND Campaign_Nm LIKE ('%YouTube Follower Growth 2024 |%') THEN 'Paid Social Awareness'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('2023 | VV | Iconic Explorers') THEN 'Paid Social Awareness'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('3.0 | 2022 | Community Interaction | AT') THEN 'Paid Social Awareness'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('3.0 | 2023 |  VV') THEN 'Paid Social Awareness'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('3.0 | VV | Ambassadors') THEN 'Paid Social Awareness'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('3.0 | VV | Everyday Travelers') THEN 'Paid Social Awareness'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('4.0 | 2024 | Community Interaction | AT') THEN 'Paid Social Awareness'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('Instagram Follower Campaign 2025') THEN 'Paid Social Awareness'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('Jet Gala | Community Interaction ') THEN 'Paid Social Awareness'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('V2 | Jet Gala | Community Interaction') THEN 'Paid Social Awareness'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('Instagram Follower Campaign - 2024') THEN 'Paid Social Awareness'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('Instagram Follower Campaign - Jan') THEN 'Paid Social Awareness'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('2.0 | Instagram Follower Campaign - 2024 | Engagement') THEN 'Paid Social Awareness'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('2023 | VV | Partners') THEN 'Paid Social Awareness'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('2024 | VV | March Giveaway') THEN 'Paid Social Awareness'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('3.0 | Traffic') THEN 'Paid Social Awareness'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('YouTube Follower Growth 2024 | Video views') THEN 'Paid Social Awareness'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('PM | PIN | RETA | CONV | Catalog Sales') THEN 'Pinterest - REM - Mid Funnel PM '
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('CP | UF | PIN | PRO | ST | Static_Video | Conversion | Q1_22') THEN 'Pinterest Paid Prospecting'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('CP | UF | PIN | PRO | ST | Static_Video | Web Sessions | Q1_22') THEN 'Pinterest Paid Prospecting'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('CP | UF | PIN | PRO | ST | Static | Awareness | Q1_22') THEN 'Pinterest Paid Prospecting'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('CP | LF | PIN | REM | ST | Static_Video | Conversion | Q1_22') THEN 'Pinterest Remarketing'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('CP | UF | GOO | PRO | Demand Gen') THEN 'Google Display and Video Retargeting'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('CP | LF | GOO | REM | Demand Gen') THEN 'Google Display Ads'
WHEN AccountGroup_Id=2 AND Campaign_Nm LIKE ('%| PIN | REM%') THEN 'Pinterest Remarketing'
WHEN AccountGroup_Id=2 AND Medium_Nm IN ('referral') THEN 'Referral'
WHEN AccountGroup_Id=2 AND Campaign_Nm LIKE ('%"PM | TT | CON | TRAF |"%') THEN 'TikTok - Acquisition - Mid Funnel PM'
WHEN AccountGroup_Id=2 AND Campaign_Nm LIKE ('%"PM | TT | CON |"%') THEN 'TikTok - Acquisition - Mid Funnel PM'
WHEN AccountGroup_Id=2 AND Campaign_Nm LIKE ('%"PM | TT | REMA |"%') THEN 'TikTok - Remarketing - Mid Funnel PM'
WHEN AccountGroup_Id=2 AND Campaign_Nm LIKE ('%"PM | TT | RETA |"%') THEN 'TikTok - Remarketing - Mid Funnel PM'
WHEN AccountGroup_Id=2 AND Campaign_Nm LIKE ('%CP | TT | MF | REM |%') THEN 'TikTok - Remarketing - Mid Funnel PM'
WHEN AccountGroup_Id=2 AND Campaign_Nm LIKE ('%PM | YT | CON |%') THEN 'YouTube - Acquisition - Mid Funnel PM'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('PM | YT | CON | TRAF | Casual Travel') THEN 'YouTube - Acquisition - Mid Funnel PM'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('PM | YT | CON | TRAF | Shorts | Modern Style') THEN 'YouTube - Acquisition - Mid Funnel PM'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('PM | YT | CON | TRAF | Lightweight') THEN 'YouTube - Acquisition - Mid Funnel PM'
WHEN AccountGroup_Id=2 AND Campaign_Nm LIKE ('%"PM | YT | REMA |"%') THEN 'YouTube - Remarketing - Mid Funnel PM'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('PM | YT | REMA | TRAF | Casual Travel') THEN 'YouTube - Remarketing - Mid Funnel PM'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('PM | YT | REMA | TRAF | Modern Style') THEN 'YouTube - Remarketing - Mid Funnel PM'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('PM | YT | REMA | VIEW | Lightweight') THEN 'YouTube - Remarketing - Mid Funnel PM'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('PM | YT | RETA | TRAF | Modern Style') THEN 'YouTube - Remarketing - Mid Funnel PM'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('PM | YT | RETA | VIEW | Casual Travel') THEN 'YouTube - Remarketing - Mid Funnel PM'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('PM | YT | RETA | VIEW | Lightweight') THEN 'YouTube - Remarketing - Mid Funnel PM'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('broad reach fineman collab') THEN 'Youtube Brand Awareness'
WHEN AccountGroup_Id=2 AND Campaign_Nm IN ('youtube shorts - testing campaign') THEN 'Youtube Brand Awareness'

WHEN Source_Nm LIKE ('%facebook%') AND Medium_Nm LIKE ('%paid%') AND Campaign_Nm LIKE ('%Remarket%') THEN 'Facebook Remarketing'
WHEN Medium_Nm in ('referral') AND Campaign_Nm IN ('(referral)') THEN 'Referral'
WHEN Campaign_Nm IN ('(organic)') AND SourceMedium IN ('google / organic') THEN 'Organic Brand and Non-Brand'
WHEN Medium_Nm IN ('social') THEN 'Organic Social'
WHEN  Medium_Nm  IN ('organicsocial') THEN 'Organic Social'
WHEN Campaign_Nm IN ('(direct)') AND SourceMedium IN ('(direct) / (none)') THEN 'Direct'
WHEN Campaign_Nm LIKE ('CP | UF | YTB | PRO |%') THEN 'Youtube Prospecting'
WHEN Campaign_Nm LIKE ('%PMax%') THEN 'Performance Max - NBR'
WHEN Medium_Nm in ('email','email,email') THEN 'Email'
ELSE 'Misc/Uncategorized' END AS New_mapping, 
Sessions, 
Transactions, 
NewUsers, 
Cost, 
Revenue, 
GA_last_click_revenue,
Platform_Revenue,
GA_last_click_revenue-(GA_last_click_revenue*0.133) AS embedded_awareness,
Revenue - Revenue * .10 AS Revenue_minus_embedded_awareness, 
map_query_id, 
map_query_type,
Impressions,
Link_Clicks,
Engaged_Sessions
  FROM [db_dev].[dbo].[Scaling_Path_PBI_Platform]
  WHERE AccountGroup_Id <>3  OR (AccountGroup_Id=3 AND (GA_last_click_revenue is null OR GA_last_click_revenue<'472968')) 
  ;