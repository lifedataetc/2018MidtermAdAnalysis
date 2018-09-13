# the following code is written to establish an understanding of advertising 
# spending by Democratic and Repbulican groups on Google from May 27th, 2018 to August 5th, 2018

setwd('../.')
# import libraries
library(ggplot2)

#Predefined ggplot2 theme options:
opts_string = {theme(axis.text.x=element_text(size=rel(2),angle=0),
                     axis.text.y=element_text(size=rel(2)),
                     legend.text=element_text(size=rel(2)),
                     title=element_text(size=rel(2)),
                     panel.background=element_blank(),
                     panel.border=element_rect(color='black',fill=NA),
                     panel.grid.major=element_line(colour='grey20',linetype='dotted'),
                     panel.grid.minor=element_line(color='grey',linetype='dotted'))}

# import data
df = read.csv('data/google-political-ads-advertiser-stats.csv',stringsAsFactors = FALSE)
# remove leading and trailing while spaces
df$Advertiser_Name = trimws(df$Advertiser_Name, which = c("both"))
# fix issues with multiple names
df$Advertiser_Name[df$Advertiser_Name=='WINNING FOR WOMEN, INC. PAC'] = "WINNING FOR WOMEN, INC."

# get total spend by advertiser
dfSum = aggregate(df$Total_Spend_USD,by=list(df$Advertiser_Name),FUN=sum)
colnames(dfSum) = c('Advertiser_Name','Spend')
dfSum$Advertiser = as.character(dfSum$Advertiser)

# get party information
Parties = read.csv('data/Advertiser Party Affiliation V2.csv',stringsAsFactors = FALSE)

# remove leading and trailing while spaces
Parties$Advertiser_Name = trimws(Parties$Advertiser_Name, which = c("both"))
Parties$party[is.na(Parties$party)] = 'NA'
Parties$party = as.factor(Parties$party)

################################################################################
# Who is spending the money?
################################################################################

# merge the data
dfSum = merge(x=dfSum,y=Parties,by = 'Advertiser_Name',all.x = TRUE)

#Reorder the levels
dfSum$Advertiser_Name = factor(dfSum$Advertiser_Name,levels=dfSum[order(dfSum$Spend),][,1])
dfSum = dfSum[order(-dfSum$Spend),]
dfSum$top20 = FALSE
dfSum$top20[1:20] = TRUE

# get the top 20 spenders
ggplot(dfSum[1:20,],aes(x=Advertiser_Name,y=Spend,fill=party)) + geom_bar(stat = 'identity') + 
  coord_flip() + scale_y_continuous(labels = scales::dollar) + 
  xlab('Advertiser') + ylab('Total Spend\n') + opts_string + scale_fill_manual(values=c("blue","red","grey")) +
  ggtitle('Total Spend on Google Ads for 2018 Midterm Election\nTop 20 Advertisers Shown')
ggsave('top20.png',units=c('cm'),width=50,height=40)

# get party affliation stats
dfPartyStats = data.frame(table(dfSum$party))
colnames(dfPartyStats) = c('Party','Number of Advertisers')

# get total spend by party
dfTemp = aggregate(dfSum$Spend,by = list(dfSum$party),FUN=sum)
colnames(dfTemp) = c('Party','Total Spend')
# merge the data
dfPartyStats = merge(x=dfPartyStats,y=dfTemp,by = 'Party')

# get average spend by party
dfTemp = aggregate(dfSum$Spend,by = list(dfSum$party),FUN=mean)
colnames(dfTemp) = c('Party','Average Spend')
# merge the data
dfPartyStats = merge(x=dfPartyStats,y=dfTemp,by = 'Party')

# get median spend by party
dfTemp = aggregate(dfSum$Spend,by = list(dfSum$party),FUN=median)
colnames(dfTemp) = c('Party','Median Spend')
# merge the data
dfPartyStats = merge(x=dfPartyStats,y=dfTemp,by = 'Party')

# get sd of spend by party
dfTemp = aggregate(dfSum$Spend,by = list(dfSum$party),FUN=sd)
colnames(dfTemp) = c('Party','Standard Deviation of Spend')
# merge the data
dfPartyStats = merge(x=dfPartyStats,y=dfTemp,by = 'Party')

# get 95% CI
dfPartyStats$SE = dfPartyStats$`Standard Deviation of Spend`/sqrt(dfPartyStats$`Number of Advertisers`)
dfPartyStats$EB = 1.96*dfPartyStats$SE
write.csv(dfPartyStats,file='partyStats.csv',row.names=FALSE)

#Reorder the levels
dfPartyStats$Party = factor(dfPartyStats$Party,levels=dfPartyStats[order(-dfPartyStats$`Total Spend`),][,1])

# data only on Dems and Republicans
dfPartyStats2 = dfPartyStats[dfPartyStats$Party %in% c('R','D'),]

# plot total spend by party
ggplot(dfPartyStats,aes(x=Party,y=`Total Spend`,fill=Party)) + geom_bar(stat = 'Identity') +
  scale_y_continuous(labels = scales::dollar) + xlab('Party\n') + ylab('Total Spend') + 
  opts_string + scale_fill_manual(values=c("red","blue","gray","black",'yellow')) + 
  ggtitle('Total Spend on Google Ads for 2018 Midterm Election\nBreakdown by Party')
ggsave('spendByParty.png',units=c('cm'),width=50,height=50)

# plot median spend by party
ggplot(dfPartyStats2,aes(x=Party,y=`Median Spend`,fill=Party)) + geom_bar(stat = 'Identity') + 
  scale_y_continuous(labels = scales::dollar) + xlab('Party\n') + ylab('Median Spend') + 
  opts_string + scale_fill_manual(values=c("red","blue")) + 
  ggtitle('Median Spend on Google Ads for 2018 Midterm Election\nBreakdown by Party')
ggsave('medianSpendByParty.png',units=c('cm'),width=50,height=50)

# plot number of advertisers by party
ggplot(dfPartyStats,aes(x=Party,y=`Number of Advertisers`,fill=Party)) + geom_bar(stat = 'Identity') +
  xlab('Party\n') + ylab('Number of Advertisers') + opts_string +
  scale_fill_manual(values=c("red","blue","gray","black",'yellow')) + 
  ggtitle('Total Advertisers on Google Ads for 2018 Midterm Election\nBreakdown by Party')
ggsave('NumberOfAdvertisersByParty.png',units=c('cm'),width=50,height=50)

# plot average spend by party
ggplot(dfPartyStats2,aes(x=Party,y=`Average Spend`,fill=Party)) + geom_bar(stat = 'Identity') + 
  scale_y_continuous(labels = scales::dollar) + xlab('Party\n') + ylab('Average Spend') + 
  opts_string + scale_fill_manual(values=c("red","blue")) + 
  geom_errorbar(aes(ymin=`Average Spend`-SE,ymax=`Average Spend`+SE),width=0.25) +
  ggtitle('Average Spend on Google Ads for 2018 Midterm Election\n95% C.I. Shown')
ggsave('AverageSpendByParty.png',units=c('cm'),width=50,height=50)

# get the distribution for spending
ggplot(dfSum[dfSum$party %in% c('R','D'),],aes(x=Spend,fill=party)) + geom_histogram(bins=10,position = 'dodge') + 
  xlab('Ad Spending\n') + opts_string + scale_fill_manual(values=c("blue","red")) + ylab('Number of Advertisers') +
  ggtitle('Distribution of Money spent on Ads by each Advertiser on Google') + scale_x_continuous(labels = scales::dollar) +
ggsave('SpendDist.png',units=c('cm'),width=50,height=25)


################################################################################
# How is the Money Being Spent?
################################################################################
# How many different ads/creatives were created?
dftemp = aggregate(df$Total_Creatives,by=list(df$Advertiser_Name),FUN=sum)
colnames(dftemp) = c('Advertiser_Name','Creatives')

# merge the data
dfSum = merge(x=dfSum,y=dftemp,by = 'Advertiser_Name',all.x = TRUE)

# top 20 campaigns by number of creatives
#Reorder the levels
dfSum$Advertiser_Name = factor(dfSum$Advertiser_Name,levels=dfSum[order(dfSum$Creatives),][,1])
dfSum = dfSum[order(-dfSum$Creatives),]
dfSum$top20 = FALSE
dfSum$top20[1:20] = TRUE

# get the top 20 creatives
ggplot(dfSum[1:20,],aes(x=Advertiser_Name,y=Creatives,fill=party)) + geom_bar(stat = 'identity') + 
  coord_flip() + xlab('Advertiser') + ylab('Number of Different Ads\n') + opts_string +
  scale_fill_manual(values=c("blue",'black',"red")) +
  ggtitle('Number of Unique Ads on Google for 2018 Midterm Election\nTop 20 Advertisers Shown')
ggsave('top20_byUniqueAds.png',units=c('cm'),width=50,height=40)

# get the distribution for creatives
ggplot(dfSum[dfSum$party %in% c('R','D'),],aes(x=Creatives,fill=party)) + geom_histogram(bins=10,position = 'dodge') + 
  xlab('Number of Different Ads\n') + opts_string + scale_fill_manual(values=c("blue","red")) + ylab('Number of Advertisers') +
  ggtitle('Distribution of Number of Ads by each Advertiser on Google')
ggsave('CreativeDist.png',units=c('cm'),width=50,height=25)


################################################################################
# Time series of spending
################################################################################
dfTS = read.csv('data/google-political-ads-advertiser-weekly-spend.csv',stringsAsFactors = FALSE)
dfTS$Advertiser_Name = trimws(dfTS$Advertiser_Name, which = c("both"))
dfTS$Week_Start_Date = as.Date(dfTS$Week_Start_Date)
dfTS = merge(x=dfTS,y=Parties,by='Advertiser_Name',all.x = TRUE)

df2 = aggregate(dfTS$Spend_USD,by=list(x=dfTS$Week_Start_Date,y=dfTS$party),FUN=sum)
colnames(df2) = c('weekOf','party','spend')

ggplot(df2[df2$party %in% c('R','D'),],aes(x=weekOf,y=spend,color=party)) + geom_point() + geom_line() +
  xlab('Week\n') + ylab('Total Weekly Ad Spending') + scale_y_continuous(labels = scales::dollar) +
  opts_string + scale_color_manual(values=c("blue","red")) + 
  ggtitle('Weekly Total Ad Spending on Google by Party')
ggsave('partyTS.png',width=50,height=25,units=c('cm'))

# get weekly average spend
dfTemp = aggregate(dfTS$Spend_USD,by=list(x=dfTS$Week_Start_Date,y=dfTS$party),FUN=mean)
colnames(dfTemp) = c('weekOf','party','averageSpend')
# merge
df2 = merge(x=df2,y=dfTemp,by=c('weekOf','party'),all.x=TRUE)

# get weekly number of advertisers
dfTemp = data.frame(table(dfTS[,c('Week_Start_Date','party')]))
colnames(dfTemp) = c('weekOf','party','N')
#merge
df2 = merge(x=df2,y=dfTemp,by=c('weekOf','party'),all.x=TRUE)

# get weekly sd of spend
dfTemp = aggregate(dfTS$Spend_USD,by=list(x=dfTS$Week_Start_Date,y=dfTS$party),FUN=sd)
colnames(dfTemp) = c('weekOf','party','sd')
# merge
df2 = merge(x=df2,y=dfTemp,by=c('weekOf','party'),all.x=TRUE)

# build EBs
# get 95% CI
df2$SE = df2$sd/sqrt(df2$N)
df2$EB = 1.96*df2$SE

# weekly average spend by party
ggplot(df2[df2$party %in% c('R','D'),],aes(x=weekOf,y=averageSpend,color=party)) + geom_point() + geom_line() +
  xlab('Week\n') + ylab('Average Ad Spending') + scale_y_continuous(labels = scales::dollar) +
  opts_string + scale_color_manual(values=c("blue","red")) + 
  geom_errorbar(aes(ymin=averageSpend-SE,ymax=averageSpend+SE),width=0.25) +
  ggtitle('Weekly Average Ad Spending on Google by Party\n95% C.I. Shown')
ggsave('partyTS_avg.png',width=50,height=25,units=c('cm'))

# Number of weekly advertisers for each party
ggplot(df2[df2$party %in% c('R','D'),],aes(x=weekOf,y=N,color=party)) + geom_point() + geom_line() +
  xlab('Week\n') + ylab('Number of Advertisers') + opts_string + scale_color_manual(values=c("blue","red")) + 
  ggtitle('Number of Weekly Advertisers on Google by Party')
ggsave('partyTS_N.png',width=50,height=25,units=c('cm'))

ggplot(dfSum[dfSum$party %in% c('R','D'),],aes(x=party,y=Spend,fill=party)) + geom_violin() +
  geom_violin(trim=FALSE) + scale_y_log10(labels=scales::dollar) + 
  xlab('Party\n') + ylab('Spending by Advertiser') + 
  scale_fill_manual(values=c("blue","red")) + 
  guides(fill=FALSE) + opts_string +
  ggtitle('Spending Distribution on Google Ads for 2018 Midterm Election\nBreakdown by Party')
ggsave('SpendDistribute.png',units=c('cm'),width=50,height=50)
