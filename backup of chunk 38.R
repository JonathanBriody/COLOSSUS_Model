
# Calculating a Beta distribution when you have a range around this in the literature you are reviewing:

# To determine the best way to do this, I'll open all the sources I mention just above the previous code chunk which include a range, se, alpha, beta, etc., and then I'll apply all the methods I have and see which is best. I'll also be heavily guided by the suggestions Andy made, as he has being doing this work for 2 decades, if he says that a certain way is correct, I'll take him at his word. Lesley also made some suggestions.

# Once you have an alpha and a beta, you can work your way back to a SE:


# per: https://stackoverflow.com/questions/41189633/how-to-get-the-standard-deviation-from-the-fitted-distribution-in-scipy
# As supported by this: https://www.real-statistics.com/binomial-and-related-distributions/beta-distribution/
# and using this here: Jenks, Michelle, et al. "Tegaderm CHG IV securement dressing for central venous and arterial catheter insertion sites: a NICE medical technology guidance." Applied Health Economics and Health Policy 14.2 (2016): 135-149. https://link.springer.com/content/pdf/10.1007/s40258-015-0202-5.pdf I get 0.002096431 or 0.0021, so it looks like they used the mean as their se.



# I demonstrate this in Table 1, row 22,  of: Sharp, Linda, et al. "Cost-effectiveness of population-based screening for colorectal cancer: a comparison of guaiac-based faecal occult blood testing, faecal immunochemical testing and flexible sigmoidoscopy." British journal of cancer 106.5 (2012): 805-816. https://www.nature.com/articles/bjc2011580.pdf also saved here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\Betadist utility\bjc2011580.pdf

# CTC sensitivity for CRC Basecase(85%) range(75 – 95%) Beta (50.00, 8.82)

a<- 50.00
b<- 8.82
Var <-  a * b / ( (a + b)^2 * (a + b + 1) )
se <- sqrt(Var)
se
# 0.04616056

# Here's a way to get alpha and beta with just the variance and mean: https://devinincerti.com/2018/02/10/psa.html

# If I wanted to turn my own SE into the variance, I can multiply it by itself, i.e. se*se per: https://r-lang.com/how-to-calculate-square-of-all-values-in-r-vector/#:~:text=To%20calculate%20square%20in%20R,square%20of%20the%20input%20value.

mean <- 0.85

std.error <- se
alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1 ## alpha + beta (ab)
alpha.plus.beta
alpha <- mean*alpha.plus.beta ## alpha (a)
beta <- alpha*(1-mean)/mean ## beta(b)
alpha
# 50.01124
beta
# 8.825513



myse <- ((0.95) - (0.85)) / 2
myse
# 0.05

# The problem is, using this se changes my alpha and beta values, as follows:

std.error <- myse
alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1 ## alpha + beta (ab)
alpha.plus.beta
alpha <- mean*alpha.plus.beta ## alpha (a)
beta <- alpha*(1-mean)/mean ## beta(b)
alpha
# 42.5
beta
# 7.5


# The differences between my results on their tables, and their results, may come down to rounding.


# When I generate the SE from the values reported in the paper, I don't have as many decimal points for my SE, i.e., it rounds up to 0.05 from 0.04616056, as below:

myse <- ((0.95) - (0.85)) / 2
myse
# 0.05

# The problem is, using this rounded se changes my alpha and beta values, as follows:

std.error <- myse
alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1 ## alpha + beta (ab)
alpha.plus.beta
alpha <- mean*alpha.plus.beta ## alpha (a)
beta <- alpha*(1-mean)/mean ## beta(b)
alpha
# 42.5
beta
# 7.5

# Which explains the differences in the alpha and beta I generate from the table.

# What this means, is that I can generate my SE as before, that is 

# se <- ((Maximum) - (Mean)) / 2

# Or se off the minimum if it's further away:

# se <- ((Mean) - (Min)) / 2

# But where there is a range, instead of just a point estimate value for utility, I use the upper end of the range for the maximum, or the lower end of the range for the minimum when generating the SE.

# I've checked this for all the beta values in the Table. Only rows 1, 5, 20, 34 (out of the 17 beta rows) give results that are too different to be accounted for by rounding. To make sure I am 100% correct about this, I've emailed Lesley to ask how she got these distributions, as she is one of the co-authors on the paper.

# All of the above applies to probabilities as well as utilities, as both are for beta distributions.


# When the SE is only different by rounding, the alpha and beta that comes out of the formula after I've worked out the SE for their beta vars from the alpha and beta and plugged it into the formula matches the alpha and beta they started with, showing that the way in which I generate the SE is correct, because my se matches the se they use as below:



# My standard error matches theirs (although involves rounding) and I get the same alpha and beta by including theirs or mine (or, at least I would without rounding) and gives me the same rbeta mean as they started out with. Subsequently, my thought process is this: I can take the approach of generating the SE from the upper range - mean or the mean - the lower range (depending on which is further away), and then plug this into my formula to get an appropriate alpha and beta and use this to make random draws for the mean in the rbeta. I won't produce an alpha and beta that matches what they present in the table, but the SE I recover from their alpha and beta, creates an unmatched version of the alpha and beta that matches the alpha and beta I create. 

# The fact that their standard error matches mine means that the way I am calculating SE in my own methods is correct.
# 
# std.error <- se
# alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1 ## alpha + beta (ab)
# alpha.plus.beta
# alpha <- mean*alpha.plus.beta ## alpha (a)
# beta <- alpha*(1-mean)/mean ## beta(b)
# alpha
# beta
# 
# u_ME       = rbeta(10000, shape1 =  a, shape2 = b)
# mean(u_ME)

# 
# std.error <- myse
# alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1 ## alpha + beta (ab)
# alpha.plus.beta
# alpha <- mean*alpha.plus.beta ## alpha (a)
# beta <- alpha*(1-mean)/mean ## beta(b)
# alpha
# beta
# 
# u_ME       = rbeta(10000, shape1 =  a, shape2 = b)
# mean(u_ME)


# Then I create alpha and beta using Koen's code, which is a different way of calculating these vales than what Briggs showed me:

# newalpha =(((mean)^2)*(1-(mean))/((se)^2)-(mean))
# newbeta =((1-(mean))*(((1-(mean))*(mean))/((se)^2)-1))
# newalpha
# [1] 50.01124
# newbeta
# [1] 8.825513






# Spackman, D. E., & Veenstra, D. L. (2008). A cost-effectiveness analysis of currently approved treatments for HBeAg-positive chronic hepatitis B. Pharmacoeconomics, 26(11), 937-949. http://download.lww.com/wolterskluwer_vitalstream_com/permalink/pcz/a/00019053-920082611-00002.pdf Also saved here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\Betadist utility\00019053-920082611-00002.pdf



# In the supplementary table to this paper, my SE is almost identical to the SE created in the paper, but because I am working with whole numbers, i.e., I only know 2 decimals of their code, say 0.03, whereas they would know lots more, say 0.031112234331, so my SE has less decimal points than there's, so of course, there will be slight variations when that SE is used for calculating alpha.plus.beta, which in turn has implications for alpha and beta calculated alone from this alpha.plus.beta, i.e., my calculation of these will be very slightly different because I am dividing by a very slightly different SE to create alpha plus beta. What I do see when I plug their longer SE into my formula I get the exact alpha and beta reported in the paper. This means that my formula to calculate alpha and beta is correct. Also, my SE is the exact same as theirs bar a few extra digits in theirs, for reasons described above, meaning that the way I calculate the SE is also perfect. Thus I can use the method described below for calculating SE from a parameter with a range, and thus the alpha and beta from this parameter, and thus the PSA distribution.


# However, I do run into some cells where things are very different:

# a <- 15.039072
# b <-  736.9145
# max <- 0.03
# min <- 0.00
# mean <-0.02

# Var <- a*b/((a+b)^2*(a+b+1))
# se<-sqrt(Var)
# se
# [1] 0.005102

# myse <- ((max)-(mean))/2
# #myse <- ((mean)-(min))/2
# myse
# [1] 0.005

# std.error <- se
# alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1 ## alpha + beta (ab)
# alpha.plus.beta
# [1] 752

# alpha <- mean*alpha.plus.beta ## alpha (a)
# beta <- alpha*(1-mean)/mean ## beta(b)
# alpha
# [1] 15.04
# beta
# [1] 736.9

# u_ME       = rbeta(10000, shape1 =  alpha, shape2 = beta)
# mean(u_ME)
# [1] 0.01997

# std.error <- myse
# alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1 ## alpha + beta (ab)
# alpha.plus.beta
# [1] 783
# alpha <- mean*alpha.plus.beta ## alpha (a)
# beta <- alpha*(1-mean)/mean ## beta(b)
# alpha
# [1] 15.66
# beta
# [1] 767.3

# u_ME       = rbeta(10000, shape1 =  alpha, shape2 = beta)
# mean(u_ME)
# [1] 0.02007









# I create a vector with 1 million entries drawing randomly from between a minimum and a maximum valuefor the mean and max values featured in the paper:


# possiblemeans <- runif(1000000, 0.012499999999999999, 0.0134999999999999999)
# possiblemaxs <- runif(1000000,  0.022499999999999999, 0.0234999999999999999)

# I create an SE that's made up of all these possible values

mypossibleses <- ((max)-(mean))/2
# mypossibleses <- ((mean)-(min))/2
mypossibleses


# The below tells me all the cells that have the included value :

grep(se, x1)

# So, basically, what I am doing is taking all the possible numbers that could make up the max and the mean, putting them into my formula, and seeing if any permutation will give me the SE they report in their paper. If it does, this simply means that their SE and my SE differ because of the number of decimal places they have.




# a <- 8.16870263
# b <-  54.66747 
# max <- 0.23
# min <- 0.07
# mean <-0.13
# 
# Var <- a*b/((a+b)^2*(a+b+1))
# se<-sqrt(Var)
# se
# [1] 0.04209
# 
# myse <- ((max)-(mean))/2
# #myse <- ((mean)-(min))/2
# myse
# [1] 0.05


# I create a vector with 1 million entries drawing randomly from between a minimum and a maximum valuefor the mean and max values featured in the paper:


# possiblemeans <- runif(1000000, 0.12499999999999999, 0.134999999999999999)
# possiblemaxs <- runif(1000000,  0.22499999999999999, 0.234999999999999999)
# possiblemins <- runif(1000000,  0.06499999999999999, 0.074999999999999999)

# I create an SE that's made up of all these possible values

# mypossibleses <- ((possiblemaxs)-(possiblemeans))/2
# mypossibleses <- ((possiblemeans)-(possiblemins))/2
# mypossibleses

# I create a data frame from this and then I control f to search for the se they created according to their alpha and beta:
# se
# mypossiblesesdf <- data.frame(mypossibleses)


# I don't find it among my values.

# This tells me that no matter what number of decimal places they had information on, I would never be able to generate the SE they generated from the values I am using. When I sort by the size of my data.frame the minimum value I have is 0.04501 and the maximum is 0.05499

# I even tred dividing by all the t-quantiles:

# tq <- c(1,1.376,1.963,3.078,6.31,12.71,31.82,63.66,106.1,159.2,0.816,1.061,1.386,1.886,2.92,4.303,6.965,9.925,12.85,15.76,0.765,0.978,1.25,1.638,2.353,3.182,4.541,5.841,6.994,8.053,0.741,0.941,1.19,1.533,2.132,2.776,3.747,4.604,5.321,5.951,0.727,0.92,1.156,1.476,2.015,2.571,3.365,4.032,4.57,5.03,0.718,0.906,1.134,1.44,1.943,2.447,3.143,3.707,4.152,4.524,0.711,0.896,1.119,1.415,1.895,2.365,2.998,3.499,3.887,4.207,0.706,0.889,1.108,1.397,1.86,2.306,2.896,3.355,3.705,3.991,0.703,0.883,1.1,1.383,1.833,2.262,2.821,3.25,3.573,3.835,0.7,0.879,1.093,1.372,1.812,2.228,2.764,3.169,3.472,3.716,0.697,0.876,1.088,1.363,1.796,2.201,2.718,3.106,3.393,3.624,0.695,0.873,1.083,1.356,1.782,2.179,2.681,3.055,3.33,3.55,0.694,0.87,1.079,1.35,1.771,2.16,2.65,3.012,3.278,3.489,0.692,0.868,1.076,1.345,1.761,2.145,2.624,2.977,3.234,3.438,0.691,0.866,1.074,1.341,1.753,2.131,2.602,2.947,3.197,3.395,0.69,0.865,1.071,1.337,1.746,2.12,2.583,2.921,3.165,3.358,0.689,0.863,1.069,1.333,1.74,2.11,2.567,2.898,3.138,3.326,0.688,0.862,1.067,1.33,1.734,2.101,2.552,2.878,3.113,3.298,0.688,0.861,1.066,1.328,1.729,2.093,2.539,2.861,3.092,3.273,0.687,0.86,1.064,1.325,1.725,2.086,2.528,2.845,3.073,3.251,0.686,0.859,1.063,1.323,1.721,2.08,2.518,2.831,3.056,3.231,0.686,0.858,1.061,1.321,1.717,2.074,2.508,2.819,3.041,3.214,0.685,0.858,1.06,1.319,1.714,2.069,2.5,2.807,3.027,3.198,0.685,0.857,1.059,1.318,1.711,2.064,2.492,2.797,3.014,3.183,0.684,0.856,1.058,1.316,1.708,2.06,2.485,2.787,3.003,3.17,0.684,0.856,1.058,1.315,1.706,2.056,2.479,2.779,2.992,3.158,0.684,0.855,1.057,1.314,1.703,2.052,2.473,2.771,2.982,3.147,0.683,0.855,1.056,1.313,1.701,2.048,2.467,2.763,2.973,3.136,0.683,0.854,1.055,1.311,1.699,2.045,2.462,2.756,2.965,3.127,0.683,0.854,1.055,1.31,1.697,2.042,2.457,2.75,2.957,3.118,0.682,0.853,1.054,1.309,1.696,2.04,2.453,2.744,2.95,3.109,0.682,0.853,1.054,1.309,1.694,2.037,2.449,2.738,2.943,3.102,0.682,0.853,1.053,1.308,1.692,2.035,2.445,2.733,2.937,3.094,0.682,0.852,1.052,1.307,1.691,2.032,2.441,2.728,2.931,3.088,0.682,0.852,1.052,1.306,1.69,2.03,2.438,2.724,2.926,3.081,0.681,0.851,1.05,1.303,1.684,2.021,2.423,2.704,2.902,3.055,0.679,0.849,1.047,1.299,1.676,2.009,2.403,2.678,2.87,3.018,0.679,0.848,1.045,1.296,1.671,2,2.39,2.66,2.849,2.994,0.677,0.845,1.041,1.289,1.658,1.98,2.358,2.617,2.798,2.935,0.674,0.842,1.036,1.282,1.645,1.96,2.326,2.576,2.748,2.878)

# mypossibleses <- ((possiblemaxs)-(possiblemeans))/tq
# mypossibleses
# I create a data frame from this and then I control f to search for the se they created according to their alpha and beta:
# se
# mypossiblesesdf <- data.frame(mypossibleses, tq)

# I ctrl f and searched 0.04209 and got a few hits, but when I went to look at these with the all the digits being displaye none of them matched exactly the long version of their SE, i.e. 0.0420918376330846

# > print(mypossiblesesdf[748327,], digits = 22)

# So, I'm definitely not able to create their SE from the formula I used

# So, they definitely didnt create their SE from the same formula I used.


# Here's code provided by Briggs (in email) and reported by Devin Incerti (https://hesim-dev.github.io/hesim/articles/markov-cohort.html) when generating the SE:


b <-c(891.6005,15.41799,736.9145,1257.92,419.1321,48.37248,54.66747,759.661,1161.571,46.55078,371.0238,613.4266,1349.813,1007.815,150.3308,515.7984,1.572009,1.709663,1196.415,44.16013,432.4305,1143.101,478.3303,344.844,318.2237,839.0925,665.8365,668.3704,15334.68,2261.868,210.4119,295.9456,839.0925,295.9456,248.218,50.63905,51.89032,54.66747,265.7833) 

a <-c(121.581888,51.6167467,15.039072,334.383756,62.6289387,12.09312,8.16870263,3.817392,254.979072,48.4508078,45.8568782,226.883808,449.9375,168.165112,22.4632179,113.224032,29.8681689,2.26629759,280.640564,9.04484592,22.7595,242.476063,28.3755279,38.316,14.64628,6.766875,12.20474,6.751216,15.35003,6.806023,6.731443,6.657262,6.766875,6.657262,6.625944,14.28281,15.76329,8.168703,6.814956)

max <-c(0.14,0.87,0.03,0.23,0.16,0.30,0.23,0.01,0.21,0.61,0.13,0.29,0.27,0.16,0.18,0.85,1.00,1.00,0.21,0.27,0.07,0.195,0.076,(13.0/100),(6.6/100),(1.6/100),(2.8/100),(2.0/100),(0.2/100),(0.6/100),(6.2/100),(4.4/100),(1.6/100),(4.4/100),(5.2/100),(32.0/100),(33.3/100),(23/100),(5.0/100))

min <-c(0.10,0.67,0.00,0.19,0.10,0.10,0.07,0.00,0.15,0.41,0.09,0.25,0.23,0.12,0.08,0.79,0.85,0.13,0.17,0.07,0.03,0.155,0.036,(7.0/100),(2.2/100),(0.4/100),(0.8/100),(0.5/100),(0.1/100),(0.015/100),(1.6/100),(1.1/100),(0.4/100),(1.1/100),(1.3/100),(12.0/100),(13.3/100),(6.5/100),(1.3/100))   

mean <-c(0.12,0.77,0.02,0.21,0.13,0.20,0.13,0.005,0.18,0.51,0.11,0.27,0.25,0.14,0.13,0.18,0.95,0.57,0.19,0.17,0.05,0.175,0.056,(10.00/100),(4.4/100),(0.8/100),(1.8/100),(1.0/100),(0.1/100),(0.3/100),(3.1/100),(2.2/100),(0.8/100),(2.2/100),(2.6/100),(22.0/100),(23.3/100),(13.0/100),(2.5/100))

# Recover the papers SE:

# For the values in Table A4, I have to divide these by 100. They start off as just percents, so 10.0 (7.0, 13.0) to reflect 10% with a range of 7 to 13 percent. But, if I want have them the same as the percentages I have throughout the model, i.e., 0 is 0% and 1 is 100%, and 0.5 is 50%, then I'll need to divide these by 100. This goes equally for any percentages I find in the literature reported as just 10% say, and want to include, they'll need to be divided by 100 to put them in the same units as the 0-1 percentages range I use throughout my model. And the fact that the alpha and beta calculated in this report exactly match the alpha and beta I calculate when I've made this /100) adjustment means that, regardless of the fact that the authors list the percentages as 10.0, 7.0 and 13.0 in Table A4, when they actually went to analyse these, they also applied the /100) adjustment.

Var <- a*b/((a+b)^2*(a+b+1))
se<-sqrt(Var)


myse <- ((max)-(mean))/2
mysemin <- ((mean)-(min))/2

devinse <- (max - min)/(2 * qnorm(.975))

briggsse <- ((max)-(mean))/1.96
briggssemin <- ((mean)-(min))/1.96

# When the range isnt PERFECTLY centered around the mean, i.e., the min is further away from the mean than the max, it looks like you use altbriggsse to incorporate this wider range, than you would see taking max-mean, what's interesting is that mean-min isnt enough to replicate the results in the study, it has to be max-min (although the fact that mean-min is divided by /1.96 and max-min is divided by /2*1.96 also contributes I'm sure). Devinse does this also, but I don't like it as much because the qnorm(.975) seems a bit less clear on what it's doing, even though > 2 * qnorm(.975) [1] 3.919928 is more or less the exact same as > 2*1.96 [1] 3.92. Nonetheless, Devins SE's are always slightly different to the actual SE when compared to briggsse, which has made me prefer briggsse.
altbriggsse <- (max-min)/(2*1.96)


wrongbriggsse <- ((max)-(min))/2*1.96

logse <- (log(max) - log(min)) / 3.92

# 3.92 is just 1.96*2

logse2 <- (log(max) - log(mean)) / (2*1.96)
logsemin2 <- (log(mean) - log(min)) / (2*1.96)







tq <- c(1,1.376,1.963,3.078,6.31,12.71,31.82,63.66,106.1,159.2,0.816,1.061,1.386,1.886,2.92,4.303,6.965,9.925,12.85,15.76,0.765,0.978,1.25,1.638,2.353,3.182,4.541,5.841,6.994,8.053,0.741,0.941,1.19,1.533,2.132,2.776,3.747,4.604,5.321,5.951,0.727,0.92,1.156,1.476,2.015,2.571,3.365,4.032,4.57,5.03,0.718,0.906,1.134,1.44,1.943,2.447,3.143,3.707,4.152,4.524,0.711,0.896,1.119,1.415,1.895,2.365,2.998,3.499,3.887,4.207,0.706,0.889,1.108,1.397,1.86,2.306,2.896,3.355,3.705,3.991,0.703,0.883,1.1,1.383,1.833,2.262,2.821,3.25,3.573,3.835,0.7,0.879,1.093,1.372,1.812,2.228,2.764,3.169,3.472,3.716,0.697,0.876,1.088,1.363,1.796,2.201,2.718,3.106,3.393,3.624,0.695,0.873,1.083,1.356,1.782,2.179,2.681,3.055,3.33,3.55,0.694,0.87,1.079,1.35,1.771,2.16,2.65,3.012,3.278,3.489,0.692,0.868,1.076,1.345,1.761,2.145,2.624,2.977,3.234,3.438,0.691,0.866,1.074,1.341,1.753,2.131,2.602,2.947,3.197,3.395,0.69,0.865,1.071,1.337,1.746,2.12,2.583,2.921,3.165,3.358,0.689,0.863,1.069,1.333,1.74,2.11,2.567,2.898,3.138,3.326,0.688,0.862,1.067,1.33,1.734,2.101,2.552,2.878,3.113,3.298,0.688,0.861,1.066,1.328,1.729,2.093,2.539,2.861,3.092,3.273,0.687,0.86,1.064,1.325,1.725,2.086,2.528,2.845,3.073,3.251,0.686,0.859,1.063,1.323,1.721,2.08,2.518,2.831,3.056,3.231,0.686,0.858,1.061,1.321,1.717,2.074,2.508,2.819,3.041,3.214,0.685,0.858,1.06,1.319,1.714,2.069,2.5,2.807,3.027,3.198,0.685,0.857,1.059,1.318,1.711,2.064,2.492,2.797,3.014,3.183,0.684,0.856,1.058,1.316,1.708,2.06,2.485,2.787,3.003,3.17,0.684,0.856,1.058,1.315,1.706,2.056,2.479,2.779,2.992,3.158,0.684,0.855,1.057,1.314,1.703,2.052,2.473,2.771,2.982,3.147,0.683,0.855,1.056,1.313,1.701,2.048,2.467,2.763,2.973,3.136,0.683,0.854,1.055,1.311,1.699,2.045,2.462,2.756,2.965,3.127,0.683,0.854,1.055,1.31,1.697,2.042,2.457,2.75,2.957,3.118,0.682,0.853,1.054,1.309,1.696,2.04,2.453,2.744,2.95,3.109,0.682,0.853,1.054,1.309,1.694,2.037,2.449,2.738,2.943,3.102,0.682,0.853,1.053,1.308,1.692,2.035,2.445,2.733,2.937,3.094,0.682,0.852,1.052,1.307,1.691,2.032,2.441,2.728,2.931,3.088,0.682,0.852,1.052,1.306,1.69,2.03,2.438,2.724,2.926,3.081,0.681,0.851,1.05,1.303,1.684,2.021,2.423,2.704,2.902,3.055,0.679,0.849,1.047,1.299,1.676,2.009,2.403,2.678,2.87,3.018,0.679,0.848,1.045,1.296,1.671,2,2.39,2.66,2.849,2.994,0.677,0.845,1.041,1.289,1.658,1.98,2.358,2.617,2.798,2.935,0.674,0.842,1.036,1.282,1.645,1.96,2.326,2.576,2.748,2.878)

#tqse <- ((max)-(min))/tq
sprintf("%.100f",tqse <- ((max)-(min))/tq)



se
myse
devinse
briggsse
altbriggsse
wrongbriggsse
logse
logse2
mysemin
briggssemin
logsemin2
tqse



# Here are the results, for the paper, there are:

# myse:
# devinse:
# briggsse:
# altbriggsse:
# wrongbriggsse:
# logse:
# logse2:
# tqse:




















# Here's what I originally thought was happening in the Tilson paper, the formula to generate the se is se <- ((Maximum) - (Mean))/2 but the 2 is really a t-quantile with n-1 degrees of freedom [i.e., SE = (CIupper-m)/t], but I use 2 as a simplification because "For large n the quantile approaches 2.0 (well, 1.959964... to be more precise; but using 2.0 is good enough)." I think that the authors of this study actually looked up the t-quantile and divided by that each time, rather than dividing by 2, i.e. "The t-quantile can be looked up for the level of confidence when the total sample size (n) is known.... For instance, the t-quantile for 95% confidence, n=10 and k=2 is 2.3." per: researchgate.net/post/Formula_for_calculate_Standard_errorSE_from_Confidence_IntervalCI There is also information supporting this here: https://stats.stackexchange.com/questions/550293/how-to-calculate-standard-error-given-mean-and-confidence-interval-for-a-gamma-d


# I checked this by dividing by every value in the t-quantile here: https://homepage.cs.uiowa.edu/~jblang/probability.calculators/t.table.htm

# tq <- c(1,1.376,1.963,3.078,6.31,12.71,31.82,63.66,106.1,159.2,0.816,1.061,1.386,1.886,2.92,4.303,6.965,9.925,12.85,15.76,0.765,0.978,1.25,1.638,2.353,3.182,4.541,5.841,6.994,8.053,0.741,0.941,1.19,1.533,2.132,2.776,3.747,4.604,5.321,5.951,0.727,0.92,1.156,1.476,2.015,2.571,3.365,4.032,4.57,5.03,0.718,0.906,1.134,1.44,1.943,2.447,3.143,3.707,4.152,4.524,0.711,0.896,1.119,1.415,1.895,2.365,2.998,3.499,3.887,4.207,0.706,0.889,1.108,1.397,1.86,2.306,2.896,3.355,3.705,3.991,0.703,0.883,1.1,1.383,1.833,2.262,2.821,3.25,3.573,3.835,0.7,0.879,1.093,1.372,1.812,2.228,2.764,3.169,3.472,3.716,0.697,0.876,1.088,1.363,1.796,2.201,2.718,3.106,3.393,3.624,0.695,0.873,1.083,1.356,1.782,2.179,2.681,3.055,3.33,3.55,0.694,0.87,1.079,1.35,1.771,2.16,2.65,3.012,3.278,3.489,0.692,0.868,1.076,1.345,1.761,2.145,2.624,2.977,3.234,3.438,0.691,0.866,1.074,1.341,1.753,2.131,2.602,2.947,3.197,3.395,0.69,0.865,1.071,1.337,1.746,2.12,2.583,2.921,3.165,3.358,0.689,0.863,1.069,1.333,1.74,2.11,2.567,2.898,3.138,3.326,0.688,0.862,1.067,1.33,1.734,2.101,2.552,2.878,3.113,3.298,0.688,0.861,1.066,1.328,1.729,2.093,2.539,2.861,3.092,3.273,0.687,0.86,1.064,1.325,1.725,2.086,2.528,2.845,3.073,3.251,0.686,0.859,1.063,1.323,1.721,2.08,2.518,2.831,3.056,3.231,0.686,0.858,1.061,1.321,1.717,2.074,2.508,2.819,3.041,3.214,0.685,0.858,1.06,1.319,1.714,2.069,2.5,2.807,3.027,3.198,0.685,0.857,1.059,1.318,1.711,2.064,2.492,2.797,3.014,3.183,0.684,0.856,1.058,1.316,1.708,2.06,2.485,2.787,3.003,3.17,0.684,0.856,1.058,1.315,1.706,2.056,2.479,2.779,2.992,3.158,0.684,0.855,1.057,1.314,1.703,2.052,2.473,2.771,2.982,3.147,0.683,0.855,1.056,1.313,1.701,2.048,2.467,2.763,2.973,3.136,0.683,0.854,1.055,1.311,1.699,2.045,2.462,2.756,2.965,3.127,0.683,0.854,1.055,1.31,1.697,2.042,2.457,2.75,2.957,3.118,0.682,0.853,1.054,1.309,1.696,2.04,2.453,2.744,2.95,3.109,0.682,0.853,1.054,1.309,1.694,2.037,2.449,2.738,2.943,3.102,0.682,0.853,1.053,1.308,1.692,2.035,2.445,2.733,2.937,3.094,0.682,0.852,1.052,1.307,1.691,2.032,2.441,2.728,2.931,3.088,0.682,0.852,1.052,1.306,1.69,2.03,2.438,2.724,2.926,3.081,0.681,0.851,1.05,1.303,1.684,2.021,2.423,2.704,2.902,3.055,0.679,0.849,1.047,1.299,1.676,2.009,2.403,2.678,2.87,3.018,0.679,0.848,1.045,1.296,1.671,2,2.39,2.66,2.849,2.994,0.677,0.845,1.041,1.289,1.658,1.98,2.358,2.617,2.798,2.935,0.674,0.842,1.036,1.282,1.645,1.96,2.326,2.576,2.748,2.878)

# And when I checked if my SE now matched the SE I got from the alpha and beta in the paper, it still didnt match.

# myse <- ((max)-(mean))/tq
# myse





# For Table 1 in the following, under utilities if I plug the SE and base case value into my formula for creating alpha and beta and then take randome draws for the mean from rbeta I get the same mean as reported as the base case value in the table. Indicating that the formula I use once I have the SE and mean to get the alpha and beta, and thus the new mean, is correct: Kristin, E., Endarti, D., Khoe, L. C., Taroeno-Hariadi, K. W., Trijayanti, C., Armansyah, A., & Sastroasmoro, S. (2021). Economic evaluation of adding bevacizumab to chemotherapy for metastatic colorectal cancer (mCRC) patients in Indonesia. Asian Pacific Journal of Cancer Prevention: APJCP, 22(6), 1921. also saved here: file:///C:/Users/Jonathan/OneDrive%20-%20Royal%20College%20of%20Surgeons%20in%20Ireland/COLOSSUS/Evidence%20Synthesis/Economic%20Models/Kristin%20et%20al_2021_Economic%20Evaluation%20of%20Adding%20Bevacizumab%20to%20Chemotherapy%20for%20Metastatic.pdf


# So, the whole problems comes down to the manner in which I am generating the SE from the mean and range.
