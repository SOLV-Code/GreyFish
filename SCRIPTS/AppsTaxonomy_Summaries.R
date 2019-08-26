# Script to generate summary tables and plots of the Online Apps dataset

# Setting up
library(tidyverse)
apps.data <- read.csv("DATA/OnlineApplications/InteractiveTools_Shiny_2019_08_24.csv", stringsAsFactors = FALSE)



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


