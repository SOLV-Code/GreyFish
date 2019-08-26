#<pre>
##############################################################
# GREYFISH TOOLKIT - EXPLORATORY PLOTS COMPARING AGENCIES    #
# developed by Gottfried Pestal of SOLV Consulting Ltd.      #
##############################################################

# THIS SCRIPT CREATES 1 PAGE OF DIAGNOSTIC PLOTS FOR EACH OF 3 DIFFERENT METRICS (Max Authors, Num Reports, Composition)
# FOR EACH METRIC IT SHOWS 1 AGENCY IN THE MAIN PANEL, AND UP TO 4 OTHER AGENCIES IN SUB-PANELS
# THIS SCRIPT REQUIRES THE FILE "GreyFish_CustomFunctions.r" AND A DATA FILE IN THE SAME DIRECTORY

#######################
# Version Tracker     #
# v 1 - July 2013     #
#######################


# CURRENT SETTINGS
# Main: New Zealand's Ministry of Fisheries (Label: NZ-MoF, Factor: MoF) 
# Sub1: Fisheries and Oceans Canada (Label: CAN-DFO, Factor: DFO)
# Sub2: Alaska dept of Fish & Game (Label: US-ADFG, Factor: ADFG )
# Sub3: National Marine Fisheries Sevice (Label: US-NMFS, Factor: NOAA)
# Sub 4: Fisheries Research Services / Marine Scotland 
#       (Label: MarScot, Factors:Fisheries Research Services, Marine Scotland)) 
#        -> Name change in 2009/10

# read in custom functions for analysis and plotting
source("GreyFish_CustomFunctions.R")



# read in data data
file.name <- "MergedFile.csv"

# check list of agencies in data file
data.file<-read.csv(file.name)
agency.list <- sort(unique(data.file[,"Agency"]))

print(agency.list)


# settings
print.type <- "SinglePDF"  # options are "ManyJPG" or "SinglePDF"
jpeg.res <- 900           # resolution in ppi, roughly 1MB per image at 300ppi, and 4 MB per image at 900 ppi

main.agency <- "MoF"
sub1.agency <- "DFO"
sub2.agency <- "ADFG"
sub3.agency <- "NOAA"
sub4.agency <- c("Fisheries Research Services", "Marine Scotland")

main.agency.label <- "NZ-MoF"
sub1.agency.label <- "CAN-DFO"
sub2.agency.label <- "US-ADFG"
sub3.agency.label <- "US-NMFS"
sub4.agency.label <- "MarScot"



# create subsetting criteria
main.reports.list <- unique(paste(data.file[which(data.file[,"Agency"] %in% main.agency),"Agency"],data.file[which(data.file[,"Agency"] %in% main.agency),"ReportSeries"],sep="-"))
sub1.reports.list <- unique(paste(data.file[which(data.file[,"Agency"] %in% sub1.agency),"Agency"],data.file[which(data.file[,"Agency"] %in% sub1.agency),"ReportSeries"],sep="-"))
sub2.reports.list <- unique(paste(data.file[which(data.file[,"Agency"] %in% sub2.agency),"Agency"],data.file[which(data.file[,"Agency"] %in% sub2.agency),"ReportSeries"],sep="-"))
sub3.reports.list <- unique(paste(data.file[which(data.file[,"Agency"] %in% sub3.agency),"Agency"],data.file[which(data.file[,"Agency"] %in% sub3.agency),"ReportSeries"],sep="-"))
sub4.reports.list <- unique(paste(data.file[which(data.file[,"Agency"] %in% sub4.agency),"Agency"],data.file[which(data.file[,"Agency"] %in% sub4.agency),"ReportSeries"],sep="-"))

# check report lists
print(main.agency)
print(main.reports.list)
print(sub1.agency)
print(sub1.reports.list)
print(sub2.agency)
print(sub2.reports.list)
print(sub3.agency)
print(sub3.reports.list)
print(sub4.agency)
print(sub4.reports.list)


# subset data and calculate simple diagnostics (see comments in "GreyFish_CustomFunctions.r" for details)
main.eda.out <- greyfish_eda(file="MergedFile.csv",reports=main.reports.list,print.data=FALSE)
sub1.eda.out <- greyfish_eda(file="MergedFile.csv",reports=sub1.reports.list,print.data=FALSE)
sub2.eda.out <- greyfish_eda(file="MergedFile.csv",reports=sub2.reports.list,print.data=FALSE)
sub3.eda.out <- greyfish_eda(file="MergedFile.csv",reports=sub3.reports.list,print.data=FALSE)
sub4.eda.out <- greyfish_eda(file="MergedFile.csv",reports=sub4.reports.list,print.data=FALSE)



# open pdf file (if applicable)
if(print.type=="SinglePDF"){
	pdf("GreyFish_ExploratoryPlots_AgencyComparisons.pdf",width=11,height=8.5,onefile=TRUE)
	layout(matrix(c(rep(1,12),2:5),ncol=4,byrow=TRUE))
	par(mar=c(3,3,2,1))
	}


# create a page of plots (see comments in "GreyFish_CustomFunctions.r" for details)

# PLOT 1 #############################################################################################

plot.list <-2
plot.var <-"Max_Auth"
plot.var.label <- "Max(Authors/Report)"
y.max <- 20

# open plot device (if applicable)
if(print.type=="ManyJPG"){
	jpeg("GreyFish_AgencyComparisons_MaxAuth.jpg",width=11,height=8.5, units = "in",quality=100,res=jpeg.res)
	layout(matrix(c(rep(1,12),2:5),ncol=4,byrow=TRUE))	
}


# create plots

par(mar=c(4.5,9,2,9))
# plot time series of highest number of authors for a report by year for main agency		
greyfish_tsplots(main.eda.out[[plot.list]][,"Year"],main.eda.out[[plot.list]][,plot.var]
			,type="ts1",trend=TRUE,add=FALSE,x.range=c(1950,2020),y.range=c(0,y.max),
			fig.lab=main.agency.label, x.lab="Year", y.lab=plot.var.label, panel.size="large")

# plot time series of highest number of authors for a report by year for 4 other agencies

par(mar=c(2.1,2.5,1.5,2))

greyfish_tsplots(sub1.eda.out[[plot.list]][,"Year"],sub1.eda.out[[plot.list]][,plot.var]
			,type="ts1",trend=TRUE,add=FALSE,x.range=c(1950,2020),
			y.range=c(0,y.max),fig.lab=sub1.agency.label, x.lab="", y.lab="", panel.size="small")

par(mar=c(2.1,2.5,1.5,2))

greyfish_tsplots(sub2.eda.out[[plot.list]][,"Year"],sub2.eda.out[[plot.list]][,plot.var]
			,type="ts1",trend=TRUE,add=FALSE,x.range=c(1950,2020),
			y.range=c(0,y.max),fig.lab=sub2.agency.label, x.lab="", y.lab="", panel.size="small")

greyfish_tsplots(sub3.eda.out[[plot.list]][,"Year"],sub3.eda.out[[plot.list]][,plot.var]
			,type="ts1",trend=TRUE,add=FALSE,x.range=c(1950,2020),
			y.range=c(0,y.max),fig.lab=sub3.agency.label, x.lab="", y.lab="", panel.size="small")

greyfish_tsplots(sub4.eda.out[[plot.list]][,"Year"],sub4.eda.out[[plot.list]][,plot.var]
			,type="ts1",trend=TRUE,add=FALSE,x.range=c(1950,2020),
			y.range=c(0,y.max),fig.lab=sub4.agency.label, x.lab="", y.lab="", panel.size="small")


if(print.type=="ManyJPG"){dev.off()}

# PLOT 2 #############################################################################################

plot.list <- 1
plot.var <-"NumReps"
plot.var.label <- "Number of Reports"

# open plot device (if applicable)
if(print.type=="ManyJPG"){
	jpeg("GreyFish_AgencyComparisons_NumRep.jpg",width=11,height=8.5, units = "in",quality=100,res=jpeg.res)
	layout(matrix(c(rep(1,12),2:5),ncol=4,byrow=TRUE))	
}


# create plots

par(mar=c(4.5,9,2,9))
# plot time series of highest number of authors for a report by year for main agency		
greyfish_tsplots(main.eda.out[[plot.list]][,"Year"],main.eda.out[[plot.list]][,plot.var]
			,type="ts1",trend=FALSE,add=FALSE,x.range=c(1950,2020),y.range=NULL,
			fig.lab=main.agency.label, x.lab="Year", y.lab=plot.var.label, panel.size="large")

# plot time series of highest number of authors for a report by year for 4 other agencies

par(mar=c(2.1,2.5,1.5,2))

greyfish_tsplots(sub1.eda.out[[plot.list]][,"Year"],sub1.eda.out[[plot.list]][,plot.var]
			,type="ts1",trend=FALSE,add=FALSE,x.range=c(1950,2020),
			y.range=NULL,fig.lab=sub1.agency.label, x.lab="", y.lab="", panel.size="small")

par(mar=c(2.1,2.5,1.5,2))

greyfish_tsplots(sub2.eda.out[[plot.list]][,"Year"],sub2.eda.out[[plot.list]][,plot.var]
			,type="ts1",trend=FALSE,add=FALSE,x.range=c(1950,2020),
			y.range=NULL,fig.lab=sub2.agency.label, x.lab="", y.lab="", panel.size="small")

greyfish_tsplots(sub3.eda.out[[plot.list]][,"Year"],sub3.eda.out[[plot.list]][,plot.var]
			,type="ts1",trend=FALSE,add=FALSE,x.range=c(1950,2020),
			y.range=NULL,fig.lab=sub3.agency.label, x.lab="", y.lab="", panel.size="small")

greyfish_tsplots(sub4.eda.out[[plot.list]][,"Year"],sub4.eda.out[[plot.list]][,plot.var]
			,type="ts1",trend=FALSE,add=FALSE,x.range=c(1950,2020),
			y.range=NULL,fig.lab=sub4.agency.label, x.lab="", y.lab="", panel.size="small")


if(print.type=="ManyJPG"){dev.off()}


# PLOT 3 #############################################################################################


# open plot device (if applicable)
if(print.type=="ManyJPG"){
	jpeg("GreyFish_AgencyComparisons_AuthComp.jpg",width=11,height=8.5, units = "in",quality=100,res=jpeg.res)
	layout(matrix(c(rep(1,12),2:5),ncol=4,byrow=TRUE))	
}



# calculate and plot proportion of reports with single author, 2-4 authors, and 5+ authors

par(mar=c(4.5,9,2.1,9))
main.comp <- auth.comp.calc(main.eda.out)
greyfish_sbplot(t(main.comp), perc=TRUE,fig.lab=main.agency.label,panel.size="large")

par(mar=c(2.1,2.5,1.5,2))
sub1.comp <- auth.comp.calc(sub1.eda.out)
greyfish_sbplot(t(sub1.comp), perc=TRUE,fig.lab=sub1.agency.label,panel.size="small")

sub2.comp <- auth.comp.calc(sub2.eda.out)
greyfish_sbplot(t(sub2.comp), perc=TRUE,fig.lab=sub2.agency.label, panel.size="small")

sub3.comp <- auth.comp.calc(sub3.eda.out)
greyfish_sbplot(t(sub3.comp), perc=TRUE,fig.lab=sub3.agency.label, panel.size="small")

sub4.comp <- auth.comp.calc(sub4.eda.out)
greyfish_sbplot(t(sub4.comp), perc=TRUE,fig.lab=sub4.agency.label,panel.size="small")



if(print.type=="ManyJPG"){dev.off()}




####################
# close pdf output (if applicable)
if(print.type=="SinglePDF"){dev.off()}





