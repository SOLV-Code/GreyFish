#<pre>
########################################################
# GREYFISH TOOLKIT - EXPLORATORY ANALYSIS AND PLOTS    #
# developed by Gottfried Pestal of SOLV Consulting Ltd.#
########################################################

# THIS SCRIPT CREATES 1 PAGE OF DIAGNOSTIC PLOTS, FIRST FOR ALL RECORDS, THEN FOR EACH COUNTRY, THEN FOR EACH REPORT SERIES
# THIS SCRIPT REQUIRES THE FILE "GreyFish_CustomFunctions.r" AND A DATA FILE IN THE SAME DIRECTORY


#######################
# Version Tracker     #
# v 2 - July 2013     #
#######################


# read in custom functions for analysis and plotting
source("GreyFish_CustomFunctions.R")

file.name <- "MergedFile.csv"


###############################################
# EDA AND DIAGNOSTIC PLOTS FOR ALL REPORT TYPES

# calculate simple diagnostics (see comments in "GreyFish_CustomFunctions.r" for details)
eda.out <- greyfish_eda(file=file.name,reports="all")

# open pdf file for output
pdf("GreyFish_ExploratoryPlots_AllRecords.pdf",width=11,height=8.5,onefile=TRUE)

# create plots (see comments in "GreyFish_CustomFunctions.r" for details)
greyfish_edaplots1(eda.out, main.label=paste("All GreyFish Records",Sys.Date()))

# close pdf output
dev.off()





###############################################
# EDA AND DIAGNOSTIC PLOTS FOR EACH COUNTRY

# Get a list of countries
data.file<-read.csv(file.name)
country.list <- sort(unique(data.file[,"Country"]))

# open pdf file for output
pdf("GreyFish_ExploratoryPlots_ByCountry.pdf",width=11,height=8.5,onefile=TRUE)

# loop through countries
for(country in country.list){
print(country)

reports.list <- unique(paste(data.file[data.file[,"Country"]==country,"Agency"],data.file[data.file[,"Country"]==country,"ReportSeries"],sep="-"))

print(reports.list)

# calculate simple diagnostics (see comments in "GreyFish_CustomFunctions.r" for details)
eda.out <- greyfish_eda(file="MergedFile.csv",reports=reports.list,print.data=FALSE)

# create a page of plots (see comments in "GreyFish_CustomFunctions.r" for details)
greyfish_edaplots1(eda.out, main.label=paste(country,Sys.Date()))

} # end looping through report types

# close pdf output
dev.off()



###############################################
# EDA AND DIAGNOSTIC PLOTS FOR EACH AGENCY

# Get a list of agencies
data.file<-read.csv(file.name)
agency.list <- sort(unique(data.file[,"Agency"]))

# open pdf file for output
pdf("GreyFish_ExploratoryPlots_ByAgency.pdf",width=11,height=8.5,onefile=TRUE)

# loop through agencies
for(agency in agency.list){
print(agency)

reports.list <- unique(paste(data.file[data.file[,"Agency"]==agency,"Agency"],data.file[data.file[,"Agency"]==agency,"ReportSeries"],sep="-"))

print(reports.list)

# calculate simple diagnostics (see comments in "GreyFish_CustomFunctions.r" for details)
eda.out <- greyfish_eda(file="MergedFile.csv",reports=reports.list,print.data=FALSE)

# create a page of plots (see comments in "GreyFish_CustomFunctions.r" for details)
greyfish_edaplots1(eda.out, main.label=paste(agency,Sys.Date()))

} # end looping through agencies

# close pdf output
dev.off()






###############################################
# EDA AND DIAGNOSTIC PLOTS FOR EACH REPORT TYPE

# Get a list of report types
data.file<-read.csv(file.name)
report.list <- unique(paste(data.file[,"Agency"],data.file[,"ReportSeries"],sep="-"))

# open pdf file for output
pdf("GreyFish_ExploratoryPlots_ByReportType.pdf",width=11,height=8.5,onefile=TRUE)

# loop through report types
for(i in report.list){
print(i)
# calculate simple diagnostics (see comments in "GreyFish_CustomFunctions.r" for details)
eda.out <- greyfish_eda(file="MergedFile.csv",reports=i,print.data=FALSE)

# create a page of plots (see comments in "GreyFish_CustomFunctions.r" for details)
greyfish_edaplots1(eda.out, main.label=paste(i,Sys.Date()))

} # end looping through report types

# close pdf output
dev.off()


#</pre>


