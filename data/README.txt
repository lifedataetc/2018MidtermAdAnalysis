google-political-ads-geo-spend.csv

This file contains the information for how much is spent buying political ads
on Google Ads Services. The data is aggregated by Congressional district.

Fields:
State - Name of the US state containing this Congressional district.
Congressional_District - Name of the US Congressional district where political
ads were served.
Total_Spend_USD - Total amount in USD spent on political ads in this
Congressional district.


google-political-ads-advertiser-stats.csv

This file contains the information about advertisers who have run a political ad
on Google Ads Services with at least one impression.

Fields:
Advertiser_ID - Unique ID for an advertiser certified to run political ads on
Google Ads Services.
Advertiser_Name - Name of advertiser.
Public_IDs_List - List of public IDs used to identify the advertiser, if
available.
Total_Creatives - Total number of political ads the advertiser ran with at least
one impression.
Total_Spend_USD - Total amount in USD spent on political ads by the advertiser.


google-political-ads-advertiser-weekly-spend.csv

This file contains the information for how much an advertiser spent on political
ads during a given week.

Fields:
Advertiser_ID - Unique ID for an advertiser certified to run political ads on
Google Ads Services.
Advertiser_Name - Name of advertiser.
Election_Cycle - The election cycle during which ads ran for the advertiser.
Week_Start_Date - The start date for the week where spending occurred.
Spend_USD - The amount in USD spent on political ads during the given week by
the advertiser.


google-political-ads-top-keywords-history.csv

This file contains the information for the top six keywords on which political
advertisers have spent money during an election cycle.

Fields:
Election_Cycle - The election cycle during which these keywords appeared.
Report_Date - The start date for the week where the spending was reported.
Keyword_1 - Keyword with the most spend by advertisers for political ads
Spend_1 - Total spend in USD for Keyword_1.
Keyword_2 - Keyword with the next most spend by advertisers for political ads
Spend_2 - Total spend in USD for Keyword_2.
Keyword_3 - Keyword with the next most spend by advertisers for political ads
Spend_3 - Total spend in USD for Keyword_3.
Keyword_4 - Keyword with the next most spend by advertisers for political ads
Spend_4 - Total spend in USD for Keyword_4.
Keyword_5 - Keyword with the next most spend by advertisers for political ads
Spend_5 - Total spend in USD for Keyword_5.
Keyword_6 - Keyword with the next most spend by advertisers for political ads
Spend_6 - Total spend in USD for Keyword_6.


See https://transparencyreport.google.com/political-ads/overview for more
information.
