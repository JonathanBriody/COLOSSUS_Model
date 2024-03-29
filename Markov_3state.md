<<<<<<< HEAD
---
title: 'Bevacizumab for Metastatic Colorectal Cancer with Chromosomal Instability:
  An Cost-Effectiveness Analysis of a Novel Subtype across the COLOSSUS Partner Countries'
author: "Jonathan Briody (1) | Kathleen Bennett (1) | Lesley Tilson (2)"
output:
  html_document: 
    keep_md: yes
  pdf_document: default
  word_document: default
editor_options:
  markdown:
    wrap: sentence
bibliography: references.bib
---

(1) Data Science Centre, RCSI University of Medicine and Health Sciences, Dublin, Ireland
(2) National Centre for Pharmacoeconomics, St James Hospital, Dublin 8, Ireland

**Co-authors:**

*Annette feels Rodrigo should be on this paper as he suggested considering the Angiopredict study. Annette said that as Matias Ebert, a gastroenterologist in Germany, is on both COLOSSUS and Angiopredict, he should be on the paper. This collaboration may also help us to get some of the cost data that we've been waiting on from Germany (in the end it didnt).*

*Annette feels that all the PIs on Angiopredict should be co-authors on this paper Matthias Ebert as mentioned above, Jochen Prehn and Bauke Ylstra. I would probably like to add Qiushi Chen, dependent on how helpful his thoughts on parametric survival analysis actually turn out to be.*

Authors (final list TBD): Jonathan Briody,  Ian Miller, Rodrigo Dienstmann, Lesley Tilson, Matthias Ebert, Jochen Prehn, Bauke Ylstra, Annette Byrne,  Kathleen Bennett. 
\

[*Possible Journal Homes:*]{.underline}

The Oncologist (<https://academic.oup.com/oncolo/pages/general-instructions>): Published a study on this in 2017:

Goldstein, D. A., Chen, Q., Ayer, T., Chan, K. K., Virik, K., Hammerman, A., \...
& Hall, P. S.
(2017).
Bevacizumab for Metastatic Colorectal Cancer: A Global Cost‐Effectiveness Analysis.
*The Oncologist*, *22*(6), 694-699.

Journal of Medical Economics <https://www.tandfonline.com/doi/pdf/10.1080/13696998.2021.1888743>

Clinical Colorectal Cancer <https://www-sciencedirect-com.proxy.library.rcsi.ie/science/article/pii/S1533002814000978>

Value in Health: FOCUSED ON CEA, ETC.,

Studies in Health Technology and Informatics

"New Journal: Oxford Open Economics" I have an email on this in my gmail, it's a new Journal and thus may be interested in this work.

We can increase our publication numbers by publishing a short summary of our study in: PharmacoEconomics & Outcomes News - per the description "Stay up to date with the exciting world of health economics. Solve the problem of reading and monitoring the vast volumes of literature necessary to stay informed on the latest issues in pharmacoeconomics and outcomes research by reading our concise news summaries, compiled in an easy-to-read format." <https://www.springer.com/journal/40274>

<https://www.clinical-colorectal-cancer.com/>

**Correspondence:**

Jonathan Briody, PhD, RCSI University of Medicine and Health Sciences, Beaux Lane House, Lower Mercer St, Dublin 2, Ireland.
Email: [jonathanbriody\@rcsi.ie](mailto:jonathanbriody@rcsi.ie){.email}

**Funding Information:**

This project has received funding from the European Union's Horizon 2020 research and innovation programme under grant agreement No 754923.
The material presented and views expressed here are the responsibility of the author(s) only.
The EU Commission takes no responsibility for any use made of the information set out.

\newpage

# Introduction

# Materials and Methods

#### Model Structure

#### Patients and Treatment Regimens

#### Transition Probabilities

# Parametric Survival Analysis:

# 




```r
#rm(list = ls())  
# clear memory (removes all the variables from the work space) - I turn this off on the understanding that the markdown doc that calls this file will clear memory.
#options(scipen=999) 
# turns scientific notation off
# options(scipen=0) turns it back on, per: https://stackoverflow.com/questions/5352099/how-can-i-disable-scientific-notation
```


```r
#01 Load all packages

# Joshua's Package Manager:

# Package names

packages <- c("pacman", "flexsurv", "MASS", "dplyr", "devtools", "scales", "ellipse", "ggplot2", "lazyeval", "igraph", "ggraph", "reshape2", "knitr", "stringr", "diagram", "survival", "lubridate", "ggsurvfit", "gtsummary", "tidycmprsk", "magrittr", "dplyr", "diffr", "gdata", "gridGraphics", "sjPlot", "stargazer", "tibble", "here", "collapse")

# Install packages not yet installed

installed_packages <- packages %in% rownames(installed.packages())

if (any(installed_packages == FALSE)) {

  install.packages(packages[!installed_packages])

}

# Packages loading

invisible(lapply(packages, library, character.only = TRUE))

p_load_gh("DARTH-git/dampack", "DARTH-git/darthtools")
```


```r
# Previous code to check whether the required packages are installed and, if not, install the missing packages
# # - the 'pacman' package is used to conveniently install other packages
# if (!require("pacman")) install.packages("pacman"); library(pacman)
# p_load("flexsurv", "MASS", "dplyr", "devtools", "scales", "ellipse", "ggplot2", "lazyeval", "igraph", "ggraph", "reshape2", "knitr", "stringr", "diagram")   
# p_load_gh("DARTH-git/dampack", "DARTH-git/darthtools")


# {r} # if (!require('pacman')) install.packages('pacman'); library(pacman)  # # use this package to conveniently install other packages # # load (install if required) packages from CRAN # p_load("diagram", "dampack", "reshape2") # # library(devtools) # devtools is necessary to install from github. # # install_github("DARTH-git/darthtools", force = TRUE) # Uncomment if there is a newer version # p_load_gh("DARTH-git/darthtools")
```


```r
#01.5 Load functions

# all functions are in the darthtools package

# There is a functions RMD for the PSA stuff below, instead of loading it lower down, I could just place it here, and place all the necessary packages above and then I would only ever need 1 R Markdown document for the entire study. Will think about doing this.
```


```r
# Country-specific cost data:


# Basically, what I have is 1 Rmarkdown document with appropriate CEA code, but 3 countries I want to separately apply this code to, because costs (and willingness to pay thresholds) are different in each of these 3 countries.

# To do this, I feed in the cost data from each country for parameters that differ across countries, just uncomment the country you want to run this code for:


# # Ireland:
# 
# country_name <- "Ireland"
# 
# 
# # 1. Cost of treatment in this country
# c_PFS_Folfox <- 307.81 
# c_PFS_Bevacizumab <- 2580.38  
# c_OS_Folfiri <- 326.02  
# administration_cost <- 365.00 
# 
# # 2. Cost of treating the AE conditional on it occurring
# c_AE1 <- 2835.89
# c_AE2 <- 1458.80
# c_AE3 <- 409.03 
# 
# # 3. Willingness to pay threshold
# n_wtp = 45000




# Germany:

# country_name <- "Germany"

# 1. Cost of treatment in this country
# c_PFS_Folfox <- 1276.66
# c_PFS_Bevacizumab <- 1325.87
# c_OS_Folfiri <- 1309.64
# administration_cost <- 1794.40

# 2. Cost of treating the AE conditional on it occurring
# c_AE1 <- 3837
# c_AE2 <- 1816.37
# c_AE3 <- 526.70

# 3. Willingness to pay threshold
# n_wtp = 78871



# Spain:

#country_name <- "Spain"


# 1. Cost of treatment in this country
#c_PFS_Folfox <- 285.54
#c_PFS_Bevacizumab <- 1325.87
#c_OS_Folfiri <- 139.58
#administration_cost <- 314.94

# 2. Cost of treating the AE conditional on it occurring
#c_AE1 <- 4885.95
#c_AE2 <- 507.36
#c_AE3 <- 95.03

# 3. Willingness to pay threshold
#n_wtp = 30000
```


```r
#02 Individual Data for Parametric Code

# Load the individual patient data for the time-to-progression (TTP) that you recovered by digitising published survival curves (actually, Ian Miller gave us the Angiopredict data directly).

# df_TTP <- read.csv(file='PFS.csv', header=TRUE)
# save.image("C:/Users/Jonathan/OneDrive - Royal College of Surgeons in Ireland/COLOSSUS/R Code/GitHub/COLOSSUS_Model/df_TTP.RData")
# df_TTD <- read.csv(file='OS.csv', header=TRUE)
# save.image("C:/Users/Jonathan/OneDrive - Royal College of Surgeons in Ireland/COLOSSUS/R Code/GitHub/COLOSSUS_Model/df_TTD.RData")

load(file = "df_TTP.RData")
# Load the individual patient data for the time-to-progression (TTP) that you recovered by digitising published survival curves (actually, Ian Miller gave us the Angiopredict data directly).
load(file = "df_TTD.RData")
# I have time-to-death (TTD) data, I'll load it in here.

# Here's how to remove the BVZ rows from the excel files we have: https://techcommunity.microsoft.com/t5/excel/deleting-rows-that-contain-specific-content/m-p/2084473

# The data needs to be set up to include a column for the time (in the example this is time in years) and a status indicator whether the time corresponds to an event, i.e. progression (status = 1), or to the last time of follow up, i.e. censoring (status = 0),

# "What is Censoring? Censoring in a study is when there is incomplete information about a study participant, observation or value of a measurement. In clinical trials, it's when the event doesn't happen while the subject is being monitored or because they drop out of the trial." - https://www.statisticshowto.com/censoring/#:~:text=What%20is%20Censoring%3F,drop%20out%20of%20the%20trial.

# https://en.wikipedia.org/wiki/Survival_analysis#:~:text=or%20q%20%3D%200.99.-,Censoring,is%20common%20in%20survival%20analysis.

# At the bottom of the parametric survival code I think about how time from individual patient data may be changed to match the time of our cycles.

# I think the digitiser will give me the time in the context of the survival curves I am digitising, i.e., time in weeks, or time in months or time in years.

# Then I will have to set-up my time accordingly in the R code so that my cycle length is at the same level as the individual patient data.

# That is, in Koen's example:

# C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\R Code\Parametric Survival Analysis\ISPOR WEBINAR Health Economic Modelling in R\ISPOR_webinar_R-master

# the data includes a column for the time (in years)
# t_cycle <- 1/4      # cycle length of 3 months (in years)                                # n_cycle <- 60       # number of cycles (total runtime 15 years)
  

# So I would have my colum for time, in the [TIME] the graph I was digitising used.
# Then I would create my cycle length of X weeks (in [TIME] the graph I was digitising used)
# Then I would have my number of cycles that would add up to give me a total runtime of how long I want to run the model for.
# So, above Koen wanted to run the model for 15 years, but his cycles were in 3 months, or each cycle was a quarter of a year, so 60 quarters, or 60 3 month cycles, is 15 years.
```

# 


```r
#03 Parametric Survival Analysis Model Plan

# We will implement a Markov model with time-dependent transition probabilities, via a parametric survival model fitted to some individual patient data for the time-to-progression (TTP) and time-to-death (TTD) for standard of care.

# A hazard ratio for the new intervention therapy vs. the standard of care will then be applied to obtain transition probabilities for the new experimental strategy.

# Let's first review the survival curves and see if they match the study:

# My understanding of survival curves is supported by: https://www.emilyzabor.com/tutorials/survival_analysis_in_r_tutorial.html

# A really good intro to survival curves is here: https://shariq-mohammed.github.io/files/cbsa2019/1-intro-to-survival.html

# Some early and simple survival curves:

# km_fit_PFS <- survfit(Surv(time, status) ~ 1, data=df_TTP)
# plot(km_fit_PFS)
# 
# km_fit_OS <- survfit(Surv(time, status) ~ 1, data=df_TTD)
# plot(km_fit_OS)

# Before I used Joshua's awesome package management code above, I installed packages as below:

#install.packages(c("survival", "lubridate", "ggsurvfit", "gtsummary", "tidycmprsk"))
#remotes::install_github("zabore/condsurv")
#remotes::install_github("zabore/ezfun")
# library(survival)
# library(lubridate)
# library(ggsurvfit)
# library(gtsummary)
# library(tidycmprsk)
# #library(condsurv)
# #install.packages("magrittr") # package installations are only needed the first time you use it
# #install.packages("dplyr")    # alternative installation of the %>%
# library(magrittr) # needs to be run every time you start R and want to use %>%
# library(dplyr)    # alternatively, this also loads %>%


# We want to make sure the data we're feeding in matches the data from the publication in Table 4d and Supplementary Table 10d
#png(paste("Baseline_PFS_Curves", ".png"))
survfit2(Surv(time, status) ~ 1, data = df_TTP) %>% ggsurvfit() +
  labs(
    x = "Days",
    y = "Progression Free survival probability"
  ) + 
  add_risktable()
```

<img src="Markov_3state_files/figure-html/unnamed-chunk-9-1.png" width="672" />

```r
#print(plot)
ggsave("Baseline_PFS_Curves.png", width = 8, height = 4, dpi=300)
#dev.off()
while (!is.null(dev.list()))  dev.off()

# I was getting the following error: "Error in dev.off() : cannot shut down device 1 (the null device)" which I addressed by adding this following each ggsave: while (!is.null(dev.list()))  dev.off() per the following link: https://stackoverflow.com/questions/44336215/error-in-dev-off-cannot-shut-down-device-1-the-null-device






km_fit_PFS <- survfit(Surv(time, status) ~ 1, data=df_TTP)
summary(km_fit_PFS, times = c(0,150,300,450, 600, 750, 900, 1050, 1200, 1350)) # This will stop just before the last patient is censored in the data, also, n.event means number of events that happened at this time.
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTP)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##     0    202       0   1.0000 0.00000      1.00000       1.0000
##   150    136      67   0.6683 0.03313      0.60644       0.7365
##   300     65      69   0.3242 0.03303      0.26551       0.3958
##   450     27      38   0.1347 0.02410      0.09482       0.1912
##   600     11      15   0.0570 0.01656      0.03223       0.1007
##   750      6       5   0.0311 0.01244      0.01418       0.0681
##   900      3       3   0.0155 0.00888      0.00507       0.0477
##  1050      1       1   0.0104 0.00728      0.00261       0.0410
##  1200      1       0   0.0104 0.00728      0.00261       0.0410
```

```r
survfit2(Surv(time, status) ~ 1, data = df_TTD) %>% ggsurvfit() +
  labs(
    x = "Days",
    y = "Overall survival probability"
  ) + 
  add_risktable()
ggsave("Baseline_OS_Curves.png", width = 4, height = 4, dpi=300)
#png(paste("Baseline_OS_Curves", ".png"))
#dev.off()
while (!is.null(dev.list()))  dev.off()

km_fit_OS <- survfit(Surv(time, status) ~ 1, data=df_TTD)
summary(km_fit_OS, times = c(0,300,600,900,1200,1500,1800,1810,1820,1830,1840,1850,1860,1870,1880,1890,1891,1892,1893,1894,1895,1896,1897,1898,1899,1900,1901,2000,2010))
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTD)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##     0    202       0   1.0000  0.0000      1.00000        1.000
##   300    154      47   0.7667  0.0298      0.71047        0.827
##   600     95      57   0.4809  0.0354      0.41638        0.555
##   900     49      43   0.2581  0.0313      0.20340        0.327
##  1200     15      24   0.1068  0.0242      0.06847        0.166
##  1500      5       4   0.0725  0.0218      0.04023        0.131
##  1800      1       1   0.0362  0.0278      0.00804        0.163
##  1810      1       0   0.0362  0.0278      0.00804        0.163
##  1820      1       0   0.0362  0.0278      0.00804        0.163
##  1830      1       0   0.0362  0.0278      0.00804        0.163
##  1840      1       0   0.0362  0.0278      0.00804        0.163
##  1850      1       0   0.0362  0.0278      0.00804        0.163
##  1860      1       0   0.0362  0.0278      0.00804        0.163
##  1870      1       0   0.0362  0.0278      0.00804        0.163
##  1880      1       0   0.0362  0.0278      0.00804        0.163
##  1890      1       0   0.0362  0.0278      0.00804        0.163
##  1891      1       0   0.0362  0.0278      0.00804        0.163
##  1892      1       0   0.0362  0.0278      0.00804        0.163
##  1893      1       0   0.0362  0.0278      0.00804        0.163
##  1894      1       0   0.0362  0.0278      0.00804        0.163
##  1895      1       0   0.0362  0.0278      0.00804        0.163
##  1896      1       0   0.0362  0.0278      0.00804        0.163
##  1897      1       0   0.0362  0.0278      0.00804        0.163
##  1898      1       0   0.0362  0.0278      0.00804        0.163
##  1899      1       0   0.0362  0.0278      0.00804        0.163
```

```r
# The PFS and OS curves I create, match those from the publication, so we know the data we are feeding in is correct.




# Now lets aks ourselves, do the Weibull probabilities we create match the probabilities created directly by the Kaplan-Meier (probably best to read this with the PDF of the Angiopredict study open on the survival curves (PFS and OS) for Figure 4d in the paper, and Figure 10d in the supplement (which represents the patient time to event data that is used in this study)):

# Seeing that the PFS and OS curves I create, match those from the publication, the problem I was having in matching these must be in how I am generating probabilities in my model.

# I calculate the probability of not progressing at the different time periods in the data from the publication, to contrast this to the probabilities I create of not progressing at different time periods once I've created probabilities in the R code, the probability of survival at each time period will be reported under the "survival" heading, per: https://www.emilyzabor.com/tutorials/survival_analysis_in_r_tutorial.html 

summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 0)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTP)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##     0    202       0        1       0            1            1
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 150)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTP)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##   150    136      67    0.668  0.0331        0.606        0.737
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 300)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTP)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##   300     65     136    0.324   0.033        0.266        0.396
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 450)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTP)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##   450     27     174    0.135  0.0241       0.0948        0.191
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 600)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTP)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##   600     11     189    0.057  0.0166       0.0322        0.101
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 750)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTP)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##   750      6     194   0.0311  0.0124       0.0142       0.0681
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 900)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTP)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##   900      3     197   0.0155 0.00888      0.00507       0.0477
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 1050)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTP)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##  1050      1     198   0.0104 0.00728      0.00261        0.041
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 1200)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTP)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##  1200      1     198   0.0104 0.00728      0.00261        0.041
```

```r
# I can repeat this for TTD:


summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 0)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTD)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##     0    202       0        1       0            1            1
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 150)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTD)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##   150    178      24    0.881  0.0228        0.838        0.927
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 300)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTD)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##   300    154      47    0.767  0.0298         0.71        0.827
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 450)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTD)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##   450    127      75    0.627  0.0341        0.564        0.698
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 600)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTD)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##   600     95     104    0.481  0.0354        0.416        0.555
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 750)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTD)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##   750     64     133    0.332  0.0335        0.272        0.404
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 900)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTD)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##   900     49     147    0.258  0.0313        0.203        0.327
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 1050)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTD)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##  1050     34     156    0.208  0.0294        0.157        0.274
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 1200)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTD)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##  1200     15     171    0.107  0.0242       0.0685        0.166
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 1350)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTD)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##  1350     10     173   0.0906  0.0231       0.0549        0.149
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 1500)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTD)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##  1500      5     175   0.0725  0.0218       0.0402        0.131
```

```r
# Do the Weibull probabilities match the probabilities created directly by the Kaplan-Meier:

# Here's how I checked if the Weibull probabilities match the probabilities created directly by the Kaplan-Meier, basically, I take the Kaplan-Meier probabilities at a few different cycles directly from the data as below, the probability of survival at each time period will be reported under the "survival" heading:

# I do this first for TTP:

# summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 0)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 14)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 28)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 42)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 56)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 70)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 84)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 98)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 112)


# Then, I calculate the probability of staying in the PFS state, which is what the above gives me. To do this, I create all the other probabilities as zero because I just want to look at whats going on with my Weibull probabilities for the PFS curve, I also put it in the first slot, as the way it works is that it needs to be multiplied by 1, and m_M_SoC has a cohort trace with 1 in in the first slot, ready to be matrix multiplied by m_P_SoC with it's probabilities. It's 1- because the probabilities created above from the PFS curve are probabilities of staying in PFS, not the probabilities of moving from PFS to OS.

# m_P_SoC["PFS", "PFS",]<- (1 -p_PFSOS_SoC)
# m_P_SoC["PFS", "OS",]<- 0
# m_P_SoC["PFS", "Dead",]<-0
# 
# # Setting the transition probabilities from OS
# m_P_SoC["OS", "OS", ] <- 0
# m_P_SoC["OS", "Dead", ]        <- 0
# 
# 
# # Setting the transition probabilities from Dead
# m_P_SoC["Dead", "Dead", ] <- 0

# So here I once again create the Markov cohort trace by looping over all cycles
# - note that the trace can easily be obtained using matrix multiplications
# - note that now the right probabilities for the cycle need to be selected, like I explained above. (this is all just the comments written from where I actually do the analysis).
# for(i_cycle in 1:(n_cycle-1)) {
#   m_M_SoC[i_cycle + 1, ] <- m_M_SoC[i_cycle, ] %*% m_P_SoC[ , , i_cycle]
#   m_M_Exp[i_cycle + 1, ] <- m_M_Exp[i_cycle, ] %*% m_P_Exp[ , , i_cycle]
# }

# head(m_M_SoC)  # print the first few lines of the matrix for standard of care (m_M_SoC)
# head(m_M_Exp)  # print the first few lines of the matrix for experimental treatment(m_M_Exp)

# looking at the cohort trace -> m_M_SoC, you see that the proportions in the PFS state from 100 are basically identical to the probabilities of being in those states created from the Kaplan Meier, again starting from 100% of people under study, thus, the Weibull probabilities created match the Kaplan-Meier.

# They can be a few % off but that's OK, as it's fitting a Weibull to the Kaplan Meier curves, so they're not going to be identical.

# m_M_SoC


# I can repeat this for TTD:
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 0)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 14)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 28)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 42)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 56)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 70)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 84)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 98)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 112)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 126)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 158)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 172)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 184)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 198)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 212)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 224)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 238)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 252)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 266)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 280)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 294)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 308)

# Here, like above, I put the p_PFSD_SoC bit into the first part of the probability matrix, even though it concerns people going from first line treatment or PFS to dead, because it needs to be multiplied by the 1 that exists in the cohort:

# 
# m_P_SoC["PFS", "PFS",]<- 1- p_PFSD_SoC
# m_P_SoC["PFS", "OS",]<- 0
# m_P_SoC["PFS", "Dead",]<-0
# 
# # Setting the transition probabilities from OS
# m_P_SoC["OS", "OS", ] <- 0
# m_P_SoC["OS", "Dead", ]        <- 0
# 
# 
# # Setting the transition probabilities from Dead
# m_P_SoC["Dead", "Dead", ] <- 0

# So here I once again create the Markov cohort trace by looping over all cycles
# - note that the trace can easily be obtained using matrix multiplications
# - note that now the right probabilities for the cycle need to be selected, like I explained above.
# for(i_cycle in 1:(n_cycle-1)) {
#   m_M_SoC[i_cycle + 1, ] <- m_M_SoC[i_cycle, ] %*% m_P_SoC[ , , i_cycle]
#   m_M_Exp[i_cycle + 1, ] <- m_M_Exp[i_cycle, ] %*% m_P_Exp[ , , i_cycle]
# }
# 
# 
# head(m_M_SoC)  # print the first few lines of the matrix for standard of care (m_M_SoC)
# head(m_M_Exp)  # print the first few lines of the matrix for experimental treatment(m_M_Exp)
# 
# #m_M_SoC
# m_M_SoC

# This also answers the question of how exactly probabilities are created in my code, the m_P_SoC is something that, when multiplied by 1, (when at the start 100% of our cohort are in the PFS state) gives us the first probability from that 100%, and the next part or row of that m_P_SoC probability is then multiplied by the proportion who are in the different states in the next row for the cohort (given their movements last time having been multiplied by m_P_SoC) which gives us the second probability multiplied by the proportion of that 1 (or 100%) in each state, and so on, and so forth, for each wave.
```


```r
# Time-to-Progression (TTP):
#04 Parametric Survival Analysis itself:

# We use the 'flexsurv' package to fit several commonly used parametric survival distributions.

# The data needs to be set up to include a column for the time (in days, weeks, years, etc.,) and a status indicator whether the time corresponds to an event, i.e. progression (status = 1), or to the last time of follow up, i.e. censoring (status = 0).


# It looks like in the example, Koen is applying the flexsurvreg formula to individuals who experience progression (i.e. ~1):

head(df_TTP)
```

```
##   time status
## 1  739      1
## 2  211      1
## 3  311      1
## 4  412      1
## 5   25      1
## 6  302      1
```

```r
l_TTP_SoC_exp      <- flexsurvreg(formula = Surv(time, status) ~ 1, data = df_TTP, dist = "exp")
l_TTP_SoC_gamma    <- flexsurvreg(formula = Surv(time, status) ~ 1, data = df_TTP, dist = "gamma")
l_TTP_SoC_gompertz <- flexsurvreg(formula = Surv(time, status) ~ 1, data = df_TTP, dist = "gompertz")
l_TTP_SoC_llogis   <- flexsurvreg(formula = Surv(time, status) ~ 1, data = df_TTP, dist = "llogis")
l_TTP_SoC_lnorm    <- flexsurvreg(formula = Surv(time, status) ~ 1, data = df_TTP, dist = "lnorm")
l_TTP_SoC_weibull  <- flexsurvreg(formula = Surv(time, status) ~ 1, data = df_TTP, dist = "weibull")
```


```r
#05 Inspecting the fits:

# And this would make sense per the below diagram - which looks at the proportion of individuals who have the event, i.e. progression.

# Inspect fit based on visual fit
colors <- rainbow(6)
plot(l_TTP_SoC_exp,       col = colors[1], ci = FALSE, ylab = "Event-free proportion", xlab = "Time in days", las = 1)
lines(l_TTP_SoC_gamma,    col = colors[2], ci = FALSE)
lines(l_TTP_SoC_gompertz, col = colors[3], ci = FALSE)
lines(l_TTP_SoC_llogis,   col = colors[4], ci = FALSE)
lines(l_TTP_SoC_lnorm,    col = colors[5], ci = FALSE)
lines(l_TTP_SoC_weibull,  col = colors[6], ci = FALSE)
legend("right",
       legend = c("exp", "gamma", "gompertz", "llogis", "lnorm", "weibull"),
       col    = colors,
       lty    = 1,
       bty    = "n")
```

<img src="Markov_3state_files/figure-html/unnamed-chunk-11-1.png" width="672" />

```r
#ggsave("Inspecting_Fits_PFS.png", width = 4, height = 4, dpi=300)
#while (!is.null(dev.list()))  dev.off()
#png(paste("Inspecting_Fits_PFS", ".png"))
#dev.off()

# Saving plots is as described here: https://stackoverflow.com/questions/70879324/storing-plots-as-variables-in-r

# By simply adding "; plot1 <- recordPlot()" to the end of the plot, I have the plot saved in the environment to enter into the console or as a piece of code in the Rmarkdown document whenever I like (using the name plot1) whenever I like. 

# I just need to remember to keep it when deleting items in the Rmarkdown file that calls this document.

# I run into trouble with this approach when I call this rmarkdown file from another rmarkdown file, so I can put the png("mtcars.png") above the plot and the following print(plot) dev.off() below the plot and save in that way, as per: https://ggplot2.tidyverse.org/reference/ggsave.html and here: https://stackoverflow.com/questions/58989775/how-to-using-code-to-save-plots-in-rstudio

# Koen says "# Weibull has the best visual and numerical fit" but I don't see what it's visually being compared to in this graph, I will have to learn about this in the C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\R Code\Parametric Survival Analysis\flexsurv folder.

# For Koen the time is in years which makes sense, the data he is drawing from is in years so that's what you want to make comparisons to.
```


```r
# Compare the fit numerically based on the AIC
(v_AIC_TTP <- c(
  exp      = l_TTP_SoC_exp$AIC,
  gamma    = l_TTP_SoC_gamma$AIC,
  gompertz = l_TTP_SoC_gompertz$AIC,
  llogis   = l_TTP_SoC_llogis$AIC,
  lnorm    = l_TTP_SoC_lnorm$AIC,
  weibull  = l_TTP_SoC_weibull$AIC
))
```

```
##      exp    gamma gompertz   llogis    lnorm  weibull 
##     2604     2570     2595     2580     2580     2575
```

```r
#v_AIC_TTP <- tibble::enframe(v_AIC_TTP)


# Weibull has the best visual and numerical fit


# tab_df(,
# title = "AIC Values", #always give
# #your tables
# #titles
# file = "v_AIC_TTP.doc")
```


```r
#06 Saving the survival parameters for use in the model:

# Saving the survival parameters ----

# The 'flexsurv' package return the coefficients, which need to be transformed for use in the base R functions, but that will be done when the coefficients actually are used, for the time being we will just save the survival parameters from the distribution we decide to use. 

# NB, if we are not going with Weibull then we may have to save something specific to the distribution that is not shape or scale - we can look into this if we don't use Weibull.

l_TTP_SoC_weibull
```

```
## Call:
## flexsurvreg(formula = Surv(time, status) ~ 1, data = df_TTP, 
##     dist = "weibull")
## 
## Estimates: 
##        est       L95%      U95%      se      
## shape    1.3917    1.2520    1.5470    0.0751
## scale  286.7776  258.1993  318.5191   15.3598
## 
## N = 202,  Events: 198,  Censored: 4
## Total time at risk: 52049
## Log-likelihood = -1285, df = 2
## AIC = 2575
```

```r
# Calling a flexsurvreg parameter like this allows you to see here that Weibull is the shape and the scale, so if we do go with another distribution we can see what it's version of shape and scale are and use these instead.

l_TTP_SoC_weibull$coefficients
```

```
##  shape  scale 
## 0.3305 5.6587
```

```r
coef_weibull_shape_SoC <- l_TTP_SoC_weibull$coefficients["shape"]
coef_weibull_scale_SoC <- l_TTP_SoC_weibull$coefficients["scale"]
```


```r
#Time-to-Dead (TTD):

#07 Parametric Survival Analysis itself:

# I repeat the things I said for TTP here:

# We use the 'flexsurv' package to fit several commonly used parametric survival distributions.

# The data needs to be set up to include a column for the time (in days, weeks, years, etc.,) and a status indicator whether the time corresponds to an event, i.e. progression (status = 1), or to the last time of follow up, i.e. censoring (status = 0).

# It looks like in his example, Koen is applying the flexsurvreg formula to individuals who experience progression (i.e. ~1):

head(df_TTD)
```

```
##   time status
## 1 1899      0
## 2  211      1
## 3  610      1
## 4  673      1
## 5   25      1
## 6 1187      1
```

```r
l_TTD_SoC_exp      <- flexsurvreg(formula = Surv(time, status) ~ 1, data = df_TTD, dist = "exp")
l_TTD_SoC_gamma    <- flexsurvreg(formula = Surv(time, status) ~ 1, data = df_TTD, dist = "gamma")
l_TTD_SoC_gompertz <- flexsurvreg(formula = Surv(time, status) ~ 1, data = df_TTD, dist = "gompertz")
l_TTD_SoC_llogis   <- flexsurvreg(formula = Surv(time, status) ~ 1, data = df_TTD, dist = "llogis")
l_TTD_SoC_lnorm    <- flexsurvreg(formula = Surv(time, status) ~ 1, data = df_TTD, dist = "lnorm")
l_TTD_SoC_weibull  <- flexsurvreg(formula = Surv(time, status) ~ 1, data = df_TTD, dist = "weibull")
```


```r
#08 Inspecting the fits:

# And this would make sense per the below diagram - which looks at the proportion of individuals who have the event, i.e. going to dead.

# Inspect fit based on visual fit
colors <- rainbow(6)
plot(l_TTD_SoC_exp,       col = colors[1], ci = FALSE, ylab = "Event-free proportion", xlab = "Time in days", las = 1)
lines(l_TTD_SoC_gamma,    col = colors[2], ci = FALSE)
lines(l_TTD_SoC_gompertz, col = colors[3], ci = FALSE)
lines(l_TTD_SoC_llogis,   col = colors[4], ci = FALSE)
lines(l_TTD_SoC_lnorm,    col = colors[5], ci = FALSE)
lines(l_TTD_SoC_weibull,  col = colors[6], ci = FALSE)
legend("right",
       legend = c("exp", "gamma", "gompertz", "llogis", "lnorm", "weibull"),
       col    = colors,
       lty    = 1,
       bty    = "n")
```

<img src="Markov_3state_files/figure-html/unnamed-chunk-15-1.png" width="672" />

```r
#ggsave("Inspecting_Fits_OS.png", width = 4, height = 4, dpi=300)
#while (!is.null(dev.list()))  dev.off()
#png(paste("Inspecting_Fits_OS", ".png"))
#dev.off()



# Koen says "# Weibull has the best visual and numerical fit" but I don't see what it's visually being compared to in this graph, I will have to learn about this in the C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\R Code\Parametric Survival Analysis\flexsurv folder.

# For Koen the time is in years which makes sense, the data he is drawing from is in years so that's what you want to make comparisons to.
```


```r
# Compare the fit numerically based on the AIC
(v_AIC_TTD <- c(
  exp      = l_TTD_SoC_exp$AIC,
  gamma    = l_TTD_SoC_gamma$AIC,
  gompertz = l_TTD_SoC_gompertz$AIC,
  llogis   = l_TTD_SoC_llogis$AIC,
  lnorm    = l_TTD_SoC_lnorm$AIC,
  weibull  = l_TTD_SoC_weibull$AIC
))
```

```
##      exp    gamma gompertz   llogis    lnorm  weibull 
##     2664     2649     2648     2665     2680     2646
```

```r
# Weibull has the best visual and numerical fit
```


```r
#09 Saving the survival parameters for use in the model:

# Saving the survival parameters ----

# The 'flexsurv' package return the coefficients, which need to be transformed for use in the base R functions, but that will be done when the coefficients actually are used, for the time being we will just save the survival parameters from the distribution we decide to use. 

# NB, if we are not going with Weibull then we may have to save something specific to the distribution that is not shape or scale - we can look into this if we don't use Weibull.

l_TTD_SoC_weibull
```

```
## Call:
## flexsurvreg(formula = Surv(time, status) ~ 1, data = df_TTD, 
##     dist = "weibull")
## 
## Estimates: 
##        est       L95%      U95%      se      
## shape    1.3530    1.1967    1.5297    0.0847
## scale  733.3499  656.5785  819.0978   41.3754
## 
## N = 202,  Events: 176,  Censored: 26
## Total time at risk: 124782
## Log-likelihood = -1321, df = 2
## AIC = 2646
```

```r
# Calling a flexsurvreg parameter like this allows you to see here that Weibull is the shape and the scale, so if we do go with another distribution we can see what it's version of shape and scale are and use these instead.

l_TTD_SoC_weibull$coefficients
```

```
##  shape  scale 
## 0.3023 6.5976
```

```r
coef_TTD_weibull_shape_SoC <- l_TTD_SoC_weibull$coefficients["shape"]
coef_TTD_weibull_scale_SoC <- l_TTD_SoC_weibull$coefficients["scale"]
```


```r
#03 Input model parameters
#  This is just a block of text reminding myself why ordering, V_names_states v_tc_SoC, v_tc_Exp,  v_tu_SoC and v_tu_Exp matters, feel free to skip over this:

# The ordering of V_names_states has an influence on the tornado diagram and the reported cost-effectiveness results.

# So, I need to ensure I correctly order V_names_states all the way through from the start.

# m_P_Exp and m_P_SoC both use v_names_states to set up the names of the rows and columns of their matrices. 

# As does m_M_SoC and m_M_Exp.

# Then m_M_SoC and  m_M_Exp use the row column names to fill in the 100% of the cohort (or 1) in PFS and the 0% of the cohort in OS and DEAD in wave 1. m_P_Exp and m_P_SoC also both use the row and column names to fill in the transition probabilities between PFS and OS, etc.,

# Then m_M_SoC and m_M_Exp are matrix multiplied by m_P_Exp and m_P_SoC:

# for(i_cycle in 1:(n_cycle-1)) {
#  m_M_SoC[i_cycle + 1, ] <- m_M_SoC[i_cycle, ] %*% m_P_SoC[ , , i_cycle]
#  m_M_Exp[i_cycle + 1, ] <- m_M_Exp[i_cycle, ] %*% m_P_Exp[ , , i_cycle]
# }

# The way this matrix multiplication works is that the value in box 1 for m_M_SoC is multiplied by the value in box 1 for m_P_SoC and so on. If box 1 for m_M_SoC and m_P_SoC is the 1 (i.e. 100% of people in the PFS state when this all starts), multiplied by the PFS state probabilities, i.e., the probability of going from the PFS state into other states like so:

#          PFS       AE1       AE2       AE3          OS        Dead

# PFS  0.974925 0.0194985 0.0194985 0.0194985 0.005074995 0.020000000

# (Ignore the AE health states, this layout is a holdover from when AE's were going to have their own health states in the Markov model).

# Then things will multiply correctly and we're multiplying PFS transition probabilities by the 100% of the cohort in the PFS state. 

# Even, if ordering v_names_states  <- c("PFS", "AE1", "AE2", "AE3", "OS", "Dead")   is not in the order as above, i.e., v_names_states  <- c("OS", "AE1", "AE2", "AE3", "PFS", "Dead") , then the m_M_SoC will have 0, 0, 0, 0, 1, 0, because everyone still starts in the PFS state, and m_P_SoC will have  "OS", "AE1", "AE2", "AE3", "PFS", "Dead", with the right probabilities put in the right spots, so when you matrix multiply it things will multiply out fine.

# However, this is not the case for ordering costs and utilities:

# v_tc_SoC <- m_M_SoC %*% c(c_F_SoC, c_AE1, c_AE2, c_AE3, c_P, c_D)
# v_tc_Exp <- m_M_Exp %*% c(c_F_Exp, c_AE1, c_AE2, c_AE3, c_P, c_D)
# v_tu_SoC <- m_M_SoC %*% c(u_F, u_AE1, u_AE2, u_AE3, u_P, u_D)
# v_tu_Exp <- m_M_Exp %*% c(u_F, u_AE1, u_AE2, u_AE3, u_P, u_D)

# As you can see, in both cases the ordering is set manually by how we enter things in the concatenated brackets, so in the case above where ordering v_names_states  <- c("PFS", "AE1", "AE2", "AE3", "OS", "Dead") is ordered differently, i.e., v_names_states  <- c("OS", "AE1", "AE2", "AE3", "PFS", "Dead") when we matrix multiply costs and utilities by m_M_SoC  and m_M_Exp above we will be multiplying the utility of being in the progression free state u_F by the matrix of individuals in the OS state, which will clearly be a smaller number of individuals in the first few waves, and multiplying the utility of the OS state (u_P) by the larger number of individuals actually in the PFS state <- c("OS", "AE1", "AE2", "AE3", "PFS", "Dead"). We'll be doing the same thing with costs. What this will mean is more people getting the OS costs and OS utility and fewer people getting the PFS costs and the PFS utility, which will in turn have consequences for the cost-effectiveness analysis results with more OS costs and more OS utility being considered in the equation that compares costs and utilities.

# I've confirmed all of the things I say about by changing the ordering first of v_names_states, and then of the cost and utility concatenations. Changing the ordering of v_names_states did nothing to the CEA results or Tornado diagram provided I changed the ordering of utilities and costs to match this, changing the ordering of utilities and costs changed both unless I changed them to be in an order that matched the changed ordering of v_names_states.
```


```r
## General setup

# Here, I think about how time from individual patient data may be changed to match the time of our cycles.

# I think the digitiser (if I am using one) will give me the time in the context of the survival curves I am digitising, i.e., time in weeks, or time in months or time in years. Otherwise if I get the data directly from Ian it will also have time in the context of the existing survival curves.

# Then I will have to set-up my time accordingly in the R code so that my cycle length is at the same level as the individual patient data.

# That is, in Koen's example:

# C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\R Code\Parametric Survival Analysis\ISPOR WEBINAR Health Economic Modelling in R\ISPOR_webinar_R-master

# the data includes a column for the time (in years)
# t_cycle <- 1/4      # cycle length of 3 months (in years)                                # n_cycle <- 60       # number of cycles (total runtime 15 years)
  

# So I would have my colum for time, in the [TIME] the graph I was digitising/getting data from used.
# Then I would create my cycle length of X weeks (in [TIME] the graph I was digitising used)
# Then I would have my number of cycles that would add up to give me a total runtime of how long I want to run the model for.
# So, above Koen wanted to run the model for 15 years, but his cycles were in 3 months, or each cycle was a quarter of a year, so 60 quarters, or 60 3 month cycles, is 15 years.

# REALISE HERE THEAT P_PD ISNT THE PROBABILITY OF PROGRESSION TO DEAD, BUT OF PFS TO DEAD, OF FIRST LINE TO DEAD, BECAUSE OUR ANGIOPREDICT CURVES ONLY EVER DESCRIBE FIRST LINE TREATMENT, BE THAT FIRST LINE SOC TREATMENT OR FIRST LINE EXP TREATMENT.

# Here we define all our model parameters, so that we can call on these parameters later during our model:

t_cycle <- 14      # cycle length of 2 weeks (in [[days]] - this is assuming the survival curves I am digitising will be in [[days]] if they are in another period I will have to represent my cycle length in that period instead).                                  
n_cycle        <- 143                            
# We set the number of cycles to 143 to reflect 2,000 days from the Angiopredict study (5 Years, 5 Months, 3 Weeks, 1 Day) broken down into fortnightly cycles
v_names_cycles  <- paste("cycle", 0:n_cycle)    
# So here, we just name each cycle by the cycle its on, going from 0 up to the number of cycles there are, here 143
v_names_states  <- c("PFS", "OS", "Dead")  
# These are the health states in our model, PFS, OS, Death.
n_states        <- length(v_names_states)        
# We're just taking the number of health states from the number of names we came up with, i.e. the number of names to reflect the number of health states 

# Strategy names
v_names_strats     <- c("Standard of Care",         
                     "Experimental Treatment")
               # store the strategy names
n_str           <- length(v_names_strats)           
# number of strategies



# TRANSITION PROBABILITIES: Time-To-Transition - TTP:


# Time-dependent transition probabilities are obtained in four steps
# 1) Defining the cycle times
# 2) Obtaining the event-free (i.e. survival) probabilities for the cycle times for SoC
# 3) Obtaining the event-free (i.e. survival) probabilities for the cycle times for Exp based on a hazard ratio
# 4) Obtaining the time-dependent transition probabilities from the event-free (i.e. survival) probabilities

# 1) Defining the cycle times
(t <- seq(from = 0, by = t_cycle, length.out = n_cycle + 1))
```

```
##   [1]    0   14   28   42   56   70   84   98  112  126  140  154  168  182  196  210  224
##  [18]  238  252  266  280  294  308  322  336  350  364  378  392  406  420  434  448  462
##  [35]  476  490  504  518  532  546  560  574  588  602  616  630  644  658  672  686  700
##  [52]  714  728  742  756  770  784  798  812  826  840  854  868  882  896  910  924  938
##  [69]  952  966  980  994 1008 1022 1036 1050 1064 1078 1092 1106 1120 1134 1148 1162 1176
##  [86] 1190 1204 1218 1232 1246 1260 1274 1288 1302 1316 1330 1344 1358 1372 1386 1400 1414
## [103] 1428 1442 1456 1470 1484 1498 1512 1526 1540 1554 1568 1582 1596 1610 1624 1638 1652
## [120] 1666 1680 1694 1708 1722 1736 1750 1764 1778 1792 1806 1820 1834 1848 1862 1876 1890
## [137] 1904 1918 1932 1946 1960 1974 1988 2002
```

```r
# Here we're saying, at each cycle how many of the time periods our individual patient data is measured at have passed? Here our individual patient data is in days, so we have 0 in cycle 0, 14 (or two weeks) in cycle 1, and so on.

# Having established that allows us to obtain the transition probabilities for the time we are interested in for our cycles from this different period individual patient data, so where the individual patient data is in days and our cycles are in fortnight or half months, this allows us to obtain transition probabilities for these fortnights.

# 2) Obtaining the event-free (i.e. survival) probabilities for the cycle times for SoC
# S_FP_SoC - survival of progression free to progression, i.e. not going to progression, i.e. staying in progression free.
# Note that the coefficients [that we took from flexsurvreg earlier] need to be transformed to obtain the parameters that the base R function uses


S_FP_SoC <- pweibull(
  q     = t, 
  shape = exp(coef_weibull_shape_SoC), 
  scale = exp(coef_weibull_scale_SoC), 
  lower.tail = FALSE
)

head(cbind(t, S_FP_SoC))
```

```
##       t S_FP_SoC
## [1,]  0   1.0000
## [2,] 14   0.9852
## [3,] 28   0.9615
## [4,] 42   0.9333
## [5,] 56   0.9021
## [6,] 70   0.8689
```

```r
#        t  S_FP_SoC
# [1,] 0.0 1.0000000
# [2,] 0.5 0.9948214
# [3,] 1.0 0.9770661
# [4,] 1.5 0.9458256
# [5,] 2.0 0.9015175
# [6,] 2.5 0.8454597


# Having the above header shows that this is probability for surviving in the F->P state, i.e., staying in this state, because you can see in time 0 100% of people are in this state, meaning 100% of people hadnt progressed and were in PFS, if this was instead about the progressed state (i.e. OS), there should be no-one in this state when the model starts, as everyone starts in the PFS state, and it takes a while for people to reach the OS state.


# 3) Obtaining the event-free (i.e. survival) probabilities for the cycle times for Experimental treatment (aka the novel therapy) based on a hazard ratio.
# So here we basically have a hazard ratio for the novel therapy that says you do X much better under the novel therapy than under standard of care, and we want to apply it to standard of care from our individual patient data to see how much improved things would be under the novel therapy.
# (NB - if we ultimately decide not to use a hazard ratio, I could probably just create my transition probabilities for the experimental therapy from individual patient data that I have digitised from patients under this novel therapy).
# Here our hazard ratio is 0.68, I can change that hazard ratio if I need to in the future.
# - note that S(t) = exp(-H(t)) and, hence, H(t) = -ln(S(t))
# that is, the survival function is the expoential of the negative hazard function, per:
# https://faculty.washington.edu/yenchic/18W_425/Lec5_survival.pdf
# and: 
# https://web.stanford.edu/~lutian/coursepdf/unit1.pdf
# Also saved here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\R Code\Parametric Survival Analysis\flexsurv
# And to multiply by the hazard ratio it's necessary to convert the survivor function into the hazard function, multiply by the hazard ratio, and then convert back to the survivor function, and then these survivor functions are used for the probabilities.
HR_FP_Exp <- 0.68
H_FP_SoC  <- -log(S_FP_SoC)
H_FP_Exp  <- H_FP_SoC * HR_FP_Exp
S_FP_Exp  <- exp(-H_FP_Exp)

head(cbind(t, S_FP_SoC, H_FP_SoC, H_FP_Exp, S_FP_Exp))
```

```
##       t S_FP_SoC H_FP_SoC H_FP_Exp S_FP_Exp
## [1,]  0   1.0000  0.00000  0.00000   1.0000
## [2,] 14   0.9852  0.01496  0.01017   0.9899
## [3,] 28   0.9615  0.03925  0.02669   0.9737
## [4,] 42   0.9333  0.06901  0.04693   0.9542
## [5,] 56   0.9021  0.10299  0.07003   0.9324
## [6,] 70   0.8689  0.14049  0.09553   0.9089
```

```r
head(cbind(t, S_FP_SoC, H_FP_SoC))
```

```
##       t S_FP_SoC H_FP_SoC
## [1,]  0   1.0000  0.00000
## [2,] 14   0.9852  0.01496
## [3,] 28   0.9615  0.03925
## [4,] 42   0.9333  0.06901
## [5,] 56   0.9021  0.10299
## [6,] 70   0.8689  0.14049
```

```r
    # I want to vary my probabilities for the one-way sensitivity analysis, particularly for the tornado       plot of the deterministic sensitivity analysis. 
    
    # The problem here is that df_params_OWSA doesnt like the fact that a different probability for each       cycle (from the time-dependent transition probabilities) gives a large number of rows (say if there were 60 cycles,      two treatment strategies and a probability for each cycle we would see 122 rows). It wants the same number of       rows as      there are probabilities, i.e., it would prefer a probability of say 0.50 and then a max and a      min     around that.
    
    # To address this, I think I can apply this mean, max and min to the hazard ratios instead, knowing        that when run_owsa_det is run in the sensitivity analysis it calls the "oncologySemiMarkov_function" function to run and in this        function the hazard ratios generate the survivor function, and then these survivor functions are used      to generate the probabilities (which will be cycle dependent).
    
    # This is fine for the hazard ratio for the experimental strategy, I can just take:
    
    # HR_FP_Exp as my mean, and:
    
    # Minimum_HR_FP_Exp <- HR_FP_Exp - 0.20*HR_FP_Exp
    # Maximum_HR_FP_Exp <- HR_FP_Exp + 0.20*HR_FP_Exp
    
    # For min and max.
    
# For standard of care there was no hazard ratio, because we took these values from the survival curves     directly, and didnt vary them by a hazard ratio, like we do above.
    
# To address this, I create a hazard ratio that is exactly one.
    
    # hazard ratio

    # A measure of how often a particular event happens in one group compared to how often it happens in       another group, over time. In cancer research, hazard ratios are often used in clinical trials to           measure survival at any point in time in a group of patients who have been given a specific treatment      compared to a control group given another treatment or a placebo. A hazard ratio of one means that         there is no difference in survival between the two groups. A hazard ratio of greater than one or less      than one means that survival was better in one of the groups. https://www.cancer.gov/publications/dictionaries/cancer-terms/def/hazard-ratio

    # Thus, I can have a hazard ratio where the baseline value of it gives you the survival curves, and        thus the probabilities, from the actual survival curves we are drawing from, and where the min and max     will be 1 +/- 0.20, which will give us probabilities that are 20% higher or lower than the probabilities from the actual survival curves that we are drawing from in the parametric survival analysis to get transitions under standard of care.
    
    # To do this, I just have to add a hazard ratio to the code that creates the transition probabilities      under standard of care as below, then I can add that hazard ratio, and it's max and min, to the            deterministic sensitivity analysis and vary all the probabilities by 20%.
        

    # So here we basically have a hazard ratio that is equal to 1, so it leaves things unchanged for           patients, and we want to apply it to standard of care from our individual patient data to leave things     unchanged in this function, but allow things to change in the sensitivity analysis lower down.
      
    # Here our hazard ratio is 1, things are unchanged.

# So, first we create our hazard ratio == 1
HR_FP_SoC <- 1

# (I'm creating the below as new parameters, i.e. putting "nu" infront of them, in case keeping the name the same causes a problem for when I want to use them in the deterministic sensivity analysis, i.e., if I generate a parameter from itself - say var_name = var_name exactly, then there may be some way in which R handles code that won't let this work, or will take one parameter before the other, or something and stop the model from executing correctly).

# Then, we create our hazard function for SoC:
NU_S_FP_SoC <- S_FP_SoC
NU_H_FP_SoC  <- -log(NU_S_FP_SoC)
# Then, we multiply this hazard function by our hazard ratio, which is just 1, but which gives us the      opportunity to apply a hazard ratio to standard of care in our code and thus to have a hazard ratio for     standard of care for our one way deterministic sensitivity analysis and tornado diagram lower down in our code:
NUnu_H_FP_SoC  <- NU_H_FP_SoC * HR_FP_SoC
# Again, I was worried that with overlap when creating parameters I would have a problem with the deterministic sensivity analysis so I call it NU again to make it a "new" parameter again.
NU_S_FP_SoC  <- exp(-NUnu_H_FP_SoC)

head(cbind(t, NU_S_FP_SoC, NUnu_H_FP_SoC))
```

```
##       t NU_S_FP_SoC NUnu_H_FP_SoC
## [1,]  0      1.0000       0.00000
## [2,] 14      0.9852       0.01496
## [3,] 28      0.9615       0.03925
## [4,] 42      0.9333       0.06901
## [5,] 56      0.9021       0.10299
## [6,] 70      0.8689       0.14049
```

```r
# NU_H_FP_SoC  <- -log(NU_S_FP_SoC)
# # Then, we multiply this hazard function by our hazard ratio, which is just 1, but which gives us the      opportunity to apply a hazard ratio to standard of care in our code and thus to have a hazard ratio for     standard of care for our one way deterministic sensitivity analysis and tornado diagram.
# NU_H_FP_SoC  <- NU_H_FP_SoC * HR_FP_SoC
# # 
# NU_S_FP_SoC  <- exp(-NU_H_FP_SoC)
# 
# head(cbind(t, NU_S_FP_SoC, NU_H_FP_SoC))












# 4) Obtaining the time-dependent transition probabilities from the event-free (i.e. survival) probabilities

# Now we can take the probability of being in the PFS state at each of our cycles, as created above, from 100% (i.e. from 1) in order to get the probability of NOT being in the PFS state, i.e. in order to get the probability of moving into the progressed state, i.e. the OS state.
 
p_PFSOS_SoC <- p_PFSOS_Exp <- rep(NA, n_cycle)

# First we make the probability of going from progression-free (F) to progression (P) blank (i.e. NA) for all the cycles in standard of care and all the cycles under the experimental strategy.

for(i in 1:n_cycle) {
  p_PFSOS_SoC[i] <- 1 - NU_S_FP_SoC[i+1] /  NU_S_FP_SoC[i]
  p_PFSOS_Exp[i] <- 1 - S_FP_Exp[i+1] / S_FP_Exp[i]
}




# If I ever wanted to round my probabilities to 2 decimal places, I can do this as below, but this code actually makes probabilities that sum perfectly to 1, so there's no need to do this.

# round(p_PFSOS_SoC, digits=2)
# round(p_PFSOS_Exp, digits=2)




# Then we generate our transition probability under standard of care and under the experimental treatement using survival functions that havent and have had the hazard ratio from above applied to them, respectively.


# The way this works is the below, you take next cycles probability of staying in this state, divide it by this cycles probability of staying in this state, and take it from 1 to get the probability of leaving this state. 

# > head(cbind(t, S_FP_SoC))
#        t  S_FP_SoC
# [1,] 0.0 1.0000000
# [2,] 0.5 0.9948214
# [3,] 1.0 0.9770661
# [4,] 1.5 0.9458256
# [5,] 2.0 0.9015175
# [6,] 2.5 0.8454597
# > 1-0.9948214/1.0000000
# [1] 0.0051786
# > 0.9770661/0.9948214
# [1] 0.9821523
# > 1-0.9821523
# [1] 0.0178477

# p_FP_SoC
p_PFSOS_SoC
```

```
##   [1] 0.01485 0.02400 0.02932 0.03341 0.03681 0.03977 0.04240 0.04479 0.04699 0.04903
##  [11] 0.05095 0.05274 0.05445 0.05607 0.05761 0.05909 0.06051 0.06188 0.06320 0.06447
##  [21] 0.06570 0.06690 0.06806 0.06919 0.07028 0.07135 0.07240 0.07341 0.07441 0.07538
##  [31] 0.07633 0.07727 0.07818 0.07908 0.07995 0.08082 0.08166 0.08250 0.08331 0.08412
##  [41] 0.08491 0.08569 0.08646 0.08721 0.08796 0.08869 0.08941 0.09013 0.09083 0.09153
##  [51] 0.09221 0.09289 0.09356 0.09422 0.09487 0.09552 0.09615 0.09678 0.09741 0.09802
##  [61] 0.09863 0.09923 0.09983 0.10042 0.10100 0.10158 0.10216 0.10272 0.10328 0.10384
##  [71] 0.10439 0.10494 0.10548 0.10602 0.10655 0.10707 0.10760 0.10811 0.10863 0.10914
##  [81] 0.10964 0.11014 0.11064 0.11113 0.11162 0.11211 0.11259 0.11307 0.11354 0.11401
##  [91] 0.11448 0.11495 0.11541 0.11587 0.11632 0.11677 0.11722 0.11766 0.11811 0.11855
## [101] 0.11898 0.11942 0.11985 0.12028 0.12070 0.12112 0.12154 0.12196 0.12238 0.12279
## [111] 0.12320 0.12361 0.12401 0.12441 0.12481 0.12521 0.12561 0.12600 0.12639 0.12678
## [121] 0.12717 0.12755 0.12794 0.12832 0.12869 0.12907 0.12945 0.12982 0.13019 0.13056
## [131] 0.13093 0.13129 0.13165 0.13202 0.13238 0.13273 0.13309 0.13344 0.13380 0.13415
## [141] 0.13450 0.13484 0.13519
```

```r
#> p_FP_SoC
#  [1] 0.005178566 0.017847796 0.031973721 0.046845943 0.062181645
#p_FP_Exp
p_PFSOS_Exp
```

```
##   [1] 0.01012 0.01638 0.02003 0.02284 0.02518 0.02722 0.02903 0.03068 0.03220 0.03361
##  [11] 0.03493 0.03618 0.03735 0.03848 0.03955 0.04057 0.04156 0.04251 0.04342 0.04430
##  [21] 0.04516 0.04599 0.04680 0.04758 0.04835 0.04909 0.04982 0.05053 0.05122 0.05190
##  [31] 0.05256 0.05321 0.05385 0.05448 0.05509 0.05569 0.05628 0.05687 0.05744 0.05800
##  [41] 0.05855 0.05910 0.05964 0.06017 0.06069 0.06120 0.06171 0.06221 0.06270 0.06319
##  [51] 0.06367 0.06414 0.06461 0.06508 0.06553 0.06599 0.06643 0.06688 0.06731 0.06775
##  [61] 0.06818 0.06860 0.06902 0.06943 0.06985 0.07025 0.07066 0.07105 0.07145 0.07184
##  [71] 0.07223 0.07261 0.07300 0.07337 0.07375 0.07412 0.07449 0.07485 0.07522 0.07558
##  [81] 0.07593 0.07629 0.07664 0.07699 0.07733 0.07767 0.07801 0.07835 0.07869 0.07902
##  [91] 0.07935 0.07968 0.08001 0.08033 0.08065 0.08097 0.08129 0.08160 0.08192 0.08223
## [101] 0.08254 0.08284 0.08315 0.08345 0.08375 0.08405 0.08435 0.08465 0.08494 0.08523
## [111] 0.08552 0.08581 0.08610 0.08638 0.08667 0.08695 0.08723 0.08751 0.08779 0.08807
## [121] 0.08834 0.08861 0.08889 0.08916 0.08942 0.08969 0.08996 0.09022 0.09049 0.09075
## [131] 0.09101 0.09127 0.09153 0.09179 0.09204 0.09230 0.09255 0.09280 0.09305 0.09330
## [141] 0.09355 0.09380 0.09405
```

```r
# TRANSITION PROBABILITIES: Time-To-Dead TTD

# [[I basically re-tread what I did for TTP so feel free just to skim this]]

# REALISE HERE THEAT P_PD ISNT THE PROBABILITY OF PROGRESSION TO DEAD, BUT OF PFS TO DEAD, OF FIRST LINE TO DEAD, BECAUSE OUR ANGIOPREDICT CURVES ONLY EVER DESCRIBE FIRST LINE TREATMENT, BE THAT FIRST LINE SOC TREATMENT OR FIRST LINE EXP TREATMENT.


# To make sure that my PFS probabilities only reflect going from PFS to progression, I create the probability of going from PFS to DEAD under standard of care and the experimental, and decrease my PFS to progression probability created above by the probability of going into the dead state, such that I am only capturing people going into progression, and not people going into death as well.

# So, first I create the transition probabilities of progression free into dead for SoC and Exp, then I convert all the probabilities (i.e. those for PFS and those for OS) into rates, minus them from eachother, turn them back into probabilities, and make sure none are negative (and where they are replace these with 0).

# Actually, I don't do the rates thing, I just I take all the probabilities (i.e. those for PFS and those for OS), minus them from eachother.

# (ACTUALLY, I'm leaving this here for now, but ultimately I decided against doing any of the above, given a comment made by Joshua in email).



# Time-dependent transition probabilities are obtained in four steps
# 1) Defining the cycle times [we already did this above]
# 2) Obtaining the event-free (i.e. overall survival) probabilities for the cycle times for SoC
# 3) Obtaining the event-free (i.e. overall survival) probabilities for the cycle times for Exp based on a hazard ratio
# 4) Obtaining the time-dependent transition probabilities from the event-free (i.e. overall survival) probabilities

# 1) Defining the cycle times
(t <- seq(from = 0, by = t_cycle, length.out = n_cycle + 1))
```

```
##   [1]    0   14   28   42   56   70   84   98  112  126  140  154  168  182  196  210  224
##  [18]  238  252  266  280  294  308  322  336  350  364  378  392  406  420  434  448  462
##  [35]  476  490  504  518  532  546  560  574  588  602  616  630  644  658  672  686  700
##  [52]  714  728  742  756  770  784  798  812  826  840  854  868  882  896  910  924  938
##  [69]  952  966  980  994 1008 1022 1036 1050 1064 1078 1092 1106 1120 1134 1148 1162 1176
##  [86] 1190 1204 1218 1232 1246 1260 1274 1288 1302 1316 1330 1344 1358 1372 1386 1400 1414
## [103] 1428 1442 1456 1470 1484 1498 1512 1526 1540 1554 1568 1582 1596 1610 1624 1638 1652
## [120] 1666 1680 1694 1708 1722 1736 1750 1764 1778 1792 1806 1820 1834 1848 1862 1876 1890
## [137] 1904 1918 1932 1946 1960 1974 1988 2002
```

```r
# 2) Obtaining the event-free (i.e. overall survival) probabilities for the cycle times for SoC
# S_PD_SoC - survival of progression free to dead, i.e. not going to dead, i.e. staying in that first progression free state.
# Note that the coefficients [that we took from flexsurvreg earlier] need to be transformed to obtain the parameters that the base R function uses


S_PD_SoC <- pweibull(
  q     = t, 
  shape = exp(coef_TTD_weibull_shape_SoC), 
  scale = exp(coef_TTD_weibull_scale_SoC), 
  lower.tail = FALSE
)

head(cbind(t, S_PD_SoC))
```

```
##       t S_PD_SoC
## [1,]  0   1.0000
## [2,] 14   0.9953
## [3,] 28   0.9880
## [4,] 42   0.9793
## [5,] 56   0.9697
## [6,] 70   0.9592
```

```r
# Having the above header shows that this is probability for surviving in the PFS->D state, i.e., staying in this state, because you should see in time 0 0% of people are in this state, meaning 100% of people hadnt gone into the dead state and were in PFS, which make sense in this model, the model starts with everyone in PFS, no-one starts the model in dead, and it takes a while for people to reach the dead state.


# 3) Obtaining the event-free (i.e. overall survival) probabilities for the cycle times for Experimental treatment (aka the novel therapy) based on a hazard ratio.
# So here we basically have a hazard ratio for the novel therapy that says you do X much better under the novel therapy than under standard of care, and we want to apply it to standard of care from our individual patient data to see how much improved things would be under the novel therapy.

# Here our hazard ratio is 0.65, I can change that hazard ratio if necessary.
# - note that S(t) = exp(-H(t)) and, hence, H(t) = -ln(S(t))
# that is, the survival function is the expoential of the negative hazard function, per:
# https://faculty.washington.edu/yenchic/18W_425/Lec5_survival.pdf
# and: 
# https://web.stanford.edu/~lutian/coursepdf/unit1.pdf
# Also saved here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\R Code\Parametric Survival Analysis\flexsurv
# And to multiply by the hazard ratio it's necessary to convert the survivor function into the hazard function, multiply by the hazard ratio, and then convert back to the survivor function, and then these survivor functions are used for the probabilities.
HR_PD_Exp <- 0.65
H_PD_SoC  <- -log(S_PD_SoC)
H_PD_Exp  <- H_PD_SoC * HR_PD_Exp
S_PD_Exp  <- exp(-H_PD_Exp)

head(cbind(t, S_PD_SoC, H_PD_SoC, H_PD_Exp, S_PD_Exp))
```

```
##       t S_PD_SoC H_PD_SoC H_PD_Exp S_PD_Exp
## [1,]  0   1.0000  0.00000 0.000000   1.0000
## [2,] 14   0.9953  0.00472 0.003068   0.9969
## [3,] 28   0.9880  0.01206 0.007836   0.9922
## [4,] 42   0.9793  0.02087 0.013564   0.9865
## [5,] 56   0.9697  0.03080 0.020018   0.9802
## [6,] 70   0.9592  0.04165 0.027073   0.9733
```

```r
# I want to vary my probabilities for the one-way sensitivity analysis, particularly for the tornado       plot of the deterministic sensitivity analysis. 

# The problem here is that df_params_OWSA doesnt like the fact that a different probability for each       cycle (from the time-dependent transition probabilities) gives many rows (say there are 60 cycles,      two treatment strategies and a probability for each cycle would give 122 rows). It wants the same number of       rows as      there are probabilities, i.e., it would prefer a probability of say 0.50 and then a max and a      min     around that.

# To address this, I think I can apply this mean, max and min to the hazard ratios instead, knowing        that when run_owsa_det is run in the sensitivity analysis it calls this function to run and in this        function the hazard ratios generate the survivor function, and then these survivor functions are used      to generate the probabilities (which will be cycle dependent).

# This is fine for the hazard ratio for the experimental strategy, I can just take:

# HR_PD_Exp as my mean, and:

# Minimum_HR_PD_Exp <- HR_PD_Exp - 0.20*HR_PD_Exp
# Maximum_HR_PD_Exp <- HR_PD_Exp + 0.20*HR_PD_Exp

# For min and max.

# For standard of care there was no hazard ratio, because we took these values from the survival curves     directly, and didnt vary them by a hazard ratio, like we do above.

# To address this, I create a hazard ratio that is exactly one.

# hazard ratio

# A measure of how often a particular event happens in one group compared to how often it happens in       another group, over time. In cancer research, hazard ratios are often used in clinical trials to           measure survival at any point in time in a group of patients who have been given a specific treatment      compared to a control group given another treatment or a placebo. A hazard ratio of one means that         there is no difference in survival between the two groups. A hazard ratio of greater than one or less      than one means that survival was better in one of the groups. https://www.cancer.gov/publications/dictionaries/cancer-terms/def/hazard-ratio

# Thus, I can have a hazard ratio where the baseline value of it gives you the survival curves, and        thus the probabilities, from the actual survival curves we are drawing from, and where the min and max     will be 1 +/- 0.20, which will give us probabilities that are 20% higher or lower than the probabilities from the actual survival curves that we are drawing from in the parametric survival analysis to get transitions under standard of care.

# To do this, I just have to add a hazard ratio to the code that creates the transition probabilities      under standard of care as below, then I can add that hazard ratio, and it's max and min, to the            deterministic sensitivity analysis and vary all the probabilities by 20%.


# So here we basically have a hazard ratio that is equal to 1, so it leaves things unchanged for           patients, and we want to apply it to standard of care from our individual patient data to leave things     unchanged in this function, but allow things to change in the sensitivity analysis.

# Here our hazard ratio is 1, things are unchanged.

# So, first we create our hazard ratio == 1
HR_PD_SoC <- 1

# (I'm creating the below as new parameters, i.e. putting "nu" infront of them, in case keeping the name the same causes a problem for when I want to use them in the deterministic sensivity analysis, i.e., if I generate a parameter from itself - say var_name = var_name exactly, then there may be some way in which R handles code that won't let this work, or will take one parameter before the other, or something and stop the model from executing correctly).

# Then, we create our hazard function for SoC:
NU_S_PD_SoC <- S_PD_SoC
NU_H_PD_SoC  <- -log(NU_S_PD_SoC)
# Then, we multiply this hazard function by our hazard ratio, which is just 1, but which gives us the      opportunity to apply a hazard ratio to standard of care in our code and thus to have a hazard ratio for     standard of care for our one way deterministic sensitivity analysis and tornado diagram.
NUnu_H_PD_SoC  <- NU_H_PD_SoC * HR_PD_SoC
# Again, I was worried that with overlap when creating parameters I would have a problem with the deterministic sensivity analysis so I call it NU again to make it a "new" parameter again.
NU_S_PD_SoC  <- exp(-NUnu_H_PD_SoC)

head(cbind(t, NU_S_PD_SoC, NUnu_H_PD_SoC))
```

```
##       t NU_S_PD_SoC NUnu_H_PD_SoC
## [1,]  0      1.0000       0.00000
## [2,] 14      0.9953       0.00472
## [3,] 28      0.9880       0.01206
## [4,] 42      0.9793       0.02087
## [5,] 56      0.9697       0.03080
## [6,] 70      0.9592       0.04165
```

```r
# NU_H_PD_SoC  <- -log(NU_S_PD_SoC)
# # Then, we multiply this hazard function by our hazard ratio, which is just 1, but which gives us the      opportunity to apply a hazard ratio to standard of care in our code and thus to have a hazard ratio for     standard of care for our one way deterministic sensitivity analysis and tornado diagram.
# NU_H_PD_SoC  <- NU_H_PD_SoC * HR_PD_SoC
# # 
# NU_S_PD_SoC  <- exp(-NU_H_PD_SoC)
# 
# head(cbind(t, NU_S_PD_SoC, NU_H_PD_SoC))


# 4) Obtaining the time-dependent transition probabilities from the event-free (i.e. survival) probabilities

# Now we can take the probability of being in the PFS state at each of our cycles, as created above, from 100% (i.e. from 1) in order to get the probability of NOT being in the PFS state, i.e. in order to get the probability of moving into the progressed state, or the OS state.


p_PFSD_SoC <- p_PFSD_Exp <- rep(NA, n_cycle)

# First we make the probability of going from progression-free (F) to progressed to dead (D) blank (i.e. NA) for all the cycles in standard of care and all the cycles under the experimental strategy.

for(i in 1:n_cycle) {
  p_PFSD_SoC[i] <- 1 - NU_S_PD_SoC[i+1] / NU_S_PD_SoC[i]
  p_PFSD_Exp[i] <- 1 - S_PD_Exp[i+1] / S_PD_Exp[i]
}

# round(p_PFSD_SoC, digits=2)
# round(p_PFSD_Exp, digits=2)
# If I wanted to round I could apply the above, but my code already rounds my numbers.

# Then we generate our transition probability under standard of care and under the experimental treatement using survival functions that havent and have had the hazard ratio from above applied to them, respectively. [If we decide not to apply a hazard ratio for the experimental strategy going from progression to dead then neither may have a hazard ratio applied to them].


# The way this works is, you take next cycles probability of staying in this state, divide it by this cycles probability of staying in this state, and take it from 1 to get the probability of leaving this state. 

p_PFSD_SoC
```

```
##   [1] 0.004708 0.007310 0.008772 0.009881 0.010796 0.011585 0.012286 0.012919 0.013499
##  [10] 0.014036 0.014538 0.015009 0.015454 0.015876 0.016279 0.016663 0.017032 0.017387
##  [19] 0.017728 0.018058 0.018376 0.018685 0.018984 0.019275 0.019558 0.019834 0.020102
##  [28] 0.020364 0.020620 0.020870 0.021114 0.021353 0.021588 0.021817 0.022043 0.022264
##  [37] 0.022480 0.022694 0.022903 0.023109 0.023311 0.023510 0.023707 0.023900 0.024090
##  [46] 0.024277 0.024462 0.024644 0.024824 0.025001 0.025176 0.025349 0.025519 0.025687
##  [55] 0.025854 0.026018 0.026180 0.026341 0.026500 0.026656 0.026812 0.026965 0.027117
##  [64] 0.027267 0.027416 0.027563 0.027709 0.027853 0.027996 0.028138 0.028278 0.028417
##  [73] 0.028555 0.028691 0.028826 0.028960 0.029093 0.029225 0.029356 0.029485 0.029614
##  [82] 0.029741 0.029867 0.029993 0.030117 0.030241 0.030363 0.030485 0.030605 0.030725
##  [91] 0.030844 0.030962 0.031079 0.031195 0.031311 0.031426 0.031540 0.031653 0.031765
## [100] 0.031877 0.031988 0.032098 0.032207 0.032316 0.032424 0.032532 0.032638 0.032744
## [109] 0.032850 0.032955 0.033059 0.033162 0.033265 0.033368 0.033469 0.033570 0.033671
## [118] 0.033771 0.033870 0.033969 0.034068 0.034166 0.034263 0.034360 0.034456 0.034552
## [127] 0.034647 0.034742 0.034836 0.034930 0.035023 0.035116 0.035208 0.035300 0.035392
## [136] 0.035483 0.035573 0.035663 0.035753 0.035842 0.035931 0.036019 0.036107
```

```r
p_PFSD_Exp
```

```
##   [1] 0.003063 0.004757 0.005711 0.006434 0.007030 0.007546 0.008003 0.008417 0.008795
##  [10] 0.009146 0.009474 0.009782 0.010072 0.010349 0.010612 0.010863 0.011104 0.011336
##  [19] 0.011559 0.011775 0.011983 0.012185 0.012381 0.012572 0.012757 0.012937 0.013113
##  [28] 0.013284 0.013452 0.013615 0.013775 0.013932 0.014086 0.014236 0.014383 0.014528
##  [37] 0.014670 0.014810 0.014947 0.015082 0.015215 0.015345 0.015474 0.015600 0.015725
##  [46] 0.015848 0.015969 0.016089 0.016206 0.016323 0.016437 0.016551 0.016662 0.016773
##  [55] 0.016882 0.016990 0.017096 0.017201 0.017306 0.017408 0.017510 0.017611 0.017711
##  [64] 0.017809 0.017907 0.018004 0.018099 0.018194 0.018288 0.018381 0.018473 0.018564
##  [73] 0.018655 0.018744 0.018833 0.018921 0.019008 0.019095 0.019180 0.019266 0.019350
##  [82] 0.019434 0.019517 0.019599 0.019681 0.019762 0.019842 0.019922 0.020001 0.020080
##  [91] 0.020158 0.020236 0.020313 0.020389 0.020465 0.020541 0.020615 0.020690 0.020764
## [100] 0.020837 0.020910 0.020982 0.021054 0.021126 0.021197 0.021268 0.021338 0.021408
## [109] 0.021477 0.021546 0.021614 0.021682 0.021750 0.021817 0.021884 0.021951 0.022017
## [118] 0.022083 0.022148 0.022213 0.022278 0.022342 0.022406 0.022470 0.022534 0.022597
## [127] 0.022659 0.022722 0.022784 0.022845 0.022907 0.022968 0.023029 0.023089 0.023149
## [136] 0.023209 0.023269 0.023328 0.023387 0.023446 0.023504 0.023563 0.023621
```

```r
# Finally, now that I create transition probabilities from first-line treatment to death under SoC and the Exp treatment I can take them from the transition probabilities from first-line treatment to progression for SoC and Exp treatment, because the OS here from Angiopredict is transitioning from the first line treatment to dead, not from second line treatment to death, and once we get rid of the people who were leaving first line treatment to die in PFS, all we have left is people leaving first line treatment to progress. And then we can keep the first line treatment to death probabilities we've created from the OS curves to capture people who have left first line treatment to transition into death rather than second line treatment.

# p_PFSOS_SoC
# p_PFSD_SoC
# p_PFSOS_SoC <- p_PFSOS_SoC - p_PFSD_SoC
# p_PFSOS_SoC
# 
# p_PFSOS_Exp
# p_PFSD_Exp
# p_PFSOS_Exp <- p_PFSOS_Exp - p_PFSD_Exp
# p_PFSOS_Exp

# Actually, I decided not to do this, as then the curves I created wouldnt match the curves reported in the ANGIOPREDICT publication so exactly:


# Time-constant transition probabilities [ADVERSE EVENTS]:


# To create transition probabilities from exisiting probabilities in the literatre, etc., that come from longer time periods than my cycle lengths I can use the information in this email to Daniel:

# Inquiry re: Cost effectiveness analysis of pharmacokinetically-guided 5-fluorouracil in FOLFOX chemotherapy for metastatic colorectal cancer
# - https://outlook.office.com/mail/id/AAQkAGI5OWU0NTJkLTEzMjgtNGVhOS04ZGZiLWZkOGU1MDg3ZmE5MAAQAHQCBS2m%2B%2FVAjAc%2FWSCjQEQ%3D


# There may also be some relevant information in the below:


## Transition probabilities and hazard ratios


# "Note: To calculate the probability of dying from S1 and S2, use the hazard ratios provided. To do so, first convert the probability of dying from healthy, p_HD , to a rate; then multiply this rate by the appropriate hazard ratio; finally, convert this rate back to a probability. Recall that you can convert between rates and probabilities using the following formulas: r = − log(1 − p) and p = 1 − e ( − rt ) . The package darthtools also has the functions prob_to_rate and rate_to_prob that might be of use to you." per: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Cost-Effectiveness and Decision Modeling using R Workshop _ DARTH\August_25\3_cSTM - history dependence_material\Download exercise handout 

# ?rate_to_prob will tell you more about this function.
# ?prob_to_rate will tell you more about this function.

# You can see conversions from probabilities to rates here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Model Calibration in R\UNZIP to Working Directory_Calibration Participant Materials\ISPOR Calibration Participant Materials\SickSicker_MarkovModel_Function.R

# As will: Cost-Effectiveness and Decision Modeling using R Workshop _ DARTH - Live Session August 25th WITH CHAT

# The above also describes how to convert probabilities for different time scales, i.e., convert a probability for 5 years to 1 year, etc., and how to convert data that exists as a rate to a probability for use in a Markov model.







 # The below reflects the probability of going to death in the second line treatment, and I make the assumption that everyone gets the same second line treatment and give them the same probability after being under exp and under SoC to go from the second line therapy into dead.

P_OSD_SoC   <- 0.17 # Probability of dying when in OS.
P_OSD_Exp   <- 0.17 # Probability of dying when in OS.

# Base-Case: 0.17 Min: 0.12 Max:0.22 According to: Wen, F., Zheng, H., Wu, Y., Wheeler, J., Zeng, X., Fu, P., & Li, Q. (2016). Cost-effectiveness Analysis of Fluorouracil, Leucovorin, and Irinotecan versus Epirubicin, Cisplatin, and Capecitabine in Patients with Advanced Gastric Adenocarcinoma. Scientific reports, 6(1), 1-8. 



## Health State Values (AKA State rewards)
# Costs and utilities  
# Basically the outcomes we are interested in coming out of this model, so we'll look at the cohorts costs over the time horizon and the quality adjusted life years in our cohort over this time horizon.

# Costs

# The costs are a particularly important part of the model, because these are the only things that differ between countries. We make the assumption, per the literature and pragmatically (because we are examining 3 different countries at once in this model), that utilities and incidence of adverse events are generalisable across countries.

# So, the best way to deal with needing 3 different sets of costs, one for each country, is likely to create a concatanated vector, where the first set of entries refers to Ireland, the second set refers to Germany and the third set refers to Spain, then when we are building a diagram or doing some analysis in the model we can have c_F_SoC[1], c_F_Exp[1] and c_P[1], referring to Ireland, and so on for Spain[3] and Germany[2].

# Ireland[1]
# Germany[2]
#Spain[3]



# I pursued this avenue and it was too complicated, so instead I just define the parameters that vary in the Rmarkdown file that calls this file.

# Basically, what I do is set these parameters equal to the costs for the country I am interested in, in the Markdown file that calls this file, and then run this current file with the parameter names from the Rmarkdown file subbed in for costs and other country-specific values. Then I repeat this for each country I am interested in. 

c_PFS_Folfox <- c_PFS_Folfox 
c_PFS_Bevacizumab <- c_PFS_Bevacizumab  
c_OS_Folfiri <- c_OS_Folfiri  
administration_cost <- administration_cost  


c_F_SoC       <- administration_cost + c_PFS_Folfox  # cost of one cycle in PFS state under standard of care
c_F_Exp       <- administration_cost + c_PFS_Folfox + c_PFS_Bevacizumab # cost of one cycle in PFS state under the experimental treatment 
c_P       <- c_OS_Folfiri  + administration_cost# cost of one cycle in progression state (I assume in OS everyone gets the same treatment so it costs everyone the same to be treated).
c_D       <- 0     # cost of one cycle in dead state



# Above is the cost for each state, PFS, OS and dead,

# Then we define the utilities per health states.


u_F       <- 0.850     # utility when PFS 
u_P       <- 0.650   # utility when OS
u_D       <- 0     # utility when dead

# Discounting factors
d_c             <- 0.04                          
# discount rate for costs (per year)
d_e             <- 0.04                          
# discount rate for QALYs (per year)

# Discount weight (equal discounting is assumed for costs and effects):

# v_dwc <- 1 / (1 + d_c) ^ (0:n_cycle) 
# v_dwe <- 1 / (1 + d_e) ^ (0:n_cycle) 

# This was my initial discount weight vector, but, I've updated this and do this later on now 

p_PFSD_SoC
```

```
##   [1] 0.004708 0.007310 0.008772 0.009881 0.010796 0.011585 0.012286 0.012919 0.013499
##  [10] 0.014036 0.014538 0.015009 0.015454 0.015876 0.016279 0.016663 0.017032 0.017387
##  [19] 0.017728 0.018058 0.018376 0.018685 0.018984 0.019275 0.019558 0.019834 0.020102
##  [28] 0.020364 0.020620 0.020870 0.021114 0.021353 0.021588 0.021817 0.022043 0.022264
##  [37] 0.022480 0.022694 0.022903 0.023109 0.023311 0.023510 0.023707 0.023900 0.024090
##  [46] 0.024277 0.024462 0.024644 0.024824 0.025001 0.025176 0.025349 0.025519 0.025687
##  [55] 0.025854 0.026018 0.026180 0.026341 0.026500 0.026656 0.026812 0.026965 0.027117
##  [64] 0.027267 0.027416 0.027563 0.027709 0.027853 0.027996 0.028138 0.028278 0.028417
##  [73] 0.028555 0.028691 0.028826 0.028960 0.029093 0.029225 0.029356 0.029485 0.029614
##  [82] 0.029741 0.029867 0.029993 0.030117 0.030241 0.030363 0.030485 0.030605 0.030725
##  [91] 0.030844 0.030962 0.031079 0.031195 0.031311 0.031426 0.031540 0.031653 0.031765
## [100] 0.031877 0.031988 0.032098 0.032207 0.032316 0.032424 0.032532 0.032638 0.032744
## [109] 0.032850 0.032955 0.033059 0.033162 0.033265 0.033368 0.033469 0.033570 0.033671
## [118] 0.033771 0.033870 0.033969 0.034068 0.034166 0.034263 0.034360 0.034456 0.034552
## [127] 0.034647 0.034742 0.034836 0.034930 0.035023 0.035116 0.035208 0.035300 0.035392
## [136] 0.035483 0.035573 0.035663 0.035753 0.035842 0.035931 0.036019 0.036107
```

```r
p_PFSD_Exp
```

```
##   [1] 0.003063 0.004757 0.005711 0.006434 0.007030 0.007546 0.008003 0.008417 0.008795
##  [10] 0.009146 0.009474 0.009782 0.010072 0.010349 0.010612 0.010863 0.011104 0.011336
##  [19] 0.011559 0.011775 0.011983 0.012185 0.012381 0.012572 0.012757 0.012937 0.013113
##  [28] 0.013284 0.013452 0.013615 0.013775 0.013932 0.014086 0.014236 0.014383 0.014528
##  [37] 0.014670 0.014810 0.014947 0.015082 0.015215 0.015345 0.015474 0.015600 0.015725
##  [46] 0.015848 0.015969 0.016089 0.016206 0.016323 0.016437 0.016551 0.016662 0.016773
##  [55] 0.016882 0.016990 0.017096 0.017201 0.017306 0.017408 0.017510 0.017611 0.017711
##  [64] 0.017809 0.017907 0.018004 0.018099 0.018194 0.018288 0.018381 0.018473 0.018564
##  [73] 0.018655 0.018744 0.018833 0.018921 0.019008 0.019095 0.019180 0.019266 0.019350
##  [82] 0.019434 0.019517 0.019599 0.019681 0.019762 0.019842 0.019922 0.020001 0.020080
##  [91] 0.020158 0.020236 0.020313 0.020389 0.020465 0.020541 0.020615 0.020690 0.020764
## [100] 0.020837 0.020910 0.020982 0.021054 0.021126 0.021197 0.021268 0.021338 0.021408
## [109] 0.021477 0.021546 0.021614 0.021682 0.021750 0.021817 0.021884 0.021951 0.022017
## [118] 0.022083 0.022148 0.022213 0.022278 0.022342 0.022406 0.022470 0.022534 0.022597
## [127] 0.022659 0.022722 0.022784 0.022845 0.022907 0.022968 0.023029 0.023089 0.023149
## [136] 0.023209 0.023269 0.023328 0.023387 0.023446 0.023504 0.023563 0.023621
```

```r
p_PFSOS_SoC
```

```
##   [1] 0.01485 0.02400 0.02932 0.03341 0.03681 0.03977 0.04240 0.04479 0.04699 0.04903
##  [11] 0.05095 0.05274 0.05445 0.05607 0.05761 0.05909 0.06051 0.06188 0.06320 0.06447
##  [21] 0.06570 0.06690 0.06806 0.06919 0.07028 0.07135 0.07240 0.07341 0.07441 0.07538
##  [31] 0.07633 0.07727 0.07818 0.07908 0.07995 0.08082 0.08166 0.08250 0.08331 0.08412
##  [41] 0.08491 0.08569 0.08646 0.08721 0.08796 0.08869 0.08941 0.09013 0.09083 0.09153
##  [51] 0.09221 0.09289 0.09356 0.09422 0.09487 0.09552 0.09615 0.09678 0.09741 0.09802
##  [61] 0.09863 0.09923 0.09983 0.10042 0.10100 0.10158 0.10216 0.10272 0.10328 0.10384
##  [71] 0.10439 0.10494 0.10548 0.10602 0.10655 0.10707 0.10760 0.10811 0.10863 0.10914
##  [81] 0.10964 0.11014 0.11064 0.11113 0.11162 0.11211 0.11259 0.11307 0.11354 0.11401
##  [91] 0.11448 0.11495 0.11541 0.11587 0.11632 0.11677 0.11722 0.11766 0.11811 0.11855
## [101] 0.11898 0.11942 0.11985 0.12028 0.12070 0.12112 0.12154 0.12196 0.12238 0.12279
## [111] 0.12320 0.12361 0.12401 0.12441 0.12481 0.12521 0.12561 0.12600 0.12639 0.12678
## [121] 0.12717 0.12755 0.12794 0.12832 0.12869 0.12907 0.12945 0.12982 0.13019 0.13056
## [131] 0.13093 0.13129 0.13165 0.13202 0.13238 0.13273 0.13309 0.13344 0.13380 0.13415
## [141] 0.13450 0.13484 0.13519
```

```r
p_PFSOS_Exp
```

```
##   [1] 0.01012 0.01638 0.02003 0.02284 0.02518 0.02722 0.02903 0.03068 0.03220 0.03361
##  [11] 0.03493 0.03618 0.03735 0.03848 0.03955 0.04057 0.04156 0.04251 0.04342 0.04430
##  [21] 0.04516 0.04599 0.04680 0.04758 0.04835 0.04909 0.04982 0.05053 0.05122 0.05190
##  [31] 0.05256 0.05321 0.05385 0.05448 0.05509 0.05569 0.05628 0.05687 0.05744 0.05800
##  [41] 0.05855 0.05910 0.05964 0.06017 0.06069 0.06120 0.06171 0.06221 0.06270 0.06319
##  [51] 0.06367 0.06414 0.06461 0.06508 0.06553 0.06599 0.06643 0.06688 0.06731 0.06775
##  [61] 0.06818 0.06860 0.06902 0.06943 0.06985 0.07025 0.07066 0.07105 0.07145 0.07184
##  [71] 0.07223 0.07261 0.07300 0.07337 0.07375 0.07412 0.07449 0.07485 0.07522 0.07558
##  [81] 0.07593 0.07629 0.07664 0.07699 0.07733 0.07767 0.07801 0.07835 0.07869 0.07902
##  [91] 0.07935 0.07968 0.08001 0.08033 0.08065 0.08097 0.08129 0.08160 0.08192 0.08223
## [101] 0.08254 0.08284 0.08315 0.08345 0.08375 0.08405 0.08435 0.08465 0.08494 0.08523
## [111] 0.08552 0.08581 0.08610 0.08638 0.08667 0.08695 0.08723 0.08751 0.08779 0.08807
## [121] 0.08834 0.08861 0.08889 0.08916 0.08942 0.08969 0.08996 0.09022 0.09049 0.09075
## [131] 0.09101 0.09127 0.09153 0.09179 0.09204 0.09230 0.09255 0.09280 0.09305 0.09330
## [141] 0.09355 0.09380 0.09405
```


```r
#Draw the state-transition cohort model

diag_names_states  <- c("PFS", "OS", "Dead")

m_P_diag <- matrix(0, nrow = n_states, ncol = n_states, dimnames = list(diag_names_states, diag_names_states))

m_P_diag["PFS", "PFS" ]  = ""
m_P_diag["PFS", "OS" ]     = ""
m_P_diag["PFS", "Dead" ]     = ""
m_P_diag["OS", "OS" ]     = ""
m_P_diag["OS", "Dead" ]     = ""
m_P_diag["Dead", "Dead" ]     = ""
layout.fig <- c(2, 1) # <- changing the numbers here changes the diagram layout, so mess with these until I'm happy. It basically decides how many bubbles will be on each level, so here 1 bubble, followed by 3 bubbles, followed by 2 bubbles, per the diagram for 1, 3, 2.
plotmat(t(m_P_diag), t(layout.fig), self.cex = 0.5, curve = 0, arr.pos = 0.76,
        latex = T, arr.type = "curved", relsize = 0.85, box.prop = 0.9,
        cex = 0.8, box.cex = 0.7, lwd = 0.6, main = "Figure 1")
```

<img src="Markov_3state_files/figure-html/unnamed-chunk-20-1.png" width="672" />

```r
#ggsave("Markov_Model_Diagram.png", width = 4, height = 4, dpi=300)
#while (!is.null(dev.list()))  dev.off()
#png(paste("Markov_Model_Diagram", ".png"))
#dev.off()
```


```r
#04 Define and initialize matrices and vectors

#04.1 Cohort trace


# After setting up our parameters above, we initialise our structure below.

# This is where we will store all of the model output, and all the things that we need to track over time as we are simulating the progression of this cohort through this disease process.

# WHEN COMING BACK TO COMPARE: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\R Code\Parametric Survival Analysis\ISPOR WEBINAR Health Economic Modelling in R\ISPOR_webinar_R-master\ISPOR_webinar_R-master\oncologySemiMarkov_illustration to the DARTH Rmarkdown document, a big difference is that DARTH creates a cycle 0 - whereas the comparison from the ISPOR_webinar_R uses -1 to get into cycle 0 where necessary. I have decided to follow the ISPOR way, because I am interested in learning from their parametric analysis, so I need to bear this difference in mind as I go through this document.

# Markov cohort trace matrix ----

# Initialize matrices to store the Markov cohort traces for each strategy

# - note that the number of rows is n_cycle + 1, because R doesn't use index 0 (i.e. cycle 0)  --> What we mean here, is that when we do our calculations later they need to be for cycle-1 to reflect cycle 0.
m_M_SoC <- m_M_Exp  <-  matrix(
  data = NA, 
  nrow = n_cycle,  
  ncol = n_states, 
  dimnames = list(paste('Cycle', 1:n_cycle), v_names_states)
)

## Initial state vector
# We create an inital vector where people start, with everyone (1 = 100% of people) starting in PFS below:
# v_s_init <- c("PFS" = 1, "OS" = 0, "Dead" = 0)
# v_s_init

# There are cases where you can have an initial illness prevalence, so you would start some people in the sick state and some people in the healthy state, but above we're looking at people with mCRC, so we'll start everyone in PFS.


## Initialize cohort trace for cSTM (cohort state transition model) for all strategies (the strategies are the treatment strategies SOC and Exp).
# So, basically we are creating a matrix to trace how the cohort is distributed across the health states, over time. 

# A matrix is necessary because there are basically two dimensions to this, the number of time cycles, which will be our rows, and then the number of states - to know which proportion of our cohort is in each state at each time:

# m_M_SoC <- matrix(0, 
#                   nrow = (n_cycles + 1), ncol = n_states, 
#                   dimnames = list(v_names_cycles, v_names_states))
# In the above code from DARTH instead of having to bother with -1 throughout the analysis they create a cycle 0.
# Then they store the initial state vector in the first row of the cohort trace
# m_M_SoC[1, ] <- v_s_init
## Initialize cohort traces
## So, above they make the cohort trace for standard of care
# This gives them a matrix to can fill in with the simulations of how patients transitions between health states under treatment.



# Back to my code, in the first row of the markov matrix [1, ] put the value at the far end, i.e. "<-1" and "<-0" under the colum "PFS" [ , "PFS"], repeating this for "OS", and "Dead":


# Specifying the initial state for the cohorts (all patients start in PFS)
m_M_SoC[1, "PFS"] <- m_M_Exp[1, "PFS"] <- 1
m_M_SoC[1, "OS"]  <- m_M_Exp[1, "OS"]  <- 0
m_M_SoC[1, "Dead"]<- m_M_Exp[1, "Dead"]  <- 0

# Inspect whether properly defined
head(m_M_SoC)
```

```
##         PFS OS Dead
## Cycle 1   1  0    0
## Cycle 2  NA NA   NA
## Cycle 3  NA NA   NA
## Cycle 4  NA NA   NA
## Cycle 5  NA NA   NA
## Cycle 6  NA NA   NA
```

```r
head(m_M_Exp)
```

```
##         PFS OS Dead
## Cycle 1   1  0    0
## Cycle 2  NA NA   NA
## Cycle 3  NA NA   NA
## Cycle 4  NA NA   NA
## Cycle 5  NA NA   NA
## Cycle 6  NA NA   NA
```


```r
# 04.2 Transition probability matrix

## If there were time varying transition probabilities, i.e. the longer you are in the model there are changes in your transition probability into death as you get older, etc., you would build a transition probability array, rather than a transition probability matrix, per: 

# 04.2 of:

# "C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modeling for Public Health_DARTH\5_Nov_29\4_Cohort state-transition models (cSTM) - time-dependent models_material\Markov_3state_time"

# with: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Cost-Effectiveness and Decision Modeling using R Workshop _ DARTH\August_24\Live Session


## Initialize transition probability matrix, [i.e. build the framework or empty scaffolding of the transition probability matrix]
# all transitions to a non-death state are assumed to be conditional on survival
# - starting with standard of care
# - note that these are now 3-dimensional matrices because we are including time.
 
# The DARTH approach would be something like:
# m_P_SoC  <- matrix(0,
#                    nrow = n_states, ncol = n_states,
#                    dimnames = list(v_names_states, v_names_states)) # define row and column names
# m_P_SoC


# Our approach to initialize matrices for the transition probabilities
# - note that these are now 3-dimensional matrices (so, above we originally included dim = nrow and ncol, but now we also include n_cycle - i.e. the number of cycles).
# - starting with standard of care
m_P_SoC <- array(
  data = 0,
  dim = c(n_states, n_states, n_cycle),
  dimnames = list(v_names_states, v_names_states, paste0("Cycle", 1:n_cycle))
  # define row and column names - then name each array after which cycle it's for, i.e. cycle 1 all the way through to cycle 143. So Cycle 1 will have all of our patients in PFS, while cycle 143 will have most people in the dead state.
)

head(m_P_SoC)
```

```
## , , Cycle1
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle2
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle3
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle4
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle5
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle6
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle7
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle8
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle9
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle10
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle11
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle12
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle13
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle14
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle15
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle16
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle17
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle18
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle19
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle20
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle21
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle22
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle23
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle24
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle25
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle26
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle27
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle28
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle29
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle30
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle31
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle32
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle33
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle34
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle35
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle36
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle37
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle38
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle39
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle40
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle41
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle42
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle43
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle44
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle45
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle46
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle47
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle48
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle49
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle50
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle51
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle52
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle53
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle54
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle55
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle56
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle57
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle58
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle59
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle60
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle61
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle62
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle63
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle64
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle65
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle66
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle67
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle68
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle69
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle70
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle71
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle72
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle73
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle74
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle75
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle76
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle77
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle78
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle79
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle80
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle81
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle82
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle83
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle84
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle85
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle86
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle87
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle88
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle89
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle90
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle91
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle92
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle93
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle94
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle95
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle96
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle97
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle98
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle99
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle100
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle101
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle102
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle103
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle104
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle105
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle106
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle107
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle108
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle109
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle110
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle111
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
##  [ reached getOption("max.print") -- omitted 32 matrix slice(s) ]
```

```r
m_P_Exp <- array(
  data = 0,
  dim = c(n_states, n_states, n_cycle),
  dimnames = list(v_names_states, v_names_states, paste0("Cycle", 1:n_cycle))
  # define row and column names - then name each array after which cycle it's for, i.e. cycle 1 all the way through to cycle 143. So Cycle 1 will have all of our patients in PFS, while cycle 143 will have most people in the dead state.
)

head(m_P_Exp)
```

```
## , , Cycle1
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle2
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle3
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle4
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle5
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle6
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle7
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle8
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle9
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle10
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle11
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle12
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle13
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle14
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle15
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle16
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle17
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle18
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle19
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle20
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle21
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle22
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle23
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle24
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle25
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle26
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle27
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle28
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle29
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle30
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle31
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle32
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle33
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle34
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle35
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle36
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle37
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle38
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle39
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle40
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle41
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle42
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle43
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle44
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle45
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle46
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle47
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle48
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle49
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle50
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle51
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle52
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle53
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle54
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle55
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle56
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle57
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle58
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle59
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle60
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle61
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle62
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle63
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle64
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle65
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle66
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle67
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle68
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle69
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle70
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle71
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle72
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle73
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle74
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle75
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle76
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle77
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle78
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle79
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle80
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle81
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle82
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle83
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle84
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle85
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle86
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle87
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle88
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle89
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle90
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle91
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle92
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle93
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle94
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle95
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle96
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle97
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle98
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle99
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle100
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle101
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle102
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle103
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle104
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle105
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle106
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle107
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle108
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle109
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle110
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle111
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
##  [ reached getOption("max.print") -- omitted 32 matrix slice(s) ]
```


```r
# 04.3 Fill in the transition probability matrix:

# Setting the transition probabilities from PFS based on the model parameters
  # So, when individuals are in PFS what are their probabilities of going into the other states that they can enter from PFS?

m_P_SoC["PFS", "PFS",]<- (1 -p_PFSOS_SoC) * (1 - p_PFSD_SoC)
m_P_SoC["PFS", "OS",]<- p_PFSOS_SoC*(1 - p_PFSD_SoC)
m_P_SoC["PFS", "Dead",]<-p_PFSD_SoC

# Setting the transition probabilities from OS
m_P_SoC["OS", "OS", ] <- 1 - P_OSD_SoC
m_P_SoC["OS", "Dead", ]        <- P_OSD_SoC


# Setting the transition probabilities from Dead
m_P_SoC["Dead", "Dead", ] <- 1


m_P_SoC
```

```
## , , Cycle1
## 
##         PFS      OS     Dead
## PFS  0.9805 0.01478 0.004708
## OS   0.0000 0.83000 0.170000
## Dead 0.0000 0.00000 1.000000
## 
## , , Cycle2
## 
##         PFS      OS    Dead
## PFS  0.9689 0.02382 0.00731
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle3
## 
##         PFS      OS     Dead
## PFS  0.9622 0.02906 0.008772
## OS   0.0000 0.83000 0.170000
## Dead 0.0000 0.00000 1.000000
## 
## , , Cycle4
## 
##        PFS      OS     Dead
## PFS  0.957 0.03308 0.009881
## OS   0.000 0.83000 0.170000
## Dead 0.000 0.00000 1.000000
## 
## , , Cycle5
## 
##         PFS      OS   Dead
## PFS  0.9528 0.03641 0.0108
## OS   0.0000 0.83000 0.1700
## Dead 0.0000 0.00000 1.0000
## 
## , , Cycle6
## 
##         PFS      OS    Dead
## PFS  0.9491 0.03931 0.01159
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle7
## 
##         PFS      OS    Dead
## PFS  0.9458 0.04188 0.01229
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle8
## 
##         PFS      OS    Dead
## PFS  0.9429 0.04421 0.01292
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle9
## 
##         PFS      OS   Dead
## PFS  0.9401 0.04636 0.0135
## OS   0.0000 0.83000 0.1700
## Dead 0.0000 0.00000 1.0000
## 
## , , Cycle10
## 
##         PFS      OS    Dead
## PFS  0.9376 0.04835 0.01404
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle11
## 
##         PFS     OS    Dead
## PFS  0.9353 0.0502 0.01454
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle12
## 
##        PFS      OS    Dead
## PFS  0.933 0.05195 0.01501
## OS   0.000 0.83000 0.17000
## Dead 0.000 0.00000 1.00000
## 
## , , Cycle13
## 
##         PFS      OS    Dead
## PFS  0.9309 0.05361 0.01545
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle14
## 
##         PFS      OS    Dead
## PFS  0.9289 0.05518 0.01588
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle15
## 
##        PFS      OS    Dead
## PFS  0.927 0.05667 0.01628
## OS   0.000 0.83000 0.17000
## Dead 0.000 0.00000 1.00000
## 
## , , Cycle16
## 
##         PFS      OS    Dead
## PFS  0.9252 0.05811 0.01666
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle17
## 
##         PFS      OS    Dead
## PFS  0.9235 0.05948 0.01703
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle18
## 
##         PFS     OS    Dead
## PFS  0.9218 0.0608 0.01739
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle19
## 
##         PFS      OS    Dead
## PFS  0.9202 0.06208 0.01773
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle20
## 
##         PFS      OS    Dead
## PFS  0.9186 0.06331 0.01806
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle21
## 
##         PFS      OS    Dead
## PFS  0.9171 0.06449 0.01838
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle22
## 
##         PFS      OS    Dead
## PFS  0.9157 0.06565 0.01869
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle23
## 
##         PFS      OS    Dead
## PFS  0.9143 0.06677 0.01898
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle24
## 
##         PFS      OS    Dead
## PFS  0.9129 0.06785 0.01928
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle25
## 
##         PFS      OS    Dead
## PFS  0.9115 0.06891 0.01956
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle26
## 
##         PFS      OS    Dead
## PFS  0.9102 0.06994 0.01983
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle27
## 
##        PFS      OS   Dead
## PFS  0.909 0.07094 0.0201
## OS   0.000 0.83000 0.1700
## Dead 0.000 0.00000 1.0000
## 
## , , Cycle28
## 
##         PFS      OS    Dead
## PFS  0.9077 0.07192 0.02036
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle29
## 
##         PFS      OS    Dead
## PFS  0.9065 0.07287 0.02062
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle30
## 
##         PFS      OS    Dead
## PFS  0.9053 0.07381 0.02087
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle31
## 
##         PFS      OS    Dead
## PFS  0.9042 0.07472 0.02111
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle32
## 
##        PFS      OS    Dead
## PFS  0.903 0.07562 0.02135
## OS   0.000 0.83000 0.17000
## Dead 0.000 0.00000 1.00000
## 
## , , Cycle33
## 
##         PFS      OS    Dead
## PFS  0.9019 0.07649 0.02159
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle34
## 
##         PFS      OS    Dead
## PFS  0.9008 0.07735 0.02182
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle35
## 
##         PFS      OS    Dead
## PFS  0.8998 0.07819 0.02204
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle36
## 
##         PFS      OS    Dead
## PFS  0.8987 0.07902 0.02226
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle37
## 
##         PFS      OS    Dead
## PFS  0.8977 0.07983 0.02248
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle38
## 
##         PFS      OS    Dead
## PFS  0.8967 0.08062 0.02269
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle39
## 
##         PFS      OS   Dead
## PFS  0.8957 0.08141 0.0229
## OS   0.0000 0.83000 0.1700
## Dead 0.0000 0.00000 1.0000
## 
## , , Cycle40
## 
##         PFS      OS    Dead
## PFS  0.8947 0.08218 0.02311
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle41
## 
##         PFS      OS    Dead
## PFS  0.8938 0.08293 0.02331
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle42
## 
##         PFS      OS    Dead
## PFS  0.8928 0.08368 0.02351
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle43
## 
##         PFS      OS    Dead
## PFS  0.8919 0.08441 0.02371
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle44
## 
##        PFS      OS   Dead
## PFS  0.891 0.08513 0.0239
## OS   0.000 0.83000 0.1700
## Dead 0.000 0.00000 1.0000
## 
## , , Cycle45
## 
##         PFS      OS    Dead
## PFS  0.8901 0.08584 0.02409
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle46
## 
##         PFS      OS    Dead
## PFS  0.8892 0.08654 0.02428
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle47
## 
##         PFS      OS    Dead
## PFS  0.8883 0.08723 0.02446
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle48
## 
##         PFS      OS    Dead
## PFS  0.8874 0.08791 0.02464
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle49
## 
##         PFS      OS    Dead
## PFS  0.8866 0.08858 0.02482
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle50
## 
##         PFS      OS  Dead
## PFS  0.8858 0.08924 0.025
## OS   0.0000 0.83000 0.170
## Dead 0.0000 0.00000 1.000
## 
## , , Cycle51
## 
##         PFS      OS    Dead
## PFS  0.8849 0.08989 0.02518
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle52
## 
##         PFS      OS    Dead
## PFS  0.8841 0.09054 0.02535
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle53
## 
##         PFS      OS    Dead
## PFS  0.8833 0.09117 0.02552
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle54
## 
##         PFS     OS    Dead
## PFS  0.8825 0.0918 0.02569
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle55
## 
##         PFS      OS    Dead
## PFS  0.8817 0.09242 0.02585
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle56
## 
##        PFS      OS    Dead
## PFS  0.881 0.09303 0.02602
## OS   0.000 0.83000 0.17000
## Dead 0.000 0.00000 1.00000
## 
## , , Cycle57
## 
##         PFS      OS    Dead
## PFS  0.8802 0.09364 0.02618
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle58
## 
##         PFS      OS    Dead
## PFS  0.8794 0.09423 0.02634
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle59
## 
##         PFS      OS   Dead
## PFS  0.8787 0.09482 0.0265
## OS   0.0000 0.83000 0.1700
## Dead 0.0000 0.00000 1.0000
## 
## , , Cycle60
## 
##         PFS      OS    Dead
## PFS  0.8779 0.09541 0.02666
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle61
## 
##         PFS      OS    Dead
## PFS  0.8772 0.09599 0.02681
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle62
## 
##         PFS      OS    Dead
## PFS  0.8765 0.09656 0.02697
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle63
## 
##         PFS      OS    Dead
## PFS  0.8758 0.09712 0.02712
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle64
## 
##         PFS      OS    Dead
## PFS  0.8751 0.09768 0.02727
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle65
## 
##         PFS      OS    Dead
## PFS  0.8743 0.09824 0.02742
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle66
## 
##         PFS      OS    Dead
## PFS  0.8737 0.09878 0.02756
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle67
## 
##        PFS      OS    Dead
## PFS  0.873 0.09932 0.02771
## OS   0.000 0.83000 0.17000
## Dead 0.000 0.00000 1.00000
## 
## , , Cycle68
## 
##         PFS      OS    Dead
## PFS  0.8723 0.09986 0.02785
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle69
## 
##         PFS     OS  Dead
## PFS  0.8716 0.1004 0.028
## OS   0.0000 0.8300 0.170
## Dead 0.0000 0.0000 1.000
## 
## , , Cycle70
## 
##         PFS     OS    Dead
## PFS  0.8709 0.1009 0.02814
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle71
## 
##         PFS     OS    Dead
## PFS  0.8703 0.1014 0.02828
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle72
## 
##         PFS    OS    Dead
## PFS  0.8696 0.102 0.02842
## OS   0.0000 0.830 0.17000
## Dead 0.0000 0.000 1.00000
## 
## , , Cycle73
## 
##        PFS     OS    Dead
## PFS  0.869 0.1025 0.02855
## OS   0.000 0.8300 0.17000
## Dead 0.000 0.0000 1.00000
## 
## , , Cycle74
## 
##         PFS    OS    Dead
## PFS  0.8683 0.103 0.02869
## OS   0.0000 0.830 0.17000
## Dead 0.0000 0.000 1.00000
## 
## , , Cycle75
## 
##         PFS     OS    Dead
## PFS  0.8677 0.1035 0.02883
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle76
## 
##         PFS    OS    Dead
## PFS  0.8671 0.104 0.02896
## OS   0.0000 0.830 0.17000
## Dead 0.0000 0.000 1.00000
## 
## , , Cycle77
## 
##         PFS     OS    Dead
## PFS  0.8664 0.1045 0.02909
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle78
## 
##         PFS    OS    Dead
## PFS  0.8658 0.105 0.02922
## OS   0.0000 0.830 0.17000
## Dead 0.0000 0.000 1.00000
## 
## , , Cycle79
## 
##         PFS     OS    Dead
## PFS  0.8652 0.1054 0.02936
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle80
## 
##         PFS     OS    Dead
## PFS  0.8646 0.1059 0.02949
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle81
## 
##        PFS     OS    Dead
## PFS  0.864 0.1064 0.02961
## OS   0.000 0.8300 0.17000
## Dead 0.000 0.0000 1.00000
## 
## , , Cycle82
## 
##         PFS     OS    Dead
## PFS  0.8634 0.1069 0.02974
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle83
## 
##         PFS     OS    Dead
## PFS  0.8628 0.1073 0.02987
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle84
## 
##         PFS     OS    Dead
## PFS  0.8622 0.1078 0.02999
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle85
## 
##         PFS     OS    Dead
## PFS  0.8616 0.1083 0.03012
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle86
## 
##        PFS     OS    Dead
## PFS  0.861 0.1087 0.03024
## OS   0.000 0.8300 0.17000
## Dead 0.000 0.0000 1.00000
## 
## , , Cycle87
## 
##         PFS     OS    Dead
## PFS  0.8605 0.1092 0.03036
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle88
## 
##         PFS     OS    Dead
## PFS  0.8599 0.1096 0.03048
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle89
## 
##         PFS     OS    Dead
## PFS  0.8593 0.1101 0.03061
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle90
## 
##         PFS     OS    Dead
## PFS  0.8588 0.1105 0.03072
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle91
## 
##         PFS    OS    Dead
## PFS  0.8582 0.111 0.03084
## OS   0.0000 0.830 0.17000
## Dead 0.0000 0.000 1.00000
## 
## , , Cycle92
## 
##         PFS     OS    Dead
## PFS  0.8577 0.1114 0.03096
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle93
## 
##         PFS     OS    Dead
## PFS  0.8571 0.1118 0.03108
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle94
## 
##         PFS     OS   Dead
## PFS  0.8566 0.1123 0.0312
## OS   0.0000 0.8300 0.1700
## Dead 0.0000 0.0000 1.0000
## 
## , , Cycle95
## 
##        PFS     OS    Dead
## PFS  0.856 0.1127 0.03131
## OS   0.000 0.8300 0.17000
## Dead 0.000 0.0000 1.00000
## 
## , , Cycle96
## 
##         PFS     OS    Dead
## PFS  0.8555 0.1131 0.03143
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle97
## 
##         PFS     OS    Dead
## PFS  0.8549 0.1135 0.03154
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle98
## 
##         PFS     OS    Dead
## PFS  0.8544 0.1139 0.03165
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle99
## 
##         PFS     OS    Dead
## PFS  0.8539 0.1144 0.03177
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle100
## 
##         PFS     OS    Dead
## PFS  0.8534 0.1148 0.03188
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle101
## 
##         PFS     OS    Dead
## PFS  0.8528 0.1152 0.03199
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle102
## 
##         PFS     OS   Dead
## PFS  0.8523 0.1156 0.0321
## OS   0.0000 0.8300 0.1700
## Dead 0.0000 0.0000 1.0000
## 
## , , Cycle103
## 
##         PFS    OS    Dead
## PFS  0.8518 0.116 0.03221
## OS   0.0000 0.830 0.17000
## Dead 0.0000 0.000 1.00000
## 
## , , Cycle104
## 
##         PFS     OS    Dead
## PFS  0.8513 0.1164 0.03232
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle105
## 
##         PFS     OS    Dead
## PFS  0.8508 0.1168 0.03242
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle106
## 
##         PFS     OS    Dead
## PFS  0.8503 0.1172 0.03253
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle107
## 
##         PFS     OS    Dead
## PFS  0.8498 0.1176 0.03264
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle108
## 
##         PFS    OS    Dead
## PFS  0.8493 0.118 0.03274
## OS   0.0000 0.830 0.17000
## Dead 0.0000 0.000 1.00000
## 
## , , Cycle109
## 
##         PFS     OS    Dead
## PFS  0.8488 0.1184 0.03285
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle110
## 
##         PFS     OS    Dead
## PFS  0.8483 0.1187 0.03295
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle111
## 
##         PFS     OS    Dead
## PFS  0.8478 0.1191 0.03306
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
##  [ reached getOption("max.print") -- omitted 32 matrix slice(s) ]
```

```r
# Using the transition probabilities for standard of care as basis, I update the transition probabilities that are different for the experimental strategy


# Setting the transition probabilities the experimental strategy
m_P_Exp["PFS", "PFS",]<- (1 -p_PFSOS_Exp) * (1 - p_PFSD_Exp)
m_P_Exp["PFS", "OS",]<- p_PFSOS_Exp*(1 - p_PFSD_Exp)
m_P_Exp["PFS", "Dead",]<-p_PFSD_Exp

# Setting the transition probabilities from OS
m_P_Exp["OS", "OS", ] <- 1 - P_OSD_Exp
m_P_Exp["OS", "Dead", ]        <- P_OSD_Exp

# Setting the transition probabilities from Dead
m_P_Exp["Dead", "Dead", ] <- 1

m_P_Exp
```

```
## , , Cycle1
## 
##         PFS      OS     Dead
## PFS  0.9868 0.01009 0.003063
## OS   0.0000 0.83000 0.170000
## Dead 0.0000 0.00000 1.000000
## 
## , , Cycle2
## 
##         PFS     OS     Dead
## PFS  0.9789 0.0163 0.004757
## OS   0.0000 0.8300 0.170000
## Dead 0.0000 0.0000 1.000000
## 
## , , Cycle3
## 
##         PFS      OS     Dead
## PFS  0.9744 0.01992 0.005711
## OS   0.0000 0.83000 0.170000
## Dead 0.0000 0.00000 1.000000
## 
## , , Cycle4
## 
##         PFS      OS     Dead
## PFS  0.9709 0.02269 0.006434
## OS   0.0000 0.83000 0.170000
## Dead 0.0000 0.00000 1.000000
## 
## , , Cycle5
## 
##        PFS    OS    Dead
## PFS  0.968 0.025 0.00703
## OS   0.000 0.830 0.17000
## Dead 0.000 0.000 1.00000
## 
## , , Cycle6
## 
##         PFS      OS     Dead
## PFS  0.9654 0.02701 0.007546
## OS   0.0000 0.83000 0.170000
## Dead 0.0000 0.00000 1.000000
## 
## , , Cycle7
## 
##         PFS     OS     Dead
## PFS  0.9632 0.0288 0.008003
## OS   0.0000 0.8300 0.170000
## Dead 0.0000 0.0000 1.000000
## 
## , , Cycle8
## 
##         PFS      OS     Dead
## PFS  0.9612 0.03042 0.008417
## OS   0.0000 0.83000 0.170000
## Dead 0.0000 0.00000 1.000000
## 
## , , Cycle9
## 
##         PFS      OS     Dead
## PFS  0.9593 0.03192 0.008795
## OS   0.0000 0.83000 0.170000
## Dead 0.0000 0.00000 1.000000
## 
## , , Cycle10
## 
##         PFS     OS     Dead
## PFS  0.9576 0.0333 0.009146
## OS   0.0000 0.8300 0.170000
## Dead 0.0000 0.0000 1.000000
## 
## , , Cycle11
## 
##         PFS     OS     Dead
## PFS  0.9559 0.0346 0.009474
## OS   0.0000 0.8300 0.170000
## Dead 0.0000 0.0000 1.000000
## 
## , , Cycle12
## 
##         PFS      OS     Dead
## PFS  0.9544 0.03582 0.009782
## OS   0.0000 0.83000 0.170000
## Dead 0.0000 0.00000 1.000000
## 
## , , Cycle13
## 
##         PFS      OS    Dead
## PFS  0.9529 0.03698 0.01007
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle14
## 
##         PFS      OS    Dead
## PFS  0.9516 0.03808 0.01035
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle15
## 
##         PFS      OS    Dead
## PFS  0.9503 0.03913 0.01061
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle16
## 
##        PFS      OS    Dead
## PFS  0.949 0.04013 0.01086
## OS   0.000 0.83000 0.17000
## Dead 0.000 0.00000 1.00000
## 
## , , Cycle17
## 
##         PFS     OS   Dead
## PFS  0.9478 0.0411 0.0111
## OS   0.0000 0.8300 0.1700
## Dead 0.0000 0.0000 1.0000
## 
## , , Cycle18
## 
##         PFS      OS    Dead
## PFS  0.9466 0.04202 0.01134
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle19
## 
##         PFS      OS    Dead
## PFS  0.9455 0.04292 0.01156
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle20
## 
##         PFS      OS    Dead
## PFS  0.9444 0.04378 0.01177
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle21
## 
##         PFS      OS    Dead
## PFS  0.9434 0.04462 0.01198
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle22
## 
##         PFS      OS    Dead
## PFS  0.9424 0.04543 0.01219
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle23
## 
##         PFS      OS    Dead
## PFS  0.9414 0.04622 0.01238
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle24
## 
##         PFS      OS    Dead
## PFS  0.9404 0.04699 0.01257
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle25
## 
##         PFS      OS    Dead
## PFS  0.9395 0.04773 0.01276
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle26
## 
##         PFS      OS    Dead
## PFS  0.9386 0.04846 0.01294
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle27
## 
##         PFS      OS    Dead
## PFS  0.9377 0.04916 0.01311
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle28
## 
##         PFS      OS    Dead
## PFS  0.9369 0.04986 0.01328
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle29
## 
##        PFS      OS    Dead
## PFS  0.936 0.05053 0.01345
## OS   0.000 0.83000 0.17000
## Dead 0.000 0.00000 1.00000
## 
## , , Cycle30
## 
##         PFS      OS    Dead
## PFS  0.9352 0.05119 0.01362
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle31
## 
##         PFS      OS    Dead
## PFS  0.9344 0.05184 0.01378
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle32
## 
##         PFS      OS    Dead
## PFS  0.9336 0.05247 0.01393
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle33
## 
##         PFS      OS    Dead
## PFS  0.9328 0.05309 0.01409
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle34
## 
##         PFS     OS    Dead
## PFS  0.9321 0.0537 0.01424
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle35
## 
##         PFS     OS    Dead
## PFS  0.9313 0.0543 0.01438
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle36
## 
##         PFS      OS    Dead
## PFS  0.9306 0.05488 0.01453
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle37
## 
##         PFS      OS    Dead
## PFS  0.9299 0.05546 0.01467
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle38
## 
##         PFS      OS    Dead
## PFS  0.9292 0.05602 0.01481
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle39
## 
##         PFS      OS    Dead
## PFS  0.9285 0.05658 0.01495
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle40
## 
##         PFS      OS    Dead
## PFS  0.9278 0.05713 0.01508
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle41
## 
##         PFS      OS    Dead
## PFS  0.9271 0.05766 0.01521
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle42
## 
##         PFS      OS    Dead
## PFS  0.9265 0.05819 0.01535
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle43
## 
##         PFS      OS    Dead
## PFS  0.9258 0.05871 0.01547
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle44
## 
##         PFS      OS   Dead
## PFS  0.9252 0.05923 0.0156
## OS   0.0000 0.83000 0.1700
## Dead 0.0000 0.00000 1.0000
## 
## , , Cycle45
## 
##         PFS      OS    Dead
## PFS  0.9245 0.05973 0.01573
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle46
## 
##         PFS      OS    Dead
## PFS  0.9239 0.06023 0.01585
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle47
## 
##         PFS      OS    Dead
## PFS  0.9233 0.06072 0.01597
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle48
## 
##         PFS      OS    Dead
## PFS  0.9227 0.06121 0.01609
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle49
## 
##         PFS      OS    Dead
## PFS  0.9221 0.06169 0.01621
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle50
## 
##         PFS      OS    Dead
## PFS  0.9215 0.06216 0.01632
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle51
## 
##         PFS      OS    Dead
## PFS  0.9209 0.06262 0.01644
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle52
## 
##         PFS      OS    Dead
## PFS  0.9204 0.06308 0.01655
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle53
## 
##         PFS      OS    Dead
## PFS  0.9198 0.06354 0.01666
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle54
## 
##         PFS      OS    Dead
## PFS  0.9192 0.06399 0.01677
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle55
## 
##         PFS      OS    Dead
## PFS  0.9187 0.06443 0.01688
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle56
## 
##         PFS      OS    Dead
## PFS  0.9181 0.06487 0.01699
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle57
## 
##         PFS     OS   Dead
## PFS  0.9176 0.0653 0.0171
## OS   0.0000 0.8300 0.1700
## Dead 0.0000 0.0000 1.0000
## 
## , , Cycle58
## 
##         PFS      OS   Dead
## PFS  0.9171 0.06573 0.0172
## OS   0.0000 0.83000 0.1700
## Dead 0.0000 0.00000 1.0000
## 
## , , Cycle59
## 
##         PFS      OS    Dead
## PFS  0.9165 0.06615 0.01731
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle60
## 
##        PFS      OS    Dead
## PFS  0.916 0.06657 0.01741
## OS   0.000 0.83000 0.17000
## Dead 0.000 0.00000 1.00000
## 
## , , Cycle61
## 
##         PFS      OS    Dead
## PFS  0.9155 0.06698 0.01751
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle62
## 
##        PFS      OS    Dead
## PFS  0.915 0.06739 0.01761
## OS   0.000 0.83000 0.17000
## Dead 0.000 0.00000 1.00000
## 
## , , Cycle63
## 
##         PFS     OS    Dead
## PFS  0.9145 0.0678 0.01771
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle64
## 
##        PFS     OS    Dead
## PFS  0.914 0.0682 0.01781
## OS   0.000 0.8300 0.17000
## Dead 0.000 0.0000 1.00000
## 
## , , Cycle65
## 
##         PFS      OS    Dead
## PFS  0.9135 0.06859 0.01791
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle66
## 
##        PFS      OS  Dead
## PFS  0.913 0.06899 0.018
## OS   0.000 0.83000 0.170
## Dead 0.000 0.00000 1.000
## 
## , , Cycle67
## 
##         PFS      OS   Dead
## PFS  0.9125 0.06938 0.0181
## OS   0.0000 0.83000 0.1700
## Dead 0.0000 0.00000 1.0000
## 
## , , Cycle68
## 
##        PFS      OS    Dead
## PFS  0.912 0.06976 0.01819
## OS   0.000 0.83000 0.17000
## Dead 0.000 0.00000 1.00000
## 
## , , Cycle69
## 
##         PFS      OS    Dead
## PFS  0.9116 0.07014 0.01829
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle70
## 
##         PFS      OS    Dead
## PFS  0.9111 0.07052 0.01838
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle71
## 
##         PFS     OS    Dead
## PFS  0.9106 0.0709 0.01847
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle72
## 
##         PFS      OS    Dead
## PFS  0.9102 0.07127 0.01856
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle73
## 
##         PFS      OS    Dead
## PFS  0.9097 0.07163 0.01865
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle74
## 
##         PFS    OS    Dead
## PFS  0.9093 0.072 0.01874
## OS   0.0000 0.830 0.17000
## Dead 0.0000 0.000 1.00000
## 
## , , Cycle75
## 
##         PFS      OS    Dead
## PFS  0.9088 0.07236 0.01883
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle76
## 
##         PFS      OS    Dead
## PFS  0.9084 0.07272 0.01892
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle77
## 
##         PFS      OS    Dead
## PFS  0.9079 0.07307 0.01901
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle78
## 
##         PFS      OS    Dead
## PFS  0.9075 0.07342 0.01909
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle79
## 
##        PFS      OS    Dead
## PFS  0.907 0.07377 0.01918
## OS   0.000 0.83000 0.17000
## Dead 0.000 0.00000 1.00000
## 
## , , Cycle80
## 
##         PFS      OS    Dead
## PFS  0.9066 0.07412 0.01927
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle81
## 
##         PFS      OS    Dead
## PFS  0.9062 0.07446 0.01935
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle82
## 
##         PFS     OS    Dead
## PFS  0.9058 0.0748 0.01943
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle83
## 
##         PFS      OS    Dead
## PFS  0.9053 0.07514 0.01952
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle84
## 
##         PFS      OS   Dead
## PFS  0.9049 0.07548 0.0196
## OS   0.0000 0.83000 0.1700
## Dead 0.0000 0.00000 1.0000
## 
## , , Cycle85
## 
##         PFS      OS    Dead
## PFS  0.9045 0.07581 0.01968
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle86
## 
##         PFS      OS    Dead
## PFS  0.9041 0.07614 0.01976
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle87
## 
##         PFS      OS    Dead
## PFS  0.9037 0.07647 0.01984
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle88
## 
##         PFS      OS    Dead
## PFS  0.9033 0.07679 0.01992
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle89
## 
##         PFS      OS Dead
## PFS  0.9029 0.07711 0.02
## OS   0.0000 0.83000 0.17
## Dead 0.0000 0.00000 1.00
## 
## , , Cycle90
## 
##         PFS      OS    Dead
## PFS  0.9025 0.07743 0.02008
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle91
## 
##         PFS      OS    Dead
## PFS  0.9021 0.07775 0.02016
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle92
## 
##         PFS      OS    Dead
## PFS  0.9017 0.07807 0.02024
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle93
## 
##         PFS      OS    Dead
## PFS  0.9013 0.07838 0.02031
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle94
## 
##         PFS      OS    Dead
## PFS  0.9009 0.07869 0.02039
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle95
## 
##         PFS    OS    Dead
## PFS  0.9005 0.079 0.02047
## OS   0.0000 0.830 0.17000
## Dead 0.0000 0.000 1.00000
## 
## , , Cycle96
## 
##         PFS      OS    Dead
## PFS  0.9002 0.07931 0.02054
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle97
## 
##         PFS      OS    Dead
## PFS  0.8998 0.07961 0.02062
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle98
## 
##         PFS      OS    Dead
## PFS  0.8994 0.07991 0.02069
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle99
## 
##        PFS      OS    Dead
## PFS  0.899 0.08021 0.02076
## OS   0.000 0.83000 0.17000
## Dead 0.000 0.00000 1.00000
## 
## , , Cycle100
## 
##         PFS      OS    Dead
## PFS  0.8986 0.08051 0.02084
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle101
## 
##         PFS      OS    Dead
## PFS  0.8983 0.08081 0.02091
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle102
## 
##         PFS     OS    Dead
## PFS  0.8979 0.0811 0.02098
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle103
## 
##         PFS     OS    Dead
## PFS  0.8975 0.0814 0.02105
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle104
## 
##         PFS      OS    Dead
## PFS  0.8972 0.08169 0.02113
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle105
## 
##         PFS      OS   Dead
## PFS  0.8968 0.08198 0.0212
## OS   0.0000 0.83000 0.1700
## Dead 0.0000 0.00000 1.0000
## 
## , , Cycle106
## 
##         PFS      OS    Dead
## PFS  0.8965 0.08226 0.02127
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle107
## 
##         PFS      OS    Dead
## PFS  0.8961 0.08255 0.02134
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle108
## 
##         PFS      OS    Dead
## PFS  0.8958 0.08283 0.02141
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle109
## 
##         PFS      OS    Dead
## PFS  0.8954 0.08312 0.02148
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle110
## 
##         PFS     OS    Dead
## PFS  0.8951 0.0834 0.02155
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle111
## 
##         PFS      OS    Dead
## PFS  0.8947 0.08367 0.02161
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
##  [ reached getOption("max.print") -- omitted 32 matrix slice(s) ]
```

```r
# If I wanted to round my transition matrix so things sum exactly to 1, instead of 0.99999999 (in cases where this was happening):
#round(m_P_SoC, digits=2) 
#But, things actually sum well so I don't need to this
```


```r
#04.4 Check if transition probability matrices are valid.

# This is a check in the DARTH tools package that all the transition probabilities are in [0, 1], i.e., no probabilities are greater than 100%.

# This works as follows, according to line 205 of: https://github.com/DARTH-git/cohort-modeling-tutorial-intro/blob/main/analysis/cSTM_time_indep.R
# 
# ## Check if transition probability matrices are valid ----
# #* Functions included in "R/Functions.R". The latest version can be found in `darthtools` package
# ### Check that transition probabilities are [0, 1] ----
# check_transition_probability(m_P,      verbose = TRUE)  # m_P >= 0 && m_P <= 1
# check_transition_probability(m_P_strA, verbose = TRUE)  # m_P_strA >= 0 && m_P_strA <= 1
# check_transition_probability(m_P_strB, verbose = TRUE)  # m_P_strB >= 0 && m_P_strB <= 1
# check_transition_probability(m_P_strAB, verbose = TRUE) # m_P_strAB >= 0 && m_P_strAB <= 1
# ### Check that all rows sum to 1 ----
# check_sum_of_transition_array(m_P,      n_states = n_states, n_cycles = n_cycles, verbose = TRUE)  # rowSums(m_P) == 1
# check_sum_of_transition_array(m_P_strA, n_states = n_states, n_cycles = n_cycles, verbose = TRUE)  # rowSums(m_P_strA) == 1
# check_sum_of_transition_array(m_P_strB, n_states = n_states, n_cycles = n_cycles, verbose = TRUE)  # rowSums(m_P_strB) == 1
# check_sum_of_transition_array(m_P_strAB, n_states = n_states, n_cycles = n_cycles, verbose = TRUE) # rowSums(m_P_strAB) == 1
# 

check_transition_probability(m_P_SoC,  verbose = TRUE)
```

```
## [1] "Valid transition probabilities"
```

```r
check_transition_probability(m_P_Exp,  verbose = TRUE)
```

```
## [1] "Valid transition probabilities"
```

```r
# Check that all rows sum in each matrix sum to 1 -> which we know is a necessary condition for transition probability matrices.
check_sum_of_transition_array(m_P_SoC,  n_states = n_states, n_cycles = n_cycle, verbose = TRUE)
```

```
## [1] "This is a valid transition array"
```

```r
check_sum_of_transition_array(m_P_Exp,  n_states = n_states, n_cycles = n_cycle, verbose = TRUE)
```

```
## [1] "This is a valid transition array"
```

```r
# This error message:
   
#   Error in check_sum_of_transition_array(m_P_SoC, n_states = n_states, n_cycles = n_cycle,  : 
#   This is not a valid transition array 
 
# Reflects when something like this happens: 

#   > m_P_SoC
# , , Cycle1
 
#           PFS          OS        Dead       AE1       AE2       AE3
# PFS  0.974925 0.005074995 0.020000000 0.0194985 0.0194985 0.0194985
# [1] 1.058495
 
# That is, that I've put just any old probability value in at the moment and they are summing to be larger than one, when I've changed this to the actual probabilities I'm sure it'll be OK.

# Inspect whether properly defined
# - note that we inspect for the first two cycles
m_P_SoC[ , , 1:2]
```

```
## , , Cycle1
## 
##         PFS      OS     Dead
## PFS  0.9805 0.01478 0.004708
## OS   0.0000 0.83000 0.170000
## Dead 0.0000 0.00000 1.000000
## 
## , , Cycle2
## 
##         PFS      OS    Dead
## PFS  0.9689 0.02382 0.00731
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
```

```r
m_P_Exp[ , , 1:2]
```

```
## , , Cycle1
## 
##         PFS      OS     Dead
## PFS  0.9868 0.01009 0.003063
## OS   0.0000 0.83000 0.170000
## Dead 0.0000 0.00000 1.000000
## 
## , , Cycle2
## 
##         PFS     OS     Dead
## PFS  0.9789 0.0163 0.004757
## OS   0.0000 0.8300 0.170000
## Dead 0.0000 0.0000 1.000000
```

```r
# Does it visually sum to 1?
```


```r
#05 Run Markov model
# for (t in 1:n_cycles){  # Use a for loop to loop through the number of cycles, basically we'll calculate the cohort distribution at the next cycle [t+1] based on the matrix of where they were at time t, matrix multiplied by the transition probability matrix for the current cycle (constant for us as we use a constant transition probability matrix, rather than a transition probability array).

# We do this for each treatment, as they all have different transition probability matrices. 

#  m_M_SoC [t + 1, ] <- m_M_SoC [t, ] %*% m_P_SoC   # estimate the state vector for the next cycle (t + 1)

# Above I was originally using a transition probability matrix, because I was using a time constant transition probability. But now, because my transition probabilities come from the survival curves, and thus change over time, I am using a transition probability array. 

# Thus, I adapt the above to reflect that my transition probability selected has to come from a certain cycle, i.e. from a certain time, and then be multiplied by the number of people in the matrix, the amount of the cohort in the matrix, at that cycle, i.e. at that time. Thats why below I pick the third dimension of the array, not row, not column, but time: R,C,T i.e.   ->  , ,i_cycle

# So here I once again create the Markov cohort trace by looping over all cycles
# - note that the trace can easily be obtained using matrix multiplications
# - note that now the right probabilities for the cycle need to be selected, like I explained above.

for(i_cycle in 1:(n_cycle-1)) {
  m_M_SoC[i_cycle + 1, ] <- m_M_SoC[i_cycle, ] %*% m_P_SoC[ , , i_cycle]
  m_M_Exp[i_cycle + 1, ] <- m_M_Exp[i_cycle, ] %*% m_P_Exp[ , , i_cycle]
}

head(m_M_SoC)  # print the first few lines of the matrix for standard of care (m_M_SoC)
```

```
##            PFS      OS     Dead
## Cycle 1 1.0000 0.00000 0.000000
## Cycle 2 0.9805 0.01478 0.004708
## Cycle 3 0.9500 0.03562 0.014388
## Cycle 4 0.9140 0.05718 0.028777
## Cycle 5 0.8748 0.07769 0.047529
## Cycle 6 0.8335 0.09634 0.070180
```

```r
head(m_M_Exp)  # print the first few lines of the matrix for experimental treatment(m_M_Exp)
```

```
##            PFS      OS     Dead
## Cycle 1 1.0000 0.00000 0.000000
## Cycle 2 0.9868 0.01009 0.003063
## Cycle 3 0.9661 0.02446 0.009473
## Cycle 4 0.9413 0.03955 0.019149
## Cycle 5 0.9139 0.05419 0.031928
## Cycle 6 0.8846 0.06783 0.047564
```

```r
#m_M_SoC
m_M_SoC
```

```
##                      PFS            OS     Dead
## Cycle 1   1.000000000000 0.00000000000 0.000000
## Cycle 2   0.980514224355 0.01477733152 0.004708
## Cycle 3   0.949988269605 0.03562398844 0.014388
## Cycle 4   0.914044904042 0.05717774013 0.028777
## Cycle 5   0.874779409562 0.07769169256 0.047529
## Cycle 6   0.833481962065 0.09633774303 0.070180
## Cycle 7   0.791064941395 0.11272115807 0.096214
## Cycle 8   0.748215368460 0.12668918736 0.125095
## Cycle 9   0.705466779582 0.13823434451 0.156299
## Cycle 10  0.663239294608 0.14743869244 0.189322
## Cycle 11  0.621864731118 0.15443915851 0.223696
## Cycle 12  0.581603788716 0.15940487909 0.258991
## Cycle 13  0.542658625121 0.16252196096 0.294819
## Cycle 14  0.505182546602 0.16398306672 0.330834
## Cycle 15  0.469287772027 0.16398026217 0.366732
## Cycle 16  0.435051836562 0.16270013323 0.402248
## Cycle 17  0.402522985943 0.16032051509 0.437156
## Cycle 18  0.371724788765 0.15700838370 0.471267
## Cycle 19  0.342660120443 0.15291859313 0.504421
## Cycle 20  0.315314626920 0.14819323149 0.536492
## Cycle 21  0.289659747226 0.14296142898 0.567379
## Cycle 22  0.265655355024 0.13733949493 0.597005
## Cycle 23  0.243252066600 0.13143129103 0.625317
## Cycle 24  0.222393254016 0.12532877068 0.652278
## Cycle 25  0.203016795944 0.11911263111 0.677871
## Cycle 26  0.185056594218 0.11285303734 0.702090
## Cycle 27  0.168443880704 0.10661038668 0.724946
## Cycle 28  0.153108336430 0.10043608988 0.746456
## Cycle 29  0.138979042779 0.09437335069 0.766648
## Cycle 30  0.125985282687 0.08845793021 0.785557
## Cycle 31  0.114057208252 0.08271888577 0.803224
## Cycle 32  0.103126389742 0.07717927711 0.819694
## Cycle 33  0.093126259704 0.07185683456 0.835017
## Cycle 34  0.083992464752 0.06676458617 0.849243
## Cycle 35  0.075663136458 0.06191144149 0.862425
## Cycle 36  0.068079091810 0.05730273154 0.874618
## Cycle 37  0.061183972714 0.05294070475 0.885875
## Cycle 38  0.054924333130 0.04882497986 0.896251
## Cycle 39  0.049249681579 0.04495295682 0.905797
## Cycle 40  0.044112485997 0.04132018759 0.914567
## Cycle 41  0.039468147145 0.03792070867 0.922611
## Cycle 42  0.035274946119 0.03474733751 0.929978
## Cycle 43  0.031493970869 0.03179193518 0.936714
## Cycle 44  0.028089026051 0.02904563760 0.942865
## Cycle 45  0.025026529987 0.02649905765 0.948474
## Cycle 46  0.022275402031 0.02414246067 0.953582
## Cycle 47  0.019806943195 0.02196591545 0.958227
## Cycle 48  0.017594712461 0.01995942316 0.962446
## Cycle 49  0.015614400861 0.01811302612 0.966273
## Cycle 50  0.013843705078 0.01641689870 0.969739
## Cycle 51  0.012262202006 0.01486142198 0.972876
## Cycle 52  0.010851225476 0.01343724426 0.975712
## Cycle 53  0.009593746112 0.01213532881 0.978271
## Cycle 54  0.008474255064 0.01094699063 0.980579
## Cycle 55  0.007478652227 0.00986392349 0.982657
## Cycle 56  0.006594139357 0.00887821860 0.984528
## Cycle 57  0.005809118405 0.00798237611 0.986209
## Cycle 58  0.005113095250 0.00716931049 0.987718
## Cycle 59  0.004496588926 0.00643235071 0.989071
## Cycle 60  0.003951046370 0.00576523614 0.990284
## Cycle 61  0.003468762623 0.00516210894 0.991369
## Cycle 62  0.003042806410 0.00461750350 0.992340
## Cycle 63  0.002666950925 0.00412633375 0.993207
## Cycle 64  0.002335609660 0.00368387859 0.993981
## Cycle 65  0.002043777073 0.00328576609 0.994670
## Cycle 66  0.001786973866 0.00292795682 0.995285
## Cycle 67  0.001561196643 0.00260672657 0.995832
## Cycle 68  0.001362871709 0.00231864875 0.996318
## Cycle 69  0.001188812756 0.00206057687 0.996751
## Cycle 70  0.001036182195 0.00182962702 0.997134
## Cycle 71  0.000902455900 0.00162316078 0.997474
## Cycle 72  0.000785391111 0.00143876850 0.997776
## Cycle 73  0.000682997276 0.00127425321 0.998043
## Cycle 74  0.000593509621 0.00112761504 0.998279
## Cycle 75  0.000515365210 0.00099703644 0.998488
## Cycle 76  0.000447181323 0.00088086805 0.998672
## Cycle 77  0.000387735944 0.00077761534 0.998835
## Cycle 78  0.000335950185 0.00068592601 0.998978
## Cycle 79  0.000290872481 0.00060457817 0.999105
## Cycle 80  0.000251664394 0.00053246925 0.999216
## Cycle 81  0.000217587888 0.00046860565 0.999314
## Cycle 82  0.000187993928 0.00041209311 0.999400
## Cycle 83  0.000162312290 0.00036212781 0.999476
## Cycle 84  0.000140042461 0.00031798808 0.999542
## Cycle 85  0.000120745522 0.00027902680 0.999600
## Cycle 86  0.000104036921 0.00024466434 0.999651
## Cycle 87  0.000089580037 0.00021438216 0.999696
## Cycle 88  0.000077080475 0.00018771684 0.999735
## Cycle 89  0.000066280989 0.00016425470 0.999769
## Cycle 90  0.000056956993 0.00014362685 0.999799
## Cycle 91  0.000048912582 0.00012550470 0.999826
## Cycle 92  0.000041977014 0.00010959582 0.999848
## Cycle 93  0.000036001602 0.00009564025 0.999868
## Cycle 94  0.000030856973 0.00008340715 0.999886
## Cycle 95  0.000026430652 0.00007269166 0.999901
## Cycle 96  0.000022624934 0.00006331223 0.999914
## Cycle 97  0.000019355011 0.00005510807 0.999926
## Cycle 98  0.000016547330 0.00004793693 0.999936
## Cycle 99  0.000014138151 0.00004167307 0.999944
## Cycle 100 0.000012072275 0.00003620542 0.999952
## Cycle 101 0.000010301943 0.00003143601 0.999958
## Cycle 102 0.000008785862 0.00002727843 0.999964
## Cycle 103 0.000007488353 0.00002365660 0.999969
## Cycle 104 0.000006378619 0.00002050353 0.999973
## Cycle 105 0.000005430089 0.00001776033 0.999977
## Cycle 106 0.000004619859 0.00001537524 0.999980
## Cycle 107 0.000003928199 0.00001330282 0.999983
## Cycle 108 0.000003338126 0.00001150320 0.999985
## Cycle 109 0.000002835032 0.00000994145 0.999987
## Cycle 110 0.000002406360 0.00000858694 0.999989
## Cycle 111 0.000002041324 0.00000741290 0.999991
## Cycle 112 0.000001730668 0.00000639588 0.999992
## Cycle 113 0.000001466449 0.00000551540 0.999993
## Cycle 114 0.000001241862 0.00000475359 0.999994
## Cycle 115 0.000001051076 0.00000409483 0.999995
## Cycle 116 0.000000889100 0.00000352551 0.999996
## Cycle 117 0.000000751664 0.00000303376 0.999996
## Cycle 118 0.000000635120 0.00000260925 0.999997
## Cycle 119 0.000000536348 0.00000224300 0.999997
## Cycle 120 0.000000452688 0.00000192719 0.999998
## Cycle 121 0.000000381868 0.00000165501 0.999998
## Cycle 122 0.000000321951 0.00000142056 0.999998
## Cycle 123 0.000000271289 0.00000121873 0.999999
## Cycle 124 0.000000228476 0.00000104506 0.999999
## Cycle 125 0.000000192315 0.00000089571 0.999999
## Cycle 126 0.000000161792 0.00000076734 0.999999
## Cycle 127 0.000000136040 0.00000065705 0.999999
## Cycle 128 0.000000114327 0.00000056235 0.999999
## Cycle 129 0.000000096029 0.00000048108 0.999999
## Cycle 130 0.000000080617 0.00000041136 1.000000
## Cycle 131 0.000000067644 0.00000035159 1.000000
## Cycle 132 0.000000056729 0.00000030036 1.000000
## Cycle 133 0.000000047550 0.00000025649 1.000000
## Cycle 134 0.000000039836 0.00000021893 1.000000
## Cycle 135 0.000000033357 0.00000018678 1.000000
## Cycle 136 0.000000027917 0.00000015929 1.000000
## Cycle 137 0.000000023352 0.00000013578 1.000000
## Cycle 138 0.000000019524 0.00000011570 1.000000
## Cycle 139 0.000000016315 0.00000009854 1.000000
## Cycle 140 0.000000013627 0.00000008389 1.000000
## Cycle 141 0.000000011376 0.00000007139 1.000000
## Cycle 142 0.000000009492 0.00000006073 1.000000
## Cycle 143 0.000000007917 0.00000005164 1.000000
```

```r
#m_M_Exp
m_M_Exp
```

```
##                   PFS          OS     Dead
## Cycle 1   1.000000000 0.000000000 0.000000
## Cycle 2   0.986847718 0.010089266 0.003063
## Cycle 3   0.966063070 0.024463981 0.009473
## Cycle 4   0.941303760 0.039547468 0.019149
## Cycle 5   0.913886497 0.054185732 0.031928
## Cycle 6   0.884610488 0.067825095 0.047564
## Cycle 7   0.854041045 0.080189150 0.065770
## Cycle 8   0.822609378 0.091153683 0.086237
## Cycle 9   0.790658666 0.100684767 0.108657
## Cycle 10  0.758468968 0.108803903 0.132727
## Cycle 11  0.726272252 0.115566815 0.158161
## Cycle 12  0.694262227 0.121049930 0.184688
## Cycle 13  0.662601198 0.125341472 0.212057
## Cycle 14  0.631425102 0.128535501 0.240039
## Cycle 15  0.600847371 0.130727888 0.268425
## Cycle 16  0.570962002 0.132013591 0.297024
## Cycle 17  0.541846063 0.132484837 0.325669
## Cycle 18  0.513561800 0.132229928 0.354208
## Cycle 19  0.486158428 0.131332500 0.382509
## Cycle 20  0.459673687 0.129871081 0.410455
## Cycle 21  0.434135204 0.127918891 0.437946
## Cycle 22  0.409561707 0.125543783 0.464895
## Cycle 23  0.385964096 0.122808310 0.491228
## Cycle 24  0.363346414 0.119769857 0.516884
## Cycle 25  0.341706713 0.116480834 0.541812
## Cycle 26  0.321037838 0.112988902 0.565973
## Cycle 27  0.301328136 0.109337216 0.589335
## Cycle 28  0.282562099 0.105564686 0.611873
## Cycle 29  0.264720937 0.101706238 0.633573
## Cycle 30  0.247783105 0.097793078 0.654424
## Cycle 31  0.231724771 0.093852948 0.674422
## Cycle 32  0.216520246 0.089910377 0.693569
## Cycle 33  0.202142360 0.085986927 0.711871
## Cycle 34  0.188562803 0.082101422 0.729336
## Cycle 35  0.175752438 0.078270173 0.745977
## Cycle 36  0.163681562 0.074507186 0.761811
## Cycle 37  0.152320154 0.070824365 0.776855
## Cycle 38  0.141638086 0.067231696 0.791130
## Cycle 39  0.131605305 0.063737429 0.804657
## Cycle 40  0.122192001 0.060348239 0.817460
## Cycle 41  0.113368743 0.057069386 0.829562
## Cycle 42  0.105106600 0.053904853 0.840989
## Cycle 43  0.097377245 0.050857486 0.851765
## Cycle 44  0.090153038 0.047929116 0.861918
## Cycle 45  0.083407100 0.045120676 0.871472
## Cycle 46  0.077113368 0.042432306 0.880454
## Cycle 47  0.071246638 0.039863451 0.888890
## Cycle 48  0.065782603 0.037412953 0.896804
## Cycle 49  0.060697877 0.035079129 0.904223
## Cycle 50  0.055970010 0.032859853 0.911170
## Cycle 51  0.051577492 0.030752620 0.917670
## Cycle 52  0.047499764 0.028754609 0.923746
## Cycle 53  0.043717205 0.026862738 0.929420
## Cycle 54  0.040211127 0.025073721 0.934715
## Cycle 55  0.036963758 0.023384106 0.939652
## Cycle 56  0.033958230 0.021790320 0.944251
## Cycle 57  0.031178553 0.020288706 0.948533
## Cycle 58  0.028609593 0.018875553 0.952515
## Cycle 59  0.026237050 0.017547126 0.956216
## Cycle 60  0.024047426 0.016299692 0.959653
## Cycle 61  0.022028000 0.015129540 0.962842
## Cycle 62  0.020166800 0.014033002 0.965800
## Cycle 63  0.018452568 0.013006465 0.968541
## Cycle 64  0.016874735 0.012046390 0.971079
## Cycle 65  0.015423388 0.011149323 0.973427
## Cycle 66  0.014089239 0.010311900 0.975599
## Cycle 67  0.012863599 0.009530860 0.977606
## Cycle 68  0.011738344 0.008803047 0.979459
## Cycle 69  0.010705886 0.008125418 0.981169
## Cycle 70  0.009759150 0.007495045 0.982746
## Cycle 71  0.008891540 0.006909117 0.984199
## Cycle 72  0.008096914 0.006364940 0.985538
## Cycle 73  0.007369560 0.005859942 0.986770
## Cycle 74  0.006704169 0.005391667 0.987904
## Cycle 75  0.006095813 0.004957776 0.988946
## Cycle 76  0.005539918 0.004556048 0.989904
## Cycle 77  0.005032246 0.004184371 0.990783
## Cycle 78  0.004568872 0.003840749 0.991590
## Cycle 79  0.004146162 0.003523290 0.992331
## Cycle 80  0.003760759 0.003230209 0.993009
## Cycle 81  0.003409559 0.002959820 0.993631
## Cycle 82  0.003089698 0.002710537 0.994200
## Cycle 83  0.002798534 0.002480866 0.994721
## Cycle 84  0.002533631 0.002269404 0.995197
## Cycle 85  0.002292745 0.002074835 0.995632
## Cycle 86  0.002073812 0.001895923 0.996030
## Cycle 87  0.001874932 0.001731514 0.996394
## Cycle 88  0.001694361 0.001580525 0.996725
## Cycle 89  0.001530494 0.001441947 0.997028
## Cycle 90  0.001381860 0.001314838 0.997303
## Cycle 91  0.001247110 0.001198318 0.997555
## Cycle 92  0.001125005 0.001091569 0.997783
## Cycle 93  0.001014414 0.000993828 0.997992
## Cycle 94  0.000914299 0.000904387 0.998181
## Cycle 95  0.000823710 0.000822588 0.998354
## Cycle 96  0.000741779 0.000747821 0.998510
## Cycle 97  0.000667715 0.000679520 0.998653
## Cycle 98  0.000600792 0.000617159 0.998782
## Cycle 99  0.000540350 0.000560254 0.998899
## Cycle 100 0.000485786 0.000508355 0.999006
## Cycle 101 0.000436552 0.000461046 0.999102
## Cycle 102 0.000392146 0.000417946 0.999190
## Cycle 103 0.000352113 0.000378700 0.999269
## Cycle 104 0.000316038 0.000342982 0.999341
## Cycle 105 0.000283545 0.000310491 0.999406
## Cycle 106 0.000254291 0.000280952 0.999465
## Cycle 107 0.000227964 0.000254109 0.999518
## Cycle 108 0.000204281 0.000229729 0.999566
## Cycle 109 0.000182987 0.000207596 0.999609
## Cycle 110 0.000163848 0.000187514 0.999649
## Cycle 111 0.000146653 0.000169301 0.999684
## Cycle 112 0.000131213 0.000152791 0.999716
## Cycle 113 0.000117352 0.000137832 0.999745
## Cycle 114 0.000104916 0.000124284 0.999771
## Cycle 115 0.000093761 0.000112021 0.999794
## Cycle 116 0.000083761 0.000100926 0.999815
## Cycle 117 0.000074799 0.000090892 0.999834
## Cycle 118 0.000066771 0.000081821 0.999851
## Cycle 119 0.000059582 0.000073626 0.999867
## Cycle 120 0.000053148 0.000066224 0.999881
## Cycle 121 0.000047391 0.000059543 0.999893
## Cycle 122 0.000042242 0.000053514 0.999904
## Cycle 123 0.000037638 0.000048076 0.999914
## Cycle 124 0.000033525 0.000043174 0.999923
## Cycle 125 0.000029850 0.000038756 0.999931
## Cycle 126 0.000026568 0.000034776 0.999939
## Cycle 127 0.000023638 0.000031194 0.999945
## Cycle 128 0.000021024 0.000027969 0.999951
## Cycle 129 0.000018693 0.000025068 0.999956
## Cycle 130 0.000016614 0.000022459 0.999961
## Cycle 131 0.000014761 0.000020115 0.999965
## Cycle 132 0.000013110 0.000018008 0.999969
## Cycle 133 0.000011640 0.000016116 0.999972
## Cycle 134 0.000010331 0.000014417 0.999975
## Cycle 135 0.000009166 0.000012892 0.999978
## Cycle 136 0.000008130 0.000011525 0.999980
## Cycle 137 0.000007208 0.000010299 0.999982
## Cycle 138 0.000006389 0.000009199 0.999984
## Cycle 139 0.000005661 0.000008215 0.999986
## Cycle 140 0.000005014 0.000007333 0.999988
## Cycle 141 0.000004440 0.000006543 0.999989
## Cycle 142 0.000003930 0.000005836 0.999990
## Cycle 143 0.000003477 0.000005204 0.999991
```


```r
#06 Compute and Plot Epidemiological Outcomes

#06.1 Cohort trace

# So, we'll plot the above Markov model for standard of care (m_M_SoC) to show our cohort distribution over time, i.e. the proportion of our cohort in the different health states over time.

# If I wanted to do the same for exp, I would just copy this code chunk and replace m_M_SoC with m_M_Exp

# Here is the simplest code that would give me what I want:

# matplot(m_M_SoC, type = 'l', 
        # ylab = "Probability of state occupancy",
        # xlab = "Cycle",
        # main = "Cohort Trace", lwd = 3)  # create a plot of the data
# legend("right", v_names_states, col = c("black", "red", "green"), 
       # lty = 1:3, bty = "n")  # add a legend to the graph

# But I would like to add more:

# Plotting the Markov cohort traces
matplot(m_M_SoC, 
        type = "l", 
        ylab = "Probability of state occupancy",
        xlab = "Cycle",
        main = "Makrov Cohort Traces",
        lwd  = 3,
        lty  = 1) # create a plot of the data
matplot(m_M_Exp, 
        type = "l", 
        lwd  = 3,
        lty  = 3,
        add  = TRUE) # add a plot of the experimental data ontop of the above plot
legend("right", 
       legend = c(paste(v_names_states, "(SOC)"), paste(v_names_states, "(Exp)")), 
       col    = rep(c("black", "red", "green"), 2), 
       lty    = c(1, 1, 1, 3, 3, 3), # Line type, full (1) or dashed (3), I have entered this 6 times here because we have 3 lines under standard of care (3 full lines) and  3 lines under experimental treatment (3 dashed lines)
       lwd    = 3,
       bty    = "n")
```

<img src="Markov_3state_files/figure-html/unnamed-chunk-26-1.png" width="672" />

```r
#ggsave("Markov_Cohort_Traces.png", width = 4, height = 4, dpi=300)
#while (!is.null(dev.list()))  dev.off()
# png(paste("Markov_Cohort_Traces", ".png"))
# dev.off()

# plot a vertical line that helps identifying at which cycle the prevalence of OS is highest
#abline(v = which.max(m_M_SoC[, "OS"]), col = "gray")
#abline(v = which.max(m_M_Exp[, "OS"]), col = "black")
# The vertical line shows you when your progressed (OS) population is the greatest that it will ever be, but it can be changed from which.max to other things (so it is finding which cycle the proportion progressed is the highest and putting a vertical line there).
# (It's probably not necessary for my own analysis and I can comment these two lines out if I'm not going to use it).

# So, you can see in the graph everyone starts in the PFS state, but that this falls over time as people progress and leave this state, then you see OS start to peak up but then fall again as people leave this state to go into the dead state, which is an absorbing state and by the end will include everyone.
```


```r
#06.2 Overall Survival (OS)

# Although in the context of my analysis this would be PFS + OS because it is drawn from the DARTH model where healthy and sick make up OS, while dead means not OS (obviously).

# v_os <- 1 - m_M_SoC[, "Dead"]    # calculate the overall survival (OS) probability
# v_os <- rowSums(m_M_SoC[, 1:2])  # alternative way of calculating the OS probability

# I could do my own version of this and chose just to look at pfs, rather than column 1 and 2 to look at anyone not dead.

# i.e. v_os <- (m_M_SoC[, 1])

# best practice would be to rename v_os if I am looking at something that isnt os, i.e. v_pfs and to of course update the table legend, bearing in mind that yet again this is all for standard of care, and that if I wanted to know this for exp treatment I would need to replace the Markov model matrix above.


# plot(v_os, type = 'l', 
#     ylim = c(0, 1),
#     ylab = "Survival probability",
#     xlab = "Cycle",
#     main = "Overall Survival")  # create a simple plot showing the OS

# add grid 
# grid(nx = n_cycles, ny = 10, col = "lightgray", lty = "dotted", lwd = par("lwd"), 
#     equilogs = TRUE) 

# Calculating and plotting overal survival (OS)
v_OS_SoC <- 1 - m_M_SoC[, "Dead"]
v_OS_Exp <- 1 - m_M_Exp[, "Dead"]

plot(v_OS_SoC, 
     type = "l",
     ylim = c(0, 1),
     ylab = "Survival probability",
     xlab = "Cycle",
     main = "Overall Survival",
     lwd  = 3) # create a simple plot showing the OS
lines(v_OS_Exp,
      lty = 3,
      lwd = 3)
legend("right",
       legend = c("SoC", "Exp"),
       lty    = c(1, 3),
       lwd    = 3,
       bty    = "n")

# add grid - completely optional, see if it looks nicer to leave this code in or output:
grid(nx = n_cycle, ny = 10, col = "lightgray", lty = "dotted", lwd = par("lwd"), 
     equilogs = TRUE) 
```

<img src="Markov_3state_files/figure-html/unnamed-chunk-27-1.png" width="672" />

```r
# I don't end up using this, because I feel plotting the cohort trace is more descriptive, with PFS, OS and D included in it, but there still are some interesting things you could do with this in the future:

# Per C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Cost-Effectiveness and Decision Modeling using R Workshop \_ DARTH\August\_25\Live Session 

# Often you have a survival curve as input to your model [I guess from a published study], and having that survival curve you need to parameterise your model so that you match that survival curve, and that would be a process of, potentially of calibration, if you can't use the parameters directly in your model.

# So, you could produce your survival curve and compare it to curves from trials, etc., to calibrate your model.

# For calibration purposes, you want to make sure that your model is outputting something that's comparable to the publications out there on actual data on the same type of patients.

# Part of being comparable to the real world is that if there is a censoring process in actual patient data, then you could incorporate this process into the model to reflect that in your model and to ensure that your own model is comparable to the existing models which may be losing people due to censoring, etc., and which you'll then need to incorporate into your model to be comparable. 

# Another interesting thing you can do is, plot this to ask is that reasonable, does that make sense that this many people are alive after this amount of time? Is the OS what I would expect it to be?
```


```r
#06.2.1 Life Expectancy (LE)

v_le <- sum(v_OS_SoC)  # summing probability of OS over time  (i.e. life expectancy)

# Basically we are summing all the alive states over time through over all the cycles, so 

# v_os <- rowSums(m_M_SoC[, 1:2])

# Is basically the PFS and OS added together.

# Also bear in mind that this is life expectancy under standard of care, and not under the new treatments, per: # v_os <- rowSums(m_M_SoC[, 1:2]) above.

v_le
```

```
## [1] 20.7
```

```r
v_le_exp <- sum(v_OS_Exp)  # summing probability of OS over time  (i.e. life expectancy)

v_le_exp
```

```
## [1] 25.94
```

```r
# So, if this gives a value of [1] 20.70332, that is [1] 20.70332 cycles, where in the context of our model, cycles are fortnights, so the life expectancy for our population of patients is 20.70332 fortnights or 289.84648, in days:

daily_v_le <- v_le * 14
daily_v_le
```

```
## [1] 289.8
```

```r
daily_v_le_exp <- v_le_exp * 14
daily_v_le_exp
```

```
## [1] 363.2
```

```r
# When I calculate LE I calculate it in cycles. Note that my code gives a LE of 20.7 cycles for the SoC group which is approx. 290 days or 0.8 years.  Caculating the LE for the Exp group I calculated the corresponding figures as: 25.9 cycles = 363 days = 1 year (approx.). So a LE gain of about 0.2 life-years.


life_years_days_gained <- round(daily_v_le_exp - daily_v_le, digits=0)
# The number of days gained.

life_years_soc <- round(daily_v_le/365, digits=2)
# The proportion of a year you get under each treatment

life_years_exp <- round(daily_v_le_exp/365, digits=2)
# The proportion of a year you get under each treatment


# Discounted life expectancy:

# If you wanted discounted life expectancy, if you were using life years and you wanted them discounted for your health economic outcomes, you could apply the discount rates - the discount factors - to the vector for overall survival [v_os] and then take it's sum [add it up] as above to get life expectancy that is discounted.

# As per: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Cost-Effectiveness and Decision Modeling using R Workshop _ DARTH\August_25\Live Session 
```


```r
#06.3 Disease prevalence
# Disease prevalence is the proportion who are sick divided by the proportion who are alive, so it's necessary to account for the fact that some of the cohort have died, so you only calculate prevalence among people who are alive,in the diagram you can see it plateauing over time, even though the number of people in the OS (or "progressed") state have gone up and come down over time and this is because this is prevalence as a proportion of those who are alive, and there are few people who are still alive by cycle 60.

# Probably looks a bit funny dividing OS by v_os below, but it's necessary to remember that v_os is PFS + OS, because it's anyone who is not dead.

# So, I guess in our context you can think of this as progression prevalence (i.e. being in second line treatment) over time.

# I ultimately dont end up using this in my analysis:

v_prev <- m_M_SoC[, "OS"]/v_OS_SoC
plot(v_prev,
     ylim = c(0, 1),
     ylab = "Prevalence",
     xlab = "Cycle",
     main = "Disease prevalence")
```

<img src="Markov_3state_files/figure-html/unnamed-chunk-29-1.png" width="672" />


```r
#07 Compute Cost-Effectiveness Outcomes

#07.1 Including ADVERSE EVENTS in Mean Costs and QALYs for each strategy

# Calculate the costs and QALYs per cycle by multiplying m_M (the Markov trace) with the cost/utility vectors for the different states

# per cycle
# calculate expected costs by multiplying cohort trace with the cost vector for the different health states

# Basically, you take the cohort trace over time for each strategy [m_M_SoC] and multiply this by a vector of our costs for each state: [c(c_H, c_S, c_D)] -> So, basically the number of people in each state at each cycle multiplied by the cost of being in that state [cost of healthy, cost of sick and cost of dead] for each strategy that we look at (standard of care, experimental).

# Bear in mind we are doing matrix multiplication [%*%], because what this does is for each cycle [row in the matrix], take the vector of costs, and multiply it by the distribution in that cycle [breakdown of proportions in the states in that row] and add it all together, to get the total costs for that cycle [row]. This gives us a vector of the costs accrued in this cohort of individuals ending up in these different states for each cycle on a per person basis, because it's a cohort distribution (it always sums to 1).

# So, in cycle 1 everyone is in the PFS state, so they only incur the PFS cost, as more and more time passes and more and more people get sick, the costs increases due to more people being in the OS state, but over time this falls again as more and more people go into the dead state, which has no costs as we don't treat corpses.
  

# 1. Probability of adverse events 1,2 3 in the PFS state under standard of care and exp care:

# AE1:Leukopenia = 0.040 AE2:Diarrhea = 0.310 AE3:Vomiting = 0.31

p_FA1_STD     <- 0.040   # probability of adverse event 1 when progression-free under SOC
p_FA2_STD     <- 0.310   # probability of adverse event 2 when progression-free under SOC
p_FA3_STD     <- 0.310   # probability of adverse event 3 when progression-free under SOC

p_FA1_EXPR     <- 0.070   # probability of adverse event 1 when progression-free under EXPR
p_FA2_EXPR     <- 0.110   # probability of adverse event 2 when progression-free under EXPR
p_FA3_EXPR     <- 0.070   # probability of adverse event 3 when progression-free under EXPR

# 2. Cost of treating the AE conditional on it occurring
c_AE1 <- c_AE1
c_AE2 <- c_AE2
c_AE3 <- c_AE3 
#3. Disutiltiy of AE (negative qol impact x duration of event)


AE1_DisUtil <-0.45
AE2_DisUtil <-0.19
AE3_DisUtil <-0.36

daily_utility <- u_F/14
AE1_discounted_daily_utility <- daily_utility * (1-AE1_DisUtil)
AE2_discounted_daily_utility <- daily_utility * (1-AE2_DisUtil)
AE3_discounted_daily_utility <- daily_utility * (1-AE3_DisUtil)


u_AE1 <- (AE1_discounted_daily_utility*7) + (daily_utility*7)
u_AE2 <- (AE2_discounted_daily_utility*7) + (daily_utility*7)
u_AE3 <- (AE3_discounted_daily_utility*7) + (daily_utility*7)


# I then adjust my state costs and utilities:

# uState<-uState-pAE1*duAE1


c_F_SoC<-c_F_SoC +p_FA1_STD*c_AE1 +p_FA2_STD*c_AE2 +p_FA3_STD*c_AE3
c_F_Exp<-c_F_Exp +p_FA1_EXPR*c_AE1 +p_FA2_EXPR*c_AE2 +p_FA3_EXPR*c_AE3


u_F_SoC<-u_F
u_F_Exp<-u_F


u_F_SoC<-u_F-p_FA1_STD*u_AE1 -p_FA2_STD*u_AE2 -p_FA3_STD*u_AE3
u_F_Exp<-u_F-p_FA1_EXPR*u_AE1 -p_FA2_EXPR*u_AE2 -p_FA3_EXPR*u_AE3


v_tc_SoC <- m_M_SoC %*% c(c_F_SoC, c_P, c_D)
v_tc_Exp <- m_M_Exp %*% c(c_F_Exp, c_P, c_D)

v_tc_SoC
```

```
##                   [,1]
## Cycle 1   982.65890000
## Cycle 2   970.22762186
## Cycle 3   949.70624325
## Cycle 4   924.18278640
## Cycle 5   894.92220044
## Cycle 6   862.81589898
## Cycle 7   828.58102591
## Cycle 8   792.82326037
## Cycle 9   756.06348388
## Cycle 10  718.75183016
## Cycle 11  681.27659896
## Cycle 12  643.97084490
## Cycle 13  607.11780933
## Cycle 14  570.95570903
## Cycle 15  535.68211461
## Cycle 16  501.45802372
## Cycle 17  468.41167511
## Cycle 18  436.64212259
## Cycle 19  406.22257598
## Cycle 20  377.20351202
## Cycle 21  349.61555728
## Cycle 22  323.47214618
## Cycle 23  298.77195859
## Cycle 24  275.50114321
## Cycle 25  253.63533447
## Cycle 26  233.14147184
## Cycle 27  213.97943148
## Cycle 28  196.10348103
## Cycle 29  179.46356865
## Cycle 30  164.00645774
## Cycle 31  149.67671876
## Cycle 32  136.41758974
## Cycle 33  124.17171637
## Cycle 34  112.88178273
## Cycle 35  102.49104283
## Cycle 36   92.94376301
## Cycle 37   84.18558445
## Cycle 38   76.16381462
## Cycle 39   68.82765586
## Cycle 40   62.12837863
## Cycle 41   56.01944656
## Cycle 42   50.45659959
## Cycle 43   45.39790115
## Cycle 44   40.80375464
## Cycle 45   36.63689411
## Cycle 46   32.86235328
## Cycle 47   29.44741690
## Cycle 48   26.36155781
## Cycle 49   23.57636261
## Cycle 50   21.06544880
## Cycle 51   18.80437545
## Cycle 52   16.77054955
## Cycle 53   14.94312965
## Cycle 54   13.30292834
## Cycle 55   11.83231468
## Cycle 56   10.51511764
## Cycle 57    9.33653149
## Cycle 58    8.28302356
## Cycle 59    7.34224517
## Cycle 60    6.50294601
## Cycle 61    5.75489222
## Cycle 62    5.08878849
## Cycle 63    4.49620428
## Cycle 64    3.96950411
## Cycle 65    3.50178213
## Cycle 66    3.08680071
## Cycle 67    2.71893313
## Cycle 68    2.39311025
## Cycle 69    2.10477083
## Cycle 70    1.84981573
## Cycle 71    1.62456536
## Cycle 72    1.42572062
## Cycle 73    1.25032692
## Cycle 74    1.09574110
## Cycle 75    0.95960121
## Cycle 76    0.83979885
## Cycle 77    0.73445390
## Cycle 78    0.64189153
## Cycle 79    0.56062130
## Cycle 80    0.48931818
## Cycle 81    0.42680531
## Cycle 82    0.37203847
## Cycle 83    0.32409195
## Cycle 84    0.28214591
## Cycle 85    0.24547492
## Cycle 86    0.21343764
## Cycle 87    0.18546760
## Cycle 88    0.16106487
## Cycle 89    0.13978865
## Cycle 90    0.12125057
## Cycle 91    0.10510878
## Cycle 92    0.09106258
## Cycle 93    0.07884770
## Cycle 94    0.06823210
## Cycle 95    0.05901213
## Cycle 96    0.05100927
## Cycle 97    0.04406709
## Cycle 98    0.03804868
## Cycle 99    0.03283422
## Cycle 100   0.02831902
## Cycle 101   0.02441159
## Cycle 102   0.02103210
## Cycle 103   0.01811090
## Cycle 104   0.01558727
## Cycle 105   0.01340835
## Cycle 106   0.01152810
## Cycle 107   0.00990648
## Cycle 108   0.00850867
## Cycle 109   0.00730446
## Cycle 110   0.00626757
## Cycle 111   0.00537524
## Cycle 112   0.00460771
## Cycle 113   0.00394788
## Cycle 114   0.00338093
## Cycle 115   0.00289403
## Cycle 116   0.00247609
## Cycle 117   0.00211753
## Cycle 118   0.00181006
## Cycle 119   0.00154654
## Cycle 120   0.00132078
## Cycle 121   0.00112748
## Cycle 122   0.00096204
## Cycle 123   0.00082052
## Cycle 124   0.00069952
## Cycle 125   0.00059610
## Cycle 126   0.00050776
## Cycle 127   0.00043233
## Cycle 128   0.00036795
## Cycle 129   0.00031302
## Cycle 130   0.00026619
## Cycle 131   0.00022627
## Cycle 132   0.00019227
## Cycle 133   0.00016331
## Cycle 134   0.00013865
## Cycle 135   0.00011767
## Cycle 136   0.00009983
## Cycle 137   0.00008466
## Cycle 138   0.00007177
## Cycle 139   0.00006082
## Cycle 140   0.00005152
## Cycle 141   0.00004363
## Cycle 142   0.00003693
## Cycle 143   0.00003125
```

```r
v_tc_Exp
```

```
##                 [,1]
## Cycle 1   2330.82820
## Cycle 2   2304.75826
## Cycle 3   2262.84642
## Cycle 4   2211.99246
## Cycle 5   2154.74092
## Cycle 6   2092.70293
## Cycle 7   2027.07052
## Cycle 8   1958.79231
## Cycle 9   1888.65276
## Cycle 10  1817.31441
## Cycle 11  1745.34327
## Cycle 12  1673.22559
## Cycle 13  1601.37976
## Cycle 14  1530.16539
## Cycle 15  1459.89044
## Cycle 16  1390.81715
## Cycle 17  1323.16709
## Cycle 18  1257.12547
## Cycle 19  1192.84502
## Cycle 20  1130.44940
## Cycle 21  1070.03627
## Cycle 22  1011.68014
## Cycle 23   955.43483
## Cycle 24   901.33586
## Cycle 25   849.40251
## Cycle 26   799.63976
## Cycle 27   752.04007
## Cycle 28   706.58497
## Cycle 29   663.24654
## Cycle 30   621.98876
## Cycle 31   582.76867
## Cycle 32   545.53756
## Cycle 33   510.24189
## Cycle 34   476.82424
## Cycle 35   445.22410
## Cycle 36   415.37861
## Cycle 37   387.22320
## Cycle 38   360.69220
## Cycle 39   335.71929
## Cycle 40   312.23804
## Cycle 41   290.18224
## Cycle 42   269.48626
## Cycle 43   250.08537
## Cycle 44   231.91599
## Cycle 45   214.91587
## Cycle 46   199.02434
## Cycle 47   184.18241
## Cycle 48   170.33288
## Cycle 49   157.42049
## Cycle 50   145.39194
## Cycle 51   134.19595
## Cycle 52   123.78333
## Cycle 53   114.10695
## Cycle 54   105.12174
## Cycle 55    96.78471
## Cycle 56    89.05494
## Cycle 57    81.89347
## Cycle 58    75.26336
## Cycle 59    69.12958
## Cycle 60    63.45895
## Cycle 61    58.22016
## Cycle 62    53.38363
## Cycle 63    48.92146
## Cycle 64    44.80743
## Cycle 65    41.01686
## Cycle 66    37.52656
## Cycle 67    34.31481
## Cycle 68    31.36122
## Cycle 69    28.64675
## Cycle 70    26.15355
## Cycle 71    23.86498
## Cycle 72    21.76551
## Cycle 73    19.84064
## Cycle 74    18.07689
## Cycle 75    16.46170
## Cycle 76    14.98341
## Cycle 77    13.63118
## Cycle 78    12.39495
## Cycle 79    11.26540
## Cycle 80    10.23388
## Cycle 81     9.29239
## Cycle 82     8.43355
## Cycle 83     7.65051
## Cycle 84     6.93695
## Cycle 85     6.28705
## Cycle 86     5.69543
## Cycle 87     5.15715
## Cycle 88     4.66764
## Cycle 89     4.22271
## Cycle 90     3.81850
## Cycle 91     3.45146
## Cycle 92     3.11833
## Cycle 93     2.81614
## Cycle 94     2.54214
## Cycle 95     2.29381
## Cycle 96     2.06886
## Cycle 97     1.86518
## Cycle 98     1.68085
## Cycle 99     1.51411
## Cycle 100    1.36334
## Cycle 101    1.22708
## Cycle 102    1.10399
## Cycle 103    0.99284
## Cycle 104    0.89252
## Cycle 105    0.80202
## Cycle 106    0.72041
## Cycle 107    0.64684
## Cycle 108    0.58056
## Cycle 109    0.52087
## Cycle 110    0.46713
## Cycle 111    0.41877
## Cycle 112    0.37528
## Cycle 113    0.33617
## Cycle 114    0.30103
## Cycle 115    0.26946
## Cycle 116    0.24111
## Cycle 117    0.21566
## Cycle 118    0.19282
## Cycle 119    0.17234
## Cycle 120    0.15398
## Cycle 121    0.13752
## Cycle 122    0.12278
## Cycle 123    0.10958
## Cycle 124    0.09776
## Cycle 125    0.08719
## Cycle 126    0.07773
## Cycle 127    0.06928
## Cycle 128    0.06172
## Cycle 129    0.05496
## Cycle 130    0.04893
## Cycle 131    0.04355
## Cycle 132    0.03874
## Cycle 133    0.03446
## Cycle 134    0.03063
## Cycle 135    0.02723
## Cycle 136    0.02419
## Cycle 137    0.02148
## Cycle 138    0.01907
## Cycle 139    0.01693
## Cycle 140    0.01502
## Cycle 141    0.01332
## Cycle 142    0.01181
## Cycle 143    0.01047
```

```r
# The below is how I would probably add a once off treatment cost in if I had to:

# v_tc_SoC  <- m_M_SoC  %*% c(c_H, c_S, c_D)  
# v_tc_trtA <- m_M_trtA %*% c(c_H + c_trtA, c_S, c_D)  
# v_tc_trtB <- m_M_trtB %*% c(c_H + c_trtB, c_S, c_D)





# calculate expected QALYs by multiplying cohort trace with the utilities for the different health states 

# The vector of utilities is basically built in the exact same way as the vector of costs above:

# v_tu_SoC  <- m_M_SoC  %*% c(u_H, u_S, u_D)  


# The file I am mirroring has the following qoute:

# "

# - note that to obtain QALYs, the utility needs to be mutiplied by the cycle length as well


# v_tu_SoC <- m_M_SoC %*% c(u_F, u_P, u_D) * t_cycle
# v_tu_Exp <- m_M_Exp %*% c(u_F, u_P, u_D) * t_cycle

# To get the QALY's we not only need to multiply the state occupancy with the utilities, but also with the duration of the time cycle, because QALY's are 2-dimensional in that they combine the duration of time and the health utility.

# "

# Maybe that's because the utility originally came from a year in the disease state, and we want it to reflect the proportion of a year that is our cycle length?

# So in the example t_cycle <- 1/4 # cycle length of 3 months (in years) - so maybe their utility originally came from a years utility and they wanted to decrease it to 3 months, aka the cycle lengths, utility.

# If that was the case it would be:

# A year of utility in this state is 0.75, so 3 months should be a quarter of this, should be 0.25 of this. So, t_cycle (0.25) * u_F (0.75) = 0.1875 i.e. your utility for 3 months if u_F is your utility for 12 months.

# v_tu_SoC <- m_M_SoC %*% c(u_F, u_P, u_D) * t_cycle

# I did the maths on his approach, and without *t_cycle the first cycle of each utility value is 0.8, but after *t_cycle it is 0.2, i.e. a quarter of what it was before. Which is why I think again that he is just making the yearly utility lower to match the 3 monthly cycles, i.e. quartering a yearly utility. A quarter of utility for a quarter of a year.

# So, I think he's just trying to generate the QALYs per cycle in both states.

# And slide 25 of C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Health Economic Modeling in R A Hands-on Introduction\Health-Eco\Markov models kind of proves that.

# In it they say: cycles are 6 months.

# Their R code in: 

# C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Health Economic Modeling in R A Hands-on Introduction\Health-Eco\Markov models\markov_smoking_deterministic.R

# Says:

# Now define the QALYS associated with the states per cycle

# QALY associated with 1 - year in the smoking state is Normal(mean = 0.95,  SD = 0.01)
# Divide by 2 as cycle length is 6 months
# state_qalys["Smoking"] <-  0.95 / 2 [I know they divide by 2 but we could have also multiplied by a half, i.e. *0.05].

# QALY associated with 1 - year in the not smoking state is 1 (no uncertainty)
# So all PSA samples have the same value
# Again divide by 2 as cycle length is 6 months
# state_qalys["Not smoking"] <-  1.0 / 2

# I like their approach, they define utility at the start, then they can do the following:

		# Now use the cohort vectors to calculate the 
		# total QALYs for each cycle
		# cycle_qalys[i_treatment, ] <-  cohort_vectors[i_treatment, , ] %*% state_qalys[]

# i.e., take the cohort (or Markov trace) for each of the treatment options and multiply it by the state qalys.

# So, I could take where he says: "QALY's are 2-dimensional in that they combine the duration of time and the health utility." as saying "we need to give the patient a utility for this health state that matches how long they were in this health state, i.e., if the utility of one year in this state is x and we know the patient was in this health state for 2 weeks, then we need to give them 2 weeks of x as their utility."


# Andrew calculated QALYs as: 
#
# QALYs.SP0 <- trace.SP0%*%state.utilities
# QALYs.SP0
# 
# undisc.QALYs.SP0 <- colSums(QALYs.SP0)
# undisc.QALYs.SP0

# However, he described the values that he started off with as:

# The quality of life utilities of a year spent in each of the model health states has been
# estimated to be 0.85, 0.3 and 0.75 for the Successful primary, Revision, and Successful revision health states respectively.

# and said the cycle length is one year, so maybe that's why he doesnt need to multiply by the time passed, because his utilities are for a year spent in this state, whereas when we start our utilies may not necessarily match.

# So, what I think this means is that provided utilities are for the period of the cycle we can do the below, and if they are not for the period of the cycle then we can just convert them like in the smoking file above and then apply them as though they are for the period of the cycle:




v_tu_SoC <- m_M_SoC %*% c(u_F_SoC, u_P, u_D)
v_tu_Exp <- m_M_Exp %*% c(u_F_Exp, u_P, u_D)

v_tu_SoC
```

```
##                    [,1]
## Cycle 1   0.36911250000
## Cycle 2   0.37152532212
## Cycle 3   0.37380813765
## Cycle 4   0.37455093073
## Cycle 5   0.37339161497
## Cycle 6   0.37026814369
## Cycle 7   0.36526071093
## Cycle 8   0.35852361697
## Cycle 9   0.35024893061
## Cycle 10  0.34064506422
## Cycle 11  0.32992349860
## Cycle 12  0.31829039987
## Cycle 13  0.30594135639
## Cycle 14  0.29305818610
## Cycle 15  0.27980715316
## Cycle 16  0.26633815762
## Cycle 17  0.25278460046
## Cycle 18  0.23926371550
## Cycle 19  0.22587721924
## Cycle 20  0.21271217070
## Cycle 21  0.19984196228
## Cycle 22  0.18732738394
## Cycle 23  0.17521771760
## Cycle 24  0.16355183091
## Cycle 25  0.15235924731
## Cycle 26  0.14166117640
## Cycle 27  0.13147149326
## Cycle 28  0.12179765925
## Cycle 29  0.11264157987
## Cycle 30  0.10400039729
## Cycle 31  0.09586721703
## Cycle 32  0.08823176965
## Cycle 33  0.08108100900
## Cycle 34  0.07439964965
## Cycle 35  0.06817064642
## Cycle 36  0.06237561927
## Cycle 37  0.05699522722
## Cycle 38  0.05200949482
## Cycle 39  0.04739809502
## Cycle 40  0.04314059192
## Cycle 41  0.03921664710
## Cycle 42  0.03560619293
## Cycle 43  0.03228957619
## Cycle 44  0.02924767507
## Cycle 45  0.02646199252
## Cycle 46  0.02391472876
## Cycle 47  0.02158883536
## Cycle 48  0.01946805336
## Cycle 49  0.01753693752
## Cycle 50  0.01578086875
## Cycle 51  0.01418605633
## Cycle 52  0.01273953173
## Cycle 53  0.01142913534
## Cycle 54  0.01024349738
## Cycle 55  0.00917201429
## Cycle 56  0.00820482135
## Cycle 57  0.00733276269
## Cycle 58  0.00654735919
## Cycle 59  0.00584077514
## Cycle 60  0.00520578410
## Cycle 61  0.00463573445
## Cycle 62  0.00412451516
## Cycle 63  0.00366652186
## Cycle 64  0.00325662380
## Cycle 65  0.00289013162
## Cycle 66  0.00256276632
## Cycle 67  0.00227062946
## Cycle 68  0.00201017467
## Cycle 69  0.00177818061
## Cycle 70  0.00157172536
## Cycle 71  0.00138816226
## Cycle 72  0.00122509720
## Cycle 73  0.00108036742
## Cycle 74  0.00095202160
## Cycle 75  0.00083830143
## Cycle 76  0.00073762445
## Cycle 77  0.00064856815
## Cycle 78  0.00056985532
## Cycle 79  0.00050034048
## Cycle 80  0.00043899749
## Cycle 81  0.00038490808
## Cycle 82  0.00033725143
## Cycle 83  0.00029529457
## Cycle 84  0.00025838368
## Cycle 85  0.00022593610
## Cycle 86  0.00019743315
## Cycle 87  0.00017241352
## Cycle 88  0.00015046731
## Cycle 89  0.00013123070
## Cycle 90  0.00011438099
## Cycle 91  0.00009963230
## Cycle 92  0.00008673152
## Cycle 93  0.00007545481
## Cycle 94  0.00006560434
## Cycle 95  0.00005700546
## Cycle 96  0.00004950409
## Cycle 97  0.00004296442
## Cycle 98  0.00003726683
## Cycle 99  0.00003230606
## Cycle 100 0.00002798955
## Cycle 101 0.00002423598
## Cycle 102 0.00002097395
## Cycle 103 0.00001814084
## Cycle 104 0.00001568172
## Cycle 105 0.00001354853
## Cycle 106 0.00001169915
## Cycle 107 0.00001009678
## Cycle 108 0.00000870922
## Cycle 109 0.00000750839
## Cycle 110 0.00000646973
## Cycle 111 0.00000557186
## Cycle 112 0.00000479613
## Cycle 113 0.00000412630
## Cycle 114 0.00000354822
## Cycle 115 0.00000304960
## Cycle 116 0.00000261976
## Cycle 117 0.00000224939
## Cycle 118 0.00000193045
## Cycle 119 0.00000165593
## Cycle 120 0.00000141976
## Cycle 121 0.00000121671
## Cycle 122 0.00000104220
## Cycle 123 0.00000089231
## Cycle 124 0.00000076363
## Cycle 125 0.00000065320
## Cycle 126 0.00000055849
## Cycle 127 0.00000047730
## Cycle 128 0.00000040773
## Cycle 129 0.00000034815
## Cycle 130 0.00000029714
## Cycle 131 0.00000025350
## Cycle 132 0.00000021618
## Cycle 133 0.00000018427
## Cycle 134 0.00000015701
## Cycle 135 0.00000013372
## Cycle 136 0.00000011384
## Cycle 137 0.00000009688
## Cycle 138 0.00000008241
## Cycle 139 0.00000007007
## Cycle 140 0.00000005956
## Cycle 141 0.00000005061
## Cycle 142 0.00000004298
## Cycle 143 0.00000003649
```

```r
v_tu_Exp
```

```
##                  [,1]
## Cycle 1   0.670480000
## Cycle 2   0.668219681
## Cycle 3   0.663627555
## Cycle 4   0.656831199
## Cycle 5   0.647963345
## Cycle 6   0.637199952
## Cycle 7   0.624740387
## Cycle 8   0.610793030
## Cycle 9   0.595565921
## Cycle 10  0.579260810
## Cycle 11  0.562069449
## Cycle 12  0.544171393
## Cycle 13  0.525732808
## Cycle 14  0.506905978
## Cycle 15  0.487829273
## Cycle 16  0.468627437
## Cycle 17  0.449412092
## Cycle 18  0.430282369
## Cycle 19  0.411325628
## Cycle 20  0.392618216
## Cycle 21  0.374226251
## Cycle 22  0.356206392
## Cycle 23  0.338606609
## Cycle 24  0.321466911
## Cycle 25  0.304820059
## Cycle 26  0.288692236
## Cycle 27  0.273103679
## Cycle 28  0.258069282
## Cycle 29  0.243599149
## Cycle 30  0.229699117
## Cycle 31  0.216371241
## Cycle 32  0.203614240
## Cycle 33  0.191423912
## Cycle 34  0.179793513
## Cycle 35  0.168714107
## Cycle 36  0.158174884
## Cycle 37  0.148163454
## Cycle 38  0.138666106
## Cycle 39  0.129668054
## Cycle 40  0.121153649
## Cycle 41  0.113106576
## Cycle 42  0.105510027
## Cycle 43  0.098346861
## Cycle 44  0.091599735
## Cycle 45  0.085251232
## Cycle 46  0.079283970
## Cycle 47  0.073680689
## Cycle 48  0.068424339
## Cycle 49  0.063498147
## Cycle 50  0.058885677
## Cycle 51  0.054570880
## Cycle 52  0.050538138
## Cycle 53  0.046772292
## Cycle 54  0.043258675
## Cycle 55  0.039983129
## Cycle 56  0.036932022
## Cycle 57  0.034092255
## Cycle 58  0.031451269
## Cycle 59  0.028997049
## Cycle 60  0.026718118
## Cycle 61  0.024603535
## Cycle 62  0.022642887
## Cycle 63  0.020826280
## Cycle 64  0.019144326
## Cycle 65  0.017588133
## Cycle 66  0.016149288
## Cycle 67  0.014819845
## Cycle 68  0.013592305
## Cycle 69  0.012459605
## Cycle 70  0.011415094
## Cycle 71  0.010452526
## Cycle 72  0.009566030
## Cycle 73  0.008750105
## Cycle 74  0.007999595
## Cycle 75  0.007309675
## Cycle 76  0.006675835
## Cycle 77  0.006093862
## Cycle 78  0.005559824
## Cycle 79  0.005070057
## Cycle 80  0.004621149
## Cycle 81  0.004209924
## Cycle 82  0.003833430
## Cycle 83  0.003488924
## Cycle 84  0.003173862
## Cycle 85  0.002885882
## Cycle 86  0.002622799
## Cycle 87  0.002382588
## Cycle 88  0.002163376
## Cycle 89  0.001963431
## Cycle 90  0.001781154
## Cycle 91  0.001615069
## Cycle 92  0.001463813
## Cycle 93  0.001326133
## Cycle 94  0.001200871
## Cycle 95  0.001086963
## Cycle 96  0.000983432
## Cycle 97  0.000889377
## Cycle 98  0.000803972
## Cycle 99  0.000726459
## Cycle 100 0.000656140
## Cycle 101 0.000592379
## Cycle 102 0.000534591
## Cycle 103 0.000482240
## Cycle 104 0.000434836
## Cycle 105 0.000391931
## Cycle 106 0.000353116
## Cycle 107 0.000318016
## Cycle 108 0.000286290
## Cycle 109 0.000257626
## Cycle 110 0.000231741
## Cycle 111 0.000208374
## Cycle 112 0.000187289
## Cycle 113 0.000168273
## Cycle 114 0.000151129
## Cycle 115 0.000135679
## Cycle 116 0.000121762
## Cycle 117 0.000109231
## Cycle 118 0.000097953
## Cycle 119 0.000087806
## Cycle 120 0.000078680
## Cycle 121 0.000070477
## Cycle 122 0.000063106
## Cycle 123 0.000056485
## Cycle 124 0.000050540
## Cycle 125 0.000045205
## Cycle 126 0.000040418
## Cycle 127 0.000036125
## Cycle 128 0.000032276
## Cycle 129 0.000028827
## Cycle 130 0.000025738
## Cycle 131 0.000022972
## Cycle 132 0.000020495
## Cycle 133 0.000018280
## Cycle 134 0.000016298
## Cycle 135 0.000014526
## Cycle 136 0.000012942
## Cycle 137 0.000011527
## Cycle 138 0.000010263
## Cycle 139 0.000009135
## Cycle 140 0.000008128
## Cycle 141 0.000007230
## Cycle 142 0.000006428
## Cycle 143 0.000005714
```

```r
# BUT, we need to remember that the above displays the amount of utilitie's gathered in each cycle.

sum(v_tu_SoC)
```

```
## [1] 8.923
```

```r
sum(v_tu_Exp)
```

```
## [1] 17.3
```

```r
# Particularly, these are quality adjusted cycles, these are quality adjusted life years where cycles are annual, so I need to consider what this means for utility where cycles are monthly, or fortnightly.

# When I calculate the QALYs above, I don’t convert these quality adjusted cycles to years. If I sum each of v_tu_SoC and v_tu_Exp I get 16.7 quality adjusted cycles in the SoC arm and 21.1 quality adjusted cycles in the Exp arm. I can convert these quality adjusted cycles to years for fortnights by working out how many fortnights there are in a year (26.0714) and then divide by this number. These correspond to 0.64 and 0.81 QALYs respectively so 0.17 QALYs gained.

v_tu_SoC <- v_tu_SoC/26.0714
v_tu_Exp <- v_tu_Exp/26.0714

# So, these are initially per-cycle utility values, but, our cycles aren't years, they are fortnights, so these are per fortnight values, if we want this value to reflect the per year value, so that we have a quality adjusted life year, or QALY, then we need to adjust this utility value by how many of these fortnights there are in a year (26.0714), that is divide by how many fortnights there are in a year to bring the per fortnight value to a per year value


# James, I'd like your thoughts on what I've done here and whether this seems reasonable.


sum(v_tu_SoC)
```

```
## [1] 0.3423
```

```r
sum(v_tu_Exp)
```

```
## [1] 0.6635
```

```r
# QALYS Gained:

Qalys_gained <- v_tu_Exp - v_tu_SoC
sum(Qalys_gained)
```

```
## [1] 0.3213
```

```r
# You can see above that there are no utility differences between the different treatments considered: c(u_H, u_S, u_D), it's just different utilities per the health states people are in.

# If we did want to do different utilities for the health state you are in per the treatment you are on, we could define this in the input parameters and then add this in above when creating the vector of utilities for that treatment.

sum(v_tc_SoC)
```

```
## [1] 17935
```

```r
sum(v_tc_Exp)
```

```
## [1] 51787
```

```r
# The question is, should I be making that similar conversion of cycles to years for costs? I could do this as below: 

# v_tc_SoC <- v_tc_SoC/26.0714
# v_tc_Exp <- v_tc_Exp/26.0714
# 
# sum(v_tc_SoC)
# sum(v_tc_Exp)


# But, I assume my costs could be correct, if I correctly defined my costs per cycle.

# This is probably where I would like some feedback, is the manner in which I generate my costs (particularly) and QALYs above, correct?


# Reviewing the literature, the fact that: Goldstein, D. A., Chen, Q., Ayer, T., Howard, D. H., Lipscomb, J., El-Rayes, B. F., & Flowers, C. R. (2015). First-and second-line bevacizumab in addition to chemotherapy for metastatic colorectal cancer: a United States–based cost-effectiveness analysis. Journal of Clinical Oncology, 33(10), 1112. has similar costs, QALYS and Life Years gained and reports similar ICERs (the $352,734/QALY in the UK, which is similar to my own several hundred thousand per QALY without dividing costs by 26.0714 and dissimilar to my ~18,000 per QALY when I divide costs by 26.0714 makes me think I shouldnt be dividing costs by 26.0714).
```


```r
#07.2 Discounted Mean Costs and QALYs

# Finally, we'll aggregate these costs and utilities into overall discounted mean (average) costs and utilities.

# Obtain the discounted costs and QALYs by multiplying the vectors of total cost and total utility we created above by the discount rate for each cycle:

# Its important to remember what scale I'm on when I applied my discounting formula.
# If I set d_e<-0 then my code estimates 16.7 and 21.1 QALYs in each group which must be the quality adjusted cycles.

# Setting the discount rate back to 4% gives me 1.97 and 1.98 QALYs (which are really QA-cycles).

# Looking at the discounting vector I have defined below, I have converted cycles to days but I need to convert the discount rate to a daily discount. If I don't, the result is that discounting reduces the cycles dramatically which reduces the difference which increases with time.

# I can adress this by defining the discount rate as divided by 365 (i.e. the number of days in a year) then the results become 16.4 and 20.6 QA-cycles which of course become 0.63 and 0.79 QALYs respectively, or 0.16 QALYs gained.

d_c <- d_c/365
d_e <- d_e/365

# - Then, the discount rate for each cycle needs to be defined accounting for the cycle length, as below:


v_dwc <- 1 / ((1 + d_c) ^ ((0:(n_cycle-1)) * t_cycle)) 
v_dwe <- 1 / ((1 + d_e) ^ ((0:(n_cycle-1)) * t_cycle))


# So, below we take the vector of costs, transposing it [the t() bit] to make it a 1 row matrix and using matrix multiplication [%*%] to multiply it by that discount factor vector, which is what you multiply by the outcome in each cycle to get the discounted value of the outcome for that cycle, and then it will all be summed all together across all cycles [across all cells of the 1 row matrix]. Giving you tc_d_SoC which is a scalar, or a single value, which is the lifetime expected cost for an average person under standard of care in this cohort. 

# Discount costs by multiplying the cost vector with discount weights (v_dwc) 
# tc_d_SoC  <-  t(v_tc_SoC)  %*% v_dwc
# tc_d_trtA <-  t(v_tc_trtA) %*% v_dwc
# tc_d_trtB <-  t(v_tc_trtB) %*% v_dwc

tc_d_SoC <-  t(v_tc_SoC) %*% v_dwc 
tc_d_Exp <-  t(v_tc_Exp) %*% v_dwc


# So, now we have the average cost per person for treatment with standard of care, and the experimental treatment. 


# Discount QALYS by multiplying the QALYs vector with discount weights (v_dwe) [probably utilities would have been a better term here, if I hadnt of updated it from fortnightly health state quality of life, to yearly health state quality of life]

tu_d_SoC <-  t(v_tu_SoC) %*% v_dwe
tu_d_Exp <-  t(v_tu_Exp) %*% v_dwe


# Store them into a vector -> So, we'll take the single values for cost for an average person under standard of care and the experimental treatment and store them in a vector v_tc_d:
v_tc_d <- c(tc_d_SoC, tc_d_Exp)
v_tu_d <- c(tu_d_SoC, tu_d_Exp)

v_tc_d
```

```
## [1] 17591 50540
```

```r
v_tu_d
```

```
## [1] 0.3346 0.6462
```

```r
# To make things a little easier to read we might name these values what they are costs for, so we can use the vector of strategy names [v_names_str] to name the values:

names (v_tc_d) <- v_names_strats
v_tc_d
```

```
##       Standard of Care Experimental Treatment 
##                  17591                  50540
```

```r
names (v_tu_d) <- v_names_strats
v_tu_d
```

```
##       Standard of Care Experimental Treatment 
##                 0.3346                 0.6462
```

```r
Discounted_Qalys_gained <- tu_d_Exp - tu_d_SoC
sum(Discounted_Qalys_gained)
```

```
## [1] 0.3115
```

```r
# For utility, the utility values aren't different for the different states depending on the treatment strategy, i.e. SOC, Experimental Treatment, but the time spent in the states with the associated utility is different due to the treatment you're on, so your utility value will be higher if the treatment keeps you well for longer so that you stay in a higher utility state for longer than a lower utility state, i.e., progression.


# Dataframe with discounted costs and effectiveness

# So then we aggregate them into a dataframe with our discounted costs and utilities, and then we use this to calculate ICERs in: ## 07.3 Compute ICERs of the Markov model

# df_ce <- data.frame(Strategy = v_names_strats,
#                     Cost     = v_tc_d, 
#                     Effect   = v_tu_d)
# df_ce
```


```r
#07.3 Compute ICERs of the Markov model

# The discounted costs and QALYs can be summarized and visualized using functions from the 'dampack' package
(df_cea <- calculate_icers(cost       = c(tc_d_SoC, tc_d_Exp),
                           effect     = c(tu_d_SoC, tu_d_Exp),
                           strategies = v_names_strats))
```

```
##                 Strategy  Cost Effect Inc_Cost Inc_Effect   ICER Status
## 1       Standard of Care 17591 0.3346       NA         NA     NA     ND
## 2 Experimental Treatment 50540 0.6462    32949     0.3115 105767     ND
```

```r
df_cea
```

```
##                 Strategy  Cost Effect Inc_Cost Inc_Effect   ICER Status
## 1       Standard of Care 17591 0.3346       NA         NA     NA     ND
## 2 Experimental Treatment 50540 0.6462    32949     0.3115 105767     ND
```

```r
# df_cea <- calculate_icers(cost       = df_ce$Cost,
#                           effect     = df_ce$Effect,
#                           strategies = df_ce$Strategy
#                           )
# df_cea

# The above uses the DARTHtools package to calculate our ICERS, incremental cost and incremental effectiveness, and also describes dominance status:

# This uses the "calculate_icers function", which does all the sorting, all the prioritization, and then computes the dominance, and not dominance, etc., and there's a publication on the methods behind this, based on a method from colleagues in Stanford.

# The default view is ordered by dominance status (ND = non-dominated, ED = extended/weak dominance, or D= strong dominance), and then ascending by cost per: https://cran.r-project.org/web/packages/dampack/vignettes/basic_cea.html


# The icer object can be easily formatted into a publication quality table using the kableExtra package, as below, but there's probably a better way to do this per Dampack just under:

# library(kableExtra)
# library(dplyr)
# df_cea %>%
#  kable() %>%
#  kable_styling()


## CEA table in proper format ---- per: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\R-HTA in LMICs Intermediate R-HTA Modelling Tutorial\September-Workshop-main\September-Workshop-main\analysis\cSTM_time_dep_simulation.r
table_cea <- format_table_cea(df_cea) # Function included in "R/Functions.R"; depends on the `scales` package
table_cea
```

```
##                 Strategy Costs ($) QALYs Incremental Costs ($) Incremental QALYs
## 1       Standard of Care    17,591  0.33                  <NA>                NA
## 2 Experimental Treatment    50,540  0.65                32,949              0.31
##   ICER ($/QALY) Status
## 1          <NA>     ND
## 2       105,767     ND
```

```r
# I create a parameter "ICER" to pull the ICER value straight out of the table, I select ($) ICER from df_cea and then pick the 2nd entry in this ICER parameter, so that I'm getting the number rather than the NA, i.e.:

# > df_cea$ICER
# [1]       NA 173845.8

# Below I create Incremental_Cost, Incremental_Effect and ICER to include in the leauge table in the paper. I take the incremental cost and ICER from the table_cea because that applies a nice format with a comma for the thousands, etc., I also use "noqoute" to take the qoute marks away when this is made. I use df_cea because I want to round Incremental_Effect and then do round to 3 digits.

Incremental_Cost<- noquote(table_cea$"Incremental Costs"[2])
Incremental_Effect<- round(df_cea$Inc_Effect[2], digits=3)
ICER<- noquote(table_cea$"ICER"[2])
```


```r
#07.4 Plot frontier of the Markov model

plot(df_cea, effect_units = "QALYs", label = "all")
```

<img src="Markov_3state_files/figure-html/unnamed-chunk-33-1.png" width="672" />

```r
ggsave(paste("Frontier_Markov_Model_", country_name[1], ".png", sep = ""), width = 8, height = 4, dpi=300)



while (!is.null(dev.list()))  dev.off()
# png(paste("Markov_Cohort_Traces", ".png"))
# dev.off()

# plot(df_cea, effect_units = "QALYs")


# When we plot it we have 2 strategies it is possible that something would be off the frontier, would be weakly dominated or strongly dominated, with just a few strategies it's not necessarily that impressive, but with lots of strategies then dampack can be helpful.
```


```r
#08.1 Load Markov model function

#08.3 One-way sensitivity analysis (OWSA)

# A brief note on how parameters are varied one at a time:

# A simple one-way DSA starts with choosing a model parameter to be investigated. Next, the modeler specifies a range for this parameter and the number of evenly spaced points along this range at which to evaluate model outcomes. The model is then run for each element of the vector of parameter values by setting the parameter of interest to the value, holding all other model parameters at their default base case values.

# To conduct the one-way DSA, we then call the function run_owsa_det with my_owsa_params_range, specifying the parameters to be varied and over which ranges, and my_params_basecase as the fixed parameter values to be used in the model when a parameter is not being explicitly varied in the one-way sensitivity analysis.


options(digits=4)

## Initialization ----

# Load the model as a function that is defined in the supporting script
# source("Functions_markov_3state.R")
# Test function
# calculate_ce_out(l_params_all)

source(file = "oncologySemiMarkov_function.R")
# If I change any code in this main model code file, I will also need to update the function that I call.


# Create list l_params_all with all input probabilities, costs, utilities, etc.,

# Test whether the function works (and generates the same results)
# - to do so, first a list of parameter values needs to be generated

# Now I update this list with the variables I have:

# If I updated utility for AE above, then I'll have to take that into account for u_F below:

l_params_all <- list(
  HR_FP_Exp = HR_FP_Exp,
  HR_FP_SoC = HR_FP_SoC,
  HR_PD_Exp = HR_PD_Exp,
  HR_PD_SoC = HR_PD_SoC,
  P_OSD_SoC = P_OSD_SoC,      
  P_OSD_Exp = P_OSD_Exp,
  p_FA1_STD = p_FA1_STD,
  p_FA2_STD = p_FA2_STD,
  p_FA3_STD = p_FA3_STD,
  p_FA1_EXPR = p_FA1_EXPR,
  p_FA2_EXPR = p_FA2_EXPR,
  p_FA3_EXPR = p_FA3_EXPR,
  administration_cost = administration_cost,
    #ITS FINE TO INCLUDE THE INGRIDENIENTS THAT MAKE UP c_F_SoC, c_F_Exp, c_P, but don't include c_F_SoC, c_F_Exp, c_P themsleves, BECAUSE WE ARE CHANGING WHAT BUILDS THESE COSTS WITH THE INGRIEDIENTS, SO WE DON'T WANT TO CHANGE IT AGAIN HERE ONCE WE'VE CHANGED WHAT BUILDS IT
  c_PFS_Folfox = c_PFS_Folfox,
  c_PFS_Bevacizumab = c_PFS_Bevacizumab,
  c_OS_Folfiri = c_OS_Folfiri,
  c_D       = c_D,    
  c_AE1 = c_AE1,
  c_AE2 = c_AE2,
  c_AE3 = c_AE3,
  u_F = u_F,   
  #ITS FINE TO INCLUDE U_F BUT DON'T INCLUDE U_F_SoC, BECAUSE WE ARE CHANGING WHAT BUILDS U_F_SoC WTH U_F AND AE1_DisUtil SO WE DON'T WANT TO CHANGE IT AGAIN HERE ONCE WE'VE CHANGED WHAT BUILDS IT
  u_P = u_P,   
  u_D = u_D,  
  AE1_DisUtil = AE1_DisUtil,
  AE2_DisUtil = AE2_DisUtil,
  AE3_DisUtil = AE3_DisUtil,
  d_e       = d_e,  
  d_c       = d_c,
  n_cycle   = n_cycle,
  t_cycle   = t_cycle
)

 
# Test function

# Test whether the function works (and generates the same results)

oncologySemiMarkov(l_params_all = l_params_all, n_wtp = n_wtp)
```

```
##                 Strategy  Cost Effect DSAICER
## 1       Standard of Care 17591 0.3346  105767
## 2 Experimental Treatment 50540 0.6462  105767
```

```r
# Entering parameter values:


UpperCI <- 0.87
LowerCI <- 0.53

HR_FP_Exp
```

```
## [1] 0.68
```

```r
Minimum_HR_FP_Exp <- LowerCI
Maximum_HR_FP_Exp <- UpperCI


HR_FP_SoC
```

```
## [1] 1
```

```r
Minimum_HR_FP_SoC <- HR_FP_SoC - 0.20*HR_FP_SoC
Maximum_HR_FP_SoC <- HR_FP_SoC + 0.20*HR_FP_SoC


# Now that we're using the OS curves, I add hazard ratios for PFS to dead that reflect the hazard ratio of the experimental strategy changing the probability of going from PFS to Death, and the hazard ratio of 1 that I apply in standard of care so that I can vary transition probabilities under standard of care in this one-way sensitivity analysis:

HR_PD_SoC
```

```
## [1] 1
```

```r
Minimum_HR_PD_SoC <- HR_PD_SoC - 0.20*HR_PD_SoC
Maximum_HR_PD_SoC <- HR_PD_SoC + 0.20*HR_PD_SoC


OS_UpperCI <- 0.86
OS_LowerCI <- 0.49
  
  
HR_PD_Exp
```

```
## [1] 0.65
```

```r
Minimum_HR_PD_Exp <- OS_LowerCI
Maximum_HR_PD_Exp <- OS_UpperCI








# Probability of progressive disease to death:

# Under the assumption that everyone will get the same second line therapy, I give them all the same probability of going from progessed (i.e., OS) to dead, and thus only need to include p_PD here once - because it is applied in oncologySemiMarkov_function.R for both SoC and Exp. ACTUALLY I THINK IT SHOULD BE P_OSD_SoC P_OSD_Exp BOTH INCLUDED.

P_OSD_SoC
```

```
## [1] 0.17
```

```r
Minimum_P_OSD_SoC <- 0.12
Maximum_P_OSD_SoC <- 0.22

P_OSD_Exp
```

```
## [1] 0.17
```

```r
Minimum_P_OSD_Exp <- 0.12
Maximum_P_OSD_Exp <- 0.22







# Probability of going from PFS to Death states under the standard of care treatment and the experimental treatment:

# # HR_PD_SoC and HR_PD_Exp address this as above:

# p_FD_SoC
# 
# Minimum_p_FD_SoC <- p_FD_SoC - 0.20*p_FD_SoC
# Maximum_p_FD_SoC <- p_FD_SoC + 0.20*p_FD_SoC
# 
# p_FD_Exp
# 
# Minimum_p_FD_Exp<- p_FD_Exp - 0.20*p_FD_Exp
# Maximum_p_FD_Exp <- p_FD_Exp + 0.20*p_FD_Exp



# Probability of Adverse Events:

p_FA1_STD
```

```
## [1] 0.04
```

```r
Minimum_p_FA1_STD <- p_FA1_STD - 0.20*p_FA1_STD
Maximum_p_FA1_STD <- p_FA1_STD + 0.20*p_FA1_STD

p_FA2_STD
```

```
## [1] 0.31
```

```r
Minimum_p_FA2_STD <- p_FA2_STD - 0.20*p_FA2_STD
Maximum_p_FA2_STD <- p_FA2_STD + 0.20*p_FA2_STD

p_FA3_STD
```

```
## [1] 0.31
```

```r
Minimum_p_FA3_STD <- p_FA3_STD - 0.20*p_FA3_STD
Maximum_p_FA3_STD <- p_FA3_STD + 0.20*p_FA3_STD


p_FA1_EXPR
```

```
## [1] 0.07
```

```r
Minimum_p_FA1_EXPR <- p_FA1_EXPR - 0.20*p_FA1_EXPR
Maximum_p_FA1_EXPR <- p_FA1_EXPR + 0.20*p_FA1_EXPR

p_FA2_EXPR
```

```
## [1] 0.11
```

```r
Minimum_p_FA2_EXPR <- p_FA2_EXPR - 0.20*p_FA2_EXPR
Maximum_p_FA2_EXPR <- p_FA2_EXPR + 0.20*p_FA2_EXPR

p_FA3_EXPR
```

```
## [1] 0.07
```

```r
Minimum_p_FA3_EXPR <- p_FA3_EXPR - 0.20*p_FA3_EXPR
Maximum_p_FA3_EXPR <- p_FA3_EXPR + 0.20*p_FA3_EXPR




# Cost:

# If I decide to include the cost of the test for patients I will also need to include this in the sensitivity analysis here:

administration_cost
```

```
## [1] 314.9
```

```r
Minimum_administration_cost <- administration_cost - 0.20*administration_cost
Maximum_administration_cost <- administration_cost + 0.20*administration_cost

c_PFS_Folfox
```

```
## [1] 285.5
```

```r
Minimum_c_PFS_Folfox  <- c_PFS_Folfox - 0.20*c_PFS_Folfox
Maximum_c_PFS_Folfox  <- c_PFS_Folfox + 0.20*c_PFS_Folfox

c_PFS_Bevacizumab 
```

```
## [1] 1326
```

```r
Minimum_c_PFS_Bevacizumab  <- c_PFS_Bevacizumab - 0.20*c_PFS_Bevacizumab
Maximum_c_PFS_Bevacizumab  <- c_PFS_Bevacizumab + 0.20*c_PFS_Bevacizumab

c_OS_Folfiri 
```

```
## [1] 139.6
```

```r
Minimum_c_OS_Folfiri  <- c_OS_Folfiri - 0.20*c_OS_Folfiri
Maximum_c_OS_Folfiri  <- c_OS_Folfiri + 0.20*c_OS_Folfiri

c_D  
```

```
## [1] 0
```

```r
Minimum_c_D  <- c_D - 0.20*c_D
Maximum_c_D  <- c_D + 0.20*c_D

c_AE1
```

```
## [1] 4886
```

```r
Minimum_c_AE1  <- c_AE1 - 0.20*c_AE1
Maximum_c_AE1  <- c_AE1 + 0.20*c_AE1

c_AE2
```

```
## [1] 507.4
```

```r
Minimum_c_AE2  <- c_AE2 - 0.20*c_AE2
Maximum_c_AE2  <- c_AE2 + 0.20*c_AE2

c_AE3
```

```
## [1] 95.03
```

```r
Minimum_c_AE3  <- c_AE3 - 0.20*c_AE3
Maximum_c_AE3  <- c_AE3 + 0.20*c_AE3


# Utilities:

u_F
```

```
## [1] 0.85
```

```r
Minimum_u_F <- 0.68
Maximum_u_F <- 1.00


u_P
```

```
## [1] 0.65
```

```r
Minimum_u_P <- 0.52
Maximum_u_P <- 0.78 


u_D
```

```
## [1] 0
```

```r
Minimum_u_D <- u_D - 0.20*u_D
Maximum_u_D <- u_D + 0.20*u_D 


AE1_DisUtil
```

```
## [1] 0.45
```

```r
Minimum_AE1_DisUtil <- AE1_DisUtil - 0.20*AE1_DisUtil
Maximum_AE1_DisUtil <- AE1_DisUtil + 0.20*AE1_DisUtil 


AE2_DisUtil
```

```
## [1] 0.19
```

```r
Minimum_AE2_DisUtil <- AE2_DisUtil - 0.20*AE2_DisUtil
Maximum_AE2_DisUtil <- AE2_DisUtil + 0.20*AE2_DisUtil 


AE3_DisUtil
```

```
## [1] 0.36
```

```r
Minimum_AE3_DisUtil <- AE3_DisUtil - 0.20*AE3_DisUtil
Maximum_AE3_DisUtil <- AE3_DisUtil + 0.20*AE3_DisUtil 


 
 
# Discount factor
# Cost Discount Factor
# Utility Discount Factor
# I divided these by 365 earlier in the R markdown document, so no need to do that again here:

d_e
```

```
## [1] 0.0001096
```

```r
Minimum_d_e <- 0
Maximum_d_e <- 0.08/365



d_c
```

```
## [1] 0.0001096
```

```r
Minimum_d_c <- 0
Maximum_d_c <- 0.08/365


# I am concerned that the min or max may go above 1 or below 0 in cases where parameter values should be bounded at 1 or 0, therefore, in such cases I say, replace the minimum I created with 0 or the maximum I created with 1, if the minimum is below 0 or the maximum is above 1:


HR_FP_Exp
```

```
## [1] 0.68
```

```r
Minimum_HR_FP_Exp<- replace(Minimum_HR_FP_Exp, Minimum_HR_FP_Exp<0, 0)
Maximum_HR_FP_Exp<- replace(Maximum_HR_FP_Exp, Maximum_HR_FP_Exp>1, 1)

HR_FP_SoC
```

```
## [1] 1
```

```r
Minimum_HR_FP_SoC<- replace(Minimum_HR_FP_SoC, Minimum_HR_FP_SoC<0, 0)
Maximum_HR_FP_SoC<- replace(Maximum_HR_FP_SoC, Maximum_HR_FP_SoC>1, 1)

HR_PD_SoC
```

```
## [1] 1
```

```r
Minimum_HR_PD_SoC<- replace(Minimum_HR_PD_SoC, Minimum_HR_PD_SoC<0, 0)
Maximum_HR_PD_SoC<- replace(Maximum_HR_PD_SoC, Maximum_HR_PD_SoC>1, 1)

HR_PD_Exp
```

```
## [1] 0.65
```

```r
Minimum_HR_PD_Exp<- replace(Minimum_HR_PD_Exp, Minimum_HR_PD_Exp<0, 0)
Maximum_HR_PD_Exp<- replace(Maximum_HR_PD_Exp, Maximum_HR_PD_Exp>1, 1)

P_OSD_SoC
```

```
## [1] 0.17
```

```r
Minimum_P_OSD_SoC<- replace(Minimum_P_OSD_SoC, Minimum_P_OSD_SoC<0, 0)
Maximum_P_OSD_SoC<- replace(Maximum_P_OSD_SoC, Maximum_P_OSD_SoC>1, 1)

P_OSD_Exp
```

```
## [1] 0.17
```

```r
Minimum_P_OSD_Exp<- replace(Minimum_P_OSD_Exp, Minimum_P_OSD_Exp<0, 0)
Maximum_P_OSD_Exp<- replace(Maximum_P_OSD_Exp, Maximum_P_OSD_Exp>1, 1)

p_FA1_STD
```

```
## [1] 0.04
```

```r
Minimum_p_FA1_STD<- replace(Minimum_p_FA1_STD, Minimum_p_FA1_STD<0, 0)
Maximum_p_FA1_STD<- replace(Maximum_p_FA1_STD, Maximum_p_FA1_STD>1, 1)

p_FA2_STD
```

```
## [1] 0.31
```

```r
Minimum_p_FA2_STD<- replace(Minimum_p_FA2_STD, Minimum_p_FA2_STD<0, 0)
Maximum_p_FA2_STD<- replace(Maximum_p_FA2_STD, Maximum_p_FA2_STD>1, 1)

p_FA3_STD
```

```
## [1] 0.31
```

```r
Minimum_p_FA3_STD<- replace(Minimum_p_FA3_STD, Minimum_p_FA3_STD<0, 0)
Maximum_p_FA3_STD<- replace(Maximum_p_FA3_STD, Maximum_p_FA3_STD>1, 1)

p_FA1_EXPR
```

```
## [1] 0.07
```

```r
Minimum_p_FA1_EXPR<- replace(Minimum_p_FA1_EXPR, Minimum_p_FA1_EXPR<0, 0)
Maximum_p_FA1_EXPR<- replace(Maximum_p_FA1_EXPR, Maximum_p_FA1_EXPR>1, 1)

p_FA2_EXPR
```

```
## [1] 0.11
```

```r
Minimum_p_FA2_EXPR<- replace(Minimum_p_FA2_EXPR, Minimum_p_FA2_EXPR<0, 0)
Maximum_p_FA2_EXPR<- replace(Maximum_p_FA2_EXPR, Maximum_p_FA2_EXPR>1, 1)

p_FA3_EXPR
```

```
## [1] 0.07
```

```r
Minimum_p_FA3_EXPR<- replace(Minimum_p_FA3_EXPR, Minimum_p_FA3_EXPR<0, 0)
Maximum_p_FA3_EXPR<- replace(Maximum_p_FA3_EXPR, Maximum_p_FA3_EXPR>1, 1)

u_F
```

```
## [1] 0.85
```

```r
Minimum_u_F<- replace(Minimum_u_F, Minimum_u_F<0, 0)
Maximum_u_F<- replace(Maximum_u_F, Maximum_u_F>1, 1)

u_P
```

```
## [1] 0.65
```

```r
Minimum_u_P<- replace(Minimum_u_P, Minimum_u_P<0, 0)
Maximum_u_P<- replace(Maximum_u_P, Maximum_u_P>1, 1)

AE1_DisUtil
```

```
## [1] 0.45
```

```r
Minimum_AE1_DisUtil<- replace(Minimum_AE1_DisUtil, Minimum_AE1_DisUtil<0, 0)
Maximum_AE1_DisUtil<- replace(Maximum_AE1_DisUtil, Maximum_AE1_DisUtil>1, 1)

AE2_DisUtil
```

```
## [1] 0.19
```

```r
Minimum_AE2_DisUtil<- replace(Minimum_AE2_DisUtil, Minimum_AE2_DisUtil<0, 0)
Maximum_AE2_DisUtil<- replace(Maximum_AE2_DisUtil, Maximum_AE2_DisUtil>1, 1)

AE3_DisUtil
```

```
## [1] 0.36
```

```r
Minimum_AE3_DisUtil<- replace(Minimum_AE3_DisUtil, Minimum_AE3_DisUtil<0, 0)
Maximum_AE3_DisUtil<- replace(Maximum_AE3_DisUtil, Maximum_AE3_DisUtil>1, 1)



# A one-way sensitivity analysis (OWSA) can be defined by specifying the names of the parameters that are to be incuded and their minimum and maximum values.


# We create a dataframe containing all parameters we want to do the sensitivity analysis on, and the min and max values of the parameters of interest 
# "min" and "max" are the mininum and maximum values of the parameters of interest.


# options(scipen = 999) # disabling scientific notation in R

df_params_OWSA <- data.frame(
  pars = c("HR_FP_Exp", "HR_FP_SoC", "HR_PD_SoC", "HR_PD_Exp", "P_OSD_SoC", "P_OSD_Exp", "p_FA1_STD", "p_FA2_STD", "p_FA3_STD", "p_FA1_EXPR", "p_FA2_EXPR", "p_FA3_EXPR", "administration_cost", "c_PFS_Folfox", "c_PFS_Bevacizumab", "c_OS_Folfiri", "c_AE1", "c_AE2", "c_AE3", "d_e", "d_c", "u_F", "u_P", "AE1_DisUtil", "AE2_DisUtil", "AE3_DisUtil"),   # names of the parameters to be changed
  min  = c(Minimum_HR_FP_Exp, Minimum_HR_FP_SoC, Minimum_HR_PD_SoC, Minimum_HR_PD_Exp, Minimum_P_OSD_SoC, Minimum_P_OSD_Exp, Minimum_p_FA1_STD, Minimum_p_FA2_STD, Minimum_p_FA3_STD, Minimum_p_FA1_EXPR, Minimum_p_FA2_EXPR, Minimum_p_FA3_EXPR, Minimum_administration_cost, Minimum_c_PFS_Folfox, Minimum_c_PFS_Bevacizumab, Minimum_c_OS_Folfiri, Minimum_c_AE1, Minimum_c_AE2, Minimum_c_AE3, Minimum_d_e, Minimum_d_c, Minimum_u_F, Minimum_u_P, Minimum_AE1_DisUtil, Minimum_AE2_DisUtil, Minimum_AE3_DisUtil),         # min parameter values
  max  = c(Maximum_HR_FP_Exp, Maximum_HR_FP_SoC, Maximum_HR_PD_SoC, Maximum_HR_PD_Exp, Maximum_P_OSD_SoC, Maximum_P_OSD_Exp, Maximum_p_FA1_STD, Maximum_p_FA2_STD, Maximum_p_FA3_STD, Maximum_p_FA1_EXPR, Maximum_p_FA2_EXPR, Maximum_p_FA3_EXPR, Maximum_administration_cost, Maximum_c_PFS_Folfox, Maximum_c_PFS_Bevacizumab, Maximum_c_OS_Folfiri, Maximum_c_AE1,  Maximum_c_AE2, Maximum_c_AE3, Maximum_d_e, Maximum_d_c, Maximum_u_F, Maximum_u_P, Maximum_AE1_DisUtil, Maximum_AE2_DisUtil, Maximum_AE3_DisUtil)          # max parameter values
)


# I made sure the names of the parameters to be varied and their mins and maxs are in the same order in all the brackets above in order to make sure that the min and max being applied are the min and the max of the parameter I want to consider a min and a max for.



# The OWSA is performed using the run_owsa_det function


# This function runs a deterministic one-way sensitivity analysis (OWSA) on a given function that produces outcomes. rdrr.io/github/DARTH-git/dampack/src/R/run_dsa.R

DSAICER  <- run_owsa_det(

# run_owsa_det: https://rdrr.io/github/DARTH-git/dampack/man/run_owsa_det.html

  # We need to make sure we consistently use "DSAICER" throughout, or else the function will present with an error saying "DSAICER" not found.  
   
# Arguments:
  
  params_range     = df_params_OWSA,     # dataframe with parameters for OWSA

# params_range	
# data.frame with 3 columns of parameters for OWSA in the following order: "pars", "min", and "max".
# The number of samples from this range is determined by nsamp. 
# "pars" are the parameters of interest and must be a subset of the parameters from params_basecase.


# Details
# params_range
 
# "pars" are the names of the input parameters of interest. These are the parameters that will be varied in the deterministic sensitivity analysis. variables in "pars" column must be a subset of variables in params_basecase
 

  
  params_basecase  = l_params_all,       # list with all parameters

# params_basecase	

# a named list of basecase values for input parameters needed by FUN, the user-defined function. So, I guess it takes the values that the parameters are equal to in l_params_all as the base case, so if cost is generated equal to 1,000 it'll take that as the base case, and then take the min and the max around this from the data.frame we created above.

# To conduct the one-way DSA, we then call the function run_owsa_det with my_owsa_params_range, specifying the parameters to be varied and over which ranges, and my_params_basecase as the fixed parameter values to be used in the model when a parameter is not being explicitly varied in the one-way sensitivity analysis. https://cran.r-project.org/web/packages/dampack/vignettes/dsa_generation.html

  nsamp            = 100,                # number of parameter values

# nsamp	

# number of sets of parameter values to be generated. If NULL, 100 parameter values are used -> I think Eva Enns said these are automatically evenly spaced out values of the parameters.

# Additional inputs are the number of equally-spaced samples (nsamp) to be used between the specified minimum and maximum of each range, the user-defined function (FUN) to be called to generate model outcomes for each strategy, the vector of outcomes to be stored (must be outcomes generated by the data frame output of the function passed in FUN), and the vector of strategy names to be evaluated.

# cran.r-project.org/web/packages/dampack/vignettes/dsa_generation.html

  FUN              = oncologySemiMarkov, # function to compute outputs

# FUN	
# function that takes the basecase in params_basecase and runs the analysis in the function... to produce the outcome of interest. The FUN must return a dataframe where the first column are the strategy names and the rest of the columns must be outcomes.
#  

 outcomes         = c("DSAICER"),           # output to do the OWSA on

# string vector with the outcomes of interest from FUN produced by nsamp
# This basically tells run_owsa_det what the name of the outcome of interest from the function we fed it is. Here our function previously had NMB, i.e., the net monetary benefit.

#  outcomes         = c("NMB"),           # output to do the OWSA on

# outcomes	

  strategies       = v_names_strats,       # names of the strategies

# strategies
# Set it equal to a vector of strategy names. The default NULL will use strategy names in FUN (  strategies = NULL,)
# Here that's "Standard of Care" and "Experimental Treatment".

  progress = TRUE,

# progress	
# TRUE or FALSE for whether or not function progress should be displayed in console, i.e., like 75% complete, 100%, etc.,

# The input progress = TRUE allows the user to see a progress bar as the DSA is conducted. When many parameters are being varied, nsamp is large, and/or the user-defined function is computationally burdensome, the DSA may take a noticeable amount of time to compute and the progress display is recommended.
# cran.r-project.org/web/packages/dampack/vignettes/dsa_generation.html


  n_wtp            = n_wtp               # extra argument to pass to FUN to specify the willingness to pay
)
```

```
## 
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |                                                                                  |   1%
  |                                                                                        
  |=                                                                                 |   1%
  |                                                                                        
  |=                                                                                 |   2%
  |                                                                                        
  |==                                                                                |   2%
  |                                                                                        
  |==                                                                                |   3%
  |                                                                                        
  |===                                                                               |   3%
  |                                                                                        
  |===                                                                               |   4%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |===                                                                               |   4%
  |                                                                                        
  |====                                                                              |   4%
  |                                                                                        
  |====                                                                              |   5%
  |                                                                                        
  |=====                                                                             |   6%
  |                                                                                        
  |=====                                                                             |   7%
  |                                                                                        
  |======                                                                            |   7%
  |                                                                                        
  |======                                                                            |   8%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |======                                                                            |   8%
  |                                                                                        
  |=======                                                                           |   8%
  |                                                                                        
  |=======                                                                           |   9%
  |                                                                                        
  |========                                                                          |   9%
  |                                                                                        
  |========                                                                          |  10%
  |                                                                                        
  |=========                                                                         |  10%
  |                                                                                        
  |=========                                                                         |  11%
  |                                                                                        
  |=========                                                                         |  12%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |=========                                                                         |  12%
  |                                                                                        
  |==========                                                                        |  12%
  |                                                                                        
  |==========                                                                        |  13%
  |                                                                                        
  |===========                                                                       |  13%
  |                                                                                        
  |===========                                                                       |  14%
  |                                                                                        
  |============                                                                      |  14%
  |                                                                                        
  |============                                                                      |  15%
  |                                                                                        
  |=============                                                                     |  15%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |=============                                                                     |  15%
  |                                                                                        
  |=============                                                                     |  16%
  |                                                                                        
  |==============                                                                    |  16%
  |                                                                                        
  |==============                                                                    |  17%
  |                                                                                        
  |==============                                                                    |  18%
  |                                                                                        
  |===============                                                                   |  18%
  |                                                                                        
  |===============                                                                   |  19%
  |                                                                                        
  |================                                                                  |  19%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |================                                                                  |  19%
  |                                                                                        
  |================                                                                  |  20%
  |                                                                                        
  |=================                                                                 |  20%
  |                                                                                        
  |=================                                                                 |  21%
  |                                                                                        
  |==================                                                                |  21%
  |                                                                                        
  |==================                                                                |  22%
  |                                                                                        
  |==================                                                                |  23%
  |                                                                                        
  |===================                                                               |  23%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |===================                                                               |  23%
  |                                                                                        
  |===================                                                               |  24%
  |                                                                                        
  |====================                                                              |  24%
  |                                                                                        
  |====================                                                              |  25%
  |                                                                                        
  |=====================                                                             |  25%
  |                                                                                        
  |=====================                                                             |  26%
  |                                                                                        
  |======================                                                            |  26%
  |                                                                                        
  |======================                                                            |  27%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |======================                                                            |  27%
  |                                                                                        
  |=======================                                                           |  27%
  |                                                                                        
  |=======================                                                           |  28%
  |                                                                                        
  |=======================                                                           |  29%
  |                                                                                        
  |========================                                                          |  29%
  |                                                                                        
  |========================                                                          |  30%
  |                                                                                        
  |=========================                                                         |  30%
  |                                                                                        
  |=========================                                                         |  31%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |=========================                                                         |  31%
  |                                                                                        
  |==========================                                                        |  31%
  |                                                                                        
  |==========================                                                        |  32%
  |                                                                                        
  |===========================                                                       |  32%
  |                                                                                        
  |===========================                                                       |  33%
  |                                                                                        
  |===========================                                                       |  34%
  |                                                                                        
  |============================                                                      |  34%
  |                                                                                        
  |============================                                                      |  35%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |============================                                                      |  35%
  |                                                                                        
  |=============================                                                     |  35%
  |                                                                                        
  |=============================                                                     |  36%
  |                                                                                        
  |==============================                                                    |  36%
  |                                                                                        
  |==============================                                                    |  37%
  |                                                                                        
  |===============================                                                   |  37%
  |                                                                                        
  |===============================                                                   |  38%
  |                                                                                        
  |================================                                                  |  38%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |================================                                                  |  38%
  |                                                                                        
  |================================                                                  |  39%
  |                                                                                        
  |================================                                                  |  40%
  |                                                                                        
  |=================================                                                 |  40%
  |                                                                                        
  |=================================                                                 |  41%
  |                                                                                        
  |==================================                                                |  41%
  |                                                                                        
  |==================================                                                |  42%
  |                                                                                        
  |===================================                                               |  42%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |===================================                                               |  42%
  |                                                                                        
  |===================================                                               |  43%
  |                                                                                        
  |====================================                                              |  43%
  |                                                                                        
  |====================================                                              |  44%
  |                                                                                        
  |=====================================                                             |  45%
  |                                                                                        
  |=====================================                                             |  46%
  |                                                                                        
  |======================================                                            |  46%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |======================================                                            |  46%
  |                                                                                        
  |======================================                                            |  47%
  |                                                                                        
  |=======================================                                           |  47%
  |                                                                                        
  |=======================================                                           |  48%
  |                                                                                        
  |========================================                                          |  48%
  |                                                                                        
  |========================================                                          |  49%
  |                                                                                        
  |=========================================                                         |  49%
  |                                                                                        
  |=========================================                                         |  50%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |=========================================                                         |  50%
  |                                                                                        
  |=========================================                                         |  51%
  |                                                                                        
  |==========================================                                        |  51%
  |                                                                                        
  |==========================================                                        |  52%
  |                                                                                        
  |===========================================                                       |  52%
  |                                                                                        
  |===========================================                                       |  53%
  |                                                                                        
  |============================================                                      |  53%
  |                                                                                        
  |============================================                                      |  54%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |============================================                                      |  54%
  |                                                                                        
  |=============================================                                     |  54%
  |                                                                                        
  |=============================================                                     |  55%
  |                                                                                        
  |==============================================                                    |  56%
  |                                                                                        
  |==============================================                                    |  57%
  |                                                                                        
  |===============================================                                   |  57%
  |                                                                                        
  |===============================================                                   |  58%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |===============================================                                   |  58%
  |                                                                                        
  |================================================                                  |  58%
  |                                                                                        
  |================================================                                  |  59%
  |                                                                                        
  |=================================================                                 |  59%
  |                                                                                        
  |=================================================                                 |  60%
  |                                                                                        
  |==================================================                                |  60%
  |                                                                                        
  |==================================================                                |  61%
  |                                                                                        
  |==================================================                                |  62%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |==================================================                                |  62%
  |                                                                                        
  |===================================================                               |  62%
  |                                                                                        
  |===================================================                               |  63%
  |                                                                                        
  |====================================================                              |  63%
  |                                                                                        
  |====================================================                              |  64%
  |                                                                                        
  |=====================================================                             |  64%
  |                                                                                        
  |=====================================================                             |  65%
  |                                                                                        
  |======================================================                            |  65%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |======================================================                            |  65%
  |                                                                                        
  |======================================================                            |  66%
  |                                                                                        
  |=======================================================                           |  66%
  |                                                                                        
  |=======================================================                           |  67%
  |                                                                                        
  |=======================================================                           |  68%
  |                                                                                        
  |========================================================                          |  68%
  |                                                                                        
  |========================================================                          |  69%
  |                                                                                        
  |=========================================================                         |  69%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |=========================================================                         |  69%
  |                                                                                        
  |=========================================================                         |  70%
  |                                                                                        
  |==========================================================                        |  70%
  |                                                                                        
  |==========================================================                        |  71%
  |                                                                                        
  |===========================================================                       |  71%
  |                                                                                        
  |===========================================================                       |  72%
  |                                                                                        
  |===========================================================                       |  73%
  |                                                                                        
  |============================================================                      |  73%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |============================================================                      |  73%
  |                                                                                        
  |============================================================                      |  74%
  |                                                                                        
  |=============================================================                     |  74%
  |                                                                                        
  |=============================================================                     |  75%
  |                                                                                        
  |==============================================================                    |  75%
  |                                                                                        
  |==============================================================                    |  76%
  |                                                                                        
  |===============================================================                   |  76%
  |                                                                                        
  |===============================================================                   |  77%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |===============================================================                   |  77%
  |                                                                                        
  |================================================================                  |  77%
  |                                                                                        
  |================================================================                  |  78%
  |                                                                                        
  |================================================================                  |  79%
  |                                                                                        
  |=================================================================                 |  79%
  |                                                                                        
  |=================================================================                 |  80%
  |                                                                                        
  |==================================================================                |  80%
  |                                                                                        
  |==================================================================                |  81%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |==================================================================                |  81%
  |                                                                                        
  |===================================================================               |  81%
  |                                                                                        
  |===================================================================               |  82%
  |                                                                                        
  |====================================================================              |  82%
  |                                                                                        
  |====================================================================              |  83%
  |                                                                                        
  |====================================================================              |  84%
  |                                                                                        
  |=====================================================================             |  84%
  |                                                                                        
  |=====================================================================             |  85%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |=====================================================================             |  85%
  |                                                                                        
  |======================================================================            |  85%
  |                                                                                        
  |======================================================================            |  86%
  |                                                                                        
  |=======================================================================           |  86%
  |                                                                                        
  |=======================================================================           |  87%
  |                                                                                        
  |========================================================================          |  87%
  |                                                                                        
  |========================================================================          |  88%
  |                                                                                        
  |=========================================================================         |  88%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |=========================================================================         |  88%
  |                                                                                        
  |=========================================================================         |  89%
  |                                                                                        
  |=========================================================================         |  90%
  |                                                                                        
  |==========================================================================        |  90%
  |                                                                                        
  |==========================================================================        |  91%
  |                                                                                        
  |===========================================================================       |  91%
  |                                                                                        
  |===========================================================================       |  92%
  |                                                                                        
  |============================================================================      |  92%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |============================================================================      |  92%
  |                                                                                        
  |============================================================================      |  93%
  |                                                                                        
  |=============================================================================     |  93%
  |                                                                                        
  |=============================================================================     |  94%
  |                                                                                        
  |==============================================================================    |  95%
  |                                                                                        
  |==============================================================================    |  96%
  |                                                                                        
  |===============================================================================   |  96%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |===============================================================================   |  96%
  |                                                                                        
  |===============================================================================   |  97%
  |                                                                                        
  |================================================================================  |  97%
  |                                                                                        
  |================================================================================  |  98%
  |                                                                                        
  |================================================================================= |  98%
  |                                                                                        
  |================================================================================= |  99%
  |                                                                                        
  |==================================================================================|  99%
  |                                                                                        
  |==================================================================================| 100%
```

```r
# Value
# A list containing dataframes with the results of the sensitivity analyses. The list will contain a dataframe for each outcome specified. List elements can be visualized with plot.owsa, owsa_opt_strat and owsa_tornado from dampack

# Basically, run_owsa_det creates the above.

# Also, each owsa object returned by run_owsa_det is a data frame with four columns: parameter, strategy, param_val, and outcome_val. For each row, param_val is the value used for the parameter listed in parameter and outcome_val is the value of the specified outcome for the strategy listed in strategy. 

# So, OWSA_NMB shows a row is created for each sampling of the parameter value from min to max, so 100 rows per parameter (because nsamp = 100,), and the outcome value associated with a parameter value of this size is displayed under outcome_val.

# You can see how this works by putting the below into the console.

# OWSA_NMB

# Or just DSAICER for DSAICER.

# Resources on this available here:


# https://rdrr.io/github/DARTH-git/dampack/man/run_owsa_det.html (also saved here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\sensitivity analysis help files\rdrr-io-github-DARTH-git-dampack-man-run_owsa_det-html.pdf)


# This link is pretty good for showing that the OWSA can be run across a variety of outcomes outcomes = c("Cost", "QALY", "LY", "NMB"), and then you can pick which of the OWSA outcomes you'd like to focus on and build tornado diagrams, etc., from that:

# "Because we have defined multiple parameters in my_owsa_params_range, we have instructed run_owsa_det to execute a series of separate one-way sensitivity analyses and compile the results into a single owsa object for each requested outcome. When only one outcome is specified run_owsa_det returns a owsa data frame. When more than one outcome is specified, run_owsa_det returns a list containing one owsa data frame for each outcome. To access the owsa object corresponding to a given outcome, one can select the list item with the name “owsa_”. For example, the owsa object associated with the NMB outcome can be accessed as l_owsa_det$owsa_NMB."

# https://cran.r-project.org/web/packages/dampack/vignettes/dsa_generation.html 

owsa_tornado(owsa = DSAICER, txtsize = 11)
```

<img src="Markov_3state_files/figure-html/unnamed-chunk-34-1.png" width="672" />

```r
ggsave(paste("Tornado_Diagram_", country_name[1], ".png", sep = ""), width = 8, height = 4, dpi=300)
while (!is.null(dev.list()))  dev.off()
#png(paste("Tornado_Diagram_", country_name[1], ".png", sep = ""))
#dev.off()

# Plotting the outcomes of the OWSA in a tornado plot
# - note that other plots can also be generated using the plot() and owsa_opt_strat() functions



# owsa_tornado(DSAICER,
# 
# min_rel_diff = 0.05)

# For owsa objects that contain many parameters that have minimal effect on the parameter of interest, you may want to consider producing a plot that highlights only the most influential parameters. Using the min_rel_diff argument, you can instruct owsa_tornado to exclude all parameters that fail to produce a relative change in the outcome below a specific fraction.


# Maybe use the below to change the formatting of the above:
# TornadoPlot(main_title = "Tornado Plot", Parms = paramNames, Outcomes = m.tor, 
#             outcomeName = "Incremental Cost-Effectiveness Ratio (ICER)", 
#             xlab = "ICER", 
#             ylab = "Parameters", 
#             col1="#3182bd", col2="#6baed6")
```

## 08.3.1 Plot OWSA


```r
# plot(DSAICER, txtsize = 10, n_x_ticks = 4, 
#      facet_scales = "free") +
#   theme(legend.position = "bottom") 
# The above was the code, but I've temporarily commented it out.

# I can add the following to the above: 

# + ggtitle("Expected Value of Perfect Information")

# To include a title on this plot, per: https://mran.microsoft.com/snapshot/2021-03-21/web/packages/dampack/dampack.pdf

#txtsize - base text size

# n_y_ticks - number of axis ticks
# n_x_ticks	- number of axis ticks

# Function for determining number of ticks on axis of ggplot2 plots. https://www.quantargo.com/help/r/latest/packages/dampack/1.0.1/number_ticks


# [SO, IN THE DIAGRAM THE PARAMETER WE ARE CONSIDERING IS AT THE TOP OF THE DIAGRAM, THE NET MONETARY BENEFIT IS ON THE LEFT OF THE DIAGRAM AND YOU'LL SEE THAT THE LEFT EDGE OF THE LINE IS THE MINIMUM VALUE FOR THE PARAMETER WE ARE INTERESTED IN, THE RIGHT EDGE OF THE LINE IS THE MAXIMUM VALUE FOR THE PARAMETER WE ARE INTERESTED IN, AND SOMEWHERE IN THE MIDDLE IS THE BASECASE WE ASSIGNED THIS PARAMETER. A GOOD EXAMPLE OF THIS IS c_P, COST OF PROGRESSION, say THE BASECASE WAS 1,000 EURO, WHICH WE'D SEE IN THE MIDDLE, THE MINIMUM WAS 800 EURO WHICH WE'D SEE ON THE FAR LEFT OF THE LINE, AND THE MAXIMUM IS 1,200 WHICH WE'D SEE ON THE FAR RIGHT OF THE LINE, AND WE'D SEE THAT AS WE MOVE FROM THE MINUMUM, THE 800 EURO ON THE FAR LEFT OF THE LINE, TO THE MAXIMUM, THE 1200 EURO ON THE FAR RIGHT OF THE LINE (I.E., AS THE COST OF BEING IN THE PROGRESSED STATE INCREASES) THE NET MONETARY BENEFIT OF BOTH TREATMENT OPTIONS FALL, WITH THE NMB OF THE EXPERIMENTAL TREATMENT OPTION FALLING FROM 235,000 TO 230,000].



# Explained here: https://cran.r-project.org/web/packages/dampack/vignettes/dsa_generation.html


# and here: https://cran.r-project.org/web/packages/dampack/vignettes/psa_analysis.html


# Because I'm using ICERs, there's only one value, whereas for NMB, there's a value under each treatment strategy, but ICERs are ratios comparing the costs of one treatment strategy to another, and the outcomes of one treatment strategy to another. So, where when I was using NMB as my outcome I would have a curve for "SoC" and "Experimental Treatment", because each would get an NMB, now I only have the one curve, to show how the ICER value changes. So, before I could have how the net monetary benefit changed under each treatment strategy as the cost of treatment A went up, or the rate of changing from healthy to dead went up, per the "# Plot outcome of each strategy over each parameter range" on: https://cran.r-project.org/web/packages/dampack/vignettes/dsa_generation.html, now I only have the ICER, so I see how the ICER changes as the cost of parameters, etc., change.

# Because only one ICER value is created, but it's created for both SoC and Exp, I imagine that the exp line and SoC line are created, but sit on top of eachother in the diagram below, so I don't include this in my paper:
```

## 08.3.2 Optimal strategy with OWSA


```r
# There are too many parameters to make things legible, so instead you should create a tornado plot that highlights only the most influential parameters. Using the min_rel_diff argument, you can instruct owsa_tornado to exclude all parameters that fail to produce a relative change in the outcome below a specific fraction.

# owsa_tornado(OWSA_NMB,
# 
# min_rel_diff = 0.05)

# Following this, create a vector of the parameters that appear in this tornado plot below and then create the optimal strategy with OWSA per these parameters.

# v_owsa_opt_strat <- c("HR_FP_Exp", "HR_FP_SoC", "p_PD", "p_FD_SoC", "p_FD_Exp", "p_FA1_SoC", "p_A1F_SoC", "p_A1D_SoC", "p_FA2_SoC", "p_A2F_SoC", "p_A2D_SoC", "p_FA3_SoC", "p_A3F_SoC", "p_A3D_SoC", "c_F_SoC", "c_F_Exp", "c_P","c_AE1", "c_AE2", "c_AE3", "d_e", "d_c", "u_F", "u_P", "u_AE1", "u_AE2", "u_AE3")

# Then include params = v_owsa_opt_strat, in the below and get rid of plot_const = FALSE

#owsa_opt_strat(owsa = DSAICER, txtsize = 10, plot_const = FALSE)
# The above was the code, but I've temporarily commented it out.


# plot_const = FALSE
# plot_const	
# whether to plot parameters that don't lead to changes in optimal strategy as they vary.

# params	
# params = v_owsa_opt_strat,
# vector of parameters to plot

# return	
# either return a ggplot object plot or a data frame with ranges of parameters for which each strategy is optimal. return = c("plot", "data"),

# Basically, the data frame will show you the ranges for each parameter that each strategy is optimal.You can see below that for p_FD_Exp the experimental treatment is the optimal strategy from 0.04 (the minimum) through to 0.055 (0.05575757575757575), while standard of care is the optimal strategy from 0.059 (0.05595959595959596) through to 0.06 (the maximum). 

# p_FD_Exp	Experimental.Treatment	4.0000000000000001e-02	5.5757575757575756e-02	
# p_FD_Exp	Standard.of.Care	5.5959595959595959e-02   6.0000000000000005e-02	

# Whereas for p_FA3_SoC the experimental treatment strategy is optimal from it's min 0.016 all the way through every value in the range to it's max: 0.024 

# p_FA3_SoC	Experimental.Treatment	1.6000000000000000e-02	2.4000000000000000e-02	

# The data frame is a bit of a pain though because it returns things in scientific notation, but according to the below:

 
# Scientific Notation
# E+01 means moving the decimal point one digit to the right, E+00 means leaving the decimal point where it is, and E–01 means moving the decimal point one digit to the left. Example: 1.00E+01 is 10, 1.33E+00 stays at 1.33, and 1.33E–01 becomes 0.133.
# https://neo.ne.gov/programs/stats/inf/79.htm#:~:text=Scientific%20Notation,-The%20scientific%20notation&text=E%2B01%20means%20moving%20the,1.33E%E2%80%9301%20becomes%200.133.

# There's also a good calculator to do this for you here: https://www.free-online-calculator-use.com/scientific-notation-converter.html#

# https://rdrr.io/github/DARTH-git/dampack/man/owsa_opt_strat.html


# Like owsa_tornado(), the return argument in owsa_opt_strat() allows the user to access a tidy data.frame that contains the exact values used to produce the plot.

# owsa_opt_strat(o, 
#                return = "data")

# https://cran.r-project.org/web/packages/dampack/vignettes/psa_analysis.html



# If return == "plot", a ggplot2 optimal strategy plot derived from the owsa object, or if return == "data", a data.frame containing all data contained in the plot. The plot allows us to see how the strategy that maximizes the expectation of the outcome of interest changes as a function of each parameter of interest.

# Visualize optimal strategy (max NMB) over each parameter range
# owsa_opt_strat(my_owsa_NMB)

# facet_ncol	
# Number of columns in plot facet.

# facet_nrow	
# number of rows in plot facet.

# txtsize
# base text size

# facet_lab_txtsize	
# text size for plot facet labels (I think this allows me change the size of the text on the plots and the size of the numbers, ledgend, etc., independently).

# Explained here: 

# https://cran.r-project.org/web/packages/dampack/vignettes/dsa_generation.html

# https://cran.r-project.org/web/packages/dampack/vignettes/psa_analysis.html

# https://rdrr.io/github/DARTH-git/dampack/man/owsa_opt_strat.html

# https://www.quantargo.com/help/r/latest/packages/dampack/1.0.1/owsa_opt_strat

# Again, this is something that doesnt work too well with ICERs, with a NMB it is easy to see what the optimal strategy is, with am ICER it's not so easy unless you are telling your code what the willingness to pay threshold is, and it's doing the ICER calculation and then comparing this to the WTP threshold to see which approach is most cost-effective. But I think this code is really set up for NMB and telling you what parameter values give you higher NMB values and which treatment strategies these NMB's belong to. 
```

## 08.4 Two-way sensitivity analysis (TWSA)


```r
# To conduct the two-way DSA, we call the function run_twsa_det with my_twsa_params_range. The general format of the function arguments for run_twsa_det are the same as those for run_owsa_det. In run_twsa_det, equally spaced sequences of length nsamp are created for the two parameters based on the inputs provided in the params_range argument. These two sequences of parameter values define an nsamp by nsamp grid over which FUN is applied to produce outcomes for every combination of the two parameters. https://cran.r-project.org/web/packages/dampack/vignettes/dsa_generation.html


## 4.2 Defining and performing a two-way sensitivity analysis ----

# I can also preform a TWSA on a a probabilistic sensitivity analysis (make_psa_obj) or a deterministic sensitivity analysis object (run_owsa_det) per: https://rdrr.io/github/DARTH-git/dampack/man/twsa.html

# A lot of this code should be reflective of the earlier code of the one-way sensitivity analysis, so if I'm confused as to what one thing is doing or another I can look at the piece of code that is confusing me here, and scroll back up to my explanation of that code in OWSA.

# Run deterministic two-way sensitivity analysis (TWSA) https://rdrr.io/github/DARTH-git/dampack/src/R/run_dsa.R

# To perform a two-way sensitivity analysis (TWSA), a similar data.frame with model parameters is required

# dataframe containing all parameters, their basecase values, and the min and 
# max values of the parameters of interest

df_params_TWSA <- data.frame(pars = c("HR_FP_SoC", "HR_FP_Exp"),
                             min  = c(Minimum_HR_FP_SoC, Minimum_HR_FP_Exp),  # min parameter values
                             max  = c(Maximum_HR_FP_SoC, Maximum_HR_FP_Exp) # max parameter values
)



# We could have chosen any of the below from our OWSA data.frame to use as our parameters:
# df_params_OWSA <- data.frame(
#   pars = c("HR_FP_Exp", "HR_FP_SoC", "p_PD", "p_FD_SoC", "p_FD_Exp", "p_FA1_SoC", "p_A1F_SoC", "p_A1D_SoC", "p_FA2_SoC", "p_A2F_SoC", "p_A2D_SoC", "p_FA3_SoC", "p_A3F_SoC", "p_A3D_SoC", "c_F_SoC", "c_F_Exp", "c_P","c_AE1", "c_AE2", "c_AE3", "d_e", "d_c", "u_F", "u_P", "u_AE1", "u_AE2", "u_AE3"),   # names of the parameters to be changed
#   min  = c(Minimum_HR_FP_Exp, Minimum_HR_FP_SoC, Minimum_p_PD, Minimum_p_FD_SoC, Minimum_p_FD_Exp, Minimum_p_FA1_SoC, Minimum_p_A1F_SoC, Minimum_p_A1D_SoC, Minimum_p_FA2_SoC, Minimum_p_A2F_SoC, Minimum_p_A2D_SoC, Minimum_p_FA3_SoC, Minimum_p_A3F_SoC, Minimum_p_A3D_SoC, Minimum_c_F_SoC, Minimum_c_F_Exp, Minimum_c_P, Minimum_c_AE1, Minimum_c_AE2, Minimum_c_AE3, Minimum_d_e, Minimum_d_c, Minimum_u_F, Minimum_u_P, Minimum_u_AE1, Minimum_u_AE2, Minimum_u_AE3),         # min parameter values
#   max  = c(Maximum_HR_FP_Exp, Maximum_HR_FP_SoC, Maximum_p_PD, Maximum_p_FD_SoC, Maximum_p_FD_Exp, Maximum_p_FA1_SoC, Maximum_p_A1F_SoC, Maximum_p_A1D_SoC, Maximum_p_FA2_SoC, Maximum_p_A2F_SoC, Maximum_p_A2D_SoC, Maximum_p_FA3_SoC, Maximum_p_A3F_SoC, Maximum_p_A3D_SoC, Maximum_c_F_SoC, Maximum_c_F_Exp, Maximum_c_P, Maximum_c_AE1,  Maximum_c_AE2, Maximum_c_AE3, Maximum_d_e, Maximum_d_c, Maximum_u_F, Maximum_u_P, Maximum_u_AE1, Maximum_u_AE2, Maximum_u_AE3)          # max parameter values
# )
# 

# It's a pain, but we have to only enter 2 parameters of interest at a time into our model per the error built into the source code for run_twsa_det:

# "two-way sensitivity analysis only allows for and requires 2 different paramters of interest at a time" https://rdrr.io/github/DARTH-git/dampack/src/R/run_dsa.R

# And:

# The structure of the function is very similar to run_owsa_det(). The primary difference is the function can only take two parameters at a time in the params_range. https://syzoekao.github.io/CEAutil/


# The TWSA is performed using the run_twsa_det function


TWSA_DSAICER <- run_twsa_det(params_range    = df_params_TWSA,    # dataframe with parameters for TWSA
                         params_basecase = l_params_all,      # list with all parameters, the "pars" chosen in the data.frame to be analysed here must be a subset of these.
                         
                         nsamp           = 40,                # number of parameter values. If NULL, 40 parameter values are used

 # number of parameter values

# nsamp	

# number of sets of parameter values to be generated. If NULL, 40 parameter values are used -> I think Eva Enns said these are automatically evenly spaced out values of the parameters.

# Additional inputs are the number of equally-spaced samples (nsamp) to be used between the specified minimum and maximum of each range, the user-defined function (FUN) to be called to generate model outcomes for each strategy, the vector of outcomes to be stored (must be outcomes generated by the data frame output of the function passed in FUN), and the vector of strategy names to be evaluated.

# cran.r-project.org/web/packages/dampack/vignettes/dsa_generation.html
                         
                         
                         FUN             = oncologySemiMarkov,  # function to compute outputs

# Function that takes the basecase in params_all and produces the outcome of interest. The FUN must return a dataframe where the first column is the strategy names and the rest of the columns must be outcomes. Which df_ce in the function does.

# Described here:

# https://rdrr.io/cran/dampack/man/run_twsa_det.html

                         outcomes        = c("DSAICER"),             # output to do the TWSA on
                         strategies      = v_names_strats,       # names of the strategies.The default (NULL) will use strategy names in FUN
                         progress        = TRUE, #Progress bar like before

                         n_wtp           = n_wtp               # extra argument to pass to FUN to specify the willingness to pay
)
```

```
## 
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |                                                                                  |   1%
  |                                                                                        
  |=                                                                                 |   1%
  |                                                                                        
  |=                                                                                 |   2%
  |                                                                                        
  |==                                                                                |   2%
  |                                                                                        
  |==                                                                                |   3%
  |                                                                                        
  |===                                                                               |   3%
  |                                                                                        
  |===                                                                               |   4%
  |                                                                                        
  |====                                                                              |   4%
  |                                                                                        
  |====                                                                              |   5%
  |                                                                                        
  |=====                                                                             |   6%
  |                                                                                        
  |=====                                                                             |   7%
  |                                                                                        
  |======                                                                            |   7%
  |                                                                                        
  |======                                                                            |   8%
  |                                                                                        
  |=======                                                                           |   8%
  |                                                                                        
  |=======                                                                           |   9%
  |                                                                                        
  |========                                                                          |   9%
  |                                                                                        
  |========                                                                          |  10%
  |                                                                                        
  |=========                                                                         |  10%
  |                                                                                        
  |=========                                                                         |  11%
  |                                                                                        
  |=========                                                                         |  12%
  |                                                                                        
  |==========                                                                        |  12%
  |                                                                                        
  |==========                                                                        |  13%
  |                                                                                        
  |===========                                                                       |  13%
  |                                                                                        
  |===========                                                                       |  14%
  |                                                                                        
  |============                                                                      |  14%
  |                                                                                        
  |============                                                                      |  15%
  |                                                                                        
  |=============                                                                     |  15%
  |                                                                                        
  |=============                                                                     |  16%
  |                                                                                        
  |==============                                                                    |  16%
  |                                                                                        
  |==============                                                                    |  17%
  |                                                                                        
  |==============                                                                    |  18%
  |                                                                                        
  |===============                                                                   |  18%
  |                                                                                        
  |===============                                                                   |  19%
  |                                                                                        
  |================                                                                  |  19%
  |                                                                                        
  |================                                                                  |  20%
  |                                                                                        
  |=================                                                                 |  20%
  |                                                                                        
  |=================                                                                 |  21%
  |                                                                                        
  |==================                                                                |  21%
  |                                                                                        
  |==================                                                                |  22%
  |                                                                                        
  |===================                                                               |  23%
  |                                                                                        
  |===================                                                               |  24%
  |                                                                                        
  |====================                                                              |  24%
  |                                                                                        
  |====================                                                              |  25%
  |                                                                                        
  |=====================                                                             |  25%
  |                                                                                        
  |=====================                                                             |  26%
  |                                                                                        
  |======================                                                            |  26%
  |                                                                                        
  |======================                                                            |  27%
  |                                                                                        
  |=======================                                                           |  28%
  |                                                                                        
  |=======================                                                           |  29%
  |                                                                                        
  |========================                                                          |  29%
  |                                                                                        
  |========================                                                          |  30%
  |                                                                                        
  |=========================                                                         |  30%
  |                                                                                        
  |=========================                                                         |  31%
  |                                                                                        
  |==========================                                                        |  31%
  |                                                                                        
  |==========================                                                        |  32%
  |                                                                                        
  |===========================                                                       |  32%
  |                                                                                        
  |===========================                                                       |  33%
  |                                                                                        
  |===========================                                                       |  34%
  |                                                                                        
  |============================                                                      |  34%
  |                                                                                        
  |============================                                                      |  35%
  |                                                                                        
  |=============================                                                     |  35%
  |                                                                                        
  |=============================                                                     |  36%
  |                                                                                        
  |==============================                                                    |  36%
  |                                                                                        
  |==============================                                                    |  37%
  |                                                                                        
  |===============================                                                   |  37%
  |                                                                                        
  |===============================                                                   |  38%
  |                                                                                        
  |================================                                                  |  38%
  |                                                                                        
  |================================                                                  |  39%
  |                                                                                        
  |================================                                                  |  40%
  |                                                                                        
  |=================================                                                 |  40%
  |                                                                                        
  |=================================                                                 |  41%
  |                                                                                        
  |==================================                                                |  41%
  |                                                                                        
  |==================================                                                |  42%
  |                                                                                        
  |===================================                                               |  42%
  |                                                                                        
  |===================================                                               |  43%
  |                                                                                        
  |====================================                                              |  43%
  |                                                                                        
  |====================================                                              |  44%
  |                                                                                        
  |=====================================                                             |  45%
  |                                                                                        
  |=====================================                                             |  46%
  |                                                                                        
  |======================================                                            |  46%
  |                                                                                        
  |======================================                                            |  47%
  |                                                                                        
  |=======================================                                           |  47%
  |                                                                                        
  |=======================================                                           |  48%
  |                                                                                        
  |========================================                                          |  48%
  |                                                                                        
  |========================================                                          |  49%
  |                                                                                        
  |=========================================                                         |  49%
  |                                                                                        
  |=========================================                                         |  50%
  |                                                                                        
  |=========================================                                         |  51%
  |                                                                                        
  |==========================================                                        |  51%
  |                                                                                        
  |==========================================                                        |  52%
  |                                                                                        
  |===========================================                                       |  52%
  |                                                                                        
  |===========================================                                       |  53%
  |                                                                                        
  |============================================                                      |  53%
  |                                                                                        
  |============================================                                      |  54%
  |                                                                                        
  |=============================================                                     |  54%
  |                                                                                        
  |=============================================                                     |  55%
  |                                                                                        
  |==============================================                                    |  56%
  |                                                                                        
  |==============================================                                    |  57%
  |                                                                                        
  |===============================================                                   |  57%
  |                                                                                        
  |===============================================                                   |  58%
  |                                                                                        
  |================================================                                  |  58%
  |                                                                                        
  |================================================                                  |  59%
  |                                                                                        
  |=================================================                                 |  59%
  |                                                                                        
  |=================================================                                 |  60%
  |                                                                                        
  |==================================================                                |  60%
  |                                                                                        
  |==================================================                                |  61%
  |                                                                                        
  |==================================================                                |  62%
  |                                                                                        
  |===================================================                               |  62%
  |                                                                                        
  |===================================================                               |  63%
  |                                                                                        
  |====================================================                              |  63%
  |                                                                                        
  |====================================================                              |  64%
  |                                                                                        
  |=====================================================                             |  64%
  |                                                                                        
  |=====================================================                             |  65%
  |                                                                                        
  |======================================================                            |  65%
  |                                                                                        
  |======================================================                            |  66%
  |                                                                                        
  |=======================================================                           |  66%
  |                                                                                        
  |=======================================================                           |  67%
  |                                                                                        
  |=======================================================                           |  68%
  |                                                                                        
  |========================================================                          |  68%
  |                                                                                        
  |========================================================                          |  69%
  |                                                                                        
  |=========================================================                         |  69%
  |                                                                                        
  |=========================================================                         |  70%
  |                                                                                        
  |==========================================================                        |  70%
  |                                                                                        
  |==========================================================                        |  71%
  |                                                                                        
  |===========================================================                       |  71%
  |                                                                                        
  |===========================================================                       |  72%
  |                                                                                        
  |============================================================                      |  73%
  |                                                                                        
  |============================================================                      |  74%
  |                                                                                        
  |=============================================================                     |  74%
  |                                                                                        
  |=============================================================                     |  75%
  |                                                                                        
  |==============================================================                    |  75%
  |                                                                                        
  |==============================================================                    |  76%
  |                                                                                        
  |===============================================================                   |  76%
  |                                                                                        
  |===============================================================                   |  77%
  |                                                                                        
  |================================================================                  |  78%
  |                                                                                        
  |================================================================                  |  79%
  |                                                                                        
  |=================================================================                 |  79%
  |                                                                                        
  |=================================================================                 |  80%
  |                                                                                        
  |==================================================================                |  80%
  |                                                                                        
  |==================================================================                |  81%
  |                                                                                        
  |===================================================================               |  81%
  |                                                                                        
  |===================================================================               |  82%
  |                                                                                        
  |====================================================================              |  82%
  |                                                                                        
  |====================================================================              |  83%
  |                                                                                        
  |====================================================================              |  84%
  |                                                                                        
  |=====================================================================             |  84%
  |                                                                                        
  |=====================================================================             |  85%
  |                                                                                        
  |======================================================================            |  85%
  |                                                                                        
  |======================================================================            |  86%
  |                                                                                        
  |=======================================================================           |  86%
  |                                                                                        
  |=======================================================================           |  87%
  |                                                                                        
  |========================================================================          |  87%
  |                                                                                        
  |========================================================================          |  88%
  |                                                                                        
  |=========================================================================         |  88%
  |                                                                                        
  |=========================================================================         |  89%
  |                                                                                        
  |=========================================================================         |  90%
  |                                                                                        
  |==========================================================================        |  90%
  |                                                                                        
  |==========================================================================        |  91%
  |                                                                                        
  |===========================================================================       |  91%
  |                                                                                        
  |===========================================================================       |  92%
  |                                                                                        
  |============================================================================      |  92%
  |                                                                                        
  |============================================================================      |  93%
  |                                                                                        
  |=============================================================================     |  93%
  |                                                                                        
  |=============================================================================     |  94%
  |                                                                                        
  |==============================================================================    |  95%
  |                                                                                        
  |==============================================================================    |  96%
  |                                                                                        
  |===============================================================================   |  96%
  |                                                                                        
  |===============================================================================   |  97%
  |                                                                                        
  |================================================================================  |  97%
  |                                                                                        
  |================================================================================  |  98%
  |                                                                                        
  |================================================================================= |  98%
  |                                                                                        
  |================================================================================= |  99%
  |                                                                                        
  |==================================================================================|  99%
  |                                                                                        
  |==================================================================================| 100%
```

```r
# plot(TWSA_DSAICER)

# The plot above was the code, but I've commented it out for now.

# Sometimes you see "maximise" written in people's TWSA code, why is that:

# maximize	
# If TRUE, plot of strategy with maximum expected outcome (default); if FALSE, plot of strategy with minimum expected outcome

# per: https://www.quantargo.com/help/r/latest/packages/dampack/1.0.1/plot.twsa



# [[A 2-way uncertainty analysis will be more useful if informed by the covariance between the 2 parameters of interest or on the logical relationship between them (e.g., a 2-way uncertainty analysis might be represented by the control intervention event rate and the hazard ratio with the new treatment). <file:///C:/Users/Jonathan/OneDrive%20-%20Royal%20College%20of%20Surgeons%20in%20Ireland/COLOSSUS/Briggs%20et%20al%202012%20model%20parameter%20estimation%20and%20uncertainty.pdf>]]

# The Briggs 2012 paper said to include 2 parameters in the TWSA that have a logical relationship,(e.g., a 2-way uncertainty analysis might be represented by the control intervention event rate and the hazard ratio with the new treatment), which are expected to have a relationship because the hazard ratio for the experimental strategy is multiplied by the rate of events under soc, that's how hazard ratios for experimental interventions work, they are just a multiplier for the number of events under SoC in order to give number of events under Exp care, so more events under SoC means more events under the experimental strategy when it's hazard ratio is applied to the number of events under SoC. In the model, the function is called in the sensitivity analysis and applies a hazard ratio

# I also describe applying the Exp HR to the post changes SoC in my function where this is done.

# I can't use Free to Progressed probabilities, because now those probabilities are time-sensitive, so if I try to change these here and include them in the TWSA I'll be including too many things, just like in the tornado diagram, as I explain in my description on hazard ratios.

# Minimum_p_FP_SoC <- p_FP_SoC - 0.20*p_FP_SoC

# Maximum_p_FP_SoC <- p_FP_SoC + 0.20*p_FP_SoC

# Minimum_p_FP_Exp <- p_FP_Exp - 0.20*p_FP_Exp

# Maximum_p_FP_Exp <- p_FP_Exp + 0.20*p_FP_Exp

# To address this, I can apply this mean, max and min to the hazard ratios instead, knowing that when run_owsa_det is run in the sensitivity analysis it calls the oncology_semi_markov_function to run and in this function the hazard ratios generate the survivor function, and then these survivor functions are used to generate the probabilities (which will be cycle dependent), so I am varying the transition probabilities by 20% using a static value.


# Alterantive modelling approach I could try here if so inclined:


# "When the base-case result of an analysis strongly favors one alternative, a threshold analysis may be presented as a worst-case or ''even if'' analysis (e.g., ''Even if the risk reduction is as low as X, the ICER remains below Y,'' or ''Even if the relative risk reduction with alternative A is as low as X and the cost of treatment is as high as Y, alternative A dominates B''). Threshold values can easily be combined with the tornado presentation by marking them on the horizontal bars."

# <file:///C:/Users/Jonathan/OneDrive%20-%20Royal%20College%20of%20Surgeons%20in%20Ireland/COLOSSUS/Briggs%20et%20al%202012%20model%20parameter%20estimation%20and%20uncertainty.pdf>


# If for some reason I wanted a three-way sensitivity analysis per Andrew Brigg's discussion on page 8 above, there may be some code to describe doing this here: https://rdrr.io/github/syzoekao/CEAutil/src/inst/rmd/Rcode.R (github here: https://github.com/syzoekao/CEAutil/) and here: https://syzoekao.github.io/CEAutil/#44_two-way_sensitivity_analysis also saved here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\introduction to R for cost-effectiveness analysis.pdf

# Again, I think this is best suited to a NMB, where you will have 2 NMB values, one for EXP and one for SOC, for ICERAs, because it's a ratio between SoC and EXP you will only have one ICER value, and in  the code, both SOC and EXP are assigned it, so in the diagram both colours will sit on top of eachother for SOC and EXP and also, even if changing one thing changes the ICER value, it is changing it for both SOC and EXP, because they both have the same ICER, so there won't be sections of one colour and not another. 
```


```r
### PROBABILISTIC ANALYSIS ----

# We conduct a probabilistic analysis (PSA) of the model to estimate the uncertainty in the model outcomes.

# To do this, we generate samples for each model parameter from parametric distributions and evaluate the model for each set of parameter samples.


## Sampling the parameter values ----

# In order for the results reported in the PSA to be reproducible we need to set the random number seed. We also defining the number of runs, i.e., how many times we will re-sample for the parameter distributions, typically the number chosen is 10,000 in published studies, so we do that too:
n_runs <- 10000
set.seed(123)

# In the PSA, first we sample the parameter values from their distributions and store them in a data.frame.
# If a model parameter has no uncertainty and, hence, is fixed, we can set it equal to itself.


# To take random draws for the Weibull parametric survival distribution that we fitted at the start of the document using the 'flexsurv' package, we use the following piece of code.

# This applies mvrnorm (i.e., takes samples from the specified multivariate normal distribution) to the mean (mu) of 

# l_TTP_SoC_weibull$coefficients
#     shape     scale 
# 0.7700246 1.7425343 

# i.e., to the mean of the shape and the scale variables from the Weibull parametric survival distribution that we fitted.

# And gives a sigma (a positive-definite symmetric matrix specifying the covariance matrix of the variables) that is equal to the covariance between the shape and the scale variables:

# > l_TTP_SoC_weibull$cov
#             shape       scale
# shape 0.001983267 0.000291494
# scale 0.000291494 0.000782051

# You'll see that it's covariance between the two variables because you can match shape with scale twice, and each time it's the same value, so the same covariance between the two variables.

# n is just the number of samples.

# Described here:
# rdocumentation.org/packages/MASS/versions/7.3-58.1/topics/mvrnorm

# So, correlated sets (a "set" here is like one random draw from the distribution, because the draw is for shape and scale at the same time) of coefficients for the survival distribution (i.e., correlated sets of shape and scale values for the survival distribution, which are the coefficients as above) are generated using the variance-covariance matrix that was obtained from fitting the weibull distribution (the cov in l_TTP_SoC_weibull is equal to the covariance between the shape and the scale variables and is printed as a 2 by 2 matrix above) and a multivariate normal distribution (this is just saying we are applying mvrnorm to take samples from the multivariate normal distribution for the mean (mu) values of shape and scale).

# Multivariate normal distribution described here too: https://devinincerti.com/2018/02/10/psa.html'


m_coef_weibull_SoC <- mvrnorm(
  n     = n_runs, 
  mu    = l_TTP_SoC_weibull$coefficients, 
  Sigma = l_TTP_SoC_weibull$cov
)

head(m_coef_weibull_SoC)
```

```
##       shape scale
## [1,] 0.4295 5.606
## [2,] 0.3354 5.674
## [3,] 0.2912 5.562
## [4,] 0.3096 5.674
## [5,] 0.3319 5.646
## [6,] 0.2907 5.549
```

```r
m_coef_weibull_OS_SoC <- mvrnorm(
  n     = n_runs, 
  mu    = l_TTD_SoC_weibull$coefficients, 
  Sigma = l_TTD_SoC_weibull$cov
)

head(m_coef_weibull_OS_SoC)
```

```
##       shape scale
## [1,] 0.3453 6.633
## [2,] 0.3215 6.592
## [3,] 0.4090 6.688
## [4,] 0.3678 6.705
## [5,] 0.3881 6.589
## [6,] 0.3973 6.650
```

```r
# Now that we have applied mvrnorm to get a random shape and a random scale we don't need to include HR_FP_SoC in our data.frame to create random probability draws for SoC, because we can just select the shape and scale from m_coef_weibull_SoC so that in our function the updated coef_weibull_shape_SoC and coef_weibull_scale_SoC are used to generate S_FP_SoC with a random value, which will in turn generate transition probabilities under standard of care with a random value.










 # According to:
#
# C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Health Economic Modeling in R A Hands-on Introduction\Health-Eco\Markov models\markov_smoking_probabilistic.R
# 
# 
# It is OK to do the following:
# 
# # QALY associated with 1-year in the smoking state is Normal(mean = 0_95, SD = 0_01)
# # Divide by 2 as cycle length is 6 months
# state_qalys[, "Smoking"] <- rnorm(n_samples, mean = 0.95, sd = 0.01) / 2
#   
# So, when doing probabilistic sensitivity analysis and I need my mean and sd for the method of moments this may be useful information when drawing these from population norms.
# This will also be useful for utility and PSA in the adverse event setting.


# I create the SD to include in the sensitivity analysis applied to the hazard ratio below, as I need to create it outside the data.frame for the PSA:

UpperCI <- 0.87
LowerCI <- 0.53
SD <- (log(UpperCI) - log(LowerCI)) / 3.92

MEAN_HR_FP_Exp <- HR_FP_Exp
# I copy the hazard ratio above in case the below would start building HR_FP_Exp from the updated HR_FP_Exp made from random draws, i.e., in case it started including the HR_FP_Exp updated from the random draws from HR_FP_Exp in meanlog = (HR_FP_Exp), when we really need to be drawing the variability from the hazard ratio we started out with, and not a hazard ratio that we started out with, but that has since already been varied and will be varied from again if we take a random draw from this pre-varied hazard ratio.

# HR_FP_Exp = rlnorm(n_runs, meanlog = log(HR_FP_Exp), sdlog = SD)

# !!! I MAY NEED TO REPEAT THIS FOR: HR_PD_Exp

# I create the SD to include in the sensitivity analysis applied to the hazard ratio below, as I need to create it outside the data.frame for the PSA:

OS_UpperCI <- 0.86
OS_LowerCI <- 0.49
OS_SD <- (log(OS_UpperCI) - log(OS_LowerCI)) / 3.92

MEAN_HR_PD_Exp <- HR_PD_Exp
# I copy the hazard ratio above in case the below would start building HR_FP_Exp from the updated HR_FP_Exp made from random draws, i.e., in case it started including the HR_FP_Exp updated from the random draws from HR_FP_Exp in meanlog = (HR_FP_Exp), when we really need to be drawing the variability from the hazard ratio we started out with, and not a hazard ratio that we started out with, but that has since already been varied and will be varied from again if we take a random draw from this pre-varied hazard ratio.




# Below I create the data.frame that I will use in the PSA.
# So, this is the PSA input dataset.

df_PA_input <- data.frame(
  coef_weibull_shape_SoC = m_coef_weibull_SoC[ , "shape"],
  coef_weibull_scale_SoC = m_coef_weibull_SoC[ , "scale"],
  coef_TTD_weibull_shape_SoC = m_coef_weibull_OS_SoC[ , "shape"],
  coef_TTD_weibull_scale_SoC = m_coef_weibull_OS_SoC[ , "scale"],
             

  
### Hazard Ratios  
  
# People use exp for rnorm (i.e., to make random draws from a normal distribution) but I to use want rlnorm.

#  HR_FP_Exp = exp(rnorm(n_runs, log(0.6), 0.08))

# The rlnorm() function in R is used for generating random draws from a log-normal distribution.
 
# To make draws from the log-normal distribution you need to enter a hazard ratio and standard deviation.

# If you find a hazard ratio and confidence interval in the literature, rather than a hazard ratio and a standard deviation, you can make conversions to a standard deviation.

# To generate random draws for the hazard ratio, I need a mean for the hazard ratio(just the hazard ratio value itself), and a standard deviation built from the 95% confidence interval of the hazard ratio (the SD is built from log(Upper CI) - log(Lower CI)/2*SE, so sd is already built from logs for inclusion in rlnorm and doesnt need to be set as sdlog = log() unlike meanlog = log() where you need to take the log of the hazard ratio value). 


# SD: (natural log(Upper confidence interval) -  natural log(lower confidence interval) / 2*Standard error (i.e. 1.95*2 = 3.92 for a 95% confidence interval)


# So, it looks like I take the natural log of the upper limit minus the natural log of the lower limit (in confidence intervals the lower limit is reported on the left and the upper limit is reported on the right, so it would be 95% CI (30.0 [LOWER LIMIT], 34.2[UPPER LIMIT]), and I would rearrange these to have [ln(UPPER LIMIT) - ln(LOWER LIMIT)], i.e., [ln(34.2)-ln(30.0)]) and divide by 2 times the standard error. Provided the sample size is large, then for the 95% confidence interval this would be 2 x 1.96 = 3.92 For 90% confidence intervals 3.92 should be replaced by 3.29, and for 99% confidence intervals it should be replaced by 5.15. 

# I often come across hazard ratios and their confidence intervals in the published literature on clinical trials, but rarely do I see standard deviations. 
 
# A typical example from the literature is the following: "HR, 0.69; 95% CI, 0.54 to 0.89 in mCRC for cetuximab plus FOLFOX-4 vs FOLFOX-4 alone" -  https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7044820/pdf/bmjopen-2019-030738.pdf:
# 
# To compute the standard deviation for hazard ratios from the above typical reports in the literature, so that I can then generate random draws from a log-normal distribution for a hazard ratio I would do the following:
# 
# (natural log(Upper confidence interval) -  natural log(lower confidence interval) / 2*Standard error (i.e. 1.95*2 = 3.92 for a 95% confidence interval)
# 
# or in R: (log(0.89) - log(0.54)) / 3.92 = 0.1274623
# 
# 
# UpperCI <- 0.89
# LowerCI <- 0.54
# SD <- (log(UpperCI) - log(LowerCI)) / 3.92
# SD = 0.1274623
# 

# If I need to provide a citation for this formula I can use the below which, although this does not provide the formula I use, it provides enough information that is similar to the above, and which I could say ultimately informed the formula:
# Higgins, J. P. T., & Deeks, J. J. (2011). Chapter 7.7. 3.3: Obtaining standard deviations from standard errors, confidence intervals, t values and P values for differences in means. Cochrane handbook for systematic reviews of interventions, Version, 5(0).
# 
# 
# This approach is also supported by the following post, which provides good clarity on all of the above:
# 
# https://stats.stackexchange.com/questions/546192/calculate-the-standard-deviation-from-a-hazard-ratios-confidence-interval


# random draws from a log-normal distribution

# hr_draws <- rlnorm(nsims, meanlog = log(mean), sdlog = SD). 

# 
# We take random draws from the log-normal distribution for ratios, because if we were to take random draws from the ratio as it stands, because the hazard ratio can't go any lower than 0 but can go to plus infinity, our random draws would be skewed in the values we take from the distribution, on the other hand, if we were to put things on the natural log scale we would be taking our random draws from a more normalised distribution. So, you'll see that in:
# 
# rlnorm(n_sim, meanlog = log(mean),  sdlog = SD)
# 
# it's the log of the mean (the ratio value, so the hazard ratio) and the log of the standard deviation (which we put on the log scale when we calculate it so we don't need to put in as sdlog = log() here, just sdlog = ) in order to be taking random draws from a log-normal distribution (i.e. a log normally distributed HAZARD RATIO).

HR_FP_Exp = rlnorm(n_runs, meanlog = log(MEAN_HR_FP_Exp), sdlog = SD),
HR_PD_Exp = rlnorm(n_runs, meanlog = log(MEAN_HR_PD_Exp), sdlog = OS_SD),


# Per [SLIDE 16] onwards in C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\notes.txt I don't think we need to worry about the duration of time a hazard ratio refers to. In my model I definitely don't, as the hazard ratio and underlying rate survival curves that make up SoC transition probabilities come from the same paper, and thus the same time period. 























#### To generate random draws for the probabilities:

# IMPORTANT, THIS VALUE IS BOUNDED BY 1 OR 0:
# When calculating se from point estimates, remember that utility and probability values cannot be less than 0 or greater than 1, so don't calculate a min or max that is less than 0 or greater than 1. If you do, then change it to be 0 or 1, as appropriate, i.e., rather than 1.02, make it 1.

# When, as in slide 12 of C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\a212ProbabilisticDistributions-210604-154.pdf you can have many transitions from one state into others [i.e. in A you can stay in State A or you can go into State B, State C or State D rather than just going from state C into State D] it's not clear how you can do this in the beta code.

# i.e., when alpha values are all the times things happened, while  beta values are all the times they didnt, how do you apply 

# transistion_probabiliy <- rbeta(n_runs,alpha,beta)
# when there are so many things that can happen?

# FOR NON-MULTI STATE, I.E. FOR THE SICK TO DEAD STATE IN THE MARKOV MODEL YOU CAN APPLY THE BETA DISTRIBUTION, BECAUSE YOU CAN ONLY LEAVE (ALPHA) OR STAY (BETA).

# Sometimes a Dirichlet is suggested, a Dirichlet distribution is the multidimensional generalization of the beta distribution, so it's the same as applying the beta distribution, - as per: https://www.rdocumentation.org/packages/rBeta2009/versions/1.0/topics/rdirichlet but I would need to have all the counts included I think, which works when you are drawing all your transition data from one larger dataset, like in a clinical trial, but my data necessarily comes from several sources, so I if I just build everything as conditional probabilities, per my notes in this Notepad [search 19/08/22: in C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\notes.txt] in combination with the slides [C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\a212ProbabilisticDistributions-210604-154.pdf] these are notes on, that is 1-Probabilities like I've done in R already, then I should be able to apply a Beta distribution to each probability and not have to worry about applying a Dirichlet.

# Here's a quote explaining how best to do that from my notes above:

# "In the above you would have a beta distribution with parameters 731, 527 [the 512+15] to look at whether you stayed in State B and then, conditional on leaving State B, we could assign another beta distribution with parameters 512 and 15 to whether you, conditional on having left State B then transited to State C. And, of course, death is then the third category. Death is the residual probability. [i.e., conditional on having left state B is 1-the probability of staying in State B, so you could apply a Beta distribution to the probability of going into State C multiplied by 1-the probability of staying in State B. Death would be 1-the probability you create of moving into State C, because if you're not going into State C then you're going into Death as there's nowhere else for you to go, I think if you wanted to apply a Beta distribution to Death you could apply a Beta distribution to the probability of going into Death and then multiply that by 1-the probability of staying in the B state]."

# Conditional probabilities are built from the below p_'s in the function, so you basically create the beta distribution probabilities below as p_'s, and then in the function you multiply them by 1-whatever probability as necessary such that they become conditional probabilities.

##1

# Fitting Beta distributions to (constant) probability parameters [I guess the "constant" here is to clarify that this isnt how you do it for time varying transition probabilities, like the transition probabilities I create from Weibull].

# There are two main ways to do this, per: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.3 Practical exercise R\A231_Making_Models_Proba.pdf say you had something like the following printed in a study:

# ‘The hospital records of a sample of 100 patients receiving a primary THR were examined retrospectively. Of these patients, two patients died either during or immediately following the procedure. The operative mortality for the procedure is therefore estimated to be 2%.’

# You could use this information directly to specify the parameters (alpha and beta) of a beta distribution for the probability of operative mortality during primary surgery. These are noted by “a.” and “b.” respectively. Your alpha values are all the times things happened, while your beta values are all the times they didnt, so 2 and 98.

# alpha <- 2 ## alpha value for operative mortality from primary surgery
# beta <- 100- alpha ## beta value for operative mortality from primary surgery

# tp.PTHR2dead <- rbeta(n_runs,alpha,beta) ## Operative mortality rate  (OMR) following primary THR

# (as coded in C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.3 Practical exercise R\A233_Making_Models_Probabilistic_Solutions-210604 (1))

# The question is, does this give the transition probability for the time period that the quote describes? Well in the same pdf and r code as above you have the following:

# "The following information has been provided to you concerning revision procedures among patients already having had a revision operation (i.e. the re-revision risk). ‘The hospital records of a sample of 100 patients having experienced a revision procedure to replace a failed primary THR were reviewed at one year. During this time, four patients had undergone a further revision procedure.’iv) Use this information to fit a constant transition probability for the annual re-revision rate parameter (tp.rrr), using the same approach as for operative mortality above. Your beta value for re-revision risk should be equivalent to 96."


# a.rrr <- 4   ## alpha value for re-revision risk
# b.rrr <- 100-a.rrr  ## beta value for re-revision risk
# tp.rrr <-rbeta(1,a.rrr,b.rrr) ## Re-revision risk transition probability

# tp.PTHR2dead
# tp.RTHR2dead
# tp.rrr


# Because the cycle length in the model is one year according to page 3 of C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A1_Advanced Markov Modelling\A1.3 Practical exercise R\A131_Advanced_Markov_Modelling_Instructions-210528-18 this indicates that it does.


##2
                          # METHOD OF MOMENTS:


# In cases where you don't have this information, but you do have a mean and a standard error, you can do the following (per: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\notes.txt):

# My initial reading for probabilistic analysis with probabilities suggested that the method of moments can be applied to a mean and standard error for a transition probability sourced from the literature to create an appropriate alpha and beta to use in a probabilistic sensitivity analysis:

# So, I built the following code to translate the formula for the methods of moments into R, to allow us to take our transition probabilities from the literature:
# 
# 
#  ## Methods of moments
# 
# 
# #Assume the below mean and std error come from the reported literature
# 
# mean <- 0.75 ## mean from the literature
# std.error <- 0.04 ## standard error from the literature
# 
# # The method of moments can be coded up as below to get the alpha and beta from the sample using the mean and standard error from the sample:
# 
# alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1 ## alpha + beta (ab)
# alpha <- mean*alpha.plus.beta ## alpha (a)
# beta <- alpha*(1-mean)/mean ## beta(b)
# 
# # Following this, you can randomly draw from the beta distribution using the below, I only have one random draw, but you could change that 1 to 10,000 (the standard number of draws) and save these as a matrix of draws to use in your probabilistic sensitivity analysis:
# 
# probabilistic.beta.dist.draw <- rbeta(1,alpha,beta) ## drawing from the Beta distribution based on a and b

# Per the above pdf:

# "Note that the rbeta function takes 3 arguments, first the number of draws or samples, the alpha parameter (named shape1) and the beta parameter (named shape2)." 
# "rbeta(n = 5, shape1 = 50, shape2 = 100)"

# while in their R code they use the below, as included above, so I don't think it matters if you include shape1= or just include the alpha and beta directly, but I'll keep it as below, as that's how DARTH do it. 

# tp.rrr <-rbeta(1,a.rrr,b.rrr) ## Re-revision risk transition probability

# The below gives the same results either way:

# set.seed(100)
# n = 1
# b4 <- rbeta(n, shape1 = 2, shape2 = 8)
# b4
# [1] 0.1329533
# 
# set.seed(100)
# n = 1
# b4 <- rbeta(n, 2, 8)
# b4
# [1] 0.1329533

## 3

# RANGE:

# I don't describe generating random draws when the probabilities don't have an SE above, however, I can do this in the same way that I figured out how to do this for the utility beta distributions below. If they are reported with a range, he section on utility below also advises how to handle this.




# Brigs code to generate the SE for a parameter with a range perfectly centered around the mean (briggsse), and then repeated but for the situations where the range isnt PERFECTLY centered around the mean (altbriggsse), i.e., the min is further away from the mean than the max, or vice versa (even a little):

max <- 0.22,
min <- 0.12,  
mean <- P_OSD_SoC,

briggsse <- ((max)-(mean))/1.96,
# altbriggsse <- (max-min)/(2*1.96),

## Generating the alpha and beta:

std.error <- briggsse, ## briggsse OR altbriggsse - as appropriate
alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1, ## alpha + beta (ab)
alpha.plus.beta,
alpha <- mean*alpha.plus.beta, ## alpha (a)
beta <- alpha*(1-mean)/mean, ## beta(b)
alpha,
beta,
 
P_OSD_SoC       = rbeta(n_runs, shape1 =  alpha, shape2 = beta),
mean(P_OSD_SoC),
P_OSD_SoC_alpha <- alpha,
P_OSD_SoC_beta <- beta,



max <- 0.22,
min <- 0.12,  
mean <- P_OSD_Exp,

briggsse <- ((max)-(mean))/1.96,
# altbriggsse <- (max-min)/(2*1.96),

## Generating the alpha and beta:

std.error <- briggsse, ## briggsse OR altbriggsse - as appropriate
alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1, ## alpha + beta (ab)
alpha.plus.beta,
alpha <- mean*alpha.plus.beta, ## alpha (a)
beta <- alpha*(1-mean)/mean, ## beta(b)
alpha,
beta,

P_OSD_Exp       = rbeta(n_runs, shape1 =  alpha, shape2 = beta),
mean(P_OSD_Exp),
P_OSD_Exp_alpha <- alpha,
P_OSD_Exp_beta <- beta,




mean<-   p_FA1_STD,
Maximum <- Maximum_p_FA1_STD,
Maximum,
se <- ((Maximum) - (mean)) / 2,
se,  
std.error <- se,
alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1, ## alpha + beta (ab)
alpha <- mean*alpha.plus.beta, ## alpha (a)
beta <- alpha*(1-mean)/mean, ## beta(b)
alpha,
beta,

p_FA1_STD        = rbeta(n_runs, shape1 =  alpha, shape2 = beta), 

alpha_p_FA1_STD <- alpha,
beta_p_FA1_STD <- beta,



mean<-   p_FA2_STD,
Maximum <- Maximum_p_FA2_STD,
Maximum,
se <- ((Maximum) - (mean)) / 2,
se,  
std.error <- se,
alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1, ## alpha + beta (ab)
alpha <- mean*alpha.plus.beta, ## alpha (a)
beta <- alpha*(1-mean)/mean, ## beta(b)
alpha,
beta,

p_FA2_STD        = rbeta(n_runs, shape1 =  alpha, shape2 = beta), 

alpha_p_FA2_STD <- alpha,
beta_p_FA2_STD <- beta,



mean<-   p_FA3_STD,
Maximum <- Maximum_p_FA3_STD,
Maximum,
se <- ((Maximum) - (mean)) / 2,
se,  
std.error <- se,
alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1, ## alpha + beta (ab)
alpha <- mean*alpha.plus.beta, ## alpha (a)
beta <- alpha*(1-mean)/mean, ## beta(b)
alpha,
beta,

p_FA3_STD        = rbeta(n_runs, shape1 =  alpha, shape2 = beta), 

alpha_p_FA3_STD <- alpha,
beta_p_FA3_STD <- beta,



mean<-   p_FA1_EXPR,
Maximum <- Maximum_p_FA1_EXPR,
Maximum,
se <- ((Maximum) - (mean)) / 2,
se,  
std.error <- se,
alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1, ## alpha + beta (ab)
alpha <- mean*alpha.plus.beta, ## alpha (a)
beta <- alpha*(1-mean)/mean, ## beta(b)
alpha,
beta,

p_FA1_EXPR        = rbeta(n_runs, shape1 =  alpha, shape2 = beta), 

alpha_p_FA1_EXPR <- alpha,
beta_p_FA1_EXPR <- beta,



mean<-   p_FA2_EXPR,
Maximum <- Maximum_p_FA2_EXPR,
Maximum,
se <- ((Maximum) - (mean)) / 2,
se,  
std.error <- se,
alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1, ## alpha + beta (ab)
alpha <- mean*alpha.plus.beta, ## alpha (a)
beta <- alpha*(1-mean)/mean, ## beta(b)
alpha,
beta,

p_FA2_EXPR        = rbeta(n_runs, shape1 =  alpha, shape2 = beta), 

alpha_p_FA2_EXPR <- alpha,
beta_p_FA2_EXPR <- beta,



mean<-   p_FA3_EXPR,
Maximum <- Maximum_p_FA3_EXPR,
Maximum,
se <- ((Maximum) - (mean)) / 2,
se,  
std.error <- se,
alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1, ## alpha + beta (ab)
alpha <- mean*alpha.plus.beta, ## alpha (a)
beta <- alpha*(1-mean)/mean, ## beta(b)
alpha,
beta,

p_FA3_EXPR        = rbeta(n_runs, shape1 =  alpha, shape2 = beta), 

alpha_p_FA3_EXPR <- alpha,
beta_p_FA3_EXPR <- beta,






  



# Calculate the mean, maximum and variance of the Beta and Gamma here: https://www.pluralsight.com/guides/beta-and-gamma-function-implementation-in-r also saved here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\R Guide_ Beta and Gamma Function Implementation _ Pluralsight.pdf




  # Cost vectors with length n_runs


##  Costs


# 1) COSTS WITH A RANGE:



# Maximum <- SOMEVALUEHERE
# Mean <- SOMEVALUEHERE

# se <- ((Maximum) - (Mean)) / 2
# se                                  
 
# mean <-Mean
# mean
 
# mn.cIntervention <- mean ## mean cost of intervention
# se.cIntervention <- se ## standard error of cost of intervention
 
# a.cIntervention <- (mn.cIntervention/se.cIntervention)^2 ## alpha value for cost of intervention (shape)
# b.cIntervention <- (se.cIntervention^2)/mn.cIntervention ## beta value for cost of intervention (scale)
 
# a.cIntervention
# b.cIntervention
 
 
# c_H   = rgamma(n_sim, shape = a.cIntervention, scale = b.cIntervention),  # cost of intervention
 
# If costs are reported with a 95% confidence interval the maximum is the upper confidence interval. If the interval is not centered on the mean, use the maximum or minimum in place of the upper confidence interval, depending on which one is further away from the mean SE = (m-CIlower)/t, here the bit in the brackets is rearranged when dealing with lower limits to have the MEAN minus the lower confidence interval so that things don't become negative (because the lower value will of course always be lower than the mean, as it's supposed to be below the mean, so a smaller number minus a larger number will be negative), but when the interval is centered on the mean the formula of SE = (CIupper-m)/t and SE = (m-CIlower)/t are inherently doing the same thing, that is getting the difference between the mean and the confidence interval and dividing this by t. So both formulas are options to use in getting the SE, and an author may choose to use the one which incorporates the interval that is farthest from the mean in order to incorporate as much variability in doing this SE calculation as possible, i.e. to reflect the variability in their SE calculation.

# 
# As per: https://stats.stackexchange.com/questions/550293/how-to-calculate-standard-error-given-mean-and-confidence-interval-for-a-gamma-d/550892#550892
 
 
# "I would like to note that, while those values in the table happen to correspond with ±2σ, the minimum and maximum values do not generally follow such simple formula with mean plus-minus some standard deviation.
 
# In this case, the minimum and maximum values only correspond to the interval μ±2σ because the distribution seems to have been truncated at those values."
 
 
# i.e., my formula will only work if the minimum and maximum values reported in a study are ±2 SE from the mean, i.e. + 2 SE from the mean for the maximum value, and -2 SE from the mean for the minimum value.
 
# And that will be the case any time there is a 95% Confidence Interval:
 

# [ "Since 95% of values fall within two standard deviations of the mean according to the 68-95-99.7 Rule, simply add and subtract two standard deviations from the mean in order to obtain the 95% confidence interval. Notice that with higher confidence levels the confidence interval gets large so there is less precision." https://www.westga.edu/academics/research/vrc/assets/docs/confidence_intervals_notes.pdf also saved here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\gammadist\confidence_intervals_notes.pdf

# A good image can be found as per: https://www.quora.com/What-is-meant-by-one-standard-deviation-away-from-the-mean also saved here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\gammadist\www-quora-com-What-is-meant-by-.pdf]

# So, if I'm taking my costs and a range about these costs from the literature, I just need to make sure the range is a 95% Confidence Interval, like that reported here: Tilson, L., Sharp, L., Usher, C., Walsh, C., Whyte, S., O’Ceilleachair, A., ... & Barry, M. (2012). Cost of care for colorectal cancer in Ireland: a health care payer perspective. The European journal of health economics, 13(4), 511-524. (https://www.researchgate.net/publication/51188456_Cost_of_care_for_colorectal_cancer_in_Ireland_A_health_care_payer_perspective) reports a cost in Table 3 for Colorectal cancer with a 95% CI: € 48,835 (€40,548–€62,582)..

# For "PK test cost MEAN: 400.00 MIN: 300.00 MAX: 500.00" from Table 4, row 3 page 222 in Goldstein, D. A., Chen, Q., Ayer, T., Howard, D. H., Lipscomb, J., Harvey, R. D., ... & Flowers, C. R. (2014). Cost effectiveness analysis of pharmacokinetically-guided 5-fluorouracil in FOLFOX chemotherapy for metastatic colorectal cancer. Clinical colorectal cancer, 13(4), 219-225 plugged into the formula above to find the SE, I get an SE of 50, so plugging the 50 and mean into the CI = m ± t*SE from Jochen above I get:
 
# 400 + 2*50 = 500
 
# 400 - 2*50 = 300
 
# Which is the same confidence interval as I got in the Table 4 row 3, i.e. 300 and 500.
 
# So, this might be a good way to check if my standard error is correct. Although this will only work if my confidence interval is centred on the mean, i.e. if I am the same distance from the mean to the max and to the min. If my confidence interval is NOT centred on the mean, I can calculate 2 standard errors, one between the lower interval and the mean, and one between the upper interval and the mean, and then apply these in CI = m ± t*SE, knowing that:

# CIupper = m + t*SE

# CIlower = m - t*SE

# I've figured out a simple test for whether the max/min reported is ±2σ:
# se <- ((Max) - (Mean)) / 2
# MaxMatch <- Mean + 2*se 
# MinMatch <- Mean - 2*se
 
# I can then check if the max/min reported in a Table match the above, and if so I know that the max/min reported is ±2σ.
 
# If not, it may be that they used the se off the minimum as it's further away, so try the below:
 
# se <- ((Mean) - (Min)) / 2
# MaxMatch <- Mean + 2*se 
# MinMatch <- Mean - 2*se
 
 
# I can then check if the max/min reported in a Table match the above, and if so I know that the max/min reported is ±2σ.
 
 
 
 
# Even if it's not symmetric, this may still be a 95% confidence interval if the mean is at 2 of one of the standard errors from the min or the max, we can see this in action below:
 
 
# > Maximum <- 27655.84
# > Mean <- 11565.60
# > 
# > se <- ((Maximum) - (Mean)) / 2
# > se                                  
# [1] 8045.12
# > 
# > MaxMatch <- Mean + 2*se 
# > MinMatch <- Mean - 2*se
# > MaxMatch
# [1] 27655.84
# > MinMatch
# [1] -4524.64
 
# But still, for these values
 
# FN: Value: 11,565.60 Minimum: 7092.16 Maximum: 27,655.84  Distribution: γ: (2.067, 5596.247)
 
# that are not centered on the mean, this still came out the same as the Table using this se <- ((Maximum) - (Mean)) / 2 method. Because looking at the below, the upper interval (the maximum) is further from the mean at a difference of 16090.24, than the lower interval (the minimum) at a difference between it and the mean of 4473.44 (i.e. the maximum is nearly four times further away from the mean that the minimum).
 
 
# > Maximum <- 27655.84
# > Minimum <- 7092.16
# > Mean <-  11565.60
  
# > Maximum - Mean
# [1] 16090.24
  
# > Mean - Minimum
# [1] 4473.44
 
 
# And when we plug the se in for the further away max we get:
 
 
# > a.cIntervention
# [1] 2.066671
# > b.cIntervention
# [1] 5596.247
 
# Just the same as the values for FN above.
# 

# So, this kind of applies to situations where an interval is reported, when you might want to check if it's a 95% confidence interval, and if not, which interval is furthest from the mean, in cases of a point estimate only, you do the following:




# 2) POINT ESTIMATE ONLY:

# If they arent reported with a 95% confidence interval, the Goldstein paper says: "Drug costs were varied within +/-20% of their baseline values as previously done by Goulart and Ramsey".
 
# I checked this for FOLFOX drug cost Min: 443.91 Value: 355.13 Max: 532.69  gamma(100, 4.439)
 
# Mean<-   443.91
# Maximum <- Mean + 0.20*Mean
# Minimum <- Mean - 0.20*Mean
 
# Taking 20% plus the mean and 20% minus the mean, I get the same maximum and minimum as above, exactly:
 
# > Maximum
# [1] 532.692
# > Minimum
# [1] 355.128
 
# They still applied the SE = (CIupper-m)/t or SE = (m-CIlower)/t to this interval which they generated from 20% plus the mean and 20% minus the mean.

# In the Goldstein 2014 paper, where the ranges are more than 20% away from the mean, i.e., 25%, etc., they use the same formula for ranges that are symmetrically far from the mean, i.e., 25% bigger or smaller than the mean, and they use the same formula but incoporating the range that's furthest from the mean when generating the se when the ranges arent symmetric about the mean.





# OK, so the question is, can we apply any percentage we like to the point estimate we find for costs to generate the max or min and then just apply the formula above to generate the SE? I reviewed Koen's study below:

# Degeling, K., Franken, M. D., May, A. M., van Oijen, M. G., Koopman, M., Punt, C. J., ... & Koffijberg, H. (2018). Matching the model with the evidence: comparing discrete event simulation and state-transition modeling for time-to-event predictions in a cost-effectiveness analysis of treatment in metastatic colorectal cancer patients. Cancer epidemiology, 57, 60-67.

# C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\Matching the model with the evidence Koen

# In the excel file, on the second sheet there is a row called parameter 1. For cost this parameter is the alpha value, and when you click on 16.000 it shows the formula that created this alpha value, which is the same as for my alpha value formula above. This formula includes the mean and the SE. When I take the mean (which is just the baseline value) and plug this into the R code to generate the SE:

# I get the same se as in the excel file when making the max and min 50% larger or smaller than the mean in the code below. 
# Mean<-   2062.35
# Maximum <- Mean + 0.50*Mean
# Minimum <- Mean - 0.50*Mean
# se <- ((Maximum) - (Mean)) / 2
# se
# 515.5875

# Even more important, they apply the same code as I have for creating the alpha value above using this mean and SE generated just from taking 50% either side of the mean. 

# The implication of this is that you can generate the SE of a point estimate by taking any percentage either side of the mean and that you can also apply the code as above to generate the alpha and beta. Unfortunately in the excel file they don't create the beta in parameter 2, but the lambda, which is something else again. 


# This may solve the riddle of lambda in Koen's code, I noticed that here they use 1/Beta: https://www.pluralsight.com/guides/beta-and-gamma-function-implementation-in-r so I took that approach with the Lambda in Koen's code, plugging it in for beta, and got the same value of the mean as I started out with.

# Mean<-   2062.35
# Maximum <- Mean + 0.50*Mean
# Minimum <- Mean - 0.50*Mean
# se <- ((Maximum) - (Mean)) / 2

# se
# Maximum
# Minimum
# mean <-Mean

# mn.cIntervention <- mean ## mean cost of intervention
# se.cIntervention <- se ## standard error of cost of intervention
# a.cIntervention <- (mn.cIntervention/se.cIntervention)^2 ## alpha value for cost of intervention (shape)
# b.cIntervention <- (mn.cIntervention)/((se.cIntervention)^2) ## beta value for cost of intervention (scale) using Koen's backwards version of Andy's (se.cIntervention^2)/mn.cIntervention to generate the Lambda code.

# a.cIntervention
# b.cIntervention
# se

# c_H   = rgamma(10000, shape = a.cIntervention, scale = 1/b.cIntervention) # cost of intervention
# mean(c_H)
 

# Likewise, if I do the following:

# 1/ b.cIntervention
# I get the exact same value for b.cIntervention as when I use the original code to generate b.cIntervention from Andy, as below.

# b.cIntervention <- (se.cIntervention^2)/mn.cIntervention ## beta value for cost of intervention (scale)
# b.cIntervention

# So, it looks like the whole Lambda thing is just a different way of getting b.cIntervention, but Koen's way of doing it requires the addition of 1/ for the scale part of rgamma, while Andy's method doesnt.

# So, in this it looks like Andy is generating the scale for the beta, while Koen is generating the rate: 

# This is supported by this: 

# "Density, distribution function, quantile function and random generation for the Gamma distribution with parameters alpha (or shape) and beta (or scale or 1/rate)." https://search.r-project.org/CRAN/refmans/Rlab/html/Gamma.html 


# "There is a R function for simulating this random variable. Here in addition to the number of values to simulate, we just need two parameters, one for the shape and one for either the rate or the scale. The rate is the inverse of the scale. The general formula is: rgamma(n, shape, rate = 1, scale = 1/rate)." https://pubs.wsb.wisc.edu/academics/analytics-using-r-2019/gamma-variables-optional.html also saved here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\13.7 Gamma Variables (Optional) _ Analytics Using R.pdf

# I think the code above also implies that if you were to include it as a "rate" instead of calling it scale in the rcode for Koen's rate, then you wouldnt need to do the 1/ bit over scale. So, he may have taken this approach as well.This is supported by: "rate:	a numeric vector in the range [0, Inf) that specifies the inverse of the scale parameter." https://docs.tibco.com/pub/enterprise-runtime-for-R/4.1.1/doc/html/Language_Reference/stats/GammaDist.html

# This is supported by the below:

# > set.seed(1)
# > x <- rgamma(n = 1000, shape = 5, scale = 3)
# > mean(x)
# [1] 14.61593
# Knowing that the rate is the inverse of the scale, we can get the rate as 1/3 below:
# > 1/3
# [1] 0.3333333
# > set.seed(1)
# > x <- rgamma(n = 1000, shape = 5, rate = 0.3333333)
# > mean(x)
# [1] 14.61593
# > set.seed(1)
# > x <- rgamma(n = 1000, shape = 5, scale = 1/0.3333333)
# > mean(x)
# [1] 14.61593

# Thus, Koen generated the rate and used that in rgamma, while Andy showed me how to use scale and use that in rgamma. 


# This 20% approach is also taken by Lesley tilson and cited in her study and other studies here: https://trello.com/c/m653JBWV/48-20-cost-sensitivity

# administration_cost
Maximum <- Maximum_administration_cost,
Mean <- administration_cost,

se <- ((Maximum) - (Mean)) / 2,
se,                                  

mean <-Mean,
mean,

mn.cIntervention <- mean, ## mean cost of intervention
se.cIntervention <- se, ## standard error of cost of intervention

a.cIntervention <- (mn.cIntervention/se.cIntervention)^2, ## alpha value for cost of intervention (shape)
b.cIntervention <- (se.cIntervention^2)/mn.cIntervention, ## beta value for cost of intervention (scale)

a.cIntervention,
b.cIntervention,

administration_cost   = rgamma(n_runs, shape = a.cIntervention, scale = b.cIntervention), 

a.cIntervention_administration_cost <-a.cIntervention,
b.cIntervention_administration_cost <-b.cIntervention, 


# c_PFS_Folfox

Maximum <- Maximum_c_PFS_Folfox,
Mean <- c_PFS_Folfox,

se <- ((Maximum) - (Mean)) / 2,
se,                                  

mean <-Mean,
mean,

mn.cIntervention <- mean, ## mean cost of intervention
se.cIntervention <- se, ## standard error of cost of intervention

a.cIntervention <- (mn.cIntervention/se.cIntervention)^2, ## alpha value for cost of intervention (shape)
b.cIntervention <- (se.cIntervention^2)/mn.cIntervention, ## beta value for cost of intervention (scale)

a.cIntervention,
b.cIntervention,

c_PFS_Folfox   = rgamma(n_runs, shape = a.cIntervention, scale = b.cIntervention), 

a.cIntervention_c_PFS_Folfox <-a.cIntervention,
b.cIntervention_c_PFS_Folfox <-b.cIntervention, 

# c_PFS_Bevacizumab

Maximum <- Maximum_c_PFS_Bevacizumab,
Mean <- c_PFS_Bevacizumab,

se <- ((Maximum) - (Mean)) / 2,
se,                                  

mean <-Mean,
mean,

mn.cIntervention <- mean, ## mean cost of intervention
se.cIntervention <- se, ## standard error of cost of intervention

a.cIntervention <- (mn.cIntervention/se.cIntervention)^2, ## alpha value for cost of intervention (shape)
b.cIntervention <- (se.cIntervention^2)/mn.cIntervention, ## beta value for cost of intervention (scale)

a.cIntervention,
b.cIntervention,

c_PFS_Bevacizumab   = rgamma(n_runs, shape = a.cIntervention, scale = b.cIntervention), 

a.cIntervention_c_PFS_Bevacizumab <-a.cIntervention,
b.cIntervention_c_PFS_Bevacizumab <-b.cIntervention, 


#  c_OS_Folfiri

Maximum <- Maximum_c_OS_Folfiri,
Mean <- c_OS_Folfiri,

se <- ((Maximum) - (Mean)) / 2,
se,                                  

mean <-Mean,
mean,

mn.cIntervention <- mean, ## mean cost of intervention
se.cIntervention <- se, ## standard error of cost of intervention

a.cIntervention <- (mn.cIntervention/se.cIntervention)^2, ## alpha value for cost of intervention (shape)
b.cIntervention <- (se.cIntervention^2)/mn.cIntervention, ## beta value for cost of intervention (scale)

a.cIntervention,
b.cIntervention,

c_OS_Folfiri   = rgamma(n_runs, shape = a.cIntervention, scale = b.cIntervention), 

a.cIntervention_c_OS_Folfiri <-a.cIntervention,
b.cIntervention_c_OS_Folfiri <-b.cIntervention, 

# The cost of being dead doesnt vary, it always costs the same to treat a dead person, which is 0 because we don't give any of our chemo, etc., to a dead body.
  c_D = 0,

#  c_AE1

Maximum <- Maximum_c_AE1,
Mean <- c_AE1,

se <- ((Maximum) - (Mean)) / 2,
se,                                  

mean <-Mean,
mean,

mn.cIntervention <- mean, ## mean cost of intervention
se.cIntervention <- se, ## standard error of cost of intervention

a.cIntervention <- (mn.cIntervention/se.cIntervention)^2, ## alpha value for cost of intervention (shape)
b.cIntervention <- (se.cIntervention^2)/mn.cIntervention, ## beta value for cost of intervention (scale)

a.cIntervention,
b.cIntervention,

c_AE1   = rgamma(n_runs, shape = a.cIntervention, scale = b.cIntervention), 

a.cIntervention_c_AE1 <-a.cIntervention,
b.cIntervention_c_AE1 <-b.cIntervention, 


#  c_AE2

Maximum <- Maximum_c_AE2,
Mean <- c_AE2,

se <- ((Maximum) - (Mean)) / 2,
se,                                  

mean <-Mean,
mean,

mn.cIntervention <- mean, ## mean cost of intervention
se.cIntervention <- se, ## standard error of cost of intervention

a.cIntervention <- (mn.cIntervention/se.cIntervention)^2, ## alpha value for cost of intervention (shape)
b.cIntervention <- (se.cIntervention^2)/mn.cIntervention, ## beta value for cost of intervention (scale)

a.cIntervention,
b.cIntervention,

c_AE2   = rgamma(n_runs, shape = a.cIntervention, scale = b.cIntervention), 

a.cIntervention_c_AE2 <-a.cIntervention,
b.cIntervention_c_AE2 <-b.cIntervention, 


#  c_AE3

Maximum <- Maximum_c_AE3,
Mean <- c_AE3,

se <- ((Maximum) - (Mean)) / 2,
se,                                  

mean <-Mean,
mean,

mn.cIntervention <- mean, ## mean cost of intervention
se.cIntervention <- se, ## standard error of cost of intervention

a.cIntervention <- (mn.cIntervention/se.cIntervention)^2, ## alpha value for cost of intervention (shape)
b.cIntervention <- (se.cIntervention^2)/mn.cIntervention, ## beta value for cost of intervention (scale)

a.cIntervention,
b.cIntervention,

c_AE3   = rgamma(n_runs, shape = a.cIntervention, scale = b.cIntervention), 

a.cIntervention_c_AE3 <-a.cIntervention,
b.cIntervention_c_AE3 <-b.cIntervention, 


  # Utility vectors with length n_runs 

# There may be helpful books here: C:\Users\Jonathan\Dropbox\PhD\HTA\Markov Modelling\books



##### POINT ESTIMATES ONLY:



# IMPORTANT, THIS VALUE IS BOUNDED BY 1 OR 0:
# When calculating se from point estimates, remember that utility and probability values cannot be less than 0 or greater than 1, so don't calculate a min or max that is less than 0 or greater than 1. If you do, just round it to 0 or 1.


# If you have a point estimate, then you can generate the standard error/standard deviation using the method of moments again.

#Per Table 4 in the Goldstein paper:
# > mean<-   0.850
# > Maximum <- mean + 0.20*mean
# > Maximum
# [1] 1.02
# > Minimum <- mean - 0.20*mean
# > Minimum
# [1] 0.68
# > se <- ((Maximum) - (mean)) / 2
# > se  
# [1] 0.085
# > std.error <- se
# > alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1 ## alpha + beta (ab)
# > alpha <- mean*alpha.plus.beta ## alpha (a)
# > beta <- alpha*(1-mean)/mean ## beta(b)
# > alpha
# [1] 14.15
# > beta
# [1] 2.497059
# So, a perfect match to the Goldstein paper.
# Because this approach to point estimates ends up making the same range around this point estimate as reported in Table 4, the implication is that when a point estimate is reported with a range, you can generate the SE the exact same way as above, that is, se <- ((Maximum) - (mean)) / 2, because we are applying the same manner of generating the SE to the range that was reported in the paper, as to the point estimate.


# I double check the manner in which I calculate the SE with the excel file from Koen's paper: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\Matching the model with the evidence Koen both are saved here, but the filepath may be too long to access them without moving them to downloads or desktop.

# For his paper, I update the Maximum/Minimum part by taking the max as 50% bigger than the mean. When I do this, I get the exact same SE as he reports in the excel file, I know this because in his cells creating the alpha and beta values for utility or probability on sheet 2 of his excel file, he includes 2 numbers, one is the mean reported on sheet 1 for the parameter whose utility or probability he is taking random draws from, and then the other number is an EXACT match for the SE number I calculate, and must therefore be the SE number he calculates. Especially because he then applies a formula to this mean and SE to generate the alpha and the beta. You can see this in my model code below, where the mean and SE I report in my own analysis turn up in his alpha and beta formulas.

# Although he uses a different method to calculate the alpha and the beta, these typically work out as very close to the values calculated for the alpha and beta using my method, which Briggs told me to use once I had the SE and mean, so I think Koen just has a deeper understanding of mathematics and is using this to apply a different formula for the generation of alpha and beta from the SE and mean.

# The takeaway here is that my method for calculating SE is correct, as proven by Koen's excel file, and once I have the SE and the mean (mean is just the point estimate value I started with for this parameter) Andrew Briggs told me what to do to calculate the alpha and the beta, so I now can be confident in the manner in which I take the PSA for utility or probability when it comes to beta distributions. 
 
# mean<-   0.042178846
# Maximum <- mean + 0.50*mean
# Maximum
# Minimum <- mean - 0.40*mean
# Minimum
# 
# se <- ((Maximum) - (mean)) / 2
# se  
# 
# std.error <- se
# alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1 ## alpha + beta (ab)
# alpha.plus.beta
# alpha <- mean*alpha.plus.beta ## alpha (a)
# beta <- alpha*(1-mean)/mean ## beta(b)
# alpha
# beta
# 
# 
# 
# 
# mean: 0.042178846
# se: 0.01054471
# 
# alpha =(((0.042178846)^2)*(1-(0.042178846))/((0.01)^2)-(0.042178846))
# beta =((1-(0.042178846))*(((1-(0.042178846))*(0.042178846))/((0.01)^2)-1))
#
# My alpha and beta:
#
# > alpha
# [1] 15.28296
# > beta
# [1] 347.0541
#
# Koen's alpha and beta:
# alpha = 14.961
# beta = 363.614

# mean<-   0.042178846

# u_ME       = rbeta(10000, shape1 =  15.28296, shape2 = 347.0541)
# mean(u_ME)
# [1] 0.04208022
# u_KOEN       = rbeta(10000, shape1 =  14.961, shape2 = 363.614)
# mean(u_KOEN)
# [1] 0.03940224
# Which will both come to 0.04 if rounding to 2 decimal points

# 
# mean= 0.042178846
# se= 0.01
#  
# newalpha =(((mean)^2)*(1-(mean))/((se)^2)-(mean))
# newbeta =((1-(mean))*(((1-(mean))*(mean))/((se)^2)-1))
# > newalpha
# [1] 16.99799
# > newbeta
# [1] 385.9999
# 
# 
# manualalpha =(((0.042178846)^2)*(1-(0.042178846))/((0.01)^2)-(0.042178846))
# manualbeta =((1-(0.042178846))*(((1-(0.042178846))*(0.042178846))/((0.01)^2)-1))
# > manualalpha
# [1] 16.99799
# > manualbeta
# [1] 385.9999

## RANGE:

##### Calculating Beta values when you have a range around your point estimate in the literature (THIS CAN BE APPLIED TO PROBABILITY OR UTILITY): 


# Here are my formulas, and if you read further below you can see how I got to these formulas.

# Here's the bottomline takeaway on the Beta formuala. My SE's are typically very close to the SE's that I recover from the published studies. I've seen first hand, that you need big changes to the SE to affect the mean you draw in the PSA. So, what I'll do is apply the briggse or altbriggse as appropriate, and then when I do the PSA I'll check the mean on the parameter drawn from the PSA draws to make sure the parameter is on average the same as the one we started with, I can do this by doing mean() whatever the parameter is, and that will show me the average value.

# Briggs code to generate the SE for a parameter with a range perfectly centered around the mean (briggsse), and then repeated but for the situations where the range isnt PERFECTLY centered around the mean (altbriggsse), i.e., the min is further away from the mean than the max, or vice versa (even a little):

# briggsse <- ((max)-(mean))/1.96
# altbriggsse <- (max-min)/(2*1.96)

## Generating the alpha and beta:

# mean <- Somevaluehere

# std.error <- briggsse OR altbriggsse - as appropriate
# alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1 ## alpha + beta (ab)
# alpha.plus.beta
# alpha <- mean*alpha.plus.beta ## alpha (a)
# beta <- alpha*(1-mean)/mean ## beta(b)
# alpha
# beta
# 
# u_ME       = rbeta(10000, shape1 =  a, shape2 = b)
# mean(u_ME)

# I could also create alpha and beta using Koen's code, which is a different way of calculating these vales than what Briggs showed me, but typically gives the same alpha and beta, so can be ignored:

# newalpha =(((mean)^2)*(1-(mean))/((se)^2)-(mean))
# newbeta =((1-(mean))*(((1-(mean))*(mean))/((se)^2)-1))
# newalpha
# newbeta


# Calculating a Beta distribution when you have a range around this in the literature you are reviewing:

# All of the below applies to probabilities as well as utilities, as both are for beta distributions.

# To determine the best way to do this, I open all the sources I mention just above which include a range, se, alpha, beta, etc., and then I apply all the methods I have and see which is best. I'll also be heavily guided by the suggestions Andy made, as he has being doing this work for 2 decades, if he says that a certain way is correct, I'll take him at his word. Lesley also made some suggestions.

# Once you have an alpha and a beta, you can work your way back to a SE:


# per: https://stackoverflow.com/questions/41189633/how-to-get-the-standard-deviation-from-the-fitted-distribution-in-scipy
# As supported by this: https://www.real-statistics.com/binomial-and-related-distributions/beta-distribution/
# and using this here: Jenks, Michelle, et al. "Tegaderm CHG IV securement dressing for central venous and arterial catheter insertion sites: a NICE medical technology guidance." Applied Health Economics and Health Policy 14.2 (2016): 135-149. https://link.springer.com/content/pdf/10.1007/s40258-015-0202-5.pdf I get 0.002096431 or 0.0021, so it looks like they used the mean as their se.


# I demonstrate this in Table 1, row 22,  of: Sharp, Linda, et al. "Cost-effectiveness of population-based screening for colorectal cancer: a comparison of guaiac-based faecal occult blood testing, faecal immunochemical testing and flexible sigmoidoscopy." British journal of cancer 106.5 (2012): 805-816. https://www.nature.com/articles/bjc2011580.pdf also saved here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\Betadist utility\bjc2011580.pdf

# CTC sensitivity for CRC Basecase(85%) range(75 – 95%) Beta (Alpha = 50.00, Beta = 8.82)

# a<- 50.00
# b<- 8.82
# Var <-  a * b / ( (a + b)^2 * (a + b + 1) )
# se <- sqrt(Var)
# se
# 0.04616056

# Here's a way to get alpha and beta with just the variance and mean: https://devinincerti.com/2018/02/10/psa.html

# If I wanted to turn my own SE into the variance, I can multiply it by itself, i.e. se*se per: https://r-lang.com/how-to-calculate-square-of-all-values-in-r-vector/#:~:text=To%20calculate%20square%20in%20R,square%20of%20the%20input%20value.

# mean <- 0.85

# std.error <- se
# alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1 ## alpha + beta (ab)
# alpha.plus.beta
# alpha <- mean*alpha.plus.beta ## alpha (a)
# beta <- alpha*(1-mean)/mean ## beta(b)
# alpha
# 50.01124
# beta
# 8.825513


# myse <- ((0.95) - (0.85)) / 2
# myse
# 0.05


# Briggs code to generate the SE for a parameter with a range perfectly centered around the mean (briggsse), and then repeated but for the situations where the range isnt PERFECTLY centered around the mean (altbriggsse), i.e., the min is further away from the mean than the max, or vice versa (even a little):

max <- 1.00,
min <- 0.68,  
mean <- u_F,

# briggsse <- ((max)-(mean))/1.96,
altbriggsse <- (max-min)/(2*1.96),

## Generating the alpha and beta:

std.error <- altbriggsse, ## briggsse OR altbriggsse - as appropriate
alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1, ## alpha + beta (ab)
alpha.plus.beta,
alpha <- mean*alpha.plus.beta, ## alpha (a)
beta <- alpha*(1-mean)/mean, ## beta(b)
alpha,
beta,

u_F       = rbeta(n_runs, shape1 =  alpha, shape2 = beta),
mean(u_F),
u_F_alpha <- alpha,
u_F_beta <- beta,

# Briggs code to generate the SE for a parameter with a range perfectly centered around the mean (briggsse), and then repeated but for the situations where the range isnt PERFECTLY centered around the mean (altbriggsse), i.e., the min is further away from the mean than the max, or vice versa (even a little):

max <- 0.78,
min <- 0.52,  
mean <- u_P,

briggsse <- ((max)-(mean))/1.96,
# altbriggsse <- (max-min)/(2*1.96),

## Generating the alpha and beta:

std.error <- briggsse, ## briggsse OR altbriggsse - as appropriate
alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1, ## alpha + beta (ab)
alpha.plus.beta,
alpha <- mean*alpha.plus.beta, ## alpha (a)
beta <- alpha*(1-mean)/mean, ## beta(b)
alpha,
beta,

u_P       = rbeta(n_runs, shape1 =  alpha, shape2 = beta),
mean(u_P),
u_P_alpha <- alpha,
u_P_beta <- beta,


  u_D       = 0,
# The utility of being dead doesnt vary, it always is the same utility to be a dead person, which is 0 because we don't have any quality of life, as we are no longer alive. I could have also just set u_D       = u_D, because when you set something equal to itself in here, that also means it's constant.

mean<-   AE1_DisUtil,
Maximum <- Maximum_AE1_DisUtil,
Maximum,
se <- ((Maximum) - (mean)) / 2,
se,  
std.error <- se,
alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1, ## alpha + beta (ab)
alpha <- mean*alpha.plus.beta, ## alpha (a)
beta <- alpha*(1-mean)/mean, ## beta(b)
alpha,
beta,

AE1_DisUtil        = rbeta(n_runs, shape1 =  alpha, shape2 = beta), 

alpha_u_AE1 <- alpha,
beta_u_AE1 <- beta,


mean<-   AE2_DisUtil,
Maximum <- Maximum_AE2_DisUtil,
Maximum,
se <- ((Maximum) - (mean)) / 2,
se,  
std.error <- se,
alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1, ## alpha + beta (ab)
alpha <- mean*alpha.plus.beta, ## alpha (a)
beta <- alpha*(1-mean)/mean, ## beta(b)
alpha,
beta,

AE2_DisUtil        = rbeta(n_runs, shape1 =  alpha, shape2 = beta), 

alpha_u_AE2 <- alpha,
beta_u_AE2 <- beta,


mean<-   AE3_DisUtil,
Maximum <- Maximum_AE3_DisUtil,
Maximum,
se <- ((Maximum) - (mean)) / 2,
se,  
std.error <- se,
alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1, ## alpha + beta (ab)
alpha <- mean*alpha.plus.beta, ## alpha (a)
beta <- alpha*(1-mean)/mean, ## beta(b)
alpha,
beta,

AE3_DisUtil        = rbeta(n_runs, shape1 =  alpha, shape2 = beta), 

alpha_u_AE3 <- alpha,
beta_u_AE3 <- beta,



# Discounting:
  
# A uniform distribution is a probability distribution in which every value between an interval from a to b is equally likely to be chosen. https://www.statology.org/uniform-distribution-r/
  
# "Generates random values that are evenly spread between min and max bounds" - https://docs.oracle.com/cd/E57185_01/CYBUG/apcs03s03s01.html 

# Devin Incerti talks about the Uniform distribution here: "The uniform distribution is useful when there is little data available to estimate a parameter and determine its distribution. It is always preferable to place uncertainty on a parameter even when there is little evidence for it than to assume a fixed value (which gives a false sense of precision). Sampling from the uniform distribution is straightforward." https://devinincerti.com/2018/02/10/psa.html  
  
#Reading the literature, it seems like studies pick a lower bound and upper bound for the discount rate, such that the average (mean of the discount rate) will reach the point estimate they started with: 
  
  # A Trial-Based Assessment of the Cost-Utility of Bevacizumab and Chemotherapy versus Chemotherapy Alone for Advanced Non-Small Cell Lung Cancer https://sci-hub.ru/10.1016/j.jval.2011.04.004 
  
# file:///C:/Users/Jonathan/OneDrive%20-%20Royal%20College%20of%20Surgeons%20in%20Ireland/COLOSSUS/Evidence%20Synthesis/Paper%20Materials%20and%20Methods/Hamdy%20Elsisi%20et%20al_2019_Cost-effectiveness%20of%20sorafenib%20versus%20best%20supportive%20care%20in%20advanced.pdf  
    
# Koen's excel file does this too: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\Matching the model with the evidence Koen
  
# as informed by: https://pubs.wsb.wisc.edu/academics/analytics-using-r-2019/uniform-continuous-version.html also saved here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\3.5 Uniform (Continuous Version) _ Analytics Using R.pdf


#  d_c       = 0.04/365,
#  d_e       = 0.04/365,
# If I wanted constant values for the discount rates I would have set them as above.
# Earlier I divided 0.04 by 365, so now I divide the upper value by 365 also.

  d_c    = runif(n_runs,  min = 0, max = 0.08/365),
  d_e    = runif(n_runs,  min = 0, max = 0.08/365),

  n_cycle   = n_cycle,
  t_cycle   = t_cycle
)

# Inspect the data.frame to see what it looks like (we'll see the first 6 observations):
head(df_PA_input)
```

```
##   coef_weibull_shape_SoC coef_weibull_scale_SoC coef_TTD_weibull_shape_SoC
## 1                 0.4295                  5.606                     0.3453
## 2                 0.3354                  5.674                     0.3215
## 3                 0.2912                  5.562                     0.4090
##   coef_TTD_weibull_scale_SoC HR_FP_Exp HR_PD_Exp max....0.22 min....0.12 mean....P_OSD_SoC
## 1                      6.633    0.7228    0.6747        0.22        0.12              0.17
## 2                      6.592    0.7449    0.7415        0.22        0.12              0.17
## 3                      6.688    0.6377    0.5860        0.22        0.12              0.17
##   briggsse......max.....mean...1.96 std.error....briggsse
## 1                           0.02551               0.02551
## 2                           0.02551               0.02551
## 3                           0.02551               0.02551
##   alpha.plus.beta....mean....1...mean...std.error.2....1 alpha.plus.beta
## 1                                                  215.8           215.8
## 2                                                  215.8           215.8
## 3                                                  215.8           215.8
##   alpha....mean...alpha.plus.beta beta....alpha....1...mean..mean alpha  beta P_OSD_SoC
## 1                           36.69                           179.1 36.69 179.1    0.1590
## 2                           36.69                           179.1 36.69 179.1    0.1708
## 3                           36.69                           179.1 36.69 179.1    0.1621
##   mean.P_OSD_SoC. P_OSD_SoC_alpha....alpha P_OSD_SoC_beta....beta max....0.22.1
## 1            0.17                    36.69                  179.1          0.22
## 2            0.17                    36.69                  179.1          0.22
## 3            0.17                    36.69                  179.1          0.22
##   min....0.12.1 mean....P_OSD_Exp briggsse......max.....mean...1.96.1
## 1          0.12              0.17                             0.02551
## 2          0.12              0.17                             0.02551
## 3          0.12              0.17                             0.02551
##   std.error....briggsse.1 alpha.plus.beta....mean....1...mean...std.error.2....1.1
## 1                 0.02551                                                    215.8
## 2                 0.02551                                                    215.8
## 3                 0.02551                                                    215.8
##   alpha.plus.beta.1 alpha....mean...alpha.plus.beta.1 beta....alpha....1...mean..mean.1
## 1             215.8                             36.69                             179.1
## 2             215.8                             36.69                             179.1
## 3             215.8                             36.69                             179.1
##   alpha.1 beta.1 P_OSD_Exp mean.P_OSD_Exp. P_OSD_Exp_alpha....alpha P_OSD_Exp_beta....beta
## 1   36.69  179.1    0.1426            0.17                    36.69                  179.1
## 2   36.69  179.1    0.1942            0.17                    36.69                  179.1
## 3   36.69  179.1    0.1759            0.17                    36.69                  179.1
##   mean....p_FA1_STD Maximum....Maximum_p_FA1_STD Maximum se......Maximum.....mean...2    se
## 1              0.04                        0.048   0.048                        0.004 0.004
## 2              0.04                        0.048   0.048                        0.004 0.004
## 3              0.04                        0.048   0.048                        0.004 0.004
##   std.error....se alpha.plus.beta....mean....1...mean...std.error.2....1.2
## 1           0.004                                                     2399
## 2           0.004                                                     2399
## 3           0.004                                                     2399
##   alpha....mean...alpha.plus.beta.2 beta....alpha....1...mean..mean.2 alpha.2 beta.2
## 1                             95.96                              2303   95.96   2303
## 2                             95.96                              2303   95.96   2303
## 3                             95.96                              2303   95.96   2303
##   p_FA1_STD alpha_p_FA1_STD....alpha beta_p_FA1_STD....beta mean....p_FA2_STD
## 1   0.03730                    95.96                   2303              0.31
## 2   0.03743                    95.96                   2303              0.31
## 3   0.04603                    95.96                   2303              0.31
##   Maximum....Maximum_p_FA2_STD Maximum.1 se......Maximum.....mean...2.1  se.1
## 1                        0.372     0.372                          0.031 0.031
## 2                        0.372     0.372                          0.031 0.031
## 3                        0.372     0.372                          0.031 0.031
##   std.error....se.1 alpha.plus.beta....mean....1...mean...std.error.2....1.3
## 1             0.031                                                    221.6
## 2             0.031                                                    221.6
## 3             0.031                                                    221.6
##   alpha....mean...alpha.plus.beta.3 beta....alpha....1...mean..mean.3 alpha.3 beta.3
## 1                             68.69                             152.9   68.69  152.9
## 2                             68.69                             152.9   68.69  152.9
## 3                             68.69                             152.9   68.69  152.9
##   p_FA2_STD alpha_p_FA2_STD....alpha beta_p_FA2_STD....beta mean....p_FA3_STD
## 1    0.3273                    68.69                  152.9              0.31
## 2    0.3542                    68.69                  152.9              0.31
## 3    0.3877                    68.69                  152.9              0.31
##   Maximum....Maximum_p_FA3_STD Maximum.2 se......Maximum.....mean...2.2  se.2
## 1                        0.372     0.372                          0.031 0.031
## 2                        0.372     0.372                          0.031 0.031
## 3                        0.372     0.372                          0.031 0.031
##   std.error....se.2 alpha.plus.beta....mean....1...mean...std.error.2....1.4
## 1             0.031                                                    221.6
## 2             0.031                                                    221.6
## 3             0.031                                                    221.6
##   alpha....mean...alpha.plus.beta.4 beta....alpha....1...mean..mean.4 alpha.4 beta.4
## 1                             68.69                             152.9   68.69  152.9
## 2                             68.69                             152.9   68.69  152.9
## 3                             68.69                             152.9   68.69  152.9
##   p_FA3_STD alpha_p_FA3_STD....alpha beta_p_FA3_STD....beta mean....p_FA1_EXPR
## 1    0.2878                    68.69                  152.9               0.07
## 2    0.3633                    68.69                  152.9               0.07
## 3    0.3070                    68.69                  152.9               0.07
##   Maximum....Maximum_p_FA1_EXPR Maximum.3 se......Maximum.....mean...2.3  se.3
## 1                         0.084     0.084                          0.007 0.007
## 2                         0.084     0.084                          0.007 0.007
## 3                         0.084     0.084                          0.007 0.007
##   std.error....se.3 alpha.plus.beta....mean....1...mean...std.error.2....1.5
## 1             0.007                                                     1328
## 2             0.007                                                     1328
## 3             0.007                                                     1328
##   alpha....mean...alpha.plus.beta.5 beta....alpha....1...mean..mean.5 alpha.5 beta.5
## 1                             92.93                              1235   92.93   1235
## 2                             92.93                              1235   92.93   1235
## 3                             92.93                              1235   92.93   1235
##   p_FA1_EXPR alpha_p_FA1_EXPR....alpha beta_p_FA1_EXPR....beta mean....p_FA2_EXPR
## 1    0.07407                     92.93                    1235               0.11
## 2    0.06746                     92.93                    1235               0.11
## 3    0.07592                     92.93                    1235               0.11
##   Maximum....Maximum_p_FA2_EXPR Maximum.4 se......Maximum.....mean...2.4  se.4
## 1                         0.132     0.132                          0.011 0.011
## 2                         0.132     0.132                          0.011 0.011
## 3                         0.132     0.132                          0.011 0.011
##   std.error....se.4 alpha.plus.beta....mean....1...mean...std.error.2....1.6
## 1             0.011                                                    808.1
## 2             0.011                                                    808.1
## 3             0.011                                                    808.1
##   alpha....mean...alpha.plus.beta.6 beta....alpha....1...mean..mean.6 alpha.6 beta.6
## 1                             88.89                             719.2   88.89  719.2
## 2                             88.89                             719.2   88.89  719.2
## 3                             88.89                             719.2   88.89  719.2
##   p_FA2_EXPR alpha_p_FA2_EXPR....alpha beta_p_FA2_EXPR....beta mean....p_FA3_EXPR
## 1    0.11395                     88.89                   719.2               0.07
## 2    0.11087                     88.89                   719.2               0.07
## 3    0.09936                     88.89                   719.2               0.07
##   Maximum....Maximum_p_FA3_EXPR Maximum.5 se......Maximum.....mean...2.5  se.5
## 1                         0.084     0.084                          0.007 0.007
## 2                         0.084     0.084                          0.007 0.007
## 3                         0.084     0.084                          0.007 0.007
##   std.error....se.5 alpha.plus.beta....mean....1...mean...std.error.2....1.7
## 1             0.007                                                     1328
## 2             0.007                                                     1328
## 3             0.007                                                     1328
##   alpha....mean...alpha.plus.beta.7 beta....alpha....1...mean..mean.7 alpha.7 beta.7
## 1                             92.93                              1235   92.93   1235
## 2                             92.93                              1235   92.93   1235
## 3                             92.93                              1235   92.93   1235
##   p_FA3_EXPR alpha_p_FA3_EXPR....alpha beta_p_FA3_EXPR....beta
## 1    0.07432                     92.93                    1235
## 2    0.07070                     92.93                    1235
## 3    0.06528                     92.93                    1235
##   Maximum....Maximum_administration_cost Mean....administration_cost
## 1                                  377.9                       314.9
## 2                                  377.9                       314.9
## 3                                  377.9                       314.9
##   se......Maximum.....Mean...2  se.6 mean....Mean  mean mn.cIntervention....mean
## 1                        31.49 31.49        314.9 314.9                    314.9
## 2                        31.49 31.49        314.9 314.9                    314.9
## 3                        31.49 31.49        314.9 314.9                    314.9
##   se.cIntervention....se a.cIntervention.....mn.cIntervention.se.cIntervention..2
## 1                  31.49                                                      100
## 2                  31.49                                                      100
## 3                  31.49                                                      100
##   b.cIntervention.....se.cIntervention.2..mn.cIntervention a.cIntervention b.cIntervention
## 1                                                    3.149             100           3.149
## 2                                                    3.149             100           3.149
## 3                                                    3.149             100           3.149
##   administration_cost a.cIntervention_administration_cost....a.cIntervention
## 1               279.3                                                    100
## 2               345.7                                                    100
## 3               299.2                                                    100
##   b.cIntervention_administration_cost....b.cIntervention Maximum....Maximum_c_PFS_Folfox
## 1                                                  3.149                           342.6
## 2                                                  3.149                           342.6
## 3                                                  3.149                           342.6
##   Mean....c_PFS_Folfox se......Maximum.....Mean...2.1  se.7 mean....Mean.1 mean.1
## 1                285.5                          28.55 28.55          285.5  285.5
## 2                285.5                          28.55 28.55          285.5  285.5
## 3                285.5                          28.55 28.55          285.5  285.5
##   mn.cIntervention....mean.1 se.cIntervention....se.1
## 1                      285.5                    28.55
## 2                      285.5                    28.55
## 3                      285.5                    28.55
##   a.cIntervention.....mn.cIntervention.se.cIntervention..2.1
## 1                                                        100
## 2                                                        100
## 3                                                        100
##   b.cIntervention.....se.cIntervention.2..mn.cIntervention.1 a.cIntervention.1
## 1                                                      2.855               100
## 2                                                      2.855               100
## 3                                                      2.855               100
##   b.cIntervention.1 c_PFS_Folfox a.cIntervention_c_PFS_Folfox....a.cIntervention
## 1             2.855        320.8                                             100
## 2             2.855        313.7                                             100
## 3             2.855        253.5                                             100
##   b.cIntervention_c_PFS_Folfox....b.cIntervention Maximum....Maximum_c_PFS_Bevacizumab
## 1                                           2.855                                 1591
## 2                                           2.855                                 1591
## 3                                           2.855                                 1591
##   Mean....c_PFS_Bevacizumab se......Maximum.....Mean...2.2  se.8 mean....Mean.2 mean.2
## 1                      1326                          132.6 132.6           1326   1326
## 2                      1326                          132.6 132.6           1326   1326
## 3                      1326                          132.6 132.6           1326   1326
##   mn.cIntervention....mean.2 se.cIntervention....se.2
## 1                       1326                    132.6
## 2                       1326                    132.6
## 3                       1326                    132.6
##   a.cIntervention.....mn.cIntervention.se.cIntervention..2.2
## 1                                                        100
## 2                                                        100
## 3                                                        100
##   b.cIntervention.....se.cIntervention.2..mn.cIntervention.2 a.cIntervention.2
## 1                                                      13.26               100
## 2                                                      13.26               100
## 3                                                      13.26               100
##   b.cIntervention.2 c_PFS_Bevacizumab a.cIntervention_c_PFS_Bevacizumab....a.cIntervention
## 1             13.26              1321                                                  100
## 2             13.26              1113                                                  100
## 3             13.26              1302                                                  100
##   b.cIntervention_c_PFS_Bevacizumab....b.cIntervention Maximum....Maximum_c_OS_Folfiri
## 1                                                13.26                           167.5
## 2                                                13.26                           167.5
## 3                                                13.26                           167.5
##   Mean....c_OS_Folfiri se......Maximum.....Mean...2.3  se.9 mean....Mean.3 mean.3
## 1                139.6                          13.96 13.96          139.6  139.6
## 2                139.6                          13.96 13.96          139.6  139.6
## 3                139.6                          13.96 13.96          139.6  139.6
##   mn.cIntervention....mean.3 se.cIntervention....se.3
## 1                      139.6                    13.96
## 2                      139.6                    13.96
## 3                      139.6                    13.96
##   a.cIntervention.....mn.cIntervention.se.cIntervention..2.3
## 1                                                        100
## 2                                                        100
## 3                                                        100
##   b.cIntervention.....se.cIntervention.2..mn.cIntervention.3 a.cIntervention.3
## 1                                                      1.396               100
## 2                                                      1.396               100
## 3                                                      1.396               100
##   b.cIntervention.3 c_OS_Folfiri a.cIntervention_c_OS_Folfiri....a.cIntervention
## 1             1.396        131.4                                             100
## 2             1.396        111.7                                             100
## 3             1.396        154.8                                             100
##   b.cIntervention_c_OS_Folfiri....b.cIntervention c_D Maximum....Maximum_c_AE1
## 1                                           1.396   0                     5863
## 2                                           1.396   0                     5863
## 3                                           1.396   0                     5863
##   Mean....c_AE1 se......Maximum.....Mean...2.4 se.10 mean....Mean.4 mean.4
## 1          4886                          488.6 488.6           4886   4886
## 2          4886                          488.6 488.6           4886   4886
## 3          4886                          488.6 488.6           4886   4886
##   mn.cIntervention....mean.4 se.cIntervention....se.4
## 1                       4886                    488.6
## 2                       4886                    488.6
## 3                       4886                    488.6
##   a.cIntervention.....mn.cIntervention.se.cIntervention..2.4
## 1                                                        100
## 2                                                        100
## 3                                                        100
##   b.cIntervention.....se.cIntervention.2..mn.cIntervention.4 a.cIntervention.4
## 1                                                      48.86               100
## 2                                                      48.86               100
## 3                                                      48.86               100
##   b.cIntervention.4 c_AE1 a.cIntervention_c_AE1....a.cIntervention
## 1             48.86  4799                                      100
## 2             48.86  5590                                      100
## 3             48.86  4872                                      100
##   b.cIntervention_c_AE1....b.cIntervention Maximum....Maximum_c_AE2 Mean....c_AE2
## 1                                    48.86                    608.8         507.4
## 2                                    48.86                    608.8         507.4
## 3                                    48.86                    608.8         507.4
##   se......Maximum.....Mean...2.5 se.11 mean....Mean.5 mean.5 mn.cIntervention....mean.5
## 1                          50.74 50.74          507.4  507.4                      507.4
## 2                          50.74 50.74          507.4  507.4                      507.4
## 3                          50.74 50.74          507.4  507.4                      507.4
##   se.cIntervention....se.5 a.cIntervention.....mn.cIntervention.se.cIntervention..2.5
## 1                    50.74                                                        100
## 2                    50.74                                                        100
## 3                    50.74                                                        100
##   b.cIntervention.....se.cIntervention.2..mn.cIntervention.5 a.cIntervention.5
## 1                                                      5.074               100
## 2                                                      5.074               100
## 3                                                      5.074               100
##   b.cIntervention.5 c_AE2 a.cIntervention_c_AE2....a.cIntervention
## 1             5.074 506.2                                      100
## 2             5.074 596.6                                      100
## 3             5.074 559.7                                      100
##   b.cIntervention_c_AE2....b.cIntervention Maximum....Maximum_c_AE3 Mean....c_AE3
## 1                                    5.074                      114         95.03
## 2                                    5.074                      114         95.03
## 3                                    5.074                      114         95.03
##   se......Maximum.....Mean...2.6 se.12 mean....Mean.6 mean.6 mn.cIntervention....mean.6
## 1                          9.503 9.503          95.03  95.03                      95.03
## 2                          9.503 9.503          95.03  95.03                      95.03
## 3                          9.503 9.503          95.03  95.03                      95.03
##   se.cIntervention....se.6 a.cIntervention.....mn.cIntervention.se.cIntervention..2.6
## 1                    9.503                                                        100
## 2                    9.503                                                        100
## 3                    9.503                                                        100
##   b.cIntervention.....se.cIntervention.2..mn.cIntervention.6 a.cIntervention.6
## 1                                                     0.9503               100
## 2                                                     0.9503               100
## 3                                                     0.9503               100
##   b.cIntervention.6  c_AE3 a.cIntervention_c_AE3....a.cIntervention
## 1            0.9503  87.34                                      100
## 2            0.9503 100.36                                      100
## 3            0.9503  76.43                                      100
##   b.cIntervention_c_AE3....b.cIntervention max....1 min....0.68 mean....u_F
## 1                                   0.9503        1        0.68        0.85
## 2                                   0.9503        1        0.68        0.85
## 3                                   0.9503        1        0.68        0.85
##   altbriggsse.....max...min...2...1.96. std.error....altbriggsse
## 1                               0.08163                  0.08163
## 2                               0.08163                  0.08163
## 3                               0.08163                  0.08163
##   alpha.plus.beta....mean....1...mean...std.error.2....1.8 alpha.plus.beta.2
## 1                                                    18.13             18.13
## 2                                                    18.13             18.13
## 3                                                    18.13             18.13
##   alpha....mean...alpha.plus.beta.8 beta....alpha....1...mean..mean.8 alpha.8 beta.8    u_F
## 1                             15.41                              2.72   15.41   2.72 0.8669
## 2                             15.41                              2.72   15.41   2.72 0.9104
## 3                             15.41                              2.72   15.41   2.72 0.7911
##   mean.u_F. u_F_alpha....alpha u_F_beta....beta max....0.78 min....0.52 mean....u_P
## 1      0.85              15.41             2.72        0.78        0.52        0.65
## 2      0.85              15.41             2.72        0.78        0.52        0.65
## 3      0.85              15.41             2.72        0.78        0.52        0.65
##   briggsse......max.....mean...1.96.2 std.error....briggsse.2
## 1                             0.06633                 0.06633
## 2                             0.06633                 0.06633
## 3                             0.06633                 0.06633
##   alpha.plus.beta....mean....1...mean...std.error.2....1.9 alpha.plus.beta.3
## 1                                                    50.71             50.71
## 2                                                    50.71             50.71
## 3                                                    50.71             50.71
##   alpha....mean...alpha.plus.beta.9 beta....alpha....1...mean..mean.9 alpha.9 beta.9    u_P
## 1                             32.96                             17.75   32.96  17.75 0.6770
## 2                             32.96                             17.75   32.96  17.75 0.7057
## 3                             32.96                             17.75   32.96  17.75 0.6445
##   mean.u_P. u_P_alpha....alpha u_P_beta....beta u_D mean....AE1_DisUtil
## 1      0.65              32.96            17.75   0                0.45
## 2      0.65              32.96            17.75   0                0.45
## 3      0.65              32.96            17.75   0                0.45
##   Maximum....Maximum_AE1_DisUtil Maximum.6 se......Maximum.....mean...2.6 se.13
## 1                           0.54      0.54                          0.045 0.045
## 2                           0.54      0.54                          0.045 0.045
## 3                           0.54      0.54                          0.045 0.045
##   std.error....se.6 alpha.plus.beta....mean....1...mean...std.error.2....1.10
## 1             0.045                                                     121.2
## 2             0.045                                                     121.2
## 3             0.045                                                     121.2
##   alpha....mean...alpha.plus.beta.10 beta....alpha....1...mean..mean.10 alpha.10 beta.10
## 1                              54.55                              66.67    54.55   66.67
## 2                              54.55                              66.67    54.55   66.67
## 3                              54.55                              66.67    54.55   66.67
##   AE1_DisUtil alpha_u_AE1....alpha beta_u_AE1....beta mean....AE2_DisUtil
## 1      0.3976                54.55              66.67                0.19
## 2      0.4539                54.55              66.67                0.19
## 3      0.4483                54.55              66.67                0.19
##   Maximum....Maximum_AE2_DisUtil Maximum.7 se......Maximum.....mean...2.7 se.14
## 1                          0.228     0.228                          0.019 0.019
## 2                          0.228     0.228                          0.019 0.019
## 3                          0.228     0.228                          0.019 0.019
##   std.error....se.7 alpha.plus.beta....mean....1...mean...std.error.2....1.11
## 1             0.019                                                     425.3
## 2             0.019                                                     425.3
## 3             0.019                                                     425.3
##   alpha....mean...alpha.plus.beta.11 beta....alpha....1...mean..mean.11 alpha.11 beta.11
## 1                              80.81                              344.5    80.81   344.5
## 2                              80.81                              344.5    80.81   344.5
## 3                              80.81                              344.5    80.81   344.5
##   AE2_DisUtil alpha_u_AE2....alpha beta_u_AE2....beta mean....AE3_DisUtil
## 1      0.2194                80.81              344.5                0.36
## 2      0.2090                80.81              344.5                0.36
## 3      0.1865                80.81              344.5                0.36
##   Maximum....Maximum_AE3_DisUtil Maximum.8 se......Maximum.....mean...2.8 se.15
## 1                          0.432     0.432                          0.036 0.036
## 2                          0.432     0.432                          0.036 0.036
## 3                          0.432     0.432                          0.036 0.036
##   std.error....se.8 alpha.plus.beta....mean....1...mean...std.error.2....1.12
## 1             0.036                                                     176.8
## 2             0.036                                                     176.8
## 3             0.036                                                     176.8
##   alpha....mean...alpha.plus.beta.12 beta....alpha....1...mean..mean.12 alpha.12 beta.12
## 1                              63.64                              113.1    63.64   113.1
## 2                              63.64                              113.1    63.64   113.1
## 3                              63.64                              113.1    63.64   113.1
##   AE3_DisUtil alpha_u_AE3....alpha beta_u_AE3....beta        d_c        d_e n_cycle t_cycle
## 1      0.4002                63.64              113.1 0.00020978 0.00008106     143      14
## 2      0.3636                63.64              113.1 0.00008086 0.00012278     143      14
## 3      0.3401                63.64              113.1 0.00015620 0.00005348     143      14
##  [ reached 'max' / getOption("max.print") -- omitted 3 rows ]
```

```r
# It's a dataframe made up of the 10,000 values I asked be made at the start of this code chunk.

# If I wanted to save the dataframe, I would do this as follows:

#save(df_PA_input, file = "df_PA_input.rda")
```


```r
# 09.1 Conduct probabilistic sensitivity analysis

# Running the probabilistic analysis :

# First we need to create data.frames to store the output from the PSA:

df_c <- df_e <- data.frame(
  SoC = rep(NA, n_runs),
  Exp = rep(NA, n_runs)
)

# As you'll see, first we make blank (repeat NA for the number of runs of the simulationn_runs) data.frames for costs (df_c) and effectiveness (df_e) for SoC and the experimental treatment:

head(df_c)
```

```
##   SoC Exp
## 1  NA  NA
## 2  NA  NA
## 3  NA  NA
## 4  NA  NA
## 5  NA  NA
## 6  NA  NA
```

```r
# > head(df_c)
#   SoC Exp
# 1  NA  NA
# 2  NA  NA
# 3  NA  NA
# 4  NA  NA
# 5  NA  NA
# 6  NA  NA

head(df_e)
```

```
##   SoC Exp
## 1  NA  NA
## 2  NA  NA
## 3  NA  NA
## 4  NA  NA
## 5  NA  NA
## 6  NA  NA
```

```r
# > head(df_e)
#   SoC Exp
# 1  NA  NA
# 2  NA  NA
# 3  NA  NA
# 4  NA  NA
# 5  NA  NA
# 6  NA  NA

# We run the Markov model for each set of parameter values from the PSA input dataset (a set of parameters here is the row of parameter values in the PSA data.frame from whatever run number of the nruns in the PSA dataset we are on, i.e. if we were doing this for run number 10 out of 10,000, we would be on row 10 in the data.frame (as each row refers to a run) and we would use all the values for costs and effect that appear in this row when running the Markov model. So, we would be using all the random draws for that PSA run in the Markov model).

# - I read a note indicating that this loop can be run in parallel to decrease the runtime, something to consider in the future if it takes a very long time...

for(i_run in 1:n_runs){

    # Evaluate the model and store the outcomes
  l_out_temp    <- oncologySemiMarkov(l_params_all = df_PA_input[i_run, ], n_wtp = n_wtp)
# The above is basically saying, apply the oncologySemiMarkov_function, where l_params_all in the function (i.e. the list of parameters the function is to be applied to) is equal to the parameters from the PSA data.frame for the run we are in, and the willingness to pay threshold is n_wtp.
  df_c[i_run, ] <- l_out_temp$Cost
  df_e[i_run, ] <- l_out_temp$Effect
# The above says, for the costs and effectiveness data.frames, store the value of costs and effects for each run that we are on in a row that reflects that run (remembering that [ROW,COLUMN], we are putting each cost and effect in a row that relates to the number of the run we are on, so if we are on run 1, i_run = 1 and we store the costs and effects for that run 1 in row 1. Remembering that our oncologySemiMarkov makes the "Cost" and "Effect" parameters at the end of the function, after applying the Markov cost-effectiveness model to all our input data for the cost-effectiveness model (so, things like, cost, utility and probability), so we are just pulling the ouputted Cost and Effect values calculated from a Markov cost-effectiveness model applied to our input data after the input data has been randomly drawn from a PSA (per the PSA input dataframe)).  

  
  # While we're doing this, we might like to display the progress of the simulation:
  if(i_run/(n_runs/10) == round(i_run/(n_runs/10), 0)) { # We've chosen to display progress every 10%
    cat('\r', paste(i_run/n_runs * 100, "% done", sep = " "))
  }
}
```

```
## 
 10 % done
 20 % done
 30 % done
 40 % done
 50 % done
 60 % done
 70 % done
 80 % done
 90 % done
 100 % done
```


```r
#09.2 Create PSA object for dampack

# Dampack has a number of functions to summarise and visualise the results of a probabilistic sensitivity analysis. However, the data needs to be in a specific structure before we can use those functions. 

# The 'dampack' package contains multiple useful functions that summarize and visualize the results of a
# probabilitic analysis. To use those functions, the data has to be in a particular structure.
l_PA <- make_psa_obj(cost          = df_c, 
                     effectiveness = df_e, 
                     parameters    = df_PA_input, 
                     strategies    = c("SoC", "Exp"))

# So, basically we make a psa object for Dampack where df_c is the dataframe of costs from the Markov model being applied to the PSA data, and df_e is the data.frame of effectiveness from the Markov model being applied to the PSA dataset, the parameters that are included are those from the PSA analysis, which we fed into df_PA_input above (df_PA_input<-) and the two strategies are SoC and Exp.
```


```r
#09.2.1 Save PSA objects

# If we wanted to save the PSA objects once they have been created above, we could do this as follows (v_names_strats is just another way of including the strategies part from above):
# save(df_PA_input, df_c, df_e, v_names_strats, n_str, l_PA,
#     file = "markov_3state_PSA_dataset.RData")
```


```r
#09.3.1 Conduct CEA with probabilistic output

# First we take the mean outcome estimates, that is, we summarise the expected costs and effects for each strategy from the PSA:
(df_out_ce_PA <- summary(l_PA))
```

```
##   Strategy meanCost meanEffect
## 1      SoC    17638     0.3372
## 2      Exp    50615     0.6493
```

```r
# Calculate incremental cost-effectiveness ratios (ICERs)

# Then we calculate the ICERs from this df_out_ce_PA (summary must be a dampack function doing things under the hood to create a selectable ($) meanCost, meanEffect and Strategy parameter in df_out_ce_PA):
(df_cea_PA <- calculate_icers(cost       = df_out_ce_PA$meanCost, 
                              effect     = df_out_ce_PA$meanEffect,
                              strategies = df_out_ce_PA$Strategy))
```

```
##   Strategy  Cost Effect Inc_Cost Inc_Effect   ICER Status
## 1      SoC 17638 0.3372       NA         NA     NA     ND
## 2      Exp 50615 0.6493    32977     0.3121 105663     ND
```

```r
# We can view the ICER results from the PSA here:
df_cea_PA
```

```
##   Strategy  Cost Effect Inc_Cost Inc_Effect   ICER Status
## 1      SoC 17638 0.3372       NA         NA     NA     ND
## 2      Exp 50615 0.6493    32977     0.3121 105663     ND
```

```r
# If we wanted to save the CEA (or leauge) table with ICERs, we would do this as follows:
# As .RData
# save(df_cea_pa, 
#     file = "markov_3state_probabilistic_CEA_results.RData")
# As .csv
# write.csv(df_cea_pa, 
#          file = "markov_3state_probabilistic_CEA_results.csv")


## CEA table in proper format ---- per: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\R-HTA in LMICs Intermediate R-HTA Modelling Tutorial\September-Workshop-main\September-Workshop-main\analysis\cSTM_time_dep_simulation.r
table_cea_PA <- format_table_cea(df_cea_PA) # Function included in "R/Functions.R"; depends on the `scales` package
table_cea_PA
```

```
##   Strategy Costs ($) QALYs Incremental Costs ($) Incremental QALYs ICER ($/QALY) Status
## 1      SoC    17,638  0.34                  <NA>                NA          <NA>     ND
## 2      Exp    50,615  0.65                32,977              0.31       105,663     ND
```


```r
#09.3.2 Cost-Effectiveness Scatter plot

# Incremental cost-effectiveness plane
plot(l_PA)
```

<img src="Markov_3state_files/figure-html/unnamed-chunk-43-1.png" width="672" />

```r
ggsave(paste("CE_Scatter_Plot_", country_name[1], ".png", sep = ""), width = 8, height = 4, dpi=300)
while (!is.null(dev.list()))  dev.off()

#png(paste("CE_Scatter_Plot_", country_name[1], ".png", sep = ""))
#dev.off()

#plot(l_PA, xlim = c(9.5, 22.5))
# In the DARTH package R code they use the additional bits above, I can see how they look in my own model, and if I'd like to use them.
```


```r
#09.4.2 Cost-effectiveness acceptability curves (CEACs) and frontier (CEAF)

# Cost-effectiveness acceptability curve (CEAC):

# We first generate a vector of willingness to pay values (thresholds) to define for which values the CEAC is made:
v_wtp <- seq(0, 500000, by = 10000)
# This basically gives you a sequence of willingness to pay thresholds from 0 all the way up to 500,000 euro, increasing by 10,000 euro each time, so start with 0 euro, go to 10,000 euro, go to 20,000 euro, and so on until you hit 500,000. You can chose any max value you like and any increment value you like, for example, in the DARTH material they use the following: v_wtp <- seq(0, 45000, by = 1000)
CEAC_obj <- ceac(wtp = v_wtp, psa = l_PA)


# The below provides details on the regions of highest probability of cost-effectiveness for each strategy
summary(CEAC_obj)
```

```
##   range_min range_max cost_eff_strat
## 1         0    110000            SoC
## 2    110000    500000            Exp
```

```r
# CEAC and cost-effectiveness acceptability frontier (CEAF) plot
plot(CEAC_obj)
```

<img src="Markov_3state_files/figure-html/unnamed-chunk-44-1.png" width="672" />

```r
ggsave(paste("CEAC_", country_name[1], ".png", sep = ""), width = 8, height = 4, dpi=300)
while (!is.null(dev.list()))  dev.off()
#png(paste("CEAC_", country_name[1], ".png", sep = ""))
#dev.off()
```


```r
#09.4.3 Plot cost-effectiveness frontier
# plot(df_cea_PA)
# I don't use this plot in my paper anymore
```


```r
#09.4.4 Expected Loss Curves (ELCs)
#The expected loss is the the quantification of the foregone benefits when choosing a suboptimal strategy given current evidence.
elc_obj <- calc_exp_loss(wtp = v_wtp, psa = l_PA)
elc_obj
```

```
##        WTP Strategy Expected_Loss On_Frontier
## 1        0      SoC       0.00000        TRUE
## 2        0      Exp   32977.31736       FALSE
## 3    10000      SoC       0.00000        TRUE
## 4    10000      Exp   29856.33129       FALSE
## 5    20000      SoC       0.00000        TRUE
## 6    20000      Exp   26735.34522       FALSE
## 7    30000      SoC       0.00000        TRUE
## 8    30000      Exp   23614.35915       FALSE
## 9    40000      SoC       0.00000        TRUE
## 10   40000      Exp   20493.37308       FALSE
## 11   50000      SoC       0.00000        TRUE
## 12   50000      Exp   17372.38701       FALSE
## 13   60000      SoC       0.00000        TRUE
## 14   60000      Exp   14251.40094       FALSE
## 15   70000      SoC       4.61129        TRUE
## 16   70000      Exp   11135.02617       FALSE
## 17   80000      SoC      71.73958        TRUE
## 18   80000      Exp    8081.16838       FALSE
## 19   90000      SoC     426.20889        TRUE
## 20   90000      Exp    5314.65162       FALSE
## 21  100000      SoC    1377.68238        TRUE
## 22  100000      Exp    3145.13904       FALSE
## 23  110000      SoC    3063.55128       FALSE
## 24  110000      Exp    1710.02187        TRUE
## 25  120000      SoC    5360.09388       FALSE
## 26  120000      Exp     885.57840        TRUE
## 27  130000      SoC    8050.45317       FALSE
## 28  130000      Exp     454.95162        TRUE
## 29  140000      SoC   10951.03413       FALSE
## 30  140000      Exp     234.54650        TRUE
## 31  150000      SoC   13963.91227       FALSE
## 32  150000      Exp     126.43857        TRUE
## 33  160000      SoC   17028.23603       FALSE
## 34  160000      Exp      69.77627        TRUE
## 35  170000      SoC   20117.83766       FALSE
## 36  170000      Exp      38.39183        TRUE
## 37  180000      SoC   23221.76423       FALSE
## 38  180000      Exp      21.33232        TRUE
## 39  190000      SoC   26333.21074       FALSE
## 40  190000      Exp      11.79277        TRUE
## 41  200000      SoC   29448.61980       FALSE
## 42  200000      Exp       6.21575        TRUE
## 43  210000      SoC   32566.97901       FALSE
## 44  210000      Exp       3.58889        TRUE
## 45  220000      SoC   35686.38451       FALSE
## 46  220000      Exp       2.00832        TRUE
## 47  230000      SoC   38806.60508       FALSE
## 48  230000      Exp       1.24282        TRUE
## 49  240000      SoC   41927.11444       FALSE
## 50  240000      Exp       0.76611        TRUE
## 51  250000      SoC   45047.73006       FALSE
## 52  250000      Exp       0.39566        TRUE
## 53  260000      SoC   48168.43699       FALSE
## 54  260000      Exp       0.11652        TRUE
## 55  270000      SoC   51289.31667       FALSE
## 56  270000      Exp       0.01012        TRUE
## 57  280000      SoC   54410.29261       FALSE
## 58  280000      Exp       0.00000        TRUE
## 59  290000      SoC   57531.27868       FALSE
## 60  290000      Exp       0.00000        TRUE
## 61  300000      SoC   60652.26475       FALSE
## 62  300000      Exp       0.00000        TRUE
## 63  310000      SoC   63773.25082       FALSE
## 64  310000      Exp       0.00000        TRUE
## 65  320000      SoC   66894.23690       FALSE
## 66  320000      Exp       0.00000        TRUE
## 67  330000      SoC   70015.22297       FALSE
## 68  330000      Exp       0.00000        TRUE
## 69  340000      SoC   73136.20904       FALSE
## 70  340000      Exp       0.00000        TRUE
## 71  350000      SoC   76257.19511       FALSE
## 72  350000      Exp       0.00000        TRUE
## 73  360000      SoC   79378.18118       FALSE
## 74  360000      Exp       0.00000        TRUE
## 75  370000      SoC   82499.16725       FALSE
## 76  370000      Exp       0.00000        TRUE
## 77  380000      SoC   85620.15332       FALSE
## 78  380000      Exp       0.00000        TRUE
## 79  390000      SoC   88741.13939       FALSE
## 80  390000      Exp       0.00000        TRUE
## 81  400000      SoC   91862.12546       FALSE
## 82  400000      Exp       0.00000        TRUE
## 83  410000      SoC   94983.11153       FALSE
## 84  410000      Exp       0.00000        TRUE
## 85  420000      SoC   98104.09760       FALSE
## 86  420000      Exp       0.00000        TRUE
## 87  430000      SoC  101225.08367       FALSE
## 88  430000      Exp       0.00000        TRUE
## 89  440000      SoC  104346.06974       FALSE
## 90  440000      Exp       0.00000        TRUE
## 91  450000      SoC  107467.05581       FALSE
## 92  450000      Exp       0.00000        TRUE
## 93  460000      SoC  110588.04188       FALSE
## 94  460000      Exp       0.00000        TRUE
## 95  470000      SoC  113709.02796       FALSE
## 96  470000      Exp       0.00000        TRUE
## 97  480000      SoC  116830.01403       FALSE
## 98  480000      Exp       0.00000        TRUE
## 99  490000      SoC  119951.00010       FALSE
## 100 490000      Exp       0.00000        TRUE
## 101 500000      SoC  123071.98617       FALSE
## 102 500000      Exp       0.00000        TRUE
```

```r
# ELC plot
#plot(elc_obj, log_y = FALSE)
# I don't use this plot anymore
```


```r
#09.4.4 Expected value of perfect information (EVPI)
# Expected value of perfect information (EVPI)

#A value-of-information analysis estimates the expected value of perfect information (EVPI), that is,

#Value of information is discussed in the York course and below:

#C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\CDC_Exclusive_Decision Modeling for Public Health_DARTH

#https://cran.r-project.org/web/packages/dampack/vignettes/voi.html

#There's also a paper on this here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\Betadist utility\EVSI.doc

EVPI_obj <- calc_evpi(wtp = v_wtp, psa = l_PA)
# EVPI plot
#plot(EVPI_obj, effect_units = "QALY")
# I don't plot this anymore.
```


```r
# For building the Table in the paper, and for referring to parameter values in the paper, I save the parameters I created in an RDA file named after the country I am studying:

#save to rda file
#save(c_PFS_Folfox, c_PFS_Bevacizumab, c_OS_Folfiri, administration_cost, c_AE1, c_AE2, c_AE3, Minimum_c_PFS_Folfox, Maximum_c_PFS_Folfox, Minimum_c_OS_Folfiri, Maximum_c_OS_Folfiri, Minimum_c_PFS_Bevacizumab, Maximum_c_PFS_Bevacizumab, Minimum_administration_cost, Maximum_administration_cost, Minimum_c_AE1, Maximum_c_AE1, Minimum_c_AE2, Maximum_c_AE2, Minimum_c_AE3, Maximum_c_AE3, n_wtp, Incremental_Cost, Incremental_Effect, ICER, tc_d_Exp, tc_d_SoC, country_name, file=paste("my_data_", country_name[1], ".rda", sep = ""))

# This creates an RDA file with all the parameters I created in this file in it.

# Next, in my Markdown file that calls this file, I will read in these parameters and name each of them after the country I am studying, to give me country specific values in my analysis.
```

## 08.3.3 Table Describing Parameters

To build a Table describing parameters, you click on the Table button at the top, and design it in there.
Then to include the parameter values automatically as they are updated you fill in the parameter name you want, highlight it in the cell and click \</\> from above to put it in a code block.
You do the same for gamma, etc., put this in code blocks also.
<https://rpruim.github.io/s341/S19/from-class/MathinRmd.html#:~:text=Math%20inside%20RMarkdown,10n%3D1n2.>

Per: [Putting the value of a variable into a table in R Markdown, rather than it's name - Stack Overflow](https://stackoverflow.com/questions/72902548/putting-the-value-of-a-variable-into-a-table-in-r-markdown-rather-than-its-nam)

Line 320 of this: <https://github.com/DARTH-git/cohort-modeling-tutorial-intro/blob/main/manuscript/cSTM_Tutorial_Intro.Rmd> is informative when viewing the final document on page 7 here: <https://arxiv.org/pdf/2001.07824.pdf>

Some helpful tips on using math notation in R Markdown.

<https://rpruim.github.io/s341/S19/from-class/MathinRmd.html>

This paper says in technical terms which distributions fit and why:

Model Parameter Estimation and Uncertainty Analysis: A Report of the ISPOR-SMDM Modeling Good Research Practices Task Force Working Group--6 <file:///C:/Users/Jonathan/OneDrive%20-%20Royal%20College%20of%20Surgeons%20in%20Ireland/COLOSSUS/Briggs%20et%20al%202012%20model%20parameter%20estimation%20and%20uncertainty.pdf>

| Parameter                                            | Base Case Value       | Minimum Value                 | Maximum Value                 | Source        | Distribution                                                                        |
|-----------|-----------|-----------|-----------|-----------|------------------|
| **Cost (Per Cycle)**                                 |                       |                               |                               |               |                                                                                     |
| FOLFOX                                               | `c_PFS_Folfox`        | `Minimum_c_PFS_Folfox`        | `Maximum_c_PFS_Folfox`        |               | GAMMA(`a.cIntervention_c_PFS_Folfox`, `b.cIntervention_c_PFS_Folfox`)               |
| FOLFIRI                                              | `c_OS_Folfiri`        | `Minimum_c_OS_Folfiri`        | `Maximum_c_OS_Folfiri`        |               | GAMMA(`a.cIntervention_c_OS_Folfiri`, `b.cIntervention_c_OS_Folfiri`)               |
| Bevacizumab                                          | `c_PFS_Bevacizumab`   | `Minimum_c_PFS_Bevacizumab`   | `Maximum_c_PFS_Bevacizumab`   |               | GAMMA( `a.cIntervention_c_PFS_Bevacizumab`, `b.cIntervention_c_PFS_Bevacizumab` )   |
| Administration Cost                                  | `administration_cost` | `Minimum_administration_cost` | `Maximum_administration_cost` |               | GAMMA(`a.cIntervention_administration_cost`, `b.cIntervention_administration_cost`) |
| **Adverse Event Cost**                               |                       |                               |                               |               |                                                                                     |
| Leukopenia                                           | `c_AE1`               | `Minimum_c_AE1`               | `Maximum_c_AE1`               |               | `GAMMA(a.cIntervention_c_AE1, b.cIntervention_c_AE1)`                               |
| Diarrhea                                             | `c_AE2`               | `Minimum_c_AE2`               | `Maximum_c_AE2`               |               | `GAMMA(a.cIntervention_c_AE2, b.cIntervention_c_AE2)`                               |
| Vomiting                                             | `c_AE3`               | `Minimum_c_AE3`               | `Maximum_c_AE3`               |               | `GAMMA(a.cIntervention_c_AE3, b.cIntervention_c_AE3)`                               |
|                                                      |                       |                               |                               |               |                                                                                     |
| **Adverse Event Incidence - With Bevacizumab**       |                       |                               |                               |               |                                                                                     |
| Leukopenia                                           | `p_FA1_Exp`           | `Minimum_p_FA1_EXPR`          | `Maximum_p_FA1_EXPR`          |               | BETA(`alpha_p_FA1_EXPR`, `beta_p_FA1_EXPR`)                                         |
| Diarrhea                                             | `p_FA2_Exp`           | `Minimum_p_FA2_EXPR`          | `Maximum_p_FA2_EXPR`          |               | BETA(`alpha_p_FA2_EXPR`, `beta_p_FA2_EXPR`)                                         |
| Vomiting                                             | `p_FA3_Exp`           | `Minimum_p_FA3_EXPR`          | `Maximum_p_FA3_EXPR`          |               | BETA(`alpha_p_FA3_EXPR`, `beta_p_FA3_EXPR`)                                         |
| **Adverse Event Incidence - Without Bevacizumab**    |                       |                               |                               |               |                                                                                     |
| Leukopenia                                           | `p_FA1_STD`           | `Minimum_p_FA1_STD`           | `Maximum_p_FA1_STD`           |               | BETA(`alpha_p_FA1_STD` , `beta_p_FA1_STD`)                                          |
| Diarrhea                                             | `p_FA2_STD`           | `Minimum_p_FA2_STD`           | `Maximum_p_FA2_STD`           |               | BETA(`alpha_p_FA2_STD` , `beta_p_FA2_STD`)                                          |
| Vomiting                                             | `p_FA3_STD`           | `Minimum_p_FA3_STD`           | `Maximum_p_FA3_STD`           |               | BETA(`alpha_p_FA3_STD` , `beta_p_FA3_STD`)                                          |
| **Utility (Per Cycle)**                              |                       |                               |                               |               |                                                                                     |
| Progression Free Survival                            | `u_F`                 | `Minimum_u_F`                 | `Maximum_u_F`                 |               | BETA(`u_F_alpha`, `u_F_beta`)                                                       |
| Overall Survival                                     | `u_P`                 | `Minimum_u_P`                 | `Maximum_u_P`                 |               | BETA(`u_P_alpha` , `u_P_beta`)                                                      |
| **Adverse Event Disutility**                         |                       |                               |                               |               |                                                                                     |
| Leukopenia                                           | `AE1_DisUtil`         | `Minimum_AE1_DisUtil`         | `Maximum_AE1_DisUtil`         | BRTYA         | `alpha_u_AE1, beta_u_AE1`                                                           |
| Diarrhea                                             | `AE2_DisUtil`         | `Minimum_AE2_DisUtil`         | `Maximum_AE2_DisUtil`         | BETA          | `alpha_u_AE2, beta_u_AE2`                                                           |
| Vomiting                                             | `AE3_DisUtil`         | `Minimum_AE3_DisUtil`         | `Maximum_AE3_DisUtil`         | BETA          | `alpha_u_AE3, beta_u_AE3`                                                           |
| **Hazard Ratios**                                    |                       |                               |                               |               |                                                                                     |
| PFS to OS under the Experimental Strategy            | `HR_FP_Exp`           | `Minimum_HR_FP_Exp`           | `Maximum_HR_FP_Exp`           | [@smeets2018] | rlnorm()                                                                            |
| OS to PFS under the Experimental Strategy            | `HR_PD_Exp`           | `Minimum_HR_PD_Exp`           | `Maximum_HR_PD_Exp`           | [@smeets2018] | rlnorm()                                                                            |
| **Probability of Dying under Second-Line Treatment** | `P_OSD_SoC`           | `Minimum_P_OSD_SoC`           | `Maximum_P_OSD_SoC`           |               | BETA(`P_OSD_SoC_alpha`, `P_OSD_SoC_beta`)                                           |
| **Discount Rate**                                    |                       |                               |                               |               |                                                                                     |
| Costs                                                | `d_c`                 | 0                             | 0.08                          |               |                                                                                     |
| Outcomes                                             | `d_e`                 | 0                             | 0.08                          |               |                                                                                     |

: Table X Model Parameters Values: Baseline, Ranges and Distributions for Sensitivity Analysis

## 
=======
---
title: 'Bevacizumab for Metastatic Colorectal Cancer with Chromosomal Instability:
  An Cost-Effectiveness Analysis of a Novel Subtype across the COLOSSUS Partner Countries'
author: "Jonathan Briody (1) | Kathleen Bennett (1) | Lesley Tilson (2)"
output:
  html_document: 
    keep_md: yes
  pdf_document: default
  word_document: default
editor_options:
  markdown:
    wrap: sentence
bibliography: references.bib
---

(1) Data Science Centre, RCSI University of Medicine and Health Sciences, Dublin, Ireland
(2) National Centre for Pharmacoeconomics, St James Hospital, Dublin 8, Ireland

**Co-authors:**

*Annette feels Rodrigo should be on this paper as he suggested considering the Angiopredict study. Annette said that as Matias Ebert, a gastroenterologist in Germany, is on both COLOSSUS and Angiopredict, he should be on the paper. This collaboration may also help us to get some of the cost data that we've been waiting on from Germany (in the end it didnt).*

*Annette feels that all the PIs on Angiopredict should be co-authors on this paper Matthias Ebert as mentioned above, Jochen Prehn and Bauke Ylstra. I would probably like to add Qiushi Chen, dependent on how helpful his thoughts on parametric survival analysis actually turn out to be.*

Authors (final list TBD): Jonathan Briody,  Ian Miller, Rodrigo Dienstmann, Lesley Tilson, Matthias Ebert, Jochen Prehn, Bauke Ylstra, Annette Byrne,  Kathleen Bennett. 
\

[*Possible Journal Homes:*]{.underline}

The Oncologist (<https://academic.oup.com/oncolo/pages/general-instructions>): Published a study on this in 2017:

Goldstein, D. A., Chen, Q., Ayer, T., Chan, K. K., Virik, K., Hammerman, A., \...
& Hall, P. S.
(2017).
Bevacizumab for Metastatic Colorectal Cancer: A Global Cost‐Effectiveness Analysis.
*The Oncologist*, *22*(6), 694-699.

Journal of Medical Economics <https://www.tandfonline.com/doi/pdf/10.1080/13696998.2021.1888743>

Clinical Colorectal Cancer <https://www-sciencedirect-com.proxy.library.rcsi.ie/science/article/pii/S1533002814000978>

Value in Health: FOCUSED ON CEA, ETC.,

Studies in Health Technology and Informatics

"New Journal: Oxford Open Economics" I have an email on this in my gmail, it's a new Journal and thus may be interested in this work.

We can increase our publication numbers by publishing a short summary of our study in: PharmacoEconomics & Outcomes News - per the description "Stay up to date with the exciting world of health economics. Solve the problem of reading and monitoring the vast volumes of literature necessary to stay informed on the latest issues in pharmacoeconomics and outcomes research by reading our concise news summaries, compiled in an easy-to-read format." <https://www.springer.com/journal/40274>

<https://www.clinical-colorectal-cancer.com/>

**Correspondence:**

Jonathan Briody, PhD, RCSI University of Medicine and Health Sciences, Beaux Lane House, Lower Mercer St, Dublin 2, Ireland.
Email: [jonathanbriody\@rcsi.ie](mailto:jonathanbriody@rcsi.ie){.email}

**Funding Information:**

This project has received funding from the European Union's Horizon 2020 research and innovation programme under grant agreement No 754923.
The material presented and views expressed here are the responsibility of the author(s) only.
The EU Commission takes no responsibility for any use made of the information set out.

\newpage

# Introduction

# Materials and Methods

#### Model Structure

#### Patients and Treatment Regimens

#### Transition Probabilities

# Parametric Survival Analysis:

# 




```r
#rm(list = ls())  
# clear memory (removes all the variables from the work space) - I turn this off on the understanding that the markdown doc that calls this file will clear memory.
#options(scipen=999) 
# turns scientific notation off
# options(scipen=0) turns it back on, per: https://stackoverflow.com/questions/5352099/how-can-i-disable-scientific-notation
```


```r
#01 Load all packages

# Joshua's Package Manager:

# Package names

packages <- c("pacman", "flexsurv", "MASS", "dplyr", "devtools", "scales", "ellipse", "ggplot2", "lazyeval", "igraph", "ggraph", "reshape2", "knitr", "stringr", "diagram", "survival", "lubridate", "ggsurvfit", "gtsummary", "tidycmprsk", "magrittr", "dplyr", "diffr", "gdata", "gridGraphics", "sjPlot", "stargazer", "tibble", "here", "collapse")

# Install packages not yet installed

installed_packages <- packages %in% rownames(installed.packages())

if (any(installed_packages == FALSE)) {

  install.packages(packages[!installed_packages])

}

# Packages loading

invisible(lapply(packages, library, character.only = TRUE))

p_load_gh("DARTH-git/dampack", "DARTH-git/darthtools")
```


```r
# Previous code to check whether the required packages are installed and, if not, install the missing packages
# # - the 'pacman' package is used to conveniently install other packages
# if (!require("pacman")) install.packages("pacman"); library(pacman)
# p_load("flexsurv", "MASS", "dplyr", "devtools", "scales", "ellipse", "ggplot2", "lazyeval", "igraph", "ggraph", "reshape2", "knitr", "stringr", "diagram")   
# p_load_gh("DARTH-git/dampack", "DARTH-git/darthtools")


# {r} # if (!require('pacman')) install.packages('pacman'); library(pacman)  # # use this package to conveniently install other packages # # load (install if required) packages from CRAN # p_load("diagram", "dampack", "reshape2") # # library(devtools) # devtools is necessary to install from github. # # install_github("DARTH-git/darthtools", force = TRUE) # Uncomment if there is a newer version # p_load_gh("DARTH-git/darthtools")
```


```r
#01.5 Load functions

# all functions are in the darthtools package

# There is a functions RMD for the PSA stuff below, instead of loading it lower down, I could just place it here, and place all the necessary packages above and then I would only ever need 1 R Markdown document for the entire study. Will think about doing this.
```


```r
# Country-specific cost data:


# Basically, what I have is 1 Rmarkdown document with appropriate CEA code, but 3 countries I want to separately apply this code to, because costs (and willingness to pay thresholds) are different in each of these 3 countries.

# To do this, I feed in the cost data from each country for parameters that differ across countries, just uncomment the country you want to run this code for:


# # Ireland:
# 
# country_name <- "Ireland"
# 
# 
# # 1. Cost of treatment in this country
# c_PFS_Folfox <- 307.81 
# c_PFS_Bevacizumab <- 2580.38  
# c_OS_Folfiri <- 326.02  
# administration_cost <- 365.00 
# 
# # 2. Cost of treating the AE conditional on it occurring
# c_AE1 <- 2835.89
# c_AE2 <- 1458.80
# c_AE3 <- 409.03 
# 
# # 3. Willingness to pay threshold
# n_wtp = 45000




# Germany:

# country_name <- "Germany"

# 1. Cost of treatment in this country
# c_PFS_Folfox <- 1276.66
# c_PFS_Bevacizumab <- 1325.87
# c_OS_Folfiri <- 1309.64
# administration_cost <- 1794.40

# 2. Cost of treating the AE conditional on it occurring
# c_AE1 <- 3837
# c_AE2 <- 1816.37
# c_AE3 <- 526.70

# 3. Willingness to pay threshold
# n_wtp = 78871



# Spain:

#country_name <- "Spain"


# 1. Cost of treatment in this country
#c_PFS_Folfox <- 285.54
#c_PFS_Bevacizumab <- 1325.87
#c_OS_Folfiri <- 139.58
#administration_cost <- 314.94

# 2. Cost of treating the AE conditional on it occurring
#c_AE1 <- 4885.95
#c_AE2 <- 507.36
#c_AE3 <- 95.03

# 3. Willingness to pay threshold
#n_wtp = 30000
```


```r
#02 Individual Data for Parametric Code

# Load the individual patient data for the time-to-progression (TTP) that you recovered by digitising published survival curves (actually, Ian Miller gave us the Angiopredict data directly).

# df_TTP <- read.csv(file='PFS.csv', header=TRUE)
# save.image("C:/Users/Jonathan/OneDrive - Royal College of Surgeons in Ireland/COLOSSUS/R Code/GitHub/COLOSSUS_Model/df_TTP.RData")
# df_TTD <- read.csv(file='OS.csv', header=TRUE)
# save.image("C:/Users/Jonathan/OneDrive - Royal College of Surgeons in Ireland/COLOSSUS/R Code/GitHub/COLOSSUS_Model/df_TTD.RData")

load(file = "df_TTP.RData")
# Load the individual patient data for the time-to-progression (TTP) that you recovered by digitising published survival curves (actually, Ian Miller gave us the Angiopredict data directly).
load(file = "df_TTD.RData")
# I have time-to-death (TTD) data, I'll load it in here.

# Here's how to remove the BVZ rows from the excel files we have: https://techcommunity.microsoft.com/t5/excel/deleting-rows-that-contain-specific-content/m-p/2084473

# The data needs to be set up to include a column for the time (in the example this is time in years) and a status indicator whether the time corresponds to an event, i.e. progression (status = 1), or to the last time of follow up, i.e. censoring (status = 0),

# "What is Censoring? Censoring in a study is when there is incomplete information about a study participant, observation or value of a measurement. In clinical trials, it's when the event doesn't happen while the subject is being monitored or because they drop out of the trial." - https://www.statisticshowto.com/censoring/#:~:text=What%20is%20Censoring%3F,drop%20out%20of%20the%20trial.

# https://en.wikipedia.org/wiki/Survival_analysis#:~:text=or%20q%20%3D%200.99.-,Censoring,is%20common%20in%20survival%20analysis.

# At the bottom of the parametric survival code I think about how time from individual patient data may be changed to match the time of our cycles.

# I think the digitiser will give me the time in the context of the survival curves I am digitising, i.e., time in weeks, or time in months or time in years.

# Then I will have to set-up my time accordingly in the R code so that my cycle length is at the same level as the individual patient data.

# That is, in Koen's example:

# C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\R Code\Parametric Survival Analysis\ISPOR WEBINAR Health Economic Modelling in R\ISPOR_webinar_R-master

# the data includes a column for the time (in years)
# t_cycle <- 1/4      # cycle length of 3 months (in years)                                # n_cycle <- 60       # number of cycles (total runtime 15 years)
  

# So I would have my colum for time, in the [TIME] the graph I was digitising used.
# Then I would create my cycle length of X weeks (in [TIME] the graph I was digitising used)
# Then I would have my number of cycles that would add up to give me a total runtime of how long I want to run the model for.
# So, above Koen wanted to run the model for 15 years, but his cycles were in 3 months, or each cycle was a quarter of a year, so 60 quarters, or 60 3 month cycles, is 15 years.
```

# 


```r
#03 Parametric Survival Analysis Model Plan

# We will implement a Markov model with time-dependent transition probabilities, via a parametric survival model fitted to some individual patient data for the time-to-progression (TTP) and time-to-death (TTD) for standard of care.

# A hazard ratio for the new intervention therapy vs. the standard of care will then be applied to obtain transition probabilities for the new experimental strategy.

# Let's first review the survival curves and see if they match the study:

# My understanding of survival curves is supported by: https://www.emilyzabor.com/tutorials/survival_analysis_in_r_tutorial.html

# A really good intro to survival curves is here: https://shariq-mohammed.github.io/files/cbsa2019/1-intro-to-survival.html

# Some early and simple survival curves:

# km_fit_PFS <- survfit(Surv(time, status) ~ 1, data=df_TTP)
# plot(km_fit_PFS)
# 
# km_fit_OS <- survfit(Surv(time, status) ~ 1, data=df_TTD)
# plot(km_fit_OS)

# Before I used Joshua's awesome package management code above, I installed packages as below:

#install.packages(c("survival", "lubridate", "ggsurvfit", "gtsummary", "tidycmprsk"))
#remotes::install_github("zabore/condsurv")
#remotes::install_github("zabore/ezfun")
# library(survival)
# library(lubridate)
# library(ggsurvfit)
# library(gtsummary)
# library(tidycmprsk)
# #library(condsurv)
# #install.packages("magrittr") # package installations are only needed the first time you use it
# #install.packages("dplyr")    # alternative installation of the %>%
# library(magrittr) # needs to be run every time you start R and want to use %>%
# library(dplyr)    # alternatively, this also loads %>%


# We want to make sure the data we're feeding in matches the data from the publication in Table 4d and Supplementary Table 10d
#png(paste("Baseline_PFS_Curves", ".png"))
survfit2(Surv(time, status) ~ 1, data = df_TTP) %>% ggsurvfit() +
  labs(
    x = "Days",
    y = "Progression Free survival probability"
  ) + 
  add_risktable()
```

<img src="Markov_3state_files/figure-html/unnamed-chunk-9-1.png" width="672" />

```r
#print(plot)
ggsave("Baseline_PFS_Curves.png", width = 8, height = 4, dpi=300)
#dev.off()
while (!is.null(dev.list()))  dev.off()

# I was getting the following error: "Error in dev.off() : cannot shut down device 1 (the null device)" which I addressed by adding this following each ggsave: while (!is.null(dev.list()))  dev.off() per the following link: https://stackoverflow.com/questions/44336215/error-in-dev-off-cannot-shut-down-device-1-the-null-device






km_fit_PFS <- survfit(Surv(time, status) ~ 1, data=df_TTP)
summary(km_fit_PFS, times = c(0,150,300,450, 600, 750, 900, 1050, 1200, 1350)) # This will stop just before the last patient is censored in the data, also, n.event means number of events that happened at this time.
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTP)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##     0    202       0   1.0000 0.00000      1.00000       1.0000
##   150    136      67   0.6683 0.03313      0.60644       0.7365
##   300     65      69   0.3242 0.03303      0.26551       0.3958
##   450     27      38   0.1347 0.02410      0.09482       0.1912
##   600     11      15   0.0570 0.01656      0.03223       0.1007
##   750      6       5   0.0311 0.01244      0.01418       0.0681
##   900      3       3   0.0155 0.00888      0.00507       0.0477
##  1050      1       1   0.0104 0.00728      0.00261       0.0410
##  1200      1       0   0.0104 0.00728      0.00261       0.0410
```

```r
survfit2(Surv(time, status) ~ 1, data = df_TTD) %>% ggsurvfit() +
  labs(
    x = "Days",
    y = "Overall survival probability"
  ) + 
  add_risktable()
ggsave("Baseline_OS_Curves.png", width = 4, height = 4, dpi=300)
#png(paste("Baseline_OS_Curves", ".png"))
#dev.off()
while (!is.null(dev.list()))  dev.off()

km_fit_OS <- survfit(Surv(time, status) ~ 1, data=df_TTD)
summary(km_fit_OS, times = c(0,300,600,900,1200,1500,1800,1810,1820,1830,1840,1850,1860,1870,1880,1890,1891,1892,1893,1894,1895,1896,1897,1898,1899,1900,1901,2000,2010))
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTD)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##     0    202       0   1.0000  0.0000      1.00000        1.000
##   300    154      47   0.7667  0.0298      0.71047        0.827
##   600     95      57   0.4809  0.0354      0.41638        0.555
##   900     49      43   0.2581  0.0313      0.20340        0.327
##  1200     15      24   0.1068  0.0242      0.06847        0.166
##  1500      5       4   0.0725  0.0218      0.04023        0.131
##  1800      1       1   0.0362  0.0278      0.00804        0.163
##  1810      1       0   0.0362  0.0278      0.00804        0.163
##  1820      1       0   0.0362  0.0278      0.00804        0.163
##  1830      1       0   0.0362  0.0278      0.00804        0.163
##  1840      1       0   0.0362  0.0278      0.00804        0.163
##  1850      1       0   0.0362  0.0278      0.00804        0.163
##  1860      1       0   0.0362  0.0278      0.00804        0.163
##  1870      1       0   0.0362  0.0278      0.00804        0.163
##  1880      1       0   0.0362  0.0278      0.00804        0.163
##  1890      1       0   0.0362  0.0278      0.00804        0.163
##  1891      1       0   0.0362  0.0278      0.00804        0.163
##  1892      1       0   0.0362  0.0278      0.00804        0.163
##  1893      1       0   0.0362  0.0278      0.00804        0.163
##  1894      1       0   0.0362  0.0278      0.00804        0.163
##  1895      1       0   0.0362  0.0278      0.00804        0.163
##  1896      1       0   0.0362  0.0278      0.00804        0.163
##  1897      1       0   0.0362  0.0278      0.00804        0.163
##  1898      1       0   0.0362  0.0278      0.00804        0.163
##  1899      1       0   0.0362  0.0278      0.00804        0.163
```

```r
# The PFS and OS curves I create, match those from the publication, so we know the data we are feeding in is correct.




# Now lets aks ourselves, do the Weibull probabilities we create match the probabilities created directly by the Kaplan-Meier (probably best to read this with the PDF of the Angiopredict study open on the survival curves (PFS and OS) for Figure 4d in the paper, and Figure 10d in the supplement (which represents the patient time to event data that is used in this study)):

# Seeing that the PFS and OS curves I create, match those from the publication, the problem I was having in matching these must be in how I am generating probabilities in my model.

# I calculate the probability of not progressing at the different time periods in the data from the publication, to contrast this to the probabilities I create of not progressing at different time periods once I've created probabilities in the R code, the probability of survival at each time period will be reported under the "survival" heading, per: https://www.emilyzabor.com/tutorials/survival_analysis_in_r_tutorial.html 

summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 0)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTP)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##     0    202       0        1       0            1            1
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 150)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTP)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##   150    136      67    0.668  0.0331        0.606        0.737
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 300)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTP)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##   300     65     136    0.324   0.033        0.266        0.396
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 450)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTP)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##   450     27     174    0.135  0.0241       0.0948        0.191
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 600)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTP)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##   600     11     189    0.057  0.0166       0.0322        0.101
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 750)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTP)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##   750      6     194   0.0311  0.0124       0.0142       0.0681
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 900)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTP)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##   900      3     197   0.0155 0.00888      0.00507       0.0477
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 1050)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTP)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##  1050      1     198   0.0104 0.00728      0.00261        0.041
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 1200)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTP)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##  1200      1     198   0.0104 0.00728      0.00261        0.041
```

```r
# I can repeat this for TTD:


summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 0)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTD)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##     0    202       0        1       0            1            1
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 150)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTD)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##   150    178      24    0.881  0.0228        0.838        0.927
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 300)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTD)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##   300    154      47    0.767  0.0298         0.71        0.827
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 450)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTD)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##   450    127      75    0.627  0.0341        0.564        0.698
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 600)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTD)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##   600     95     104    0.481  0.0354        0.416        0.555
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 750)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTD)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##   750     64     133    0.332  0.0335        0.272        0.404
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 900)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTD)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##   900     49     147    0.258  0.0313        0.203        0.327
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 1050)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTD)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##  1050     34     156    0.208  0.0294        0.157        0.274
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 1200)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTD)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##  1200     15     171    0.107  0.0242       0.0685        0.166
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 1350)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTD)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##  1350     10     173   0.0906  0.0231       0.0549        0.149
```

```r
summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 1500)
```

```
## Call: survfit(formula = Surv(time, status) ~ 1, data = df_TTD)
## 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##  1500      5     175   0.0725  0.0218       0.0402        0.131
```

```r
# Do the Weibull probabilities match the probabilities created directly by the Kaplan-Meier:

# Here's how I checked if the Weibull probabilities match the probabilities created directly by the Kaplan-Meier, basically, I take the Kaplan-Meier probabilities at a few different cycles directly from the data as below, the probability of survival at each time period will be reported under the "survival" heading:

# I do this first for TTP:

# summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 0)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 14)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 28)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 42)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 56)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 70)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 84)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 98)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTP), times = 112)


# Then, I calculate the probability of staying in the PFS state, which is what the above gives me. To do this, I create all the other probabilities as zero because I just want to look at whats going on with my Weibull probabilities for the PFS curve, I also put it in the first slot, as the way it works is that it needs to be multiplied by 1, and m_M_SoC has a cohort trace with 1 in in the first slot, ready to be matrix multiplied by m_P_SoC with it's probabilities. It's 1- because the probabilities created above from the PFS curve are probabilities of staying in PFS, not the probabilities of moving from PFS to OS.

# m_P_SoC["PFS", "PFS",]<- (1 -p_PFSOS_SoC)
# m_P_SoC["PFS", "OS",]<- 0
# m_P_SoC["PFS", "Dead",]<-0
# 
# # Setting the transition probabilities from OS
# m_P_SoC["OS", "OS", ] <- 0
# m_P_SoC["OS", "Dead", ]        <- 0
# 
# 
# # Setting the transition probabilities from Dead
# m_P_SoC["Dead", "Dead", ] <- 0

# So here I once again create the Markov cohort trace by looping over all cycles
# - note that the trace can easily be obtained using matrix multiplications
# - note that now the right probabilities for the cycle need to be selected, like I explained above. (this is all just the comments written from where I actually do the analysis).
# for(i_cycle in 1:(n_cycle-1)) {
#   m_M_SoC[i_cycle + 1, ] <- m_M_SoC[i_cycle, ] %*% m_P_SoC[ , , i_cycle]
#   m_M_Exp[i_cycle + 1, ] <- m_M_Exp[i_cycle, ] %*% m_P_Exp[ , , i_cycle]
# }

# head(m_M_SoC)  # print the first few lines of the matrix for standard of care (m_M_SoC)
# head(m_M_Exp)  # print the first few lines of the matrix for experimental treatment(m_M_Exp)

# looking at the cohort trace -> m_M_SoC, you see that the proportions in the PFS state from 100 are basically identical to the probabilities of being in those states created from the Kaplan Meier, again starting from 100% of people under study, thus, the Weibull probabilities created match the Kaplan-Meier.

# They can be a few % off but that's OK, as it's fitting a Weibull to the Kaplan Meier curves, so they're not going to be identical.

# m_M_SoC


# I can repeat this for TTD:
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 0)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 14)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 28)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 42)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 56)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 70)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 84)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 98)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 112)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 126)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 158)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 172)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 184)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 198)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 212)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 224)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 238)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 252)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 266)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 280)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 294)
# 
# summary(survfit(Surv(time, status) ~ 1, data = df_TTD), times = 308)

# Here, like above, I put the p_PFSD_SoC bit into the first part of the probability matrix, even though it concerns people going from first line treatment or PFS to dead, because it needs to be multiplied by the 1 that exists in the cohort:

# 
# m_P_SoC["PFS", "PFS",]<- 1- p_PFSD_SoC
# m_P_SoC["PFS", "OS",]<- 0
# m_P_SoC["PFS", "Dead",]<-0
# 
# # Setting the transition probabilities from OS
# m_P_SoC["OS", "OS", ] <- 0
# m_P_SoC["OS", "Dead", ]        <- 0
# 
# 
# # Setting the transition probabilities from Dead
# m_P_SoC["Dead", "Dead", ] <- 0

# So here I once again create the Markov cohort trace by looping over all cycles
# - note that the trace can easily be obtained using matrix multiplications
# - note that now the right probabilities for the cycle need to be selected, like I explained above.
# for(i_cycle in 1:(n_cycle-1)) {
#   m_M_SoC[i_cycle + 1, ] <- m_M_SoC[i_cycle, ] %*% m_P_SoC[ , , i_cycle]
#   m_M_Exp[i_cycle + 1, ] <- m_M_Exp[i_cycle, ] %*% m_P_Exp[ , , i_cycle]
# }
# 
# 
# head(m_M_SoC)  # print the first few lines of the matrix for standard of care (m_M_SoC)
# head(m_M_Exp)  # print the first few lines of the matrix for experimental treatment(m_M_Exp)
# 
# #m_M_SoC
# m_M_SoC

# This also answers the question of how exactly probabilities are created in my code, the m_P_SoC is something that, when multiplied by 1, (when at the start 100% of our cohort are in the PFS state) gives us the first probability from that 100%, and the next part or row of that m_P_SoC probability is then multiplied by the proportion who are in the different states in the next row for the cohort (given their movements last time having been multiplied by m_P_SoC) which gives us the second probability multiplied by the proportion of that 1 (or 100%) in each state, and so on, and so forth, for each wave.
```


```r
# Time-to-Progression (TTP):
#04 Parametric Survival Analysis itself:

# We use the 'flexsurv' package to fit several commonly used parametric survival distributions.

# The data needs to be set up to include a column for the time (in days, weeks, years, etc.,) and a status indicator whether the time corresponds to an event, i.e. progression (status = 1), or to the last time of follow up, i.e. censoring (status = 0).


# It looks like in the example, Koen is applying the flexsurvreg formula to individuals who experience progression (i.e. ~1):

head(df_TTP)
```

```
##   time status
## 1  739      1
## 2  211      1
## 3  311      1
## 4  412      1
## 5   25      1
## 6  302      1
```

```r
l_TTP_SoC_exp      <- flexsurvreg(formula = Surv(time, status) ~ 1, data = df_TTP, dist = "exp")
l_TTP_SoC_gamma    <- flexsurvreg(formula = Surv(time, status) ~ 1, data = df_TTP, dist = "gamma")
l_TTP_SoC_gompertz <- flexsurvreg(formula = Surv(time, status) ~ 1, data = df_TTP, dist = "gompertz")
l_TTP_SoC_llogis   <- flexsurvreg(formula = Surv(time, status) ~ 1, data = df_TTP, dist = "llogis")
l_TTP_SoC_lnorm    <- flexsurvreg(formula = Surv(time, status) ~ 1, data = df_TTP, dist = "lnorm")
l_TTP_SoC_weibull  <- flexsurvreg(formula = Surv(time, status) ~ 1, data = df_TTP, dist = "weibull")
```


```r
#05 Inspecting the fits:

# And this would make sense per the below diagram - which looks at the proportion of individuals who have the event, i.e. progression.

# Inspect fit based on visual fit
colors <- rainbow(6)
plot(l_TTP_SoC_exp,       col = colors[1], ci = FALSE, ylab = "Event-free proportion", xlab = "Time in days", las = 1)
lines(l_TTP_SoC_gamma,    col = colors[2], ci = FALSE)
lines(l_TTP_SoC_gompertz, col = colors[3], ci = FALSE)
lines(l_TTP_SoC_llogis,   col = colors[4], ci = FALSE)
lines(l_TTP_SoC_lnorm,    col = colors[5], ci = FALSE)
lines(l_TTP_SoC_weibull,  col = colors[6], ci = FALSE)
legend("right",
       legend = c("exp", "gamma", "gompertz", "llogis", "lnorm", "weibull"),
       col    = colors,
       lty    = 1,
       bty    = "n")
```

<img src="Markov_3state_files/figure-html/unnamed-chunk-11-1.png" width="672" />

```r
#ggsave("Inspecting_Fits_PFS.png", width = 4, height = 4, dpi=300)
#while (!is.null(dev.list()))  dev.off()
#png(paste("Inspecting_Fits_PFS", ".png"))
#dev.off()

# Saving plots is as described here: https://stackoverflow.com/questions/70879324/storing-plots-as-variables-in-r

# By simply adding "; plot1 <- recordPlot()" to the end of the plot, I have the plot saved in the environment to enter into the console or as a piece of code in the Rmarkdown document whenever I like (using the name plot1) whenever I like. 

# I just need to remember to keep it when deleting items in the Rmarkdown file that calls this document.

# I run into trouble with this approach when I call this rmarkdown file from another rmarkdown file, so I can put the png("mtcars.png") above the plot and the following print(plot) dev.off() below the plot and save in that way, as per: https://ggplot2.tidyverse.org/reference/ggsave.html and here: https://stackoverflow.com/questions/58989775/how-to-using-code-to-save-plots-in-rstudio

# Koen says "# Weibull has the best visual and numerical fit" but I don't see what it's visually being compared to in this graph, I will have to learn about this in the C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\R Code\Parametric Survival Analysis\flexsurv folder.

# For Koen the time is in years which makes sense, the data he is drawing from is in years so that's what you want to make comparisons to.
```


```r
# Compare the fit numerically based on the AIC
(v_AIC_TTP <- c(
  exp      = l_TTP_SoC_exp$AIC,
  gamma    = l_TTP_SoC_gamma$AIC,
  gompertz = l_TTP_SoC_gompertz$AIC,
  llogis   = l_TTP_SoC_llogis$AIC,
  lnorm    = l_TTP_SoC_lnorm$AIC,
  weibull  = l_TTP_SoC_weibull$AIC
))
```

```
##      exp    gamma gompertz   llogis    lnorm  weibull 
##     2604     2570     2595     2580     2580     2575
```

```r
#v_AIC_TTP <- tibble::enframe(v_AIC_TTP)


# Weibull has the best visual and numerical fit


# tab_df(,
# title = "AIC Values", #always give
# #your tables
# #titles
# file = "v_AIC_TTP.doc")
```


```r
#06 Saving the survival parameters for use in the model:

# Saving the survival parameters ----

# The 'flexsurv' package return the coefficients, which need to be transformed for use in the base R functions, but that will be done when the coefficients actually are used, for the time being we will just save the survival parameters from the distribution we decide to use. 

# NB, if we are not going with Weibull then we may have to save something specific to the distribution that is not shape or scale - we can look into this if we don't use Weibull.

l_TTP_SoC_weibull
```

```
## Call:
## flexsurvreg(formula = Surv(time, status) ~ 1, data = df_TTP, 
##     dist = "weibull")
## 
## Estimates: 
##        est       L95%      U95%      se      
## shape    1.3917    1.2520    1.5470    0.0751
## scale  286.7776  258.1993  318.5191   15.3598
## 
## N = 202,  Events: 198,  Censored: 4
## Total time at risk: 52049
## Log-likelihood = -1285, df = 2
## AIC = 2575
```

```r
# Calling a flexsurvreg parameter like this allows you to see here that Weibull is the shape and the scale, so if we do go with another distribution we can see what it's version of shape and scale are and use these instead.

l_TTP_SoC_weibull$coefficients
```

```
##  shape  scale 
## 0.3305 5.6587
```

```r
coef_weibull_shape_SoC <- l_TTP_SoC_weibull$coefficients["shape"]
coef_weibull_scale_SoC <- l_TTP_SoC_weibull$coefficients["scale"]
```


```r
#Time-to-Dead (TTD):

#07 Parametric Survival Analysis itself:

# I repeat the things I said for TTP here:

# We use the 'flexsurv' package to fit several commonly used parametric survival distributions.

# The data needs to be set up to include a column for the time (in days, weeks, years, etc.,) and a status indicator whether the time corresponds to an event, i.e. progression (status = 1), or to the last time of follow up, i.e. censoring (status = 0).

# It looks like in his example, Koen is applying the flexsurvreg formula to individuals who experience progression (i.e. ~1):

head(df_TTD)
```

```
##   time status
## 1 1899      0
## 2  211      1
## 3  610      1
## 4  673      1
## 5   25      1
## 6 1187      1
```

```r
l_TTD_SoC_exp      <- flexsurvreg(formula = Surv(time, status) ~ 1, data = df_TTD, dist = "exp")
l_TTD_SoC_gamma    <- flexsurvreg(formula = Surv(time, status) ~ 1, data = df_TTD, dist = "gamma")
l_TTD_SoC_gompertz <- flexsurvreg(formula = Surv(time, status) ~ 1, data = df_TTD, dist = "gompertz")
l_TTD_SoC_llogis   <- flexsurvreg(formula = Surv(time, status) ~ 1, data = df_TTD, dist = "llogis")
l_TTD_SoC_lnorm    <- flexsurvreg(formula = Surv(time, status) ~ 1, data = df_TTD, dist = "lnorm")
l_TTD_SoC_weibull  <- flexsurvreg(formula = Surv(time, status) ~ 1, data = df_TTD, dist = "weibull")
```


```r
#08 Inspecting the fits:

# And this would make sense per the below diagram - which looks at the proportion of individuals who have the event, i.e. going to dead.

# Inspect fit based on visual fit
colors <- rainbow(6)
plot(l_TTD_SoC_exp,       col = colors[1], ci = FALSE, ylab = "Event-free proportion", xlab = "Time in days", las = 1)
lines(l_TTD_SoC_gamma,    col = colors[2], ci = FALSE)
lines(l_TTD_SoC_gompertz, col = colors[3], ci = FALSE)
lines(l_TTD_SoC_llogis,   col = colors[4], ci = FALSE)
lines(l_TTD_SoC_lnorm,    col = colors[5], ci = FALSE)
lines(l_TTD_SoC_weibull,  col = colors[6], ci = FALSE)
legend("right",
       legend = c("exp", "gamma", "gompertz", "llogis", "lnorm", "weibull"),
       col    = colors,
       lty    = 1,
       bty    = "n")
```

<img src="Markov_3state_files/figure-html/unnamed-chunk-15-1.png" width="672" />

```r
#ggsave("Inspecting_Fits_OS.png", width = 4, height = 4, dpi=300)
#while (!is.null(dev.list()))  dev.off()
#png(paste("Inspecting_Fits_OS", ".png"))
#dev.off()



# Koen says "# Weibull has the best visual and numerical fit" but I don't see what it's visually being compared to in this graph, I will have to learn about this in the C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\R Code\Parametric Survival Analysis\flexsurv folder.

# For Koen the time is in years which makes sense, the data he is drawing from is in years so that's what you want to make comparisons to.
```


```r
# Compare the fit numerically based on the AIC
(v_AIC_TTD <- c(
  exp      = l_TTD_SoC_exp$AIC,
  gamma    = l_TTD_SoC_gamma$AIC,
  gompertz = l_TTD_SoC_gompertz$AIC,
  llogis   = l_TTD_SoC_llogis$AIC,
  lnorm    = l_TTD_SoC_lnorm$AIC,
  weibull  = l_TTD_SoC_weibull$AIC
))
```

```
##      exp    gamma gompertz   llogis    lnorm  weibull 
##     2664     2649     2648     2665     2680     2646
```

```r
# Weibull has the best visual and numerical fit
```


```r
#09 Saving the survival parameters for use in the model:

# Saving the survival parameters ----

# The 'flexsurv' package return the coefficients, which need to be transformed for use in the base R functions, but that will be done when the coefficients actually are used, for the time being we will just save the survival parameters from the distribution we decide to use. 

# NB, if we are not going with Weibull then we may have to save something specific to the distribution that is not shape or scale - we can look into this if we don't use Weibull.

l_TTD_SoC_weibull
```

```
## Call:
## flexsurvreg(formula = Surv(time, status) ~ 1, data = df_TTD, 
##     dist = "weibull")
## 
## Estimates: 
##        est       L95%      U95%      se      
## shape    1.3530    1.1967    1.5297    0.0847
## scale  733.3499  656.5785  819.0978   41.3754
## 
## N = 202,  Events: 176,  Censored: 26
## Total time at risk: 124782
## Log-likelihood = -1321, df = 2
## AIC = 2646
```

```r
# Calling a flexsurvreg parameter like this allows you to see here that Weibull is the shape and the scale, so if we do go with another distribution we can see what it's version of shape and scale are and use these instead.

l_TTD_SoC_weibull$coefficients
```

```
##  shape  scale 
## 0.3023 6.5976
```

```r
coef_TTD_weibull_shape_SoC <- l_TTD_SoC_weibull$coefficients["shape"]
coef_TTD_weibull_scale_SoC <- l_TTD_SoC_weibull$coefficients["scale"]
```


```r
#03 Input model parameters
#  This is just a block of text reminding myself why ordering, V_names_states v_tc_SoC, v_tc_Exp,  v_tu_SoC and v_tu_Exp matters, feel free to skip over this:

# The ordering of V_names_states has an influence on the tornado diagram and the reported cost-effectiveness results.

# So, I need to ensure I correctly order V_names_states all the way through from the start.

# m_P_Exp and m_P_SoC both use v_names_states to set up the names of the rows and columns of their matrices. 

# As does m_M_SoC and m_M_Exp.

# Then m_M_SoC and  m_M_Exp use the row column names to fill in the 100% of the cohort (or 1) in PFS and the 0% of the cohort in OS and DEAD in wave 1. m_P_Exp and m_P_SoC also both use the row and column names to fill in the transition probabilities between PFS and OS, etc.,

# Then m_M_SoC and m_M_Exp are matrix multiplied by m_P_Exp and m_P_SoC:

# for(i_cycle in 1:(n_cycle-1)) {
#  m_M_SoC[i_cycle + 1, ] <- m_M_SoC[i_cycle, ] %*% m_P_SoC[ , , i_cycle]
#  m_M_Exp[i_cycle + 1, ] <- m_M_Exp[i_cycle, ] %*% m_P_Exp[ , , i_cycle]
# }

# The way this matrix multiplication works is that the value in box 1 for m_M_SoC is multiplied by the value in box 1 for m_P_SoC and so on. If box 1 for m_M_SoC and m_P_SoC is the 1 (i.e. 100% of people in the PFS state when this all starts), multiplied by the PFS state probabilities, i.e., the probability of going from the PFS state into other states like so:

#          PFS       AE1       AE2       AE3          OS        Dead

# PFS  0.974925 0.0194985 0.0194985 0.0194985 0.005074995 0.020000000

# (Ignore the AE health states, this layout is a holdover from when AE's were going to have their own health states in the Markov model).

# Then things will multiply correctly and we're multiplying PFS transition probabilities by the 100% of the cohort in the PFS state. 

# Even, if ordering v_names_states  <- c("PFS", "AE1", "AE2", "AE3", "OS", "Dead")   is not in the order as above, i.e., v_names_states  <- c("OS", "AE1", "AE2", "AE3", "PFS", "Dead") , then the m_M_SoC will have 0, 0, 0, 0, 1, 0, because everyone still starts in the PFS state, and m_P_SoC will have  "OS", "AE1", "AE2", "AE3", "PFS", "Dead", with the right probabilities put in the right spots, so when you matrix multiply it things will multiply out fine.

# However, this is not the case for ordering costs and utilities:

# v_tc_SoC <- m_M_SoC %*% c(c_F_SoC, c_AE1, c_AE2, c_AE3, c_P, c_D)
# v_tc_Exp <- m_M_Exp %*% c(c_F_Exp, c_AE1, c_AE2, c_AE3, c_P, c_D)
# v_tu_SoC <- m_M_SoC %*% c(u_F, u_AE1, u_AE2, u_AE3, u_P, u_D)
# v_tu_Exp <- m_M_Exp %*% c(u_F, u_AE1, u_AE2, u_AE3, u_P, u_D)

# As you can see, in both cases the ordering is set manually by how we enter things in the concatenated brackets, so in the case above where ordering v_names_states  <- c("PFS", "AE1", "AE2", "AE3", "OS", "Dead") is ordered differently, i.e., v_names_states  <- c("OS", "AE1", "AE2", "AE3", "PFS", "Dead") when we matrix multiply costs and utilities by m_M_SoC  and m_M_Exp above we will be multiplying the utility of being in the progression free state u_F by the matrix of individuals in the OS state, which will clearly be a smaller number of individuals in the first few waves, and multiplying the utility of the OS state (u_P) by the larger number of individuals actually in the PFS state <- c("OS", "AE1", "AE2", "AE3", "PFS", "Dead"). We'll be doing the same thing with costs. What this will mean is more people getting the OS costs and OS utility and fewer people getting the PFS costs and the PFS utility, which will in turn have consequences for the cost-effectiveness analysis results with more OS costs and more OS utility being considered in the equation that compares costs and utilities.

# I've confirmed all of the things I say about by changing the ordering first of v_names_states, and then of the cost and utility concatenations. Changing the ordering of v_names_states did nothing to the CEA results or Tornado diagram provided I changed the ordering of utilities and costs to match this, changing the ordering of utilities and costs changed both unless I changed them to be in an order that matched the changed ordering of v_names_states.
```


```r
## General setup

# Here, I think about how time from individual patient data may be changed to match the time of our cycles.

# I think the digitiser (if I am using one) will give me the time in the context of the survival curves I am digitising, i.e., time in weeks, or time in months or time in years. Otherwise if I get the data directly from Ian it will also have time in the context of the existing survival curves.

# Then I will have to set-up my time accordingly in the R code so that my cycle length is at the same level as the individual patient data.

# That is, in Koen's example:

# C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\R Code\Parametric Survival Analysis\ISPOR WEBINAR Health Economic Modelling in R\ISPOR_webinar_R-master

# the data includes a column for the time (in years)
# t_cycle <- 1/4      # cycle length of 3 months (in years)                                # n_cycle <- 60       # number of cycles (total runtime 15 years)
  

# So I would have my colum for time, in the [TIME] the graph I was digitising/getting data from used.
# Then I would create my cycle length of X weeks (in [TIME] the graph I was digitising used)
# Then I would have my number of cycles that would add up to give me a total runtime of how long I want to run the model for.
# So, above Koen wanted to run the model for 15 years, but his cycles were in 3 months, or each cycle was a quarter of a year, so 60 quarters, or 60 3 month cycles, is 15 years.

# REALISE HERE THEAT P_PD ISNT THE PROBABILITY OF PROGRESSION TO DEAD, BUT OF PFS TO DEAD, OF FIRST LINE TO DEAD, BECAUSE OUR ANGIOPREDICT CURVES ONLY EVER DESCRIBE FIRST LINE TREATMENT, BE THAT FIRST LINE SOC TREATMENT OR FIRST LINE EXP TREATMENT.

# Here we define all our model parameters, so that we can call on these parameters later during our model:

t_cycle <- 14      # cycle length of 2 weeks (in [[days]] - this is assuming the survival curves I am digitising will be in [[days]] if they are in another period I will have to represent my cycle length in that period instead).                                  
n_cycle        <- 143                            
# We set the number of cycles to 143 to reflect 2,000 days from the Angiopredict study (5 Years, 5 Months, 3 Weeks, 1 Day) broken down into fortnightly cycles
v_names_cycles  <- paste("cycle", 0:n_cycle)    
# So here, we just name each cycle by the cycle its on, going from 0 up to the number of cycles there are, here 143
v_names_states  <- c("PFS", "OS", "Dead")  
# These are the health states in our model, PFS, OS, Death.
n_states        <- length(v_names_states)        
# We're just taking the number of health states from the number of names we came up with, i.e. the number of names to reflect the number of health states 

# Strategy names
v_names_strats     <- c("Standard of Care",         
                     "Experimental Treatment")
               # store the strategy names
n_str           <- length(v_names_strats)           
# number of strategies



# TRANSITION PROBABILITIES: Time-To-Transition - TTP:


# Time-dependent transition probabilities are obtained in four steps
# 1) Defining the cycle times
# 2) Obtaining the event-free (i.e. survival) probabilities for the cycle times for SoC
# 3) Obtaining the event-free (i.e. survival) probabilities for the cycle times for Exp based on a hazard ratio
# 4) Obtaining the time-dependent transition probabilities from the event-free (i.e. survival) probabilities

# 1) Defining the cycle times
(t <- seq(from = 0, by = t_cycle, length.out = n_cycle + 1))
```

```
##   [1]    0   14   28   42   56   70   84   98  112  126  140  154  168  182  196  210  224
##  [18]  238  252  266  280  294  308  322  336  350  364  378  392  406  420  434  448  462
##  [35]  476  490  504  518  532  546  560  574  588  602  616  630  644  658  672  686  700
##  [52]  714  728  742  756  770  784  798  812  826  840  854  868  882  896  910  924  938
##  [69]  952  966  980  994 1008 1022 1036 1050 1064 1078 1092 1106 1120 1134 1148 1162 1176
##  [86] 1190 1204 1218 1232 1246 1260 1274 1288 1302 1316 1330 1344 1358 1372 1386 1400 1414
## [103] 1428 1442 1456 1470 1484 1498 1512 1526 1540 1554 1568 1582 1596 1610 1624 1638 1652
## [120] 1666 1680 1694 1708 1722 1736 1750 1764 1778 1792 1806 1820 1834 1848 1862 1876 1890
## [137] 1904 1918 1932 1946 1960 1974 1988 2002
```

```r
# Here we're saying, at each cycle how many of the time periods our individual patient data is measured at have passed? Here our individual patient data is in days, so we have 0 in cycle 0, 14 (or two weeks) in cycle 1, and so on.

# Having established that allows us to obtain the transition probabilities for the time we are interested in for our cycles from this different period individual patient data, so where the individual patient data is in days and our cycles are in fortnight or half months, this allows us to obtain transition probabilities for these fortnights.

# 2) Obtaining the event-free (i.e. survival) probabilities for the cycle times for SoC
# S_FP_SoC - survival of progression free to progression, i.e. not going to progression, i.e. staying in progression free.
# Note that the coefficients [that we took from flexsurvreg earlier] need to be transformed to obtain the parameters that the base R function uses


S_FP_SoC <- pweibull(
  q     = t, 
  shape = exp(coef_weibull_shape_SoC), 
  scale = exp(coef_weibull_scale_SoC), 
  lower.tail = FALSE
)

head(cbind(t, S_FP_SoC))
```

```
##       t S_FP_SoC
## [1,]  0   1.0000
## [2,] 14   0.9852
## [3,] 28   0.9615
## [4,] 42   0.9333
## [5,] 56   0.9021
## [6,] 70   0.8689
```

```r
#        t  S_FP_SoC
# [1,] 0.0 1.0000000
# [2,] 0.5 0.9948214
# [3,] 1.0 0.9770661
# [4,] 1.5 0.9458256
# [5,] 2.0 0.9015175
# [6,] 2.5 0.8454597


# Having the above header shows that this is probability for surviving in the F->P state, i.e., staying in this state, because you can see in time 0 100% of people are in this state, meaning 100% of people hadnt progressed and were in PFS, if this was instead about the progressed state (i.e. OS), there should be no-one in this state when the model starts, as everyone starts in the PFS state, and it takes a while for people to reach the OS state.


# 3) Obtaining the event-free (i.e. survival) probabilities for the cycle times for Experimental treatment (aka the novel therapy) based on a hazard ratio.
# So here we basically have a hazard ratio for the novel therapy that says you do X much better under the novel therapy than under standard of care, and we want to apply it to standard of care from our individual patient data to see how much improved things would be under the novel therapy.
# (NB - if we ultimately decide not to use a hazard ratio, I could probably just create my transition probabilities for the experimental therapy from individual patient data that I have digitised from patients under this novel therapy).
# Here our hazard ratio is 0.68, I can change that hazard ratio if I need to in the future.
# - note that S(t) = exp(-H(t)) and, hence, H(t) = -ln(S(t))
# that is, the survival function is the expoential of the negative hazard function, per:
# https://faculty.washington.edu/yenchic/18W_425/Lec5_survival.pdf
# and: 
# https://web.stanford.edu/~lutian/coursepdf/unit1.pdf
# Also saved here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\R Code\Parametric Survival Analysis\flexsurv
# And to multiply by the hazard ratio it's necessary to convert the survivor function into the hazard function, multiply by the hazard ratio, and then convert back to the survivor function, and then these survivor functions are used for the probabilities.
HR_FP_Exp <- 0.68
H_FP_SoC  <- -log(S_FP_SoC)
H_FP_Exp  <- H_FP_SoC * HR_FP_Exp
S_FP_Exp  <- exp(-H_FP_Exp)

head(cbind(t, S_FP_SoC, H_FP_SoC, H_FP_Exp, S_FP_Exp))
```

```
##       t S_FP_SoC H_FP_SoC H_FP_Exp S_FP_Exp
## [1,]  0   1.0000  0.00000  0.00000   1.0000
## [2,] 14   0.9852  0.01496  0.01017   0.9899
## [3,] 28   0.9615  0.03925  0.02669   0.9737
## [4,] 42   0.9333  0.06901  0.04693   0.9542
## [5,] 56   0.9021  0.10299  0.07003   0.9324
## [6,] 70   0.8689  0.14049  0.09553   0.9089
```

```r
head(cbind(t, S_FP_SoC, H_FP_SoC))
```

```
##       t S_FP_SoC H_FP_SoC
## [1,]  0   1.0000  0.00000
## [2,] 14   0.9852  0.01496
## [3,] 28   0.9615  0.03925
## [4,] 42   0.9333  0.06901
## [5,] 56   0.9021  0.10299
## [6,] 70   0.8689  0.14049
```

```r
    # I want to vary my probabilities for the one-way sensitivity analysis, particularly for the tornado       plot of the deterministic sensitivity analysis. 
    
    # The problem here is that df_params_OWSA doesnt like the fact that a different probability for each       cycle (from the time-dependent transition probabilities) gives a large number of rows (say if there were 60 cycles,      two treatment strategies and a probability for each cycle we would see 122 rows). It wants the same number of       rows as      there are probabilities, i.e., it would prefer a probability of say 0.50 and then a max and a      min     around that.
    
    # To address this, I think I can apply this mean, max and min to the hazard ratios instead, knowing        that when run_owsa_det is run in the sensitivity analysis it calls the "oncologySemiMarkov_function" function to run and in this        function the hazard ratios generate the survivor function, and then these survivor functions are used      to generate the probabilities (which will be cycle dependent).
    
    # This is fine for the hazard ratio for the experimental strategy, I can just take:
    
    # HR_FP_Exp as my mean, and:
    
    # Minimum_HR_FP_Exp <- HR_FP_Exp - 0.20*HR_FP_Exp
    # Maximum_HR_FP_Exp <- HR_FP_Exp + 0.20*HR_FP_Exp
    
    # For min and max.
    
# For standard of care there was no hazard ratio, because we took these values from the survival curves     directly, and didnt vary them by a hazard ratio, like we do above.
    
# To address this, I create a hazard ratio that is exactly one.
    
    # hazard ratio

    # A measure of how often a particular event happens in one group compared to how often it happens in       another group, over time. In cancer research, hazard ratios are often used in clinical trials to           measure survival at any point in time in a group of patients who have been given a specific treatment      compared to a control group given another treatment or a placebo. A hazard ratio of one means that         there is no difference in survival between the two groups. A hazard ratio of greater than one or less      than one means that survival was better in one of the groups. https://www.cancer.gov/publications/dictionaries/cancer-terms/def/hazard-ratio

    # Thus, I can have a hazard ratio where the baseline value of it gives you the survival curves, and        thus the probabilities, from the actual survival curves we are drawing from, and where the min and max     will be 1 +/- 0.20, which will give us probabilities that are 20% higher or lower than the probabilities from the actual survival curves that we are drawing from in the parametric survival analysis to get transitions under standard of care.
    
    # To do this, I just have to add a hazard ratio to the code that creates the transition probabilities      under standard of care as below, then I can add that hazard ratio, and it's max and min, to the            deterministic sensitivity analysis and vary all the probabilities by 20%.
        

    # So here we basically have a hazard ratio that is equal to 1, so it leaves things unchanged for           patients, and we want to apply it to standard of care from our individual patient data to leave things     unchanged in this function, but allow things to change in the sensitivity analysis lower down.
      
    # Here our hazard ratio is 1, things are unchanged.

# So, first we create our hazard ratio == 1
HR_FP_SoC <- 1

# (I'm creating the below as new parameters, i.e. putting "nu" infront of them, in case keeping the name the same causes a problem for when I want to use them in the deterministic sensivity analysis, i.e., if I generate a parameter from itself - say var_name = var_name exactly, then there may be some way in which R handles code that won't let this work, or will take one parameter before the other, or something and stop the model from executing correctly).

# Then, we create our hazard function for SoC:
NU_S_FP_SoC <- S_FP_SoC
NU_H_FP_SoC  <- -log(NU_S_FP_SoC)
# Then, we multiply this hazard function by our hazard ratio, which is just 1, but which gives us the      opportunity to apply a hazard ratio to standard of care in our code and thus to have a hazard ratio for     standard of care for our one way deterministic sensitivity analysis and tornado diagram lower down in our code:
NUnu_H_FP_SoC  <- NU_H_FP_SoC * HR_FP_SoC
# Again, I was worried that with overlap when creating parameters I would have a problem with the deterministic sensivity analysis so I call it NU again to make it a "new" parameter again.
NU_S_FP_SoC  <- exp(-NUnu_H_FP_SoC)

head(cbind(t, NU_S_FP_SoC, NUnu_H_FP_SoC))
```

```
##       t NU_S_FP_SoC NUnu_H_FP_SoC
## [1,]  0      1.0000       0.00000
## [2,] 14      0.9852       0.01496
## [3,] 28      0.9615       0.03925
## [4,] 42      0.9333       0.06901
## [5,] 56      0.9021       0.10299
## [6,] 70      0.8689       0.14049
```

```r
# NU_H_FP_SoC  <- -log(NU_S_FP_SoC)
# # Then, we multiply this hazard function by our hazard ratio, which is just 1, but which gives us the      opportunity to apply a hazard ratio to standard of care in our code and thus to have a hazard ratio for     standard of care for our one way deterministic sensitivity analysis and tornado diagram.
# NU_H_FP_SoC  <- NU_H_FP_SoC * HR_FP_SoC
# # 
# NU_S_FP_SoC  <- exp(-NU_H_FP_SoC)
# 
# head(cbind(t, NU_S_FP_SoC, NU_H_FP_SoC))












# 4) Obtaining the time-dependent transition probabilities from the event-free (i.e. survival) probabilities

# Now we can take the probability of being in the PFS state at each of our cycles, as created above, from 100% (i.e. from 1) in order to get the probability of NOT being in the PFS state, i.e. in order to get the probability of moving into the progressed state, i.e. the OS state.
 
p_PFSOS_SoC <- p_PFSOS_Exp <- rep(NA, n_cycle)

# First we make the probability of going from progression-free (F) to progression (P) blank (i.e. NA) for all the cycles in standard of care and all the cycles under the experimental strategy.

for(i in 1:n_cycle) {
  p_PFSOS_SoC[i] <- 1 - NU_S_FP_SoC[i+1] /  NU_S_FP_SoC[i]
  p_PFSOS_Exp[i] <- 1 - S_FP_Exp[i+1] / S_FP_Exp[i]
}




# If I ever wanted to round my probabilities to 2 decimal places, I can do this as below, but this code actually makes probabilities that sum perfectly to 1, so there's no need to do this.

# round(p_PFSOS_SoC, digits=2)
# round(p_PFSOS_Exp, digits=2)




# Then we generate our transition probability under standard of care and under the experimental treatement using survival functions that havent and have had the hazard ratio from above applied to them, respectively.


# The way this works is the below, you take next cycles probability of staying in this state, divide it by this cycles probability of staying in this state, and take it from 1 to get the probability of leaving this state. 

# > head(cbind(t, S_FP_SoC))
#        t  S_FP_SoC
# [1,] 0.0 1.0000000
# [2,] 0.5 0.9948214
# [3,] 1.0 0.9770661
# [4,] 1.5 0.9458256
# [5,] 2.0 0.9015175
# [6,] 2.5 0.8454597
# > 1-0.9948214/1.0000000
# [1] 0.0051786
# > 0.9770661/0.9948214
# [1] 0.9821523
# > 1-0.9821523
# [1] 0.0178477

# p_FP_SoC
p_PFSOS_SoC
```

```
##   [1] 0.01485 0.02400 0.02932 0.03341 0.03681 0.03977 0.04240 0.04479 0.04699 0.04903
##  [11] 0.05095 0.05274 0.05445 0.05607 0.05761 0.05909 0.06051 0.06188 0.06320 0.06447
##  [21] 0.06570 0.06690 0.06806 0.06919 0.07028 0.07135 0.07240 0.07341 0.07441 0.07538
##  [31] 0.07633 0.07727 0.07818 0.07908 0.07995 0.08082 0.08166 0.08250 0.08331 0.08412
##  [41] 0.08491 0.08569 0.08646 0.08721 0.08796 0.08869 0.08941 0.09013 0.09083 0.09153
##  [51] 0.09221 0.09289 0.09356 0.09422 0.09487 0.09552 0.09615 0.09678 0.09741 0.09802
##  [61] 0.09863 0.09923 0.09983 0.10042 0.10100 0.10158 0.10216 0.10272 0.10328 0.10384
##  [71] 0.10439 0.10494 0.10548 0.10602 0.10655 0.10707 0.10760 0.10811 0.10863 0.10914
##  [81] 0.10964 0.11014 0.11064 0.11113 0.11162 0.11211 0.11259 0.11307 0.11354 0.11401
##  [91] 0.11448 0.11495 0.11541 0.11587 0.11632 0.11677 0.11722 0.11766 0.11811 0.11855
## [101] 0.11898 0.11942 0.11985 0.12028 0.12070 0.12112 0.12154 0.12196 0.12238 0.12279
## [111] 0.12320 0.12361 0.12401 0.12441 0.12481 0.12521 0.12561 0.12600 0.12639 0.12678
## [121] 0.12717 0.12755 0.12794 0.12832 0.12869 0.12907 0.12945 0.12982 0.13019 0.13056
## [131] 0.13093 0.13129 0.13165 0.13202 0.13238 0.13273 0.13309 0.13344 0.13380 0.13415
## [141] 0.13450 0.13484 0.13519
```

```r
#> p_FP_SoC
#  [1] 0.005178566 0.017847796 0.031973721 0.046845943 0.062181645
#p_FP_Exp
p_PFSOS_Exp
```

```
##   [1] 0.01012 0.01638 0.02003 0.02284 0.02518 0.02722 0.02903 0.03068 0.03220 0.03361
##  [11] 0.03493 0.03618 0.03735 0.03848 0.03955 0.04057 0.04156 0.04251 0.04342 0.04430
##  [21] 0.04516 0.04599 0.04680 0.04758 0.04835 0.04909 0.04982 0.05053 0.05122 0.05190
##  [31] 0.05256 0.05321 0.05385 0.05448 0.05509 0.05569 0.05628 0.05687 0.05744 0.05800
##  [41] 0.05855 0.05910 0.05964 0.06017 0.06069 0.06120 0.06171 0.06221 0.06270 0.06319
##  [51] 0.06367 0.06414 0.06461 0.06508 0.06553 0.06599 0.06643 0.06688 0.06731 0.06775
##  [61] 0.06818 0.06860 0.06902 0.06943 0.06985 0.07025 0.07066 0.07105 0.07145 0.07184
##  [71] 0.07223 0.07261 0.07300 0.07337 0.07375 0.07412 0.07449 0.07485 0.07522 0.07558
##  [81] 0.07593 0.07629 0.07664 0.07699 0.07733 0.07767 0.07801 0.07835 0.07869 0.07902
##  [91] 0.07935 0.07968 0.08001 0.08033 0.08065 0.08097 0.08129 0.08160 0.08192 0.08223
## [101] 0.08254 0.08284 0.08315 0.08345 0.08375 0.08405 0.08435 0.08465 0.08494 0.08523
## [111] 0.08552 0.08581 0.08610 0.08638 0.08667 0.08695 0.08723 0.08751 0.08779 0.08807
## [121] 0.08834 0.08861 0.08889 0.08916 0.08942 0.08969 0.08996 0.09022 0.09049 0.09075
## [131] 0.09101 0.09127 0.09153 0.09179 0.09204 0.09230 0.09255 0.09280 0.09305 0.09330
## [141] 0.09355 0.09380 0.09405
```

```r
# TRANSITION PROBABILITIES: Time-To-Dead TTD

# [[I basically re-tread what I did for TTP so feel free just to skim this]]

# REALISE HERE THEAT P_PD ISNT THE PROBABILITY OF PROGRESSION TO DEAD, BUT OF PFS TO DEAD, OF FIRST LINE TO DEAD, BECAUSE OUR ANGIOPREDICT CURVES ONLY EVER DESCRIBE FIRST LINE TREATMENT, BE THAT FIRST LINE SOC TREATMENT OR FIRST LINE EXP TREATMENT.


# To make sure that my PFS probabilities only reflect going from PFS to progression, I create the probability of going from PFS to DEAD under standard of care and the experimental, and decrease my PFS to progression probability created above by the probability of going into the dead state, such that I am only capturing people going into progression, and not people going into death as well.

# So, first I create the transition probabilities of progression free into dead for SoC and Exp, then I convert all the probabilities (i.e. those for PFS and those for OS) into rates, minus them from eachother, turn them back into probabilities, and make sure none are negative (and where they are replace these with 0).

# Actually, I don't do the rates thing, I just I take all the probabilities (i.e. those for PFS and those for OS), minus them from eachother.

# (ACTUALLY, I'm leaving this here for now, but ultimately I decided against doing any of the above, given a comment made by Joshua in email).



# Time-dependent transition probabilities are obtained in four steps
# 1) Defining the cycle times [we already did this above]
# 2) Obtaining the event-free (i.e. overall survival) probabilities for the cycle times for SoC
# 3) Obtaining the event-free (i.e. overall survival) probabilities for the cycle times for Exp based on a hazard ratio
# 4) Obtaining the time-dependent transition probabilities from the event-free (i.e. overall survival) probabilities

# 1) Defining the cycle times
(t <- seq(from = 0, by = t_cycle, length.out = n_cycle + 1))
```

```
##   [1]    0   14   28   42   56   70   84   98  112  126  140  154  168  182  196  210  224
##  [18]  238  252  266  280  294  308  322  336  350  364  378  392  406  420  434  448  462
##  [35]  476  490  504  518  532  546  560  574  588  602  616  630  644  658  672  686  700
##  [52]  714  728  742  756  770  784  798  812  826  840  854  868  882  896  910  924  938
##  [69]  952  966  980  994 1008 1022 1036 1050 1064 1078 1092 1106 1120 1134 1148 1162 1176
##  [86] 1190 1204 1218 1232 1246 1260 1274 1288 1302 1316 1330 1344 1358 1372 1386 1400 1414
## [103] 1428 1442 1456 1470 1484 1498 1512 1526 1540 1554 1568 1582 1596 1610 1624 1638 1652
## [120] 1666 1680 1694 1708 1722 1736 1750 1764 1778 1792 1806 1820 1834 1848 1862 1876 1890
## [137] 1904 1918 1932 1946 1960 1974 1988 2002
```

```r
# 2) Obtaining the event-free (i.e. overall survival) probabilities for the cycle times for SoC
# S_PD_SoC - survival of progression free to dead, i.e. not going to dead, i.e. staying in that first progression free state.
# Note that the coefficients [that we took from flexsurvreg earlier] need to be transformed to obtain the parameters that the base R function uses


S_PD_SoC <- pweibull(
  q     = t, 
  shape = exp(coef_TTD_weibull_shape_SoC), 
  scale = exp(coef_TTD_weibull_scale_SoC), 
  lower.tail = FALSE
)

head(cbind(t, S_PD_SoC))
```

```
##       t S_PD_SoC
## [1,]  0   1.0000
## [2,] 14   0.9953
## [3,] 28   0.9880
## [4,] 42   0.9793
## [5,] 56   0.9697
## [6,] 70   0.9592
```

```r
# Having the above header shows that this is probability for surviving in the PFS->D state, i.e., staying in this state, because you should see in time 0 0% of people are in this state, meaning 100% of people hadnt gone into the dead state and were in PFS, which make sense in this model, the model starts with everyone in PFS, no-one starts the model in dead, and it takes a while for people to reach the dead state.


# 3) Obtaining the event-free (i.e. overall survival) probabilities for the cycle times for Experimental treatment (aka the novel therapy) based on a hazard ratio.
# So here we basically have a hazard ratio for the novel therapy that says you do X much better under the novel therapy than under standard of care, and we want to apply it to standard of care from our individual patient data to see how much improved things would be under the novel therapy.

# Here our hazard ratio is 0.65, I can change that hazard ratio if necessary.
# - note that S(t) = exp(-H(t)) and, hence, H(t) = -ln(S(t))
# that is, the survival function is the expoential of the negative hazard function, per:
# https://faculty.washington.edu/yenchic/18W_425/Lec5_survival.pdf
# and: 
# https://web.stanford.edu/~lutian/coursepdf/unit1.pdf
# Also saved here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\R Code\Parametric Survival Analysis\flexsurv
# And to multiply by the hazard ratio it's necessary to convert the survivor function into the hazard function, multiply by the hazard ratio, and then convert back to the survivor function, and then these survivor functions are used for the probabilities.
HR_PD_Exp <- 0.65
H_PD_SoC  <- -log(S_PD_SoC)
H_PD_Exp  <- H_PD_SoC * HR_PD_Exp
S_PD_Exp  <- exp(-H_PD_Exp)

head(cbind(t, S_PD_SoC, H_PD_SoC, H_PD_Exp, S_PD_Exp))
```

```
##       t S_PD_SoC H_PD_SoC H_PD_Exp S_PD_Exp
## [1,]  0   1.0000  0.00000 0.000000   1.0000
## [2,] 14   0.9953  0.00472 0.003068   0.9969
## [3,] 28   0.9880  0.01206 0.007836   0.9922
## [4,] 42   0.9793  0.02087 0.013564   0.9865
## [5,] 56   0.9697  0.03080 0.020018   0.9802
## [6,] 70   0.9592  0.04165 0.027073   0.9733
```

```r
# I want to vary my probabilities for the one-way sensitivity analysis, particularly for the tornado       plot of the deterministic sensitivity analysis. 

# The problem here is that df_params_OWSA doesnt like the fact that a different probability for each       cycle (from the time-dependent transition probabilities) gives many rows (say there are 60 cycles,      two treatment strategies and a probability for each cycle would give 122 rows). It wants the same number of       rows as      there are probabilities, i.e., it would prefer a probability of say 0.50 and then a max and a      min     around that.

# To address this, I think I can apply this mean, max and min to the hazard ratios instead, knowing        that when run_owsa_det is run in the sensitivity analysis it calls this function to run and in this        function the hazard ratios generate the survivor function, and then these survivor functions are used      to generate the probabilities (which will be cycle dependent).

# This is fine for the hazard ratio for the experimental strategy, I can just take:

# HR_PD_Exp as my mean, and:

# Minimum_HR_PD_Exp <- HR_PD_Exp - 0.20*HR_PD_Exp
# Maximum_HR_PD_Exp <- HR_PD_Exp + 0.20*HR_PD_Exp

# For min and max.

# For standard of care there was no hazard ratio, because we took these values from the survival curves     directly, and didnt vary them by a hazard ratio, like we do above.

# To address this, I create a hazard ratio that is exactly one.

# hazard ratio

# A measure of how often a particular event happens in one group compared to how often it happens in       another group, over time. In cancer research, hazard ratios are often used in clinical trials to           measure survival at any point in time in a group of patients who have been given a specific treatment      compared to a control group given another treatment or a placebo. A hazard ratio of one means that         there is no difference in survival between the two groups. A hazard ratio of greater than one or less      than one means that survival was better in one of the groups. https://www.cancer.gov/publications/dictionaries/cancer-terms/def/hazard-ratio

# Thus, I can have a hazard ratio where the baseline value of it gives you the survival curves, and        thus the probabilities, from the actual survival curves we are drawing from, and where the min and max     will be 1 +/- 0.20, which will give us probabilities that are 20% higher or lower than the probabilities from the actual survival curves that we are drawing from in the parametric survival analysis to get transitions under standard of care.

# To do this, I just have to add a hazard ratio to the code that creates the transition probabilities      under standard of care as below, then I can add that hazard ratio, and it's max and min, to the            deterministic sensitivity analysis and vary all the probabilities by 20%.


# So here we basically have a hazard ratio that is equal to 1, so it leaves things unchanged for           patients, and we want to apply it to standard of care from our individual patient data to leave things     unchanged in this function, but allow things to change in the sensitivity analysis.

# Here our hazard ratio is 1, things are unchanged.

# So, first we create our hazard ratio == 1
HR_PD_SoC <- 1

# (I'm creating the below as new parameters, i.e. putting "nu" infront of them, in case keeping the name the same causes a problem for when I want to use them in the deterministic sensivity analysis, i.e., if I generate a parameter from itself - say var_name = var_name exactly, then there may be some way in which R handles code that won't let this work, or will take one parameter before the other, or something and stop the model from executing correctly).

# Then, we create our hazard function for SoC:
NU_S_PD_SoC <- S_PD_SoC
NU_H_PD_SoC  <- -log(NU_S_PD_SoC)
# Then, we multiply this hazard function by our hazard ratio, which is just 1, but which gives us the      opportunity to apply a hazard ratio to standard of care in our code and thus to have a hazard ratio for     standard of care for our one way deterministic sensitivity analysis and tornado diagram.
NUnu_H_PD_SoC  <- NU_H_PD_SoC * HR_PD_SoC
# Again, I was worried that with overlap when creating parameters I would have a problem with the deterministic sensivity analysis so I call it NU again to make it a "new" parameter again.
NU_S_PD_SoC  <- exp(-NUnu_H_PD_SoC)

head(cbind(t, NU_S_PD_SoC, NUnu_H_PD_SoC))
```

```
##       t NU_S_PD_SoC NUnu_H_PD_SoC
## [1,]  0      1.0000       0.00000
## [2,] 14      0.9953       0.00472
## [3,] 28      0.9880       0.01206
## [4,] 42      0.9793       0.02087
## [5,] 56      0.9697       0.03080
## [6,] 70      0.9592       0.04165
```

```r
# NU_H_PD_SoC  <- -log(NU_S_PD_SoC)
# # Then, we multiply this hazard function by our hazard ratio, which is just 1, but which gives us the      opportunity to apply a hazard ratio to standard of care in our code and thus to have a hazard ratio for     standard of care for our one way deterministic sensitivity analysis and tornado diagram.
# NU_H_PD_SoC  <- NU_H_PD_SoC * HR_PD_SoC
# # 
# NU_S_PD_SoC  <- exp(-NU_H_PD_SoC)
# 
# head(cbind(t, NU_S_PD_SoC, NU_H_PD_SoC))


# 4) Obtaining the time-dependent transition probabilities from the event-free (i.e. survival) probabilities

# Now we can take the probability of being in the PFS state at each of our cycles, as created above, from 100% (i.e. from 1) in order to get the probability of NOT being in the PFS state, i.e. in order to get the probability of moving into the progressed state, or the OS state.


p_PFSD_SoC <- p_PFSD_Exp <- rep(NA, n_cycle)

# First we make the probability of going from progression-free (F) to progressed to dead (D) blank (i.e. NA) for all the cycles in standard of care and all the cycles under the experimental strategy.

for(i in 1:n_cycle) {
  p_PFSD_SoC[i] <- 1 - NU_S_PD_SoC[i+1] / NU_S_PD_SoC[i]
  p_PFSD_Exp[i] <- 1 - S_PD_Exp[i+1] / S_PD_Exp[i]
}

# round(p_PFSD_SoC, digits=2)
# round(p_PFSD_Exp, digits=2)
# If I wanted to round I could apply the above, but my code already rounds my numbers.

# Then we generate our transition probability under standard of care and under the experimental treatement using survival functions that havent and have had the hazard ratio from above applied to them, respectively. [If we decide not to apply a hazard ratio for the experimental strategy going from progression to dead then neither may have a hazard ratio applied to them].


# The way this works is, you take next cycles probability of staying in this state, divide it by this cycles probability of staying in this state, and take it from 1 to get the probability of leaving this state. 

p_PFSD_SoC
```

```
##   [1] 0.004708 0.007310 0.008772 0.009881 0.010796 0.011585 0.012286 0.012919 0.013499
##  [10] 0.014036 0.014538 0.015009 0.015454 0.015876 0.016279 0.016663 0.017032 0.017387
##  [19] 0.017728 0.018058 0.018376 0.018685 0.018984 0.019275 0.019558 0.019834 0.020102
##  [28] 0.020364 0.020620 0.020870 0.021114 0.021353 0.021588 0.021817 0.022043 0.022264
##  [37] 0.022480 0.022694 0.022903 0.023109 0.023311 0.023510 0.023707 0.023900 0.024090
##  [46] 0.024277 0.024462 0.024644 0.024824 0.025001 0.025176 0.025349 0.025519 0.025687
##  [55] 0.025854 0.026018 0.026180 0.026341 0.026500 0.026656 0.026812 0.026965 0.027117
##  [64] 0.027267 0.027416 0.027563 0.027709 0.027853 0.027996 0.028138 0.028278 0.028417
##  [73] 0.028555 0.028691 0.028826 0.028960 0.029093 0.029225 0.029356 0.029485 0.029614
##  [82] 0.029741 0.029867 0.029993 0.030117 0.030241 0.030363 0.030485 0.030605 0.030725
##  [91] 0.030844 0.030962 0.031079 0.031195 0.031311 0.031426 0.031540 0.031653 0.031765
## [100] 0.031877 0.031988 0.032098 0.032207 0.032316 0.032424 0.032532 0.032638 0.032744
## [109] 0.032850 0.032955 0.033059 0.033162 0.033265 0.033368 0.033469 0.033570 0.033671
## [118] 0.033771 0.033870 0.033969 0.034068 0.034166 0.034263 0.034360 0.034456 0.034552
## [127] 0.034647 0.034742 0.034836 0.034930 0.035023 0.035116 0.035208 0.035300 0.035392
## [136] 0.035483 0.035573 0.035663 0.035753 0.035842 0.035931 0.036019 0.036107
```

```r
p_PFSD_Exp
```

```
##   [1] 0.003063 0.004757 0.005711 0.006434 0.007030 0.007546 0.008003 0.008417 0.008795
##  [10] 0.009146 0.009474 0.009782 0.010072 0.010349 0.010612 0.010863 0.011104 0.011336
##  [19] 0.011559 0.011775 0.011983 0.012185 0.012381 0.012572 0.012757 0.012937 0.013113
##  [28] 0.013284 0.013452 0.013615 0.013775 0.013932 0.014086 0.014236 0.014383 0.014528
##  [37] 0.014670 0.014810 0.014947 0.015082 0.015215 0.015345 0.015474 0.015600 0.015725
##  [46] 0.015848 0.015969 0.016089 0.016206 0.016323 0.016437 0.016551 0.016662 0.016773
##  [55] 0.016882 0.016990 0.017096 0.017201 0.017306 0.017408 0.017510 0.017611 0.017711
##  [64] 0.017809 0.017907 0.018004 0.018099 0.018194 0.018288 0.018381 0.018473 0.018564
##  [73] 0.018655 0.018744 0.018833 0.018921 0.019008 0.019095 0.019180 0.019266 0.019350
##  [82] 0.019434 0.019517 0.019599 0.019681 0.019762 0.019842 0.019922 0.020001 0.020080
##  [91] 0.020158 0.020236 0.020313 0.020389 0.020465 0.020541 0.020615 0.020690 0.020764
## [100] 0.020837 0.020910 0.020982 0.021054 0.021126 0.021197 0.021268 0.021338 0.021408
## [109] 0.021477 0.021546 0.021614 0.021682 0.021750 0.021817 0.021884 0.021951 0.022017
## [118] 0.022083 0.022148 0.022213 0.022278 0.022342 0.022406 0.022470 0.022534 0.022597
## [127] 0.022659 0.022722 0.022784 0.022845 0.022907 0.022968 0.023029 0.023089 0.023149
## [136] 0.023209 0.023269 0.023328 0.023387 0.023446 0.023504 0.023563 0.023621
```

```r
# Finally, now that I create transition probabilities from first-line treatment to death under SoC and the Exp treatment I can take them from the transition probabilities from first-line treatment to progression for SoC and Exp treatment, because the OS here from Angiopredict is transitioning from the first line treatment to dead, not from second line treatment to death, and once we get rid of the people who were leaving first line treatment to die in PFS, all we have left is people leaving first line treatment to progress. And then we can keep the first line treatment to death probabilities we've created from the OS curves to capture people who have left first line treatment to transition into death rather than second line treatment.

# p_PFSOS_SoC
# p_PFSD_SoC
# p_PFSOS_SoC <- p_PFSOS_SoC - p_PFSD_SoC
# p_PFSOS_SoC
# 
# p_PFSOS_Exp
# p_PFSD_Exp
# p_PFSOS_Exp <- p_PFSOS_Exp - p_PFSD_Exp
# p_PFSOS_Exp

# Actually, I decided not to do this, as then the curves I created wouldnt match the curves reported in the ANGIOPREDICT publication so exactly:


# Time-constant transition probabilities [ADVERSE EVENTS]:


# To create transition probabilities from exisiting probabilities in the literatre, etc., that come from longer time periods than my cycle lengths I can use the information in this email to Daniel:

# Inquiry re: Cost effectiveness analysis of pharmacokinetically-guided 5-fluorouracil in FOLFOX chemotherapy for metastatic colorectal cancer
# - https://outlook.office.com/mail/id/AAQkAGI5OWU0NTJkLTEzMjgtNGVhOS04ZGZiLWZkOGU1MDg3ZmE5MAAQAHQCBS2m%2B%2FVAjAc%2FWSCjQEQ%3D


# There may also be some relevant information in the below:


## Transition probabilities and hazard ratios


# "Note: To calculate the probability of dying from S1 and S2, use the hazard ratios provided. To do so, first convert the probability of dying from healthy, p_HD , to a rate; then multiply this rate by the appropriate hazard ratio; finally, convert this rate back to a probability. Recall that you can convert between rates and probabilities using the following formulas: r = − log(1 − p) and p = 1 − e ( − rt ) . The package darthtools also has the functions prob_to_rate and rate_to_prob that might be of use to you." per: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Cost-Effectiveness and Decision Modeling using R Workshop _ DARTH\August_25\3_cSTM - history dependence_material\Download exercise handout 

# ?rate_to_prob will tell you more about this function.
# ?prob_to_rate will tell you more about this function.

# You can see conversions from probabilities to rates here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Model Calibration in R\UNZIP to Working Directory_Calibration Participant Materials\ISPOR Calibration Participant Materials\SickSicker_MarkovModel_Function.R

# As will: Cost-Effectiveness and Decision Modeling using R Workshop _ DARTH - Live Session August 25th WITH CHAT

# The above also describes how to convert probabilities for different time scales, i.e., convert a probability for 5 years to 1 year, etc., and how to convert data that exists as a rate to a probability for use in a Markov model.







 # The below reflects the probability of going to death in the second line treatment, and I make the assumption that everyone gets the same second line treatment and give them the same probability after being under exp and under SoC to go from the second line therapy into dead.

P_OSD_SoC   <- 0.17 # Probability of dying when in OS.
P_OSD_Exp   <- 0.17 # Probability of dying when in OS.

# Base-Case: 0.17 Min: 0.12 Max:0.22 According to: Wen, F., Zheng, H., Wu, Y., Wheeler, J., Zeng, X., Fu, P., & Li, Q. (2016). Cost-effectiveness Analysis of Fluorouracil, Leucovorin, and Irinotecan versus Epirubicin, Cisplatin, and Capecitabine in Patients with Advanced Gastric Adenocarcinoma. Scientific reports, 6(1), 1-8. 



## Health State Values (AKA State rewards)
# Costs and utilities  
# Basically the outcomes we are interested in coming out of this model, so we'll look at the cohorts costs over the time horizon and the quality adjusted life years in our cohort over this time horizon.

# Costs

# The costs are a particularly important part of the model, because these are the only things that differ between countries. We make the assumption, per the literature and pragmatically (because we are examining 3 different countries at once in this model), that utilities and incidence of adverse events are generalisable across countries.

# So, the best way to deal with needing 3 different sets of costs, one for each country, is likely to create a concatanated vector, where the first set of entries refers to Ireland, the second set refers to Germany and the third set refers to Spain, then when we are building a diagram or doing some analysis in the model we can have c_F_SoC[1], c_F_Exp[1] and c_P[1], referring to Ireland, and so on for Spain[3] and Germany[2].

# Ireland[1]
# Germany[2]
#Spain[3]



# I pursued this avenue and it was too complicated, so instead I just define the parameters that vary in the Rmarkdown file that calls this file.

# Basically, what I do is set these parameters equal to the costs for the country I am interested in, in the Markdown file that calls this file, and then run this current file with the parameter names from the Rmarkdown file subbed in for costs and other country-specific values. Then I repeat this for each country I am interested in. 

c_PFS_Folfox <- c_PFS_Folfox 
c_PFS_Bevacizumab <- c_PFS_Bevacizumab  
c_OS_Folfiri <- c_OS_Folfiri  
administration_cost <- administration_cost  


c_F_SoC       <- administration_cost + c_PFS_Folfox  # cost of one cycle in PFS state under standard of care
c_F_Exp       <- administration_cost + c_PFS_Folfox + c_PFS_Bevacizumab # cost of one cycle in PFS state under the experimental treatment 
c_P       <- c_OS_Folfiri  + administration_cost# cost of one cycle in progression state (I assume in OS everyone gets the same treatment so it costs everyone the same to be treated).
c_D       <- 0     # cost of one cycle in dead state



# Above is the cost for each state, PFS, OS and dead,

# Then we define the utilities per health states.


u_F       <- 0.850     # utility when PFS 
u_P       <- 0.650   # utility when OS
u_D       <- 0     # utility when dead

# Discounting factors
d_c             <- 0.04                          
# discount rate for costs (per year)
d_e             <- 0.04                          
# discount rate for QALYs (per year)

# Discount weight (equal discounting is assumed for costs and effects):

# v_dwc <- 1 / (1 + d_c) ^ (0:n_cycle) 
# v_dwe <- 1 / (1 + d_e) ^ (0:n_cycle) 

# This was my initial discount weight vector, but, I've updated this and do this later on now 

p_PFSD_SoC
```

```
##   [1] 0.004708 0.007310 0.008772 0.009881 0.010796 0.011585 0.012286 0.012919 0.013499
##  [10] 0.014036 0.014538 0.015009 0.015454 0.015876 0.016279 0.016663 0.017032 0.017387
##  [19] 0.017728 0.018058 0.018376 0.018685 0.018984 0.019275 0.019558 0.019834 0.020102
##  [28] 0.020364 0.020620 0.020870 0.021114 0.021353 0.021588 0.021817 0.022043 0.022264
##  [37] 0.022480 0.022694 0.022903 0.023109 0.023311 0.023510 0.023707 0.023900 0.024090
##  [46] 0.024277 0.024462 0.024644 0.024824 0.025001 0.025176 0.025349 0.025519 0.025687
##  [55] 0.025854 0.026018 0.026180 0.026341 0.026500 0.026656 0.026812 0.026965 0.027117
##  [64] 0.027267 0.027416 0.027563 0.027709 0.027853 0.027996 0.028138 0.028278 0.028417
##  [73] 0.028555 0.028691 0.028826 0.028960 0.029093 0.029225 0.029356 0.029485 0.029614
##  [82] 0.029741 0.029867 0.029993 0.030117 0.030241 0.030363 0.030485 0.030605 0.030725
##  [91] 0.030844 0.030962 0.031079 0.031195 0.031311 0.031426 0.031540 0.031653 0.031765
## [100] 0.031877 0.031988 0.032098 0.032207 0.032316 0.032424 0.032532 0.032638 0.032744
## [109] 0.032850 0.032955 0.033059 0.033162 0.033265 0.033368 0.033469 0.033570 0.033671
## [118] 0.033771 0.033870 0.033969 0.034068 0.034166 0.034263 0.034360 0.034456 0.034552
## [127] 0.034647 0.034742 0.034836 0.034930 0.035023 0.035116 0.035208 0.035300 0.035392
## [136] 0.035483 0.035573 0.035663 0.035753 0.035842 0.035931 0.036019 0.036107
```

```r
p_PFSD_Exp
```

```
##   [1] 0.003063 0.004757 0.005711 0.006434 0.007030 0.007546 0.008003 0.008417 0.008795
##  [10] 0.009146 0.009474 0.009782 0.010072 0.010349 0.010612 0.010863 0.011104 0.011336
##  [19] 0.011559 0.011775 0.011983 0.012185 0.012381 0.012572 0.012757 0.012937 0.013113
##  [28] 0.013284 0.013452 0.013615 0.013775 0.013932 0.014086 0.014236 0.014383 0.014528
##  [37] 0.014670 0.014810 0.014947 0.015082 0.015215 0.015345 0.015474 0.015600 0.015725
##  [46] 0.015848 0.015969 0.016089 0.016206 0.016323 0.016437 0.016551 0.016662 0.016773
##  [55] 0.016882 0.016990 0.017096 0.017201 0.017306 0.017408 0.017510 0.017611 0.017711
##  [64] 0.017809 0.017907 0.018004 0.018099 0.018194 0.018288 0.018381 0.018473 0.018564
##  [73] 0.018655 0.018744 0.018833 0.018921 0.019008 0.019095 0.019180 0.019266 0.019350
##  [82] 0.019434 0.019517 0.019599 0.019681 0.019762 0.019842 0.019922 0.020001 0.020080
##  [91] 0.020158 0.020236 0.020313 0.020389 0.020465 0.020541 0.020615 0.020690 0.020764
## [100] 0.020837 0.020910 0.020982 0.021054 0.021126 0.021197 0.021268 0.021338 0.021408
## [109] 0.021477 0.021546 0.021614 0.021682 0.021750 0.021817 0.021884 0.021951 0.022017
## [118] 0.022083 0.022148 0.022213 0.022278 0.022342 0.022406 0.022470 0.022534 0.022597
## [127] 0.022659 0.022722 0.022784 0.022845 0.022907 0.022968 0.023029 0.023089 0.023149
## [136] 0.023209 0.023269 0.023328 0.023387 0.023446 0.023504 0.023563 0.023621
```

```r
p_PFSOS_SoC
```

```
##   [1] 0.01485 0.02400 0.02932 0.03341 0.03681 0.03977 0.04240 0.04479 0.04699 0.04903
##  [11] 0.05095 0.05274 0.05445 0.05607 0.05761 0.05909 0.06051 0.06188 0.06320 0.06447
##  [21] 0.06570 0.06690 0.06806 0.06919 0.07028 0.07135 0.07240 0.07341 0.07441 0.07538
##  [31] 0.07633 0.07727 0.07818 0.07908 0.07995 0.08082 0.08166 0.08250 0.08331 0.08412
##  [41] 0.08491 0.08569 0.08646 0.08721 0.08796 0.08869 0.08941 0.09013 0.09083 0.09153
##  [51] 0.09221 0.09289 0.09356 0.09422 0.09487 0.09552 0.09615 0.09678 0.09741 0.09802
##  [61] 0.09863 0.09923 0.09983 0.10042 0.10100 0.10158 0.10216 0.10272 0.10328 0.10384
##  [71] 0.10439 0.10494 0.10548 0.10602 0.10655 0.10707 0.10760 0.10811 0.10863 0.10914
##  [81] 0.10964 0.11014 0.11064 0.11113 0.11162 0.11211 0.11259 0.11307 0.11354 0.11401
##  [91] 0.11448 0.11495 0.11541 0.11587 0.11632 0.11677 0.11722 0.11766 0.11811 0.11855
## [101] 0.11898 0.11942 0.11985 0.12028 0.12070 0.12112 0.12154 0.12196 0.12238 0.12279
## [111] 0.12320 0.12361 0.12401 0.12441 0.12481 0.12521 0.12561 0.12600 0.12639 0.12678
## [121] 0.12717 0.12755 0.12794 0.12832 0.12869 0.12907 0.12945 0.12982 0.13019 0.13056
## [131] 0.13093 0.13129 0.13165 0.13202 0.13238 0.13273 0.13309 0.13344 0.13380 0.13415
## [141] 0.13450 0.13484 0.13519
```

```r
p_PFSOS_Exp
```

```
##   [1] 0.01012 0.01638 0.02003 0.02284 0.02518 0.02722 0.02903 0.03068 0.03220 0.03361
##  [11] 0.03493 0.03618 0.03735 0.03848 0.03955 0.04057 0.04156 0.04251 0.04342 0.04430
##  [21] 0.04516 0.04599 0.04680 0.04758 0.04835 0.04909 0.04982 0.05053 0.05122 0.05190
##  [31] 0.05256 0.05321 0.05385 0.05448 0.05509 0.05569 0.05628 0.05687 0.05744 0.05800
##  [41] 0.05855 0.05910 0.05964 0.06017 0.06069 0.06120 0.06171 0.06221 0.06270 0.06319
##  [51] 0.06367 0.06414 0.06461 0.06508 0.06553 0.06599 0.06643 0.06688 0.06731 0.06775
##  [61] 0.06818 0.06860 0.06902 0.06943 0.06985 0.07025 0.07066 0.07105 0.07145 0.07184
##  [71] 0.07223 0.07261 0.07300 0.07337 0.07375 0.07412 0.07449 0.07485 0.07522 0.07558
##  [81] 0.07593 0.07629 0.07664 0.07699 0.07733 0.07767 0.07801 0.07835 0.07869 0.07902
##  [91] 0.07935 0.07968 0.08001 0.08033 0.08065 0.08097 0.08129 0.08160 0.08192 0.08223
## [101] 0.08254 0.08284 0.08315 0.08345 0.08375 0.08405 0.08435 0.08465 0.08494 0.08523
## [111] 0.08552 0.08581 0.08610 0.08638 0.08667 0.08695 0.08723 0.08751 0.08779 0.08807
## [121] 0.08834 0.08861 0.08889 0.08916 0.08942 0.08969 0.08996 0.09022 0.09049 0.09075
## [131] 0.09101 0.09127 0.09153 0.09179 0.09204 0.09230 0.09255 0.09280 0.09305 0.09330
## [141] 0.09355 0.09380 0.09405
```


```r
#Draw the state-transition cohort model

diag_names_states  <- c("PFS", "OS", "Dead")

m_P_diag <- matrix(0, nrow = n_states, ncol = n_states, dimnames = list(diag_names_states, diag_names_states))

m_P_diag["PFS", "PFS" ]  = ""
m_P_diag["PFS", "OS" ]     = ""
m_P_diag["PFS", "Dead" ]     = ""
m_P_diag["OS", "OS" ]     = ""
m_P_diag["OS", "Dead" ]     = ""
m_P_diag["Dead", "Dead" ]     = ""
layout.fig <- c(2, 1) # <- changing the numbers here changes the diagram layout, so mess with these until I'm happy. It basically decides how many bubbles will be on each level, so here 1 bubble, followed by 3 bubbles, followed by 2 bubbles, per the diagram for 1, 3, 2.
plotmat(t(m_P_diag), t(layout.fig), self.cex = 0.5, curve = 0, arr.pos = 0.76,
        latex = T, arr.type = "curved", relsize = 0.85, box.prop = 0.9,
        cex = 0.8, box.cex = 0.7, lwd = 0.6, main = "Figure 1")
```

<img src="Markov_3state_files/figure-html/unnamed-chunk-20-1.png" width="672" />

```r
#ggsave("Markov_Model_Diagram.png", width = 4, height = 4, dpi=300)
#while (!is.null(dev.list()))  dev.off()
#png(paste("Markov_Model_Diagram", ".png"))
#dev.off()
```


```r
#04 Define and initialize matrices and vectors

#04.1 Cohort trace


# After setting up our parameters above, we initialise our structure below.

# This is where we will store all of the model output, and all the things that we need to track over time as we are simulating the progression of this cohort through this disease process.

# WHEN COMING BACK TO COMPARE: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\R Code\Parametric Survival Analysis\ISPOR WEBINAR Health Economic Modelling in R\ISPOR_webinar_R-master\ISPOR_webinar_R-master\oncologySemiMarkov_illustration to the DARTH Rmarkdown document, a big difference is that DARTH creates a cycle 0 - whereas the comparison from the ISPOR_webinar_R uses -1 to get into cycle 0 where necessary. I have decided to follow the ISPOR way, because I am interested in learning from their parametric analysis, so I need to bear this difference in mind as I go through this document.

# Markov cohort trace matrix ----

# Initialize matrices to store the Markov cohort traces for each strategy

# - note that the number of rows is n_cycle + 1, because R doesn't use index 0 (i.e. cycle 0)  --> What we mean here, is that when we do our calculations later they need to be for cycle-1 to reflect cycle 0.
m_M_SoC <- m_M_Exp  <-  matrix(
  data = NA, 
  nrow = n_cycle,  
  ncol = n_states, 
  dimnames = list(paste('Cycle', 1:n_cycle), v_names_states)
)

## Initial state vector
# We create an inital vector where people start, with everyone (1 = 100% of people) starting in PFS below:
# v_s_init <- c("PFS" = 1, "OS" = 0, "Dead" = 0)
# v_s_init

# There are cases where you can have an initial illness prevalence, so you would start some people in the sick state and some people in the healthy state, but above we're looking at people with mCRC, so we'll start everyone in PFS.


## Initialize cohort trace for cSTM (cohort state transition model) for all strategies (the strategies are the treatment strategies SOC and Exp).
# So, basically we are creating a matrix to trace how the cohort is distributed across the health states, over time. 

# A matrix is necessary because there are basically two dimensions to this, the number of time cycles, which will be our rows, and then the number of states - to know which proportion of our cohort is in each state at each time:

# m_M_SoC <- matrix(0, 
#                   nrow = (n_cycles + 1), ncol = n_states, 
#                   dimnames = list(v_names_cycles, v_names_states))
# In the above code from DARTH instead of having to bother with -1 throughout the analysis they create a cycle 0.
# Then they store the initial state vector in the first row of the cohort trace
# m_M_SoC[1, ] <- v_s_init
## Initialize cohort traces
## So, above they make the cohort trace for standard of care
# This gives them a matrix to can fill in with the simulations of how patients transitions between health states under treatment.



# Back to my code, in the first row of the markov matrix [1, ] put the value at the far end, i.e. "<-1" and "<-0" under the colum "PFS" [ , "PFS"], repeating this for "OS", and "Dead":


# Specifying the initial state for the cohorts (all patients start in PFS)
m_M_SoC[1, "PFS"] <- m_M_Exp[1, "PFS"] <- 1
m_M_SoC[1, "OS"]  <- m_M_Exp[1, "OS"]  <- 0
m_M_SoC[1, "Dead"]<- m_M_Exp[1, "Dead"]  <- 0

# Inspect whether properly defined
head(m_M_SoC)
```

```
##         PFS OS Dead
## Cycle 1   1  0    0
## Cycle 2  NA NA   NA
## Cycle 3  NA NA   NA
## Cycle 4  NA NA   NA
## Cycle 5  NA NA   NA
## Cycle 6  NA NA   NA
```

```r
head(m_M_Exp)
```

```
##         PFS OS Dead
## Cycle 1   1  0    0
## Cycle 2  NA NA   NA
## Cycle 3  NA NA   NA
## Cycle 4  NA NA   NA
## Cycle 5  NA NA   NA
## Cycle 6  NA NA   NA
```


```r
# 04.2 Transition probability matrix

## If there were time varying transition probabilities, i.e. the longer you are in the model there are changes in your transition probability into death as you get older, etc., you would build a transition probability array, rather than a transition probability matrix, per: 

# 04.2 of:

# "C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modeling for Public Health_DARTH\5_Nov_29\4_Cohort state-transition models (cSTM) - time-dependent models_material\Markov_3state_time"

# with: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Cost-Effectiveness and Decision Modeling using R Workshop _ DARTH\August_24\Live Session


## Initialize transition probability matrix, [i.e. build the framework or empty scaffolding of the transition probability matrix]
# all transitions to a non-death state are assumed to be conditional on survival
# - starting with standard of care
# - note that these are now 3-dimensional matrices because we are including time.
 
# The DARTH approach would be something like:
# m_P_SoC  <- matrix(0,
#                    nrow = n_states, ncol = n_states,
#                    dimnames = list(v_names_states, v_names_states)) # define row and column names
# m_P_SoC


# Our approach to initialize matrices for the transition probabilities
# - note that these are now 3-dimensional matrices (so, above we originally included dim = nrow and ncol, but now we also include n_cycle - i.e. the number of cycles).
# - starting with standard of care
m_P_SoC <- array(
  data = 0,
  dim = c(n_states, n_states, n_cycle),
  dimnames = list(v_names_states, v_names_states, paste0("Cycle", 1:n_cycle))
  # define row and column names - then name each array after which cycle it's for, i.e. cycle 1 all the way through to cycle 143. So Cycle 1 will have all of our patients in PFS, while cycle 143 will have most people in the dead state.
)

head(m_P_SoC)
```

```
## , , Cycle1
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle2
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle3
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle4
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle5
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle6
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle7
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle8
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle9
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle10
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle11
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle12
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle13
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle14
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle15
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle16
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle17
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle18
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle19
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle20
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle21
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle22
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle23
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle24
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle25
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle26
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle27
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle28
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle29
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle30
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle31
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle32
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle33
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle34
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle35
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle36
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle37
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle38
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle39
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle40
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle41
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle42
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle43
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle44
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle45
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle46
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle47
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle48
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle49
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle50
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle51
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle52
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle53
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle54
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle55
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle56
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle57
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle58
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle59
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle60
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle61
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle62
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle63
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle64
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle65
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle66
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle67
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle68
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle69
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle70
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle71
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle72
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle73
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle74
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle75
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle76
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle77
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle78
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle79
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle80
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle81
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle82
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle83
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle84
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle85
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle86
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle87
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle88
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle89
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle90
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle91
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle92
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle93
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle94
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle95
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle96
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle97
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle98
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle99
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle100
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle101
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle102
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle103
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle104
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle105
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle106
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle107
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle108
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle109
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle110
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle111
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
##  [ reached getOption("max.print") -- omitted 32 matrix slice(s) ]
```

```r
m_P_Exp <- array(
  data = 0,
  dim = c(n_states, n_states, n_cycle),
  dimnames = list(v_names_states, v_names_states, paste0("Cycle", 1:n_cycle))
  # define row and column names - then name each array after which cycle it's for, i.e. cycle 1 all the way through to cycle 143. So Cycle 1 will have all of our patients in PFS, while cycle 143 will have most people in the dead state.
)

head(m_P_Exp)
```

```
## , , Cycle1
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle2
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle3
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle4
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle5
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle6
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle7
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle8
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle9
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle10
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle11
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle12
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle13
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle14
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle15
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle16
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle17
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle18
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle19
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle20
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle21
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle22
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle23
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle24
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle25
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle26
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle27
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle28
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle29
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle30
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle31
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle32
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle33
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle34
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle35
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle36
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle37
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle38
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle39
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle40
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle41
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle42
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle43
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle44
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle45
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle46
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle47
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle48
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle49
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle50
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle51
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle52
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle53
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle54
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle55
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle56
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle57
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle58
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle59
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle60
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle61
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle62
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle63
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle64
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle65
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle66
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle67
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle68
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle69
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle70
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle71
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle72
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle73
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle74
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle75
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle76
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle77
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle78
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle79
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle80
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle81
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle82
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle83
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle84
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle85
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle86
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle87
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle88
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle89
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle90
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle91
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle92
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle93
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle94
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle95
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle96
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle97
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle98
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle99
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle100
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle101
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle102
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle103
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle104
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle105
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle106
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle107
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle108
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle109
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle110
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
## , , Cycle111
## 
##      PFS OS Dead
## PFS    0  0    0
## OS     0  0    0
## Dead   0  0    0
## 
##  [ reached getOption("max.print") -- omitted 32 matrix slice(s) ]
```


```r
# 04.3 Fill in the transition probability matrix:

# Setting the transition probabilities from PFS based on the model parameters
  # So, when individuals are in PFS what are their probabilities of going into the other states that they can enter from PFS?

m_P_SoC["PFS", "PFS",]<- (1 -p_PFSOS_SoC) * (1 - p_PFSD_SoC)
m_P_SoC["PFS", "OS",]<- p_PFSOS_SoC*(1 - p_PFSD_SoC)
m_P_SoC["PFS", "Dead",]<-p_PFSD_SoC

# Setting the transition probabilities from OS
m_P_SoC["OS", "OS", ] <- 1 - P_OSD_SoC
m_P_SoC["OS", "Dead", ]        <- P_OSD_SoC


# Setting the transition probabilities from Dead
m_P_SoC["Dead", "Dead", ] <- 1


m_P_SoC
```

```
## , , Cycle1
## 
##         PFS      OS     Dead
## PFS  0.9805 0.01478 0.004708
## OS   0.0000 0.83000 0.170000
## Dead 0.0000 0.00000 1.000000
## 
## , , Cycle2
## 
##         PFS      OS    Dead
## PFS  0.9689 0.02382 0.00731
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle3
## 
##         PFS      OS     Dead
## PFS  0.9622 0.02906 0.008772
## OS   0.0000 0.83000 0.170000
## Dead 0.0000 0.00000 1.000000
## 
## , , Cycle4
## 
##        PFS      OS     Dead
## PFS  0.957 0.03308 0.009881
## OS   0.000 0.83000 0.170000
## Dead 0.000 0.00000 1.000000
## 
## , , Cycle5
## 
##         PFS      OS   Dead
## PFS  0.9528 0.03641 0.0108
## OS   0.0000 0.83000 0.1700
## Dead 0.0000 0.00000 1.0000
## 
## , , Cycle6
## 
##         PFS      OS    Dead
## PFS  0.9491 0.03931 0.01159
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle7
## 
##         PFS      OS    Dead
## PFS  0.9458 0.04188 0.01229
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle8
## 
##         PFS      OS    Dead
## PFS  0.9429 0.04421 0.01292
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle9
## 
##         PFS      OS   Dead
## PFS  0.9401 0.04636 0.0135
## OS   0.0000 0.83000 0.1700
## Dead 0.0000 0.00000 1.0000
## 
## , , Cycle10
## 
##         PFS      OS    Dead
## PFS  0.9376 0.04835 0.01404
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle11
## 
##         PFS     OS    Dead
## PFS  0.9353 0.0502 0.01454
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle12
## 
##        PFS      OS    Dead
## PFS  0.933 0.05195 0.01501
## OS   0.000 0.83000 0.17000
## Dead 0.000 0.00000 1.00000
## 
## , , Cycle13
## 
##         PFS      OS    Dead
## PFS  0.9309 0.05361 0.01545
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle14
## 
##         PFS      OS    Dead
## PFS  0.9289 0.05518 0.01588
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle15
## 
##        PFS      OS    Dead
## PFS  0.927 0.05667 0.01628
## OS   0.000 0.83000 0.17000
## Dead 0.000 0.00000 1.00000
## 
## , , Cycle16
## 
##         PFS      OS    Dead
## PFS  0.9252 0.05811 0.01666
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle17
## 
##         PFS      OS    Dead
## PFS  0.9235 0.05948 0.01703
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle18
## 
##         PFS     OS    Dead
## PFS  0.9218 0.0608 0.01739
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle19
## 
##         PFS      OS    Dead
## PFS  0.9202 0.06208 0.01773
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle20
## 
##         PFS      OS    Dead
## PFS  0.9186 0.06331 0.01806
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle21
## 
##         PFS      OS    Dead
## PFS  0.9171 0.06449 0.01838
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle22
## 
##         PFS      OS    Dead
## PFS  0.9157 0.06565 0.01869
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle23
## 
##         PFS      OS    Dead
## PFS  0.9143 0.06677 0.01898
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle24
## 
##         PFS      OS    Dead
## PFS  0.9129 0.06785 0.01928
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle25
## 
##         PFS      OS    Dead
## PFS  0.9115 0.06891 0.01956
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle26
## 
##         PFS      OS    Dead
## PFS  0.9102 0.06994 0.01983
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle27
## 
##        PFS      OS   Dead
## PFS  0.909 0.07094 0.0201
## OS   0.000 0.83000 0.1700
## Dead 0.000 0.00000 1.0000
## 
## , , Cycle28
## 
##         PFS      OS    Dead
## PFS  0.9077 0.07192 0.02036
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle29
## 
##         PFS      OS    Dead
## PFS  0.9065 0.07287 0.02062
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle30
## 
##         PFS      OS    Dead
## PFS  0.9053 0.07381 0.02087
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle31
## 
##         PFS      OS    Dead
## PFS  0.9042 0.07472 0.02111
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle32
## 
##        PFS      OS    Dead
## PFS  0.903 0.07562 0.02135
## OS   0.000 0.83000 0.17000
## Dead 0.000 0.00000 1.00000
## 
## , , Cycle33
## 
##         PFS      OS    Dead
## PFS  0.9019 0.07649 0.02159
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle34
## 
##         PFS      OS    Dead
## PFS  0.9008 0.07735 0.02182
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle35
## 
##         PFS      OS    Dead
## PFS  0.8998 0.07819 0.02204
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle36
## 
##         PFS      OS    Dead
## PFS  0.8987 0.07902 0.02226
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle37
## 
##         PFS      OS    Dead
## PFS  0.8977 0.07983 0.02248
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle38
## 
##         PFS      OS    Dead
## PFS  0.8967 0.08062 0.02269
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle39
## 
##         PFS      OS   Dead
## PFS  0.8957 0.08141 0.0229
## OS   0.0000 0.83000 0.1700
## Dead 0.0000 0.00000 1.0000
## 
## , , Cycle40
## 
##         PFS      OS    Dead
## PFS  0.8947 0.08218 0.02311
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle41
## 
##         PFS      OS    Dead
## PFS  0.8938 0.08293 0.02331
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle42
## 
##         PFS      OS    Dead
## PFS  0.8928 0.08368 0.02351
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle43
## 
##         PFS      OS    Dead
## PFS  0.8919 0.08441 0.02371
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle44
## 
##        PFS      OS   Dead
## PFS  0.891 0.08513 0.0239
## OS   0.000 0.83000 0.1700
## Dead 0.000 0.00000 1.0000
## 
## , , Cycle45
## 
##         PFS      OS    Dead
## PFS  0.8901 0.08584 0.02409
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle46
## 
##         PFS      OS    Dead
## PFS  0.8892 0.08654 0.02428
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle47
## 
##         PFS      OS    Dead
## PFS  0.8883 0.08723 0.02446
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle48
## 
##         PFS      OS    Dead
## PFS  0.8874 0.08791 0.02464
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle49
## 
##         PFS      OS    Dead
## PFS  0.8866 0.08858 0.02482
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle50
## 
##         PFS      OS  Dead
## PFS  0.8858 0.08924 0.025
## OS   0.0000 0.83000 0.170
## Dead 0.0000 0.00000 1.000
## 
## , , Cycle51
## 
##         PFS      OS    Dead
## PFS  0.8849 0.08989 0.02518
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle52
## 
##         PFS      OS    Dead
## PFS  0.8841 0.09054 0.02535
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle53
## 
##         PFS      OS    Dead
## PFS  0.8833 0.09117 0.02552
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle54
## 
##         PFS     OS    Dead
## PFS  0.8825 0.0918 0.02569
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle55
## 
##         PFS      OS    Dead
## PFS  0.8817 0.09242 0.02585
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle56
## 
##        PFS      OS    Dead
## PFS  0.881 0.09303 0.02602
## OS   0.000 0.83000 0.17000
## Dead 0.000 0.00000 1.00000
## 
## , , Cycle57
## 
##         PFS      OS    Dead
## PFS  0.8802 0.09364 0.02618
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle58
## 
##         PFS      OS    Dead
## PFS  0.8794 0.09423 0.02634
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle59
## 
##         PFS      OS   Dead
## PFS  0.8787 0.09482 0.0265
## OS   0.0000 0.83000 0.1700
## Dead 0.0000 0.00000 1.0000
## 
## , , Cycle60
## 
##         PFS      OS    Dead
## PFS  0.8779 0.09541 0.02666
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle61
## 
##         PFS      OS    Dead
## PFS  0.8772 0.09599 0.02681
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle62
## 
##         PFS      OS    Dead
## PFS  0.8765 0.09656 0.02697
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle63
## 
##         PFS      OS    Dead
## PFS  0.8758 0.09712 0.02712
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle64
## 
##         PFS      OS    Dead
## PFS  0.8751 0.09768 0.02727
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle65
## 
##         PFS      OS    Dead
## PFS  0.8743 0.09824 0.02742
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle66
## 
##         PFS      OS    Dead
## PFS  0.8737 0.09878 0.02756
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle67
## 
##        PFS      OS    Dead
## PFS  0.873 0.09932 0.02771
## OS   0.000 0.83000 0.17000
## Dead 0.000 0.00000 1.00000
## 
## , , Cycle68
## 
##         PFS      OS    Dead
## PFS  0.8723 0.09986 0.02785
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle69
## 
##         PFS     OS  Dead
## PFS  0.8716 0.1004 0.028
## OS   0.0000 0.8300 0.170
## Dead 0.0000 0.0000 1.000
## 
## , , Cycle70
## 
##         PFS     OS    Dead
## PFS  0.8709 0.1009 0.02814
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle71
## 
##         PFS     OS    Dead
## PFS  0.8703 0.1014 0.02828
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle72
## 
##         PFS    OS    Dead
## PFS  0.8696 0.102 0.02842
## OS   0.0000 0.830 0.17000
## Dead 0.0000 0.000 1.00000
## 
## , , Cycle73
## 
##        PFS     OS    Dead
## PFS  0.869 0.1025 0.02855
## OS   0.000 0.8300 0.17000
## Dead 0.000 0.0000 1.00000
## 
## , , Cycle74
## 
##         PFS    OS    Dead
## PFS  0.8683 0.103 0.02869
## OS   0.0000 0.830 0.17000
## Dead 0.0000 0.000 1.00000
## 
## , , Cycle75
## 
##         PFS     OS    Dead
## PFS  0.8677 0.1035 0.02883
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle76
## 
##         PFS    OS    Dead
## PFS  0.8671 0.104 0.02896
## OS   0.0000 0.830 0.17000
## Dead 0.0000 0.000 1.00000
## 
## , , Cycle77
## 
##         PFS     OS    Dead
## PFS  0.8664 0.1045 0.02909
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle78
## 
##         PFS    OS    Dead
## PFS  0.8658 0.105 0.02922
## OS   0.0000 0.830 0.17000
## Dead 0.0000 0.000 1.00000
## 
## , , Cycle79
## 
##         PFS     OS    Dead
## PFS  0.8652 0.1054 0.02936
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle80
## 
##         PFS     OS    Dead
## PFS  0.8646 0.1059 0.02949
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle81
## 
##        PFS     OS    Dead
## PFS  0.864 0.1064 0.02961
## OS   0.000 0.8300 0.17000
## Dead 0.000 0.0000 1.00000
## 
## , , Cycle82
## 
##         PFS     OS    Dead
## PFS  0.8634 0.1069 0.02974
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle83
## 
##         PFS     OS    Dead
## PFS  0.8628 0.1073 0.02987
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle84
## 
##         PFS     OS    Dead
## PFS  0.8622 0.1078 0.02999
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle85
## 
##         PFS     OS    Dead
## PFS  0.8616 0.1083 0.03012
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle86
## 
##        PFS     OS    Dead
## PFS  0.861 0.1087 0.03024
## OS   0.000 0.8300 0.17000
## Dead 0.000 0.0000 1.00000
## 
## , , Cycle87
## 
##         PFS     OS    Dead
## PFS  0.8605 0.1092 0.03036
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle88
## 
##         PFS     OS    Dead
## PFS  0.8599 0.1096 0.03048
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle89
## 
##         PFS     OS    Dead
## PFS  0.8593 0.1101 0.03061
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle90
## 
##         PFS     OS    Dead
## PFS  0.8588 0.1105 0.03072
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle91
## 
##         PFS    OS    Dead
## PFS  0.8582 0.111 0.03084
## OS   0.0000 0.830 0.17000
## Dead 0.0000 0.000 1.00000
## 
## , , Cycle92
## 
##         PFS     OS    Dead
## PFS  0.8577 0.1114 0.03096
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle93
## 
##         PFS     OS    Dead
## PFS  0.8571 0.1118 0.03108
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle94
## 
##         PFS     OS   Dead
## PFS  0.8566 0.1123 0.0312
## OS   0.0000 0.8300 0.1700
## Dead 0.0000 0.0000 1.0000
## 
## , , Cycle95
## 
##        PFS     OS    Dead
## PFS  0.856 0.1127 0.03131
## OS   0.000 0.8300 0.17000
## Dead 0.000 0.0000 1.00000
## 
## , , Cycle96
## 
##         PFS     OS    Dead
## PFS  0.8555 0.1131 0.03143
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle97
## 
##         PFS     OS    Dead
## PFS  0.8549 0.1135 0.03154
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle98
## 
##         PFS     OS    Dead
## PFS  0.8544 0.1139 0.03165
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle99
## 
##         PFS     OS    Dead
## PFS  0.8539 0.1144 0.03177
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle100
## 
##         PFS     OS    Dead
## PFS  0.8534 0.1148 0.03188
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle101
## 
##         PFS     OS    Dead
## PFS  0.8528 0.1152 0.03199
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle102
## 
##         PFS     OS   Dead
## PFS  0.8523 0.1156 0.0321
## OS   0.0000 0.8300 0.1700
## Dead 0.0000 0.0000 1.0000
## 
## , , Cycle103
## 
##         PFS    OS    Dead
## PFS  0.8518 0.116 0.03221
## OS   0.0000 0.830 0.17000
## Dead 0.0000 0.000 1.00000
## 
## , , Cycle104
## 
##         PFS     OS    Dead
## PFS  0.8513 0.1164 0.03232
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle105
## 
##         PFS     OS    Dead
## PFS  0.8508 0.1168 0.03242
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle106
## 
##         PFS     OS    Dead
## PFS  0.8503 0.1172 0.03253
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle107
## 
##         PFS     OS    Dead
## PFS  0.8498 0.1176 0.03264
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle108
## 
##         PFS    OS    Dead
## PFS  0.8493 0.118 0.03274
## OS   0.0000 0.830 0.17000
## Dead 0.0000 0.000 1.00000
## 
## , , Cycle109
## 
##         PFS     OS    Dead
## PFS  0.8488 0.1184 0.03285
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle110
## 
##         PFS     OS    Dead
## PFS  0.8483 0.1187 0.03295
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle111
## 
##         PFS     OS    Dead
## PFS  0.8478 0.1191 0.03306
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
##  [ reached getOption("max.print") -- omitted 32 matrix slice(s) ]
```

```r
# Using the transition probabilities for standard of care as basis, I update the transition probabilities that are different for the experimental strategy


# Setting the transition probabilities the experimental strategy
m_P_Exp["PFS", "PFS",]<- (1 -p_PFSOS_Exp) * (1 - p_PFSD_Exp)
m_P_Exp["PFS", "OS",]<- p_PFSOS_Exp*(1 - p_PFSD_Exp)
m_P_Exp["PFS", "Dead",]<-p_PFSD_Exp

# Setting the transition probabilities from OS
m_P_Exp["OS", "OS", ] <- 1 - P_OSD_Exp
m_P_Exp["OS", "Dead", ]        <- P_OSD_Exp

# Setting the transition probabilities from Dead
m_P_Exp["Dead", "Dead", ] <- 1

m_P_Exp
```

```
## , , Cycle1
## 
##         PFS      OS     Dead
## PFS  0.9868 0.01009 0.003063
## OS   0.0000 0.83000 0.170000
## Dead 0.0000 0.00000 1.000000
## 
## , , Cycle2
## 
##         PFS     OS     Dead
## PFS  0.9789 0.0163 0.004757
## OS   0.0000 0.8300 0.170000
## Dead 0.0000 0.0000 1.000000
## 
## , , Cycle3
## 
##         PFS      OS     Dead
## PFS  0.9744 0.01992 0.005711
## OS   0.0000 0.83000 0.170000
## Dead 0.0000 0.00000 1.000000
## 
## , , Cycle4
## 
##         PFS      OS     Dead
## PFS  0.9709 0.02269 0.006434
## OS   0.0000 0.83000 0.170000
## Dead 0.0000 0.00000 1.000000
## 
## , , Cycle5
## 
##        PFS    OS    Dead
## PFS  0.968 0.025 0.00703
## OS   0.000 0.830 0.17000
## Dead 0.000 0.000 1.00000
## 
## , , Cycle6
## 
##         PFS      OS     Dead
## PFS  0.9654 0.02701 0.007546
## OS   0.0000 0.83000 0.170000
## Dead 0.0000 0.00000 1.000000
## 
## , , Cycle7
## 
##         PFS     OS     Dead
## PFS  0.9632 0.0288 0.008003
## OS   0.0000 0.8300 0.170000
## Dead 0.0000 0.0000 1.000000
## 
## , , Cycle8
## 
##         PFS      OS     Dead
## PFS  0.9612 0.03042 0.008417
## OS   0.0000 0.83000 0.170000
## Dead 0.0000 0.00000 1.000000
## 
## , , Cycle9
## 
##         PFS      OS     Dead
## PFS  0.9593 0.03192 0.008795
## OS   0.0000 0.83000 0.170000
## Dead 0.0000 0.00000 1.000000
## 
## , , Cycle10
## 
##         PFS     OS     Dead
## PFS  0.9576 0.0333 0.009146
## OS   0.0000 0.8300 0.170000
## Dead 0.0000 0.0000 1.000000
## 
## , , Cycle11
## 
##         PFS     OS     Dead
## PFS  0.9559 0.0346 0.009474
## OS   0.0000 0.8300 0.170000
## Dead 0.0000 0.0000 1.000000
## 
## , , Cycle12
## 
##         PFS      OS     Dead
## PFS  0.9544 0.03582 0.009782
## OS   0.0000 0.83000 0.170000
## Dead 0.0000 0.00000 1.000000
## 
## , , Cycle13
## 
##         PFS      OS    Dead
## PFS  0.9529 0.03698 0.01007
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle14
## 
##         PFS      OS    Dead
## PFS  0.9516 0.03808 0.01035
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle15
## 
##         PFS      OS    Dead
## PFS  0.9503 0.03913 0.01061
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle16
## 
##        PFS      OS    Dead
## PFS  0.949 0.04013 0.01086
## OS   0.000 0.83000 0.17000
## Dead 0.000 0.00000 1.00000
## 
## , , Cycle17
## 
##         PFS     OS   Dead
## PFS  0.9478 0.0411 0.0111
## OS   0.0000 0.8300 0.1700
## Dead 0.0000 0.0000 1.0000
## 
## , , Cycle18
## 
##         PFS      OS    Dead
## PFS  0.9466 0.04202 0.01134
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle19
## 
##         PFS      OS    Dead
## PFS  0.9455 0.04292 0.01156
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle20
## 
##         PFS      OS    Dead
## PFS  0.9444 0.04378 0.01177
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle21
## 
##         PFS      OS    Dead
## PFS  0.9434 0.04462 0.01198
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle22
## 
##         PFS      OS    Dead
## PFS  0.9424 0.04543 0.01219
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle23
## 
##         PFS      OS    Dead
## PFS  0.9414 0.04622 0.01238
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle24
## 
##         PFS      OS    Dead
## PFS  0.9404 0.04699 0.01257
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle25
## 
##         PFS      OS    Dead
## PFS  0.9395 0.04773 0.01276
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle26
## 
##         PFS      OS    Dead
## PFS  0.9386 0.04846 0.01294
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle27
## 
##         PFS      OS    Dead
## PFS  0.9377 0.04916 0.01311
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle28
## 
##         PFS      OS    Dead
## PFS  0.9369 0.04986 0.01328
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle29
## 
##        PFS      OS    Dead
## PFS  0.936 0.05053 0.01345
## OS   0.000 0.83000 0.17000
## Dead 0.000 0.00000 1.00000
## 
## , , Cycle30
## 
##         PFS      OS    Dead
## PFS  0.9352 0.05119 0.01362
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle31
## 
##         PFS      OS    Dead
## PFS  0.9344 0.05184 0.01378
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle32
## 
##         PFS      OS    Dead
## PFS  0.9336 0.05247 0.01393
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle33
## 
##         PFS      OS    Dead
## PFS  0.9328 0.05309 0.01409
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle34
## 
##         PFS     OS    Dead
## PFS  0.9321 0.0537 0.01424
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle35
## 
##         PFS     OS    Dead
## PFS  0.9313 0.0543 0.01438
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle36
## 
##         PFS      OS    Dead
## PFS  0.9306 0.05488 0.01453
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle37
## 
##         PFS      OS    Dead
## PFS  0.9299 0.05546 0.01467
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle38
## 
##         PFS      OS    Dead
## PFS  0.9292 0.05602 0.01481
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle39
## 
##         PFS      OS    Dead
## PFS  0.9285 0.05658 0.01495
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle40
## 
##         PFS      OS    Dead
## PFS  0.9278 0.05713 0.01508
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle41
## 
##         PFS      OS    Dead
## PFS  0.9271 0.05766 0.01521
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle42
## 
##         PFS      OS    Dead
## PFS  0.9265 0.05819 0.01535
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle43
## 
##         PFS      OS    Dead
## PFS  0.9258 0.05871 0.01547
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle44
## 
##         PFS      OS   Dead
## PFS  0.9252 0.05923 0.0156
## OS   0.0000 0.83000 0.1700
## Dead 0.0000 0.00000 1.0000
## 
## , , Cycle45
## 
##         PFS      OS    Dead
## PFS  0.9245 0.05973 0.01573
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle46
## 
##         PFS      OS    Dead
## PFS  0.9239 0.06023 0.01585
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle47
## 
##         PFS      OS    Dead
## PFS  0.9233 0.06072 0.01597
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle48
## 
##         PFS      OS    Dead
## PFS  0.9227 0.06121 0.01609
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle49
## 
##         PFS      OS    Dead
## PFS  0.9221 0.06169 0.01621
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle50
## 
##         PFS      OS    Dead
## PFS  0.9215 0.06216 0.01632
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle51
## 
##         PFS      OS    Dead
## PFS  0.9209 0.06262 0.01644
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle52
## 
##         PFS      OS    Dead
## PFS  0.9204 0.06308 0.01655
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle53
## 
##         PFS      OS    Dead
## PFS  0.9198 0.06354 0.01666
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle54
## 
##         PFS      OS    Dead
## PFS  0.9192 0.06399 0.01677
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle55
## 
##         PFS      OS    Dead
## PFS  0.9187 0.06443 0.01688
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle56
## 
##         PFS      OS    Dead
## PFS  0.9181 0.06487 0.01699
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle57
## 
##         PFS     OS   Dead
## PFS  0.9176 0.0653 0.0171
## OS   0.0000 0.8300 0.1700
## Dead 0.0000 0.0000 1.0000
## 
## , , Cycle58
## 
##         PFS      OS   Dead
## PFS  0.9171 0.06573 0.0172
## OS   0.0000 0.83000 0.1700
## Dead 0.0000 0.00000 1.0000
## 
## , , Cycle59
## 
##         PFS      OS    Dead
## PFS  0.9165 0.06615 0.01731
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle60
## 
##        PFS      OS    Dead
## PFS  0.916 0.06657 0.01741
## OS   0.000 0.83000 0.17000
## Dead 0.000 0.00000 1.00000
## 
## , , Cycle61
## 
##         PFS      OS    Dead
## PFS  0.9155 0.06698 0.01751
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle62
## 
##        PFS      OS    Dead
## PFS  0.915 0.06739 0.01761
## OS   0.000 0.83000 0.17000
## Dead 0.000 0.00000 1.00000
## 
## , , Cycle63
## 
##         PFS     OS    Dead
## PFS  0.9145 0.0678 0.01771
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle64
## 
##        PFS     OS    Dead
## PFS  0.914 0.0682 0.01781
## OS   0.000 0.8300 0.17000
## Dead 0.000 0.0000 1.00000
## 
## , , Cycle65
## 
##         PFS      OS    Dead
## PFS  0.9135 0.06859 0.01791
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle66
## 
##        PFS      OS  Dead
## PFS  0.913 0.06899 0.018
## OS   0.000 0.83000 0.170
## Dead 0.000 0.00000 1.000
## 
## , , Cycle67
## 
##         PFS      OS   Dead
## PFS  0.9125 0.06938 0.0181
## OS   0.0000 0.83000 0.1700
## Dead 0.0000 0.00000 1.0000
## 
## , , Cycle68
## 
##        PFS      OS    Dead
## PFS  0.912 0.06976 0.01819
## OS   0.000 0.83000 0.17000
## Dead 0.000 0.00000 1.00000
## 
## , , Cycle69
## 
##         PFS      OS    Dead
## PFS  0.9116 0.07014 0.01829
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle70
## 
##         PFS      OS    Dead
## PFS  0.9111 0.07052 0.01838
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle71
## 
##         PFS     OS    Dead
## PFS  0.9106 0.0709 0.01847
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle72
## 
##         PFS      OS    Dead
## PFS  0.9102 0.07127 0.01856
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle73
## 
##         PFS      OS    Dead
## PFS  0.9097 0.07163 0.01865
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle74
## 
##         PFS    OS    Dead
## PFS  0.9093 0.072 0.01874
## OS   0.0000 0.830 0.17000
## Dead 0.0000 0.000 1.00000
## 
## , , Cycle75
## 
##         PFS      OS    Dead
## PFS  0.9088 0.07236 0.01883
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle76
## 
##         PFS      OS    Dead
## PFS  0.9084 0.07272 0.01892
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle77
## 
##         PFS      OS    Dead
## PFS  0.9079 0.07307 0.01901
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle78
## 
##         PFS      OS    Dead
## PFS  0.9075 0.07342 0.01909
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle79
## 
##        PFS      OS    Dead
## PFS  0.907 0.07377 0.01918
## OS   0.000 0.83000 0.17000
## Dead 0.000 0.00000 1.00000
## 
## , , Cycle80
## 
##         PFS      OS    Dead
## PFS  0.9066 0.07412 0.01927
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle81
## 
##         PFS      OS    Dead
## PFS  0.9062 0.07446 0.01935
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle82
## 
##         PFS     OS    Dead
## PFS  0.9058 0.0748 0.01943
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle83
## 
##         PFS      OS    Dead
## PFS  0.9053 0.07514 0.01952
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle84
## 
##         PFS      OS   Dead
## PFS  0.9049 0.07548 0.0196
## OS   0.0000 0.83000 0.1700
## Dead 0.0000 0.00000 1.0000
## 
## , , Cycle85
## 
##         PFS      OS    Dead
## PFS  0.9045 0.07581 0.01968
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle86
## 
##         PFS      OS    Dead
## PFS  0.9041 0.07614 0.01976
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle87
## 
##         PFS      OS    Dead
## PFS  0.9037 0.07647 0.01984
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle88
## 
##         PFS      OS    Dead
## PFS  0.9033 0.07679 0.01992
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle89
## 
##         PFS      OS Dead
## PFS  0.9029 0.07711 0.02
## OS   0.0000 0.83000 0.17
## Dead 0.0000 0.00000 1.00
## 
## , , Cycle90
## 
##         PFS      OS    Dead
## PFS  0.9025 0.07743 0.02008
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle91
## 
##         PFS      OS    Dead
## PFS  0.9021 0.07775 0.02016
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle92
## 
##         PFS      OS    Dead
## PFS  0.9017 0.07807 0.02024
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle93
## 
##         PFS      OS    Dead
## PFS  0.9013 0.07838 0.02031
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle94
## 
##         PFS      OS    Dead
## PFS  0.9009 0.07869 0.02039
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle95
## 
##         PFS    OS    Dead
## PFS  0.9005 0.079 0.02047
## OS   0.0000 0.830 0.17000
## Dead 0.0000 0.000 1.00000
## 
## , , Cycle96
## 
##         PFS      OS    Dead
## PFS  0.9002 0.07931 0.02054
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle97
## 
##         PFS      OS    Dead
## PFS  0.8998 0.07961 0.02062
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle98
## 
##         PFS      OS    Dead
## PFS  0.8994 0.07991 0.02069
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle99
## 
##        PFS      OS    Dead
## PFS  0.899 0.08021 0.02076
## OS   0.000 0.83000 0.17000
## Dead 0.000 0.00000 1.00000
## 
## , , Cycle100
## 
##         PFS      OS    Dead
## PFS  0.8986 0.08051 0.02084
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle101
## 
##         PFS      OS    Dead
## PFS  0.8983 0.08081 0.02091
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle102
## 
##         PFS     OS    Dead
## PFS  0.8979 0.0811 0.02098
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle103
## 
##         PFS     OS    Dead
## PFS  0.8975 0.0814 0.02105
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle104
## 
##         PFS      OS    Dead
## PFS  0.8972 0.08169 0.02113
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle105
## 
##         PFS      OS   Dead
## PFS  0.8968 0.08198 0.0212
## OS   0.0000 0.83000 0.1700
## Dead 0.0000 0.00000 1.0000
## 
## , , Cycle106
## 
##         PFS      OS    Dead
## PFS  0.8965 0.08226 0.02127
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle107
## 
##         PFS      OS    Dead
## PFS  0.8961 0.08255 0.02134
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle108
## 
##         PFS      OS    Dead
## PFS  0.8958 0.08283 0.02141
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle109
## 
##         PFS      OS    Dead
## PFS  0.8954 0.08312 0.02148
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
## , , Cycle110
## 
##         PFS     OS    Dead
## PFS  0.8951 0.0834 0.02155
## OS   0.0000 0.8300 0.17000
## Dead 0.0000 0.0000 1.00000
## 
## , , Cycle111
## 
##         PFS      OS    Dead
## PFS  0.8947 0.08367 0.02161
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
## 
##  [ reached getOption("max.print") -- omitted 32 matrix slice(s) ]
```

```r
# If I wanted to round my transition matrix so things sum exactly to 1, instead of 0.99999999 (in cases where this was happening):
#round(m_P_SoC, digits=2) 
#But, things actually sum well so I don't need to this
```


```r
#04.4 Check if transition probability matrices are valid.

# This is a check in the DARTH tools package that all the transition probabilities are in [0, 1], i.e., no probabilities are greater than 100%.

# This works as follows, according to line 205 of: https://github.com/DARTH-git/cohort-modeling-tutorial-intro/blob/main/analysis/cSTM_time_indep.R
# 
# ## Check if transition probability matrices are valid ----
# #* Functions included in "R/Functions.R". The latest version can be found in `darthtools` package
# ### Check that transition probabilities are [0, 1] ----
# check_transition_probability(m_P,      verbose = TRUE)  # m_P >= 0 && m_P <= 1
# check_transition_probability(m_P_strA, verbose = TRUE)  # m_P_strA >= 0 && m_P_strA <= 1
# check_transition_probability(m_P_strB, verbose = TRUE)  # m_P_strB >= 0 && m_P_strB <= 1
# check_transition_probability(m_P_strAB, verbose = TRUE) # m_P_strAB >= 0 && m_P_strAB <= 1
# ### Check that all rows sum to 1 ----
# check_sum_of_transition_array(m_P,      n_states = n_states, n_cycles = n_cycles, verbose = TRUE)  # rowSums(m_P) == 1
# check_sum_of_transition_array(m_P_strA, n_states = n_states, n_cycles = n_cycles, verbose = TRUE)  # rowSums(m_P_strA) == 1
# check_sum_of_transition_array(m_P_strB, n_states = n_states, n_cycles = n_cycles, verbose = TRUE)  # rowSums(m_P_strB) == 1
# check_sum_of_transition_array(m_P_strAB, n_states = n_states, n_cycles = n_cycles, verbose = TRUE) # rowSums(m_P_strAB) == 1
# 

check_transition_probability(m_P_SoC,  verbose = TRUE)
```

```
## [1] "Valid transition probabilities"
```

```r
check_transition_probability(m_P_Exp,  verbose = TRUE)
```

```
## [1] "Valid transition probabilities"
```

```r
# Check that all rows sum in each matrix sum to 1 -> which we know is a necessary condition for transition probability matrices.
check_sum_of_transition_array(m_P_SoC,  n_states = n_states, n_cycles = n_cycle, verbose = TRUE)
```

```
## [1] "This is a valid transition array"
```

```r
check_sum_of_transition_array(m_P_Exp,  n_states = n_states, n_cycles = n_cycle, verbose = TRUE)
```

```
## [1] "This is a valid transition array"
```

```r
# This error message:
   
#   Error in check_sum_of_transition_array(m_P_SoC, n_states = n_states, n_cycles = n_cycle,  : 
#   This is not a valid transition array 
 
# Reflects when something like this happens: 

#   > m_P_SoC
# , , Cycle1
 
#           PFS          OS        Dead       AE1       AE2       AE3
# PFS  0.974925 0.005074995 0.020000000 0.0194985 0.0194985 0.0194985
# [1] 1.058495
 
# That is, that I've put just any old probability value in at the moment and they are summing to be larger than one, when I've changed this to the actual probabilities I'm sure it'll be OK.

# Inspect whether properly defined
# - note that we inspect for the first two cycles
m_P_SoC[ , , 1:2]
```

```
## , , Cycle1
## 
##         PFS      OS     Dead
## PFS  0.9805 0.01478 0.004708
## OS   0.0000 0.83000 0.170000
## Dead 0.0000 0.00000 1.000000
## 
## , , Cycle2
## 
##         PFS      OS    Dead
## PFS  0.9689 0.02382 0.00731
## OS   0.0000 0.83000 0.17000
## Dead 0.0000 0.00000 1.00000
```

```r
m_P_Exp[ , , 1:2]
```

```
## , , Cycle1
## 
##         PFS      OS     Dead
## PFS  0.9868 0.01009 0.003063
## OS   0.0000 0.83000 0.170000
## Dead 0.0000 0.00000 1.000000
## 
## , , Cycle2
## 
##         PFS     OS     Dead
## PFS  0.9789 0.0163 0.004757
## OS   0.0000 0.8300 0.170000
## Dead 0.0000 0.0000 1.000000
```

```r
# Does it visually sum to 1?
```


```r
#05 Run Markov model
# for (t in 1:n_cycles){  # Use a for loop to loop through the number of cycles, basically we'll calculate the cohort distribution at the next cycle [t+1] based on the matrix of where they were at time t, matrix multiplied by the transition probability matrix for the current cycle (constant for us as we use a constant transition probability matrix, rather than a transition probability array).

# We do this for each treatment, as they all have different transition probability matrices. 

#  m_M_SoC [t + 1, ] <- m_M_SoC [t, ] %*% m_P_SoC   # estimate the state vector for the next cycle (t + 1)

# Above I was originally using a transition probability matrix, because I was using a time constant transition probability. But now, because my transition probabilities come from the survival curves, and thus change over time, I am using a transition probability array. 

# Thus, I adapt the above to reflect that my transition probability selected has to come from a certain cycle, i.e. from a certain time, and then be multiplied by the number of people in the matrix, the amount of the cohort in the matrix, at that cycle, i.e. at that time. Thats why below I pick the third dimension of the array, not row, not column, but time: R,C,T i.e.   ->  , ,i_cycle

# So here I once again create the Markov cohort trace by looping over all cycles
# - note that the trace can easily be obtained using matrix multiplications
# - note that now the right probabilities for the cycle need to be selected, like I explained above.

for(i_cycle in 1:(n_cycle-1)) {
  m_M_SoC[i_cycle + 1, ] <- m_M_SoC[i_cycle, ] %*% m_P_SoC[ , , i_cycle]
  m_M_Exp[i_cycle + 1, ] <- m_M_Exp[i_cycle, ] %*% m_P_Exp[ , , i_cycle]
}

head(m_M_SoC)  # print the first few lines of the matrix for standard of care (m_M_SoC)
```

```
##            PFS      OS     Dead
## Cycle 1 1.0000 0.00000 0.000000
## Cycle 2 0.9805 0.01478 0.004708
## Cycle 3 0.9500 0.03562 0.014388
## Cycle 4 0.9140 0.05718 0.028777
## Cycle 5 0.8748 0.07769 0.047529
## Cycle 6 0.8335 0.09634 0.070180
```

```r
head(m_M_Exp)  # print the first few lines of the matrix for experimental treatment(m_M_Exp)
```

```
##            PFS      OS     Dead
## Cycle 1 1.0000 0.00000 0.000000
## Cycle 2 0.9868 0.01009 0.003063
## Cycle 3 0.9661 0.02446 0.009473
## Cycle 4 0.9413 0.03955 0.019149
## Cycle 5 0.9139 0.05419 0.031928
## Cycle 6 0.8846 0.06783 0.047564
```

```r
#m_M_SoC
m_M_SoC
```

```
##                      PFS            OS     Dead
## Cycle 1   1.000000000000 0.00000000000 0.000000
## Cycle 2   0.980514224355 0.01477733152 0.004708
## Cycle 3   0.949988269605 0.03562398844 0.014388
## Cycle 4   0.914044904042 0.05717774013 0.028777
## Cycle 5   0.874779409562 0.07769169256 0.047529
## Cycle 6   0.833481962065 0.09633774303 0.070180
## Cycle 7   0.791064941395 0.11272115807 0.096214
## Cycle 8   0.748215368460 0.12668918736 0.125095
## Cycle 9   0.705466779582 0.13823434451 0.156299
## Cycle 10  0.663239294608 0.14743869244 0.189322
## Cycle 11  0.621864731118 0.15443915851 0.223696
## Cycle 12  0.581603788716 0.15940487909 0.258991
## Cycle 13  0.542658625121 0.16252196096 0.294819
## Cycle 14  0.505182546602 0.16398306672 0.330834
## Cycle 15  0.469287772027 0.16398026217 0.366732
## Cycle 16  0.435051836562 0.16270013323 0.402248
## Cycle 17  0.402522985943 0.16032051509 0.437156
## Cycle 18  0.371724788765 0.15700838370 0.471267
## Cycle 19  0.342660120443 0.15291859313 0.504421
## Cycle 20  0.315314626920 0.14819323149 0.536492
## Cycle 21  0.289659747226 0.14296142898 0.567379
## Cycle 22  0.265655355024 0.13733949493 0.597005
## Cycle 23  0.243252066600 0.13143129103 0.625317
## Cycle 24  0.222393254016 0.12532877068 0.652278
## Cycle 25  0.203016795944 0.11911263111 0.677871
## Cycle 26  0.185056594218 0.11285303734 0.702090
## Cycle 27  0.168443880704 0.10661038668 0.724946
## Cycle 28  0.153108336430 0.10043608988 0.746456
## Cycle 29  0.138979042779 0.09437335069 0.766648
## Cycle 30  0.125985282687 0.08845793021 0.785557
## Cycle 31  0.114057208252 0.08271888577 0.803224
## Cycle 32  0.103126389742 0.07717927711 0.819694
## Cycle 33  0.093126259704 0.07185683456 0.835017
## Cycle 34  0.083992464752 0.06676458617 0.849243
## Cycle 35  0.075663136458 0.06191144149 0.862425
## Cycle 36  0.068079091810 0.05730273154 0.874618
## Cycle 37  0.061183972714 0.05294070475 0.885875
## Cycle 38  0.054924333130 0.04882497986 0.896251
## Cycle 39  0.049249681579 0.04495295682 0.905797
## Cycle 40  0.044112485997 0.04132018759 0.914567
## Cycle 41  0.039468147145 0.03792070867 0.922611
## Cycle 42  0.035274946119 0.03474733751 0.929978
## Cycle 43  0.031493970869 0.03179193518 0.936714
## Cycle 44  0.028089026051 0.02904563760 0.942865
## Cycle 45  0.025026529987 0.02649905765 0.948474
## Cycle 46  0.022275402031 0.02414246067 0.953582
## Cycle 47  0.019806943195 0.02196591545 0.958227
## Cycle 48  0.017594712461 0.01995942316 0.962446
## Cycle 49  0.015614400861 0.01811302612 0.966273
## Cycle 50  0.013843705078 0.01641689870 0.969739
## Cycle 51  0.012262202006 0.01486142198 0.972876
## Cycle 52  0.010851225476 0.01343724426 0.975712
## Cycle 53  0.009593746112 0.01213532881 0.978271
## Cycle 54  0.008474255064 0.01094699063 0.980579
## Cycle 55  0.007478652227 0.00986392349 0.982657
## Cycle 56  0.006594139357 0.00887821860 0.984528
## Cycle 57  0.005809118405 0.00798237611 0.986209
## Cycle 58  0.005113095250 0.00716931049 0.987718
## Cycle 59  0.004496588926 0.00643235071 0.989071
## Cycle 60  0.003951046370 0.00576523614 0.990284
## Cycle 61  0.003468762623 0.00516210894 0.991369
## Cycle 62  0.003042806410 0.00461750350 0.992340
## Cycle 63  0.002666950925 0.00412633375 0.993207
## Cycle 64  0.002335609660 0.00368387859 0.993981
## Cycle 65  0.002043777073 0.00328576609 0.994670
## Cycle 66  0.001786973866 0.00292795682 0.995285
## Cycle 67  0.001561196643 0.00260672657 0.995832
## Cycle 68  0.001362871709 0.00231864875 0.996318
## Cycle 69  0.001188812756 0.00206057687 0.996751
## Cycle 70  0.001036182195 0.00182962702 0.997134
## Cycle 71  0.000902455900 0.00162316078 0.997474
## Cycle 72  0.000785391111 0.00143876850 0.997776
## Cycle 73  0.000682997276 0.00127425321 0.998043
## Cycle 74  0.000593509621 0.00112761504 0.998279
## Cycle 75  0.000515365210 0.00099703644 0.998488
## Cycle 76  0.000447181323 0.00088086805 0.998672
## Cycle 77  0.000387735944 0.00077761534 0.998835
## Cycle 78  0.000335950185 0.00068592601 0.998978
## Cycle 79  0.000290872481 0.00060457817 0.999105
## Cycle 80  0.000251664394 0.00053246925 0.999216
## Cycle 81  0.000217587888 0.00046860565 0.999314
## Cycle 82  0.000187993928 0.00041209311 0.999400
## Cycle 83  0.000162312290 0.00036212781 0.999476
## Cycle 84  0.000140042461 0.00031798808 0.999542
## Cycle 85  0.000120745522 0.00027902680 0.999600
## Cycle 86  0.000104036921 0.00024466434 0.999651
## Cycle 87  0.000089580037 0.00021438216 0.999696
## Cycle 88  0.000077080475 0.00018771684 0.999735
## Cycle 89  0.000066280989 0.00016425470 0.999769
## Cycle 90  0.000056956993 0.00014362685 0.999799
## Cycle 91  0.000048912582 0.00012550470 0.999826
## Cycle 92  0.000041977014 0.00010959582 0.999848
## Cycle 93  0.000036001602 0.00009564025 0.999868
## Cycle 94  0.000030856973 0.00008340715 0.999886
## Cycle 95  0.000026430652 0.00007269166 0.999901
## Cycle 96  0.000022624934 0.00006331223 0.999914
## Cycle 97  0.000019355011 0.00005510807 0.999926
## Cycle 98  0.000016547330 0.00004793693 0.999936
## Cycle 99  0.000014138151 0.00004167307 0.999944
## Cycle 100 0.000012072275 0.00003620542 0.999952
## Cycle 101 0.000010301943 0.00003143601 0.999958
## Cycle 102 0.000008785862 0.00002727843 0.999964
## Cycle 103 0.000007488353 0.00002365660 0.999969
## Cycle 104 0.000006378619 0.00002050353 0.999973
## Cycle 105 0.000005430089 0.00001776033 0.999977
## Cycle 106 0.000004619859 0.00001537524 0.999980
## Cycle 107 0.000003928199 0.00001330282 0.999983
## Cycle 108 0.000003338126 0.00001150320 0.999985
## Cycle 109 0.000002835032 0.00000994145 0.999987
## Cycle 110 0.000002406360 0.00000858694 0.999989
## Cycle 111 0.000002041324 0.00000741290 0.999991
## Cycle 112 0.000001730668 0.00000639588 0.999992
## Cycle 113 0.000001466449 0.00000551540 0.999993
## Cycle 114 0.000001241862 0.00000475359 0.999994
## Cycle 115 0.000001051076 0.00000409483 0.999995
## Cycle 116 0.000000889100 0.00000352551 0.999996
## Cycle 117 0.000000751664 0.00000303376 0.999996
## Cycle 118 0.000000635120 0.00000260925 0.999997
## Cycle 119 0.000000536348 0.00000224300 0.999997
## Cycle 120 0.000000452688 0.00000192719 0.999998
## Cycle 121 0.000000381868 0.00000165501 0.999998
## Cycle 122 0.000000321951 0.00000142056 0.999998
## Cycle 123 0.000000271289 0.00000121873 0.999999
## Cycle 124 0.000000228476 0.00000104506 0.999999
## Cycle 125 0.000000192315 0.00000089571 0.999999
## Cycle 126 0.000000161792 0.00000076734 0.999999
## Cycle 127 0.000000136040 0.00000065705 0.999999
## Cycle 128 0.000000114327 0.00000056235 0.999999
## Cycle 129 0.000000096029 0.00000048108 0.999999
## Cycle 130 0.000000080617 0.00000041136 1.000000
## Cycle 131 0.000000067644 0.00000035159 1.000000
## Cycle 132 0.000000056729 0.00000030036 1.000000
## Cycle 133 0.000000047550 0.00000025649 1.000000
## Cycle 134 0.000000039836 0.00000021893 1.000000
## Cycle 135 0.000000033357 0.00000018678 1.000000
## Cycle 136 0.000000027917 0.00000015929 1.000000
## Cycle 137 0.000000023352 0.00000013578 1.000000
## Cycle 138 0.000000019524 0.00000011570 1.000000
## Cycle 139 0.000000016315 0.00000009854 1.000000
## Cycle 140 0.000000013627 0.00000008389 1.000000
## Cycle 141 0.000000011376 0.00000007139 1.000000
## Cycle 142 0.000000009492 0.00000006073 1.000000
## Cycle 143 0.000000007917 0.00000005164 1.000000
```

```r
#m_M_Exp
m_M_Exp
```

```
##                   PFS          OS     Dead
## Cycle 1   1.000000000 0.000000000 0.000000
## Cycle 2   0.986847718 0.010089266 0.003063
## Cycle 3   0.966063070 0.024463981 0.009473
## Cycle 4   0.941303760 0.039547468 0.019149
## Cycle 5   0.913886497 0.054185732 0.031928
## Cycle 6   0.884610488 0.067825095 0.047564
## Cycle 7   0.854041045 0.080189150 0.065770
## Cycle 8   0.822609378 0.091153683 0.086237
## Cycle 9   0.790658666 0.100684767 0.108657
## Cycle 10  0.758468968 0.108803903 0.132727
## Cycle 11  0.726272252 0.115566815 0.158161
## Cycle 12  0.694262227 0.121049930 0.184688
## Cycle 13  0.662601198 0.125341472 0.212057
## Cycle 14  0.631425102 0.128535501 0.240039
## Cycle 15  0.600847371 0.130727888 0.268425
## Cycle 16  0.570962002 0.132013591 0.297024
## Cycle 17  0.541846063 0.132484837 0.325669
## Cycle 18  0.513561800 0.132229928 0.354208
## Cycle 19  0.486158428 0.131332500 0.382509
## Cycle 20  0.459673687 0.129871081 0.410455
## Cycle 21  0.434135204 0.127918891 0.437946
## Cycle 22  0.409561707 0.125543783 0.464895
## Cycle 23  0.385964096 0.122808310 0.491228
## Cycle 24  0.363346414 0.119769857 0.516884
## Cycle 25  0.341706713 0.116480834 0.541812
## Cycle 26  0.321037838 0.112988902 0.565973
## Cycle 27  0.301328136 0.109337216 0.589335
## Cycle 28  0.282562099 0.105564686 0.611873
## Cycle 29  0.264720937 0.101706238 0.633573
## Cycle 30  0.247783105 0.097793078 0.654424
## Cycle 31  0.231724771 0.093852948 0.674422
## Cycle 32  0.216520246 0.089910377 0.693569
## Cycle 33  0.202142360 0.085986927 0.711871
## Cycle 34  0.188562803 0.082101422 0.729336
## Cycle 35  0.175752438 0.078270173 0.745977
## Cycle 36  0.163681562 0.074507186 0.761811
## Cycle 37  0.152320154 0.070824365 0.776855
## Cycle 38  0.141638086 0.067231696 0.791130
## Cycle 39  0.131605305 0.063737429 0.804657
## Cycle 40  0.122192001 0.060348239 0.817460
## Cycle 41  0.113368743 0.057069386 0.829562
## Cycle 42  0.105106600 0.053904853 0.840989
## Cycle 43  0.097377245 0.050857486 0.851765
## Cycle 44  0.090153038 0.047929116 0.861918
## Cycle 45  0.083407100 0.045120676 0.871472
## Cycle 46  0.077113368 0.042432306 0.880454
## Cycle 47  0.071246638 0.039863451 0.888890
## Cycle 48  0.065782603 0.037412953 0.896804
## Cycle 49  0.060697877 0.035079129 0.904223
## Cycle 50  0.055970010 0.032859853 0.911170
## Cycle 51  0.051577492 0.030752620 0.917670
## Cycle 52  0.047499764 0.028754609 0.923746
## Cycle 53  0.043717205 0.026862738 0.929420
## Cycle 54  0.040211127 0.025073721 0.934715
## Cycle 55  0.036963758 0.023384106 0.939652
## Cycle 56  0.033958230 0.021790320 0.944251
## Cycle 57  0.031178553 0.020288706 0.948533
## Cycle 58  0.028609593 0.018875553 0.952515
## Cycle 59  0.026237050 0.017547126 0.956216
## Cycle 60  0.024047426 0.016299692 0.959653
## Cycle 61  0.022028000 0.015129540 0.962842
## Cycle 62  0.020166800 0.014033002 0.965800
## Cycle 63  0.018452568 0.013006465 0.968541
## Cycle 64  0.016874735 0.012046390 0.971079
## Cycle 65  0.015423388 0.011149323 0.973427
## Cycle 66  0.014089239 0.010311900 0.975599
## Cycle 67  0.012863599 0.009530860 0.977606
## Cycle 68  0.011738344 0.008803047 0.979459
## Cycle 69  0.010705886 0.008125418 0.981169
## Cycle 70  0.009759150 0.007495045 0.982746
## Cycle 71  0.008891540 0.006909117 0.984199
## Cycle 72  0.008096914 0.006364940 0.985538
## Cycle 73  0.007369560 0.005859942 0.986770
## Cycle 74  0.006704169 0.005391667 0.987904
## Cycle 75  0.006095813 0.004957776 0.988946
## Cycle 76  0.005539918 0.004556048 0.989904
## Cycle 77  0.005032246 0.004184371 0.990783
## Cycle 78  0.004568872 0.003840749 0.991590
## Cycle 79  0.004146162 0.003523290 0.992331
## Cycle 80  0.003760759 0.003230209 0.993009
## Cycle 81  0.003409559 0.002959820 0.993631
## Cycle 82  0.003089698 0.002710537 0.994200
## Cycle 83  0.002798534 0.002480866 0.994721
## Cycle 84  0.002533631 0.002269404 0.995197
## Cycle 85  0.002292745 0.002074835 0.995632
## Cycle 86  0.002073812 0.001895923 0.996030
## Cycle 87  0.001874932 0.001731514 0.996394
## Cycle 88  0.001694361 0.001580525 0.996725
## Cycle 89  0.001530494 0.001441947 0.997028
## Cycle 90  0.001381860 0.001314838 0.997303
## Cycle 91  0.001247110 0.001198318 0.997555
## Cycle 92  0.001125005 0.001091569 0.997783
## Cycle 93  0.001014414 0.000993828 0.997992
## Cycle 94  0.000914299 0.000904387 0.998181
## Cycle 95  0.000823710 0.000822588 0.998354
## Cycle 96  0.000741779 0.000747821 0.998510
## Cycle 97  0.000667715 0.000679520 0.998653
## Cycle 98  0.000600792 0.000617159 0.998782
## Cycle 99  0.000540350 0.000560254 0.998899
## Cycle 100 0.000485786 0.000508355 0.999006
## Cycle 101 0.000436552 0.000461046 0.999102
## Cycle 102 0.000392146 0.000417946 0.999190
## Cycle 103 0.000352113 0.000378700 0.999269
## Cycle 104 0.000316038 0.000342982 0.999341
## Cycle 105 0.000283545 0.000310491 0.999406
## Cycle 106 0.000254291 0.000280952 0.999465
## Cycle 107 0.000227964 0.000254109 0.999518
## Cycle 108 0.000204281 0.000229729 0.999566
## Cycle 109 0.000182987 0.000207596 0.999609
## Cycle 110 0.000163848 0.000187514 0.999649
## Cycle 111 0.000146653 0.000169301 0.999684
## Cycle 112 0.000131213 0.000152791 0.999716
## Cycle 113 0.000117352 0.000137832 0.999745
## Cycle 114 0.000104916 0.000124284 0.999771
## Cycle 115 0.000093761 0.000112021 0.999794
## Cycle 116 0.000083761 0.000100926 0.999815
## Cycle 117 0.000074799 0.000090892 0.999834
## Cycle 118 0.000066771 0.000081821 0.999851
## Cycle 119 0.000059582 0.000073626 0.999867
## Cycle 120 0.000053148 0.000066224 0.999881
## Cycle 121 0.000047391 0.000059543 0.999893
## Cycle 122 0.000042242 0.000053514 0.999904
## Cycle 123 0.000037638 0.000048076 0.999914
## Cycle 124 0.000033525 0.000043174 0.999923
## Cycle 125 0.000029850 0.000038756 0.999931
## Cycle 126 0.000026568 0.000034776 0.999939
## Cycle 127 0.000023638 0.000031194 0.999945
## Cycle 128 0.000021024 0.000027969 0.999951
## Cycle 129 0.000018693 0.000025068 0.999956
## Cycle 130 0.000016614 0.000022459 0.999961
## Cycle 131 0.000014761 0.000020115 0.999965
## Cycle 132 0.000013110 0.000018008 0.999969
## Cycle 133 0.000011640 0.000016116 0.999972
## Cycle 134 0.000010331 0.000014417 0.999975
## Cycle 135 0.000009166 0.000012892 0.999978
## Cycle 136 0.000008130 0.000011525 0.999980
## Cycle 137 0.000007208 0.000010299 0.999982
## Cycle 138 0.000006389 0.000009199 0.999984
## Cycle 139 0.000005661 0.000008215 0.999986
## Cycle 140 0.000005014 0.000007333 0.999988
## Cycle 141 0.000004440 0.000006543 0.999989
## Cycle 142 0.000003930 0.000005836 0.999990
## Cycle 143 0.000003477 0.000005204 0.999991
```


```r
#06 Compute and Plot Epidemiological Outcomes

#06.1 Cohort trace

# So, we'll plot the above Markov model for standard of care (m_M_SoC) to show our cohort distribution over time, i.e. the proportion of our cohort in the different health states over time.

# If I wanted to do the same for exp, I would just copy this code chunk and replace m_M_SoC with m_M_Exp

# Here is the simplest code that would give me what I want:

# matplot(m_M_SoC, type = 'l', 
        # ylab = "Probability of state occupancy",
        # xlab = "Cycle",
        # main = "Cohort Trace", lwd = 3)  # create a plot of the data
# legend("right", v_names_states, col = c("black", "red", "green"), 
       # lty = 1:3, bty = "n")  # add a legend to the graph

# But I would like to add more:

# Plotting the Markov cohort traces
matplot(m_M_SoC, 
        type = "l", 
        ylab = "Probability of state occupancy",
        xlab = "Cycle",
        main = "Makrov Cohort Traces",
        lwd  = 3,
        lty  = 1) # create a plot of the data
matplot(m_M_Exp, 
        type = "l", 
        lwd  = 3,
        lty  = 3,
        add  = TRUE) # add a plot of the experimental data ontop of the above plot
legend("right", 
       legend = c(paste(v_names_states, "(SOC)"), paste(v_names_states, "(Exp)")), 
       col    = rep(c("black", "red", "green"), 2), 
       lty    = c(1, 1, 1, 3, 3, 3), # Line type, full (1) or dashed (3), I have entered this 6 times here because we have 3 lines under standard of care (3 full lines) and  3 lines under experimental treatment (3 dashed lines)
       lwd    = 3,
       bty    = "n")
```

<img src="Markov_3state_files/figure-html/unnamed-chunk-26-1.png" width="672" />

```r
#ggsave("Markov_Cohort_Traces.png", width = 4, height = 4, dpi=300)
#while (!is.null(dev.list()))  dev.off()
# png(paste("Markov_Cohort_Traces", ".png"))
# dev.off()

# plot a vertical line that helps identifying at which cycle the prevalence of OS is highest
#abline(v = which.max(m_M_SoC[, "OS"]), col = "gray")
#abline(v = which.max(m_M_Exp[, "OS"]), col = "black")
# The vertical line shows you when your progressed (OS) population is the greatest that it will ever be, but it can be changed from which.max to other things (so it is finding which cycle the proportion progressed is the highest and putting a vertical line there).
# (It's probably not necessary for my own analysis and I can comment these two lines out if I'm not going to use it).

# So, you can see in the graph everyone starts in the PFS state, but that this falls over time as people progress and leave this state, then you see OS start to peak up but then fall again as people leave this state to go into the dead state, which is an absorbing state and by the end will include everyone.
```


```r
#06.2 Overall Survival (OS)

# Although in the context of my analysis this would be PFS + OS because it is drawn from the DARTH model where healthy and sick make up OS, while dead means not OS (obviously).

# v_os <- 1 - m_M_SoC[, "Dead"]    # calculate the overall survival (OS) probability
# v_os <- rowSums(m_M_SoC[, 1:2])  # alternative way of calculating the OS probability

# I could do my own version of this and chose just to look at pfs, rather than column 1 and 2 to look at anyone not dead.

# i.e. v_os <- (m_M_SoC[, 1])

# best practice would be to rename v_os if I am looking at something that isnt os, i.e. v_pfs and to of course update the table legend, bearing in mind that yet again this is all for standard of care, and that if I wanted to know this for exp treatment I would need to replace the Markov model matrix above.


# plot(v_os, type = 'l', 
#     ylim = c(0, 1),
#     ylab = "Survival probability",
#     xlab = "Cycle",
#     main = "Overall Survival")  # create a simple plot showing the OS

# add grid 
# grid(nx = n_cycles, ny = 10, col = "lightgray", lty = "dotted", lwd = par("lwd"), 
#     equilogs = TRUE) 

# Calculating and plotting overal survival (OS)
v_OS_SoC <- 1 - m_M_SoC[, "Dead"]
v_OS_Exp <- 1 - m_M_Exp[, "Dead"]

plot(v_OS_SoC, 
     type = "l",
     ylim = c(0, 1),
     ylab = "Survival probability",
     xlab = "Cycle",
     main = "Overall Survival",
     lwd  = 3) # create a simple plot showing the OS
lines(v_OS_Exp,
      lty = 3,
      lwd = 3)
legend("right",
       legend = c("SoC", "Exp"),
       lty    = c(1, 3),
       lwd    = 3,
       bty    = "n")

# add grid - completely optional, see if it looks nicer to leave this code in or output:
grid(nx = n_cycle, ny = 10, col = "lightgray", lty = "dotted", lwd = par("lwd"), 
     equilogs = TRUE) 
```

<img src="Markov_3state_files/figure-html/unnamed-chunk-27-1.png" width="672" />

```r
# I don't end up using this, because I feel plotting the cohort trace is more descriptive, with PFS, OS and D included in it, but there still are some interesting things you could do with this in the future:

# Per C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Cost-Effectiveness and Decision Modeling using R Workshop \_ DARTH\August\_25\Live Session 

# Often you have a survival curve as input to your model [I guess from a published study], and having that survival curve you need to parameterise your model so that you match that survival curve, and that would be a process of, potentially of calibration, if you can't use the parameters directly in your model.

# So, you could produce your survival curve and compare it to curves from trials, etc., to calibrate your model.

# For calibration purposes, you want to make sure that your model is outputting something that's comparable to the publications out there on actual data on the same type of patients.

# Part of being comparable to the real world is that if there is a censoring process in actual patient data, then you could incorporate this process into the model to reflect that in your model and to ensure that your own model is comparable to the existing models which may be losing people due to censoring, etc., and which you'll then need to incorporate into your model to be comparable. 

# Another interesting thing you can do is, plot this to ask is that reasonable, does that make sense that this many people are alive after this amount of time? Is the OS what I would expect it to be?
```


```r
#06.2.1 Life Expectancy (LE)

v_le <- sum(v_OS_SoC)  # summing probability of OS over time  (i.e. life expectancy)

# Basically we are summing all the alive states over time through over all the cycles, so 

# v_os <- rowSums(m_M_SoC[, 1:2])

# Is basically the PFS and OS added together.

# Also bear in mind that this is life expectancy under standard of care, and not under the new treatments, per: # v_os <- rowSums(m_M_SoC[, 1:2]) above.

v_le
```

```
## [1] 20.7
```

```r
v_le_exp <- sum(v_OS_Exp)  # summing probability of OS over time  (i.e. life expectancy)

v_le_exp
```

```
## [1] 25.94
```

```r
# So, if this gives a value of [1] 20.70332, that is [1] 20.70332 cycles, where in the context of our model, cycles are fortnights, so the life expectancy for our population of patients is 20.70332 fortnights or 289.84648, in days:

daily_v_le <- v_le * 14
daily_v_le
```

```
## [1] 289.8
```

```r
daily_v_le_exp <- v_le_exp * 14
daily_v_le_exp
```

```
## [1] 363.2
```

```r
# When I calculate LE I calculate it in cycles. Note that my code gives a LE of 20.7 cycles for the SoC group which is approx. 290 days or 0.8 years.  Caculating the LE for the Exp group I calculated the corresponding figures as: 25.9 cycles = 363 days = 1 year (approx.). So a LE gain of about 0.2 life-years.


life_years_days_gained <- round(daily_v_le_exp - daily_v_le, digits=0)
# The number of days gained.

life_years_soc <- round(daily_v_le/365, digits=2)
# The proportion of a year you get under each treatment

life_years_exp <- round(daily_v_le_exp/365, digits=2)
# The proportion of a year you get under each treatment


# Discounted life expectancy:

# If you wanted discounted life expectancy, if you were using life years and you wanted them discounted for your health economic outcomes, you could apply the discount rates - the discount factors - to the vector for overall survival [v_os] and then take it's sum [add it up] as above to get life expectancy that is discounted.

# As per: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Cost-Effectiveness and Decision Modeling using R Workshop _ DARTH\August_25\Live Session 
```


```r
#06.3 Disease prevalence
# Disease prevalence is the proportion who are sick divided by the proportion who are alive, so it's necessary to account for the fact that some of the cohort have died, so you only calculate prevalence among people who are alive,in the diagram you can see it plateauing over time, even though the number of people in the OS (or "progressed") state have gone up and come down over time and this is because this is prevalence as a proportion of those who are alive, and there are few people who are still alive by cycle 60.

# Probably looks a bit funny dividing OS by v_os below, but it's necessary to remember that v_os is PFS + OS, because it's anyone who is not dead.

# So, I guess in our context you can think of this as progression prevalence (i.e. being in second line treatment) over time.

# I ultimately dont end up using this in my analysis:

v_prev <- m_M_SoC[, "OS"]/v_OS_SoC
plot(v_prev,
     ylim = c(0, 1),
     ylab = "Prevalence",
     xlab = "Cycle",
     main = "Disease prevalence")
```

<img src="Markov_3state_files/figure-html/unnamed-chunk-29-1.png" width="672" />


```r
#07 Compute Cost-Effectiveness Outcomes

#07.1 Including ADVERSE EVENTS in Mean Costs and QALYs for each strategy

# Calculate the costs and QALYs per cycle by multiplying m_M (the Markov trace) with the cost/utility vectors for the different states

# per cycle
# calculate expected costs by multiplying cohort trace with the cost vector for the different health states

# Basically, you take the cohort trace over time for each strategy [m_M_SoC] and multiply this by a vector of our costs for each state: [c(c_H, c_S, c_D)] -> So, basically the number of people in each state at each cycle multiplied by the cost of being in that state [cost of healthy, cost of sick and cost of dead] for each strategy that we look at (standard of care, experimental).

# Bear in mind we are doing matrix multiplication [%*%], because what this does is for each cycle [row in the matrix], take the vector of costs, and multiply it by the distribution in that cycle [breakdown of proportions in the states in that row] and add it all together, to get the total costs for that cycle [row]. This gives us a vector of the costs accrued in this cohort of individuals ending up in these different states for each cycle on a per person basis, because it's a cohort distribution (it always sums to 1).

# So, in cycle 1 everyone is in the PFS state, so they only incur the PFS cost, as more and more time passes and more and more people get sick, the costs increases due to more people being in the OS state, but over time this falls again as more and more people go into the dead state, which has no costs as we don't treat corpses.
  

# 1. Probability of adverse events 1,2 3 in the PFS state under standard of care and exp care:

# AE1:Leukopenia = 0.040 AE2:Diarrhea = 0.310 AE3:Vomiting = 0.31

p_FA1_STD     <- 0.040   # probability of adverse event 1 when progression-free under SOC
p_FA2_STD     <- 0.310   # probability of adverse event 2 when progression-free under SOC
p_FA3_STD     <- 0.310   # probability of adverse event 3 when progression-free under SOC

p_FA1_EXPR     <- 0.070   # probability of adverse event 1 when progression-free under EXPR
p_FA2_EXPR     <- 0.110   # probability of adverse event 2 when progression-free under EXPR
p_FA3_EXPR     <- 0.070   # probability of adverse event 3 when progression-free under EXPR

# 2. Cost of treating the AE conditional on it occurring
c_AE1 <- c_AE1
c_AE2 <- c_AE2
c_AE3 <- c_AE3 
#3. Disutiltiy of AE (negative qol impact x duration of event)


AE1_DisUtil <-0.45
AE2_DisUtil <-0.19
AE3_DisUtil <-0.36

daily_utility <- u_F/14
AE1_discounted_daily_utility <- daily_utility * (1-AE1_DisUtil)
AE2_discounted_daily_utility <- daily_utility * (1-AE2_DisUtil)
AE3_discounted_daily_utility <- daily_utility * (1-AE3_DisUtil)


u_AE1 <- (AE1_discounted_daily_utility*7) + (daily_utility*7)
u_AE2 <- (AE2_discounted_daily_utility*7) + (daily_utility*7)
u_AE3 <- (AE3_discounted_daily_utility*7) + (daily_utility*7)


# I then adjust my state costs and utilities:

# uState<-uState-pAE1*duAE1


c_F_SoC<-c_F_SoC +p_FA1_STD*c_AE1 +p_FA2_STD*c_AE2 +p_FA3_STD*c_AE3
c_F_Exp<-c_F_Exp +p_FA1_EXPR*c_AE1 +p_FA2_EXPR*c_AE2 +p_FA3_EXPR*c_AE3


u_F_SoC<-u_F
u_F_Exp<-u_F


u_F_SoC<-u_F-p_FA1_STD*u_AE1 -p_FA2_STD*u_AE2 -p_FA3_STD*u_AE3
u_F_Exp<-u_F-p_FA1_EXPR*u_AE1 -p_FA2_EXPR*u_AE2 -p_FA3_EXPR*u_AE3


v_tc_SoC <- m_M_SoC %*% c(c_F_SoC, c_P, c_D)
v_tc_Exp <- m_M_Exp %*% c(c_F_Exp, c_P, c_D)

v_tc_SoC
```

```
##                   [,1]
## Cycle 1   982.65890000
## Cycle 2   970.22762186
## Cycle 3   949.70624325
## Cycle 4   924.18278640
## Cycle 5   894.92220044
## Cycle 6   862.81589898
## Cycle 7   828.58102591
## Cycle 8   792.82326037
## Cycle 9   756.06348388
## Cycle 10  718.75183016
## Cycle 11  681.27659896
## Cycle 12  643.97084490
## Cycle 13  607.11780933
## Cycle 14  570.95570903
## Cycle 15  535.68211461
## Cycle 16  501.45802372
## Cycle 17  468.41167511
## Cycle 18  436.64212259
## Cycle 19  406.22257598
## Cycle 20  377.20351202
## Cycle 21  349.61555728
## Cycle 22  323.47214618
## Cycle 23  298.77195859
## Cycle 24  275.50114321
## Cycle 25  253.63533447
## Cycle 26  233.14147184
## Cycle 27  213.97943148
## Cycle 28  196.10348103
## Cycle 29  179.46356865
## Cycle 30  164.00645774
## Cycle 31  149.67671876
## Cycle 32  136.41758974
## Cycle 33  124.17171637
## Cycle 34  112.88178273
## Cycle 35  102.49104283
## Cycle 36   92.94376301
## Cycle 37   84.18558445
## Cycle 38   76.16381462
## Cycle 39   68.82765586
## Cycle 40   62.12837863
## Cycle 41   56.01944656
## Cycle 42   50.45659959
## Cycle 43   45.39790115
## Cycle 44   40.80375464
## Cycle 45   36.63689411
## Cycle 46   32.86235328
## Cycle 47   29.44741690
## Cycle 48   26.36155781
## Cycle 49   23.57636261
## Cycle 50   21.06544880
## Cycle 51   18.80437545
## Cycle 52   16.77054955
## Cycle 53   14.94312965
## Cycle 54   13.30292834
## Cycle 55   11.83231468
## Cycle 56   10.51511764
## Cycle 57    9.33653149
## Cycle 58    8.28302356
## Cycle 59    7.34224517
## Cycle 60    6.50294601
## Cycle 61    5.75489222
## Cycle 62    5.08878849
## Cycle 63    4.49620428
## Cycle 64    3.96950411
## Cycle 65    3.50178213
## Cycle 66    3.08680071
## Cycle 67    2.71893313
## Cycle 68    2.39311025
## Cycle 69    2.10477083
## Cycle 70    1.84981573
## Cycle 71    1.62456536
## Cycle 72    1.42572062
## Cycle 73    1.25032692
## Cycle 74    1.09574110
## Cycle 75    0.95960121
## Cycle 76    0.83979885
## Cycle 77    0.73445390
## Cycle 78    0.64189153
## Cycle 79    0.56062130
## Cycle 80    0.48931818
## Cycle 81    0.42680531
## Cycle 82    0.37203847
## Cycle 83    0.32409195
## Cycle 84    0.28214591
## Cycle 85    0.24547492
## Cycle 86    0.21343764
## Cycle 87    0.18546760
## Cycle 88    0.16106487
## Cycle 89    0.13978865
## Cycle 90    0.12125057
## Cycle 91    0.10510878
## Cycle 92    0.09106258
## Cycle 93    0.07884770
## Cycle 94    0.06823210
## Cycle 95    0.05901213
## Cycle 96    0.05100927
## Cycle 97    0.04406709
## Cycle 98    0.03804868
## Cycle 99    0.03283422
## Cycle 100   0.02831902
## Cycle 101   0.02441159
## Cycle 102   0.02103210
## Cycle 103   0.01811090
## Cycle 104   0.01558727
## Cycle 105   0.01340835
## Cycle 106   0.01152810
## Cycle 107   0.00990648
## Cycle 108   0.00850867
## Cycle 109   0.00730446
## Cycle 110   0.00626757
## Cycle 111   0.00537524
## Cycle 112   0.00460771
## Cycle 113   0.00394788
## Cycle 114   0.00338093
## Cycle 115   0.00289403
## Cycle 116   0.00247609
## Cycle 117   0.00211753
## Cycle 118   0.00181006
## Cycle 119   0.00154654
## Cycle 120   0.00132078
## Cycle 121   0.00112748
## Cycle 122   0.00096204
## Cycle 123   0.00082052
## Cycle 124   0.00069952
## Cycle 125   0.00059610
## Cycle 126   0.00050776
## Cycle 127   0.00043233
## Cycle 128   0.00036795
## Cycle 129   0.00031302
## Cycle 130   0.00026619
## Cycle 131   0.00022627
## Cycle 132   0.00019227
## Cycle 133   0.00016331
## Cycle 134   0.00013865
## Cycle 135   0.00011767
## Cycle 136   0.00009983
## Cycle 137   0.00008466
## Cycle 138   0.00007177
## Cycle 139   0.00006082
## Cycle 140   0.00005152
## Cycle 141   0.00004363
## Cycle 142   0.00003693
## Cycle 143   0.00003125
```

```r
v_tc_Exp
```

```
##                 [,1]
## Cycle 1   2330.82820
## Cycle 2   2304.75826
## Cycle 3   2262.84642
## Cycle 4   2211.99246
## Cycle 5   2154.74092
## Cycle 6   2092.70293
## Cycle 7   2027.07052
## Cycle 8   1958.79231
## Cycle 9   1888.65276
## Cycle 10  1817.31441
## Cycle 11  1745.34327
## Cycle 12  1673.22559
## Cycle 13  1601.37976
## Cycle 14  1530.16539
## Cycle 15  1459.89044
## Cycle 16  1390.81715
## Cycle 17  1323.16709
## Cycle 18  1257.12547
## Cycle 19  1192.84502
## Cycle 20  1130.44940
## Cycle 21  1070.03627
## Cycle 22  1011.68014
## Cycle 23   955.43483
## Cycle 24   901.33586
## Cycle 25   849.40251
## Cycle 26   799.63976
## Cycle 27   752.04007
## Cycle 28   706.58497
## Cycle 29   663.24654
## Cycle 30   621.98876
## Cycle 31   582.76867
## Cycle 32   545.53756
## Cycle 33   510.24189
## Cycle 34   476.82424
## Cycle 35   445.22410
## Cycle 36   415.37861
## Cycle 37   387.22320
## Cycle 38   360.69220
## Cycle 39   335.71929
## Cycle 40   312.23804
## Cycle 41   290.18224
## Cycle 42   269.48626
## Cycle 43   250.08537
## Cycle 44   231.91599
## Cycle 45   214.91587
## Cycle 46   199.02434
## Cycle 47   184.18241
## Cycle 48   170.33288
## Cycle 49   157.42049
## Cycle 50   145.39194
## Cycle 51   134.19595
## Cycle 52   123.78333
## Cycle 53   114.10695
## Cycle 54   105.12174
## Cycle 55    96.78471
## Cycle 56    89.05494
## Cycle 57    81.89347
## Cycle 58    75.26336
## Cycle 59    69.12958
## Cycle 60    63.45895
## Cycle 61    58.22016
## Cycle 62    53.38363
## Cycle 63    48.92146
## Cycle 64    44.80743
## Cycle 65    41.01686
## Cycle 66    37.52656
## Cycle 67    34.31481
## Cycle 68    31.36122
## Cycle 69    28.64675
## Cycle 70    26.15355
## Cycle 71    23.86498
## Cycle 72    21.76551
## Cycle 73    19.84064
## Cycle 74    18.07689
## Cycle 75    16.46170
## Cycle 76    14.98341
## Cycle 77    13.63118
## Cycle 78    12.39495
## Cycle 79    11.26540
## Cycle 80    10.23388
## Cycle 81     9.29239
## Cycle 82     8.43355
## Cycle 83     7.65051
## Cycle 84     6.93695
## Cycle 85     6.28705
## Cycle 86     5.69543
## Cycle 87     5.15715
## Cycle 88     4.66764
## Cycle 89     4.22271
## Cycle 90     3.81850
## Cycle 91     3.45146
## Cycle 92     3.11833
## Cycle 93     2.81614
## Cycle 94     2.54214
## Cycle 95     2.29381
## Cycle 96     2.06886
## Cycle 97     1.86518
## Cycle 98     1.68085
## Cycle 99     1.51411
## Cycle 100    1.36334
## Cycle 101    1.22708
## Cycle 102    1.10399
## Cycle 103    0.99284
## Cycle 104    0.89252
## Cycle 105    0.80202
## Cycle 106    0.72041
## Cycle 107    0.64684
## Cycle 108    0.58056
## Cycle 109    0.52087
## Cycle 110    0.46713
## Cycle 111    0.41877
## Cycle 112    0.37528
## Cycle 113    0.33617
## Cycle 114    0.30103
## Cycle 115    0.26946
## Cycle 116    0.24111
## Cycle 117    0.21566
## Cycle 118    0.19282
## Cycle 119    0.17234
## Cycle 120    0.15398
## Cycle 121    0.13752
## Cycle 122    0.12278
## Cycle 123    0.10958
## Cycle 124    0.09776
## Cycle 125    0.08719
## Cycle 126    0.07773
## Cycle 127    0.06928
## Cycle 128    0.06172
## Cycle 129    0.05496
## Cycle 130    0.04893
## Cycle 131    0.04355
## Cycle 132    0.03874
## Cycle 133    0.03446
## Cycle 134    0.03063
## Cycle 135    0.02723
## Cycle 136    0.02419
## Cycle 137    0.02148
## Cycle 138    0.01907
## Cycle 139    0.01693
## Cycle 140    0.01502
## Cycle 141    0.01332
## Cycle 142    0.01181
## Cycle 143    0.01047
```

```r
# The below is how I would probably add a once off treatment cost in if I had to:

# v_tc_SoC  <- m_M_SoC  %*% c(c_H, c_S, c_D)  
# v_tc_trtA <- m_M_trtA %*% c(c_H + c_trtA, c_S, c_D)  
# v_tc_trtB <- m_M_trtB %*% c(c_H + c_trtB, c_S, c_D)





# calculate expected QALYs by multiplying cohort trace with the utilities for the different health states 

# The vector of utilities is basically built in the exact same way as the vector of costs above:

# v_tu_SoC  <- m_M_SoC  %*% c(u_H, u_S, u_D)  


# The file I am mirroring has the following qoute:

# "

# - note that to obtain QALYs, the utility needs to be mutiplied by the cycle length as well


# v_tu_SoC <- m_M_SoC %*% c(u_F, u_P, u_D) * t_cycle
# v_tu_Exp <- m_M_Exp %*% c(u_F, u_P, u_D) * t_cycle

# To get the QALY's we not only need to multiply the state occupancy with the utilities, but also with the duration of the time cycle, because QALY's are 2-dimensional in that they combine the duration of time and the health utility.

# "

# Maybe that's because the utility originally came from a year in the disease state, and we want it to reflect the proportion of a year that is our cycle length?

# So in the example t_cycle <- 1/4 # cycle length of 3 months (in years) - so maybe their utility originally came from a years utility and they wanted to decrease it to 3 months, aka the cycle lengths, utility.

# If that was the case it would be:

# A year of utility in this state is 0.75, so 3 months should be a quarter of this, should be 0.25 of this. So, t_cycle (0.25) * u_F (0.75) = 0.1875 i.e. your utility for 3 months if u_F is your utility for 12 months.

# v_tu_SoC <- m_M_SoC %*% c(u_F, u_P, u_D) * t_cycle

# I did the maths on his approach, and without *t_cycle the first cycle of each utility value is 0.8, but after *t_cycle it is 0.2, i.e. a quarter of what it was before. Which is why I think again that he is just making the yearly utility lower to match the 3 monthly cycles, i.e. quartering a yearly utility. A quarter of utility for a quarter of a year.

# So, I think he's just trying to generate the QALYs per cycle in both states.

# And slide 25 of C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Health Economic Modeling in R A Hands-on Introduction\Health-Eco\Markov models kind of proves that.

# In it they say: cycles are 6 months.

# Their R code in: 

# C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Health Economic Modeling in R A Hands-on Introduction\Health-Eco\Markov models\markov_smoking_deterministic.R

# Says:

# Now define the QALYS associated with the states per cycle

# QALY associated with 1 - year in the smoking state is Normal(mean = 0.95,  SD = 0.01)
# Divide by 2 as cycle length is 6 months
# state_qalys["Smoking"] <-  0.95 / 2 [I know they divide by 2 but we could have also multiplied by a half, i.e. *0.05].

# QALY associated with 1 - year in the not smoking state is 1 (no uncertainty)
# So all PSA samples have the same value
# Again divide by 2 as cycle length is 6 months
# state_qalys["Not smoking"] <-  1.0 / 2

# I like their approach, they define utility at the start, then they can do the following:

		# Now use the cohort vectors to calculate the 
		# total QALYs for each cycle
		# cycle_qalys[i_treatment, ] <-  cohort_vectors[i_treatment, , ] %*% state_qalys[]

# i.e., take the cohort (or Markov trace) for each of the treatment options and multiply it by the state qalys.

# So, I could take where he says: "QALY's are 2-dimensional in that they combine the duration of time and the health utility." as saying "we need to give the patient a utility for this health state that matches how long they were in this health state, i.e., if the utility of one year in this state is x and we know the patient was in this health state for 2 weeks, then we need to give them 2 weeks of x as their utility."


# Andrew calculated QALYs as: 
#
# QALYs.SP0 <- trace.SP0%*%state.utilities
# QALYs.SP0
# 
# undisc.QALYs.SP0 <- colSums(QALYs.SP0)
# undisc.QALYs.SP0

# However, he described the values that he started off with as:

# The quality of life utilities of a year spent in each of the model health states has been
# estimated to be 0.85, 0.3 and 0.75 for the Successful primary, Revision, and Successful revision health states respectively.

# and said the cycle length is one year, so maybe that's why he doesnt need to multiply by the time passed, because his utilities are for a year spent in this state, whereas when we start our utilies may not necessarily match.

# So, what I think this means is that provided utilities are for the period of the cycle we can do the below, and if they are not for the period of the cycle then we can just convert them like in the smoking file above and then apply them as though they are for the period of the cycle:




v_tu_SoC <- m_M_SoC %*% c(u_F_SoC, u_P, u_D)
v_tu_Exp <- m_M_Exp %*% c(u_F_Exp, u_P, u_D)

v_tu_SoC
```

```
##                    [,1]
## Cycle 1   0.36911250000
## Cycle 2   0.37152532212
## Cycle 3   0.37380813765
## Cycle 4   0.37455093073
## Cycle 5   0.37339161497
## Cycle 6   0.37026814369
## Cycle 7   0.36526071093
## Cycle 8   0.35852361697
## Cycle 9   0.35024893061
## Cycle 10  0.34064506422
## Cycle 11  0.32992349860
## Cycle 12  0.31829039987
## Cycle 13  0.30594135639
## Cycle 14  0.29305818610
## Cycle 15  0.27980715316
## Cycle 16  0.26633815762
## Cycle 17  0.25278460046
## Cycle 18  0.23926371550
## Cycle 19  0.22587721924
## Cycle 20  0.21271217070
## Cycle 21  0.19984196228
## Cycle 22  0.18732738394
## Cycle 23  0.17521771760
## Cycle 24  0.16355183091
## Cycle 25  0.15235924731
## Cycle 26  0.14166117640
## Cycle 27  0.13147149326
## Cycle 28  0.12179765925
## Cycle 29  0.11264157987
## Cycle 30  0.10400039729
## Cycle 31  0.09586721703
## Cycle 32  0.08823176965
## Cycle 33  0.08108100900
## Cycle 34  0.07439964965
## Cycle 35  0.06817064642
## Cycle 36  0.06237561927
## Cycle 37  0.05699522722
## Cycle 38  0.05200949482
## Cycle 39  0.04739809502
## Cycle 40  0.04314059192
## Cycle 41  0.03921664710
## Cycle 42  0.03560619293
## Cycle 43  0.03228957619
## Cycle 44  0.02924767507
## Cycle 45  0.02646199252
## Cycle 46  0.02391472876
## Cycle 47  0.02158883536
## Cycle 48  0.01946805336
## Cycle 49  0.01753693752
## Cycle 50  0.01578086875
## Cycle 51  0.01418605633
## Cycle 52  0.01273953173
## Cycle 53  0.01142913534
## Cycle 54  0.01024349738
## Cycle 55  0.00917201429
## Cycle 56  0.00820482135
## Cycle 57  0.00733276269
## Cycle 58  0.00654735919
## Cycle 59  0.00584077514
## Cycle 60  0.00520578410
## Cycle 61  0.00463573445
## Cycle 62  0.00412451516
## Cycle 63  0.00366652186
## Cycle 64  0.00325662380
## Cycle 65  0.00289013162
## Cycle 66  0.00256276632
## Cycle 67  0.00227062946
## Cycle 68  0.00201017467
## Cycle 69  0.00177818061
## Cycle 70  0.00157172536
## Cycle 71  0.00138816226
## Cycle 72  0.00122509720
## Cycle 73  0.00108036742
## Cycle 74  0.00095202160
## Cycle 75  0.00083830143
## Cycle 76  0.00073762445
## Cycle 77  0.00064856815
## Cycle 78  0.00056985532
## Cycle 79  0.00050034048
## Cycle 80  0.00043899749
## Cycle 81  0.00038490808
## Cycle 82  0.00033725143
## Cycle 83  0.00029529457
## Cycle 84  0.00025838368
## Cycle 85  0.00022593610
## Cycle 86  0.00019743315
## Cycle 87  0.00017241352
## Cycle 88  0.00015046731
## Cycle 89  0.00013123070
## Cycle 90  0.00011438099
## Cycle 91  0.00009963230
## Cycle 92  0.00008673152
## Cycle 93  0.00007545481
## Cycle 94  0.00006560434
## Cycle 95  0.00005700546
## Cycle 96  0.00004950409
## Cycle 97  0.00004296442
## Cycle 98  0.00003726683
## Cycle 99  0.00003230606
## Cycle 100 0.00002798955
## Cycle 101 0.00002423598
## Cycle 102 0.00002097395
## Cycle 103 0.00001814084
## Cycle 104 0.00001568172
## Cycle 105 0.00001354853
## Cycle 106 0.00001169915
## Cycle 107 0.00001009678
## Cycle 108 0.00000870922
## Cycle 109 0.00000750839
## Cycle 110 0.00000646973
## Cycle 111 0.00000557186
## Cycle 112 0.00000479613
## Cycle 113 0.00000412630
## Cycle 114 0.00000354822
## Cycle 115 0.00000304960
## Cycle 116 0.00000261976
## Cycle 117 0.00000224939
## Cycle 118 0.00000193045
## Cycle 119 0.00000165593
## Cycle 120 0.00000141976
## Cycle 121 0.00000121671
## Cycle 122 0.00000104220
## Cycle 123 0.00000089231
## Cycle 124 0.00000076363
## Cycle 125 0.00000065320
## Cycle 126 0.00000055849
## Cycle 127 0.00000047730
## Cycle 128 0.00000040773
## Cycle 129 0.00000034815
## Cycle 130 0.00000029714
## Cycle 131 0.00000025350
## Cycle 132 0.00000021618
## Cycle 133 0.00000018427
## Cycle 134 0.00000015701
## Cycle 135 0.00000013372
## Cycle 136 0.00000011384
## Cycle 137 0.00000009688
## Cycle 138 0.00000008241
## Cycle 139 0.00000007007
## Cycle 140 0.00000005956
## Cycle 141 0.00000005061
## Cycle 142 0.00000004298
## Cycle 143 0.00000003649
```

```r
v_tu_Exp
```

```
##                  [,1]
## Cycle 1   0.670480000
## Cycle 2   0.668219681
## Cycle 3   0.663627555
## Cycle 4   0.656831199
## Cycle 5   0.647963345
## Cycle 6   0.637199952
## Cycle 7   0.624740387
## Cycle 8   0.610793030
## Cycle 9   0.595565921
## Cycle 10  0.579260810
## Cycle 11  0.562069449
## Cycle 12  0.544171393
## Cycle 13  0.525732808
## Cycle 14  0.506905978
## Cycle 15  0.487829273
## Cycle 16  0.468627437
## Cycle 17  0.449412092
## Cycle 18  0.430282369
## Cycle 19  0.411325628
## Cycle 20  0.392618216
## Cycle 21  0.374226251
## Cycle 22  0.356206392
## Cycle 23  0.338606609
## Cycle 24  0.321466911
## Cycle 25  0.304820059
## Cycle 26  0.288692236
## Cycle 27  0.273103679
## Cycle 28  0.258069282
## Cycle 29  0.243599149
## Cycle 30  0.229699117
## Cycle 31  0.216371241
## Cycle 32  0.203614240
## Cycle 33  0.191423912
## Cycle 34  0.179793513
## Cycle 35  0.168714107
## Cycle 36  0.158174884
## Cycle 37  0.148163454
## Cycle 38  0.138666106
## Cycle 39  0.129668054
## Cycle 40  0.121153649
## Cycle 41  0.113106576
## Cycle 42  0.105510027
## Cycle 43  0.098346861
## Cycle 44  0.091599735
## Cycle 45  0.085251232
## Cycle 46  0.079283970
## Cycle 47  0.073680689
## Cycle 48  0.068424339
## Cycle 49  0.063498147
## Cycle 50  0.058885677
## Cycle 51  0.054570880
## Cycle 52  0.050538138
## Cycle 53  0.046772292
## Cycle 54  0.043258675
## Cycle 55  0.039983129
## Cycle 56  0.036932022
## Cycle 57  0.034092255
## Cycle 58  0.031451269
## Cycle 59  0.028997049
## Cycle 60  0.026718118
## Cycle 61  0.024603535
## Cycle 62  0.022642887
## Cycle 63  0.020826280
## Cycle 64  0.019144326
## Cycle 65  0.017588133
## Cycle 66  0.016149288
## Cycle 67  0.014819845
## Cycle 68  0.013592305
## Cycle 69  0.012459605
## Cycle 70  0.011415094
## Cycle 71  0.010452526
## Cycle 72  0.009566030
## Cycle 73  0.008750105
## Cycle 74  0.007999595
## Cycle 75  0.007309675
## Cycle 76  0.006675835
## Cycle 77  0.006093862
## Cycle 78  0.005559824
## Cycle 79  0.005070057
## Cycle 80  0.004621149
## Cycle 81  0.004209924
## Cycle 82  0.003833430
## Cycle 83  0.003488924
## Cycle 84  0.003173862
## Cycle 85  0.002885882
## Cycle 86  0.002622799
## Cycle 87  0.002382588
## Cycle 88  0.002163376
## Cycle 89  0.001963431
## Cycle 90  0.001781154
## Cycle 91  0.001615069
## Cycle 92  0.001463813
## Cycle 93  0.001326133
## Cycle 94  0.001200871
## Cycle 95  0.001086963
## Cycle 96  0.000983432
## Cycle 97  0.000889377
## Cycle 98  0.000803972
## Cycle 99  0.000726459
## Cycle 100 0.000656140
## Cycle 101 0.000592379
## Cycle 102 0.000534591
## Cycle 103 0.000482240
## Cycle 104 0.000434836
## Cycle 105 0.000391931
## Cycle 106 0.000353116
## Cycle 107 0.000318016
## Cycle 108 0.000286290
## Cycle 109 0.000257626
## Cycle 110 0.000231741
## Cycle 111 0.000208374
## Cycle 112 0.000187289
## Cycle 113 0.000168273
## Cycle 114 0.000151129
## Cycle 115 0.000135679
## Cycle 116 0.000121762
## Cycle 117 0.000109231
## Cycle 118 0.000097953
## Cycle 119 0.000087806
## Cycle 120 0.000078680
## Cycle 121 0.000070477
## Cycle 122 0.000063106
## Cycle 123 0.000056485
## Cycle 124 0.000050540
## Cycle 125 0.000045205
## Cycle 126 0.000040418
## Cycle 127 0.000036125
## Cycle 128 0.000032276
## Cycle 129 0.000028827
## Cycle 130 0.000025738
## Cycle 131 0.000022972
## Cycle 132 0.000020495
## Cycle 133 0.000018280
## Cycle 134 0.000016298
## Cycle 135 0.000014526
## Cycle 136 0.000012942
## Cycle 137 0.000011527
## Cycle 138 0.000010263
## Cycle 139 0.000009135
## Cycle 140 0.000008128
## Cycle 141 0.000007230
## Cycle 142 0.000006428
## Cycle 143 0.000005714
```

```r
# BUT, we need to remember that the above displays the amount of utilitie's gathered in each cycle.

sum(v_tu_SoC)
```

```
## [1] 8.923
```

```r
sum(v_tu_Exp)
```

```
## [1] 17.3
```

```r
# Particularly, these are quality adjusted cycles, these are quality adjusted life years where cycles are annual, so I need to consider what this means for utility where cycles are monthly, or fortnightly.

# When I calculate the QALYs above, I don’t convert these quality adjusted cycles to years. If I sum each of v_tu_SoC and v_tu_Exp I get 16.7 quality adjusted cycles in the SoC arm and 21.1 quality adjusted cycles in the Exp arm. I can convert these quality adjusted cycles to years for fortnights by working out how many fortnights there are in a year (26.0714) and then divide by this number. These correspond to 0.64 and 0.81 QALYs respectively so 0.17 QALYs gained.

v_tu_SoC <- v_tu_SoC/26.0714
v_tu_Exp <- v_tu_Exp/26.0714

# So, these are initially per-cycle utility values, but, our cycles aren't years, they are fortnights, so these are per fortnight values, if we want this value to reflect the per year value, so that we have a quality adjusted life year, or QALY, then we need to adjust this utility value by how many of these fortnights there are in a year (26.0714), that is divide by how many fortnights there are in a year to bring the per fortnight value to a per year value


# James, I'd like your thoughts on what I've done here and whether this seems reasonable.


sum(v_tu_SoC)
```

```
## [1] 0.3423
```

```r
sum(v_tu_Exp)
```

```
## [1] 0.6635
```

```r
# QALYS Gained:

Qalys_gained <- v_tu_Exp - v_tu_SoC
sum(Qalys_gained)
```

```
## [1] 0.3213
```

```r
# You can see above that there are no utility differences between the different treatments considered: c(u_H, u_S, u_D), it's just different utilities per the health states people are in.

# If we did want to do different utilities for the health state you are in per the treatment you are on, we could define this in the input parameters and then add this in above when creating the vector of utilities for that treatment.

sum(v_tc_SoC)
```

```
## [1] 17935
```

```r
sum(v_tc_Exp)
```

```
## [1] 51787
```

```r
# The question is, should I be making that similar conversion of cycles to years for costs? I could do this as below: 

# v_tc_SoC <- v_tc_SoC/26.0714
# v_tc_Exp <- v_tc_Exp/26.0714
# 
# sum(v_tc_SoC)
# sum(v_tc_Exp)


# But, I assume my costs could be correct, if I correctly defined my costs per cycle.

# This is probably where I would like some feedback, is the manner in which I generate my costs (particularly) and QALYs above, correct?


# Reviewing the literature, the fact that: Goldstein, D. A., Chen, Q., Ayer, T., Howard, D. H., Lipscomb, J., El-Rayes, B. F., & Flowers, C. R. (2015). First-and second-line bevacizumab in addition to chemotherapy for metastatic colorectal cancer: a United States–based cost-effectiveness analysis. Journal of Clinical Oncology, 33(10), 1112. has similar costs, QALYS and Life Years gained and reports similar ICERs (the $352,734/QALY in the UK, which is similar to my own several hundred thousand per QALY without dividing costs by 26.0714 and dissimilar to my ~18,000 per QALY when I divide costs by 26.0714 makes me think I shouldnt be dividing costs by 26.0714).
```


```r
#07.2 Discounted Mean Costs and QALYs

# Finally, we'll aggregate these costs and utilities into overall discounted mean (average) costs and utilities.

# Obtain the discounted costs and QALYs by multiplying the vectors of total cost and total utility we created above by the discount rate for each cycle:

# Its important to remember what scale I'm on when I applied my discounting formula.
# If I set d_e<-0 then my code estimates 16.7 and 21.1 QALYs in each group which must be the quality adjusted cycles.

# Setting the discount rate back to 4% gives me 1.97 and 1.98 QALYs (which are really QA-cycles).

# Looking at the discounting vector I have defined below, I have converted cycles to days but I need to convert the discount rate to a daily discount. If I don't, the result is that discounting reduces the cycles dramatically which reduces the difference which increases with time.

# I can adress this by defining the discount rate as divided by 365 (i.e. the number of days in a year) then the results become 16.4 and 20.6 QA-cycles which of course become 0.63 and 0.79 QALYs respectively, or 0.16 QALYs gained.

d_c <- d_c/365
d_e <- d_e/365

# - Then, the discount rate for each cycle needs to be defined accounting for the cycle length, as below:


v_dwc <- 1 / ((1 + d_c) ^ ((0:(n_cycle-1)) * t_cycle)) 
v_dwe <- 1 / ((1 + d_e) ^ ((0:(n_cycle-1)) * t_cycle))


# So, below we take the vector of costs, transposing it [the t() bit] to make it a 1 row matrix and using matrix multiplication [%*%] to multiply it by that discount factor vector, which is what you multiply by the outcome in each cycle to get the discounted value of the outcome for that cycle, and then it will all be summed all together across all cycles [across all cells of the 1 row matrix]. Giving you tc_d_SoC which is a scalar, or a single value, which is the lifetime expected cost for an average person under standard of care in this cohort. 

# Discount costs by multiplying the cost vector with discount weights (v_dwc) 
# tc_d_SoC  <-  t(v_tc_SoC)  %*% v_dwc
# tc_d_trtA <-  t(v_tc_trtA) %*% v_dwc
# tc_d_trtB <-  t(v_tc_trtB) %*% v_dwc

tc_d_SoC <-  t(v_tc_SoC) %*% v_dwc 
tc_d_Exp <-  t(v_tc_Exp) %*% v_dwc


# So, now we have the average cost per person for treatment with standard of care, and the experimental treatment. 


# Discount QALYS by multiplying the QALYs vector with discount weights (v_dwe) [probably utilities would have been a better term here, if I hadnt of updated it from fortnightly health state quality of life, to yearly health state quality of life]

tu_d_SoC <-  t(v_tu_SoC) %*% v_dwe
tu_d_Exp <-  t(v_tu_Exp) %*% v_dwe


# Store them into a vector -> So, we'll take the single values for cost for an average person under standard of care and the experimental treatment and store them in a vector v_tc_d:
v_tc_d <- c(tc_d_SoC, tc_d_Exp)
v_tu_d <- c(tu_d_SoC, tu_d_Exp)

v_tc_d
```

```
## [1] 17591 50540
```

```r
v_tu_d
```

```
## [1] 0.3346 0.6462
```

```r
# To make things a little easier to read we might name these values what they are costs for, so we can use the vector of strategy names [v_names_str] to name the values:

names (v_tc_d) <- v_names_strats
v_tc_d
```

```
##       Standard of Care Experimental Treatment 
##                  17591                  50540
```

```r
names (v_tu_d) <- v_names_strats
v_tu_d
```

```
##       Standard of Care Experimental Treatment 
##                 0.3346                 0.6462
```

```r
Discounted_Qalys_gained <- tu_d_Exp - tu_d_SoC
sum(Discounted_Qalys_gained)
```

```
## [1] 0.3115
```

```r
# For utility, the utility values aren't different for the different states depending on the treatment strategy, i.e. SOC, Experimental Treatment, but the time spent in the states with the associated utility is different due to the treatment you're on, so your utility value will be higher if the treatment keeps you well for longer so that you stay in a higher utility state for longer than a lower utility state, i.e., progression.


# Dataframe with discounted costs and effectiveness

# So then we aggregate them into a dataframe with our discounted costs and utilities, and then we use this to calculate ICERs in: ## 07.3 Compute ICERs of the Markov model

# df_ce <- data.frame(Strategy = v_names_strats,
#                     Cost     = v_tc_d, 
#                     Effect   = v_tu_d)
# df_ce
```


```r
#07.3 Compute ICERs of the Markov model

# The discounted costs and QALYs can be summarized and visualized using functions from the 'dampack' package
(df_cea <- calculate_icers(cost       = c(tc_d_SoC, tc_d_Exp),
                           effect     = c(tu_d_SoC, tu_d_Exp),
                           strategies = v_names_strats))
```

```
##                 Strategy  Cost Effect Inc_Cost Inc_Effect   ICER Status
## 1       Standard of Care 17591 0.3346       NA         NA     NA     ND
## 2 Experimental Treatment 50540 0.6462    32949     0.3115 105767     ND
```

```r
df_cea
```

```
##                 Strategy  Cost Effect Inc_Cost Inc_Effect   ICER Status
## 1       Standard of Care 17591 0.3346       NA         NA     NA     ND
## 2 Experimental Treatment 50540 0.6462    32949     0.3115 105767     ND
```

```r
# df_cea <- calculate_icers(cost       = df_ce$Cost,
#                           effect     = df_ce$Effect,
#                           strategies = df_ce$Strategy
#                           )
# df_cea

# The above uses the DARTHtools package to calculate our ICERS, incremental cost and incremental effectiveness, and also describes dominance status:

# This uses the "calculate_icers function", which does all the sorting, all the prioritization, and then computes the dominance, and not dominance, etc., and there's a publication on the methods behind this, based on a method from colleagues in Stanford.

# The default view is ordered by dominance status (ND = non-dominated, ED = extended/weak dominance, or D= strong dominance), and then ascending by cost per: https://cran.r-project.org/web/packages/dampack/vignettes/basic_cea.html


# The icer object can be easily formatted into a publication quality table using the kableExtra package, as below, but there's probably a better way to do this per Dampack just under:

# library(kableExtra)
# library(dplyr)
# df_cea %>%
#  kable() %>%
#  kable_styling()


## CEA table in proper format ---- per: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\R-HTA in LMICs Intermediate R-HTA Modelling Tutorial\September-Workshop-main\September-Workshop-main\analysis\cSTM_time_dep_simulation.r
table_cea <- format_table_cea(df_cea) # Function included in "R/Functions.R"; depends on the `scales` package
table_cea
```

```
##                 Strategy Costs ($) QALYs Incremental Costs ($) Incremental QALYs
## 1       Standard of Care    17,591  0.33                  <NA>                NA
## 2 Experimental Treatment    50,540  0.65                32,949              0.31
##   ICER ($/QALY) Status
## 1          <NA>     ND
## 2       105,767     ND
```

```r
# I create a parameter "ICER" to pull the ICER value straight out of the table, I select ($) ICER from df_cea and then pick the 2nd entry in this ICER parameter, so that I'm getting the number rather than the NA, i.e.:

# > df_cea$ICER
# [1]       NA 173845.8

# Below I create Incremental_Cost, Incremental_Effect and ICER to include in the leauge table in the paper. I take the incremental cost and ICER from the table_cea because that applies a nice format with a comma for the thousands, etc., I also use "noqoute" to take the qoute marks away when this is made. I use df_cea because I want to round Incremental_Effect and then do round to 3 digits.

Incremental_Cost<- noquote(table_cea$"Incremental Costs"[2])
Incremental_Effect<- round(df_cea$Inc_Effect[2], digits=3)
ICER<- noquote(table_cea$"ICER"[2])
```


```r
#07.4 Plot frontier of the Markov model

plot(df_cea, effect_units = "QALYs", label = "all")
```

<img src="Markov_3state_files/figure-html/unnamed-chunk-33-1.png" width="672" />

```r
ggsave(paste("Frontier_Markov_Model_", country_name[1], ".png", sep = ""), width = 8, height = 4, dpi=300)



while (!is.null(dev.list()))  dev.off()
# png(paste("Markov_Cohort_Traces", ".png"))
# dev.off()

# plot(df_cea, effect_units = "QALYs")


# When we plot it we have 2 strategies it is possible that something would be off the frontier, would be weakly dominated or strongly dominated, with just a few strategies it's not necessarily that impressive, but with lots of strategies then dampack can be helpful.
```


```r
#08.1 Load Markov model function

#08.3 One-way sensitivity analysis (OWSA)

# A brief note on how parameters are varied one at a time:

# A simple one-way DSA starts with choosing a model parameter to be investigated. Next, the modeler specifies a range for this parameter and the number of evenly spaced points along this range at which to evaluate model outcomes. The model is then run for each element of the vector of parameter values by setting the parameter of interest to the value, holding all other model parameters at their default base case values.

# To conduct the one-way DSA, we then call the function run_owsa_det with my_owsa_params_range, specifying the parameters to be varied and over which ranges, and my_params_basecase as the fixed parameter values to be used in the model when a parameter is not being explicitly varied in the one-way sensitivity analysis.


options(digits=4)

## Initialization ----

# Load the model as a function that is defined in the supporting script
# source("Functions_markov_3state.R")
# Test function
# calculate_ce_out(l_params_all)

source(file = "oncologySemiMarkov_function.R")
# If I change any code in this main model code file, I will also need to update the function that I call.


# Create list l_params_all with all input probabilities, costs, utilities, etc.,

# Test whether the function works (and generates the same results)
# - to do so, first a list of parameter values needs to be generated

# Now I update this list with the variables I have:

# If I updated utility for AE above, then I'll have to take that into account for u_F below:

l_params_all <- list(
  HR_FP_Exp = HR_FP_Exp,
  HR_FP_SoC = HR_FP_SoC,
  HR_PD_Exp = HR_PD_Exp,
  HR_PD_SoC = HR_PD_SoC,
  P_OSD_SoC = P_OSD_SoC,      
  P_OSD_Exp = P_OSD_Exp,
  p_FA1_STD = p_FA1_STD,
  p_FA2_STD = p_FA2_STD,
  p_FA3_STD = p_FA3_STD,
  p_FA1_EXPR = p_FA1_EXPR,
  p_FA2_EXPR = p_FA2_EXPR,
  p_FA3_EXPR = p_FA3_EXPR,
  administration_cost = administration_cost,
    #ITS FINE TO INCLUDE THE INGRIDENIENTS THAT MAKE UP c_F_SoC, c_F_Exp, c_P, but don't include c_F_SoC, c_F_Exp, c_P themsleves, BECAUSE WE ARE CHANGING WHAT BUILDS THESE COSTS WITH THE INGRIEDIENTS, SO WE DON'T WANT TO CHANGE IT AGAIN HERE ONCE WE'VE CHANGED WHAT BUILDS IT
  c_PFS_Folfox = c_PFS_Folfox,
  c_PFS_Bevacizumab = c_PFS_Bevacizumab,
  c_OS_Folfiri = c_OS_Folfiri,
  c_D       = c_D,    
  c_AE1 = c_AE1,
  c_AE2 = c_AE2,
  c_AE3 = c_AE3,
  u_F = u_F,   
  #ITS FINE TO INCLUDE U_F BUT DON'T INCLUDE U_F_SoC, BECAUSE WE ARE CHANGING WHAT BUILDS U_F_SoC WTH U_F AND AE1_DisUtil SO WE DON'T WANT TO CHANGE IT AGAIN HERE ONCE WE'VE CHANGED WHAT BUILDS IT
  u_P = u_P,   
  u_D = u_D,  
  AE1_DisUtil = AE1_DisUtil,
  AE2_DisUtil = AE2_DisUtil,
  AE3_DisUtil = AE3_DisUtil,
  d_e       = d_e,  
  d_c       = d_c,
  n_cycle   = n_cycle,
  t_cycle   = t_cycle
)

 
# Test function

# Test whether the function works (and generates the same results)

oncologySemiMarkov(l_params_all = l_params_all, n_wtp = n_wtp)
```

```
##                 Strategy  Cost Effect DSAICER
## 1       Standard of Care 17591 0.3346  105767
## 2 Experimental Treatment 50540 0.6462  105767
```

```r
# Entering parameter values:


UpperCI <- 0.87
LowerCI <- 0.53

HR_FP_Exp
```

```
## [1] 0.68
```

```r
Minimum_HR_FP_Exp <- LowerCI
Maximum_HR_FP_Exp <- UpperCI


HR_FP_SoC
```

```
## [1] 1
```

```r
Minimum_HR_FP_SoC <- HR_FP_SoC - 0.20*HR_FP_SoC
Maximum_HR_FP_SoC <- HR_FP_SoC + 0.20*HR_FP_SoC


# Now that we're using the OS curves, I add hazard ratios for PFS to dead that reflect the hazard ratio of the experimental strategy changing the probability of going from PFS to Death, and the hazard ratio of 1 that I apply in standard of care so that I can vary transition probabilities under standard of care in this one-way sensitivity analysis:

HR_PD_SoC
```

```
## [1] 1
```

```r
Minimum_HR_PD_SoC <- HR_PD_SoC - 0.20*HR_PD_SoC
Maximum_HR_PD_SoC <- HR_PD_SoC + 0.20*HR_PD_SoC


OS_UpperCI <- 0.86
OS_LowerCI <- 0.49
  
  
HR_PD_Exp
```

```
## [1] 0.65
```

```r
Minimum_HR_PD_Exp <- OS_LowerCI
Maximum_HR_PD_Exp <- OS_UpperCI








# Probability of progressive disease to death:

# Under the assumption that everyone will get the same second line therapy, I give them all the same probability of going from progessed (i.e., OS) to dead, and thus only need to include p_PD here once - because it is applied in oncologySemiMarkov_function.R for both SoC and Exp. ACTUALLY I THINK IT SHOULD BE P_OSD_SoC P_OSD_Exp BOTH INCLUDED.

P_OSD_SoC
```

```
## [1] 0.17
```

```r
Minimum_P_OSD_SoC <- 0.12
Maximum_P_OSD_SoC <- 0.22

P_OSD_Exp
```

```
## [1] 0.17
```

```r
Minimum_P_OSD_Exp <- 0.12
Maximum_P_OSD_Exp <- 0.22







# Probability of going from PFS to Death states under the standard of care treatment and the experimental treatment:

# # HR_PD_SoC and HR_PD_Exp address this as above:

# p_FD_SoC
# 
# Minimum_p_FD_SoC <- p_FD_SoC - 0.20*p_FD_SoC
# Maximum_p_FD_SoC <- p_FD_SoC + 0.20*p_FD_SoC
# 
# p_FD_Exp
# 
# Minimum_p_FD_Exp<- p_FD_Exp - 0.20*p_FD_Exp
# Maximum_p_FD_Exp <- p_FD_Exp + 0.20*p_FD_Exp



# Probability of Adverse Events:

p_FA1_STD
```

```
## [1] 0.04
```

```r
Minimum_p_FA1_STD <- p_FA1_STD - 0.20*p_FA1_STD
Maximum_p_FA1_STD <- p_FA1_STD + 0.20*p_FA1_STD

p_FA2_STD
```

```
## [1] 0.31
```

```r
Minimum_p_FA2_STD <- p_FA2_STD - 0.20*p_FA2_STD
Maximum_p_FA2_STD <- p_FA2_STD + 0.20*p_FA2_STD

p_FA3_STD
```

```
## [1] 0.31
```

```r
Minimum_p_FA3_STD <- p_FA3_STD - 0.20*p_FA3_STD
Maximum_p_FA3_STD <- p_FA3_STD + 0.20*p_FA3_STD


p_FA1_EXPR
```

```
## [1] 0.07
```

```r
Minimum_p_FA1_EXPR <- p_FA1_EXPR - 0.20*p_FA1_EXPR
Maximum_p_FA1_EXPR <- p_FA1_EXPR + 0.20*p_FA1_EXPR

p_FA2_EXPR
```

```
## [1] 0.11
```

```r
Minimum_p_FA2_EXPR <- p_FA2_EXPR - 0.20*p_FA2_EXPR
Maximum_p_FA2_EXPR <- p_FA2_EXPR + 0.20*p_FA2_EXPR

p_FA3_EXPR
```

```
## [1] 0.07
```

```r
Minimum_p_FA3_EXPR <- p_FA3_EXPR - 0.20*p_FA3_EXPR
Maximum_p_FA3_EXPR <- p_FA3_EXPR + 0.20*p_FA3_EXPR




# Cost:

# If I decide to include the cost of the test for patients I will also need to include this in the sensitivity analysis here:

administration_cost
```

```
## [1] 314.9
```

```r
Minimum_administration_cost <- administration_cost - 0.20*administration_cost
Maximum_administration_cost <- administration_cost + 0.20*administration_cost

c_PFS_Folfox
```

```
## [1] 285.5
```

```r
Minimum_c_PFS_Folfox  <- c_PFS_Folfox - 0.20*c_PFS_Folfox
Maximum_c_PFS_Folfox  <- c_PFS_Folfox + 0.20*c_PFS_Folfox

c_PFS_Bevacizumab 
```

```
## [1] 1326
```

```r
Minimum_c_PFS_Bevacizumab  <- c_PFS_Bevacizumab - 0.20*c_PFS_Bevacizumab
Maximum_c_PFS_Bevacizumab  <- c_PFS_Bevacizumab + 0.20*c_PFS_Bevacizumab

c_OS_Folfiri 
```

```
## [1] 139.6
```

```r
Minimum_c_OS_Folfiri  <- c_OS_Folfiri - 0.20*c_OS_Folfiri
Maximum_c_OS_Folfiri  <- c_OS_Folfiri + 0.20*c_OS_Folfiri

c_D  
```

```
## [1] 0
```

```r
Minimum_c_D  <- c_D - 0.20*c_D
Maximum_c_D  <- c_D + 0.20*c_D

c_AE1
```

```
## [1] 4886
```

```r
Minimum_c_AE1  <- c_AE1 - 0.20*c_AE1
Maximum_c_AE1  <- c_AE1 + 0.20*c_AE1

c_AE2
```

```
## [1] 507.4
```

```r
Minimum_c_AE2  <- c_AE2 - 0.20*c_AE2
Maximum_c_AE2  <- c_AE2 + 0.20*c_AE2

c_AE3
```

```
## [1] 95.03
```

```r
Minimum_c_AE3  <- c_AE3 - 0.20*c_AE3
Maximum_c_AE3  <- c_AE3 + 0.20*c_AE3


# Utilities:

u_F
```

```
## [1] 0.85
```

```r
Minimum_u_F <- 0.68
Maximum_u_F <- 1.00


u_P
```

```
## [1] 0.65
```

```r
Minimum_u_P <- 0.52
Maximum_u_P <- 0.78 


u_D
```

```
## [1] 0
```

```r
Minimum_u_D <- u_D - 0.20*u_D
Maximum_u_D <- u_D + 0.20*u_D 


AE1_DisUtil
```

```
## [1] 0.45
```

```r
Minimum_AE1_DisUtil <- AE1_DisUtil - 0.20*AE1_DisUtil
Maximum_AE1_DisUtil <- AE1_DisUtil + 0.20*AE1_DisUtil 


AE2_DisUtil
```

```
## [1] 0.19
```

```r
Minimum_AE2_DisUtil <- AE2_DisUtil - 0.20*AE2_DisUtil
Maximum_AE2_DisUtil <- AE2_DisUtil + 0.20*AE2_DisUtil 


AE3_DisUtil
```

```
## [1] 0.36
```

```r
Minimum_AE3_DisUtil <- AE3_DisUtil - 0.20*AE3_DisUtil
Maximum_AE3_DisUtil <- AE3_DisUtil + 0.20*AE3_DisUtil 


 
 
# Discount factor
# Cost Discount Factor
# Utility Discount Factor
# I divided these by 365 earlier in the R markdown document, so no need to do that again here:

d_e
```

```
## [1] 0.0001096
```

```r
Minimum_d_e <- 0
Maximum_d_e <- 0.08/365



d_c
```

```
## [1] 0.0001096
```

```r
Minimum_d_c <- 0
Maximum_d_c <- 0.08/365


# I am concerned that the min or max may go above 1 or below 0 in cases where parameter values should be bounded at 1 or 0, therefore, in such cases I say, replace the minimum I created with 0 or the maximum I created with 1, if the minimum is below 0 or the maximum is above 1:


HR_FP_Exp
```

```
## [1] 0.68
```

```r
Minimum_HR_FP_Exp<- replace(Minimum_HR_FP_Exp, Minimum_HR_FP_Exp<0, 0)
Maximum_HR_FP_Exp<- replace(Maximum_HR_FP_Exp, Maximum_HR_FP_Exp>1, 1)

HR_FP_SoC
```

```
## [1] 1
```

```r
Minimum_HR_FP_SoC<- replace(Minimum_HR_FP_SoC, Minimum_HR_FP_SoC<0, 0)
Maximum_HR_FP_SoC<- replace(Maximum_HR_FP_SoC, Maximum_HR_FP_SoC>1, 1)

HR_PD_SoC
```

```
## [1] 1
```

```r
Minimum_HR_PD_SoC<- replace(Minimum_HR_PD_SoC, Minimum_HR_PD_SoC<0, 0)
Maximum_HR_PD_SoC<- replace(Maximum_HR_PD_SoC, Maximum_HR_PD_SoC>1, 1)

HR_PD_Exp
```

```
## [1] 0.65
```

```r
Minimum_HR_PD_Exp<- replace(Minimum_HR_PD_Exp, Minimum_HR_PD_Exp<0, 0)
Maximum_HR_PD_Exp<- replace(Maximum_HR_PD_Exp, Maximum_HR_PD_Exp>1, 1)

P_OSD_SoC
```

```
## [1] 0.17
```

```r
Minimum_P_OSD_SoC<- replace(Minimum_P_OSD_SoC, Minimum_P_OSD_SoC<0, 0)
Maximum_P_OSD_SoC<- replace(Maximum_P_OSD_SoC, Maximum_P_OSD_SoC>1, 1)

P_OSD_Exp
```

```
## [1] 0.17
```

```r
Minimum_P_OSD_Exp<- replace(Minimum_P_OSD_Exp, Minimum_P_OSD_Exp<0, 0)
Maximum_P_OSD_Exp<- replace(Maximum_P_OSD_Exp, Maximum_P_OSD_Exp>1, 1)

p_FA1_STD
```

```
## [1] 0.04
```

```r
Minimum_p_FA1_STD<- replace(Minimum_p_FA1_STD, Minimum_p_FA1_STD<0, 0)
Maximum_p_FA1_STD<- replace(Maximum_p_FA1_STD, Maximum_p_FA1_STD>1, 1)

p_FA2_STD
```

```
## [1] 0.31
```

```r
Minimum_p_FA2_STD<- replace(Minimum_p_FA2_STD, Minimum_p_FA2_STD<0, 0)
Maximum_p_FA2_STD<- replace(Maximum_p_FA2_STD, Maximum_p_FA2_STD>1, 1)

p_FA3_STD
```

```
## [1] 0.31
```

```r
Minimum_p_FA3_STD<- replace(Minimum_p_FA3_STD, Minimum_p_FA3_STD<0, 0)
Maximum_p_FA3_STD<- replace(Maximum_p_FA3_STD, Maximum_p_FA3_STD>1, 1)

p_FA1_EXPR
```

```
## [1] 0.07
```

```r
Minimum_p_FA1_EXPR<- replace(Minimum_p_FA1_EXPR, Minimum_p_FA1_EXPR<0, 0)
Maximum_p_FA1_EXPR<- replace(Maximum_p_FA1_EXPR, Maximum_p_FA1_EXPR>1, 1)

p_FA2_EXPR
```

```
## [1] 0.11
```

```r
Minimum_p_FA2_EXPR<- replace(Minimum_p_FA2_EXPR, Minimum_p_FA2_EXPR<0, 0)
Maximum_p_FA2_EXPR<- replace(Maximum_p_FA2_EXPR, Maximum_p_FA2_EXPR>1, 1)

p_FA3_EXPR
```

```
## [1] 0.07
```

```r
Minimum_p_FA3_EXPR<- replace(Minimum_p_FA3_EXPR, Minimum_p_FA3_EXPR<0, 0)
Maximum_p_FA3_EXPR<- replace(Maximum_p_FA3_EXPR, Maximum_p_FA3_EXPR>1, 1)

u_F
```

```
## [1] 0.85
```

```r
Minimum_u_F<- replace(Minimum_u_F, Minimum_u_F<0, 0)
Maximum_u_F<- replace(Maximum_u_F, Maximum_u_F>1, 1)

u_P
```

```
## [1] 0.65
```

```r
Minimum_u_P<- replace(Minimum_u_P, Minimum_u_P<0, 0)
Maximum_u_P<- replace(Maximum_u_P, Maximum_u_P>1, 1)

AE1_DisUtil
```

```
## [1] 0.45
```

```r
Minimum_AE1_DisUtil<- replace(Minimum_AE1_DisUtil, Minimum_AE1_DisUtil<0, 0)
Maximum_AE1_DisUtil<- replace(Maximum_AE1_DisUtil, Maximum_AE1_DisUtil>1, 1)

AE2_DisUtil
```

```
## [1] 0.19
```

```r
Minimum_AE2_DisUtil<- replace(Minimum_AE2_DisUtil, Minimum_AE2_DisUtil<0, 0)
Maximum_AE2_DisUtil<- replace(Maximum_AE2_DisUtil, Maximum_AE2_DisUtil>1, 1)

AE3_DisUtil
```

```
## [1] 0.36
```

```r
Minimum_AE3_DisUtil<- replace(Minimum_AE3_DisUtil, Minimum_AE3_DisUtil<0, 0)
Maximum_AE3_DisUtil<- replace(Maximum_AE3_DisUtil, Maximum_AE3_DisUtil>1, 1)



# A one-way sensitivity analysis (OWSA) can be defined by specifying the names of the parameters that are to be incuded and their minimum and maximum values.


# We create a dataframe containing all parameters we want to do the sensitivity analysis on, and the min and max values of the parameters of interest 
# "min" and "max" are the mininum and maximum values of the parameters of interest.


# options(scipen = 999) # disabling scientific notation in R

df_params_OWSA <- data.frame(
  pars = c("HR_FP_Exp", "HR_FP_SoC", "HR_PD_SoC", "HR_PD_Exp", "P_OSD_SoC", "P_OSD_Exp", "p_FA1_STD", "p_FA2_STD", "p_FA3_STD", "p_FA1_EXPR", "p_FA2_EXPR", "p_FA3_EXPR", "administration_cost", "c_PFS_Folfox", "c_PFS_Bevacizumab", "c_OS_Folfiri", "c_AE1", "c_AE2", "c_AE3", "d_e", "d_c", "u_F", "u_P", "AE1_DisUtil", "AE2_DisUtil", "AE3_DisUtil"),   # names of the parameters to be changed
  min  = c(Minimum_HR_FP_Exp, Minimum_HR_FP_SoC, Minimum_HR_PD_SoC, Minimum_HR_PD_Exp, Minimum_P_OSD_SoC, Minimum_P_OSD_Exp, Minimum_p_FA1_STD, Minimum_p_FA2_STD, Minimum_p_FA3_STD, Minimum_p_FA1_EXPR, Minimum_p_FA2_EXPR, Minimum_p_FA3_EXPR, Minimum_administration_cost, Minimum_c_PFS_Folfox, Minimum_c_PFS_Bevacizumab, Minimum_c_OS_Folfiri, Minimum_c_AE1, Minimum_c_AE2, Minimum_c_AE3, Minimum_d_e, Minimum_d_c, Minimum_u_F, Minimum_u_P, Minimum_AE1_DisUtil, Minimum_AE2_DisUtil, Minimum_AE3_DisUtil),         # min parameter values
  max  = c(Maximum_HR_FP_Exp, Maximum_HR_FP_SoC, Maximum_HR_PD_SoC, Maximum_HR_PD_Exp, Maximum_P_OSD_SoC, Maximum_P_OSD_Exp, Maximum_p_FA1_STD, Maximum_p_FA2_STD, Maximum_p_FA3_STD, Maximum_p_FA1_EXPR, Maximum_p_FA2_EXPR, Maximum_p_FA3_EXPR, Maximum_administration_cost, Maximum_c_PFS_Folfox, Maximum_c_PFS_Bevacizumab, Maximum_c_OS_Folfiri, Maximum_c_AE1,  Maximum_c_AE2, Maximum_c_AE3, Maximum_d_e, Maximum_d_c, Maximum_u_F, Maximum_u_P, Maximum_AE1_DisUtil, Maximum_AE2_DisUtil, Maximum_AE3_DisUtil)          # max parameter values
)


# I made sure the names of the parameters to be varied and their mins and maxs are in the same order in all the brackets above in order to make sure that the min and max being applied are the min and the max of the parameter I want to consider a min and a max for.



# The OWSA is performed using the run_owsa_det function


# This function runs a deterministic one-way sensitivity analysis (OWSA) on a given function that produces outcomes. rdrr.io/github/DARTH-git/dampack/src/R/run_dsa.R

DSAICER  <- run_owsa_det(

# run_owsa_det: https://rdrr.io/github/DARTH-git/dampack/man/run_owsa_det.html

  # We need to make sure we consistently use "DSAICER" throughout, or else the function will present with an error saying "DSAICER" not found.  
   
# Arguments:
  
  params_range     = df_params_OWSA,     # dataframe with parameters for OWSA

# params_range	
# data.frame with 3 columns of parameters for OWSA in the following order: "pars", "min", and "max".
# The number of samples from this range is determined by nsamp. 
# "pars" are the parameters of interest and must be a subset of the parameters from params_basecase.


# Details
# params_range
 
# "pars" are the names of the input parameters of interest. These are the parameters that will be varied in the deterministic sensitivity analysis. variables in "pars" column must be a subset of variables in params_basecase
 

  
  params_basecase  = l_params_all,       # list with all parameters

# params_basecase	

# a named list of basecase values for input parameters needed by FUN, the user-defined function. So, I guess it takes the values that the parameters are equal to in l_params_all as the base case, so if cost is generated equal to 1,000 it'll take that as the base case, and then take the min and the max around this from the data.frame we created above.

# To conduct the one-way DSA, we then call the function run_owsa_det with my_owsa_params_range, specifying the parameters to be varied and over which ranges, and my_params_basecase as the fixed parameter values to be used in the model when a parameter is not being explicitly varied in the one-way sensitivity analysis. https://cran.r-project.org/web/packages/dampack/vignettes/dsa_generation.html

  nsamp            = 100,                # number of parameter values

# nsamp	

# number of sets of parameter values to be generated. If NULL, 100 parameter values are used -> I think Eva Enns said these are automatically evenly spaced out values of the parameters.

# Additional inputs are the number of equally-spaced samples (nsamp) to be used between the specified minimum and maximum of each range, the user-defined function (FUN) to be called to generate model outcomes for each strategy, the vector of outcomes to be stored (must be outcomes generated by the data frame output of the function passed in FUN), and the vector of strategy names to be evaluated.

# cran.r-project.org/web/packages/dampack/vignettes/dsa_generation.html

  FUN              = oncologySemiMarkov, # function to compute outputs

# FUN	
# function that takes the basecase in params_basecase and runs the analysis in the function... to produce the outcome of interest. The FUN must return a dataframe where the first column are the strategy names and the rest of the columns must be outcomes.
#  

 outcomes         = c("DSAICER"),           # output to do the OWSA on

# string vector with the outcomes of interest from FUN produced by nsamp
# This basically tells run_owsa_det what the name of the outcome of interest from the function we fed it is. Here our function previously had NMB, i.e., the net monetary benefit.

#  outcomes         = c("NMB"),           # output to do the OWSA on

# outcomes	

  strategies       = v_names_strats,       # names of the strategies

# strategies
# Set it equal to a vector of strategy names. The default NULL will use strategy names in FUN (  strategies = NULL,)
# Here that's "Standard of Care" and "Experimental Treatment".

  progress = TRUE,

# progress	
# TRUE or FALSE for whether or not function progress should be displayed in console, i.e., like 75% complete, 100%, etc.,

# The input progress = TRUE allows the user to see a progress bar as the DSA is conducted. When many parameters are being varied, nsamp is large, and/or the user-defined function is computationally burdensome, the DSA may take a noticeable amount of time to compute and the progress display is recommended.
# cran.r-project.org/web/packages/dampack/vignettes/dsa_generation.html


  n_wtp            = n_wtp               # extra argument to pass to FUN to specify the willingness to pay
)
```

```
## 
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |                                                                                  |   1%
  |                                                                                        
  |=                                                                                 |   1%
  |                                                                                        
  |=                                                                                 |   2%
  |                                                                                        
  |==                                                                                |   2%
  |                                                                                        
  |==                                                                                |   3%
  |                                                                                        
  |===                                                                               |   3%
  |                                                                                        
  |===                                                                               |   4%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |===                                                                               |   4%
  |                                                                                        
  |====                                                                              |   4%
  |                                                                                        
  |====                                                                              |   5%
  |                                                                                        
  |=====                                                                             |   6%
  |                                                                                        
  |=====                                                                             |   7%
  |                                                                                        
  |======                                                                            |   7%
  |                                                                                        
  |======                                                                            |   8%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |======                                                                            |   8%
  |                                                                                        
  |=======                                                                           |   8%
  |                                                                                        
  |=======                                                                           |   9%
  |                                                                                        
  |========                                                                          |   9%
  |                                                                                        
  |========                                                                          |  10%
  |                                                                                        
  |=========                                                                         |  10%
  |                                                                                        
  |=========                                                                         |  11%
  |                                                                                        
  |=========                                                                         |  12%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |=========                                                                         |  12%
  |                                                                                        
  |==========                                                                        |  12%
  |                                                                                        
  |==========                                                                        |  13%
  |                                                                                        
  |===========                                                                       |  13%
  |                                                                                        
  |===========                                                                       |  14%
  |                                                                                        
  |============                                                                      |  14%
  |                                                                                        
  |============                                                                      |  15%
  |                                                                                        
  |=============                                                                     |  15%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |=============                                                                     |  15%
  |                                                                                        
  |=============                                                                     |  16%
  |                                                                                        
  |==============                                                                    |  16%
  |                                                                                        
  |==============                                                                    |  17%
  |                                                                                        
  |==============                                                                    |  18%
  |                                                                                        
  |===============                                                                   |  18%
  |                                                                                        
  |===============                                                                   |  19%
  |                                                                                        
  |================                                                                  |  19%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |================                                                                  |  19%
  |                                                                                        
  |================                                                                  |  20%
  |                                                                                        
  |=================                                                                 |  20%
  |                                                                                        
  |=================                                                                 |  21%
  |                                                                                        
  |==================                                                                |  21%
  |                                                                                        
  |==================                                                                |  22%
  |                                                                                        
  |==================                                                                |  23%
  |                                                                                        
  |===================                                                               |  23%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |===================                                                               |  23%
  |                                                                                        
  |===================                                                               |  24%
  |                                                                                        
  |====================                                                              |  24%
  |                                                                                        
  |====================                                                              |  25%
  |                                                                                        
  |=====================                                                             |  25%
  |                                                                                        
  |=====================                                                             |  26%
  |                                                                                        
  |======================                                                            |  26%
  |                                                                                        
  |======================                                                            |  27%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |======================                                                            |  27%
  |                                                                                        
  |=======================                                                           |  27%
  |                                                                                        
  |=======================                                                           |  28%
  |                                                                                        
  |=======================                                                           |  29%
  |                                                                                        
  |========================                                                          |  29%
  |                                                                                        
  |========================                                                          |  30%
  |                                                                                        
  |=========================                                                         |  30%
  |                                                                                        
  |=========================                                                         |  31%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |=========================                                                         |  31%
  |                                                                                        
  |==========================                                                        |  31%
  |                                                                                        
  |==========================                                                        |  32%
  |                                                                                        
  |===========================                                                       |  32%
  |                                                                                        
  |===========================                                                       |  33%
  |                                                                                        
  |===========================                                                       |  34%
  |                                                                                        
  |============================                                                      |  34%
  |                                                                                        
  |============================                                                      |  35%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |============================                                                      |  35%
  |                                                                                        
  |=============================                                                     |  35%
  |                                                                                        
  |=============================                                                     |  36%
  |                                                                                        
  |==============================                                                    |  36%
  |                                                                                        
  |==============================                                                    |  37%
  |                                                                                        
  |===============================                                                   |  37%
  |                                                                                        
  |===============================                                                   |  38%
  |                                                                                        
  |================================                                                  |  38%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |================================                                                  |  38%
  |                                                                                        
  |================================                                                  |  39%
  |                                                                                        
  |================================                                                  |  40%
  |                                                                                        
  |=================================                                                 |  40%
  |                                                                                        
  |=================================                                                 |  41%
  |                                                                                        
  |==================================                                                |  41%
  |                                                                                        
  |==================================                                                |  42%
  |                                                                                        
  |===================================                                               |  42%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |===================================                                               |  42%
  |                                                                                        
  |===================================                                               |  43%
  |                                                                                        
  |====================================                                              |  43%
  |                                                                                        
  |====================================                                              |  44%
  |                                                                                        
  |=====================================                                             |  45%
  |                                                                                        
  |=====================================                                             |  46%
  |                                                                                        
  |======================================                                            |  46%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |======================================                                            |  46%
  |                                                                                        
  |======================================                                            |  47%
  |                                                                                        
  |=======================================                                           |  47%
  |                                                                                        
  |=======================================                                           |  48%
  |                                                                                        
  |========================================                                          |  48%
  |                                                                                        
  |========================================                                          |  49%
  |                                                                                        
  |=========================================                                         |  49%
  |                                                                                        
  |=========================================                                         |  50%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |=========================================                                         |  50%
  |                                                                                        
  |=========================================                                         |  51%
  |                                                                                        
  |==========================================                                        |  51%
  |                                                                                        
  |==========================================                                        |  52%
  |                                                                                        
  |===========================================                                       |  52%
  |                                                                                        
  |===========================================                                       |  53%
  |                                                                                        
  |============================================                                      |  53%
  |                                                                                        
  |============================================                                      |  54%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |============================================                                      |  54%
  |                                                                                        
  |=============================================                                     |  54%
  |                                                                                        
  |=============================================                                     |  55%
  |                                                                                        
  |==============================================                                    |  56%
  |                                                                                        
  |==============================================                                    |  57%
  |                                                                                        
  |===============================================                                   |  57%
  |                                                                                        
  |===============================================                                   |  58%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |===============================================                                   |  58%
  |                                                                                        
  |================================================                                  |  58%
  |                                                                                        
  |================================================                                  |  59%
  |                                                                                        
  |=================================================                                 |  59%
  |                                                                                        
  |=================================================                                 |  60%
  |                                                                                        
  |==================================================                                |  60%
  |                                                                                        
  |==================================================                                |  61%
  |                                                                                        
  |==================================================                                |  62%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |==================================================                                |  62%
  |                                                                                        
  |===================================================                               |  62%
  |                                                                                        
  |===================================================                               |  63%
  |                                                                                        
  |====================================================                              |  63%
  |                                                                                        
  |====================================================                              |  64%
  |                                                                                        
  |=====================================================                             |  64%
  |                                                                                        
  |=====================================================                             |  65%
  |                                                                                        
  |======================================================                            |  65%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |======================================================                            |  65%
  |                                                                                        
  |======================================================                            |  66%
  |                                                                                        
  |=======================================================                           |  66%
  |                                                                                        
  |=======================================================                           |  67%
  |                                                                                        
  |=======================================================                           |  68%
  |                                                                                        
  |========================================================                          |  68%
  |                                                                                        
  |========================================================                          |  69%
  |                                                                                        
  |=========================================================                         |  69%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |=========================================================                         |  69%
  |                                                                                        
  |=========================================================                         |  70%
  |                                                                                        
  |==========================================================                        |  70%
  |                                                                                        
  |==========================================================                        |  71%
  |                                                                                        
  |===========================================================                       |  71%
  |                                                                                        
  |===========================================================                       |  72%
  |                                                                                        
  |===========================================================                       |  73%
  |                                                                                        
  |============================================================                      |  73%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |============================================================                      |  73%
  |                                                                                        
  |============================================================                      |  74%
  |                                                                                        
  |=============================================================                     |  74%
  |                                                                                        
  |=============================================================                     |  75%
  |                                                                                        
  |==============================================================                    |  75%
  |                                                                                        
  |==============================================================                    |  76%
  |                                                                                        
  |===============================================================                   |  76%
  |                                                                                        
  |===============================================================                   |  77%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |===============================================================                   |  77%
  |                                                                                        
  |================================================================                  |  77%
  |                                                                                        
  |================================================================                  |  78%
  |                                                                                        
  |================================================================                  |  79%
  |                                                                                        
  |=================================================================                 |  79%
  |                                                                                        
  |=================================================================                 |  80%
  |                                                                                        
  |==================================================================                |  80%
  |                                                                                        
  |==================================================================                |  81%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |==================================================================                |  81%
  |                                                                                        
  |===================================================================               |  81%
  |                                                                                        
  |===================================================================               |  82%
  |                                                                                        
  |====================================================================              |  82%
  |                                                                                        
  |====================================================================              |  83%
  |                                                                                        
  |====================================================================              |  84%
  |                                                                                        
  |=====================================================================             |  84%
  |                                                                                        
  |=====================================================================             |  85%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |=====================================================================             |  85%
  |                                                                                        
  |======================================================================            |  85%
  |                                                                                        
  |======================================================================            |  86%
  |                                                                                        
  |=======================================================================           |  86%
  |                                                                                        
  |=======================================================================           |  87%
  |                                                                                        
  |========================================================================          |  87%
  |                                                                                        
  |========================================================================          |  88%
  |                                                                                        
  |=========================================================================         |  88%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |=========================================================================         |  88%
  |                                                                                        
  |=========================================================================         |  89%
  |                                                                                        
  |=========================================================================         |  90%
  |                                                                                        
  |==========================================================================        |  90%
  |                                                                                        
  |==========================================================================        |  91%
  |                                                                                        
  |===========================================================================       |  91%
  |                                                                                        
  |===========================================================================       |  92%
  |                                                                                        
  |============================================================================      |  92%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |============================================================================      |  92%
  |                                                                                        
  |============================================================================      |  93%
  |                                                                                        
  |=============================================================================     |  93%
  |                                                                                        
  |=============================================================================     |  94%
  |                                                                                        
  |==============================================================================    |  95%
  |                                                                                        
  |==============================================================================    |  96%
  |                                                                                        
  |===============================================================================   |  96%
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |===============================================================================   |  96%
  |                                                                                        
  |===============================================================================   |  97%
  |                                                                                        
  |================================================================================  |  97%
  |                                                                                        
  |================================================================================  |  98%
  |                                                                                        
  |================================================================================= |  98%
  |                                                                                        
  |================================================================================= |  99%
  |                                                                                        
  |==================================================================================|  99%
  |                                                                                        
  |==================================================================================| 100%
```

```r
# Value
# A list containing dataframes with the results of the sensitivity analyses. The list will contain a dataframe for each outcome specified. List elements can be visualized with plot.owsa, owsa_opt_strat and owsa_tornado from dampack

# Basically, run_owsa_det creates the above.

# Also, each owsa object returned by run_owsa_det is a data frame with four columns: parameter, strategy, param_val, and outcome_val. For each row, param_val is the value used for the parameter listed in parameter and outcome_val is the value of the specified outcome for the strategy listed in strategy. 

# So, OWSA_NMB shows a row is created for each sampling of the parameter value from min to max, so 100 rows per parameter (because nsamp = 100,), and the outcome value associated with a parameter value of this size is displayed under outcome_val.

# You can see how this works by putting the below into the console.

# OWSA_NMB

# Or just DSAICER for DSAICER.

# Resources on this available here:


# https://rdrr.io/github/DARTH-git/dampack/man/run_owsa_det.html (also saved here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\sensitivity analysis help files\rdrr-io-github-DARTH-git-dampack-man-run_owsa_det-html.pdf)


# This link is pretty good for showing that the OWSA can be run across a variety of outcomes outcomes = c("Cost", "QALY", "LY", "NMB"), and then you can pick which of the OWSA outcomes you'd like to focus on and build tornado diagrams, etc., from that:

# "Because we have defined multiple parameters in my_owsa_params_range, we have instructed run_owsa_det to execute a series of separate one-way sensitivity analyses and compile the results into a single owsa object for each requested outcome. When only one outcome is specified run_owsa_det returns a owsa data frame. When more than one outcome is specified, run_owsa_det returns a list containing one owsa data frame for each outcome. To access the owsa object corresponding to a given outcome, one can select the list item with the name “owsa_”. For example, the owsa object associated with the NMB outcome can be accessed as l_owsa_det$owsa_NMB."

# https://cran.r-project.org/web/packages/dampack/vignettes/dsa_generation.html 

owsa_tornado(owsa = DSAICER, txtsize = 11)
```

<img src="Markov_3state_files/figure-html/unnamed-chunk-34-1.png" width="672" />

```r
ggsave(paste("Tornado_Diagram_", country_name[1], ".png", sep = ""), width = 8, height = 4, dpi=300)
while (!is.null(dev.list()))  dev.off()
#png(paste("Tornado_Diagram_", country_name[1], ".png", sep = ""))
#dev.off()

# Plotting the outcomes of the OWSA in a tornado plot
# - note that other plots can also be generated using the plot() and owsa_opt_strat() functions



# owsa_tornado(DSAICER,
# 
# min_rel_diff = 0.05)

# For owsa objects that contain many parameters that have minimal effect on the parameter of interest, you may want to consider producing a plot that highlights only the most influential parameters. Using the min_rel_diff argument, you can instruct owsa_tornado to exclude all parameters that fail to produce a relative change in the outcome below a specific fraction.


# Maybe use the below to change the formatting of the above:
# TornadoPlot(main_title = "Tornado Plot", Parms = paramNames, Outcomes = m.tor, 
#             outcomeName = "Incremental Cost-Effectiveness Ratio (ICER)", 
#             xlab = "ICER", 
#             ylab = "Parameters", 
#             col1="#3182bd", col2="#6baed6")
```

## 08.3.1 Plot OWSA


```r
# plot(DSAICER, txtsize = 10, n_x_ticks = 4, 
#      facet_scales = "free") +
#   theme(legend.position = "bottom") 
# The above was the code, but I've temporarily commented it out.

# I can add the following to the above: 

# + ggtitle("Expected Value of Perfect Information")

# To include a title on this plot, per: https://mran.microsoft.com/snapshot/2021-03-21/web/packages/dampack/dampack.pdf

#txtsize - base text size

# n_y_ticks - number of axis ticks
# n_x_ticks	- number of axis ticks

# Function for determining number of ticks on axis of ggplot2 plots. https://www.quantargo.com/help/r/latest/packages/dampack/1.0.1/number_ticks


# [SO, IN THE DIAGRAM THE PARAMETER WE ARE CONSIDERING IS AT THE TOP OF THE DIAGRAM, THE NET MONETARY BENEFIT IS ON THE LEFT OF THE DIAGRAM AND YOU'LL SEE THAT THE LEFT EDGE OF THE LINE IS THE MINIMUM VALUE FOR THE PARAMETER WE ARE INTERESTED IN, THE RIGHT EDGE OF THE LINE IS THE MAXIMUM VALUE FOR THE PARAMETER WE ARE INTERESTED IN, AND SOMEWHERE IN THE MIDDLE IS THE BASECASE WE ASSIGNED THIS PARAMETER. A GOOD EXAMPLE OF THIS IS c_P, COST OF PROGRESSION, say THE BASECASE WAS 1,000 EURO, WHICH WE'D SEE IN THE MIDDLE, THE MINIMUM WAS 800 EURO WHICH WE'D SEE ON THE FAR LEFT OF THE LINE, AND THE MAXIMUM IS 1,200 WHICH WE'D SEE ON THE FAR RIGHT OF THE LINE, AND WE'D SEE THAT AS WE MOVE FROM THE MINUMUM, THE 800 EURO ON THE FAR LEFT OF THE LINE, TO THE MAXIMUM, THE 1200 EURO ON THE FAR RIGHT OF THE LINE (I.E., AS THE COST OF BEING IN THE PROGRESSED STATE INCREASES) THE NET MONETARY BENEFIT OF BOTH TREATMENT OPTIONS FALL, WITH THE NMB OF THE EXPERIMENTAL TREATMENT OPTION FALLING FROM 235,000 TO 230,000].



# Explained here: https://cran.r-project.org/web/packages/dampack/vignettes/dsa_generation.html


# and here: https://cran.r-project.org/web/packages/dampack/vignettes/psa_analysis.html


# Because I'm using ICERs, there's only one value, whereas for NMB, there's a value under each treatment strategy, but ICERs are ratios comparing the costs of one treatment strategy to another, and the outcomes of one treatment strategy to another. So, where when I was using NMB as my outcome I would have a curve for "SoC" and "Experimental Treatment", because each would get an NMB, now I only have the one curve, to show how the ICER value changes. So, before I could have how the net monetary benefit changed under each treatment strategy as the cost of treatment A went up, or the rate of changing from healthy to dead went up, per the "# Plot outcome of each strategy over each parameter range" on: https://cran.r-project.org/web/packages/dampack/vignettes/dsa_generation.html, now I only have the ICER, so I see how the ICER changes as the cost of parameters, etc., change.

# Because only one ICER value is created, but it's created for both SoC and Exp, I imagine that the exp line and SoC line are created, but sit on top of eachother in the diagram below, so I don't include this in my paper:
```

## 08.3.2 Optimal strategy with OWSA


```r
# There are too many parameters to make things legible, so instead you should create a tornado plot that highlights only the most influential parameters. Using the min_rel_diff argument, you can instruct owsa_tornado to exclude all parameters that fail to produce a relative change in the outcome below a specific fraction.

# owsa_tornado(OWSA_NMB,
# 
# min_rel_diff = 0.05)

# Following this, create a vector of the parameters that appear in this tornado plot below and then create the optimal strategy with OWSA per these parameters.

# v_owsa_opt_strat <- c("HR_FP_Exp", "HR_FP_SoC", "p_PD", "p_FD_SoC", "p_FD_Exp", "p_FA1_SoC", "p_A1F_SoC", "p_A1D_SoC", "p_FA2_SoC", "p_A2F_SoC", "p_A2D_SoC", "p_FA3_SoC", "p_A3F_SoC", "p_A3D_SoC", "c_F_SoC", "c_F_Exp", "c_P","c_AE1", "c_AE2", "c_AE3", "d_e", "d_c", "u_F", "u_P", "u_AE1", "u_AE2", "u_AE3")

# Then include params = v_owsa_opt_strat, in the below and get rid of plot_const = FALSE

#owsa_opt_strat(owsa = DSAICER, txtsize = 10, plot_const = FALSE)
# The above was the code, but I've temporarily commented it out.


# plot_const = FALSE
# plot_const	
# whether to plot parameters that don't lead to changes in optimal strategy as they vary.

# params	
# params = v_owsa_opt_strat,
# vector of parameters to plot

# return	
# either return a ggplot object plot or a data frame with ranges of parameters for which each strategy is optimal. return = c("plot", "data"),

# Basically, the data frame will show you the ranges for each parameter that each strategy is optimal.You can see below that for p_FD_Exp the experimental treatment is the optimal strategy from 0.04 (the minimum) through to 0.055 (0.05575757575757575), while standard of care is the optimal strategy from 0.059 (0.05595959595959596) through to 0.06 (the maximum). 

# p_FD_Exp	Experimental.Treatment	4.0000000000000001e-02	5.5757575757575756e-02	
# p_FD_Exp	Standard.of.Care	5.5959595959595959e-02   6.0000000000000005e-02	

# Whereas for p_FA3_SoC the experimental treatment strategy is optimal from it's min 0.016 all the way through every value in the range to it's max: 0.024 

# p_FA3_SoC	Experimental.Treatment	1.6000000000000000e-02	2.4000000000000000e-02	

# The data frame is a bit of a pain though because it returns things in scientific notation, but according to the below:

 
# Scientific Notation
# E+01 means moving the decimal point one digit to the right, E+00 means leaving the decimal point where it is, and E–01 means moving the decimal point one digit to the left. Example: 1.00E+01 is 10, 1.33E+00 stays at 1.33, and 1.33E–01 becomes 0.133.
# https://neo.ne.gov/programs/stats/inf/79.htm#:~:text=Scientific%20Notation,-The%20scientific%20notation&text=E%2B01%20means%20moving%20the,1.33E%E2%80%9301%20becomes%200.133.

# There's also a good calculator to do this for you here: https://www.free-online-calculator-use.com/scientific-notation-converter.html#

# https://rdrr.io/github/DARTH-git/dampack/man/owsa_opt_strat.html


# Like owsa_tornado(), the return argument in owsa_opt_strat() allows the user to access a tidy data.frame that contains the exact values used to produce the plot.

# owsa_opt_strat(o, 
#                return = "data")

# https://cran.r-project.org/web/packages/dampack/vignettes/psa_analysis.html



# If return == "plot", a ggplot2 optimal strategy plot derived from the owsa object, or if return == "data", a data.frame containing all data contained in the plot. The plot allows us to see how the strategy that maximizes the expectation of the outcome of interest changes as a function of each parameter of interest.

# Visualize optimal strategy (max NMB) over each parameter range
# owsa_opt_strat(my_owsa_NMB)

# facet_ncol	
# Number of columns in plot facet.

# facet_nrow	
# number of rows in plot facet.

# txtsize
# base text size

# facet_lab_txtsize	
# text size for plot facet labels (I think this allows me change the size of the text on the plots and the size of the numbers, ledgend, etc., independently).

# Explained here: 

# https://cran.r-project.org/web/packages/dampack/vignettes/dsa_generation.html

# https://cran.r-project.org/web/packages/dampack/vignettes/psa_analysis.html

# https://rdrr.io/github/DARTH-git/dampack/man/owsa_opt_strat.html

# https://www.quantargo.com/help/r/latest/packages/dampack/1.0.1/owsa_opt_strat

# Again, this is something that doesnt work too well with ICERs, with a NMB it is easy to see what the optimal strategy is, with am ICER it's not so easy unless you are telling your code what the willingness to pay threshold is, and it's doing the ICER calculation and then comparing this to the WTP threshold to see which approach is most cost-effective. But I think this code is really set up for NMB and telling you what parameter values give you higher NMB values and which treatment strategies these NMB's belong to. 
```

## 08.4 Two-way sensitivity analysis (TWSA)


```r
# To conduct the two-way DSA, we call the function run_twsa_det with my_twsa_params_range. The general format of the function arguments for run_twsa_det are the same as those for run_owsa_det. In run_twsa_det, equally spaced sequences of length nsamp are created for the two parameters based on the inputs provided in the params_range argument. These two sequences of parameter values define an nsamp by nsamp grid over which FUN is applied to produce outcomes for every combination of the two parameters. https://cran.r-project.org/web/packages/dampack/vignettes/dsa_generation.html


## 4.2 Defining and performing a two-way sensitivity analysis ----

# I can also preform a TWSA on a a probabilistic sensitivity analysis (make_psa_obj) or a deterministic sensitivity analysis object (run_owsa_det) per: https://rdrr.io/github/DARTH-git/dampack/man/twsa.html

# A lot of this code should be reflective of the earlier code of the one-way sensitivity analysis, so if I'm confused as to what one thing is doing or another I can look at the piece of code that is confusing me here, and scroll back up to my explanation of that code in OWSA.

# Run deterministic two-way sensitivity analysis (TWSA) https://rdrr.io/github/DARTH-git/dampack/src/R/run_dsa.R

# To perform a two-way sensitivity analysis (TWSA), a similar data.frame with model parameters is required

# dataframe containing all parameters, their basecase values, and the min and 
# max values of the parameters of interest

df_params_TWSA <- data.frame(pars = c("HR_FP_SoC", "HR_FP_Exp"),
                             min  = c(Minimum_HR_FP_SoC, Minimum_HR_FP_Exp),  # min parameter values
                             max  = c(Maximum_HR_FP_SoC, Maximum_HR_FP_Exp) # max parameter values
)



# We could have chosen any of the below from our OWSA data.frame to use as our parameters:
# df_params_OWSA <- data.frame(
#   pars = c("HR_FP_Exp", "HR_FP_SoC", "p_PD", "p_FD_SoC", "p_FD_Exp", "p_FA1_SoC", "p_A1F_SoC", "p_A1D_SoC", "p_FA2_SoC", "p_A2F_SoC", "p_A2D_SoC", "p_FA3_SoC", "p_A3F_SoC", "p_A3D_SoC", "c_F_SoC", "c_F_Exp", "c_P","c_AE1", "c_AE2", "c_AE3", "d_e", "d_c", "u_F", "u_P", "u_AE1", "u_AE2", "u_AE3"),   # names of the parameters to be changed
#   min  = c(Minimum_HR_FP_Exp, Minimum_HR_FP_SoC, Minimum_p_PD, Minimum_p_FD_SoC, Minimum_p_FD_Exp, Minimum_p_FA1_SoC, Minimum_p_A1F_SoC, Minimum_p_A1D_SoC, Minimum_p_FA2_SoC, Minimum_p_A2F_SoC, Minimum_p_A2D_SoC, Minimum_p_FA3_SoC, Minimum_p_A3F_SoC, Minimum_p_A3D_SoC, Minimum_c_F_SoC, Minimum_c_F_Exp, Minimum_c_P, Minimum_c_AE1, Minimum_c_AE2, Minimum_c_AE3, Minimum_d_e, Minimum_d_c, Minimum_u_F, Minimum_u_P, Minimum_u_AE1, Minimum_u_AE2, Minimum_u_AE3),         # min parameter values
#   max  = c(Maximum_HR_FP_Exp, Maximum_HR_FP_SoC, Maximum_p_PD, Maximum_p_FD_SoC, Maximum_p_FD_Exp, Maximum_p_FA1_SoC, Maximum_p_A1F_SoC, Maximum_p_A1D_SoC, Maximum_p_FA2_SoC, Maximum_p_A2F_SoC, Maximum_p_A2D_SoC, Maximum_p_FA3_SoC, Maximum_p_A3F_SoC, Maximum_p_A3D_SoC, Maximum_c_F_SoC, Maximum_c_F_Exp, Maximum_c_P, Maximum_c_AE1,  Maximum_c_AE2, Maximum_c_AE3, Maximum_d_e, Maximum_d_c, Maximum_u_F, Maximum_u_P, Maximum_u_AE1, Maximum_u_AE2, Maximum_u_AE3)          # max parameter values
# )
# 

# It's a pain, but we have to only enter 2 parameters of interest at a time into our model per the error built into the source code for run_twsa_det:

# "two-way sensitivity analysis only allows for and requires 2 different paramters of interest at a time" https://rdrr.io/github/DARTH-git/dampack/src/R/run_dsa.R

# And:

# The structure of the function is very similar to run_owsa_det(). The primary difference is the function can only take two parameters at a time in the params_range. https://syzoekao.github.io/CEAutil/


# The TWSA is performed using the run_twsa_det function


TWSA_DSAICER <- run_twsa_det(params_range    = df_params_TWSA,    # dataframe with parameters for TWSA
                         params_basecase = l_params_all,      # list with all parameters, the "pars" chosen in the data.frame to be analysed here must be a subset of these.
                         
                         nsamp           = 40,                # number of parameter values. If NULL, 40 parameter values are used

 # number of parameter values

# nsamp	

# number of sets of parameter values to be generated. If NULL, 40 parameter values are used -> I think Eva Enns said these are automatically evenly spaced out values of the parameters.

# Additional inputs are the number of equally-spaced samples (nsamp) to be used between the specified minimum and maximum of each range, the user-defined function (FUN) to be called to generate model outcomes for each strategy, the vector of outcomes to be stored (must be outcomes generated by the data frame output of the function passed in FUN), and the vector of strategy names to be evaluated.

# cran.r-project.org/web/packages/dampack/vignettes/dsa_generation.html
                         
                         
                         FUN             = oncologySemiMarkov,  # function to compute outputs

# Function that takes the basecase in params_all and produces the outcome of interest. The FUN must return a dataframe where the first column is the strategy names and the rest of the columns must be outcomes. Which df_ce in the function does.

# Described here:

# https://rdrr.io/cran/dampack/man/run_twsa_det.html

                         outcomes        = c("DSAICER"),             # output to do the TWSA on
                         strategies      = v_names_strats,       # names of the strategies.The default (NULL) will use strategy names in FUN
                         progress        = TRUE, #Progress bar like before

                         n_wtp           = n_wtp               # extra argument to pass to FUN to specify the willingness to pay
)
```

```
## 
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |                                                                                  |   1%
  |                                                                                        
  |=                                                                                 |   1%
  |                                                                                        
  |=                                                                                 |   2%
  |                                                                                        
  |==                                                                                |   2%
  |                                                                                        
  |==                                                                                |   3%
  |                                                                                        
  |===                                                                               |   3%
  |                                                                                        
  |===                                                                               |   4%
  |                                                                                        
  |====                                                                              |   4%
  |                                                                                        
  |====                                                                              |   5%
  |                                                                                        
  |=====                                                                             |   6%
  |                                                                                        
  |=====                                                                             |   7%
  |                                                                                        
  |======                                                                            |   7%
  |                                                                                        
  |======                                                                            |   8%
  |                                                                                        
  |=======                                                                           |   8%
  |                                                                                        
  |=======                                                                           |   9%
  |                                                                                        
  |========                                                                          |   9%
  |                                                                                        
  |========                                                                          |  10%
  |                                                                                        
  |=========                                                                         |  10%
  |                                                                                        
  |=========                                                                         |  11%
  |                                                                                        
  |=========                                                                         |  12%
  |                                                                                        
  |==========                                                                        |  12%
  |                                                                                        
  |==========                                                                        |  13%
  |                                                                                        
  |===========                                                                       |  13%
  |                                                                                        
  |===========                                                                       |  14%
  |                                                                                        
  |============                                                                      |  14%
  |                                                                                        
  |============                                                                      |  15%
  |                                                                                        
  |=============                                                                     |  15%
  |                                                                                        
  |=============                                                                     |  16%
  |                                                                                        
  |==============                                                                    |  16%
  |                                                                                        
  |==============                                                                    |  17%
  |                                                                                        
  |==============                                                                    |  18%
  |                                                                                        
  |===============                                                                   |  18%
  |                                                                                        
  |===============                                                                   |  19%
  |                                                                                        
  |================                                                                  |  19%
  |                                                                                        
  |================                                                                  |  20%
  |                                                                                        
  |=================                                                                 |  20%
  |                                                                                        
  |=================                                                                 |  21%
  |                                                                                        
  |==================                                                                |  21%
  |                                                                                        
  |==================                                                                |  22%
  |                                                                                        
  |===================                                                               |  23%
  |                                                                                        
  |===================                                                               |  24%
  |                                                                                        
  |====================                                                              |  24%
  |                                                                                        
  |====================                                                              |  25%
  |                                                                                        
  |=====================                                                             |  25%
  |                                                                                        
  |=====================                                                             |  26%
  |                                                                                        
  |======================                                                            |  26%
  |                                                                                        
  |======================                                                            |  27%
  |                                                                                        
  |=======================                                                           |  28%
  |                                                                                        
  |=======================                                                           |  29%
  |                                                                                        
  |========================                                                          |  29%
  |                                                                                        
  |========================                                                          |  30%
  |                                                                                        
  |=========================                                                         |  30%
  |                                                                                        
  |=========================                                                         |  31%
  |                                                                                        
  |==========================                                                        |  31%
  |                                                                                        
  |==========================                                                        |  32%
  |                                                                                        
  |===========================                                                       |  32%
  |                                                                                        
  |===========================                                                       |  33%
  |                                                                                        
  |===========================                                                       |  34%
  |                                                                                        
  |============================                                                      |  34%
  |                                                                                        
  |============================                                                      |  35%
  |                                                                                        
  |=============================                                                     |  35%
  |                                                                                        
  |=============================                                                     |  36%
  |                                                                                        
  |==============================                                                    |  36%
  |                                                                                        
  |==============================                                                    |  37%
  |                                                                                        
  |===============================                                                   |  37%
  |                                                                                        
  |===============================                                                   |  38%
  |                                                                                        
  |================================                                                  |  38%
  |                                                                                        
  |================================                                                  |  39%
  |                                                                                        
  |================================                                                  |  40%
  |                                                                                        
  |=================================                                                 |  40%
  |                                                                                        
  |=================================                                                 |  41%
  |                                                                                        
  |==================================                                                |  41%
  |                                                                                        
  |==================================                                                |  42%
  |                                                                                        
  |===================================                                               |  42%
  |                                                                                        
  |===================================                                               |  43%
  |                                                                                        
  |====================================                                              |  43%
  |                                                                                        
  |====================================                                              |  44%
  |                                                                                        
  |=====================================                                             |  45%
  |                                                                                        
  |=====================================                                             |  46%
  |                                                                                        
  |======================================                                            |  46%
  |                                                                                        
  |======================================                                            |  47%
  |                                                                                        
  |=======================================                                           |  47%
  |                                                                                        
  |=======================================                                           |  48%
  |                                                                                        
  |========================================                                          |  48%
  |                                                                                        
  |========================================                                          |  49%
  |                                                                                        
  |=========================================                                         |  49%
  |                                                                                        
  |=========================================                                         |  50%
  |                                                                                        
  |=========================================                                         |  51%
  |                                                                                        
  |==========================================                                        |  51%
  |                                                                                        
  |==========================================                                        |  52%
  |                                                                                        
  |===========================================                                       |  52%
  |                                                                                        
  |===========================================                                       |  53%
  |                                                                                        
  |============================================                                      |  53%
  |                                                                                        
  |============================================                                      |  54%
  |                                                                                        
  |=============================================                                     |  54%
  |                                                                                        
  |=============================================                                     |  55%
  |                                                                                        
  |==============================================                                    |  56%
  |                                                                                        
  |==============================================                                    |  57%
  |                                                                                        
  |===============================================                                   |  57%
  |                                                                                        
  |===============================================                                   |  58%
  |                                                                                        
  |================================================                                  |  58%
  |                                                                                        
  |================================================                                  |  59%
  |                                                                                        
  |=================================================                                 |  59%
  |                                                                                        
  |=================================================                                 |  60%
  |                                                                                        
  |==================================================                                |  60%
  |                                                                                        
  |==================================================                                |  61%
  |                                                                                        
  |==================================================                                |  62%
  |                                                                                        
  |===================================================                               |  62%
  |                                                                                        
  |===================================================                               |  63%
  |                                                                                        
  |====================================================                              |  63%
  |                                                                                        
  |====================================================                              |  64%
  |                                                                                        
  |=====================================================                             |  64%
  |                                                                                        
  |=====================================================                             |  65%
  |                                                                                        
  |======================================================                            |  65%
  |                                                                                        
  |======================================================                            |  66%
  |                                                                                        
  |=======================================================                           |  66%
  |                                                                                        
  |=======================================================                           |  67%
  |                                                                                        
  |=======================================================                           |  68%
  |                                                                                        
  |========================================================                          |  68%
  |                                                                                        
  |========================================================                          |  69%
  |                                                                                        
  |=========================================================                         |  69%
  |                                                                                        
  |=========================================================                         |  70%
  |                                                                                        
  |==========================================================                        |  70%
  |                                                                                        
  |==========================================================                        |  71%
  |                                                                                        
  |===========================================================                       |  71%
  |                                                                                        
  |===========================================================                       |  72%
  |                                                                                        
  |============================================================                      |  73%
  |                                                                                        
  |============================================================                      |  74%
  |                                                                                        
  |=============================================================                     |  74%
  |                                                                                        
  |=============================================================                     |  75%
  |                                                                                        
  |==============================================================                    |  75%
  |                                                                                        
  |==============================================================                    |  76%
  |                                                                                        
  |===============================================================                   |  76%
  |                                                                                        
  |===============================================================                   |  77%
  |                                                                                        
  |================================================================                  |  78%
  |                                                                                        
  |================================================================                  |  79%
  |                                                                                        
  |=================================================================                 |  79%
  |                                                                                        
  |=================================================================                 |  80%
  |                                                                                        
  |==================================================================                |  80%
  |                                                                                        
  |==================================================================                |  81%
  |                                                                                        
  |===================================================================               |  81%
  |                                                                                        
  |===================================================================               |  82%
  |                                                                                        
  |====================================================================              |  82%
  |                                                                                        
  |====================================================================              |  83%
  |                                                                                        
  |====================================================================              |  84%
  |                                                                                        
  |=====================================================================             |  84%
  |                                                                                        
  |=====================================================================             |  85%
  |                                                                                        
  |======================================================================            |  85%
  |                                                                                        
  |======================================================================            |  86%
  |                                                                                        
  |=======================================================================           |  86%
  |                                                                                        
  |=======================================================================           |  87%
  |                                                                                        
  |========================================================================          |  87%
  |                                                                                        
  |========================================================================          |  88%
  |                                                                                        
  |=========================================================================         |  88%
  |                                                                                        
  |=========================================================================         |  89%
  |                                                                                        
  |=========================================================================         |  90%
  |                                                                                        
  |==========================================================================        |  90%
  |                                                                                        
  |==========================================================================        |  91%
  |                                                                                        
  |===========================================================================       |  91%
  |                                                                                        
  |===========================================================================       |  92%
  |                                                                                        
  |============================================================================      |  92%
  |                                                                                        
  |============================================================================      |  93%
  |                                                                                        
  |=============================================================================     |  93%
  |                                                                                        
  |=============================================================================     |  94%
  |                                                                                        
  |==============================================================================    |  95%
  |                                                                                        
  |==============================================================================    |  96%
  |                                                                                        
  |===============================================================================   |  96%
  |                                                                                        
  |===============================================================================   |  97%
  |                                                                                        
  |================================================================================  |  97%
  |                                                                                        
  |================================================================================  |  98%
  |                                                                                        
  |================================================================================= |  98%
  |                                                                                        
  |================================================================================= |  99%
  |                                                                                        
  |==================================================================================|  99%
  |                                                                                        
  |==================================================================================| 100%
```

```r
# plot(TWSA_DSAICER)

# The plot above was the code, but I've commented it out for now.

# Sometimes you see "maximise" written in people's TWSA code, why is that:

# maximize	
# If TRUE, plot of strategy with maximum expected outcome (default); if FALSE, plot of strategy with minimum expected outcome

# per: https://www.quantargo.com/help/r/latest/packages/dampack/1.0.1/plot.twsa



# [[A 2-way uncertainty analysis will be more useful if informed by the covariance between the 2 parameters of interest or on the logical relationship between them (e.g., a 2-way uncertainty analysis might be represented by the control intervention event rate and the hazard ratio with the new treatment). <file:///C:/Users/Jonathan/OneDrive%20-%20Royal%20College%20of%20Surgeons%20in%20Ireland/COLOSSUS/Briggs%20et%20al%202012%20model%20parameter%20estimation%20and%20uncertainty.pdf>]]

# The Briggs 2012 paper said to include 2 parameters in the TWSA that have a logical relationship,(e.g., a 2-way uncertainty analysis might be represented by the control intervention event rate and the hazard ratio with the new treatment), which are expected to have a relationship because the hazard ratio for the experimental strategy is multiplied by the rate of events under soc, that's how hazard ratios for experimental interventions work, they are just a multiplier for the number of events under SoC in order to give number of events under Exp care, so more events under SoC means more events under the experimental strategy when it's hazard ratio is applied to the number of events under SoC. In the model, the function is called in the sensitivity analysis and applies a hazard ratio

# I also describe applying the Exp HR to the post changes SoC in my function where this is done.

# I can't use Free to Progressed probabilities, because now those probabilities are time-sensitive, so if I try to change these here and include them in the TWSA I'll be including too many things, just like in the tornado diagram, as I explain in my description on hazard ratios.

# Minimum_p_FP_SoC <- p_FP_SoC - 0.20*p_FP_SoC

# Maximum_p_FP_SoC <- p_FP_SoC + 0.20*p_FP_SoC

# Minimum_p_FP_Exp <- p_FP_Exp - 0.20*p_FP_Exp

# Maximum_p_FP_Exp <- p_FP_Exp + 0.20*p_FP_Exp

# To address this, I can apply this mean, max and min to the hazard ratios instead, knowing that when run_owsa_det is run in the sensitivity analysis it calls the oncology_semi_markov_function to run and in this function the hazard ratios generate the survivor function, and then these survivor functions are used to generate the probabilities (which will be cycle dependent), so I am varying the transition probabilities by 20% using a static value.


# Alterantive modelling approach I could try here if so inclined:


# "When the base-case result of an analysis strongly favors one alternative, a threshold analysis may be presented as a worst-case or ''even if'' analysis (e.g., ''Even if the risk reduction is as low as X, the ICER remains below Y,'' or ''Even if the relative risk reduction with alternative A is as low as X and the cost of treatment is as high as Y, alternative A dominates B''). Threshold values can easily be combined with the tornado presentation by marking them on the horizontal bars."

# <file:///C:/Users/Jonathan/OneDrive%20-%20Royal%20College%20of%20Surgeons%20in%20Ireland/COLOSSUS/Briggs%20et%20al%202012%20model%20parameter%20estimation%20and%20uncertainty.pdf>


# If for some reason I wanted a three-way sensitivity analysis per Andrew Brigg's discussion on page 8 above, there may be some code to describe doing this here: https://rdrr.io/github/syzoekao/CEAutil/src/inst/rmd/Rcode.R (github here: https://github.com/syzoekao/CEAutil/) and here: https://syzoekao.github.io/CEAutil/#44_two-way_sensitivity_analysis also saved here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\introduction to R for cost-effectiveness analysis.pdf

# Again, I think this is best suited to a NMB, where you will have 2 NMB values, one for EXP and one for SOC, for ICERAs, because it's a ratio between SoC and EXP you will only have one ICER value, and in  the code, both SOC and EXP are assigned it, so in the diagram both colours will sit on top of eachother for SOC and EXP and also, even if changing one thing changes the ICER value, it is changing it for both SOC and EXP, because they both have the same ICER, so there won't be sections of one colour and not another. 
```


```r
### PROBABILISTIC ANALYSIS ----

# We conduct a probabilistic analysis (PSA) of the model to estimate the uncertainty in the model outcomes.

# To do this, we generate samples for each model parameter from parametric distributions and evaluate the model for each set of parameter samples.


## Sampling the parameter values ----

# In order for the results reported in the PSA to be reproducible we need to set the random number seed. We also defining the number of runs, i.e., how many times we will re-sample for the parameter distributions, typically the number chosen is 10,000 in published studies, so we do that too:
n_runs <- 10000
set.seed(123)

# In the PSA, first we sample the parameter values from their distributions and store them in a data.frame.
# If a model parameter has no uncertainty and, hence, is fixed, we can set it equal to itself.


# To take random draws for the Weibull parametric survival distribution that we fitted at the start of the document using the 'flexsurv' package, we use the following piece of code.

# This applies mvrnorm (i.e., takes samples from the specified multivariate normal distribution) to the mean (mu) of 

# l_TTP_SoC_weibull$coefficients
#     shape     scale 
# 0.7700246 1.7425343 

# i.e., to the mean of the shape and the scale variables from the Weibull parametric survival distribution that we fitted.

# And gives a sigma (a positive-definite symmetric matrix specifying the covariance matrix of the variables) that is equal to the covariance between the shape and the scale variables:

# > l_TTP_SoC_weibull$cov
#             shape       scale
# shape 0.001983267 0.000291494
# scale 0.000291494 0.000782051

# You'll see that it's covariance between the two variables because you can match shape with scale twice, and each time it's the same value, so the same covariance between the two variables.

# n is just the number of samples.

# Described here:
# rdocumentation.org/packages/MASS/versions/7.3-58.1/topics/mvrnorm

# So, correlated sets (a "set" here is like one random draw from the distribution, because the draw is for shape and scale at the same time) of coefficients for the survival distribution (i.e., correlated sets of shape and scale values for the survival distribution, which are the coefficients as above) are generated using the variance-covariance matrix that was obtained from fitting the weibull distribution (the cov in l_TTP_SoC_weibull is equal to the covariance between the shape and the scale variables and is printed as a 2 by 2 matrix above) and a multivariate normal distribution (this is just saying we are applying mvrnorm to take samples from the multivariate normal distribution for the mean (mu) values of shape and scale).

# Multivariate normal distribution described here too: https://devinincerti.com/2018/02/10/psa.html'


m_coef_weibull_SoC <- mvrnorm(
  n     = n_runs, 
  mu    = l_TTP_SoC_weibull$coefficients, 
  Sigma = l_TTP_SoC_weibull$cov
)

head(m_coef_weibull_SoC)
```

```
##       shape scale
## [1,] 0.4295 5.606
## [2,] 0.3354 5.674
## [3,] 0.2912 5.562
## [4,] 0.3096 5.674
## [5,] 0.3319 5.646
## [6,] 0.2907 5.549
```

```r
m_coef_weibull_OS_SoC <- mvrnorm(
  n     = n_runs, 
  mu    = l_TTD_SoC_weibull$coefficients, 
  Sigma = l_TTD_SoC_weibull$cov
)

head(m_coef_weibull_OS_SoC)
```

```
##       shape scale
## [1,] 0.3453 6.633
## [2,] 0.3215 6.592
## [3,] 0.4090 6.688
## [4,] 0.3678 6.705
## [5,] 0.3881 6.589
## [6,] 0.3973 6.650
```

```r
# Now that we have applied mvrnorm to get a random shape and a random scale we don't need to include HR_FP_SoC in our data.frame to create random probability draws for SoC, because we can just select the shape and scale from m_coef_weibull_SoC so that in our function the updated coef_weibull_shape_SoC and coef_weibull_scale_SoC are used to generate S_FP_SoC with a random value, which will in turn generate transition probabilities under standard of care with a random value.










 # According to:
#
# C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Health Economic Modeling in R A Hands-on Introduction\Health-Eco\Markov models\markov_smoking_probabilistic.R
# 
# 
# It is OK to do the following:
# 
# # QALY associated with 1-year in the smoking state is Normal(mean = 0_95, SD = 0_01)
# # Divide by 2 as cycle length is 6 months
# state_qalys[, "Smoking"] <- rnorm(n_samples, mean = 0.95, sd = 0.01) / 2
#   
# So, when doing probabilistic sensitivity analysis and I need my mean and sd for the method of moments this may be useful information when drawing these from population norms.
# This will also be useful for utility and PSA in the adverse event setting.


# I create the SD to include in the sensitivity analysis applied to the hazard ratio below, as I need to create it outside the data.frame for the PSA:

UpperCI <- 0.87
LowerCI <- 0.53
SD <- (log(UpperCI) - log(LowerCI)) / 3.92

MEAN_HR_FP_Exp <- HR_FP_Exp
# I copy the hazard ratio above in case the below would start building HR_FP_Exp from the updated HR_FP_Exp made from random draws, i.e., in case it started including the HR_FP_Exp updated from the random draws from HR_FP_Exp in meanlog = (HR_FP_Exp), when we really need to be drawing the variability from the hazard ratio we started out with, and not a hazard ratio that we started out with, but that has since already been varied and will be varied from again if we take a random draw from this pre-varied hazard ratio.

# HR_FP_Exp = rlnorm(n_runs, meanlog = log(HR_FP_Exp), sdlog = SD)

# !!! I MAY NEED TO REPEAT THIS FOR: HR_PD_Exp

# I create the SD to include in the sensitivity analysis applied to the hazard ratio below, as I need to create it outside the data.frame for the PSA:

OS_UpperCI <- 0.86
OS_LowerCI <- 0.49
OS_SD <- (log(OS_UpperCI) - log(OS_LowerCI)) / 3.92

MEAN_HR_PD_Exp <- HR_PD_Exp
# I copy the hazard ratio above in case the below would start building HR_FP_Exp from the updated HR_FP_Exp made from random draws, i.e., in case it started including the HR_FP_Exp updated from the random draws from HR_FP_Exp in meanlog = (HR_FP_Exp), when we really need to be drawing the variability from the hazard ratio we started out with, and not a hazard ratio that we started out with, but that has since already been varied and will be varied from again if we take a random draw from this pre-varied hazard ratio.




# Below I create the data.frame that I will use in the PSA.
# So, this is the PSA input dataset.

df_PA_input <- data.frame(
  coef_weibull_shape_SoC = m_coef_weibull_SoC[ , "shape"],
  coef_weibull_scale_SoC = m_coef_weibull_SoC[ , "scale"],
  coef_TTD_weibull_shape_SoC = m_coef_weibull_OS_SoC[ , "shape"],
  coef_TTD_weibull_scale_SoC = m_coef_weibull_OS_SoC[ , "scale"],
             

  
### Hazard Ratios  
  
# People use exp for rnorm (i.e., to make random draws from a normal distribution) but I to use want rlnorm.

#  HR_FP_Exp = exp(rnorm(n_runs, log(0.6), 0.08))

# The rlnorm() function in R is used for generating random draws from a log-normal distribution.
 
# To make draws from the log-normal distribution you need to enter a hazard ratio and standard deviation.

# If you find a hazard ratio and confidence interval in the literature, rather than a hazard ratio and a standard deviation, you can make conversions to a standard deviation.

# To generate random draws for the hazard ratio, I need a mean for the hazard ratio(just the hazard ratio value itself), and a standard deviation built from the 95% confidence interval of the hazard ratio (the SD is built from log(Upper CI) - log(Lower CI)/2*SE, so sd is already built from logs for inclusion in rlnorm and doesnt need to be set as sdlog = log() unlike meanlog = log() where you need to take the log of the hazard ratio value). 


# SD: (natural log(Upper confidence interval) -  natural log(lower confidence interval) / 2*Standard error (i.e. 1.95*2 = 3.92 for a 95% confidence interval)


# So, it looks like I take the natural log of the upper limit minus the natural log of the lower limit (in confidence intervals the lower limit is reported on the left and the upper limit is reported on the right, so it would be 95% CI (30.0 [LOWER LIMIT], 34.2[UPPER LIMIT]), and I would rearrange these to have [ln(UPPER LIMIT) - ln(LOWER LIMIT)], i.e., [ln(34.2)-ln(30.0)]) and divide by 2 times the standard error. Provided the sample size is large, then for the 95% confidence interval this would be 2 x 1.96 = 3.92 For 90% confidence intervals 3.92 should be replaced by 3.29, and for 99% confidence intervals it should be replaced by 5.15. 

# I often come across hazard ratios and their confidence intervals in the published literature on clinical trials, but rarely do I see standard deviations. 
 
# A typical example from the literature is the following: "HR, 0.69; 95% CI, 0.54 to 0.89 in mCRC for cetuximab plus FOLFOX-4 vs FOLFOX-4 alone" -  https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7044820/pdf/bmjopen-2019-030738.pdf:
# 
# To compute the standard deviation for hazard ratios from the above typical reports in the literature, so that I can then generate random draws from a log-normal distribution for a hazard ratio I would do the following:
# 
# (natural log(Upper confidence interval) -  natural log(lower confidence interval) / 2*Standard error (i.e. 1.95*2 = 3.92 for a 95% confidence interval)
# 
# or in R: (log(0.89) - log(0.54)) / 3.92 = 0.1274623
# 
# 
# UpperCI <- 0.89
# LowerCI <- 0.54
# SD <- (log(UpperCI) - log(LowerCI)) / 3.92
# SD = 0.1274623
# 

# If I need to provide a citation for this formula I can use the below which, although this does not provide the formula I use, it provides enough information that is similar to the above, and which I could say ultimately informed the formula:
# Higgins, J. P. T., & Deeks, J. J. (2011). Chapter 7.7. 3.3: Obtaining standard deviations from standard errors, confidence intervals, t values and P values for differences in means. Cochrane handbook for systematic reviews of interventions, Version, 5(0).
# 
# 
# This approach is also supported by the following post, which provides good clarity on all of the above:
# 
# https://stats.stackexchange.com/questions/546192/calculate-the-standard-deviation-from-a-hazard-ratios-confidence-interval


# random draws from a log-normal distribution

# hr_draws <- rlnorm(nsims, meanlog = log(mean), sdlog = SD). 

# 
# We take random draws from the log-normal distribution for ratios, because if we were to take random draws from the ratio as it stands, because the hazard ratio can't go any lower than 0 but can go to plus infinity, our random draws would be skewed in the values we take from the distribution, on the other hand, if we were to put things on the natural log scale we would be taking our random draws from a more normalised distribution. So, you'll see that in:
# 
# rlnorm(n_sim, meanlog = log(mean),  sdlog = SD)
# 
# it's the log of the mean (the ratio value, so the hazard ratio) and the log of the standard deviation (which we put on the log scale when we calculate it so we don't need to put in as sdlog = log() here, just sdlog = ) in order to be taking random draws from a log-normal distribution (i.e. a log normally distributed HAZARD RATIO).

HR_FP_Exp = rlnorm(n_runs, meanlog = log(MEAN_HR_FP_Exp), sdlog = SD),
HR_PD_Exp = rlnorm(n_runs, meanlog = log(MEAN_HR_PD_Exp), sdlog = OS_SD),


# Per [SLIDE 16] onwards in C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\notes.txt I don't think we need to worry about the duration of time a hazard ratio refers to. In my model I definitely don't, as the hazard ratio and underlying rate survival curves that make up SoC transition probabilities come from the same paper, and thus the same time period. 























#### To generate random draws for the probabilities:

# IMPORTANT, THIS VALUE IS BOUNDED BY 1 OR 0:
# When calculating se from point estimates, remember that utility and probability values cannot be less than 0 or greater than 1, so don't calculate a min or max that is less than 0 or greater than 1. If you do, then change it to be 0 or 1, as appropriate, i.e., rather than 1.02, make it 1.

# When, as in slide 12 of C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\a212ProbabilisticDistributions-210604-154.pdf you can have many transitions from one state into others [i.e. in A you can stay in State A or you can go into State B, State C or State D rather than just going from state C into State D] it's not clear how you can do this in the beta code.

# i.e., when alpha values are all the times things happened, while  beta values are all the times they didnt, how do you apply 

# transistion_probabiliy <- rbeta(n_runs,alpha,beta)
# when there are so many things that can happen?

# FOR NON-MULTI STATE, I.E. FOR THE SICK TO DEAD STATE IN THE MARKOV MODEL YOU CAN APPLY THE BETA DISTRIBUTION, BECAUSE YOU CAN ONLY LEAVE (ALPHA) OR STAY (BETA).

# Sometimes a Dirichlet is suggested, a Dirichlet distribution is the multidimensional generalization of the beta distribution, so it's the same as applying the beta distribution, - as per: https://www.rdocumentation.org/packages/rBeta2009/versions/1.0/topics/rdirichlet but I would need to have all the counts included I think, which works when you are drawing all your transition data from one larger dataset, like in a clinical trial, but my data necessarily comes from several sources, so I if I just build everything as conditional probabilities, per my notes in this Notepad [search 19/08/22: in C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\notes.txt] in combination with the slides [C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\a212ProbabilisticDistributions-210604-154.pdf] these are notes on, that is 1-Probabilities like I've done in R already, then I should be able to apply a Beta distribution to each probability and not have to worry about applying a Dirichlet.

# Here's a quote explaining how best to do that from my notes above:

# "In the above you would have a beta distribution with parameters 731, 527 [the 512+15] to look at whether you stayed in State B and then, conditional on leaving State B, we could assign another beta distribution with parameters 512 and 15 to whether you, conditional on having left State B then transited to State C. And, of course, death is then the third category. Death is the residual probability. [i.e., conditional on having left state B is 1-the probability of staying in State B, so you could apply a Beta distribution to the probability of going into State C multiplied by 1-the probability of staying in State B. Death would be 1-the probability you create of moving into State C, because if you're not going into State C then you're going into Death as there's nowhere else for you to go, I think if you wanted to apply a Beta distribution to Death you could apply a Beta distribution to the probability of going into Death and then multiply that by 1-the probability of staying in the B state]."

# Conditional probabilities are built from the below p_'s in the function, so you basically create the beta distribution probabilities below as p_'s, and then in the function you multiply them by 1-whatever probability as necessary such that they become conditional probabilities.

##1

# Fitting Beta distributions to (constant) probability parameters [I guess the "constant" here is to clarify that this isnt how you do it for time varying transition probabilities, like the transition probabilities I create from Weibull].

# There are two main ways to do this, per: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.3 Practical exercise R\A231_Making_Models_Proba.pdf say you had something like the following printed in a study:

# ‘The hospital records of a sample of 100 patients receiving a primary THR were examined retrospectively. Of these patients, two patients died either during or immediately following the procedure. The operative mortality for the procedure is therefore estimated to be 2%.’

# You could use this information directly to specify the parameters (alpha and beta) of a beta distribution for the probability of operative mortality during primary surgery. These are noted by “a.” and “b.” respectively. Your alpha values are all the times things happened, while your beta values are all the times they didnt, so 2 and 98.

# alpha <- 2 ## alpha value for operative mortality from primary surgery
# beta <- 100- alpha ## beta value for operative mortality from primary surgery

# tp.PTHR2dead <- rbeta(n_runs,alpha,beta) ## Operative mortality rate  (OMR) following primary THR

# (as coded in C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.3 Practical exercise R\A233_Making_Models_Probabilistic_Solutions-210604 (1))

# The question is, does this give the transition probability for the time period that the quote describes? Well in the same pdf and r code as above you have the following:

# "The following information has been provided to you concerning revision procedures among patients already having had a revision operation (i.e. the re-revision risk). ‘The hospital records of a sample of 100 patients having experienced a revision procedure to replace a failed primary THR were reviewed at one year. During this time, four patients had undergone a further revision procedure.’iv) Use this information to fit a constant transition probability for the annual re-revision rate parameter (tp.rrr), using the same approach as for operative mortality above. Your beta value for re-revision risk should be equivalent to 96."


# a.rrr <- 4   ## alpha value for re-revision risk
# b.rrr <- 100-a.rrr  ## beta value for re-revision risk
# tp.rrr <-rbeta(1,a.rrr,b.rrr) ## Re-revision risk transition probability

# tp.PTHR2dead
# tp.RTHR2dead
# tp.rrr


# Because the cycle length in the model is one year according to page 3 of C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A1_Advanced Markov Modelling\A1.3 Practical exercise R\A131_Advanced_Markov_Modelling_Instructions-210528-18 this indicates that it does.


##2
                          # METHOD OF MOMENTS:


# In cases where you don't have this information, but you do have a mean and a standard error, you can do the following (per: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\notes.txt):

# My initial reading for probabilistic analysis with probabilities suggested that the method of moments can be applied to a mean and standard error for a transition probability sourced from the literature to create an appropriate alpha and beta to use in a probabilistic sensitivity analysis:

# So, I built the following code to translate the formula for the methods of moments into R, to allow us to take our transition probabilities from the literature:
# 
# 
#  ## Methods of moments
# 
# 
# #Assume the below mean and std error come from the reported literature
# 
# mean <- 0.75 ## mean from the literature
# std.error <- 0.04 ## standard error from the literature
# 
# # The method of moments can be coded up as below to get the alpha and beta from the sample using the mean and standard error from the sample:
# 
# alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1 ## alpha + beta (ab)
# alpha <- mean*alpha.plus.beta ## alpha (a)
# beta <- alpha*(1-mean)/mean ## beta(b)
# 
# # Following this, you can randomly draw from the beta distribution using the below, I only have one random draw, but you could change that 1 to 10,000 (the standard number of draws) and save these as a matrix of draws to use in your probabilistic sensitivity analysis:
# 
# probabilistic.beta.dist.draw <- rbeta(1,alpha,beta) ## drawing from the Beta distribution based on a and b

# Per the above pdf:

# "Note that the rbeta function takes 3 arguments, first the number of draws or samples, the alpha parameter (named shape1) and the beta parameter (named shape2)." 
# "rbeta(n = 5, shape1 = 50, shape2 = 100)"

# while in their R code they use the below, as included above, so I don't think it matters if you include shape1= or just include the alpha and beta directly, but I'll keep it as below, as that's how DARTH do it. 

# tp.rrr <-rbeta(1,a.rrr,b.rrr) ## Re-revision risk transition probability

# The below gives the same results either way:

# set.seed(100)
# n = 1
# b4 <- rbeta(n, shape1 = 2, shape2 = 8)
# b4
# [1] 0.1329533
# 
# set.seed(100)
# n = 1
# b4 <- rbeta(n, 2, 8)
# b4
# [1] 0.1329533

## 3

# RANGE:

# I don't describe generating random draws when the probabilities don't have an SE above, however, I can do this in the same way that I figured out how to do this for the utility beta distributions below. If they are reported with a range, he section on utility below also advises how to handle this.




# Brigs code to generate the SE for a parameter with a range perfectly centered around the mean (briggsse), and then repeated but for the situations where the range isnt PERFECTLY centered around the mean (altbriggsse), i.e., the min is further away from the mean than the max, or vice versa (even a little):

max <- 0.22,
min <- 0.12,  
mean <- P_OSD_SoC,

briggsse <- ((max)-(mean))/1.96,
# altbriggsse <- (max-min)/(2*1.96),

## Generating the alpha and beta:

std.error <- briggsse, ## briggsse OR altbriggsse - as appropriate
alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1, ## alpha + beta (ab)
alpha.plus.beta,
alpha <- mean*alpha.plus.beta, ## alpha (a)
beta <- alpha*(1-mean)/mean, ## beta(b)
alpha,
beta,
 
P_OSD_SoC       = rbeta(n_runs, shape1 =  alpha, shape2 = beta),
mean(P_OSD_SoC),
P_OSD_SoC_alpha <- alpha,
P_OSD_SoC_beta <- beta,



max <- 0.22,
min <- 0.12,  
mean <- P_OSD_Exp,

briggsse <- ((max)-(mean))/1.96,
# altbriggsse <- (max-min)/(2*1.96),

## Generating the alpha and beta:

std.error <- briggsse, ## briggsse OR altbriggsse - as appropriate
alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1, ## alpha + beta (ab)
alpha.plus.beta,
alpha <- mean*alpha.plus.beta, ## alpha (a)
beta <- alpha*(1-mean)/mean, ## beta(b)
alpha,
beta,

P_OSD_Exp       = rbeta(n_runs, shape1 =  alpha, shape2 = beta),
mean(P_OSD_Exp),
P_OSD_Exp_alpha <- alpha,
P_OSD_Exp_beta <- beta,




mean<-   p_FA1_STD,
Maximum <- Maximum_p_FA1_STD,
Maximum,
se <- ((Maximum) - (mean)) / 2,
se,  
std.error <- se,
alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1, ## alpha + beta (ab)
alpha <- mean*alpha.plus.beta, ## alpha (a)
beta <- alpha*(1-mean)/mean, ## beta(b)
alpha,
beta,

p_FA1_STD        = rbeta(n_runs, shape1 =  alpha, shape2 = beta), 

alpha_p_FA1_STD <- alpha,
beta_p_FA1_STD <- beta,



mean<-   p_FA2_STD,
Maximum <- Maximum_p_FA2_STD,
Maximum,
se <- ((Maximum) - (mean)) / 2,
se,  
std.error <- se,
alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1, ## alpha + beta (ab)
alpha <- mean*alpha.plus.beta, ## alpha (a)
beta <- alpha*(1-mean)/mean, ## beta(b)
alpha,
beta,

p_FA2_STD        = rbeta(n_runs, shape1 =  alpha, shape2 = beta), 

alpha_p_FA2_STD <- alpha,
beta_p_FA2_STD <- beta,



mean<-   p_FA3_STD,
Maximum <- Maximum_p_FA3_STD,
Maximum,
se <- ((Maximum) - (mean)) / 2,
se,  
std.error <- se,
alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1, ## alpha + beta (ab)
alpha <- mean*alpha.plus.beta, ## alpha (a)
beta <- alpha*(1-mean)/mean, ## beta(b)
alpha,
beta,

p_FA3_STD        = rbeta(n_runs, shape1 =  alpha, shape2 = beta), 

alpha_p_FA3_STD <- alpha,
beta_p_FA3_STD <- beta,



mean<-   p_FA1_EXPR,
Maximum <- Maximum_p_FA1_EXPR,
Maximum,
se <- ((Maximum) - (mean)) / 2,
se,  
std.error <- se,
alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1, ## alpha + beta (ab)
alpha <- mean*alpha.plus.beta, ## alpha (a)
beta <- alpha*(1-mean)/mean, ## beta(b)
alpha,
beta,

p_FA1_EXPR        = rbeta(n_runs, shape1 =  alpha, shape2 = beta), 

alpha_p_FA1_EXPR <- alpha,
beta_p_FA1_EXPR <- beta,



mean<-   p_FA2_EXPR,
Maximum <- Maximum_p_FA2_EXPR,
Maximum,
se <- ((Maximum) - (mean)) / 2,
se,  
std.error <- se,
alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1, ## alpha + beta (ab)
alpha <- mean*alpha.plus.beta, ## alpha (a)
beta <- alpha*(1-mean)/mean, ## beta(b)
alpha,
beta,

p_FA2_EXPR        = rbeta(n_runs, shape1 =  alpha, shape2 = beta), 

alpha_p_FA2_EXPR <- alpha,
beta_p_FA2_EXPR <- beta,



mean<-   p_FA3_EXPR,
Maximum <- Maximum_p_FA3_EXPR,
Maximum,
se <- ((Maximum) - (mean)) / 2,
se,  
std.error <- se,
alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1, ## alpha + beta (ab)
alpha <- mean*alpha.plus.beta, ## alpha (a)
beta <- alpha*(1-mean)/mean, ## beta(b)
alpha,
beta,

p_FA3_EXPR        = rbeta(n_runs, shape1 =  alpha, shape2 = beta), 

alpha_p_FA3_EXPR <- alpha,
beta_p_FA3_EXPR <- beta,






  



# Calculate the mean, maximum and variance of the Beta and Gamma here: https://www.pluralsight.com/guides/beta-and-gamma-function-implementation-in-r also saved here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\R Guide_ Beta and Gamma Function Implementation _ Pluralsight.pdf




  # Cost vectors with length n_runs


##  Costs


# 1) COSTS WITH A RANGE:



# Maximum <- SOMEVALUEHERE
# Mean <- SOMEVALUEHERE

# se <- ((Maximum) - (Mean)) / 2
# se                                  
 
# mean <-Mean
# mean
 
# mn.cIntervention <- mean ## mean cost of intervention
# se.cIntervention <- se ## standard error of cost of intervention
 
# a.cIntervention <- (mn.cIntervention/se.cIntervention)^2 ## alpha value for cost of intervention (shape)
# b.cIntervention <- (se.cIntervention^2)/mn.cIntervention ## beta value for cost of intervention (scale)
 
# a.cIntervention
# b.cIntervention
 
 
# c_H   = rgamma(n_sim, shape = a.cIntervention, scale = b.cIntervention),  # cost of intervention
 
# If costs are reported with a 95% confidence interval the maximum is the upper confidence interval. If the interval is not centered on the mean, use the maximum or minimum in place of the upper confidence interval, depending on which one is further away from the mean SE = (m-CIlower)/t, here the bit in the brackets is rearranged when dealing with lower limits to have the MEAN minus the lower confidence interval so that things don't become negative (because the lower value will of course always be lower than the mean, as it's supposed to be below the mean, so a smaller number minus a larger number will be negative), but when the interval is centered on the mean the formula of SE = (CIupper-m)/t and SE = (m-CIlower)/t are inherently doing the same thing, that is getting the difference between the mean and the confidence interval and dividing this by t. So both formulas are options to use in getting the SE, and an author may choose to use the one which incorporates the interval that is farthest from the mean in order to incorporate as much variability in doing this SE calculation as possible, i.e. to reflect the variability in their SE calculation.

# 
# As per: https://stats.stackexchange.com/questions/550293/how-to-calculate-standard-error-given-mean-and-confidence-interval-for-a-gamma-d/550892#550892
 
 
# "I would like to note that, while those values in the table happen to correspond with ±2σ, the minimum and maximum values do not generally follow such simple formula with mean plus-minus some standard deviation.
 
# In this case, the minimum and maximum values only correspond to the interval μ±2σ because the distribution seems to have been truncated at those values."
 
 
# i.e., my formula will only work if the minimum and maximum values reported in a study are ±2 SE from the mean, i.e. + 2 SE from the mean for the maximum value, and -2 SE from the mean for the minimum value.
 
# And that will be the case any time there is a 95% Confidence Interval:
 

# [ "Since 95% of values fall within two standard deviations of the mean according to the 68-95-99.7 Rule, simply add and subtract two standard deviations from the mean in order to obtain the 95% confidence interval. Notice that with higher confidence levels the confidence interval gets large so there is less precision." https://www.westga.edu/academics/research/vrc/assets/docs/confidence_intervals_notes.pdf also saved here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\gammadist\confidence_intervals_notes.pdf

# A good image can be found as per: https://www.quora.com/What-is-meant-by-one-standard-deviation-away-from-the-mean also saved here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\gammadist\www-quora-com-What-is-meant-by-.pdf]

# So, if I'm taking my costs and a range about these costs from the literature, I just need to make sure the range is a 95% Confidence Interval, like that reported here: Tilson, L., Sharp, L., Usher, C., Walsh, C., Whyte, S., O’Ceilleachair, A., ... & Barry, M. (2012). Cost of care for colorectal cancer in Ireland: a health care payer perspective. The European journal of health economics, 13(4), 511-524. (https://www.researchgate.net/publication/51188456_Cost_of_care_for_colorectal_cancer_in_Ireland_A_health_care_payer_perspective) reports a cost in Table 3 for Colorectal cancer with a 95% CI: € 48,835 (€40,548–€62,582)..

# For "PK test cost MEAN: 400.00 MIN: 300.00 MAX: 500.00" from Table 4, row 3 page 222 in Goldstein, D. A., Chen, Q., Ayer, T., Howard, D. H., Lipscomb, J., Harvey, R. D., ... & Flowers, C. R. (2014). Cost effectiveness analysis of pharmacokinetically-guided 5-fluorouracil in FOLFOX chemotherapy for metastatic colorectal cancer. Clinical colorectal cancer, 13(4), 219-225 plugged into the formula above to find the SE, I get an SE of 50, so plugging the 50 and mean into the CI = m ± t*SE from Jochen above I get:
 
# 400 + 2*50 = 500
 
# 400 - 2*50 = 300
 
# Which is the same confidence interval as I got in the Table 4 row 3, i.e. 300 and 500.
 
# So, this might be a good way to check if my standard error is correct. Although this will only work if my confidence interval is centred on the mean, i.e. if I am the same distance from the mean to the max and to the min. If my confidence interval is NOT centred on the mean, I can calculate 2 standard errors, one between the lower interval and the mean, and one between the upper interval and the mean, and then apply these in CI = m ± t*SE, knowing that:

# CIupper = m + t*SE

# CIlower = m - t*SE

# I've figured out a simple test for whether the max/min reported is ±2σ:
# se <- ((Max) - (Mean)) / 2
# MaxMatch <- Mean + 2*se 
# MinMatch <- Mean - 2*se
 
# I can then check if the max/min reported in a Table match the above, and if so I know that the max/min reported is ±2σ.
 
# If not, it may be that they used the se off the minimum as it's further away, so try the below:
 
# se <- ((Mean) - (Min)) / 2
# MaxMatch <- Mean + 2*se 
# MinMatch <- Mean - 2*se
 
 
# I can then check if the max/min reported in a Table match the above, and if so I know that the max/min reported is ±2σ.
 
 
 
 
# Even if it's not symmetric, this may still be a 95% confidence interval if the mean is at 2 of one of the standard errors from the min or the max, we can see this in action below:
 
 
# > Maximum <- 27655.84
# > Mean <- 11565.60
# > 
# > se <- ((Maximum) - (Mean)) / 2
# > se                                  
# [1] 8045.12
# > 
# > MaxMatch <- Mean + 2*se 
# > MinMatch <- Mean - 2*se
# > MaxMatch
# [1] 27655.84
# > MinMatch
# [1] -4524.64
 
# But still, for these values
 
# FN: Value: 11,565.60 Minimum: 7092.16 Maximum: 27,655.84  Distribution: γ: (2.067, 5596.247)
 
# that are not centered on the mean, this still came out the same as the Table using this se <- ((Maximum) - (Mean)) / 2 method. Because looking at the below, the upper interval (the maximum) is further from the mean at a difference of 16090.24, than the lower interval (the minimum) at a difference between it and the mean of 4473.44 (i.e. the maximum is nearly four times further away from the mean that the minimum).
 
 
# > Maximum <- 27655.84
# > Minimum <- 7092.16
# > Mean <-  11565.60
  
# > Maximum - Mean
# [1] 16090.24
  
# > Mean - Minimum
# [1] 4473.44
 
 
# And when we plug the se in for the further away max we get:
 
 
# > a.cIntervention
# [1] 2.066671
# > b.cIntervention
# [1] 5596.247
 
# Just the same as the values for FN above.
# 

# So, this kind of applies to situations where an interval is reported, when you might want to check if it's a 95% confidence interval, and if not, which interval is furthest from the mean, in cases of a point estimate only, you do the following:




# 2) POINT ESTIMATE ONLY:

# If they arent reported with a 95% confidence interval, the Goldstein paper says: "Drug costs were varied within +/-20% of their baseline values as previously done by Goulart and Ramsey".
 
# I checked this for FOLFOX drug cost Min: 443.91 Value: 355.13 Max: 532.69  gamma(100, 4.439)
 
# Mean<-   443.91
# Maximum <- Mean + 0.20*Mean
# Minimum <- Mean - 0.20*Mean
 
# Taking 20% plus the mean and 20% minus the mean, I get the same maximum and minimum as above, exactly:
 
# > Maximum
# [1] 532.692
# > Minimum
# [1] 355.128
 
# They still applied the SE = (CIupper-m)/t or SE = (m-CIlower)/t to this interval which they generated from 20% plus the mean and 20% minus the mean.

# In the Goldstein 2014 paper, where the ranges are more than 20% away from the mean, i.e., 25%, etc., they use the same formula for ranges that are symmetrically far from the mean, i.e., 25% bigger or smaller than the mean, and they use the same formula but incoporating the range that's furthest from the mean when generating the se when the ranges arent symmetric about the mean.





# OK, so the question is, can we apply any percentage we like to the point estimate we find for costs to generate the max or min and then just apply the formula above to generate the SE? I reviewed Koen's study below:

# Degeling, K., Franken, M. D., May, A. M., van Oijen, M. G., Koopman, M., Punt, C. J., ... & Koffijberg, H. (2018). Matching the model with the evidence: comparing discrete event simulation and state-transition modeling for time-to-event predictions in a cost-effectiveness analysis of treatment in metastatic colorectal cancer patients. Cancer epidemiology, 57, 60-67.

# C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\Matching the model with the evidence Koen

# In the excel file, on the second sheet there is a row called parameter 1. For cost this parameter is the alpha value, and when you click on 16.000 it shows the formula that created this alpha value, which is the same as for my alpha value formula above. This formula includes the mean and the SE. When I take the mean (which is just the baseline value) and plug this into the R code to generate the SE:

# I get the same se as in the excel file when making the max and min 50% larger or smaller than the mean in the code below. 
# Mean<-   2062.35
# Maximum <- Mean + 0.50*Mean
# Minimum <- Mean - 0.50*Mean
# se <- ((Maximum) - (Mean)) / 2
# se
# 515.5875

# Even more important, they apply the same code as I have for creating the alpha value above using this mean and SE generated just from taking 50% either side of the mean. 

# The implication of this is that you can generate the SE of a point estimate by taking any percentage either side of the mean and that you can also apply the code as above to generate the alpha and beta. Unfortunately in the excel file they don't create the beta in parameter 2, but the lambda, which is something else again. 


# This may solve the riddle of lambda in Koen's code, I noticed that here they use 1/Beta: https://www.pluralsight.com/guides/beta-and-gamma-function-implementation-in-r so I took that approach with the Lambda in Koen's code, plugging it in for beta, and got the same value of the mean as I started out with.

# Mean<-   2062.35
# Maximum <- Mean + 0.50*Mean
# Minimum <- Mean - 0.50*Mean
# se <- ((Maximum) - (Mean)) / 2

# se
# Maximum
# Minimum
# mean <-Mean

# mn.cIntervention <- mean ## mean cost of intervention
# se.cIntervention <- se ## standard error of cost of intervention
# a.cIntervention <- (mn.cIntervention/se.cIntervention)^2 ## alpha value for cost of intervention (shape)
# b.cIntervention <- (mn.cIntervention)/((se.cIntervention)^2) ## beta value for cost of intervention (scale) using Koen's backwards version of Andy's (se.cIntervention^2)/mn.cIntervention to generate the Lambda code.

# a.cIntervention
# b.cIntervention
# se

# c_H   = rgamma(10000, shape = a.cIntervention, scale = 1/b.cIntervention) # cost of intervention
# mean(c_H)
 

# Likewise, if I do the following:

# 1/ b.cIntervention
# I get the exact same value for b.cIntervention as when I use the original code to generate b.cIntervention from Andy, as below.

# b.cIntervention <- (se.cIntervention^2)/mn.cIntervention ## beta value for cost of intervention (scale)
# b.cIntervention

# So, it looks like the whole Lambda thing is just a different way of getting b.cIntervention, but Koen's way of doing it requires the addition of 1/ for the scale part of rgamma, while Andy's method doesnt.

# So, in this it looks like Andy is generating the scale for the beta, while Koen is generating the rate: 

# This is supported by this: 

# "Density, distribution function, quantile function and random generation for the Gamma distribution with parameters alpha (or shape) and beta (or scale or 1/rate)." https://search.r-project.org/CRAN/refmans/Rlab/html/Gamma.html 


# "There is a R function for simulating this random variable. Here in addition to the number of values to simulate, we just need two parameters, one for the shape and one for either the rate or the scale. The rate is the inverse of the scale. The general formula is: rgamma(n, shape, rate = 1, scale = 1/rate)." https://pubs.wsb.wisc.edu/academics/analytics-using-r-2019/gamma-variables-optional.html also saved here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\13.7 Gamma Variables (Optional) _ Analytics Using R.pdf

# I think the code above also implies that if you were to include it as a "rate" instead of calling it scale in the rcode for Koen's rate, then you wouldnt need to do the 1/ bit over scale. So, he may have taken this approach as well.This is supported by: "rate:	a numeric vector in the range [0, Inf) that specifies the inverse of the scale parameter." https://docs.tibco.com/pub/enterprise-runtime-for-R/4.1.1/doc/html/Language_Reference/stats/GammaDist.html

# This is supported by the below:

# > set.seed(1)
# > x <- rgamma(n = 1000, shape = 5, scale = 3)
# > mean(x)
# [1] 14.61593
# Knowing that the rate is the inverse of the scale, we can get the rate as 1/3 below:
# > 1/3
# [1] 0.3333333
# > set.seed(1)
# > x <- rgamma(n = 1000, shape = 5, rate = 0.3333333)
# > mean(x)
# [1] 14.61593
# > set.seed(1)
# > x <- rgamma(n = 1000, shape = 5, scale = 1/0.3333333)
# > mean(x)
# [1] 14.61593

# Thus, Koen generated the rate and used that in rgamma, while Andy showed me how to use scale and use that in rgamma. 


# This 20% approach is also taken by Lesley tilson and cited in her study and other studies here: https://trello.com/c/m653JBWV/48-20-cost-sensitivity

# administration_cost
Maximum <- Maximum_administration_cost,
Mean <- administration_cost,

se <- ((Maximum) - (Mean)) / 2,
se,                                  

mean <-Mean,
mean,

mn.cIntervention <- mean, ## mean cost of intervention
se.cIntervention <- se, ## standard error of cost of intervention

a.cIntervention <- (mn.cIntervention/se.cIntervention)^2, ## alpha value for cost of intervention (shape)
b.cIntervention <- (se.cIntervention^2)/mn.cIntervention, ## beta value for cost of intervention (scale)

a.cIntervention,
b.cIntervention,

administration_cost   = rgamma(n_runs, shape = a.cIntervention, scale = b.cIntervention), 

a.cIntervention_administration_cost <-a.cIntervention,
b.cIntervention_administration_cost <-b.cIntervention, 


# c_PFS_Folfox

Maximum <- Maximum_c_PFS_Folfox,
Mean <- c_PFS_Folfox,

se <- ((Maximum) - (Mean)) / 2,
se,                                  

mean <-Mean,
mean,

mn.cIntervention <- mean, ## mean cost of intervention
se.cIntervention <- se, ## standard error of cost of intervention

a.cIntervention <- (mn.cIntervention/se.cIntervention)^2, ## alpha value for cost of intervention (shape)
b.cIntervention <- (se.cIntervention^2)/mn.cIntervention, ## beta value for cost of intervention (scale)

a.cIntervention,
b.cIntervention,

c_PFS_Folfox   = rgamma(n_runs, shape = a.cIntervention, scale = b.cIntervention), 

a.cIntervention_c_PFS_Folfox <-a.cIntervention,
b.cIntervention_c_PFS_Folfox <-b.cIntervention, 

# c_PFS_Bevacizumab

Maximum <- Maximum_c_PFS_Bevacizumab,
Mean <- c_PFS_Bevacizumab,

se <- ((Maximum) - (Mean)) / 2,
se,                                  

mean <-Mean,
mean,

mn.cIntervention <- mean, ## mean cost of intervention
se.cIntervention <- se, ## standard error of cost of intervention

a.cIntervention <- (mn.cIntervention/se.cIntervention)^2, ## alpha value for cost of intervention (shape)
b.cIntervention <- (se.cIntervention^2)/mn.cIntervention, ## beta value for cost of intervention (scale)

a.cIntervention,
b.cIntervention,

c_PFS_Bevacizumab   = rgamma(n_runs, shape = a.cIntervention, scale = b.cIntervention), 

a.cIntervention_c_PFS_Bevacizumab <-a.cIntervention,
b.cIntervention_c_PFS_Bevacizumab <-b.cIntervention, 


#  c_OS_Folfiri

Maximum <- Maximum_c_OS_Folfiri,
Mean <- c_OS_Folfiri,

se <- ((Maximum) - (Mean)) / 2,
se,                                  

mean <-Mean,
mean,

mn.cIntervention <- mean, ## mean cost of intervention
se.cIntervention <- se, ## standard error of cost of intervention

a.cIntervention <- (mn.cIntervention/se.cIntervention)^2, ## alpha value for cost of intervention (shape)
b.cIntervention <- (se.cIntervention^2)/mn.cIntervention, ## beta value for cost of intervention (scale)

a.cIntervention,
b.cIntervention,

c_OS_Folfiri   = rgamma(n_runs, shape = a.cIntervention, scale = b.cIntervention), 

a.cIntervention_c_OS_Folfiri <-a.cIntervention,
b.cIntervention_c_OS_Folfiri <-b.cIntervention, 

# The cost of being dead doesnt vary, it always costs the same to treat a dead person, which is 0 because we don't give any of our chemo, etc., to a dead body.
  c_D = 0,

#  c_AE1

Maximum <- Maximum_c_AE1,
Mean <- c_AE1,

se <- ((Maximum) - (Mean)) / 2,
se,                                  

mean <-Mean,
mean,

mn.cIntervention <- mean, ## mean cost of intervention
se.cIntervention <- se, ## standard error of cost of intervention

a.cIntervention <- (mn.cIntervention/se.cIntervention)^2, ## alpha value for cost of intervention (shape)
b.cIntervention <- (se.cIntervention^2)/mn.cIntervention, ## beta value for cost of intervention (scale)

a.cIntervention,
b.cIntervention,

c_AE1   = rgamma(n_runs, shape = a.cIntervention, scale = b.cIntervention), 

a.cIntervention_c_AE1 <-a.cIntervention,
b.cIntervention_c_AE1 <-b.cIntervention, 


#  c_AE2

Maximum <- Maximum_c_AE2,
Mean <- c_AE2,

se <- ((Maximum) - (Mean)) / 2,
se,                                  

mean <-Mean,
mean,

mn.cIntervention <- mean, ## mean cost of intervention
se.cIntervention <- se, ## standard error of cost of intervention

a.cIntervention <- (mn.cIntervention/se.cIntervention)^2, ## alpha value for cost of intervention (shape)
b.cIntervention <- (se.cIntervention^2)/mn.cIntervention, ## beta value for cost of intervention (scale)

a.cIntervention,
b.cIntervention,

c_AE2   = rgamma(n_runs, shape = a.cIntervention, scale = b.cIntervention), 

a.cIntervention_c_AE2 <-a.cIntervention,
b.cIntervention_c_AE2 <-b.cIntervention, 


#  c_AE3

Maximum <- Maximum_c_AE3,
Mean <- c_AE3,

se <- ((Maximum) - (Mean)) / 2,
se,                                  

mean <-Mean,
mean,

mn.cIntervention <- mean, ## mean cost of intervention
se.cIntervention <- se, ## standard error of cost of intervention

a.cIntervention <- (mn.cIntervention/se.cIntervention)^2, ## alpha value for cost of intervention (shape)
b.cIntervention <- (se.cIntervention^2)/mn.cIntervention, ## beta value for cost of intervention (scale)

a.cIntervention,
b.cIntervention,

c_AE3   = rgamma(n_runs, shape = a.cIntervention, scale = b.cIntervention), 

a.cIntervention_c_AE3 <-a.cIntervention,
b.cIntervention_c_AE3 <-b.cIntervention, 


  # Utility vectors with length n_runs 

# There may be helpful books here: C:\Users\Jonathan\Dropbox\PhD\HTA\Markov Modelling\books



##### POINT ESTIMATES ONLY:



# IMPORTANT, THIS VALUE IS BOUNDED BY 1 OR 0:
# When calculating se from point estimates, remember that utility and probability values cannot be less than 0 or greater than 1, so don't calculate a min or max that is less than 0 or greater than 1. If you do, just round it to 0 or 1.


# If you have a point estimate, then you can generate the standard error/standard deviation using the method of moments again.

#Per Table 4 in the Goldstein paper:
# > mean<-   0.850
# > Maximum <- mean + 0.20*mean
# > Maximum
# [1] 1.02
# > Minimum <- mean - 0.20*mean
# > Minimum
# [1] 0.68
# > se <- ((Maximum) - (mean)) / 2
# > se  
# [1] 0.085
# > std.error <- se
# > alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1 ## alpha + beta (ab)
# > alpha <- mean*alpha.plus.beta ## alpha (a)
# > beta <- alpha*(1-mean)/mean ## beta(b)
# > alpha
# [1] 14.15
# > beta
# [1] 2.497059
# So, a perfect match to the Goldstein paper.
# Because this approach to point estimates ends up making the same range around this point estimate as reported in Table 4, the implication is that when a point estimate is reported with a range, you can generate the SE the exact same way as above, that is, se <- ((Maximum) - (mean)) / 2, because we are applying the same manner of generating the SE to the range that was reported in the paper, as to the point estimate.


# I double check the manner in which I calculate the SE with the excel file from Koen's paper: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\Matching the model with the evidence Koen both are saved here, but the filepath may be too long to access them without moving them to downloads or desktop.

# For his paper, I update the Maximum/Minimum part by taking the max as 50% bigger than the mean. When I do this, I get the exact same SE as he reports in the excel file, I know this because in his cells creating the alpha and beta values for utility or probability on sheet 2 of his excel file, he includes 2 numbers, one is the mean reported on sheet 1 for the parameter whose utility or probability he is taking random draws from, and then the other number is an EXACT match for the SE number I calculate, and must therefore be the SE number he calculates. Especially because he then applies a formula to this mean and SE to generate the alpha and the beta. You can see this in my model code below, where the mean and SE I report in my own analysis turn up in his alpha and beta formulas.

# Although he uses a different method to calculate the alpha and the beta, these typically work out as very close to the values calculated for the alpha and beta using my method, which Briggs told me to use once I had the SE and mean, so I think Koen just has a deeper understanding of mathematics and is using this to apply a different formula for the generation of alpha and beta from the SE and mean.

# The takeaway here is that my method for calculating SE is correct, as proven by Koen's excel file, and once I have the SE and the mean (mean is just the point estimate value I started with for this parameter) Andrew Briggs told me what to do to calculate the alpha and the beta, so I now can be confident in the manner in which I take the PSA for utility or probability when it comes to beta distributions. 
 
# mean<-   0.042178846
# Maximum <- mean + 0.50*mean
# Maximum
# Minimum <- mean - 0.40*mean
# Minimum
# 
# se <- ((Maximum) - (mean)) / 2
# se  
# 
# std.error <- se
# alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1 ## alpha + beta (ab)
# alpha.plus.beta
# alpha <- mean*alpha.plus.beta ## alpha (a)
# beta <- alpha*(1-mean)/mean ## beta(b)
# alpha
# beta
# 
# 
# 
# 
# mean: 0.042178846
# se: 0.01054471
# 
# alpha =(((0.042178846)^2)*(1-(0.042178846))/((0.01)^2)-(0.042178846))
# beta =((1-(0.042178846))*(((1-(0.042178846))*(0.042178846))/((0.01)^2)-1))
#
# My alpha and beta:
#
# > alpha
# [1] 15.28296
# > beta
# [1] 347.0541
#
# Koen's alpha and beta:
# alpha = 14.961
# beta = 363.614

# mean<-   0.042178846

# u_ME       = rbeta(10000, shape1 =  15.28296, shape2 = 347.0541)
# mean(u_ME)
# [1] 0.04208022
# u_KOEN       = rbeta(10000, shape1 =  14.961, shape2 = 363.614)
# mean(u_KOEN)
# [1] 0.03940224
# Which will both come to 0.04 if rounding to 2 decimal points

# 
# mean= 0.042178846
# se= 0.01
#  
# newalpha =(((mean)^2)*(1-(mean))/((se)^2)-(mean))
# newbeta =((1-(mean))*(((1-(mean))*(mean))/((se)^2)-1))
# > newalpha
# [1] 16.99799
# > newbeta
# [1] 385.9999
# 
# 
# manualalpha =(((0.042178846)^2)*(1-(0.042178846))/((0.01)^2)-(0.042178846))
# manualbeta =((1-(0.042178846))*(((1-(0.042178846))*(0.042178846))/((0.01)^2)-1))
# > manualalpha
# [1] 16.99799
# > manualbeta
# [1] 385.9999

## RANGE:

##### Calculating Beta values when you have a range around your point estimate in the literature (THIS CAN BE APPLIED TO PROBABILITY OR UTILITY): 


# Here are my formulas, and if you read further below you can see how I got to these formulas.

# Here's the bottomline takeaway on the Beta formuala. My SE's are typically very close to the SE's that I recover from the published studies. I've seen first hand, that you need big changes to the SE to affect the mean you draw in the PSA. So, what I'll do is apply the briggse or altbriggse as appropriate, and then when I do the PSA I'll check the mean on the parameter drawn from the PSA draws to make sure the parameter is on average the same as the one we started with, I can do this by doing mean() whatever the parameter is, and that will show me the average value.

# Briggs code to generate the SE for a parameter with a range perfectly centered around the mean (briggsse), and then repeated but for the situations where the range isnt PERFECTLY centered around the mean (altbriggsse), i.e., the min is further away from the mean than the max, or vice versa (even a little):

# briggsse <- ((max)-(mean))/1.96
# altbriggsse <- (max-min)/(2*1.96)

## Generating the alpha and beta:

# mean <- Somevaluehere

# std.error <- briggsse OR altbriggsse - as appropriate
# alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1 ## alpha + beta (ab)
# alpha.plus.beta
# alpha <- mean*alpha.plus.beta ## alpha (a)
# beta <- alpha*(1-mean)/mean ## beta(b)
# alpha
# beta
# 
# u_ME       = rbeta(10000, shape1 =  a, shape2 = b)
# mean(u_ME)

# I could also create alpha and beta using Koen's code, which is a different way of calculating these vales than what Briggs showed me, but typically gives the same alpha and beta, so can be ignored:

# newalpha =(((mean)^2)*(1-(mean))/((se)^2)-(mean))
# newbeta =((1-(mean))*(((1-(mean))*(mean))/((se)^2)-1))
# newalpha
# newbeta


# Calculating a Beta distribution when you have a range around this in the literature you are reviewing:

# All of the below applies to probabilities as well as utilities, as both are for beta distributions.

# To determine the best way to do this, I open all the sources I mention just above which include a range, se, alpha, beta, etc., and then I apply all the methods I have and see which is best. I'll also be heavily guided by the suggestions Andy made, as he has being doing this work for 2 decades, if he says that a certain way is correct, I'll take him at his word. Lesley also made some suggestions.

# Once you have an alpha and a beta, you can work your way back to a SE:


# per: https://stackoverflow.com/questions/41189633/how-to-get-the-standard-deviation-from-the-fitted-distribution-in-scipy
# As supported by this: https://www.real-statistics.com/binomial-and-related-distributions/beta-distribution/
# and using this here: Jenks, Michelle, et al. "Tegaderm CHG IV securement dressing for central venous and arterial catheter insertion sites: a NICE medical technology guidance." Applied Health Economics and Health Policy 14.2 (2016): 135-149. https://link.springer.com/content/pdf/10.1007/s40258-015-0202-5.pdf I get 0.002096431 or 0.0021, so it looks like they used the mean as their se.


# I demonstrate this in Table 1, row 22,  of: Sharp, Linda, et al. "Cost-effectiveness of population-based screening for colorectal cancer: a comparison of guaiac-based faecal occult blood testing, faecal immunochemical testing and flexible sigmoidoscopy." British journal of cancer 106.5 (2012): 805-816. https://www.nature.com/articles/bjc2011580.pdf also saved here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\Betadist utility\bjc2011580.pdf

# CTC sensitivity for CRC Basecase(85%) range(75 – 95%) Beta (Alpha = 50.00, Beta = 8.82)

# a<- 50.00
# b<- 8.82
# Var <-  a * b / ( (a + b)^2 * (a + b + 1) )
# se <- sqrt(Var)
# se
# 0.04616056

# Here's a way to get alpha and beta with just the variance and mean: https://devinincerti.com/2018/02/10/psa.html

# If I wanted to turn my own SE into the variance, I can multiply it by itself, i.e. se*se per: https://r-lang.com/how-to-calculate-square-of-all-values-in-r-vector/#:~:text=To%20calculate%20square%20in%20R,square%20of%20the%20input%20value.

# mean <- 0.85

# std.error <- se
# alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1 ## alpha + beta (ab)
# alpha.plus.beta
# alpha <- mean*alpha.plus.beta ## alpha (a)
# beta <- alpha*(1-mean)/mean ## beta(b)
# alpha
# 50.01124
# beta
# 8.825513


# myse <- ((0.95) - (0.85)) / 2
# myse
# 0.05


# Briggs code to generate the SE for a parameter with a range perfectly centered around the mean (briggsse), and then repeated but for the situations where the range isnt PERFECTLY centered around the mean (altbriggsse), i.e., the min is further away from the mean than the max, or vice versa (even a little):

max <- 1.00,
min <- 0.68,  
mean <- u_F,

# briggsse <- ((max)-(mean))/1.96,
altbriggsse <- (max-min)/(2*1.96),

## Generating the alpha and beta:

std.error <- altbriggsse, ## briggsse OR altbriggsse - as appropriate
alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1, ## alpha + beta (ab)
alpha.plus.beta,
alpha <- mean*alpha.plus.beta, ## alpha (a)
beta <- alpha*(1-mean)/mean, ## beta(b)
alpha,
beta,

u_F       = rbeta(n_runs, shape1 =  alpha, shape2 = beta),
mean(u_F),
u_F_alpha <- alpha,
u_F_beta <- beta,

# Briggs code to generate the SE for a parameter with a range perfectly centered around the mean (briggsse), and then repeated but for the situations where the range isnt PERFECTLY centered around the mean (altbriggsse), i.e., the min is further away from the mean than the max, or vice versa (even a little):

max <- 0.78,
min <- 0.52,  
mean <- u_P,

briggsse <- ((max)-(mean))/1.96,
# altbriggsse <- (max-min)/(2*1.96),

## Generating the alpha and beta:

std.error <- briggsse, ## briggsse OR altbriggsse - as appropriate
alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1, ## alpha + beta (ab)
alpha.plus.beta,
alpha <- mean*alpha.plus.beta, ## alpha (a)
beta <- alpha*(1-mean)/mean, ## beta(b)
alpha,
beta,

u_P       = rbeta(n_runs, shape1 =  alpha, shape2 = beta),
mean(u_P),
u_P_alpha <- alpha,
u_P_beta <- beta,


  u_D       = 0,
# The utility of being dead doesnt vary, it always is the same utility to be a dead person, which is 0 because we don't have any quality of life, as we are no longer alive. I could have also just set u_D       = u_D, because when you set something equal to itself in here, that also means it's constant.

mean<-   AE1_DisUtil,
Maximum <- Maximum_AE1_DisUtil,
Maximum,
se <- ((Maximum) - (mean)) / 2,
se,  
std.error <- se,
alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1, ## alpha + beta (ab)
alpha <- mean*alpha.plus.beta, ## alpha (a)
beta <- alpha*(1-mean)/mean, ## beta(b)
alpha,
beta,

AE1_DisUtil        = rbeta(n_runs, shape1 =  alpha, shape2 = beta), 

alpha_u_AE1 <- alpha,
beta_u_AE1 <- beta,


mean<-   AE2_DisUtil,
Maximum <- Maximum_AE2_DisUtil,
Maximum,
se <- ((Maximum) - (mean)) / 2,
se,  
std.error <- se,
alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1, ## alpha + beta (ab)
alpha <- mean*alpha.plus.beta, ## alpha (a)
beta <- alpha*(1-mean)/mean, ## beta(b)
alpha,
beta,

AE2_DisUtil        = rbeta(n_runs, shape1 =  alpha, shape2 = beta), 

alpha_u_AE2 <- alpha,
beta_u_AE2 <- beta,


mean<-   AE3_DisUtil,
Maximum <- Maximum_AE3_DisUtil,
Maximum,
se <- ((Maximum) - (mean)) / 2,
se,  
std.error <- se,
alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1, ## alpha + beta (ab)
alpha <- mean*alpha.plus.beta, ## alpha (a)
beta <- alpha*(1-mean)/mean, ## beta(b)
alpha,
beta,

AE3_DisUtil        = rbeta(n_runs, shape1 =  alpha, shape2 = beta), 

alpha_u_AE3 <- alpha,
beta_u_AE3 <- beta,



# Discounting:
  
# A uniform distribution is a probability distribution in which every value between an interval from a to b is equally likely to be chosen. https://www.statology.org/uniform-distribution-r/
  
# "Generates random values that are evenly spread between min and max bounds" - https://docs.oracle.com/cd/E57185_01/CYBUG/apcs03s03s01.html 

# Devin Incerti talks about the Uniform distribution here: "The uniform distribution is useful when there is little data available to estimate a parameter and determine its distribution. It is always preferable to place uncertainty on a parameter even when there is little evidence for it than to assume a fixed value (which gives a false sense of precision). Sampling from the uniform distribution is straightforward." https://devinincerti.com/2018/02/10/psa.html  
  
#Reading the literature, it seems like studies pick a lower bound and upper bound for the discount rate, such that the average (mean of the discount rate) will reach the point estimate they started with: 
  
  # A Trial-Based Assessment of the Cost-Utility of Bevacizumab and Chemotherapy versus Chemotherapy Alone for Advanced Non-Small Cell Lung Cancer https://sci-hub.ru/10.1016/j.jval.2011.04.004 
  
# file:///C:/Users/Jonathan/OneDrive%20-%20Royal%20College%20of%20Surgeons%20in%20Ireland/COLOSSUS/Evidence%20Synthesis/Paper%20Materials%20and%20Methods/Hamdy%20Elsisi%20et%20al_2019_Cost-effectiveness%20of%20sorafenib%20versus%20best%20supportive%20care%20in%20advanced.pdf  
    
# Koen's excel file does this too: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\Matching the model with the evidence Koen
  
# as informed by: https://pubs.wsb.wisc.edu/academics/analytics-using-r-2019/uniform-continuous-version.html also saved here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\3.5 Uniform (Continuous Version) _ Analytics Using R.pdf


#  d_c       = 0.04/365,
#  d_e       = 0.04/365,
# If I wanted constant values for the discount rates I would have set them as above.
# Earlier I divided 0.04 by 365, so now I divide the upper value by 365 also.

  d_c    = runif(n_runs,  min = 0, max = 0.08/365),
  d_e    = runif(n_runs,  min = 0, max = 0.08/365),

  n_cycle   = n_cycle,
  t_cycle   = t_cycle
)

# Inspect the data.frame to see what it looks like (we'll see the first 6 observations):
head(df_PA_input)
```

```
##   coef_weibull_shape_SoC coef_weibull_scale_SoC coef_TTD_weibull_shape_SoC
## 1                 0.4295                  5.606                     0.3453
## 2                 0.3354                  5.674                     0.3215
## 3                 0.2912                  5.562                     0.4090
##   coef_TTD_weibull_scale_SoC HR_FP_Exp HR_PD_Exp max....0.22 min....0.12 mean....P_OSD_SoC
## 1                      6.633    0.7228    0.6747        0.22        0.12              0.17
## 2                      6.592    0.7449    0.7415        0.22        0.12              0.17
## 3                      6.688    0.6377    0.5860        0.22        0.12              0.17
##   briggsse......max.....mean...1.96 std.error....briggsse
## 1                           0.02551               0.02551
## 2                           0.02551               0.02551
## 3                           0.02551               0.02551
##   alpha.plus.beta....mean....1...mean...std.error.2....1 alpha.plus.beta
## 1                                                  215.8           215.8
## 2                                                  215.8           215.8
## 3                                                  215.8           215.8
##   alpha....mean...alpha.plus.beta beta....alpha....1...mean..mean alpha  beta P_OSD_SoC
## 1                           36.69                           179.1 36.69 179.1    0.1590
## 2                           36.69                           179.1 36.69 179.1    0.1708
## 3                           36.69                           179.1 36.69 179.1    0.1621
##   mean.P_OSD_SoC. P_OSD_SoC_alpha....alpha P_OSD_SoC_beta....beta max....0.22.1
## 1            0.17                    36.69                  179.1          0.22
## 2            0.17                    36.69                  179.1          0.22
## 3            0.17                    36.69                  179.1          0.22
##   min....0.12.1 mean....P_OSD_Exp briggsse......max.....mean...1.96.1
## 1          0.12              0.17                             0.02551
## 2          0.12              0.17                             0.02551
## 3          0.12              0.17                             0.02551
##   std.error....briggsse.1 alpha.plus.beta....mean....1...mean...std.error.2....1.1
## 1                 0.02551                                                    215.8
## 2                 0.02551                                                    215.8
## 3                 0.02551                                                    215.8
##   alpha.plus.beta.1 alpha....mean...alpha.plus.beta.1 beta....alpha....1...mean..mean.1
## 1             215.8                             36.69                             179.1
## 2             215.8                             36.69                             179.1
## 3             215.8                             36.69                             179.1
##   alpha.1 beta.1 P_OSD_Exp mean.P_OSD_Exp. P_OSD_Exp_alpha....alpha P_OSD_Exp_beta....beta
## 1   36.69  179.1    0.1426            0.17                    36.69                  179.1
## 2   36.69  179.1    0.1942            0.17                    36.69                  179.1
## 3   36.69  179.1    0.1759            0.17                    36.69                  179.1
##   mean....p_FA1_STD Maximum....Maximum_p_FA1_STD Maximum se......Maximum.....mean...2    se
## 1              0.04                        0.048   0.048                        0.004 0.004
## 2              0.04                        0.048   0.048                        0.004 0.004
## 3              0.04                        0.048   0.048                        0.004 0.004
##   std.error....se alpha.plus.beta....mean....1...mean...std.error.2....1.2
## 1           0.004                                                     2399
## 2           0.004                                                     2399
## 3           0.004                                                     2399
##   alpha....mean...alpha.plus.beta.2 beta....alpha....1...mean..mean.2 alpha.2 beta.2
## 1                             95.96                              2303   95.96   2303
## 2                             95.96                              2303   95.96   2303
## 3                             95.96                              2303   95.96   2303
##   p_FA1_STD alpha_p_FA1_STD....alpha beta_p_FA1_STD....beta mean....p_FA2_STD
## 1   0.03730                    95.96                   2303              0.31
## 2   0.03743                    95.96                   2303              0.31
## 3   0.04603                    95.96                   2303              0.31
##   Maximum....Maximum_p_FA2_STD Maximum.1 se......Maximum.....mean...2.1  se.1
## 1                        0.372     0.372                          0.031 0.031
## 2                        0.372     0.372                          0.031 0.031
## 3                        0.372     0.372                          0.031 0.031
##   std.error....se.1 alpha.plus.beta....mean....1...mean...std.error.2....1.3
## 1             0.031                                                    221.6
## 2             0.031                                                    221.6
## 3             0.031                                                    221.6
##   alpha....mean...alpha.plus.beta.3 beta....alpha....1...mean..mean.3 alpha.3 beta.3
## 1                             68.69                             152.9   68.69  152.9
## 2                             68.69                             152.9   68.69  152.9
## 3                             68.69                             152.9   68.69  152.9
##   p_FA2_STD alpha_p_FA2_STD....alpha beta_p_FA2_STD....beta mean....p_FA3_STD
## 1    0.3273                    68.69                  152.9              0.31
## 2    0.3542                    68.69                  152.9              0.31
## 3    0.3877                    68.69                  152.9              0.31
##   Maximum....Maximum_p_FA3_STD Maximum.2 se......Maximum.....mean...2.2  se.2
## 1                        0.372     0.372                          0.031 0.031
## 2                        0.372     0.372                          0.031 0.031
## 3                        0.372     0.372                          0.031 0.031
##   std.error....se.2 alpha.plus.beta....mean....1...mean...std.error.2....1.4
## 1             0.031                                                    221.6
## 2             0.031                                                    221.6
## 3             0.031                                                    221.6
##   alpha....mean...alpha.plus.beta.4 beta....alpha....1...mean..mean.4 alpha.4 beta.4
## 1                             68.69                             152.9   68.69  152.9
## 2                             68.69                             152.9   68.69  152.9
## 3                             68.69                             152.9   68.69  152.9
##   p_FA3_STD alpha_p_FA3_STD....alpha beta_p_FA3_STD....beta mean....p_FA1_EXPR
## 1    0.2878                    68.69                  152.9               0.07
## 2    0.3633                    68.69                  152.9               0.07
## 3    0.3070                    68.69                  152.9               0.07
##   Maximum....Maximum_p_FA1_EXPR Maximum.3 se......Maximum.....mean...2.3  se.3
## 1                         0.084     0.084                          0.007 0.007
## 2                         0.084     0.084                          0.007 0.007
## 3                         0.084     0.084                          0.007 0.007
##   std.error....se.3 alpha.plus.beta....mean....1...mean...std.error.2....1.5
## 1             0.007                                                     1328
## 2             0.007                                                     1328
## 3             0.007                                                     1328
##   alpha....mean...alpha.plus.beta.5 beta....alpha....1...mean..mean.5 alpha.5 beta.5
## 1                             92.93                              1235   92.93   1235
## 2                             92.93                              1235   92.93   1235
## 3                             92.93                              1235   92.93   1235
##   p_FA1_EXPR alpha_p_FA1_EXPR....alpha beta_p_FA1_EXPR....beta mean....p_FA2_EXPR
## 1    0.07407                     92.93                    1235               0.11
## 2    0.06746                     92.93                    1235               0.11
## 3    0.07592                     92.93                    1235               0.11
##   Maximum....Maximum_p_FA2_EXPR Maximum.4 se......Maximum.....mean...2.4  se.4
## 1                         0.132     0.132                          0.011 0.011
## 2                         0.132     0.132                          0.011 0.011
## 3                         0.132     0.132                          0.011 0.011
##   std.error....se.4 alpha.plus.beta....mean....1...mean...std.error.2....1.6
## 1             0.011                                                    808.1
## 2             0.011                                                    808.1
## 3             0.011                                                    808.1
##   alpha....mean...alpha.plus.beta.6 beta....alpha....1...mean..mean.6 alpha.6 beta.6
## 1                             88.89                             719.2   88.89  719.2
## 2                             88.89                             719.2   88.89  719.2
## 3                             88.89                             719.2   88.89  719.2
##   p_FA2_EXPR alpha_p_FA2_EXPR....alpha beta_p_FA2_EXPR....beta mean....p_FA3_EXPR
## 1    0.11395                     88.89                   719.2               0.07
## 2    0.11087                     88.89                   719.2               0.07
## 3    0.09936                     88.89                   719.2               0.07
##   Maximum....Maximum_p_FA3_EXPR Maximum.5 se......Maximum.....mean...2.5  se.5
## 1                         0.084     0.084                          0.007 0.007
## 2                         0.084     0.084                          0.007 0.007
## 3                         0.084     0.084                          0.007 0.007
##   std.error....se.5 alpha.plus.beta....mean....1...mean...std.error.2....1.7
## 1             0.007                                                     1328
## 2             0.007                                                     1328
## 3             0.007                                                     1328
##   alpha....mean...alpha.plus.beta.7 beta....alpha....1...mean..mean.7 alpha.7 beta.7
## 1                             92.93                              1235   92.93   1235
## 2                             92.93                              1235   92.93   1235
## 3                             92.93                              1235   92.93   1235
##   p_FA3_EXPR alpha_p_FA3_EXPR....alpha beta_p_FA3_EXPR....beta
## 1    0.07432                     92.93                    1235
## 2    0.07070                     92.93                    1235
## 3    0.06528                     92.93                    1235
##   Maximum....Maximum_administration_cost Mean....administration_cost
## 1                                  377.9                       314.9
## 2                                  377.9                       314.9
## 3                                  377.9                       314.9
##   se......Maximum.....Mean...2  se.6 mean....Mean  mean mn.cIntervention....mean
## 1                        31.49 31.49        314.9 314.9                    314.9
## 2                        31.49 31.49        314.9 314.9                    314.9
## 3                        31.49 31.49        314.9 314.9                    314.9
##   se.cIntervention....se a.cIntervention.....mn.cIntervention.se.cIntervention..2
## 1                  31.49                                                      100
## 2                  31.49                                                      100
## 3                  31.49                                                      100
##   b.cIntervention.....se.cIntervention.2..mn.cIntervention a.cIntervention b.cIntervention
## 1                                                    3.149             100           3.149
## 2                                                    3.149             100           3.149
## 3                                                    3.149             100           3.149
##   administration_cost a.cIntervention_administration_cost....a.cIntervention
## 1               279.3                                                    100
## 2               345.7                                                    100
## 3               299.2                                                    100
##   b.cIntervention_administration_cost....b.cIntervention Maximum....Maximum_c_PFS_Folfox
## 1                                                  3.149                           342.6
## 2                                                  3.149                           342.6
## 3                                                  3.149                           342.6
##   Mean....c_PFS_Folfox se......Maximum.....Mean...2.1  se.7 mean....Mean.1 mean.1
## 1                285.5                          28.55 28.55          285.5  285.5
## 2                285.5                          28.55 28.55          285.5  285.5
## 3                285.5                          28.55 28.55          285.5  285.5
##   mn.cIntervention....mean.1 se.cIntervention....se.1
## 1                      285.5                    28.55
## 2                      285.5                    28.55
## 3                      285.5                    28.55
##   a.cIntervention.....mn.cIntervention.se.cIntervention..2.1
## 1                                                        100
## 2                                                        100
## 3                                                        100
##   b.cIntervention.....se.cIntervention.2..mn.cIntervention.1 a.cIntervention.1
## 1                                                      2.855               100
## 2                                                      2.855               100
## 3                                                      2.855               100
##   b.cIntervention.1 c_PFS_Folfox a.cIntervention_c_PFS_Folfox....a.cIntervention
## 1             2.855        320.8                                             100
## 2             2.855        313.7                                             100
## 3             2.855        253.5                                             100
##   b.cIntervention_c_PFS_Folfox....b.cIntervention Maximum....Maximum_c_PFS_Bevacizumab
## 1                                           2.855                                 1591
## 2                                           2.855                                 1591
## 3                                           2.855                                 1591
##   Mean....c_PFS_Bevacizumab se......Maximum.....Mean...2.2  se.8 mean....Mean.2 mean.2
## 1                      1326                          132.6 132.6           1326   1326
## 2                      1326                          132.6 132.6           1326   1326
## 3                      1326                          132.6 132.6           1326   1326
##   mn.cIntervention....mean.2 se.cIntervention....se.2
## 1                       1326                    132.6
## 2                       1326                    132.6
## 3                       1326                    132.6
##   a.cIntervention.....mn.cIntervention.se.cIntervention..2.2
## 1                                                        100
## 2                                                        100
## 3                                                        100
##   b.cIntervention.....se.cIntervention.2..mn.cIntervention.2 a.cIntervention.2
## 1                                                      13.26               100
## 2                                                      13.26               100
## 3                                                      13.26               100
##   b.cIntervention.2 c_PFS_Bevacizumab a.cIntervention_c_PFS_Bevacizumab....a.cIntervention
## 1             13.26              1321                                                  100
## 2             13.26              1113                                                  100
## 3             13.26              1302                                                  100
##   b.cIntervention_c_PFS_Bevacizumab....b.cIntervention Maximum....Maximum_c_OS_Folfiri
## 1                                                13.26                           167.5
## 2                                                13.26                           167.5
## 3                                                13.26                           167.5
##   Mean....c_OS_Folfiri se......Maximum.....Mean...2.3  se.9 mean....Mean.3 mean.3
## 1                139.6                          13.96 13.96          139.6  139.6
## 2                139.6                          13.96 13.96          139.6  139.6
## 3                139.6                          13.96 13.96          139.6  139.6
##   mn.cIntervention....mean.3 se.cIntervention....se.3
## 1                      139.6                    13.96
## 2                      139.6                    13.96
## 3                      139.6                    13.96
##   a.cIntervention.....mn.cIntervention.se.cIntervention..2.3
## 1                                                        100
## 2                                                        100
## 3                                                        100
##   b.cIntervention.....se.cIntervention.2..mn.cIntervention.3 a.cIntervention.3
## 1                                                      1.396               100
## 2                                                      1.396               100
## 3                                                      1.396               100
##   b.cIntervention.3 c_OS_Folfiri a.cIntervention_c_OS_Folfiri....a.cIntervention
## 1             1.396        131.4                                             100
## 2             1.396        111.7                                             100
## 3             1.396        154.8                                             100
##   b.cIntervention_c_OS_Folfiri....b.cIntervention c_D Maximum....Maximum_c_AE1
## 1                                           1.396   0                     5863
## 2                                           1.396   0                     5863
## 3                                           1.396   0                     5863
##   Mean....c_AE1 se......Maximum.....Mean...2.4 se.10 mean....Mean.4 mean.4
## 1          4886                          488.6 488.6           4886   4886
## 2          4886                          488.6 488.6           4886   4886
## 3          4886                          488.6 488.6           4886   4886
##   mn.cIntervention....mean.4 se.cIntervention....se.4
## 1                       4886                    488.6
## 2                       4886                    488.6
## 3                       4886                    488.6
##   a.cIntervention.....mn.cIntervention.se.cIntervention..2.4
## 1                                                        100
## 2                                                        100
## 3                                                        100
##   b.cIntervention.....se.cIntervention.2..mn.cIntervention.4 a.cIntervention.4
## 1                                                      48.86               100
## 2                                                      48.86               100
## 3                                                      48.86               100
##   b.cIntervention.4 c_AE1 a.cIntervention_c_AE1....a.cIntervention
## 1             48.86  4799                                      100
## 2             48.86  5590                                      100
## 3             48.86  4872                                      100
##   b.cIntervention_c_AE1....b.cIntervention Maximum....Maximum_c_AE2 Mean....c_AE2
## 1                                    48.86                    608.8         507.4
## 2                                    48.86                    608.8         507.4
## 3                                    48.86                    608.8         507.4
##   se......Maximum.....Mean...2.5 se.11 mean....Mean.5 mean.5 mn.cIntervention....mean.5
## 1                          50.74 50.74          507.4  507.4                      507.4
## 2                          50.74 50.74          507.4  507.4                      507.4
## 3                          50.74 50.74          507.4  507.4                      507.4
##   se.cIntervention....se.5 a.cIntervention.....mn.cIntervention.se.cIntervention..2.5
## 1                    50.74                                                        100
## 2                    50.74                                                        100
## 3                    50.74                                                        100
##   b.cIntervention.....se.cIntervention.2..mn.cIntervention.5 a.cIntervention.5
## 1                                                      5.074               100
## 2                                                      5.074               100
## 3                                                      5.074               100
##   b.cIntervention.5 c_AE2 a.cIntervention_c_AE2....a.cIntervention
## 1             5.074 506.2                                      100
## 2             5.074 596.6                                      100
## 3             5.074 559.7                                      100
##   b.cIntervention_c_AE2....b.cIntervention Maximum....Maximum_c_AE3 Mean....c_AE3
## 1                                    5.074                      114         95.03
## 2                                    5.074                      114         95.03
## 3                                    5.074                      114         95.03
##   se......Maximum.....Mean...2.6 se.12 mean....Mean.6 mean.6 mn.cIntervention....mean.6
## 1                          9.503 9.503          95.03  95.03                      95.03
## 2                          9.503 9.503          95.03  95.03                      95.03
## 3                          9.503 9.503          95.03  95.03                      95.03
##   se.cIntervention....se.6 a.cIntervention.....mn.cIntervention.se.cIntervention..2.6
## 1                    9.503                                                        100
## 2                    9.503                                                        100
## 3                    9.503                                                        100
##   b.cIntervention.....se.cIntervention.2..mn.cIntervention.6 a.cIntervention.6
## 1                                                     0.9503               100
## 2                                                     0.9503               100
## 3                                                     0.9503               100
##   b.cIntervention.6  c_AE3 a.cIntervention_c_AE3....a.cIntervention
## 1            0.9503  87.34                                      100
## 2            0.9503 100.36                                      100
## 3            0.9503  76.43                                      100
##   b.cIntervention_c_AE3....b.cIntervention max....1 min....0.68 mean....u_F
## 1                                   0.9503        1        0.68        0.85
## 2                                   0.9503        1        0.68        0.85
## 3                                   0.9503        1        0.68        0.85
##   altbriggsse.....max...min...2...1.96. std.error....altbriggsse
## 1                               0.08163                  0.08163
## 2                               0.08163                  0.08163
## 3                               0.08163                  0.08163
##   alpha.plus.beta....mean....1...mean...std.error.2....1.8 alpha.plus.beta.2
## 1                                                    18.13             18.13
## 2                                                    18.13             18.13
## 3                                                    18.13             18.13
##   alpha....mean...alpha.plus.beta.8 beta....alpha....1...mean..mean.8 alpha.8 beta.8    u_F
## 1                             15.41                              2.72   15.41   2.72 0.8669
## 2                             15.41                              2.72   15.41   2.72 0.9104
## 3                             15.41                              2.72   15.41   2.72 0.7911
##   mean.u_F. u_F_alpha....alpha u_F_beta....beta max....0.78 min....0.52 mean....u_P
## 1      0.85              15.41             2.72        0.78        0.52        0.65
## 2      0.85              15.41             2.72        0.78        0.52        0.65
## 3      0.85              15.41             2.72        0.78        0.52        0.65
##   briggsse......max.....mean...1.96.2 std.error....briggsse.2
## 1                             0.06633                 0.06633
## 2                             0.06633                 0.06633
## 3                             0.06633                 0.06633
##   alpha.plus.beta....mean....1...mean...std.error.2....1.9 alpha.plus.beta.3
## 1                                                    50.71             50.71
## 2                                                    50.71             50.71
## 3                                                    50.71             50.71
##   alpha....mean...alpha.plus.beta.9 beta....alpha....1...mean..mean.9 alpha.9 beta.9    u_P
## 1                             32.96                             17.75   32.96  17.75 0.6770
## 2                             32.96                             17.75   32.96  17.75 0.7057
## 3                             32.96                             17.75   32.96  17.75 0.6445
##   mean.u_P. u_P_alpha....alpha u_P_beta....beta u_D mean....AE1_DisUtil
## 1      0.65              32.96            17.75   0                0.45
## 2      0.65              32.96            17.75   0                0.45
## 3      0.65              32.96            17.75   0                0.45
##   Maximum....Maximum_AE1_DisUtil Maximum.6 se......Maximum.....mean...2.6 se.13
## 1                           0.54      0.54                          0.045 0.045
## 2                           0.54      0.54                          0.045 0.045
## 3                           0.54      0.54                          0.045 0.045
##   std.error....se.6 alpha.plus.beta....mean....1...mean...std.error.2....1.10
## 1             0.045                                                     121.2
## 2             0.045                                                     121.2
## 3             0.045                                                     121.2
##   alpha....mean...alpha.plus.beta.10 beta....alpha....1...mean..mean.10 alpha.10 beta.10
## 1                              54.55                              66.67    54.55   66.67
## 2                              54.55                              66.67    54.55   66.67
## 3                              54.55                              66.67    54.55   66.67
##   AE1_DisUtil alpha_u_AE1....alpha beta_u_AE1....beta mean....AE2_DisUtil
## 1      0.3976                54.55              66.67                0.19
## 2      0.4539                54.55              66.67                0.19
## 3      0.4483                54.55              66.67                0.19
##   Maximum....Maximum_AE2_DisUtil Maximum.7 se......Maximum.....mean...2.7 se.14
## 1                          0.228     0.228                          0.019 0.019
## 2                          0.228     0.228                          0.019 0.019
## 3                          0.228     0.228                          0.019 0.019
##   std.error....se.7 alpha.plus.beta....mean....1...mean...std.error.2....1.11
## 1             0.019                                                     425.3
## 2             0.019                                                     425.3
## 3             0.019                                                     425.3
##   alpha....mean...alpha.plus.beta.11 beta....alpha....1...mean..mean.11 alpha.11 beta.11
## 1                              80.81                              344.5    80.81   344.5
## 2                              80.81                              344.5    80.81   344.5
## 3                              80.81                              344.5    80.81   344.5
##   AE2_DisUtil alpha_u_AE2....alpha beta_u_AE2....beta mean....AE3_DisUtil
## 1      0.2194                80.81              344.5                0.36
## 2      0.2090                80.81              344.5                0.36
## 3      0.1865                80.81              344.5                0.36
##   Maximum....Maximum_AE3_DisUtil Maximum.8 se......Maximum.....mean...2.8 se.15
## 1                          0.432     0.432                          0.036 0.036
## 2                          0.432     0.432                          0.036 0.036
## 3                          0.432     0.432                          0.036 0.036
##   std.error....se.8 alpha.plus.beta....mean....1...mean...std.error.2....1.12
## 1             0.036                                                     176.8
## 2             0.036                                                     176.8
## 3             0.036                                                     176.8
##   alpha....mean...alpha.plus.beta.12 beta....alpha....1...mean..mean.12 alpha.12 beta.12
## 1                              63.64                              113.1    63.64   113.1
## 2                              63.64                              113.1    63.64   113.1
## 3                              63.64                              113.1    63.64   113.1
##   AE3_DisUtil alpha_u_AE3....alpha beta_u_AE3....beta        d_c        d_e n_cycle t_cycle
## 1      0.4002                63.64              113.1 0.00020978 0.00008106     143      14
## 2      0.3636                63.64              113.1 0.00008086 0.00012278     143      14
## 3      0.3401                63.64              113.1 0.00015620 0.00005348     143      14
##  [ reached 'max' / getOption("max.print") -- omitted 3 rows ]
```

```r
# It's a dataframe made up of the 10,000 values I asked be made at the start of this code chunk.

# If I wanted to save the dataframe, I would do this as follows:

#save(df_PA_input, file = "df_PA_input.rda")
```


```r
# 09.1 Conduct probabilistic sensitivity analysis

# Running the probabilistic analysis :

# First we need to create data.frames to store the output from the PSA:

df_c <- df_e <- data.frame(
  SoC = rep(NA, n_runs),
  Exp = rep(NA, n_runs)
)

# As you'll see, first we make blank (repeat NA for the number of runs of the simulationn_runs) data.frames for costs (df_c) and effectiveness (df_e) for SoC and the experimental treatment:

head(df_c)
```

```
##   SoC Exp
## 1  NA  NA
## 2  NA  NA
## 3  NA  NA
## 4  NA  NA
## 5  NA  NA
## 6  NA  NA
```

```r
# > head(df_c)
#   SoC Exp
# 1  NA  NA
# 2  NA  NA
# 3  NA  NA
# 4  NA  NA
# 5  NA  NA
# 6  NA  NA

head(df_e)
```

```
##   SoC Exp
## 1  NA  NA
## 2  NA  NA
## 3  NA  NA
## 4  NA  NA
## 5  NA  NA
## 6  NA  NA
```

```r
# > head(df_e)
#   SoC Exp
# 1  NA  NA
# 2  NA  NA
# 3  NA  NA
# 4  NA  NA
# 5  NA  NA
# 6  NA  NA

# We run the Markov model for each set of parameter values from the PSA input dataset (a set of parameters here is the row of parameter values in the PSA data.frame from whatever run number of the nruns in the PSA dataset we are on, i.e. if we were doing this for run number 10 out of 10,000, we would be on row 10 in the data.frame (as each row refers to a run) and we would use all the values for costs and effect that appear in this row when running the Markov model. So, we would be using all the random draws for that PSA run in the Markov model).

# - I read a note indicating that this loop can be run in parallel to decrease the runtime, something to consider in the future if it takes a very long time...

for(i_run in 1:n_runs){

    # Evaluate the model and store the outcomes
  l_out_temp    <- oncologySemiMarkov(l_params_all = df_PA_input[i_run, ], n_wtp = n_wtp)
# The above is basically saying, apply the oncologySemiMarkov_function, where l_params_all in the function (i.e. the list of parameters the function is to be applied to) is equal to the parameters from the PSA data.frame for the run we are in, and the willingness to pay threshold is n_wtp.
  df_c[i_run, ] <- l_out_temp$Cost
  df_e[i_run, ] <- l_out_temp$Effect
# The above says, for the costs and effectiveness data.frames, store the value of costs and effects for each run that we are on in a row that reflects that run (remembering that [ROW,COLUMN], we are putting each cost and effect in a row that relates to the number of the run we are on, so if we are on run 1, i_run = 1 and we store the costs and effects for that run 1 in row 1. Remembering that our oncologySemiMarkov makes the "Cost" and "Effect" parameters at the end of the function, after applying the Markov cost-effectiveness model to all our input data for the cost-effectiveness model (so, things like, cost, utility and probability), so we are just pulling the ouputted Cost and Effect values calculated from a Markov cost-effectiveness model applied to our input data after the input data has been randomly drawn from a PSA (per the PSA input dataframe)).  

  
  # While we're doing this, we might like to display the progress of the simulation:
  if(i_run/(n_runs/10) == round(i_run/(n_runs/10), 0)) { # We've chosen to display progress every 10%
    cat('\r', paste(i_run/n_runs * 100, "% done", sep = " "))
  }
}
```

```
## 
 10 % done
 20 % done
 30 % done
 40 % done
 50 % done
 60 % done
 70 % done
 80 % done
 90 % done
 100 % done
```


```r
#09.2 Create PSA object for dampack

# Dampack has a number of functions to summarise and visualise the results of a probabilistic sensitivity analysis. However, the data needs to be in a specific structure before we can use those functions. 

# The 'dampack' package contains multiple useful functions that summarize and visualize the results of a
# probabilitic analysis. To use those functions, the data has to be in a particular structure.
l_PA <- make_psa_obj(cost          = df_c, 
                     effectiveness = df_e, 
                     parameters    = df_PA_input, 
                     strategies    = c("SoC", "Exp"))

# So, basically we make a psa object for Dampack where df_c is the dataframe of costs from the Markov model being applied to the PSA data, and df_e is the data.frame of effectiveness from the Markov model being applied to the PSA dataset, the parameters that are included are those from the PSA analysis, which we fed into df_PA_input above (df_PA_input<-) and the two strategies are SoC and Exp.
```


```r
#09.2.1 Save PSA objects

# If we wanted to save the PSA objects once they have been created above, we could do this as follows (v_names_strats is just another way of including the strategies part from above):
# save(df_PA_input, df_c, df_e, v_names_strats, n_str, l_PA,
#     file = "markov_3state_PSA_dataset.RData")
```


```r
#09.3.1 Conduct CEA with probabilistic output

# First we take the mean outcome estimates, that is, we summarise the expected costs and effects for each strategy from the PSA:
(df_out_ce_PA <- summary(l_PA))
```

```
##   Strategy meanCost meanEffect
## 1      SoC    17638     0.3372
## 2      Exp    50615     0.6493
```

```r
# Calculate incremental cost-effectiveness ratios (ICERs)

# Then we calculate the ICERs from this df_out_ce_PA (summary must be a dampack function doing things under the hood to create a selectable ($) meanCost, meanEffect and Strategy parameter in df_out_ce_PA):
(df_cea_PA <- calculate_icers(cost       = df_out_ce_PA$meanCost, 
                              effect     = df_out_ce_PA$meanEffect,
                              strategies = df_out_ce_PA$Strategy))
```

```
##   Strategy  Cost Effect Inc_Cost Inc_Effect   ICER Status
## 1      SoC 17638 0.3372       NA         NA     NA     ND
## 2      Exp 50615 0.6493    32977     0.3121 105663     ND
```

```r
# We can view the ICER results from the PSA here:
df_cea_PA
```

```
##   Strategy  Cost Effect Inc_Cost Inc_Effect   ICER Status
## 1      SoC 17638 0.3372       NA         NA     NA     ND
## 2      Exp 50615 0.6493    32977     0.3121 105663     ND
```

```r
# If we wanted to save the CEA (or leauge) table with ICERs, we would do this as follows:
# As .RData
# save(df_cea_pa, 
#     file = "markov_3state_probabilistic_CEA_results.RData")
# As .csv
# write.csv(df_cea_pa, 
#          file = "markov_3state_probabilistic_CEA_results.csv")


## CEA table in proper format ---- per: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\R-HTA in LMICs Intermediate R-HTA Modelling Tutorial\September-Workshop-main\September-Workshop-main\analysis\cSTM_time_dep_simulation.r
table_cea_PA <- format_table_cea(df_cea_PA) # Function included in "R/Functions.R"; depends on the `scales` package
table_cea_PA
```

```
##   Strategy Costs ($) QALYs Incremental Costs ($) Incremental QALYs ICER ($/QALY) Status
## 1      SoC    17,638  0.34                  <NA>                NA          <NA>     ND
## 2      Exp    50,615  0.65                32,977              0.31       105,663     ND
```


```r
#09.3.2 Cost-Effectiveness Scatter plot

# Incremental cost-effectiveness plane
plot(l_PA)
```

<img src="Markov_3state_files/figure-html/unnamed-chunk-43-1.png" width="672" />

```r
ggsave(paste("CE_Scatter_Plot_", country_name[1], ".png", sep = ""), width = 8, height = 4, dpi=300)
while (!is.null(dev.list()))  dev.off()

#png(paste("CE_Scatter_Plot_", country_name[1], ".png", sep = ""))
#dev.off()

#plot(l_PA, xlim = c(9.5, 22.5))
# In the DARTH package R code they use the additional bits above, I can see how they look in my own model, and if I'd like to use them.
```


```r
#09.4.2 Cost-effectiveness acceptability curves (CEACs) and frontier (CEAF)

# Cost-effectiveness acceptability curve (CEAC):

# We first generate a vector of willingness to pay values (thresholds) to define for which values the CEAC is made:
v_wtp <- seq(0, 500000, by = 10000)
# This basically gives you a sequence of willingness to pay thresholds from 0 all the way up to 500,000 euro, increasing by 10,000 euro each time, so start with 0 euro, go to 10,000 euro, go to 20,000 euro, and so on until you hit 500,000. You can chose any max value you like and any increment value you like, for example, in the DARTH material they use the following: v_wtp <- seq(0, 45000, by = 1000)
CEAC_obj <- ceac(wtp = v_wtp, psa = l_PA)


# The below provides details on the regions of highest probability of cost-effectiveness for each strategy
summary(CEAC_obj)
```

```
##   range_min range_max cost_eff_strat
## 1         0    110000            SoC
## 2    110000    500000            Exp
```

```r
# CEAC and cost-effectiveness acceptability frontier (CEAF) plot
plot(CEAC_obj)
```

<img src="Markov_3state_files/figure-html/unnamed-chunk-44-1.png" width="672" />

```r
ggsave(paste("CEAC_", country_name[1], ".png", sep = ""), width = 8, height = 4, dpi=300)
while (!is.null(dev.list()))  dev.off()
#png(paste("CEAC_", country_name[1], ".png", sep = ""))
#dev.off()
```


```r
#09.4.3 Plot cost-effectiveness frontier
# plot(df_cea_PA)
# I don't use this plot in my paper anymore
```


```r
#09.4.4 Expected Loss Curves (ELCs)
#The expected loss is the the quantification of the foregone benefits when choosing a suboptimal strategy given current evidence.
elc_obj <- calc_exp_loss(wtp = v_wtp, psa = l_PA)
elc_obj
```

```
##        WTP Strategy Expected_Loss On_Frontier
## 1        0      SoC       0.00000        TRUE
## 2        0      Exp   32977.31736       FALSE
## 3    10000      SoC       0.00000        TRUE
## 4    10000      Exp   29856.33129       FALSE
## 5    20000      SoC       0.00000        TRUE
## 6    20000      Exp   26735.34522       FALSE
## 7    30000      SoC       0.00000        TRUE
## 8    30000      Exp   23614.35915       FALSE
## 9    40000      SoC       0.00000        TRUE
## 10   40000      Exp   20493.37308       FALSE
## 11   50000      SoC       0.00000        TRUE
## 12   50000      Exp   17372.38701       FALSE
## 13   60000      SoC       0.00000        TRUE
## 14   60000      Exp   14251.40094       FALSE
## 15   70000      SoC       4.61129        TRUE
## 16   70000      Exp   11135.02617       FALSE
## 17   80000      SoC      71.73958        TRUE
## 18   80000      Exp    8081.16838       FALSE
## 19   90000      SoC     426.20889        TRUE
## 20   90000      Exp    5314.65162       FALSE
## 21  100000      SoC    1377.68238        TRUE
## 22  100000      Exp    3145.13904       FALSE
## 23  110000      SoC    3063.55128       FALSE
## 24  110000      Exp    1710.02187        TRUE
## 25  120000      SoC    5360.09388       FALSE
## 26  120000      Exp     885.57840        TRUE
## 27  130000      SoC    8050.45317       FALSE
## 28  130000      Exp     454.95162        TRUE
## 29  140000      SoC   10951.03413       FALSE
## 30  140000      Exp     234.54650        TRUE
## 31  150000      SoC   13963.91227       FALSE
## 32  150000      Exp     126.43857        TRUE
## 33  160000      SoC   17028.23603       FALSE
## 34  160000      Exp      69.77627        TRUE
## 35  170000      SoC   20117.83766       FALSE
## 36  170000      Exp      38.39183        TRUE
## 37  180000      SoC   23221.76423       FALSE
## 38  180000      Exp      21.33232        TRUE
## 39  190000      SoC   26333.21074       FALSE
## 40  190000      Exp      11.79277        TRUE
## 41  200000      SoC   29448.61980       FALSE
## 42  200000      Exp       6.21575        TRUE
## 43  210000      SoC   32566.97901       FALSE
## 44  210000      Exp       3.58889        TRUE
## 45  220000      SoC   35686.38451       FALSE
## 46  220000      Exp       2.00832        TRUE
## 47  230000      SoC   38806.60508       FALSE
## 48  230000      Exp       1.24282        TRUE
## 49  240000      SoC   41927.11444       FALSE
## 50  240000      Exp       0.76611        TRUE
## 51  250000      SoC   45047.73006       FALSE
## 52  250000      Exp       0.39566        TRUE
## 53  260000      SoC   48168.43699       FALSE
## 54  260000      Exp       0.11652        TRUE
## 55  270000      SoC   51289.31667       FALSE
## 56  270000      Exp       0.01012        TRUE
## 57  280000      SoC   54410.29261       FALSE
## 58  280000      Exp       0.00000        TRUE
## 59  290000      SoC   57531.27868       FALSE
## 60  290000      Exp       0.00000        TRUE
## 61  300000      SoC   60652.26475       FALSE
## 62  300000      Exp       0.00000        TRUE
## 63  310000      SoC   63773.25082       FALSE
## 64  310000      Exp       0.00000        TRUE
## 65  320000      SoC   66894.23690       FALSE
## 66  320000      Exp       0.00000        TRUE
## 67  330000      SoC   70015.22297       FALSE
## 68  330000      Exp       0.00000        TRUE
## 69  340000      SoC   73136.20904       FALSE
## 70  340000      Exp       0.00000        TRUE
## 71  350000      SoC   76257.19511       FALSE
## 72  350000      Exp       0.00000        TRUE
## 73  360000      SoC   79378.18118       FALSE
## 74  360000      Exp       0.00000        TRUE
## 75  370000      SoC   82499.16725       FALSE
## 76  370000      Exp       0.00000        TRUE
## 77  380000      SoC   85620.15332       FALSE
## 78  380000      Exp       0.00000        TRUE
## 79  390000      SoC   88741.13939       FALSE
## 80  390000      Exp       0.00000        TRUE
## 81  400000      SoC   91862.12546       FALSE
## 82  400000      Exp       0.00000        TRUE
## 83  410000      SoC   94983.11153       FALSE
## 84  410000      Exp       0.00000        TRUE
## 85  420000      SoC   98104.09760       FALSE
## 86  420000      Exp       0.00000        TRUE
## 87  430000      SoC  101225.08367       FALSE
## 88  430000      Exp       0.00000        TRUE
## 89  440000      SoC  104346.06974       FALSE
## 90  440000      Exp       0.00000        TRUE
## 91  450000      SoC  107467.05581       FALSE
## 92  450000      Exp       0.00000        TRUE
## 93  460000      SoC  110588.04188       FALSE
## 94  460000      Exp       0.00000        TRUE
## 95  470000      SoC  113709.02796       FALSE
## 96  470000      Exp       0.00000        TRUE
## 97  480000      SoC  116830.01403       FALSE
## 98  480000      Exp       0.00000        TRUE
## 99  490000      SoC  119951.00010       FALSE
## 100 490000      Exp       0.00000        TRUE
## 101 500000      SoC  123071.98617       FALSE
## 102 500000      Exp       0.00000        TRUE
```

```r
# ELC plot
#plot(elc_obj, log_y = FALSE)
# I don't use this plot anymore
```


```r
#09.4.4 Expected value of perfect information (EVPI)
# Expected value of perfect information (EVPI)

#A value-of-information analysis estimates the expected value of perfect information (EVPI), that is,

#Value of information is discussed in the York course and below:

#C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\CDC_Exclusive_Decision Modeling for Public Health_DARTH

#https://cran.r-project.org/web/packages/dampack/vignettes/voi.html

#There's also a paper on this here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\Betadist utility\EVSI.doc

EVPI_obj <- calc_evpi(wtp = v_wtp, psa = l_PA)
# EVPI plot
#plot(EVPI_obj, effect_units = "QALY")
# I don't plot this anymore.
```


```r
# For building the Table in the paper, and for referring to parameter values in the paper, I save the parameters I created in an RDA file named after the country I am studying:

#save to rda file
#save(c_PFS_Folfox, c_PFS_Bevacizumab, c_OS_Folfiri, administration_cost, c_AE1, c_AE2, c_AE3, Minimum_c_PFS_Folfox, Maximum_c_PFS_Folfox, Minimum_c_OS_Folfiri, Maximum_c_OS_Folfiri, Minimum_c_PFS_Bevacizumab, Maximum_c_PFS_Bevacizumab, Minimum_administration_cost, Maximum_administration_cost, Minimum_c_AE1, Maximum_c_AE1, Minimum_c_AE2, Maximum_c_AE2, Minimum_c_AE3, Maximum_c_AE3, n_wtp, Incremental_Cost, Incremental_Effect, ICER, tc_d_Exp, tc_d_SoC, country_name, file=paste("my_data_", country_name[1], ".rda", sep = ""))

# This creates an RDA file with all the parameters I created in this file in it.

# Next, in my Markdown file that calls this file, I will read in these parameters and name each of them after the country I am studying, to give me country specific values in my analysis.
```

## 08.3.3 Table Describing Parameters

To build a Table describing parameters, you click on the Table button at the top, and design it in there.
Then to include the parameter values automatically as they are updated you fill in the parameter name you want, highlight it in the cell and click \</\> from above to put it in a code block.
You do the same for gamma, etc., put this in code blocks also.
<https://rpruim.github.io/s341/S19/from-class/MathinRmd.html#:~:text=Math%20inside%20RMarkdown,10n%3D1n2.>

Per: [Putting the value of a variable into a table in R Markdown, rather than it's name - Stack Overflow](https://stackoverflow.com/questions/72902548/putting-the-value-of-a-variable-into-a-table-in-r-markdown-rather-than-its-nam)

Line 320 of this: <https://github.com/DARTH-git/cohort-modeling-tutorial-intro/blob/main/manuscript/cSTM_Tutorial_Intro.Rmd> is informative when viewing the final document on page 7 here: <https://arxiv.org/pdf/2001.07824.pdf>

Some helpful tips on using math notation in R Markdown.

<https://rpruim.github.io/s341/S19/from-class/MathinRmd.html>

This paper says in technical terms which distributions fit and why:

Model Parameter Estimation and Uncertainty Analysis: A Report of the ISPOR-SMDM Modeling Good Research Practices Task Force Working Group--6 <file:///C:/Users/Jonathan/OneDrive%20-%20Royal%20College%20of%20Surgeons%20in%20Ireland/COLOSSUS/Briggs%20et%20al%202012%20model%20parameter%20estimation%20and%20uncertainty.pdf>

| Parameter                                            | Base Case Value       | Minimum Value                 | Maximum Value                 | Source        | Distribution                                                                        |
|-----------|-----------|-----------|-----------|-----------|------------------|
| **Cost (Per Cycle)**                                 |                       |                               |                               |               |                                                                                     |
| FOLFOX                                               | `c_PFS_Folfox`        | `Minimum_c_PFS_Folfox`        | `Maximum_c_PFS_Folfox`        |               | GAMMA(`a.cIntervention_c_PFS_Folfox`, `b.cIntervention_c_PFS_Folfox`)               |
| FOLFIRI                                              | `c_OS_Folfiri`        | `Minimum_c_OS_Folfiri`        | `Maximum_c_OS_Folfiri`        |               | GAMMA(`a.cIntervention_c_OS_Folfiri`, `b.cIntervention_c_OS_Folfiri`)               |
| Bevacizumab                                          | `c_PFS_Bevacizumab`   | `Minimum_c_PFS_Bevacizumab`   | `Maximum_c_PFS_Bevacizumab`   |               | GAMMA( `a.cIntervention_c_PFS_Bevacizumab`, `b.cIntervention_c_PFS_Bevacizumab` )   |
| Administration Cost                                  | `administration_cost` | `Minimum_administration_cost` | `Maximum_administration_cost` |               | GAMMA(`a.cIntervention_administration_cost`, `b.cIntervention_administration_cost`) |
| **Adverse Event Cost**                               |                       |                               |                               |               |                                                                                     |
| Leukopenia                                           | `c_AE1`               | `Minimum_c_AE1`               | `Maximum_c_AE1`               |               | `GAMMA(a.cIntervention_c_AE1, b.cIntervention_c_AE1)`                               |
| Diarrhea                                             | `c_AE2`               | `Minimum_c_AE2`               | `Maximum_c_AE2`               |               | `GAMMA(a.cIntervention_c_AE2, b.cIntervention_c_AE2)`                               |
| Vomiting                                             | `c_AE3`               | `Minimum_c_AE3`               | `Maximum_c_AE3`               |               | `GAMMA(a.cIntervention_c_AE3, b.cIntervention_c_AE3)`                               |
|                                                      |                       |                               |                               |               |                                                                                     |
| **Adverse Event Incidence - With Bevacizumab**       |                       |                               |                               |               |                                                                                     |
| Leukopenia                                           | `p_FA1_Exp`           | `Minimum_p_FA1_EXPR`          | `Maximum_p_FA1_EXPR`          |               | BETA(`alpha_p_FA1_EXPR`, `beta_p_FA1_EXPR`)                                         |
| Diarrhea                                             | `p_FA2_Exp`           | `Minimum_p_FA2_EXPR`          | `Maximum_p_FA2_EXPR`          |               | BETA(`alpha_p_FA2_EXPR`, `beta_p_FA2_EXPR`)                                         |
| Vomiting                                             | `p_FA3_Exp`           | `Minimum_p_FA3_EXPR`          | `Maximum_p_FA3_EXPR`          |               | BETA(`alpha_p_FA3_EXPR`, `beta_p_FA3_EXPR`)                                         |
| **Adverse Event Incidence - Without Bevacizumab**    |                       |                               |                               |               |                                                                                     |
| Leukopenia                                           | `p_FA1_STD`           | `Minimum_p_FA1_STD`           | `Maximum_p_FA1_STD`           |               | BETA(`alpha_p_FA1_STD` , `beta_p_FA1_STD`)                                          |
| Diarrhea                                             | `p_FA2_STD`           | `Minimum_p_FA2_STD`           | `Maximum_p_FA2_STD`           |               | BETA(`alpha_p_FA2_STD` , `beta_p_FA2_STD`)                                          |
| Vomiting                                             | `p_FA3_STD`           | `Minimum_p_FA3_STD`           | `Maximum_p_FA3_STD`           |               | BETA(`alpha_p_FA3_STD` , `beta_p_FA3_STD`)                                          |
| **Utility (Per Cycle)**                              |                       |                               |                               |               |                                                                                     |
| Progression Free Survival                            | `u_F`                 | `Minimum_u_F`                 | `Maximum_u_F`                 |               | BETA(`u_F_alpha`, `u_F_beta`)                                                       |
| Overall Survival                                     | `u_P`                 | `Minimum_u_P`                 | `Maximum_u_P`                 |               | BETA(`u_P_alpha` , `u_P_beta`)                                                      |
| **Adverse Event Disutility**                         |                       |                               |                               |               |                                                                                     |
| Leukopenia                                           | `AE1_DisUtil`         | `Minimum_AE1_DisUtil`         | `Maximum_AE1_DisUtil`         | BRTYA         | `alpha_u_AE1, beta_u_AE1`                                                           |
| Diarrhea                                             | `AE2_DisUtil`         | `Minimum_AE2_DisUtil`         | `Maximum_AE2_DisUtil`         | BETA          | `alpha_u_AE2, beta_u_AE2`                                                           |
| Vomiting                                             | `AE3_DisUtil`         | `Minimum_AE3_DisUtil`         | `Maximum_AE3_DisUtil`         | BETA          | `alpha_u_AE3, beta_u_AE3`                                                           |
| **Hazard Ratios**                                    |                       |                               |                               |               |                                                                                     |
| PFS to OS under the Experimental Strategy            | `HR_FP_Exp`           | `Minimum_HR_FP_Exp`           | `Maximum_HR_FP_Exp`           | [@smeets2018] | rlnorm()                                                                            |
| OS to PFS under the Experimental Strategy            | `HR_PD_Exp`           | `Minimum_HR_PD_Exp`           | `Maximum_HR_PD_Exp`           | [@smeets2018] | rlnorm()                                                                            |
| **Probability of Dying under Second-Line Treatment** | `P_OSD_SoC`           | `Minimum_P_OSD_SoC`           | `Maximum_P_OSD_SoC`           |               | BETA(`P_OSD_SoC_alpha`, `P_OSD_SoC_beta`)                                           |
| **Discount Rate**                                    |                       |                               |                               |               |                                                                                     |
| Costs                                                | `d_c`                 | 0                             | 0.08                          |               |                                                                                     |
| Outcomes                                             | `d_e`                 | 0                             | 0.08                          |               |                                                                                     |

: Table X Model Parameters Values: Baseline, Ranges and Distributions for Sensitivity Analysis

## 
>>>>>>> f691f520d56b229ae5e891d942f6f964d9c7d025
