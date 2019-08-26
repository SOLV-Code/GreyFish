
## GreyFish Data

*Note: For each data set, there is a README file with source details.*

### Basic Records

These data sets include fields for year, number of authors, and a full citation, as well as a link to the report where available. For each set, there is a csv file for importing into R, and a txt file with background information (e.g. source, download date, search parameters).

* Base Dataset - all data below
* Canada - DFO Science Reports - Research Documents
* Canada - DFO Science Reports - Other
* Canada - DFO Management Reports
* New Zealand - MoF Research Papers
* Scotland - Marine Scotland and FRS Science Reports
* USA - ADFG Science Reports
* USA - NMFS Science Reports

If you want to contribute data sets, refer to this [input file template](http://solv.ca/GreyFish/Tools/GreyFish_DataTemplate.csv).
Step-by-step instructions for converting a *.bib file are available
 [here](http://solv.ca/GreyFish/Tools/GreyFish_ConvertingABibFile.zip)
 (zip with code and sample files).




### Authorship Mapping

For the next phase of the project, we plan to extract
 first author information from the citation text strings and identify
 unique authors. This step is complicated by inconsistencies in formatting and the 
 inevitable typos (e.g. WE Ricker, W Ricker, B Ricker, BE Ricker, and WE Rikker likely 
 all refer to the same author, but J Smith could be several people). 
 So far, this is only an issue for a few dozen entries per data set, 
 and we are reviewing them on a case-by-case basis.

As GreyFish grows, we also plan to extract co-author names and explore more 
formal methods for authorship disambiguation 
(e.g. likelihood based on publication year, key words, and co-authors)

The use of unique author IDs, such as [ORCID](http://orcid.org/), is growing, but none 
of the fisheries agencies covered so far have implemented formal authorship tracking.

### Online Applications

GreyFish is expanding to cover online applications (e.g. interactive data visualizations). 
We are building 3 data sets:

* Interactive Tools - Shiny
* Interactive Tools - Other
* Non-interactive Data Portals

These data sets include links to the apps as well as fields for topic (e.g. "Fish Biology", app type (e.g. DataVis), status (e.g. "active"),
documentation type (e.g. "tech report"), and access type (e.g. "free & public").


