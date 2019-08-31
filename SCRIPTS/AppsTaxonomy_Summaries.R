# Script to generate summary tables and plots of the Online Apps dataset

# Setting up
library(tidyverse)
apps.data <- read.csv("DATA/OnlineApplications/InteractiveTools_Master.csv", stringsAsFactors = FALSE)


apps.data <- apps.data %>% mutate(DataScoreTotal = DPScore + DVScore,
                                  ModelScoreTotal = GMScore + MDScore + ATScore,
                                  TotalScore = DPScore + DVScore + GMScore + MDScore + ATScore
                                  )



summary.topic.general <- apps.data %>% 
                          mutate(TopicLabel = paste(Domain, TopicGeneral,sep="-")) %>%
                          group_by(TopicLabel) %>% 
                          summarise(TotalApps = length(Name),
                                    DataFocus = sum(AppType %in% c("Data Portal","Data Vis" )),
                                    DataPortal = sum(AppType=="Data Portal"),
                                    DataVis = sum(AppType=="Data Vis"),
                                    GenModel = sum(AppType=="General Model"),
                                    ModelDoc = sum(AppType=="Model Documentation"),
                                    AnalyticalTool = sum(AppType=="Analytical Tool")) 
                          


summary.topic.general


write.csv(summary.topic.general,"DATA/OnlineApplications/GeneratedSummaries/Summary_ByGeneralTopic.csv",row.names=FALSE)











# Overview plot

png(filename = "DATA/OnlineApplications/GeneratedPlots/Summary_ByGeneralTopic.png",
    width = 480*2.8, height = 480*2, units = "px", pointsize = 14*2, bg = "white",  res = NA)

par(mai = c(2,7,2,1))

mid.points <- barplot(rev(summary.topic.general$TotalApps),horiz=TRUE,col="white",
                      border="darkblue", xlab="Number of Apps")
barplot(rev(summary.topic.general$DataFocus),add=TRUE,horiz=TRUE,col="lightblue", border="darkblue")
axis(2,at=mid.points,labels =rev(summary.topic.general$TopicLabel),las=2 )
legend("topright",legend=c("Data Focused","Model Focused"),fill=c("lightblue","white"),bty="n")
title(main="Overview of App Topics and Focus")

dev.off()




# #### 
# Tornado plot of Model vs Data focus

model.score.sub <- apps.data %>% select(Domain, NameShort,ModelScoreTotal,DataScoreTotal,TotalScore)  %>% 
                        arrange(desc(ModelScoreTotal),DataScoreTotal) %>%
                        mutate(Label = paste(substr(Domain,1,4),NameShort,sep="-"))


x.range<- c(min(-model.score.sub$DataScoreTotal)-2, max(model.score.sub$ModelScoreTotal)+2)
x.ticks <- pretty(x.range)
x.lim <- range(x.ticks)


png(filename = "DATA/OnlineApplications/GeneratedPlots/TornadoPlot_AppFocus.png",
    width = 480*2.8, height = 480*3, units = "px", pointsize = 14*2, bg = "white",  res = NA)

par(mai = c(2,7,2,1))


mid.points <- barplot(rev(model.score.sub$ModelScoreTotal),horiz = TRUE,col="lightblue",
                      border="darkblue", xlim=x.lim,axes=FALSE)
barplot(-rev(model.score.sub$DataScoreTotal),horiz = TRUE,col="white",
        border="darkblue", add=TRUE,xlim=x.lim,axes=FALSE)
abline(v=0,col="darkblue", lwd=2)
axis(1,at=x.ticks,labels=abs(x.ticks))

title(main="Relative Focus")
axis(2,at=mid.points,labels =rev(model.score.sub$Label),las=2 ,cex.axis=0.8)
text(5,par("usr")[4],labels="Model Score", xpd=NA,adj=c(0.5,0))
text(- 5,par("usr")[4],labels="Data Score", xpd=NA,adj=c(0.5,0))

dev.off()





# #### 
# Plot of Documentation Type



