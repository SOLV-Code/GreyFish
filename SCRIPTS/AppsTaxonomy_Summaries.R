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



mid.points <- barplot(summary.topic.general$TotalApps,horiz=TRUE,col="white",border="darkblue",width=0.7)
barplot(summary.topic.general$DataFocus,add=TRUE,horiz=TRUE,col="lightblue", border="darkblue",width=0.7)
axis(2,at=mid.points,labels =summary.topic.general$TopicLabel,las=2 )
legend("topright",legend="Data Focused",fill="lightblue",bty="n")




