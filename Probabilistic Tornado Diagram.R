
# df_PA_input
# 
# df_PA_input <- data.frame(
#   coef_weibull_shape_SoC = m_coef_weibull_SoC[ , "shape"],
#   coef_weibull_scale_SoC = m_coef_weibull_SoC[ , "scale"],
#   coef_TTD_weibull_shape_SoC = m_coef_weibull_OS_SoC[ , "shape"],
#   coef_TTD_weibull_scale_SoC = m_coef_weibull_OS_SoC[ , "scale"],
# 
#   n_cycle   = n_cycle,
#   t_cycle   = t_cycle
#   
#   
#   df_c <- df_e
#   
# )




# I think I should only create one DSAICER below, I think the fact that its for SoC and Exp is what's messing things up, as values will always be the same.

# If the below doesnt work, create both Exp = and SoC = as before, but then once you've made it go back in and replace all the SoC values with NA, like the df_cea dataframe has.

#  xf_DSAICER <- data.frame(
#    Exp = rep(NA, n_runs)
#  )
# 
# 
#  for(i_run in 1:n_runs){
#    
#    # Evaluate the model and store the outcomes
#    l_out_xfDSAICER_temp    <- oncologySemiMarkov(l_params_all = df_PA_input[i_run, ], n_wtp = n_wtp)
# # The above is basically saying, apply the oncologySemiMarkov_function, where l_params_all in the function (i.e. the list of parameters the function is to be applied to) is equal to the parameters from the PSA data.frame for the run we are in, and the willingness to pay threshold is n_wtp.
#    f_DSAICER[i_run, ] <- l_out_xfDSAICER_temp$DSAICER
#    
# # While we're doing this, we might like to display the progress of the simulation:
# if(i_run/(n_runs/10) == round(i_run/(n_runs/10), 0)) { # We've chosen to display progress every 10%
#      cat('\r', paste(i_run/n_runs * 100, "% done", sep = " "))
#    }
#  }

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






















 xf_DSAICER <- data.frame(
   Exp = rep(NA, n_runs)
 )
 
 
 for(i_run in 1:n_runs){
   
   # Evaluate the model and store the outcomes
   l_out_xfDSAICER_temp    <- oncologySemiMarkov(l_params_all = df_PA_input[i_run, ], n_wtp = n_wtp)
   # The above is basically saying, apply the oncologySemiMarkov_function, where l_params_all in the function (i.e. the list of parameters the function is to be applied to) is equal to the parameters from the PSA data.frame for the run we are in, and the willingness to pay threshold is n_wtp.
   f_DSAICER[i_run, ] <- l_out_xfDSAICER_temp$DSAICER
   
   # While we're doing this, we might like to display the progress of the simulation:
   if(i_run/(n_runs/10) == round(i_run/(n_runs/10), 0)) { # We've chosen to display progress every 10%
     cat('\r', paste(i_run/n_runs * 100, "% done", sep = " "))
   }
 }



l_PA <- make_psa_obj(cost          = df_c, 
                     effectiveness = aaf_DSAICER, 
                     parameters    = df_PA_input, 
                     strategies    = c("SoC", "Exp"))

psa_obj <- make_psa_obj(cost = df_c,
                        effectiveness = aaf_DSAICER,
                        parameters = l_PA$parameters,
                        strategies = l_PA$strategies,
                        currency = "$")
str(psa_obj)
plot(psa_obj)
psa_sum <- summary(psa_obj, 
                   calc_sds = TRUE)
psa_sum

icers <- calculate_icers(cost = psa_sum$meanCost, 
                         effect = psa_sum$meanEffect, 
                         strategies = psa_sum$Strategy)
plot(icers)

ceac_obj <- ceac(wtp = v_wtp, 
                 psa = psa_obj)
head(ceac_obj)

summary(ceac_obj)

plot(ceac_obj, 
     frontier = TRUE, 
     points = TRUE)


el <- calc_exp_loss(wtp = v_wtp, 
                    psa = psa_obj)
head(el)
#>     WTP Strategy Expected_Loss On_Frontier
#> 1  1000    Chemo     15472.987       FALSE
#> 2  1000    Radio      1084.833        TRUE
#> 3  1000  Surgery      9869.887       FALSE
#> 4 11000    Chemo     13163.617       FALSE
#> 5 11000    Radio      2613.132        TRUE
#> 6 11000  Surgery      9435.351       FALSE
plot(el, 
     n_x_ticks = 8, 
     n_y_ticks = 6)

o <- owsa(psa_obj)

plot(o,
     n_x_ticks = 2)


owsa_tornado(o)


owsa_tornado(o, 
             min_rel_diff = 0.05)

owsa_tornado(o, return = "data")


owsa_opt_strat(o, n_x_ticks = 5)


i1 <- owsa_opt_strat(o, 
               return = "data")

print(i1,n=700)


# I think the owsa_opt_strat will help me answer the necessary cost reduction in Bevacizumab for this to be cost-effective. Basically, if you look at the last diagram here : https://web.archive.org/web/20220802010424/https://cran.r-project.org/web/packages/dampack/vignettes/psa_analysis.html you'll see that this shows you at what probability of failing chemo the chemo treatment is cost-effective and at which probability of failing chemo the surgery treatment becomes cost-effective, so if I re-run the above but this time decrease the cost of bevacizumab by a huge number I'll have a range within which I'll know at which cost of bevacizumab the SOC treatment is cost-effective and at which point the Exp becomes cost-effective, much like in the link for the changing probabilities of chemo failure. And particularly, I can see this in the data frame most easily. 


# So, this is a PSA, which makes it harder to get every single value in order like we would for seeing which cost value for bevacizumab gives us an UCER below the necessary threshod than in a deterministic analysis analysis where it's as simple as setting the max to be 90% higher and the min to be 90% lower and then you see which ICER value prodiced is ;pwer. For a PSA it's not gguranteed that all numbers from the minimum cost to it's maxi,u, will appear, because you are taking random draws, so what I've done here is re-run the PSA and increased the max and min size of the bevacizumab xost and also I've increased the number of runs to make it more likely that we'll reach the lowest bevacizumab cost that will give us an ICER that may be cost-effective. 

# Alternatively, what I could do is re-run the PSA and assume the bevacizumab is estimated with certainty, then I could pick a value  that I think would be cost-effective and ffill that in for the bevcizumab and see if it was ost effective and keep entering values for bevacizumab cost until I found one that was cost-effective.

# In addition, when I look at the ICER and cost of bev in a table using view () below it's necessary to sort by the bev cost in order to put the two runs together where bev was the same cost, or else things don't match.



c_PFS_Bevacizumab 

Minimum_c_PFS_Bevacizumab  <- c_PFS_Bevacizumab - 0.90*c_PFS_Bevacizumab
Maximum_c_PFS_Bevacizumab  <- c_PFS_Bevacizumab + 0.90*c_PFS_Bevacizumab


{

### PROBABILISTIC ANALYSIS ----

# We conduct a probabilistic analysis (PSA) of the model to estimate the uncertainty in the model outcomes.

# To do this, we generate samples for each model parameter from parametric distributions and evaluate the model for each set of parameter samples.


## Sampling the parameter values ----

# In order for the results reported in the PSA to be reproducible we need to set the random number seed. We also defining the number of runs, i.e., how many times we will re-sample for the parameter distributions, typically the number chosen is 10,000 in published studies, so we do that too:
n_runs <- 50000
set.seed(123)

df_PA_input <- data.frame(

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

}



xf_DSAICER <- data.frame(
  Exp = rep(NA, n_runs)
)


for(i_run in 1:n_runs){
  
  # Evaluate the model and store the outcomes
  l_out_xfDSAICER_temp    <- oncologySemiMarkov(l_params_all = df_PA_input[i_run, ], n_wtp = n_wtp)
  # The above is basically saying, apply the oncologySemiMarkov_function, where l_params_all in the function (i.e. the list of parameters the function is to be applied to) is equal to the parameters from the PSA data.frame for the run we are in, and the willingness to pay threshold is n_wtp.
  f_DSAICER[i_run, ] <- l_out_xfDSAICER_temp$DSAICER
  
  # While we're doing this, we might like to display the progress of the simulation:
  if(i_run/(n_runs/10) == round(i_run/(n_runs/10), 0)) { # We've chosen to display progress every 10%
    cat('\r', paste(i_run/n_runs * 100, "% done", sep = " "))
  }
}


aaf_DSAICER <- f_DSAICER
head(aaf_DSAICER)

# aaf_DSAICER$SoC <- aaf_DSAICER$SoC/n_wtp
# aaf_DSAICER
# 
# aaf_DSAICER$Exp <- aaf_DSAICER$SoC/n_wtp

aaf_DSAICER <- n_wtp/aaf_DSAICER
head(aaf_DSAICER)


# Replace Exp values with Exp + 10 and SoC with 5 where Exp is greater than or equal to 1
#aaf_DSAICER$Exp <- ifelse(aaf_DSAICER$Exp >= 1, aaf_DSAICER$Exp + 10, 2.5)
#head(aaf_DSAICER)

#aaf_DSAICER$SoC <- ifelse(aaf_DSAICER$Exp >= 11, 5, aaf_DSAICER$SoC + 5)
#head(aaf_DSAICER)






# Replace SoC values with 0 where Exp is greater than or equal to 1
 aaf_DSAICER$SoC <- ifelse(aaf_DSAICER$Exp >= 1, 0, aaf_DSAICER$SoC)
 head(aaf_DSAICER)

# Replace Exp values with 0 where Exp is less than 1
 aaf_DSAICER$Exp <- ifelse(aaf_DSAICER$Exp < 1, 0, aaf_DSAICER$Exp)
 head(aaf_DSAICER)

# The ifelse function takes three arguments:
  
# A logical test
# A value to use if the test is TRUE
# A value to use if the test is FALSE

# In the first line, it checks if Exp is greater than or equal to 1, and if so, it replaces the corresponding SoC value with 0. Otherwise, it leaves the SoC value as is. 
# The second line then checks if Exp is less than 1, and if so, it replaces Exp with 0. Otherwise, it leaves the Exp value as is. This ensures that whenever Exp is greater than or equal to 1, SoC is 0 in the same row. If Exp is less than 1, it becomes 0 and SoC retains its original value.


# 
# # Replace SoC values less than 1 with 0
# aaf_DSAICER$SoC <- ifelse(aaf_DSAICER$SoC < 1, 0, aaf_DSAICER$SoC)
# head(aaf_DSAICER)
# 
# # Replace Exp values greater than or equal to 1 with 1
# aaf_DSAICER$Exp <- ifelse(aaf_DSAICER$Exp >= 1, 1, aaf_DSAICER$Exp)
# head(aaf_DSAICER)


l_PA <- make_psa_obj(cost          = df_c, 
                     effectiveness = aaf_DSAICER, 
                     parameters    = df_PA_input, 
                     strategies    = c("SoC", "Exp"))

psa_obj <- make_psa_obj(cost = df_c,
                        effectiveness = aaf_DSAICER,
                        parameters = l_PA$parameters,
                        strategies = l_PA$strategies,
                        currency = "$")
o <- owsa(psa_obj)

#o

# o$SoC <- NA


# i1 <- owsa_opt_strat(o, return = "data")

# head(i1)

i1 <- subset(o, parameter == "c_PFS_Bevacizumab")
# i1 <- subset(o, parameters %in% c("c_PFS_Bevacizumab", "DSAICER"))
head(i1)
view(i1)



print(i1,n=700)

















