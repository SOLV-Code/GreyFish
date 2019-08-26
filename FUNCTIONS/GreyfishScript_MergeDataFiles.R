#<pre>
##################################################################
# GREYFISH TOOLKIT - MERGING DATA FILES                          #
# Script to merge all current data files                         #
# developed by Gottfried Pestal of SOLV Consulting Ltd.          #
##################################################################

# THIS SCRIPT CREATES A MERGED FILE FROM ALL THE .csv FILES IN THE GREYFISH ARCHIVE (NOTE REQUIRED COLUMN HEADINGS!)
# USER NEEDS TO SPECIFY A TARGET DIRECTORY WHERE .csv FILES ARE STORED
# NOTE: STORES OUTPUT IN THE CURRENT WORKING DIRECTORY, NOT THE TARGET DIRECTORY (else would be reading itself next time around!)

#######################
# Version Tracker     #
# v 1.2 - August 2012 #
#######################

# specify path to directory
source.path <- "Data Files/"

# get a list of all the files in that directory
source.files <- list.files(source.path)

# extract the ones that are *.csv files
source.files <- source.files[grep(".csv", source.files)]


# read in all csv files and merge the columns with basic info
# Note: stringsAsFactors=FALSE needed to avoid problems in rbind(). If one file has all numeric in NumAuth and another has some "UFO" text strings, then factor levels can't be reconciled.
for(i in source.files){
print(paste("... reading file:",i))
if(i==source.files[1]){temp.src <- read.csv(paste(source.path,i,sep=""),stringsAsFactors=FALSE)[,c("Country","URL","Year","NumAuth","Agency","ReportSeries","Title","AllAuthors","Citation")]}
if(i!=source.files[1]){temp.src <- rbind(temp.src,read.csv(paste(source.path,i,sep=""),stringsAsFactors=FALSE)[,c("Country","URL","Year","NumAuth","Agency","ReportSeries","Title","AllAuthors","Citation")])}
} # end loop through all csv files

dim(temp.src)

write.csv(temp.src,"MergedFile.csv",row.names=FALSE)

# read in functions
source("GreyFish_CustomFunctions.R")

# create short summary of MergedFile.csv, then print to screen and  file
greyfish_summary(file="MergedFile.csv", type="short", output="both")

# create overview by report series of MergedFile.csv, then print  file
greyfish_summary(file="MergedFile.csv", type="by country", output="both")

# create overview by report series of MergedFile.csv, then print  file
greyfish_summary(file="MergedFile.csv", type="by report series", output="both")

#</pre>


