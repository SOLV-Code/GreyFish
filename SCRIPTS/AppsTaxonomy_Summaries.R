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



best.apps <- apps.data %>%  arrange(desc(TotalScore),NameShort) %>% select(Domain,NameShort,TotalScore,DataScoreTotal)

write.csv(best.apps[1:10,],"DATA/OnlineApplications/GeneratedSummaries/TopTenApps.csv",row.names=FALSE)







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



png(filename = "DATA/OnlineApplications/GeneratedPlots/Large/Summary_ByGeneralTopic_Large.png",
    width = 480*2.8*1.7, height = 480*2*2, units = "px", pointsize = 14*4, bg = "white",  res = NA)

par(mai = c(4,14,4,2))

mid.points <- barplot(rev(summary.topic.general$TotalApps),horiz=TRUE,col="white",
                      border="darkblue", xlab="Number of Apps")
barplot(rev(summary.topic.general$DataFocus),add=TRUE,horiz=TRUE,col="lightblue", border="darkblue")
axis(2,at=mid.points,labels =rev(summary.topic.general$TopicLabel),las=2 )

ocean.idx <- (1:length(summary.topic.general$TopicLabel))[grepl("Oceanography",rev(summary.topic.general$TopicLabel))]
axis(2,at=mid.points[ocean.idx],labels =rev(summary.topic.general$TopicLabel)[ocean.idx],las=2,col.axis="darkblue" )


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



png(filename = "DATA/OnlineApplications/GeneratedPlots/Large/TornadoPlot_AppFocus_Large.png",
    width = 480*2.8*2, height = 480*3*2.5, units = "px", pointsize = 14*5, bg = "white",  res = NA)

par(mai = c(4,14,4,2))

mid.points <- barplot(rev(model.score.sub$ModelScoreTotal),horiz = TRUE,col="lightblue",
                      border="darkblue", xlim=x.lim,axes=FALSE)
barplot(-rev(model.score.sub$DataScoreTotal),horiz = TRUE,col="white",
        border="darkblue", add=TRUE,xlim=x.lim,axes=FALSE)
abline(v=0,col="darkblue", lwd=2)
axis(1,at=x.ticks,labels=abs(x.ticks))

title(main="Relative Focus")
axis(2,at=mid.points,labels =rev(model.score.sub$Label),las=2 ,cex.axis=0.75,col.axis="grey")

ocean.idx <- (1:length(model.score.sub$Label))[grepl("Ocea",rev(model.score.sub$Label))]
axis(2,at=mid.points[ocean.idx],labels =rev(model.score.sub$Label)[ocean.idx],las=2,col.axis="darkblue" ,cex.axis=0.75 )



text(5,par("usr")[4],labels="Model Score", xpd=NA,adj=c(0.5,0))
text(- 5,par("usr")[4],labels="Data Score", xpd=NA,adj=c(0.5,0))
dev.off()


# Plot of Top Ten Apps

png(filename = "DATA/OnlineApplications/GeneratedPlots/Large/TopTenApps_TotalScore_Large.png",
    width = 480*2.9, height = 480*3, units = "px", pointsize = 14*2.5, bg = "white",  res = NA)

par(mai = c(2.5,6.3,1.5,1))

mid.points <- barplot(rev(best.apps$TotalScore[1:10]),horiz=TRUE,col="lightblue",
                      border="darkblue", xlab="Total Score",xlim=c(0,25))
barplot(rev(best.apps$DataScoreTotal[1:10]),add=TRUE,horiz=TRUE,col="darkblue", density=10, border="darkblue")
axis(2,at=mid.points,labels =rev(best.apps$NameShort[1:10]),las=2,cex.axis=1.2 ,col.axis="grey")

ocean.idx <- (1:length(best.apps$Domain[1:10]))[grepl("Ocea",rev(best.apps$Domain[1:10]))]
axis(2,at=mid.points[ocean.idx],labels =rev(best.apps$NameShort[1:10])[ocean.idx],las=2,col.axis="darkblue" ,cex.axis=1.2)



legend("bottomright",legend=c("Data Score","Model Score"),col="darkblue",fill=c("lightblue","lightblue"),
        bty="n",cex=1.1)
legend("bottomright",legend=c("Data Score","Model Score"),col="darkblue",fill=c("lightblue","darkblue"),
       density=c(NA,10),bty="n",cex=1.1)

abline(v=25,col="red",lty=2)
text(25,par("usr")[4],labels = "Perfect\nScore",col="red",xpd=NA,adj=c(0.5,0))


title(main="Top Ten Apps")

dev.off()












# #### 
# Plot of Documentation Type

doc.overall<- apps.data %>% 
                   group_by(DocCategory) %>% 
                    summarise(NumApps = n()) 
doc.overall

doc.bydomain <- apps.data %>% 
                      group_by(Domain,DocCategory) %>% 
                      summarise(NumApps = n()) %>%
                      spread(Domain,NumApps)
doc.bydomain

doc.byapptype <- apps.data %>% 
                    group_by(AppType,DocCategory) %>% 
                    summarise(NumApps = n()) %>%
                    spread(AppType,NumApps) 

doc.byapptype <- doc.byapptype[c(3,1,2),]

doc.byapptype[is.na(doc.byapptype)] <- 0 



y.lim <- range(pretty(c(-max(doc.byapptype[3,][-1],na.rm = TRUE),max(colSums(doc.byapptype[c(1,2),-1],na.rm=TRUE)))))

png(filename = "DATA/OnlineApplications/GeneratedPlots/Large/IcebergPlot_DocType_Large.png",
    width = 480*2.8*2, height = 480*3*2, units = "px", pointsize = 14*5, bg = "white",  res = NA)


plot(1:5,1:5,type="n",xlim = c(0,6), ylim = y.lim, xlab="",ylab="Num Apps",bty="n",axes=FALSE)

axis(2,at=pretty(y.lim),labels= abs(pretty(y.lim)))


# need to streamline and generalize this extraxtion step
prim.vec <- unlist(doc.byapptype[1,][-1][c(2:5,1)])
grey.vec <- unlist(doc.byapptype[2,][-1][c(2:5,1)])
web.vec <- unlist(doc.byapptype[3,][-1][c(2:5,1)])
type.labels <- c("Data\nPortal","Data\nVis","Gen\nMod","Mod\nDoc","Tool")

rect( c(1:5)-0.5 , 0, c(1:5)+0.5, grey.vec,col="lightblue",border="darkblue",density=10,lwd=2)
rect( c(1:5)-0.5 , grey.vec, c(1:5)+0.5, grey.vec+prim.vec,col="lightblue",border="darkblue",lwd=2)
rect( c(1:5)-0.5 , -web.vec, c(1:5)+0.5, 0 ,col="white",border="darkblue",lwd=2)
text(1:5,par("usr")[4],labels =  type.labels ,xpd=NA,font=2,cex=1.2,col="darkblue"    )

abline(h=0,lwd=3,col="red",lty=1)

text(5.55, c(prim.vec[5]/2+grey.vec[5],grey.vec[5]/2,-web.vec[5]/2),
     labels=c("Primary","Grey","Online Only"),xpd=NA,adj=0)


dev.off()
            