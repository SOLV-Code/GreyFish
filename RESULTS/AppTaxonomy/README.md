# Taxonomy of Online Apps


## Inventory of Apps


[Interactive Table](https://airtable.com/embed/shrfgKaXclantoQ4d?backgroundColor=gray&viewControls=on)




## Posters

Tunon and Pestal (2019) *Interactive Online Tools: The Future of Grey Literature*. OceanObs19
 ([pdf](http://solv.ca/GreyFish/Analyses/POSTER_OceanObs2019_Tunon&Pestal_ShinyGreyLit.pdf))

Pestal and Tunon (2019) *From Data Displays To Data Analyses: Building Interactive Tools That Encourage Active Exploration of Complex Data and Models.* OceanObs19 ([pdf](http://solv.ca/GreyFish/Analyses/POSTER_OceanObs2019_Pestal&Tunon_InteractiveTools.pdf))


## App Type

We assigned each app in the [inventory](../../DATA/OnlineApplications/) to
one of 5 categories, defined as:

* Data Portal: mainly focused on providing access to one ore more data sets
* Data Vis: includes data and various ways of displaying the data
* General Model: illustrates a basic model or concept  (e.g. fish growth equation)
* Model Documentation: documents the settings, assumptions, or results from a specific analysis 
* Analytical Tool:  allows users to load in their own data and implement analyses


The figure below shows the number of apps in the current inventory, separating data vs. model focused apps.


<img src="https://github.com/SOLV-Code/GreyFish/blob/master/DATA/OnlineApplications/GeneratedPlots/Summary_ByGeneralTopic.png"
	width="600">


### Component Scores

Many of the apps have multiple features, and span several of the categories. 
To capture this diversity, we assigned subjective scores 1-5 according to the following
 rough qualitative scales:
 
 **App Feature** | **Score = 1**  | **Score = 5** 
-- | -- | --
Data Portal |  One or a few  data sets, localized |  many datasets, or large scope
Data Vis   |  a few basic plots      |  several interactive variations, innovative plots
General Model | very basic model concept  |  highly specialized complex model
Model Documentation |  general illustration of a method | detailed results, interactive assumption testing
 Analytical Tool    | try out some alternative settings | load in your own data, full functionality


Examples to illustrate the scoring approach:

 **App** | **DP Score**  | **DV Score** | **GM Score** | **MD Score** | **AT Score** 
-- | -- | --| --| --| --
Teaching aid for Holling's  predator functional response,letting users try out parameter values | 0  | 0  | 5 | 0  | 0 
Data set with individual estimates and fitted Holling curves for many different species and areas, and interactive plotting options | 5  | 3 | 0 | 0  | 0 
App for fitting Holling curves using various frequentist and Bayesian approaches to your own data, including a few sample data sets, and fancy interactive displays to explore the results | 2  | 5  | 2 | 0  | 5
App with the specific data, fitting functions, and results for a paper on functional responses, with interactive sensitivity testing, but only a few basic plots  | 1  | 2 | 0 | 5 | 0 


The figure below shows the aggregate scores for each app in the current inventory, with DataScore = DPScore + DVScore and ModelScore = GMScore + MD Score + ATScore



<img src="https://github.com/SOLV-Code/GreyFish/blob/master/DATA/OnlineApplications/GeneratedPlots/TopTenApps_TotalScore.png"
	width="400">


<img src="https://github.com/SOLV-Code/GreyFish/blob/master/DATA/OnlineApplications/GeneratedPlots/TornadoPlot_AppFocus.png"
	width="800">




