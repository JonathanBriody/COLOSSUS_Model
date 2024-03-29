<<<<<<< HEAD
---
title: 'Bevacizumab for Metastatic Colorectal Cancer with Chromosomal Instability:
  An Cost-Effectiveness Analysis of a Novel Subtype across the COLOSSUS Partner Countries'
author: "Jonathan Briody (1) | Kathleen Bennett (1) | Lesley Tilson (2)"
output:
  html_document: default
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


```r
rm(list = ls())  
# clear memory (removes all the variables from the work space).
options(scipen=999) 
# turns scientific notation off

source_rmd = function(file, ...) {
  tmp_file = tempfile(fileext=".R")
  on.exit(unlink(tmp_file), add = TRUE)
  knitr::purl(file, output=tmp_file)
  source(file = tmp_file, ...)
}

# This is a function (based on the below link) that grabs a file we give it in the next code chunk below, temporarily makes it an R file rather than an Rmarkdown file using purl and then sources this file for us (i.e., runs everything).

# I apply the source_rmd function to source an R markdown document of my choice.

# https://stackoverflow.com/questions/70535350/run-rmarkdown-rmd-from-inside-another-rmd-without-creating-html-output
# Also saved here: r - Run RMarkdown (.rmd) from inside another .rmd without creating HTML output - Stack Overflow.pdf
```


```r
# A warning that the below will take a bit of time to calculate for all 3 countries (maybe 20 minutes in total to finish the report), so be ready to wait a little.

# Basically, what I have is 1 Rmarkdown document with appropriate CEA code, but 3 countries I want to apply separately this code to, because costs (and willingness to pay thresholds) are different in each of these 3 countries.

# To do this, I feed in the cost data from each country for parameters that differ across countries:


# Ireland:

country_name <- "Ireland"


# 1. Cost of treatment in this country
c_PFS_Folfox <- 307.81 
c_PFS_Bevacizumab <- 2580.38  
c_OS_Folfiri <- 326.02  
administration_cost <- 365.00 

# 2. Cost of treating the AE conditional on it occurring
c_AE1 <- 2835.89
c_AE2 <- 1458.80
c_AE3 <- 409.03 

# 3. Willingness to pay threshold
n_wtp = 45000


# I apply the source_rmd function to source the core R markdown CEA document when costs are specific to the country of choice.

#source_rmd("Markov_3state.rmd")
rmarkdown::render("Markov_3state.Rmd", clean = FALSE)
```

```
## 
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |.                                                                                 |   1%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..                                                                                |   2%
## label: setup (with options) 
## List of 1
##  $ include: logi FALSE
## 
## 
  |                                                                                        
  |...                                                                               |   3%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...                                                                               |   4%
## label: unnamed-chunk-8
## 
  |                                                                                        
  |....                                                                              |   5%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.....                                                                             |   6%
## label: unnamed-chunk-9
## 
  |                                                                                        
  |......                                                                            |   7%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.......                                                                           |   8%
## label: unnamed-chunk-10
## 
  |                                                                                        
  |........                                                                          |   9%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.........                                                                         |  11%
## label: unnamed-chunk-11
## 
  |                                                                                        
  |.........                                                                         |  12%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..........                                                                        |  13%
## label: unnamed-chunk-12
## 
  |                                                                                        
  |...........                                                                       |  14%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |............                                                                      |  15%
## label: unnamed-chunk-13
## 
  |                                                                                        
  |.............                                                                     |  16%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..............                                                                    |  17%
## label: unnamed-chunk-14
```

```
## 
  |                                                                                        
  |...............                                                                   |  18%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |................                                                                  |  19%
## label: unnamed-chunk-15
## 
  |                                                                                        
  |................                                                                  |  20%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.................                                                                 |  21%
## label: unnamed-chunk-16
```

```
## 
  |                                                                                        
  |..................                                                                |  22%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...................                                                               |  23%
## label: unnamed-chunk-17
## 
  |                                                                                        
  |....................                                                              |  24%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.....................                                                             |  25%
## label: unnamed-chunk-18
## 
  |                                                                                        
  |......................                                                            |  26%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |......................                                                            |  27%
## label: unnamed-chunk-19
## 
  |                                                                                        
  |.......................                                                           |  28%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |........................                                                          |  29%
## label: unnamed-chunk-20
```

```
## 
  |                                                                                        
  |.........................                                                         |  31%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..........................                                                        |  32%
## label: unnamed-chunk-21
## 
  |                                                                                        
  |...........................                                                       |  33%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |............................                                                      |  34%
## label: unnamed-chunk-22
## 
  |                                                                                        
  |............................                                                      |  35%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.............................                                                     |  36%
## label: unnamed-chunk-23
## 
  |                                                                                        
  |..............................                                                    |  37%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...............................                                                   |  38%
## label: unnamed-chunk-24
## 
  |                                                                                        
  |................................                                                  |  39%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.................................                                                 |  40%
## label: unnamed-chunk-25
```

```
## 
  |                                                                                        
  |..................................                                                |  41%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...................................                                               |  42%
## label: unnamed-chunk-26
## 
  |                                                                                        
  |...................................                                               |  43%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |....................................                                              |  44%
## label: unnamed-chunk-27
## 
  |                                                                                        
  |.....................................                                             |  45%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |......................................                                            |  46%
## label: unnamed-chunk-28
## 
  |                                                                                        
  |.......................................                                           |  47%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |........................................                                          |  48%
## label: unnamed-chunk-29
## 
  |                                                                                        
  |.........................................                                         |  49%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.........................................                                         |  51%
## label: unnamed-chunk-30
## 
  |                                                                                        
  |..........................................                                        |  52%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...........................................                                       |  53%
## label: unnamed-chunk-31
```

```
## 
  |                                                                                        
  |............................................                                      |  54%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.............................................                                     |  55%
## label: unnamed-chunk-32
```

```
## 
  |                                                                                        
  |..............................................                                    |  56%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...............................................                                   |  57%
## label: unnamed-chunk-33
## 
  |                                                                                        
  |...............................................                                   |  58%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |................................................                                  |  59%
## label: unnamed-chunk-34
```

```
## 
  |                                                                                        
  |.................................................                                 |  60%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..................................................                                |  61%
## label: unnamed-chunk-35
## 
  |                                                                                        
  |...................................................                               |  62%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |....................................................                              |  63%
## label: unnamed-chunk-36
## 
  |                                                                                        
  |.....................................................                             |  64%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |......................................................                            |  65%
## label: unnamed-chunk-37
## 
  |                                                                                        
  |......................................................                            |  66%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.......................................................                           |  67%
## label: unnamed-chunk-38
```

```
## 
  |                                                                                        
  |........................................................                          |  68%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.........................................................                         |  69%
## label: unnamed-chunk-39
```

```
## 
  |                                                                                        
  |..........................................................                        |  71%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...........................................................                       |  72%
## label: unnamed-chunk-40
## 
  |                                                                                        
  |............................................................                      |  73%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |............................................................                      |  74%
## label: unnamed-chunk-41
## 
  |                                                                                        
  |.............................................................                     |  75%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..............................................................                    |  76%
## label: unnamed-chunk-42
## 
  |                                                                                        
  |...............................................................                   |  77%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |................................................................                  |  78%
## label: unnamed-chunk-43
## 
  |                                                                                        
  |.................................................................                 |  79%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..................................................................                |  80%
## label: unnamed-chunk-44
## 
  |                                                                                        
  |..................................................................                |  81%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...................................................................               |  82%
## label: unnamed-chunk-45
## 
  |                                                                                        
  |....................................................................              |  83%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.....................................................................             |  84%
## label: unnamed-chunk-46
## 
  |                                                                                        
  |......................................................................            |  85%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.......................................................................           |  86%
## label: unnamed-chunk-47
## 
  |                                                                                        
  |........................................................................          |  87%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.........................................................................         |  88%
## label: unnamed-chunk-48
```

```
## 
  |                                                                                        
  |.........................................................................         |  89%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..........................................................................        |  91%
## label: unnamed-chunk-49
```

```
## 
  |                                                                                        
  |...........................................................................       |  92%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |............................................................................      |  93%
## label: unnamed-chunk-50
## 
  |                                                                                        
  |.............................................................................     |  94%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..............................................................................    |  95%
## label: unnamed-chunk-51
## 
  |                                                                                        
  |...............................................................................   |  96%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...............................................................................   |  97%
## label: unnamed-chunk-52
## 
  |                                                                                        
  |................................................................................  |  98%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |................................................................................. |  99%
## label: unnamed-chunk-53
## 
  |                                                                                        
  |..................................................................................| 100%
##   ordinary text without R code
## 
## 
## "C:/Program Files/RStudio/resources/app/bin/quarto/bin/tools/pandoc" +RTS -K512m -RTS Markov_3state.knit.md --to html4 --from markdown+autolink_bare_uris+tex_math_single_backslash --output Markov_3state.html --lua-filter "C:\Users\jonathanbriody\AppData\Local\R\win-library\4.2\rmarkdown\rmarkdown\lua\pagebreak.lua" --lua-filter "C:\Users\jonathanbriody\AppData\Local\R\win-library\4.2\rmarkdown\rmarkdown\lua\latex-div.lua" --embed-resources --standalone --variable bs3=TRUE --section-divs --template "C:\Users\jonathanbriody\AppData\Local\R\win-library\4.2\rmarkdown\rmd\h\default.html" --no-highlight --variable highlightjs=1 --variable theme=bootstrap --mathjax --variable "mathjax-url=https://mathjax.rstudio.com/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML" --include-in-header "C:\Users\JONATH~1\AppData\Local\Temp\Rtmpq4dKZt\rmarkdown-str5dc44421687.html" --citeproc
```

```r
#keep(source_rmd, country_name, sure = TRUE)


# For building the Table in the paper, and for referring to parameter values in the paper, I saved the parameters I created in the RMarkdown file I source above in an RDA file named after the country I am studying:

# now I load that RDA datafile for each country:

#load(file='my_data_Ireland.rda')

# I create a data frame of all the parameters in that file:

vars_2_keep <- data.frame(c_PFS_Folfox, c_PFS_Bevacizumab, c_OS_Folfiri, administration_cost, c_AE1, c_AE2, c_AE3, Minimum_c_PFS_Folfox, Maximum_c_PFS_Folfox, Minimum_c_OS_Folfiri, Maximum_c_OS_Folfiri, Minimum_c_PFS_Bevacizumab, Maximum_c_PFS_Bevacizumab, Minimum_administration_cost, Maximum_administration_cost, Minimum_c_AE1, Maximum_c_AE1, Minimum_c_AE2, Maximum_c_AE2, Minimum_c_AE3, Maximum_c_AE3, n_wtp, Incremental_Cost, Incremental_Effect, ICER, tc_d_Exp, tc_d_SoC)

# And I name them after the country in question:

paste(country_name, colnames(vars_2_keep), sep="_") %=% vars_2_keep


# I remove everything [rm( )] everything except the specific objects I include in the write-up analysis, to create each parameter from scratch, this ensures that there arent situations where a variable is created once when the rmarkdown file is first run, and then iterated on and increased or changed in some way from this starting point in the second and third run.


keep(Ireland_c_PFS_Folfox,  Ireland_c_PFS_Bevacizumab,  Ireland_c_OS_Folfiri,  Ireland_administration_cost,  Ireland_c_AE1,  Ireland_c_AE2,  Ireland_c_AE3,  Ireland_Minimum_c_PFS_Folfox,  Ireland_Maximum_c_PFS_Folfox,  Ireland_Minimum_c_OS_Folfiri,  Ireland_Maximum_c_OS_Folfiri,  Ireland_Minimum_c_PFS_Bevacizumab,  Ireland_Maximum_c_PFS_Bevacizumab,  Ireland_Minimum_administration_cost,  Ireland_Maximum_administration_cost,  Ireland_Minimum_c_AE1,  Ireland_Maximum_c_AE1,  Ireland_Minimum_c_AE2,  Ireland_Maximum_c_AE2,  Ireland_Minimum_c_AE3,  Ireland_Maximum_c_AE3,  Ireland_n_wtp,  Ireland_Incremental_Cost,  Ireland_Incremental_Effect,  Ireland_ICER,  Ireland_tc_d_Exp,  Ireland_tc_d_SoC, sure = TRUE)

# I use the keep function from the gdata package as described here: https://stackoverflow.com/questions/6190051/how-can-i-remove-all-objects-but-one-from-the-workspace-in-r/7205040#7205040


# Then, I repeat all of this exactly for the other countries I am studying:




# Germany:

country_name <- "Germany"

# 1. Cost of treatment in this country
c_PFS_Folfox <- 1276.66
c_PFS_Bevacizumab <- 1325.87
c_OS_Folfiri <- 1309.64
administration_cost <- 1794.40

# 2. Cost of treating the AE conditional on it occurring
c_AE1 <- 3837
c_AE2 <- 1816.37
c_AE3 <- 526.70

# 3. Willingness to pay threshold
n_wtp = 78871


# I apply the source_rmd function to source the core R markdown CEA document when costs are specific to the country of choice.

#source_rmd("Markov_3state.rmd")

rmarkdown::render("Markov_3state.Rmd", clean = FALSE)
```

```
## 
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |.                                                                                 |   1%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..                                                                                |   2%
## label: setup (with options) 
## List of 1
##  $ include: logi FALSE
## 
## 
  |                                                                                        
  |...                                                                               |   3%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...                                                                               |   4%
## label: unnamed-chunk-1
## 
  |                                                                                        
  |....                                                                              |   5%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.....                                                                             |   6%
## label: unnamed-chunk-2
## 
  |                                                                                        
  |......                                                                            |   7%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.......                                                                           |   8%
## label: unnamed-chunk-3
## 
  |                                                                                        
  |........                                                                          |   9%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.........                                                                         |  11%
## label: unnamed-chunk-4-5
## 
  |                                                                                        
  |.........                                                                         |  12%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..........                                                                        |  13%
## label: unnamed-chunk-6-7
## 
  |                                                                                        
  |...........                                                                       |  14%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |............                                                                      |  15%
## label: unnamed-chunk-8
## 
  |                                                                                        
  |.............                                                                     |  16%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..............                                                                    |  17%
## label: unnamed-chunk-9
```

```
## 
  |                                                                                        
  |...............                                                                   |  18%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |................                                                                  |  19%
## label: unnamed-chunk-10
## 
  |                                                                                        
  |................                                                                  |  20%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.................                                                                 |  21%
## label: unnamed-chunk-11
```

```
## 
  |                                                                                        
  |..................                                                                |  22%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...................                                                               |  23%
## label: unnamed-chunk-12
## 
  |                                                                                        
  |....................                                                              |  24%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.....................                                                             |  25%
## label: unnamed-chunk-13
## 
  |                                                                                        
  |......................                                                            |  26%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |......................                                                            |  27%
## label: unnamed-chunk-14
## 
  |                                                                                        
  |.......................                                                           |  28%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |........................                                                          |  29%
## label: unnamed-chunk-15
```

```
## 
  |                                                                                        
  |.........................                                                         |  31%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..........................                                                        |  32%
## label: unnamed-chunk-16
## 
  |                                                                                        
  |...........................                                                       |  33%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |............................                                                      |  34%
## label: unnamed-chunk-17
## 
  |                                                                                        
  |............................                                                      |  35%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.............................                                                     |  36%
## label: unnamed-chunk-18
## 
  |                                                                                        
  |..............................                                                    |  37%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...............................                                                   |  38%
## label: unnamed-chunk-19
## 
  |                                                                                        
  |................................                                                  |  39%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.................................                                                 |  40%
## label: unnamed-chunk-20
```

```
## 
  |                                                                                        
  |..................................                                                |  41%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...................................                                               |  42%
## label: unnamed-chunk-21
## 
  |                                                                                        
  |...................................                                               |  43%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |....................................                                              |  44%
## label: unnamed-chunk-22
## 
  |                                                                                        
  |.....................................                                             |  45%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |......................................                                            |  46%
## label: unnamed-chunk-23
## 
  |                                                                                        
  |.......................................                                           |  47%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |........................................                                          |  48%
## label: unnamed-chunk-24
## 
  |                                                                                        
  |.........................................                                         |  49%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.........................................                                         |  51%
## label: unnamed-chunk-25
## 
  |                                                                                        
  |..........................................                                        |  52%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...........................................                                       |  53%
## label: unnamed-chunk-26
```

```
## 
  |                                                                                        
  |............................................                                      |  54%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.............................................                                     |  55%
## label: unnamed-chunk-27
```

```
## 
  |                                                                                        
  |..............................................                                    |  56%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...............................................                                   |  57%
## label: unnamed-chunk-28
## 
  |                                                                                        
  |...............................................                                   |  58%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |................................................                                  |  59%
## label: unnamed-chunk-29
```

```
## 
  |                                                                                        
  |.................................................                                 |  60%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..................................................                                |  61%
## label: unnamed-chunk-30
## 
  |                                                                                        
  |...................................................                               |  62%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |....................................................                              |  63%
## label: unnamed-chunk-31
## 
  |                                                                                        
  |.....................................................                             |  64%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |......................................................                            |  65%
## label: unnamed-chunk-32
## 
  |                                                                                        
  |......................................................                            |  66%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.......................................................                           |  67%
## label: unnamed-chunk-33
```

```
## 
  |                                                                                        
  |........................................................                          |  68%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.........................................................                         |  69%
## label: unnamed-chunk-34
```

```
## 
  |                                                                                        
  |..........................................................                        |  71%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...........................................................                       |  72%
## label: unnamed-chunk-35
## 
  |                                                                                        
  |............................................................                      |  73%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |............................................................                      |  74%
## label: unnamed-chunk-36
## 
  |                                                                                        
  |.............................................................                     |  75%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..............................................................                    |  76%
## label: unnamed-chunk-37
## 
  |                                                                                        
  |...............................................................                   |  77%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |................................................................                  |  78%
## label: unnamed-chunk-38
## 
  |                                                                                        
  |.................................................................                 |  79%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..................................................................                |  80%
## label: unnamed-chunk-39
## 
  |                                                                                        
  |..................................................................                |  81%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...................................................................               |  82%
## label: unnamed-chunk-40
## 
  |                                                                                        
  |....................................................................              |  83%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.....................................................................             |  84%
## label: unnamed-chunk-41
## 
  |                                                                                        
  |......................................................................            |  85%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.......................................................................           |  86%
## label: unnamed-chunk-42
## 
  |                                                                                        
  |........................................................................          |  87%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.........................................................................         |  88%
## label: unnamed-chunk-43
```

```
## 
  |                                                                                        
  |.........................................................................         |  89%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..........................................................................        |  91%
## label: unnamed-chunk-44
```

```
## 
  |                                                                                        
  |...........................................................................       |  92%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |............................................................................      |  93%
## label: unnamed-chunk-45
## 
  |                                                                                        
  |.............................................................................     |  94%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..............................................................................    |  95%
## label: unnamed-chunk-46
## 
  |                                                                                        
  |...............................................................................   |  96%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...............................................................................   |  97%
## label: unnamed-chunk-47
## 
  |                                                                                        
  |................................................................................  |  98%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |................................................................................. |  99%
## label: unnamed-chunk-48
## 
  |                                                                                        
  |..................................................................................| 100%
##   ordinary text without R code
## 
## 
## "C:/Program Files/RStudio/resources/app/bin/quarto/bin/tools/pandoc" +RTS -K512m -RTS Markov_3state.knit.md --to html4 --from markdown+autolink_bare_uris+tex_math_single_backslash --output Markov_3state.html --lua-filter "C:\Users\jonathanbriody\AppData\Local\R\win-library\4.2\rmarkdown\rmarkdown\lua\pagebreak.lua" --lua-filter "C:\Users\jonathanbriody\AppData\Local\R\win-library\4.2\rmarkdown\rmarkdown\lua\latex-div.lua" --embed-resources --standalone --variable bs3=TRUE --section-divs --template "C:\Users\jonathanbriody\AppData\Local\R\win-library\4.2\rmarkdown\rmd\h\default.html" --no-highlight --variable highlightjs=1 --variable theme=bootstrap --mathjax --variable "mathjax-url=https://mathjax.rstudio.com/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML" --include-in-header "C:\Users\JONATH~1\AppData\Local\Temp\Rtmpq4dKZt\rmarkdown-str5dc7a63694d.html" --citeproc
```

```r
#keep(source_rmd, country_name, sure = TRUE)


# For building the Table in the paper, and for referring to parameter values in the paper, I saved the parameters I created in the RMarkdown file I sourced above in an RDA file named after the country I am studying:

# now I load that RDA datafile for each country:

#load(file='my_data_Germany.rda')

# I create a data frame of all the parameters in that file:

vars_2_keep <- data.frame(c_PFS_Folfox, c_PFS_Bevacizumab, c_OS_Folfiri, administration_cost, c_AE1, c_AE2, c_AE3, Minimum_c_PFS_Folfox, Maximum_c_PFS_Folfox, Minimum_c_OS_Folfiri, Maximum_c_OS_Folfiri, Minimum_c_PFS_Bevacizumab, Maximum_c_PFS_Bevacizumab, Minimum_administration_cost, Maximum_administration_cost, Minimum_c_AE1, Maximum_c_AE1, Minimum_c_AE2, Maximum_c_AE2, Minimum_c_AE3, Maximum_c_AE3, n_wtp, Incremental_Cost, Incremental_Effect, ICER, tc_d_Exp, tc_d_SoC)

# And I name them after the country in question:

paste(country_name, colnames(vars_2_keep), sep="_") %=% vars_2_keep


# I remove everything [rm( )] everything except the specific objects I include in the write-up analysis, to create each parameter from scratch, this ensures that there arent situations where a variable is created once when the rmarkdown file is first run, and then iterated on and increased or changed in some way from this starting point in the second and third run.


keep(Germany_c_PFS_Folfox,  Germany_c_PFS_Bevacizumab,  Germany_c_OS_Folfiri,  Germany_administration_cost,  Germany_c_AE1,  Germany_c_AE2,  Germany_c_AE3,  Germany_Minimum_c_PFS_Folfox,  Germany_Maximum_c_PFS_Folfox,  Germany_Minimum_c_OS_Folfiri,  Germany_Maximum_c_OS_Folfiri,  Germany_Minimum_c_PFS_Bevacizumab,  Germany_Maximum_c_PFS_Bevacizumab,  Germany_Minimum_administration_cost,  Germany_Maximum_administration_cost,  Germany_Minimum_c_AE1,  Germany_Maximum_c_AE1,  Germany_Minimum_c_AE2,  Germany_Maximum_c_AE2,  Germany_Minimum_c_AE3,  Germany_Maximum_c_AE3,  Germany_n_wtp,  Germany_Incremental_Cost,  Germany_Incremental_Effect,  Germany_ICER,  Germany_tc_d_Exp,  Germany_tc_d_SoC, sure = TRUE)

# I use the keep function from the gdata package as described here: https://stackoverflow.com/questions/6190051/how-can-i-remove-all-objects-but-one-from-the-workspace-in-r/7205040#7205040



# Spain:

country_name <- "Spain"


# 1. Cost of treatment in this country
c_PFS_Folfox <- 285.54
c_PFS_Bevacizumab <- 1325.87
c_OS_Folfiri <- 139.58
administration_cost <- 314.94

# 2. Cost of treating the AE conditional on it occurring
c_AE1 <- 4885.95
c_AE2 <- 507.36
c_AE3 <- 95.03

# 3. Willingness to pay threshold
n_wtp = 30000


# I apply the source_rmd function to source the core R markdown CEA document when costs are specific to the country of choice.

#source_rmd("Markov_3state.rmd")
rmarkdown::render("Markov_3state.Rmd", clean = FALSE)
```

```
## 
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |.                                                                                 |   1%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..                                                                                |   2%
## label: setup (with options) 
## List of 1
##  $ include: logi FALSE
## 
## 
  |                                                                                        
  |...                                                                               |   3%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...                                                                               |   4%
## label: unnamed-chunk-1
## 
  |                                                                                        
  |....                                                                              |   5%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.....                                                                             |   6%
## label: unnamed-chunk-2
## 
  |                                                                                        
  |......                                                                            |   7%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.......                                                                           |   8%
## label: unnamed-chunk-3
## 
  |                                                                                        
  |........                                                                          |   9%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.........                                                                         |  11%
## label: unnamed-chunk-4-5
## 
  |                                                                                        
  |.........                                                                         |  12%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..........                                                                        |  13%
## label: unnamed-chunk-6-7
## 
  |                                                                                        
  |...........                                                                       |  14%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |............                                                                      |  15%
## label: unnamed-chunk-8
## 
  |                                                                                        
  |.............                                                                     |  16%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..............                                                                    |  17%
## label: unnamed-chunk-9
```

```
## 
  |                                                                                        
  |...............                                                                   |  18%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |................                                                                  |  19%
## label: unnamed-chunk-10
## 
  |                                                                                        
  |................                                                                  |  20%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.................                                                                 |  21%
## label: unnamed-chunk-11
```

```
## 
  |                                                                                        
  |..................                                                                |  22%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...................                                                               |  23%
## label: unnamed-chunk-12
## 
  |                                                                                        
  |....................                                                              |  24%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.....................                                                             |  25%
## label: unnamed-chunk-13
## 
  |                                                                                        
  |......................                                                            |  26%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |......................                                                            |  27%
## label: unnamed-chunk-14
## 
  |                                                                                        
  |.......................                                                           |  28%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |........................                                                          |  29%
## label: unnamed-chunk-15
```

```
## 
  |                                                                                        
  |.........................                                                         |  31%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..........................                                                        |  32%
## label: unnamed-chunk-16
## 
  |                                                                                        
  |...........................                                                       |  33%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |............................                                                      |  34%
## label: unnamed-chunk-17
## 
  |                                                                                        
  |............................                                                      |  35%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.............................                                                     |  36%
## label: unnamed-chunk-18
## 
  |                                                                                        
  |..............................                                                    |  37%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...............................                                                   |  38%
## label: unnamed-chunk-19
## 
  |                                                                                        
  |................................                                                  |  39%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.................................                                                 |  40%
## label: unnamed-chunk-20
```

```
## 
  |                                                                                        
  |..................................                                                |  41%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...................................                                               |  42%
## label: unnamed-chunk-21
## 
  |                                                                                        
  |...................................                                               |  43%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |....................................                                              |  44%
## label: unnamed-chunk-22
## 
  |                                                                                        
  |.....................................                                             |  45%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |......................................                                            |  46%
## label: unnamed-chunk-23
## 
  |                                                                                        
  |.......................................                                           |  47%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |........................................                                          |  48%
## label: unnamed-chunk-24
## 
  |                                                                                        
  |.........................................                                         |  49%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.........................................                                         |  51%
## label: unnamed-chunk-25
## 
  |                                                                                        
  |..........................................                                        |  52%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...........................................                                       |  53%
## label: unnamed-chunk-26
```

```
## 
  |                                                                                        
  |............................................                                      |  54%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.............................................                                     |  55%
## label: unnamed-chunk-27
```

```
## 
  |                                                                                        
  |..............................................                                    |  56%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...............................................                                   |  57%
## label: unnamed-chunk-28
## 
  |                                                                                        
  |...............................................                                   |  58%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |................................................                                  |  59%
## label: unnamed-chunk-29
```

```
## 
  |                                                                                        
  |.................................................                                 |  60%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..................................................                                |  61%
## label: unnamed-chunk-30
## 
  |                                                                                        
  |...................................................                               |  62%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |....................................................                              |  63%
## label: unnamed-chunk-31
## 
  |                                                                                        
  |.....................................................                             |  64%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |......................................................                            |  65%
## label: unnamed-chunk-32
## 
  |                                                                                        
  |......................................................                            |  66%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.......................................................                           |  67%
## label: unnamed-chunk-33
```

```
## 
  |                                                                                        
  |........................................................                          |  68%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.........................................................                         |  69%
## label: unnamed-chunk-34
```

```
## 
  |                                                                                        
  |..........................................................                        |  71%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...........................................................                       |  72%
## label: unnamed-chunk-35
## 
  |                                                                                        
  |............................................................                      |  73%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |............................................................                      |  74%
## label: unnamed-chunk-36
## 
  |                                                                                        
  |.............................................................                     |  75%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..............................................................                    |  76%
## label: unnamed-chunk-37
## 
  |                                                                                        
  |...............................................................                   |  77%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |................................................................                  |  78%
## label: unnamed-chunk-38
## 
  |                                                                                        
  |.................................................................                 |  79%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..................................................................                |  80%
## label: unnamed-chunk-39
## 
  |                                                                                        
  |..................................................................                |  81%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...................................................................               |  82%
## label: unnamed-chunk-40
## 
  |                                                                                        
  |....................................................................              |  83%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.....................................................................             |  84%
## label: unnamed-chunk-41
## 
  |                                                                                        
  |......................................................................            |  85%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.......................................................................           |  86%
## label: unnamed-chunk-42
## 
  |                                                                                        
  |........................................................................          |  87%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.........................................................................         |  88%
## label: unnamed-chunk-43
```

```
## 
  |                                                                                        
  |.........................................................................         |  89%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..........................................................................        |  91%
## label: unnamed-chunk-44
```

```
## 
  |                                                                                        
  |...........................................................................       |  92%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |............................................................................      |  93%
## label: unnamed-chunk-45
## 
  |                                                                                        
  |.............................................................................     |  94%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..............................................................................    |  95%
## label: unnamed-chunk-46
## 
  |                                                                                        
  |...............................................................................   |  96%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...............................................................................   |  97%
## label: unnamed-chunk-47
## 
  |                                                                                        
  |................................................................................  |  98%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |................................................................................. |  99%
## label: unnamed-chunk-48
## 
  |                                                                                        
  |..................................................................................| 100%
##   ordinary text without R code
## 
## 
## "C:/Program Files/RStudio/resources/app/bin/quarto/bin/tools/pandoc" +RTS -K512m -RTS Markov_3state.knit.md --to html4 --from markdown+autolink_bare_uris+tex_math_single_backslash --output Markov_3state.html --lua-filter "C:\Users\jonathanbriody\AppData\Local\R\win-library\4.2\rmarkdown\rmarkdown\lua\pagebreak.lua" --lua-filter "C:\Users\jonathanbriody\AppData\Local\R\win-library\4.2\rmarkdown\rmarkdown\lua\latex-div.lua" --embed-resources --standalone --variable bs3=TRUE --section-divs --template "C:\Users\jonathanbriody\AppData\Local\R\win-library\4.2\rmarkdown\rmd\h\default.html" --no-highlight --variable highlightjs=1 --variable theme=bootstrap --mathjax --variable "mathjax-url=https://mathjax.rstudio.com/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML" --include-in-header "C:\Users\JONATH~1\AppData\Local\Temp\Rtmpq4dKZt\rmarkdown-str5dc26813cd4.html" --citeproc
```

```r
#keep(source_rmd, country_name, sure = TRUE)


# For building the Table in the paper, and for referring to parameter values in the paper, I saved the parameters I created in the RMarkdown file I sourced above in an RDA file named after the country I am studying:

# now I load that RDA datafile for each country:

#load(file='my_data_Spain.rda')

# I create a data frame of all the parameters in that file:

vars_2_keep <- data.frame(c_PFS_Folfox, c_PFS_Bevacizumab, c_OS_Folfiri, administration_cost, c_AE1, c_AE2, c_AE3, Minimum_c_PFS_Folfox, Maximum_c_PFS_Folfox, Minimum_c_OS_Folfiri, Maximum_c_OS_Folfiri, Minimum_c_PFS_Bevacizumab, Maximum_c_PFS_Bevacizumab, Minimum_administration_cost, Maximum_administration_cost, Minimum_c_AE1, Maximum_c_AE1, Minimum_c_AE2, Maximum_c_AE2, Minimum_c_AE3, Maximum_c_AE3, n_wtp, Incremental_Cost, Incremental_Effect, ICER, tc_d_Exp, tc_d_SoC)

# And I name them after the country in question:

paste(country_name, colnames(vars_2_keep), sep="_") %=% vars_2_keep


# I remove everything [rm( )] everything except the specific objects I include in the write-up analysis, to create each parameter from scratch, this ensures that there arent situations where a variable is created once when the rmarkdown file is first run, and then iterated on and increased or changed in some way from this starting point in the second and third run.


keep(Spain_c_PFS_Folfox,  Spain_c_PFS_Bevacizumab,  Spain_c_OS_Folfiri,  Spain_administration_cost,  Spain_c_AE1,  Spain_c_AE2,  Spain_c_AE3,  Spain_Minimum_c_PFS_Folfox,  Spain_Maximum_c_PFS_Folfox,  Spain_Minimum_c_OS_Folfiri,  Spain_Maximum_c_OS_Folfiri,  Spain_Minimum_c_PFS_Bevacizumab,  Spain_Maximum_c_PFS_Bevacizumab,  Spain_Minimum_administration_cost,  Spain_Maximum_administration_cost,  Spain_Minimum_c_AE1,  Spain_Maximum_c_AE1,  Spain_Minimum_c_AE2,  Spain_Maximum_c_AE2,  Spain_Minimum_c_AE3,  Spain_Maximum_c_AE3,  Spain_n_wtp,  Spain_Incremental_Cost,  Spain_Incremental_Effect,  Spain_ICER,  Spain_tc_d_Exp,  Spain_tc_d_SoC, sure = TRUE)

# I use the keep function from the gdata package as described here: https://stackoverflow.com/questions/6190051/how-can-i-remove-all-objects-but-one-from-the-workspace-in-r/7205040#7205040



# Now I can look at the ICERs and graphs, etc., from each of these countries and apply them in the appropriate places in this R Markdown document for the academic report.
```


```r
# also

# I can add the following to the above: 

# + ggtitle("Expected Value of Perfect Information")
#txtsize - base text size
```


```r
# # Bits for the paper:
# 
# # Appendix:
# 
# 
# 
# 
# # Compare the fit of the different distributions to the survival data numerically based on the AIC
# 
# v_AIC_TTP
# (v_AIC_TTP <- c(
#   exp      = l_TTP_SoC_exp$AIC,
#   gamma    = l_TTP_SoC_gamma$AIC,
#   gompertz = l_TTP_SoC_gompertz$AIC,
#   llogis   = l_TTP_SoC_llogis$AIC,
#   lnorm    = l_TTP_SoC_lnorm$AIC,
#   weibull  = l_TTP_SoC_weibull$AIC
# ))
# 
# 
# v_AIC_TTD
# (v_AIC_TTD <- c(
#   exp      = l_TTP_SoC_exp$AIC,
#   gamma    = l_TTP_SoC_gamma$AIC,
#   gompertz = l_TTP_SoC_gompertz$AIC,
#   llogis   = l_TTP_SoC_llogis$AIC,
#   lnorm    = l_TTP_SoC_lnorm$AIC,
#   weibull  = l_TTP_SoC_weibull$AIC
# ))
# 
# 
# # I also need to run plot(l_TTP_SoC_exp,  and plot(l_TTD_SoC_exp, here with the same logic as why I run these, that is, the data is available here, so I run these here.
# 
# 
# #05 Inspecting the fits:
# 
# # And this would make sense per the below diagram - which looks at the proportion of individuals who have the event, i.e. progression.
# 
# # Inspect fit based on visual fit
# colors <- rainbow(6)
# plot(l_TTP_SoC_exp,       col = colors[1], ci = FALSE, ylab = "Event-free proportion", xlab = "Time in days", las = 1)
# lines(l_TTP_SoC_gamma,    col = colors[2], ci = FALSE)
# lines(l_TTP_SoC_gompertz, col = colors[3], ci = FALSE)
# lines(l_TTP_SoC_llogis,   col = colors[4], ci = FALSE)
# lines(l_TTP_SoC_lnorm,    col = colors[5], ci = FALSE)
# lines(l_TTP_SoC_weibull,  col = colors[6], ci = FALSE)
# legend("right",
#        legend = c("exp", "gamma", "gompertz", "llogis", "lnorm", "weibull"),
#        col    = colors,
#        lty    = 1,
#        bty    = "n")
# 
# 
# 
# #08 Inspecting the fits:
# 
# # And this would make sense per the below diagram - which looks at the proportion of individuals who have the event, i.e. going to dead.
# 
# # Inspect fit based on visual fit
# colors <- rainbow(6)
# plot(l_TTD_SoC_exp,       col = colors[1], ci = FALSE, ylab = "Event-free proportion", xlab = "Time in days", las = 1)
# lines(l_TTD_SoC_gamma,    col = colors[2], ci = FALSE)
# lines(l_TTD_SoC_gompertz, col = colors[3], ci = FALSE)
# lines(l_TTD_SoC_llogis,   col = colors[4], ci = FALSE)
# lines(l_TTD_SoC_lnorm,    col = colors[5], ci = FALSE)
# lines(l_TTD_SoC_weibull,  col = colors[6], ci = FALSE)
# legend("right",
#        legend = c("exp", "gamma", "gompertz", "llogis", "lnorm", "weibull"),
#        col    = colors,
#        lty    = 1,
#        bty    = "n")
# #ggsave("Inspecting_Fits_OS.png", width = 4, height = 4, dpi=300)
# #while (!is.null(dev.list()))  dev.off()
# #png(paste("Inspecting_Fits_OS", ".png"))
# #dev.off()
# 
# 
# 
# 
# #Draw the state-transition cohort model
# 
# diag_names_states  <- c("PFS", "OS", "Dead")
# 
# m_P_diag <- matrix(0, nrow = n_states, ncol = n_states, dimnames = list(diag_names_states, diag_names_states))
# 
# m_P_diag["PFS", "PFS" ]  = ""
# m_P_diag["PFS", "OS" ]     = ""
# m_P_diag["PFS", "Dead" ]     = ""
# m_P_diag["OS", "OS" ]     = ""
# m_P_diag["OS", "Dead" ]     = ""
# m_P_diag["Dead", "Dead" ]     = ""
# layout.fig <- c(2, 1) # <- changing the numbers here changes the diagram layout, so mess with these until I'm happy. It basically decides how many bubbles will be on each level, so here 1 bubble, followed by 3 bubbles, followed by 2 bubbles, per the diagram for 1, 3, 2.
# plotmat(t(m_P_diag), t(layout.fig), self.cex = 0.5, curve = 0, arr.pos = 0.76,
#         latex = T, arr.type = "curved", relsize = 0.85, box.prop = 0.9,
#         cex = 0.8, box.cex = 0.7, lwd = 0.6, main = "Figure 1")
# #ggsave("Markov_Model_Diagram.png", width = 4, height = 4, dpi=300)
# #while (!is.null(dev.list()))  dev.off()
# #png(paste("Markov_Model_Diagram", ".png"))
# #dev.off()
# 
# 
# 
# #06 Compute and Plot Epidemiological Outcomes
# 
# #06.1 Cohort trace
# 
# # So, we'll plot the above Markov model for standard of care (m_M_SoC) to show our cohort distribution over time, i.e. the proportion of our cohort in the different health states over time.
# 
# # If I wanted to do the same for exp, I would just copy this code chunk and replace m_M_SoC with m_M_Exp
# 
# # Here is the simplest code that would give me what I want:
# 
# # matplot(m_M_SoC, type = 'l', 
#         # ylab = "Probability of state occupancy",
#         # xlab = "Cycle",
#         # main = "Cohort Trace", lwd = 3)  # create a plot of the data
# # legend("right", v_names_states, col = c("black", "red", "green"), 
#        # lty = 1:3, bty = "n")  # add a legend to the graph
# 
# # But I would like to add more:
# 
# # Plotting the Markov cohort traces
# matplot(m_M_SoC, 
#         type = "l", 
#         ylab = "Probability of state occupancy",
#         xlab = "Cycle",
#         main = "Makrov Cohort Traces",
#         lwd  = 3,
#         lty  = 1) # create a plot of the data
# matplot(m_M_Exp, 
#         type = "l", 
#         lwd  = 3,
#         lty  = 3,
#         add  = TRUE) # add a plot of the experimental data ontop of the above plot
# legend("right", 
#        legend = c(paste(v_names_states, "(SOC)"), paste(v_names_states, "(Exp)")), 
#        col    = rep(c("black", "red", "green"), 2), 
#        lty    = c(1, 1, 1, 3, 3, 3), # Line type, full (1) or dashed (3), I have entered this 6 times here because we have 3 lines under standard of care (3 full lines) and  3 lines under experimental treatment (3 dashed lines)
#        lwd    = 3,
#        bty    = "n")
# #ggsave("Markov_Cohort_Traces.png", width = 4, height = 4, dpi=300)
# #while (!is.null(dev.list()))  dev.off()
# # png(paste("Markov_Cohort_Traces", ".png"))
# # dev.off()
# 
# # plot a vertical line that helps identifying at which cycle the prevalence of OS is highest
# #abline(v = which.max(m_M_SoC[, "OS"]), col = "gray")
# #abline(v = which.max(m_M_Exp[, "OS"]), col = "black")
# # The vertical line shows you when your progressed (OS) population is the greatest that it will ever be, but it can be changed from which.max to other things (so it is finding which cycle the proportion progressed is the highest and putting a vertical line there).
# # (It's probably not necessary for my own analysis and I can comment these two lines out if I'm not going to use it).
# 
# # So, you can see in the graph everyone starts in the PFS state, but that this falls over time as people progress and leave this state, then you see OS start to peak up but then fall again as people leave this state to go into the dead state, which is an absorbing state and by the end will include everyone.
# 
# 
# 
# 
# 
# 
# 
# 
# # I don't save these values using "keep" as they'll be leftover from running the code, and should always come out the same as they are from the ANGIOPREDICT data on peoples survival and not dependent on the country we are studying, so the last country studied should have them saved on the final run of the model.
# 
# # Similarly for life_years_days_gained life_years_soc, life_years_exp
# 
# 
```

There are some things that I would like to appear in the code chunks, but not in the knitted document.
To do this I can go to:

<https://stackoverflow.com/questions/47710427/how-to-show-code-but-hide-output-in-rmarkdown>

and

<https://stackoverflow.com/questions/48286722/rmarkdown-how-to-show-partial-output-from-chunk?rq=1>

Although I can probably just use:

knitr::opts_chunk\$set(echo = TRUE, warning = FALSE, message = FALSE, eval = T)

But set echo = false

Or even better, click the gear on each code chunk and decide if I would like that code chunk to show things or not.

# Introduction

We constructed a Markov model to calculate the lifetime costs and outcomes of each treatment strategy in mCRC.

The intention-to-treat (ITT) population we modelled in this study is mCRC patients in Germany, Ireland and Spain from a healthcare payer perspective in these countries.
Subsequently, the analysis included direct medical costs.

Effectiveness is reflected in quality-adjusted life years (QALYS).
Per the countries studied, a discount rate of 4% per annum was applied to cost input and health output parameters [\@Williams2022].
All model inputs are described in Table 1.
The primary outcomes of the model were the total costs, QALYS, and the incremental cost-effectiveness ratio (ICER).
Per [\@goldstein2017] probability of transitions, adverse events, and quality of life under treatment was assumed to be generalisable; consequently, shared values were applied to all countries under study in the interest of concision.
Country specific differences in cost were included.

## References:
=======
---
title: 'Bevacizumab for Metastatic Colorectal Cancer with Chromosomal Instability:
  An Cost-Effectiveness Analysis of a Novel Subtype across the COLOSSUS Partner Countries'
author: "Jonathan Briody (1) | Kathleen Bennett (1) | Lesley Tilson (2)"
output:
  html_document: default
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


```r
rm(list = ls())  
# clear memory (removes all the variables from the work space).
options(scipen=999) 
# turns scientific notation off

source_rmd = function(file, ...) {
  tmp_file = tempfile(fileext=".R")
  on.exit(unlink(tmp_file), add = TRUE)
  knitr::purl(file, output=tmp_file)
  source(file = tmp_file, ...)
}

# This is a function (based on the below link) that grabs a file we give it in the next code chunk below, temporarily makes it an R file rather than an Rmarkdown file using purl and then sources this file for us (i.e., runs everything).

# I apply the source_rmd function to source an R markdown document of my choice.

# https://stackoverflow.com/questions/70535350/run-rmarkdown-rmd-from-inside-another-rmd-without-creating-html-output
# Also saved here: r - Run RMarkdown (.rmd) from inside another .rmd without creating HTML output - Stack Overflow.pdf
```


```r
# A warning that the below will take a bit of time to calculate for all 3 countries (maybe 20 minutes in total to finish the report), so be ready to wait a little.

# Basically, what I have is 1 Rmarkdown document with appropriate CEA code, but 3 countries I want to apply separately this code to, because costs (and willingness to pay thresholds) are different in each of these 3 countries.

# To do this, I feed in the cost data from each country for parameters that differ across countries:


# Ireland:

country_name <- "Ireland"


# 1. Cost of treatment in this country
c_PFS_Folfox <- 307.81 
c_PFS_Bevacizumab <- 2580.38  
c_OS_Folfiri <- 326.02  
administration_cost <- 365.00 

# 2. Cost of treating the AE conditional on it occurring
c_AE1 <- 2835.89
c_AE2 <- 1458.80
c_AE3 <- 409.03 

# 3. Willingness to pay threshold
n_wtp = 45000


# I apply the source_rmd function to source the core R markdown CEA document when costs are specific to the country of choice.

#source_rmd("Markov_3state.rmd")
rmarkdown::render("Markov_3state.Rmd", clean = FALSE)
```

```
## 
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |.                                                                                 |   1%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..                                                                                |   2%
## label: setup (with options) 
## List of 1
##  $ include: logi FALSE
## 
## 
  |                                                                                        
  |...                                                                               |   3%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...                                                                               |   4%
## label: unnamed-chunk-8
## 
  |                                                                                        
  |....                                                                              |   5%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.....                                                                             |   6%
## label: unnamed-chunk-9
## 
  |                                                                                        
  |......                                                                            |   7%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.......                                                                           |   8%
## label: unnamed-chunk-10
## 
  |                                                                                        
  |........                                                                          |   9%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.........                                                                         |  11%
## label: unnamed-chunk-11
## 
  |                                                                                        
  |.........                                                                         |  12%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..........                                                                        |  13%
## label: unnamed-chunk-12
## 
  |                                                                                        
  |...........                                                                       |  14%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |............                                                                      |  15%
## label: unnamed-chunk-13
## 
  |                                                                                        
  |.............                                                                     |  16%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..............                                                                    |  17%
## label: unnamed-chunk-14
```

```
## 
  |                                                                                        
  |...............                                                                   |  18%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |................                                                                  |  19%
## label: unnamed-chunk-15
## 
  |                                                                                        
  |................                                                                  |  20%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.................                                                                 |  21%
## label: unnamed-chunk-16
```

```
## 
  |                                                                                        
  |..................                                                                |  22%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...................                                                               |  23%
## label: unnamed-chunk-17
## 
  |                                                                                        
  |....................                                                              |  24%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.....................                                                             |  25%
## label: unnamed-chunk-18
## 
  |                                                                                        
  |......................                                                            |  26%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |......................                                                            |  27%
## label: unnamed-chunk-19
## 
  |                                                                                        
  |.......................                                                           |  28%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |........................                                                          |  29%
## label: unnamed-chunk-20
```

```
## 
  |                                                                                        
  |.........................                                                         |  31%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..........................                                                        |  32%
## label: unnamed-chunk-21
## 
  |                                                                                        
  |...........................                                                       |  33%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |............................                                                      |  34%
## label: unnamed-chunk-22
## 
  |                                                                                        
  |............................                                                      |  35%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.............................                                                     |  36%
## label: unnamed-chunk-23
## 
  |                                                                                        
  |..............................                                                    |  37%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...............................                                                   |  38%
## label: unnamed-chunk-24
## 
  |                                                                                        
  |................................                                                  |  39%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.................................                                                 |  40%
## label: unnamed-chunk-25
```

```
## 
  |                                                                                        
  |..................................                                                |  41%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...................................                                               |  42%
## label: unnamed-chunk-26
## 
  |                                                                                        
  |...................................                                               |  43%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |....................................                                              |  44%
## label: unnamed-chunk-27
## 
  |                                                                                        
  |.....................................                                             |  45%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |......................................                                            |  46%
## label: unnamed-chunk-28
## 
  |                                                                                        
  |.......................................                                           |  47%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |........................................                                          |  48%
## label: unnamed-chunk-29
## 
  |                                                                                        
  |.........................................                                         |  49%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.........................................                                         |  51%
## label: unnamed-chunk-30
## 
  |                                                                                        
  |..........................................                                        |  52%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...........................................                                       |  53%
## label: unnamed-chunk-31
```

```
## 
  |                                                                                        
  |............................................                                      |  54%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.............................................                                     |  55%
## label: unnamed-chunk-32
```

```
## 
  |                                                                                        
  |..............................................                                    |  56%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...............................................                                   |  57%
## label: unnamed-chunk-33
## 
  |                                                                                        
  |...............................................                                   |  58%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |................................................                                  |  59%
## label: unnamed-chunk-34
```

```
## 
  |                                                                                        
  |.................................................                                 |  60%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..................................................                                |  61%
## label: unnamed-chunk-35
## 
  |                                                                                        
  |...................................................                               |  62%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |....................................................                              |  63%
## label: unnamed-chunk-36
## 
  |                                                                                        
  |.....................................................                             |  64%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |......................................................                            |  65%
## label: unnamed-chunk-37
## 
  |                                                                                        
  |......................................................                            |  66%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.......................................................                           |  67%
## label: unnamed-chunk-38
```

```
## 
  |                                                                                        
  |........................................................                          |  68%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.........................................................                         |  69%
## label: unnamed-chunk-39
```

```
## 
  |                                                                                        
  |..........................................................                        |  71%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...........................................................                       |  72%
## label: unnamed-chunk-40
## 
  |                                                                                        
  |............................................................                      |  73%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |............................................................                      |  74%
## label: unnamed-chunk-41
## 
  |                                                                                        
  |.............................................................                     |  75%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..............................................................                    |  76%
## label: unnamed-chunk-42
## 
  |                                                                                        
  |...............................................................                   |  77%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |................................................................                  |  78%
## label: unnamed-chunk-43
## 
  |                                                                                        
  |.................................................................                 |  79%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..................................................................                |  80%
## label: unnamed-chunk-44
## 
  |                                                                                        
  |..................................................................                |  81%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...................................................................               |  82%
## label: unnamed-chunk-45
## 
  |                                                                                        
  |....................................................................              |  83%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.....................................................................             |  84%
## label: unnamed-chunk-46
## 
  |                                                                                        
  |......................................................................            |  85%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.......................................................................           |  86%
## label: unnamed-chunk-47
## 
  |                                                                                        
  |........................................................................          |  87%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.........................................................................         |  88%
## label: unnamed-chunk-48
```

```
## 
  |                                                                                        
  |.........................................................................         |  89%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..........................................................................        |  91%
## label: unnamed-chunk-49
```

```
## 
  |                                                                                        
  |...........................................................................       |  92%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |............................................................................      |  93%
## label: unnamed-chunk-50
## 
  |                                                                                        
  |.............................................................................     |  94%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..............................................................................    |  95%
## label: unnamed-chunk-51
## 
  |                                                                                        
  |...............................................................................   |  96%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...............................................................................   |  97%
## label: unnamed-chunk-52
## 
  |                                                                                        
  |................................................................................  |  98%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |................................................................................. |  99%
## label: unnamed-chunk-53
## 
  |                                                                                        
  |..................................................................................| 100%
##   ordinary text without R code
## 
## 
## "C:/Program Files/RStudio/resources/app/bin/quarto/bin/tools/pandoc" +RTS -K512m -RTS Markov_3state.knit.md --to html4 --from markdown+autolink_bare_uris+tex_math_single_backslash --output Markov_3state.html --lua-filter "C:\Users\jonathanbriody\AppData\Local\R\win-library\4.2\rmarkdown\rmarkdown\lua\pagebreak.lua" --lua-filter "C:\Users\jonathanbriody\AppData\Local\R\win-library\4.2\rmarkdown\rmarkdown\lua\latex-div.lua" --embed-resources --standalone --variable bs3=TRUE --section-divs --template "C:\Users\jonathanbriody\AppData\Local\R\win-library\4.2\rmarkdown\rmd\h\default.html" --no-highlight --variable highlightjs=1 --variable theme=bootstrap --mathjax --variable "mathjax-url=https://mathjax.rstudio.com/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML" --include-in-header "C:\Users\JONATH~1\AppData\Local\Temp\Rtmpq4dKZt\rmarkdown-str5dc44421687.html" --citeproc
```

```r
#keep(source_rmd, country_name, sure = TRUE)


# For building the Table in the paper, and for referring to parameter values in the paper, I saved the parameters I created in the RMarkdown file I source above in an RDA file named after the country I am studying:

# now I load that RDA datafile for each country:

#load(file='my_data_Ireland.rda')

# I create a data frame of all the parameters in that file:

vars_2_keep <- data.frame(c_PFS_Folfox, c_PFS_Bevacizumab, c_OS_Folfiri, administration_cost, c_AE1, c_AE2, c_AE3, Minimum_c_PFS_Folfox, Maximum_c_PFS_Folfox, Minimum_c_OS_Folfiri, Maximum_c_OS_Folfiri, Minimum_c_PFS_Bevacizumab, Maximum_c_PFS_Bevacizumab, Minimum_administration_cost, Maximum_administration_cost, Minimum_c_AE1, Maximum_c_AE1, Minimum_c_AE2, Maximum_c_AE2, Minimum_c_AE3, Maximum_c_AE3, n_wtp, Incremental_Cost, Incremental_Effect, ICER, tc_d_Exp, tc_d_SoC)

# And I name them after the country in question:

paste(country_name, colnames(vars_2_keep), sep="_") %=% vars_2_keep


# I remove everything [rm( )] everything except the specific objects I include in the write-up analysis, to create each parameter from scratch, this ensures that there arent situations where a variable is created once when the rmarkdown file is first run, and then iterated on and increased or changed in some way from this starting point in the second and third run.


keep(Ireland_c_PFS_Folfox,  Ireland_c_PFS_Bevacizumab,  Ireland_c_OS_Folfiri,  Ireland_administration_cost,  Ireland_c_AE1,  Ireland_c_AE2,  Ireland_c_AE3,  Ireland_Minimum_c_PFS_Folfox,  Ireland_Maximum_c_PFS_Folfox,  Ireland_Minimum_c_OS_Folfiri,  Ireland_Maximum_c_OS_Folfiri,  Ireland_Minimum_c_PFS_Bevacizumab,  Ireland_Maximum_c_PFS_Bevacizumab,  Ireland_Minimum_administration_cost,  Ireland_Maximum_administration_cost,  Ireland_Minimum_c_AE1,  Ireland_Maximum_c_AE1,  Ireland_Minimum_c_AE2,  Ireland_Maximum_c_AE2,  Ireland_Minimum_c_AE3,  Ireland_Maximum_c_AE3,  Ireland_n_wtp,  Ireland_Incremental_Cost,  Ireland_Incremental_Effect,  Ireland_ICER,  Ireland_tc_d_Exp,  Ireland_tc_d_SoC, sure = TRUE)

# I use the keep function from the gdata package as described here: https://stackoverflow.com/questions/6190051/how-can-i-remove-all-objects-but-one-from-the-workspace-in-r/7205040#7205040


# Then, I repeat all of this exactly for the other countries I am studying:




# Germany:

country_name <- "Germany"

# 1. Cost of treatment in this country
c_PFS_Folfox <- 1276.66
c_PFS_Bevacizumab <- 1325.87
c_OS_Folfiri <- 1309.64
administration_cost <- 1794.40

# 2. Cost of treating the AE conditional on it occurring
c_AE1 <- 3837
c_AE2 <- 1816.37
c_AE3 <- 526.70

# 3. Willingness to pay threshold
n_wtp = 78871


# I apply the source_rmd function to source the core R markdown CEA document when costs are specific to the country of choice.

#source_rmd("Markov_3state.rmd")

rmarkdown::render("Markov_3state.Rmd", clean = FALSE)
```

```
## 
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |.                                                                                 |   1%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..                                                                                |   2%
## label: setup (with options) 
## List of 1
##  $ include: logi FALSE
## 
## 
  |                                                                                        
  |...                                                                               |   3%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...                                                                               |   4%
## label: unnamed-chunk-1
## 
  |                                                                                        
  |....                                                                              |   5%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.....                                                                             |   6%
## label: unnamed-chunk-2
## 
  |                                                                                        
  |......                                                                            |   7%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.......                                                                           |   8%
## label: unnamed-chunk-3
## 
  |                                                                                        
  |........                                                                          |   9%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.........                                                                         |  11%
## label: unnamed-chunk-4-5
## 
  |                                                                                        
  |.........                                                                         |  12%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..........                                                                        |  13%
## label: unnamed-chunk-6-7
## 
  |                                                                                        
  |...........                                                                       |  14%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |............                                                                      |  15%
## label: unnamed-chunk-8
## 
  |                                                                                        
  |.............                                                                     |  16%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..............                                                                    |  17%
## label: unnamed-chunk-9
```

```
## 
  |                                                                                        
  |...............                                                                   |  18%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |................                                                                  |  19%
## label: unnamed-chunk-10
## 
  |                                                                                        
  |................                                                                  |  20%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.................                                                                 |  21%
## label: unnamed-chunk-11
```

```
## 
  |                                                                                        
  |..................                                                                |  22%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...................                                                               |  23%
## label: unnamed-chunk-12
## 
  |                                                                                        
  |....................                                                              |  24%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.....................                                                             |  25%
## label: unnamed-chunk-13
## 
  |                                                                                        
  |......................                                                            |  26%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |......................                                                            |  27%
## label: unnamed-chunk-14
## 
  |                                                                                        
  |.......................                                                           |  28%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |........................                                                          |  29%
## label: unnamed-chunk-15
```

```
## 
  |                                                                                        
  |.........................                                                         |  31%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..........................                                                        |  32%
## label: unnamed-chunk-16
## 
  |                                                                                        
  |...........................                                                       |  33%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |............................                                                      |  34%
## label: unnamed-chunk-17
## 
  |                                                                                        
  |............................                                                      |  35%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.............................                                                     |  36%
## label: unnamed-chunk-18
## 
  |                                                                                        
  |..............................                                                    |  37%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...............................                                                   |  38%
## label: unnamed-chunk-19
## 
  |                                                                                        
  |................................                                                  |  39%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.................................                                                 |  40%
## label: unnamed-chunk-20
```

```
## 
  |                                                                                        
  |..................................                                                |  41%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...................................                                               |  42%
## label: unnamed-chunk-21
## 
  |                                                                                        
  |...................................                                               |  43%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |....................................                                              |  44%
## label: unnamed-chunk-22
## 
  |                                                                                        
  |.....................................                                             |  45%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |......................................                                            |  46%
## label: unnamed-chunk-23
## 
  |                                                                                        
  |.......................................                                           |  47%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |........................................                                          |  48%
## label: unnamed-chunk-24
## 
  |                                                                                        
  |.........................................                                         |  49%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.........................................                                         |  51%
## label: unnamed-chunk-25
## 
  |                                                                                        
  |..........................................                                        |  52%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...........................................                                       |  53%
## label: unnamed-chunk-26
```

```
## 
  |                                                                                        
  |............................................                                      |  54%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.............................................                                     |  55%
## label: unnamed-chunk-27
```

```
## 
  |                                                                                        
  |..............................................                                    |  56%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...............................................                                   |  57%
## label: unnamed-chunk-28
## 
  |                                                                                        
  |...............................................                                   |  58%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |................................................                                  |  59%
## label: unnamed-chunk-29
```

```
## 
  |                                                                                        
  |.................................................                                 |  60%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..................................................                                |  61%
## label: unnamed-chunk-30
## 
  |                                                                                        
  |...................................................                               |  62%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |....................................................                              |  63%
## label: unnamed-chunk-31
## 
  |                                                                                        
  |.....................................................                             |  64%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |......................................................                            |  65%
## label: unnamed-chunk-32
## 
  |                                                                                        
  |......................................................                            |  66%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.......................................................                           |  67%
## label: unnamed-chunk-33
```

```
## 
  |                                                                                        
  |........................................................                          |  68%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.........................................................                         |  69%
## label: unnamed-chunk-34
```

```
## 
  |                                                                                        
  |..........................................................                        |  71%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...........................................................                       |  72%
## label: unnamed-chunk-35
## 
  |                                                                                        
  |............................................................                      |  73%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |............................................................                      |  74%
## label: unnamed-chunk-36
## 
  |                                                                                        
  |.............................................................                     |  75%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..............................................................                    |  76%
## label: unnamed-chunk-37
## 
  |                                                                                        
  |...............................................................                   |  77%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |................................................................                  |  78%
## label: unnamed-chunk-38
## 
  |                                                                                        
  |.................................................................                 |  79%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..................................................................                |  80%
## label: unnamed-chunk-39
## 
  |                                                                                        
  |..................................................................                |  81%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...................................................................               |  82%
## label: unnamed-chunk-40
## 
  |                                                                                        
  |....................................................................              |  83%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.....................................................................             |  84%
## label: unnamed-chunk-41
## 
  |                                                                                        
  |......................................................................            |  85%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.......................................................................           |  86%
## label: unnamed-chunk-42
## 
  |                                                                                        
  |........................................................................          |  87%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.........................................................................         |  88%
## label: unnamed-chunk-43
```

```
## 
  |                                                                                        
  |.........................................................................         |  89%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..........................................................................        |  91%
## label: unnamed-chunk-44
```

```
## 
  |                                                                                        
  |...........................................................................       |  92%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |............................................................................      |  93%
## label: unnamed-chunk-45
## 
  |                                                                                        
  |.............................................................................     |  94%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..............................................................................    |  95%
## label: unnamed-chunk-46
## 
  |                                                                                        
  |...............................................................................   |  96%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...............................................................................   |  97%
## label: unnamed-chunk-47
## 
  |                                                                                        
  |................................................................................  |  98%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |................................................................................. |  99%
## label: unnamed-chunk-48
## 
  |                                                                                        
  |..................................................................................| 100%
##   ordinary text without R code
## 
## 
## "C:/Program Files/RStudio/resources/app/bin/quarto/bin/tools/pandoc" +RTS -K512m -RTS Markov_3state.knit.md --to html4 --from markdown+autolink_bare_uris+tex_math_single_backslash --output Markov_3state.html --lua-filter "C:\Users\jonathanbriody\AppData\Local\R\win-library\4.2\rmarkdown\rmarkdown\lua\pagebreak.lua" --lua-filter "C:\Users\jonathanbriody\AppData\Local\R\win-library\4.2\rmarkdown\rmarkdown\lua\latex-div.lua" --embed-resources --standalone --variable bs3=TRUE --section-divs --template "C:\Users\jonathanbriody\AppData\Local\R\win-library\4.2\rmarkdown\rmd\h\default.html" --no-highlight --variable highlightjs=1 --variable theme=bootstrap --mathjax --variable "mathjax-url=https://mathjax.rstudio.com/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML" --include-in-header "C:\Users\JONATH~1\AppData\Local\Temp\Rtmpq4dKZt\rmarkdown-str5dc7a63694d.html" --citeproc
```

```r
#keep(source_rmd, country_name, sure = TRUE)


# For building the Table in the paper, and for referring to parameter values in the paper, I saved the parameters I created in the RMarkdown file I sourced above in an RDA file named after the country I am studying:

# now I load that RDA datafile for each country:

#load(file='my_data_Germany.rda')

# I create a data frame of all the parameters in that file:

vars_2_keep <- data.frame(c_PFS_Folfox, c_PFS_Bevacizumab, c_OS_Folfiri, administration_cost, c_AE1, c_AE2, c_AE3, Minimum_c_PFS_Folfox, Maximum_c_PFS_Folfox, Minimum_c_OS_Folfiri, Maximum_c_OS_Folfiri, Minimum_c_PFS_Bevacizumab, Maximum_c_PFS_Bevacizumab, Minimum_administration_cost, Maximum_administration_cost, Minimum_c_AE1, Maximum_c_AE1, Minimum_c_AE2, Maximum_c_AE2, Minimum_c_AE3, Maximum_c_AE3, n_wtp, Incremental_Cost, Incremental_Effect, ICER, tc_d_Exp, tc_d_SoC)

# And I name them after the country in question:

paste(country_name, colnames(vars_2_keep), sep="_") %=% vars_2_keep


# I remove everything [rm( )] everything except the specific objects I include in the write-up analysis, to create each parameter from scratch, this ensures that there arent situations where a variable is created once when the rmarkdown file is first run, and then iterated on and increased or changed in some way from this starting point in the second and third run.


keep(Germany_c_PFS_Folfox,  Germany_c_PFS_Bevacizumab,  Germany_c_OS_Folfiri,  Germany_administration_cost,  Germany_c_AE1,  Germany_c_AE2,  Germany_c_AE3,  Germany_Minimum_c_PFS_Folfox,  Germany_Maximum_c_PFS_Folfox,  Germany_Minimum_c_OS_Folfiri,  Germany_Maximum_c_OS_Folfiri,  Germany_Minimum_c_PFS_Bevacizumab,  Germany_Maximum_c_PFS_Bevacizumab,  Germany_Minimum_administration_cost,  Germany_Maximum_administration_cost,  Germany_Minimum_c_AE1,  Germany_Maximum_c_AE1,  Germany_Minimum_c_AE2,  Germany_Maximum_c_AE2,  Germany_Minimum_c_AE3,  Germany_Maximum_c_AE3,  Germany_n_wtp,  Germany_Incremental_Cost,  Germany_Incremental_Effect,  Germany_ICER,  Germany_tc_d_Exp,  Germany_tc_d_SoC, sure = TRUE)

# I use the keep function from the gdata package as described here: https://stackoverflow.com/questions/6190051/how-can-i-remove-all-objects-but-one-from-the-workspace-in-r/7205040#7205040



# Spain:

country_name <- "Spain"


# 1. Cost of treatment in this country
c_PFS_Folfox <- 285.54
c_PFS_Bevacizumab <- 1325.87
c_OS_Folfiri <- 139.58
administration_cost <- 314.94

# 2. Cost of treating the AE conditional on it occurring
c_AE1 <- 4885.95
c_AE2 <- 507.36
c_AE3 <- 95.03

# 3. Willingness to pay threshold
n_wtp = 30000


# I apply the source_rmd function to source the core R markdown CEA document when costs are specific to the country of choice.

#source_rmd("Markov_3state.rmd")
rmarkdown::render("Markov_3state.Rmd", clean = FALSE)
```

```
## 
  |                                                                                        
  |                                                                                  |   0%
  |                                                                                        
  |.                                                                                 |   1%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..                                                                                |   2%
## label: setup (with options) 
## List of 1
##  $ include: logi FALSE
## 
## 
  |                                                                                        
  |...                                                                               |   3%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...                                                                               |   4%
## label: unnamed-chunk-1
## 
  |                                                                                        
  |....                                                                              |   5%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.....                                                                             |   6%
## label: unnamed-chunk-2
## 
  |                                                                                        
  |......                                                                            |   7%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.......                                                                           |   8%
## label: unnamed-chunk-3
## 
  |                                                                                        
  |........                                                                          |   9%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.........                                                                         |  11%
## label: unnamed-chunk-4-5
## 
  |                                                                                        
  |.........                                                                         |  12%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..........                                                                        |  13%
## label: unnamed-chunk-6-7
## 
  |                                                                                        
  |...........                                                                       |  14%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |............                                                                      |  15%
## label: unnamed-chunk-8
## 
  |                                                                                        
  |.............                                                                     |  16%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..............                                                                    |  17%
## label: unnamed-chunk-9
```

```
## 
  |                                                                                        
  |...............                                                                   |  18%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |................                                                                  |  19%
## label: unnamed-chunk-10
## 
  |                                                                                        
  |................                                                                  |  20%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.................                                                                 |  21%
## label: unnamed-chunk-11
```

```
## 
  |                                                                                        
  |..................                                                                |  22%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...................                                                               |  23%
## label: unnamed-chunk-12
## 
  |                                                                                        
  |....................                                                              |  24%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.....................                                                             |  25%
## label: unnamed-chunk-13
## 
  |                                                                                        
  |......................                                                            |  26%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |......................                                                            |  27%
## label: unnamed-chunk-14
## 
  |                                                                                        
  |.......................                                                           |  28%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |........................                                                          |  29%
## label: unnamed-chunk-15
```

```
## 
  |                                                                                        
  |.........................                                                         |  31%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..........................                                                        |  32%
## label: unnamed-chunk-16
## 
  |                                                                                        
  |...........................                                                       |  33%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |............................                                                      |  34%
## label: unnamed-chunk-17
## 
  |                                                                                        
  |............................                                                      |  35%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.............................                                                     |  36%
## label: unnamed-chunk-18
## 
  |                                                                                        
  |..............................                                                    |  37%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...............................                                                   |  38%
## label: unnamed-chunk-19
## 
  |                                                                                        
  |................................                                                  |  39%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.................................                                                 |  40%
## label: unnamed-chunk-20
```

```
## 
  |                                                                                        
  |..................................                                                |  41%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...................................                                               |  42%
## label: unnamed-chunk-21
## 
  |                                                                                        
  |...................................                                               |  43%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |....................................                                              |  44%
## label: unnamed-chunk-22
## 
  |                                                                                        
  |.....................................                                             |  45%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |......................................                                            |  46%
## label: unnamed-chunk-23
## 
  |                                                                                        
  |.......................................                                           |  47%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |........................................                                          |  48%
## label: unnamed-chunk-24
## 
  |                                                                                        
  |.........................................                                         |  49%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.........................................                                         |  51%
## label: unnamed-chunk-25
## 
  |                                                                                        
  |..........................................                                        |  52%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...........................................                                       |  53%
## label: unnamed-chunk-26
```

```
## 
  |                                                                                        
  |............................................                                      |  54%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.............................................                                     |  55%
## label: unnamed-chunk-27
```

```
## 
  |                                                                                        
  |..............................................                                    |  56%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...............................................                                   |  57%
## label: unnamed-chunk-28
## 
  |                                                                                        
  |...............................................                                   |  58%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |................................................                                  |  59%
## label: unnamed-chunk-29
```

```
## 
  |                                                                                        
  |.................................................                                 |  60%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..................................................                                |  61%
## label: unnamed-chunk-30
## 
  |                                                                                        
  |...................................................                               |  62%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |....................................................                              |  63%
## label: unnamed-chunk-31
## 
  |                                                                                        
  |.....................................................                             |  64%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |......................................................                            |  65%
## label: unnamed-chunk-32
## 
  |                                                                                        
  |......................................................                            |  66%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.......................................................                           |  67%
## label: unnamed-chunk-33
```

```
## 
  |                                                                                        
  |........................................................                          |  68%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.........................................................                         |  69%
## label: unnamed-chunk-34
```

```
## 
  |                                                                                        
  |..........................................................                        |  71%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...........................................................                       |  72%
## label: unnamed-chunk-35
## 
  |                                                                                        
  |............................................................                      |  73%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |............................................................                      |  74%
## label: unnamed-chunk-36
## 
  |                                                                                        
  |.............................................................                     |  75%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..............................................................                    |  76%
## label: unnamed-chunk-37
## 
  |                                                                                        
  |...............................................................                   |  77%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |................................................................                  |  78%
## label: unnamed-chunk-38
## 
  |                                                                                        
  |.................................................................                 |  79%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..................................................................                |  80%
## label: unnamed-chunk-39
## 
  |                                                                                        
  |..................................................................                |  81%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...................................................................               |  82%
## label: unnamed-chunk-40
## 
  |                                                                                        
  |....................................................................              |  83%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.....................................................................             |  84%
## label: unnamed-chunk-41
## 
  |                                                                                        
  |......................................................................            |  85%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.......................................................................           |  86%
## label: unnamed-chunk-42
## 
  |                                                                                        
  |........................................................................          |  87%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |.........................................................................         |  88%
## label: unnamed-chunk-43
```

```
## 
  |                                                                                        
  |.........................................................................         |  89%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..........................................................................        |  91%
## label: unnamed-chunk-44
```

```
## 
  |                                                                                        
  |...........................................................................       |  92%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |............................................................................      |  93%
## label: unnamed-chunk-45
## 
  |                                                                                        
  |.............................................................................     |  94%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |..............................................................................    |  95%
## label: unnamed-chunk-46
## 
  |                                                                                        
  |...............................................................................   |  96%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |...............................................................................   |  97%
## label: unnamed-chunk-47
## 
  |                                                                                        
  |................................................................................  |  98%
##   ordinary text without R code
## 
## 
  |                                                                                        
  |................................................................................. |  99%
## label: unnamed-chunk-48
## 
  |                                                                                        
  |..................................................................................| 100%
##   ordinary text without R code
## 
## 
## "C:/Program Files/RStudio/resources/app/bin/quarto/bin/tools/pandoc" +RTS -K512m -RTS Markov_3state.knit.md --to html4 --from markdown+autolink_bare_uris+tex_math_single_backslash --output Markov_3state.html --lua-filter "C:\Users\jonathanbriody\AppData\Local\R\win-library\4.2\rmarkdown\rmarkdown\lua\pagebreak.lua" --lua-filter "C:\Users\jonathanbriody\AppData\Local\R\win-library\4.2\rmarkdown\rmarkdown\lua\latex-div.lua" --embed-resources --standalone --variable bs3=TRUE --section-divs --template "C:\Users\jonathanbriody\AppData\Local\R\win-library\4.2\rmarkdown\rmd\h\default.html" --no-highlight --variable highlightjs=1 --variable theme=bootstrap --mathjax --variable "mathjax-url=https://mathjax.rstudio.com/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML" --include-in-header "C:\Users\JONATH~1\AppData\Local\Temp\Rtmpq4dKZt\rmarkdown-str5dc26813cd4.html" --citeproc
```

```r
#keep(source_rmd, country_name, sure = TRUE)


# For building the Table in the paper, and for referring to parameter values in the paper, I saved the parameters I created in the RMarkdown file I sourced above in an RDA file named after the country I am studying:

# now I load that RDA datafile for each country:

#load(file='my_data_Spain.rda')

# I create a data frame of all the parameters in that file:

vars_2_keep <- data.frame(c_PFS_Folfox, c_PFS_Bevacizumab, c_OS_Folfiri, administration_cost, c_AE1, c_AE2, c_AE3, Minimum_c_PFS_Folfox, Maximum_c_PFS_Folfox, Minimum_c_OS_Folfiri, Maximum_c_OS_Folfiri, Minimum_c_PFS_Bevacizumab, Maximum_c_PFS_Bevacizumab, Minimum_administration_cost, Maximum_administration_cost, Minimum_c_AE1, Maximum_c_AE1, Minimum_c_AE2, Maximum_c_AE2, Minimum_c_AE3, Maximum_c_AE3, n_wtp, Incremental_Cost, Incremental_Effect, ICER, tc_d_Exp, tc_d_SoC)

# And I name them after the country in question:

paste(country_name, colnames(vars_2_keep), sep="_") %=% vars_2_keep


# I remove everything [rm( )] everything except the specific objects I include in the write-up analysis, to create each parameter from scratch, this ensures that there arent situations where a variable is created once when the rmarkdown file is first run, and then iterated on and increased or changed in some way from this starting point in the second and third run.


keep(Spain_c_PFS_Folfox,  Spain_c_PFS_Bevacizumab,  Spain_c_OS_Folfiri,  Spain_administration_cost,  Spain_c_AE1,  Spain_c_AE2,  Spain_c_AE3,  Spain_Minimum_c_PFS_Folfox,  Spain_Maximum_c_PFS_Folfox,  Spain_Minimum_c_OS_Folfiri,  Spain_Maximum_c_OS_Folfiri,  Spain_Minimum_c_PFS_Bevacizumab,  Spain_Maximum_c_PFS_Bevacizumab,  Spain_Minimum_administration_cost,  Spain_Maximum_administration_cost,  Spain_Minimum_c_AE1,  Spain_Maximum_c_AE1,  Spain_Minimum_c_AE2,  Spain_Maximum_c_AE2,  Spain_Minimum_c_AE3,  Spain_Maximum_c_AE3,  Spain_n_wtp,  Spain_Incremental_Cost,  Spain_Incremental_Effect,  Spain_ICER,  Spain_tc_d_Exp,  Spain_tc_d_SoC, sure = TRUE)

# I use the keep function from the gdata package as described here: https://stackoverflow.com/questions/6190051/how-can-i-remove-all-objects-but-one-from-the-workspace-in-r/7205040#7205040



# Now I can look at the ICERs and graphs, etc., from each of these countries and apply them in the appropriate places in this R Markdown document for the academic report.
```


```r
# also

# I can add the following to the above: 

# + ggtitle("Expected Value of Perfect Information")
#txtsize - base text size
```


```r
# # Bits for the paper:
# 
# # Appendix:
# 
# 
# 
# 
# # Compare the fit of the different distributions to the survival data numerically based on the AIC
# 
# v_AIC_TTP
# (v_AIC_TTP <- c(
#   exp      = l_TTP_SoC_exp$AIC,
#   gamma    = l_TTP_SoC_gamma$AIC,
#   gompertz = l_TTP_SoC_gompertz$AIC,
#   llogis   = l_TTP_SoC_llogis$AIC,
#   lnorm    = l_TTP_SoC_lnorm$AIC,
#   weibull  = l_TTP_SoC_weibull$AIC
# ))
# 
# 
# v_AIC_TTD
# (v_AIC_TTD <- c(
#   exp      = l_TTP_SoC_exp$AIC,
#   gamma    = l_TTP_SoC_gamma$AIC,
#   gompertz = l_TTP_SoC_gompertz$AIC,
#   llogis   = l_TTP_SoC_llogis$AIC,
#   lnorm    = l_TTP_SoC_lnorm$AIC,
#   weibull  = l_TTP_SoC_weibull$AIC
# ))
# 
# 
# # I also need to run plot(l_TTP_SoC_exp,  and plot(l_TTD_SoC_exp, here with the same logic as why I run these, that is, the data is available here, so I run these here.
# 
# 
# #05 Inspecting the fits:
# 
# # And this would make sense per the below diagram - which looks at the proportion of individuals who have the event, i.e. progression.
# 
# # Inspect fit based on visual fit
# colors <- rainbow(6)
# plot(l_TTP_SoC_exp,       col = colors[1], ci = FALSE, ylab = "Event-free proportion", xlab = "Time in days", las = 1)
# lines(l_TTP_SoC_gamma,    col = colors[2], ci = FALSE)
# lines(l_TTP_SoC_gompertz, col = colors[3], ci = FALSE)
# lines(l_TTP_SoC_llogis,   col = colors[4], ci = FALSE)
# lines(l_TTP_SoC_lnorm,    col = colors[5], ci = FALSE)
# lines(l_TTP_SoC_weibull,  col = colors[6], ci = FALSE)
# legend("right",
#        legend = c("exp", "gamma", "gompertz", "llogis", "lnorm", "weibull"),
#        col    = colors,
#        lty    = 1,
#        bty    = "n")
# 
# 
# 
# #08 Inspecting the fits:
# 
# # And this would make sense per the below diagram - which looks at the proportion of individuals who have the event, i.e. going to dead.
# 
# # Inspect fit based on visual fit
# colors <- rainbow(6)
# plot(l_TTD_SoC_exp,       col = colors[1], ci = FALSE, ylab = "Event-free proportion", xlab = "Time in days", las = 1)
# lines(l_TTD_SoC_gamma,    col = colors[2], ci = FALSE)
# lines(l_TTD_SoC_gompertz, col = colors[3], ci = FALSE)
# lines(l_TTD_SoC_llogis,   col = colors[4], ci = FALSE)
# lines(l_TTD_SoC_lnorm,    col = colors[5], ci = FALSE)
# lines(l_TTD_SoC_weibull,  col = colors[6], ci = FALSE)
# legend("right",
#        legend = c("exp", "gamma", "gompertz", "llogis", "lnorm", "weibull"),
#        col    = colors,
#        lty    = 1,
#        bty    = "n")
# #ggsave("Inspecting_Fits_OS.png", width = 4, height = 4, dpi=300)
# #while (!is.null(dev.list()))  dev.off()
# #png(paste("Inspecting_Fits_OS", ".png"))
# #dev.off()
# 
# 
# 
# 
# #Draw the state-transition cohort model
# 
# diag_names_states  <- c("PFS", "OS", "Dead")
# 
# m_P_diag <- matrix(0, nrow = n_states, ncol = n_states, dimnames = list(diag_names_states, diag_names_states))
# 
# m_P_diag["PFS", "PFS" ]  = ""
# m_P_diag["PFS", "OS" ]     = ""
# m_P_diag["PFS", "Dead" ]     = ""
# m_P_diag["OS", "OS" ]     = ""
# m_P_diag["OS", "Dead" ]     = ""
# m_P_diag["Dead", "Dead" ]     = ""
# layout.fig <- c(2, 1) # <- changing the numbers here changes the diagram layout, so mess with these until I'm happy. It basically decides how many bubbles will be on each level, so here 1 bubble, followed by 3 bubbles, followed by 2 bubbles, per the diagram for 1, 3, 2.
# plotmat(t(m_P_diag), t(layout.fig), self.cex = 0.5, curve = 0, arr.pos = 0.76,
#         latex = T, arr.type = "curved", relsize = 0.85, box.prop = 0.9,
#         cex = 0.8, box.cex = 0.7, lwd = 0.6, main = "Figure 1")
# #ggsave("Markov_Model_Diagram.png", width = 4, height = 4, dpi=300)
# #while (!is.null(dev.list()))  dev.off()
# #png(paste("Markov_Model_Diagram", ".png"))
# #dev.off()
# 
# 
# 
# #06 Compute and Plot Epidemiological Outcomes
# 
# #06.1 Cohort trace
# 
# # So, we'll plot the above Markov model for standard of care (m_M_SoC) to show our cohort distribution over time, i.e. the proportion of our cohort in the different health states over time.
# 
# # If I wanted to do the same for exp, I would just copy this code chunk and replace m_M_SoC with m_M_Exp
# 
# # Here is the simplest code that would give me what I want:
# 
# # matplot(m_M_SoC, type = 'l', 
#         # ylab = "Probability of state occupancy",
#         # xlab = "Cycle",
#         # main = "Cohort Trace", lwd = 3)  # create a plot of the data
# # legend("right", v_names_states, col = c("black", "red", "green"), 
#        # lty = 1:3, bty = "n")  # add a legend to the graph
# 
# # But I would like to add more:
# 
# # Plotting the Markov cohort traces
# matplot(m_M_SoC, 
#         type = "l", 
#         ylab = "Probability of state occupancy",
#         xlab = "Cycle",
#         main = "Makrov Cohort Traces",
#         lwd  = 3,
#         lty  = 1) # create a plot of the data
# matplot(m_M_Exp, 
#         type = "l", 
#         lwd  = 3,
#         lty  = 3,
#         add  = TRUE) # add a plot of the experimental data ontop of the above plot
# legend("right", 
#        legend = c(paste(v_names_states, "(SOC)"), paste(v_names_states, "(Exp)")), 
#        col    = rep(c("black", "red", "green"), 2), 
#        lty    = c(1, 1, 1, 3, 3, 3), # Line type, full (1) or dashed (3), I have entered this 6 times here because we have 3 lines under standard of care (3 full lines) and  3 lines under experimental treatment (3 dashed lines)
#        lwd    = 3,
#        bty    = "n")
# #ggsave("Markov_Cohort_Traces.png", width = 4, height = 4, dpi=300)
# #while (!is.null(dev.list()))  dev.off()
# # png(paste("Markov_Cohort_Traces", ".png"))
# # dev.off()
# 
# # plot a vertical line that helps identifying at which cycle the prevalence of OS is highest
# #abline(v = which.max(m_M_SoC[, "OS"]), col = "gray")
# #abline(v = which.max(m_M_Exp[, "OS"]), col = "black")
# # The vertical line shows you when your progressed (OS) population is the greatest that it will ever be, but it can be changed from which.max to other things (so it is finding which cycle the proportion progressed is the highest and putting a vertical line there).
# # (It's probably not necessary for my own analysis and I can comment these two lines out if I'm not going to use it).
# 
# # So, you can see in the graph everyone starts in the PFS state, but that this falls over time as people progress and leave this state, then you see OS start to peak up but then fall again as people leave this state to go into the dead state, which is an absorbing state and by the end will include everyone.
# 
# 
# 
# 
# 
# 
# 
# 
# # I don't save these values using "keep" as they'll be leftover from running the code, and should always come out the same as they are from the ANGIOPREDICT data on peoples survival and not dependent on the country we are studying, so the last country studied should have them saved on the final run of the model.
# 
# # Similarly for life_years_days_gained life_years_soc, life_years_exp
# 
# 
```

There are some things that I would like to appear in the code chunks, but not in the knitted document.
To do this I can go to:

<https://stackoverflow.com/questions/47710427/how-to-show-code-but-hide-output-in-rmarkdown>

and

<https://stackoverflow.com/questions/48286722/rmarkdown-how-to-show-partial-output-from-chunk?rq=1>

Although I can probably just use:

knitr::opts_chunk\$set(echo = TRUE, warning = FALSE, message = FALSE, eval = T)

But set echo = false

Or even better, click the gear on each code chunk and decide if I would like that code chunk to show things or not.

# Introduction

We constructed a Markov model to calculate the lifetime costs and outcomes of each treatment strategy in mCRC.

The intention-to-treat (ITT) population we modelled in this study is mCRC patients in Germany, Ireland and Spain from a healthcare payer perspective in these countries.
Subsequently, the analysis included direct medical costs.

Effectiveness is reflected in quality-adjusted life years (QALYS).
Per the countries studied, a discount rate of 4% per annum was applied to cost input and health output parameters [\@Williams2022].
All model inputs are described in Table 1.
The primary outcomes of the model were the total costs, QALYS, and the incremental cost-effectiveness ratio (ICER).
Per [\@goldstein2017] probability of transitions, adverse events, and quality of life under treatment was assumed to be generalisable; consequently, shared values were applied to all countries under study in the interest of concision.
Country specific differences in cost were included.

## References:
>>>>>>> f691f520d56b229ae5e891d942f6f964d9c7d025
