# I record the original value of c_PFS_Bevacizumab here on the understanding that this will be updated later by the fact that I keep changing this in continuous decrements to bring cost down and see the effect on ICERs:

Original_Price_c_PFS_Bevacizumab <- c_PFS_Bevacizumab

# Initialize c_PFS_BevacizumabReduction as NULL
c_PFS_BevacizumabReduction <- NULL

# Initialize a counter
counter <- 0

# I set c_PFS_Bevacizumab == 700 as a one off to make sure the code works by running it quickly with a low cost value that should be close to cost-effective, I'll need to delete this later:

# c_PFS_Bevacizumab <- 700

# I wanted to make sure the below code worked, so when it ran for Ireland and gave me 

# c_PFS_BevacizumabReduction: 665.69303493 
# df_cea_PA$ICER[2]: 44551.3629755377

# So, a Bev cost of 665.69303493 Which was a percentage reduction in cost of 56.42% from the initial c_PFS_Bevacizumab <- 1187.55 and as you can see my ICER is just below the WTP threshold of 45,000

# But, I wanted to make sure that we were getting as close to the threshold as possible without going over in this code, as that would let me know the necessary reduction in Bev cost to reach cost-effectiveness, i.e., I didnt want to say we NEED to reduce the cost by 56% when actually 54% would be OK.

# So, I increased the cost of bev to 680, a percentage point larger than what my code had selected (57.26%), to see if it was getting the price as low as possible.

# When I did this I got an ICER of 45,509 which is just over the WTP, which means my original 56% was the minimum necessary reduction to get an ICER that was <= 45,000 thus, this 56% is the minimum necessary reduction in Bev cost to make providing bev cost-effective in our analysis.


# Start the loop
while(is.null(c_PFS_BevacizumabReduction) & counter < 30000) {
  # Increase the counter by 1
  counter <- counter + 1
  
  # Decrease the value of c_PFS_Bevacizumab by 1%
  c_PFS_Bevacizumab <- c_PFS_Bevacizumab * 0.99
  
 
  # I START RUNNING MY PSA CODE HERE:
  
  
  # I Run my PSA code here:
  
  
  
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
  
  m_coef_weibull_OS_SoC <- mvrnorm(
    n     = n_runs, 
    mu    = l_TTD_SoC_weibull$coefficients, 
    Sigma = l_TTD_SoC_weibull$cov
  )
  
  head(m_coef_weibull_OS_SoC)
  
  
  
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
    
    # Because I am updating the cost of bev at the start of this loop, it is also necessary to update the associated max and min using this new updated cost:
    
    Minimum_c_PFS_Bevacizumab  <- c_PFS_Bevacizumab - 0.20*c_PFS_Bevacizumab,
    Maximum_c_PFS_Bevacizumab  <- c_PFS_Bevacizumab + 0.20*c_PFS_Bevacizumab,
    
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
    
    
    
    #  subtyping_test_cost 
    
    Maximum <- Maximum_subtyping_test_cost,
    Mean <- subtyping_test_cost,
    
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
    
    subtyping_test_cost = rgamma(n_runs, shape = a.cIntervention, scale = b.cIntervention), 
    
    a.cIntervention_subtyping_test_cost  <-a.cIntervention,
    b.cIntervention_subtyping_test_cost  <-b.cIntervention, 
    
    
    
    
    
    
    
    
    
    
    
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
  
  # It's a dataframe made up of the 10,000 values I asked be made at the start of this code chunk.
  
  # If I wanted to save the dataframe, I would do this as follows:
  
  #save(df_PA_input, file = "df_PA_input.rda")
  
  
  
  # 09.1 Conduct probabilistic sensitivity analysis
  
  # Running the probabilistic analysis :
  
  # First we need to create data.frames to store the output from the PSA:
  
  df_c <- df_e <- data.frame(
    SoC = rep(NA, n_runs),
    Exp = rep(NA, n_runs)
  )
  
  # As you'll see, first we make blank (repeat NA for the number of runs of the simulationn_runs) data.frames for costs (df_c) and effectiveness (df_e) for SoC and the experimental treatment:
  
  head(df_c)
  
  # > head(df_c)
  #   SoC Exp
  # 1  NA  NA
  # 2  NA  NA
  # 3  NA  NA
  # 4  NA  NA
  # 5  NA  NA
  # 6  NA  NA
  
  head(df_e)
  
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
  
  
  # 
  
  # If I wanted to save the ICERs for each run of the PSA from it's calculated costs and effects for that run, I would just update the above as follows:
  
  # 
  # # 09.1 Conduct probabilistic sensitivity analysis
  # 
  # # Running the probabilistic analysis :
  # 
  # # First we need to create data.frames to store the output from the PSA:
  # 
  # df_c <- df_e <- data.frame(
  #   SoC = rep(NA, n_runs),
  #   Exp = rep(NA, n_runs)
  # )
  # 
  # df_DSAICER <- data.frame(
  #   SoC = rep(NA, n_runs),
  #   Exp = rep(NA, n_runs)
  # )
  
  
  # Of course the DSAICER is going to be the same for SOC and Exp because only one ICER is ever created, but I just didnt know if this would work if I only created a data frame for SoC or Exp and not both, and this was quite a quick and dirty way of calculating the ICERs. 
  
  
  # # As you'll see, first we make blank (repeat NA for the number of runs of the simulationn_runs) data.frames for costs (df_c) and effectiveness (df_e) for SoC and the experimental treatment:
  # 
  # head(df_c)
  # 
  # # > head(df_c)
  # #   SoC Exp
  # # 1  NA  NA
  # # 2  NA  NA
  # # 3  NA  NA
  # # 4  NA  NA
  # # 5  NA  NA
  # # 6  NA  NA
  # 
  # head(df_e)
  # 
  # # > head(df_e)
  # #   SoC Exp
  # # 1  NA  NA
  # # 2  NA  NA
  # # 3  NA  NA
  # # 4  NA  NA
  # # 5  NA  NA
  # # 6  NA  NA
  # 
  # # We run the Markov model for each set of parameter values from the PSA input dataset (a set of parameters here is the row of parameter values in the PSA data.frame from whatever run number of the nruns in the PSA dataset we are on, i.e. if we were doing this for run number 10 out of 10,000, we would be on row 10 in the data.frame (as each row refers to a run) and we would use all the values for costs and effect that appear in this row when running the Markov model. So, we would be using all the random draws for that PSA run in the Markov model).
  # 
  # # - I read a note indicating that this loop can be run in parallel to decrease the runtime, something to consider in the future if it takes a very long time...
  # 
  # for(i_run in 1:n_runs){
  #   
  #   # Evaluate the model and store the outcomes
  #   l_out_temp    <- oncologySemiMarkov(l_params_all = df_PA_input[i_run, ], n_wtp = n_wtp)
  #   # The above is basically saying, apply the oncologySemiMarkov_function, where l_params_all in the function (i.e. the list of parameters the function is to be applied to) is equal to the parameters from the PSA data.frame for the run we are in, and the willingness to pay threshold is n_wtp.
  #   df_c[i_run, ] <- l_out_temp$Cost
  #   df_e[i_run, ] <- l_out_temp$Effect
  #   df_DSAICER[i_run, ] <- l_out_temp$DSAICER
  #   
  #   # The above says, for the costs and effectiveness data.frames, store the value of costs and effects for each run that we are on in a row that reflects that run (remembering that [ROW,COLUMN], we are putting each cost and effect in a row that relates to the number of the run we are on, so if we are on run 1, i_run = 1 and we store the costs and effects for that run 1 in row 1. Remembering that our oncologySemiMarkov makes the "Cost" and "Effect" parameters at the end of the function, after applying the Markov cost-effectiveness model to all our input data for the cost-effectiveness model (so, things like, cost, utility and probability), so we are just pulling the ouputted Cost and Effect values calculated from a Markov cost-effectiveness model applied to our input data after the input data has been randomly drawn from a PSA (per the PSA input dataframe)).  
  #   
  #   
  #   # While we're doing this, we might like to display the progress of the simulation:
  #   if(i_run/(n_runs/10) == round(i_run/(n_runs/10), 0)) { # We've chosen to display progress every 10%
  #     cat('\r', paste(i_run/n_runs * 100, "% done", sep = " "))
  #   }
  # }
  # 
  # 
  # # To check that the above DSAICER is actually calculating the ICER values, I manually checked this by exporting the dataframe of costs and effects from SoC and Exp to Excel and then manually calculated the ICERs, and the ICERs calculated in the Excel match those in DSAICER (in MANUAL ICER CALCULATIONS IRELAND.xlsx):
  # 
  # write.csv(DSAICER,'DSAICER.csv')
  # write.csv(df_e,'df_eGER.csv')
  # write.csv(df_c,'df_cGER.csv')
  # 
  
  # When I averaged the ICERs in DSAICER they didnt match the ICER created below, in table_cea_PA, but I did match the ICER in the table with the ICER I created by averaging the incremental costs and effects (which matchered the incremental costs and effects in the table when I averaged these) and creating the ICER by dividing the average incremental cost by the average incremental utility, so it must just be that they calculate their ICER in the table by dividing the average incremental cost by the average incremental utility, rather than average all the ICERs created in the PSA. Which would make sense as I updated their function code to include DSAICER, originally it was NMB in the function where I create DSAICER in the first place, so they wouldnt have had a DSAICER to average across all the runs. So it makes sense theyd have to go this way as they'll always be calculating costs and effects, but they won't always know what you are interested in as your final measure, i.e., ICER, NMB, etc.,
  
  # Knowing that DSAICER reflects the ICERs across simulations means I am able to order them from smallest to largest to allow me to determine how many ICERs from the PSA are at or below the WTP threshold, that is, how many are cost-effective. This information allows me to report the following when I see that for Ireland 18 ICERs are < = 45000
  
  
  # 18 is what percent of 10000?
  # 18 is P% of 10000
  # Equation: Y = P% * X
  # Solving our equation for P
  # P% = Y/X
  # P% = 18/10000
  # p = 0.0018
  # Convert decimal to percent:
  # P% = 0.0018 * 100 = 0.18%
  
  # That is, less than 1% of the simulations (0.18%) were cost-effective.
  
  # so 100-0.18, 99.82% of simulations were not cost-effective. 
  
  # And the CEAC I created reflects this, you'll see that in the CEAC for Ireland, the probability of cost-effectiveness hovers at around 0 for standard of care up until WTP thresholds go above 50k, at which point it starts to climb (slowly).
  
  # And that's really the whole point of the CEAC, it's fed by the PSA and basically puts the PSA ICERs in order from smallest to biggest so you can see what percentage of them fall under the different WTP thresholds. Try to remember that the CEAC is just taking the PSA values for ICERs and putting them on a graph that shows how many are under the WTP threshold described at the bottom.
  
  
  
  #09.2 Create PSA object for dampack
  
  # Dampack has a number of functions to summarise and visualise the results of a probabilistic sensitivity analysis. However, the data needs to be in a specific structure before we can use those functions. 
  
  # The 'dampack' package contains multiple useful functions that summarize and visualize the results of a
  # probabilitic analysis. To use those functions, the data has to be in a particular structure.
  l_PA <- make_psa_obj(cost          = df_c, 
                       effectiveness = df_e, 
                       parameters    = df_PA_input, 
                       strategies    = c("SoC", "Exp"))
  
  # So, basically we make a psa object for Dampack where df_c is the dataframe of costs from the Markov model being applied to the PSA data, and df_e is the data.frame of effectiveness from the Markov model being applied to the PSA dataset, the parameters that are included are those from the PSA analysis, which we fed into df_PA_input above (df_PA_input<-) and the two strategies are SoC and Exp.
  
  
  #09.3.1 Conduct CEA with probabilistic output
  
  # First we take the mean outcome estimates, that is, we summarise the expected costs and effects for each strategy from the PSA:
  (df_out_ce_PA <- summary(l_PA))
  
  
  # Calculate incremental cost-effectiveness ratios (ICERs)
  
  # Then we calculate the ICERs from this df_out_ce_PA (summary must be a dampack function doing things under the hood to create a selectable ($) meanCost, meanEffect and Strategy parameter in df_out_ce_PA):
  (df_cea_PA <- calculate_icers(cost       = df_out_ce_PA$meanCost, 
                                effect     = df_out_ce_PA$meanEffect,
                                strategies = df_out_ce_PA$Strategy))
  
  # We can view the ICER results from the PSA here:
  df_cea_PA
  
  
  
  # I STOP RUNNING MY PSA CODE HERE.
  

  
  
  # Check if df_cea_PA$ICER is less than or equal to n_wtp
  if(df_cea_PA$ICER[2] <= n_wtp) {
    # If it is, assign the current value of c_PFS_Bevacizumab to c_PFS_BevacizumabReduction
    c_PFS_BevacizumabReduction <- c_PFS_Bevacizumab


# Calculate the percentage reduction of c_PFS_Bevacizumab from Original_Price_c_PFS_Bevacizumab
    percentage_reduction <- (Original_Price_c_PFS_Bevacizumab - c_PFS_Bevacizumab) / Original_Price_c_PFS_Bevacizumab * 100        
    
        
    # Save the value of c_PFS_BevacizumabReduction to a notepad document
#    write(c_PFS_BevacizumabReduction, file = paste0("necessary_bev_cost_reduction_",country_name, ".txt"))
    
    
    # Actually, I want to save the value of c_PFS_BevacizumabReduction and the ICER this produces to a notepad document, which I now do as below:
    
    # Save the value of c_PFS_BevacizumabReduction, df_cea_PA$ICER[2], and the percentage reduction to a notepad document
    
    write(paste("c_PFS_BevacizumabReduction:", c_PFS_BevacizumabReduction, 
                "\ndf_cea_PA$ICER[2]:", df_cea_PA$ICER[2], 
          "\nNecessary Percentage Bevacizumab reduction:", percentage_reduction, "%"),
          file = paste0("necessary_bev_cost_reduction_",country_name, ".txt"))
    
    
    # Print the value of c_PFS_BevacizumabReduction
    print(c_PFS_BevacizumabReduction)
  }
  
  # If the counter reaches 300 and the condition is never met
  if(counter == 30000 && is.null(c_PFS_BevacizumabReduction)) {
    # Create a notepad document with "never_cost_effective" written ahead of the country_name
    write(c_PFS_Bevacizumab, file = paste0("never_cost_effective_", country_name, ".txt"))
  }
}

# The loop will continue until df_cea_PA$ICER is less than or equal to n_wtp or the counter reaches 300


