#<pre>
########################################################
# GREYFISH TOOLKIT - CUSTOM FUNCTIONS                  #
# developed by Gottfried Pestal of SOLV Consulting Ltd.#
########################################################

# THIS SCRIPT DEFINES CUSTOM FUNCTIONS USED BY VARIOUS SCRIPTS IN THE GREYFISH TOOLKIT
# PUT THIS FILE INTO THE R WORKING DIRECTORY, THEN RUN ANY OF THE SCRIPTS
# SCRIPTS USE SOURCE() TO READ IN THE FUNCTIONS


#######################
# Version Tracker     #
# v 3 - July 2013     #
#######################



##################################################################################
# EXPLORATORY DATA ANALYSIS FUNCTION
# Calculates simple metrics of total publication rate and authorship for diagnostic plots
##################################################################################

greyfish_eda <- function(file="MergedFile.csv",reports="all",years=1950:2020,print.data=TRUE){

# file = specify path and csv file to summarize ("Sample.csv" OR "../Greyfish Datasets/DFO_Management_Reports_v1_25June2012.csv")
# reports = specify either "all" or some vector of report types to include, such as c("ADFG-Subsistence Technical Paper", "ADFG-Technical Data Report", "ADFG-Technical Fishery Report")


########## START DATA ORGANIZATION

# specify path and source file (default is "MergedFile.csv" in current directory)
Reports.src <- read.csv(file,stringsAsFactors=FALSE)

if(print.data){
print("header names")
print(names(Reports.src))
print(dim(Reports.src))
}

# add a column with combination of "Agency" and "Report Series"  (in case there are duplicate names like "Fishery Report Series"
ReportLabel <- paste(Reports.src[,"Agency"],Reports.src[,"ReportSeries"],sep="-")
Reports.src <- cbind(Reports.src,ReportLabel )

#print(names(Reports.src))

# extract subset to be analysed
if(length(reports)==1){
	if(reports=="all"){RepTypes <- as.vector(unique(Reports.src[,"ReportLabel"]))}
	if(reports!="all"){RepTypes <- reports}
		}
if(length(reports)>1){RepTypes <- reports}

#print("Report Types")
#print(sort(RepTypes))

First.RepType <- RepTypes[1]
Reps <- Reports.src[Reports.src$ReportLabel==First.RepType,]# should fix to using subset()
if(length(RepTypes)>1){for(i in 2:length(RepTypes)){Reps<- rbind(Reps,Reports.src[Reports.src$ReportLabel==RepTypes[i],])}}
#print("subset dimensions")
#print(dim(Reps))

if(dim(Reps)[1]==0){warning("No matching report series in the data set!");stop()}


########### START CALCULATIONS


# NUMBER OF REPORTS  BY YEAR 
NumReps <- matrix(NA,nrow=length(years),ncol=2, dimnames=list(years,c("Year","NumReps")))

#should streamline
NumReps[,"Year"] <-years
for(yr in sort(unique(Reps[,"Year"]))){NumReps[NumReps[,"Year"]==yr,"NumReps"] <- sum(Reps[,"Year"]==yr)}


############## NUMBER OF AUTHORS BY YEAR ###############################

NumAuth <- matrix(NA,nrow=length(years),ncol=23,dimnames=list(years, c("Year",paste(1:19,"Auth",sep="_"),"20+_Auth", "Max_Auth","UFO")))
NumAuth[,"Year"] <-years


# should streamline, convert to function

for(yr in sort(unique(Reps[,"Year"]))){
	
	for(auth in 1:19){NumAuth[NumAuth[,"Year"]==yr,1+auth] <- dim(Reps[Reps[,"Year"]==yr & Reps[,"NumAuth"]==auth,])[1]}
	
	tmp1<- as.numeric(Reps[Reps[,"Year"]==yr & Reps[,"NumAuth"]!="UFO","NumAuth"])# why need as.numeric?
		
	if(length(tmp1)> 0){
			NumAuth[NumAuth[,"Year"]==yr,21] <- length(tmp1[tmp1>19])	
			NumAuth[NumAuth[,"Year"]==yr,22] <- max(tmp1) 
		} # end if length > 0
		
	NumAuth[NumAuth[,"Year"]==yr,23] <- dim(Reps[Reps[,"Year"]==yr & Reps[,"NumAuth"]=="UFO",])[1]
	
	
} # end looping through years


eda.out <- list(num.reps=NumReps, num.auth=NumAuth)


} # end greyfish_eda function






##################################################################################
# DIAGNOSTIC PLOT FUNCTION 1
# plots 4 diagnostic plots onto a single page: Max(Authors), Distr(Authors), Num(reports), and Num(UFO), all by year
# note: this function needs output from greyfish_eda() 
##################################################################################


greyfish_edaplots1<-function(x.list,main.label="EDA PLOTS"){

	
layout(matrix(1:4,ncol=2,byrow=TRUE))
par(mar=c(5,5,4,4))

# plot time series of highest number of authors for a report by year		
greyfish_tsplots(x.list[[2]][,"Year"],x.list[[2]][,"Max_Auth"]
			,type="ts1",trend=TRUE,add=FALSE,x.range=c(1950,2020),y.range=c(0,35),fig.lab="Max(Authors/Report)", x.lab="Year", y.lab="Authors")
	
# calculate and plot proportion of reports with single author, 2-4 authors, and 5+ authors
authorcomp.sb.mat<- matrix(NA,nrow=length(x.list[[2]][,"Year"]),ncol=3, dimnames=list(c(x.list[[2]][,"Year"]),c("1","2-4","5+")))
authorcomp.sb.mat[,1]<-x.list[[2]][,2]
authorcomp.sb.mat[,2]<-rowSums(x.list[[2]][,3:5])
authorcomp.sb.mat[,3]<-rowSums(x.list[[2]][,6:21])
greyfish_sbplot(t(authorcomp.sb.mat), perc=TRUE,fig.lab="Distribution of Authors/Report")



# plot time series of highest number of authors for a report by year		
greyfish_tsplots(x.list[[1]][,"Year"],x.list[[1]][,"NumReps"]
			,type="ts1",trend=FALSE,add=FALSE,x.range=c(1950,2020),fig.lab="Number of Reports", x.lab="Year", y.lab="Reports")
	

# plot time series of highest number of authors for a report by year		
greyfish_tsplots(x.list[[2]][,"Year"],x.list[[2]][,"UFO"]
			,type="ts1",trend=FALSE,add=FALSE,x.range=c(1950,2020),fig.lab="UFO (Reports with Corporate Author) ", x.lab="Year", y.lab="Reports")
	
	
title(main=main.label,  line = -1.1, outer = TRUE, cex.main=1.5)	
	
	
} # end of edaplots1












##################################################################################
# TIME SERIES PLOTTING FUNCTIONS
# layout for various time series plots
##################################################################################


greyfish_tsplots <- function(x,y,type="ts1", trend=FALSE,add=FALSE,x.range=NULL,y.range=NULL,fig.lab=NULL, x.lab=NULL, y.lab=NULL, panel.size=NULL){
	
# x = vector of values
# y = vector of values, same length as x	
# type =  type of plot, so far have a regular time series plot "ts1" 
# trend = if TRUE, plot a simple linear model fit using lm()  (does not apply to stacked bars)
# add = if TRUE	, series is added to existing plot (x.range and y.range are be ignored)
# x.range and y.range specify the axis limits in the form x.range = c(1950,2020). If they are set to NULL then R default ranges are used	
# x.lab and y.lab are axis labels for the plot (NEED TO INCLUDE A DEFAULT)
# panel.size determines the font and plotting charaxter sizes. NULL gives default, "small" is for sub panels in a poster, "large"  is for main panels in a poster

# time series plot	1
if(type=="ts1"){

if(is.null(panel.size)){p.cex <- 1.3; p.cex.main=1; p.cex.lab=1; p.cex.axis=1}	

if(!is.null(panel.size)){
	if(panel.size=="small"){p.cex <- 1.4; p.cex.main=1.8; p.cex.lab=1.5; p.cex.axis=1.5}	
	if(panel.size=="large"){p.cex <- 3; p.cex.main=3.2; p.cex.lab=2.5; p.cex.axis=2.1}	
	}
		
if(add==FALSE){ plot(x,y,type="b",main=fig.lab, ylim=y.range,xlim=x.range,xlab=x.lab,ylab=y.lab,bty="none",col="dodgerblue",cex=p.cex,,cex.main=p.cex.main,cex.lab=p.cex.lab, cex.axis=p.cex.axis,pch=19) }
if(add==TRUE){ points(x,y,type="b",col="darkblue",cex=p.cex) }  



if(trend==TRUE && length(y[!is.na(y)])>=5 ){
	
trend_fit <- lm(y~x)
abline(trend_fit, col="red",lwd=2)
#print(summary(trend_fit))

# add printing of slope to plot
	
} #end of trend = TRUE
	
	
}	# end of times series plot 1

	
} # end of greyfish_tsplots




##################################################################################
# STACKED BAR PLOTTING FUNCTION
# creates a stacked bar plot of 3 series using % composition
##################################################################################


greyfish_sbplot <- function(y.mat,perc=TRUE, fig.lab=NULL, x.lab=NULL, y.lab=NULL,x.label.range=c(0,dim(y.mat)[2]-1),x.label.start=1950,panel.size=NULL, p.cex.leg=NULL){
# x = vector of values
# y.mat = matrix of values, with 3 rows and length(x) columns 
# perc = specify TRUE to convert 3 series into percentage values, FALSE to plot stacked totals
# x.lab and y.lab are axis labels for the plot (NEED TO INCLUDE A DEFAULT)
# need to clean up this function: x axis specs are unwieldy
	

#x.lim=x.label.range,
	
barcols<-c("dodgerblue","lightgrey","darkblue")

if(is.null(panel.size)){p.cex <- 1.3; p.cex.main <- 1; p.cex.lab <- 1; p.cex.axis <- 1; p.legend <- TRUE; p.cex.leg <- 1}	

if(!is.null(panel.size)){
	if(panel.size=="small"){p.cex <- 1.4; p.cex.main <- 1.8; p.cex.lab <- 1.5; p.cex.axis <-1.5; p.legend <- FALSE; p.cex.leg <- 1}	
	if(panel.size=="large"){p.cex <- 3; p.cex.main <- 3.2; p.cex.lab <- 2.5; p.cex.axis <- 2.1; p.legend <- TRUE; p.cex.leg <- 3}	
	}


if(perc){
	legend.specs<-list(bty="n", horiz=FALSE,x="right", xpd=TRUE,inset=-0.05,cex=p.cex.leg)
	y.mat<-prop.table(y.mat,2)
	tmp<-barplot(y.mat,border=NA,space=0, axes=FALSE,legend=p.legend,args.legend=legend.specs,col=barcols,main=fig.lab,cex.main=p.cex.main,xaxt="n")
	axis(side=2,at=seq(0,1,by=0.2),labels=paste(seq(0,1,by=0.2)*100,"%",sep=""),cex.axis=p.cex.axis,xpd=TRUE)
	axis(side=1,at=pretty(x.label.range),labels=pretty(x.label.range+x.label.start),cex.axis=p.cex.axis,xpd=TRUE)
		
	abline(h=seq(0.2,0.8,by=0.2),col="white",lwd=1.5)
} # end if perc=TRUE
	
# NEEDS TESTING	
if(!perc){
	y.scale<-pretty(colSums(y.mat))
	legend.specs<-list(bty="n", horiz=TRUE,x="top", inset=c(0,-0.12))
	barplot(y.mat,border=NA,space=0, axes=FALSE, ylim=c(min(y.scale),max(y.scale)),cex.main=p.cex.main,legend=p.legend,args.legend=legend.specs,col=barcols,main=fig.lab)  
		y.scale<-pretty(colSums(y.mat))
	axis(side=2,at=y.scale,,cex.axis=p.cex.axis,)
	abline(h=y.scale,col="white",lwd=1.5)
} # end if perc=FALSE
	
	
	
} # end of greyfish_sbplot	
	
	






##################################################################################
# AUTHORSHIP COMPOSITION SUB-FUNCTION
# Calculates number of reports each year with 1, 2-4, and  5+ authors
##################################################################################


auth.comp.calc<-function(x.list){
# x.list is output from EDA function above

sb.mat<- matrix(NA,nrow=length(x.list[[2]][,"Year"]),ncol=3, dimnames=list(c(x.list[[2]][,"Year"]),c("1","2-4","5+")))
sb.mat[,1]<-x.list[[2]][,2]
sb.mat[,2]<-rowSums(x.list[[2]][,3:5])
sb.mat[,3]<-rowSums(x.list[[2]][,6:21])
sb.mat

}







##################################################################################
# SUMMARY FUNCTION
# Calculates simple summary stats and prints to screen or file
##################################################################################

greyfish_summary <- function(file="MergedFile.csv", type="short", output="both"){

# file = specify path and csv file to summarize ("Sample.csv" OR "../Greyfish Datasets/DFO_Management_Reports_v1_25June2012.csv")
# type = summary type. For now only "short" summary available
# output = "screen","file", or "both"

# read in data
source.file <- read.csv(file,stringsAsFactors=FALSE)

# checking file properties
print("Rows   Columns")
print(dim(source.file)) # show number of rows and columns
print("Headers")
print(dimnames(source.file)[[2]]) # show list of column headings
			

# Create short summary	

if(type=="short"){
	
short.summary <-	matrix(NA,ncol=1,nrow=7,dimnames=list(
				c("Countries","Agencies","Report Series","Reports","Max(NumAuthors)","Earliest","Most Recent"),"Count"))	
				
short.summary["Countries",] <- length(unique(source.file[,"Country"]))
short.summary["Agencies",] <- length(unique(source.file[,"Agency"]))
short.summary["Report Series",] <- length(unique(source.file[,"ReportSeries"]))
short.summary["Reports",] <- length(source.file[,1])
short.summary["Max(NumAuthors)",] <- max(as.numeric(paste(source.file[source.file[,"NumAuth"]!="UFO","NumAuth"]))) #works, but should change to simpler approach
short.summary["Earliest",] <- min(source.file[,"Year"])
short.summary["Most Recent",] <- max(source.file[,"Year"])

# print to command line
if(output=="screen" || output =="both"){print(short.summary)}

# save to file
if(output=="file" || output =="both"){write.csv(short.summary,"ShortSummary.csv")}

} # end short summary



# create more detailed summary by country
if(type=="by country"){

bycountry.summary <- matrix(NA,nrow=length(unique(source.file[,"Country"])),ncol=6,dimnames=list(
				sort(unique(source.file[,"Country"])),c("Agencies", "Report Series", "Reports","Max(NumAuthors)","Earliest","Most Recent")))		
# need to sort because tapply below gives sorted factors	
				
for(country in 1:length(unique(source.file[,"Country"]))){	
# should simplify	

		bycountry.summary[country,"Agencies"] <- length(unique(source.file[source.file[,"Country"]==sort(unique(source.file[,"Country"]))[country],"Agency"]))
		bycountry.summary[country,"Report Series"]  <- length(unique(source.file[source.file[,"Country"]==sort(unique(source.file[,"Country"]))[country],"ReportSeries"]))
		bycountry.summary[country,"Reports"]  <- length(source.file[source.file[,"Country"]==sort(unique(source.file[,"Country"]))[country],"ReportSeries"])
		
		auth.tmp <- source.file[source.file[,"Country"]==sort(unique(source.file[,"Country"]))[country],"NumAuth"]
		if(sum(auth.tmp!="UFO")>0){bycountry.summary[country,"Max(NumAuthors)"] <- max(as.numeric(auth.tmp[auth.tmp!="UFO"])) }
		
} #end looping through countries

bycountry.summary[,"Earliest"] <- tapply(source.file[,"Year"],source.file[,"Country"],min)
bycountry.summary[,"Most Recent"] <- tapply(source.file[,"Year"],source.file[,"Country"],max)

# print to command line
if(output=="screen" || output =="both"){print(bycountry.summary)}

# save to file
if(output=="file" || output =="both"){write.csv(bycountry.summary,"SummaryByCountry.csv")}



} # end by country





# create more detailed summary by report series
if(type=="by report series"){

ReportLabel <- paste(source.file[,"Country"],source.file[,"Agency"],source.file[,"ReportSeries"],sep="-")
source.file <- cbind(ReportLabel,source.file)
				
byreportseries.summary <- matrix(NA,nrow=length(unique(ReportLabel)),ncol=4,dimnames=list(
				sort(unique(ReportLabel)),c("Reports","Max(NumAuthors)","Earliest","Most Recent")))														
# need to sort because tapply below gives sorted factors

for(report in 1:length(unique(ReportLabel))){
# should simplify
		byreportseries.summary[report,"Reports"] <- length(source.file[source.file[,1]==sort(unique(ReportLabel))[report],"ReportSeries"])
		
		auth.tmp <- source.file[source.file[,1]==sort(unique(ReportLabel))[report],"NumAuth"]
		if(sum(auth.tmp!="UFO")>0){byreportseries.summary[report,"Max(NumAuthors)"] <- max(as.numeric(auth.tmp[auth.tmp!="UFO"])) }
} # end looping through reports
	
byreportseries.summary[,"Earliest"] <- tapply(source.file[,"Year"],source.file[,1],min)
byreportseries.summary[,"Most Recent"] <- tapply(source.file[,"Year"],source.file[,1],max)


#}# end looping through report series


# print to command line
if(output=="screen" || output =="both"){print(byreportseries.summary)}

# save to file
if(output=="file" || output =="both"){write.csv(byreportseries.summary,"SummaryByReportSeries.csv")}

} # end if type= by report series


# fix this
if(type!="short" && type!="by report series" && type!="by country"){warning("specify one of the available summary types",call.=FALSE)}


} # end summary function



#</pre>