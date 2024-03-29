# This script is used in the Markov_3state.Rmd script to define the function that evaluates the three-state semi-Markov model for a specific set of parameter values.

# This "function" is basically just repeating the code from the Markov_3state.R script again.

oncologySemiMarkov <- function(l_params_all, n_wtp = n_wtp) {
  
  with(as.list(l_params_all), {
    
    # TRANSITION PROBABILITIES: Time-To-Transition - TTP:
    
    
    # Time-dependent transition probabilities are obtained in four steps
    # 1) Defining the cycle times
    # 2) Obtaining the event-free (i.e. survival) probabilities for the cycle times for SoC
    # 3) Obtaining the event-free (i.e. survival) probabilities for the cycle times for Exp based on a hazard ratio
    # 4) Obtaining the time-dependent transition probabilities from the event-free (i.e. survival) probabilities
    
    # 1) Defining the cycle times    
    t <- seq(from = 0, by = t_cycle, length.out = n_cycle + 1)
    
    # I think here we're saying, at each cycle how many of the time periods our individual patient data is measured at have passed? Here our individual patient data is in months, so we have 0 in cycle 0, 0.5 or half a month in cycle 1, and so on.
    
    # Having established that allows us to obtain the transition probabilities for the time we are interested in for our cycles from this longer period individual patient data, so where the individual patient data is in months and our cycles are in fortnight or half months, this allows us to obtain transition probabilities for these fortnights.
    
    # 2) Obtaining the event-free (i.e. survival) probabilities for the cycle times for SoC
    # S_FP_SoC - survival of progression free to progression, i.e. not going to progression, i.e. staying in progression free.
    # Note that the coefficients [that we took from flexsurvreg earlier] need to be transformed to obtain the parameters that the base R function uses
    S_FP_SoC <- pweibull(
      q     = t, 
      shape = exp(coef_weibull_shape_SoC), 
      scale = exp(coef_weibull_scale_SoC), 
      lower.tail = FALSE
    )
    
    ###### IN THE FUNCTION WE ARE USING WEIBULL, IF IN THE CODE IN MARKOV_3STATE.RMD WE USE SOMETHING OTHER THAN WEIBULL THEN WE WILL HAVE TO UPDATE THIS ACCORDINGLY.
    
    
    # head(cbind(t, S_FP_SoC))
    
    #        t  S_FP_SoC
    # [1,] 0.0 1.0000000
    # [2,] 0.5 0.9948214
    # [3,] 1.0 0.9770661
    # [4,] 1.5 0.9458256
    # [5,] 2.0 0.9015175
    # [6,] 2.5 0.8454597
    
    
    # Having the above header shows that this is probability for surviving in the F->P state, i.e., staying in this state, because you can see in time 0 100% of people are in this state, meaning 100% of people hadnt progressed and were in PFS, if this was instead about the progressed state (i.e. OS), there should be no-one in this state when the model starts, as everyone starts in the PFS state, and it takes a while for people to reach the OS state.
    
    
    
    
    
    # I want to vary my probabilities for the one-way sensitivity analysis, particularly for the tornado       plot of the deterministic sensitivity analysis. 
    
    # The problem here is that df_params_OWSA doesnt like the fact that a different probability for each       cycle (from the time-dependent transition probabilities) gives 122 rows (because there are 60 cycles,      two treatment strategies and a probability for each cycle). It wants the same number of       rows as      there are probabilities, i.e., it would prefer a probability of say 0.50 and then a max and a      min     around that.
    
    # To address this, I think I can apply this mean, max and min to the hazard ratios instead, knowing        that when run_owsa_det is run in the sensitivity analysis it calls this function to run and in this        function the hazard ratios generate the survivor function, and then these survivor functions are used      to generate the probabilities (which will be cycle dependent).
    
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
    
    
    # 3) Obtaining the event-free (i.e. survival) probabilities for the cycle times for Experimental treatment (aka the novel therapy) based on a hazard ratio.
    # So here we basically have a hazard ratio for the novel therapy that says you do X much better under the novel therapy than under standard of care, and we want to apply it to standard of care from our individual patient data to see how much improved things would be under the novel therapy.
    # (NB - if we ultimately decide not to use a hazard ratio, I could probably just create my transition probabilities for the experimental therapy from individual patient data that I have digitised from patients under this novel therapy).
    # Here our hazard ratio is 0.6, I can change that for our hazard ratio.
    # - note that S(t) = exp(-H(t)) and, hence, H(t) = -ln(S(t))
    # that is, the survival function is the expoential of the negative hazard function, per:
    # https://faculty.washington.edu/yenchic/18W_425/Lec5_survival.pdf
    # and: 
    # https://web.stanford.edu/~lutian/coursepdf/unit1.pdf
    # Also saved here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\R Code\Parametric Survival Analysis\flexsurv
    # And to multiply by the hazard ratio it's necessary to convert the survivor function into the hazard function, multiply by the hazard ratio, and then convert back to the survivor function, and then these survivor functions are used for the probabilities.     
    
    
    
    #    * ======================================================================================
    
    
    # So here we basically have a hazard ratio that is equal to 1, so it leaves things unchanged for           patients, and we want to apply it to standard of care from our individual patient data to leave things     unchanged in this function, but allow things to change in the sensitivity analysis.
    
    # Here our hazard ratio is 1, things are unchanged.
    
    # - note that S(t) = exp(-H(t)) and, hence, H(t) = -ln(S(t))
    # that is, the survival function is the expoential of the negative hazard function, per:
    # https://faculty.washington.edu/yenchic/18W_425/Lec5_survival.pdf
    # and: 
    # https://web.stanford.edu/~lutian/coursepdf/unit1.pdf
    # Also saved here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\R Code\Parametric Survival Analysis\flexsurv
    # And to multiply by the hazard ratio it's necessary to convert the survivor function into the hazard      function, multiply by the hazard ratio, and then convert back to the survivor function, and then these     survivor functions are used for the probabilities.
    
    head(cbind(t, S_FP_SoC, H_FP_SoC))
    # Then, we create our hazard function for SoC:
    XNU_S_FP_SoC <- S_FP_SoC
    XNU_H_FP_SoC  <- -log(XNU_S_FP_SoC)
    # Then, we multiply this hazard function by our hazard ratio, which is just 1, but which gives us the      opportunity to apply a hazard ratio to standard of care in our code and thus to have a hazard ratio for     standard of care for our one way deterministic sensitivity analysis and tornado diagram.
    XNUnu_H_FP_SoC  <- XNU_H_FP_SoC * HR_FP_SoC
    # 
    XNU_S_FP_SoC  <- exp(-XNUnu_H_FP_SoC)
    
    head(cbind(t, XNU_S_FP_SoC, XNUnu_H_FP_SoC))
    
    
    # I compare the header now, to the header earlier. They should be identical, because all this code does     is add the space for a hazard ratio, it doesnt actually do anything other than convert from a survivor     function to a hazard function, multiply by a hazard ratio equal to one, and then convert back to a         survivor function, just so we can include a hazard ratio for standard of care in our sensitivity           analysis. 
    
    
    # Then, the above survival function is used to generate transition probabilities below, which is the       genius of applying the hazard ratio to the sensitivity analysis, it can have a singular mean with a        static min and max, but applying it how we apply it above allows it to still produce cycle-specific        transition probabilities.
    
    #    * ======================================================================================
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
   
    
    
    # I create S_FP_Exp (below) after the code above for SoC in my function, and with XNU_S_FP_SoC in the place of S_FP_SoC, because XNU_S_FP_SoC is S_FP_SoC post multiplication by the SoC hazard ratio. In the OWSA everything but the one thing being varied is held at it's basecase values, so if I am considering changes in HR_FP_Exp for the OWSA the hazard ratio for SoC won't be changing by 20% and thus effecting the S_FP_Exp created by multiplying the exp hazard ratio by the SoC rates because it will be kept at it's base values. However, for the hazard ratio adjustments for SoC and Exp to have a logical covariance in the TWSA, one needs to be drawing from the other so that I can say they are related because the hazard ratio for the experimental strategy is multiplied by the rate of events under soc, and that's not the case if I use S_FP_SoC rather than XNU_S_FP_SoC because they won't be changing together as S_FP_SoC isnt multiplied by the hazard ratio, XNU_S_FP_SoC is, so the rate of events under S_FP_SoC aren't changing. Also, if I don't have this piece of code second, then I apply the exp hazard ratio to the XNU_S_FP_SoC before the XNU_S_FP_SoC has been varied by the SoC hazard ratio and thus they are again not moving together. [Although now that I'm using XNU_S_FP_SoC putting this piece of code first wouldnt work anyway, because XNU_S_FP_SoC would need to be generated first, unlike S_FP_SoC which is generated straight away in this function.]
    
    # it's OK that they are varied at the same time and made from eachother, because if we were changing a rate and a hazard ratio as below, they would be changing at the same time also the hazard ratio would be made from the rate too:
    
    # [[A 2-way uncertainty analysis will be more useful if informed by the covariance between the 2 parameters of interest or on the logical relationship between them (e.g., a 2-way uncertainty analysis might be represented by the control intervention event rate and the hazard ratio with the new treatment). file:///C:/Users/Jonathan/OneDrive%20-%20Royal%20College%20of%20Surgeons%20in%20Ireland/COLOSSUS/Briggs%20et%20al%202012%20model%20parameter%20estimation%20and%20uncertainty.pdf]]
    
    # The fact that he says the logical relationship between the two parameters makes me think I should include XNU_S_FP_SoC because S_FP_SoC won't change with the experimental strategy and thus there won't be a relationship between the two. In a two way sensitivity analysis, I'm supposed to be changing both parameters at the same time, but, if I have this block first, and don't include XNU_S_FP_SoC then the underlying rate isnt changing at the same time as the experimental hazard ratio (because the SoC hazard ratio which I alter in the TWSA only exists to alter this underlying rate and subsequently probabilities under SoC). So, we wouldnt be changing the event rate in the control that the hazard ratio is applied to, so there wouldnt be a covarying movement between the two parameters.
    
    # If I apply the hazard ratio to the rate after it has changed then they will be covarying, because when the rate goes down by 20% the hazard ratio will create a new experimental treatment rate that is a hazard ratio by a SoC rate that is 20% lower, and when the rate goes up by 20%, the hazard ratio will create a new experimental treatment rate that is a hazard ratio by an SoC rate that is 20% higher. So, the hazard ratio will move down when the rate moves down, and the hazard ratio will move up when the rate goes up - because it is created after the rate has changed.
    
# That's the whole point of the hazard ratio, it's supposed to be making one thing higher or lower than the other, and if I don't apply it as above, then if I do a TWSA the difference between treatment strategies will be more muted.
    
# i.e., if I say in the TWSA, oh the actual event rate under SoC is 5% less than I thought it was, then by not applying the hazard ratio to this updated 5% lower event rate I am not applying hazard ratios as they are meant to be applied, i.e. to the basecase number of events:
    
# i.e, for a hazard ratio that is 10% lower:
    
    # SoC: 5% 40 = 2 = 40 - 2 = 38 -> so we are wondering if there are 5% less events than we originally thought how that would change things, so 38 instead of the original 40.
    # Exp: 10% of 40 = 4 = 40 - 4 = 36 -> This is the hazard ratio being applied to SoC pre-changes to what event rates under SoC could be, so the difference between SoC and Exp is two events.
    # Exp: 10% of 38 = 3.8 = 38 - 3.8 = 34.2 -> The difference between Exp and SoC treatment strategies is now 3.8 events, if we apply the experimental hazard ratio after we've adjusted SoC's event rates to what they could be in our SA.
    # So, if we want to maintain a hazard ratio that is at all times X percent higher or lower than standard of care for our TWSA where they are both being changed together (i.e., in TWSA they step through from min value we gave to the max value we gave in order and at the same time together), then we need to make the event rate under the Exp from the event rate under the adjusted SoC events.
    # And even if we are moving both the SoC and Exp events down by X% in the sensitivity analysis we should still be able to maintain that 10% difference because they should both be X% lower at the start together (because TWSA moves both at the same time and in order while holding everything else constant) which will still maintain a 10% difference, particularly in our situation where we will be changing rates in SoC by changing a hazard ratio which is 1 +/- a certain amount (i.e., baseline hazard ratio +/- a certain %) and in Exp we will also be changing rates by a hazard ratio +/- a certain percent, and because we are changing both by 20% in our paper - which will maintain the inherent difference between SoC and hazard ratio Exp.
    
    # In the probabilistic sensitivity analysis where we are picking randomly from the range around the parameters the event rate under the Exp will always be some percent lower than under the SoC, provided it's applied to the SoC that has the sensitivity analysis applied to it. If, however, it is applied to the SoC without the sensitivity analysis applied to it, it means that we are applying percentage changes to just a random number that is pretty static, so, the Exp event rate could be higher than the SoC event rate if the SoC from the sensitivity analysis is 20% lower than the static number and the Exp from the sensitivity analysis is 20% higher than this static number. If, however, we apply the Exp to the SoC after the sensitivity analysis, no matter how much the SoC varies under the sensitivity analysis, the Exp will always be a percentage of that, so will always be lower as it is meant to be, i.e, it's supposed to be that the experimental treatment is better for your health - and taking Exp as a percentage of SoC means that it will always give you less of the bad health events, no matter how we vary the bad health events. 
    
    
    H_FP_SoC  <- -log(XNU_S_FP_SoC)
    H_FP_Exp  <- H_FP_SoC * HR_FP_Exp
    S_FP_Exp  <- exp(-H_FP_Exp)
    
    
    # head(cbind(t, S_FP_SoC, H_FP_SoC, H_FP_Exp, S_FP_Exp))

# The question is, for the probabilistic model where things other than the parameter we are interested in varying arent being held constant and we'll be varying all the parameters all at once, does it make sense to have two things that vary when they are combined to make another parameter? Or is that doubling up in the varying and does it mess things up?
    
# Well, in oncologySemiMarkov_illustration in the ISPOR demonstration (C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\R Code\Parametric Survival Analysis\ISPOR WEBINAR Health Economic Modelling in R), both m_coef_weibull_SoC and HR_FP_Exp have values taken randomly from their distributions as below:
    
    # m_coef_weibull_SoC <- mvrnorm(
    #   n     = n_runs, 
    #   mu    = l_TTP_SoC_weibull$coefficients, 
    #   Sigma = l_TTP_SoC_weibull$cov
    # )
    # 
    # head(m_coef_weibull_SoC)
    # 
    # df_PA_input <- data.frame(
    #   coef_weibull_shape_SoC = m_coef_weibull_SoC[ , "shape"],
    #   coef_weibull_scale_SoC = m_coef_weibull_SoC[ , "scale"],
    #   HR_FP_Exp = exp(rnorm(n_runs, log(0.6), 0.08)),
    #   p_FD      = rbeta(n_runs, shape1 = 16, shape2 = 767),
    #   P_OSD_SoC      = rbeta(n_runs, shape1 = 22.4, shape2 = 201.6),
    #   c_F_SoC   = rgamma(n_runs, shape = 16, scale = 25), 
    #   c_F_Exp   = rgamma(n_runs, shape = 16, scale = 50), 
    #   c_P       = rgamma(n_runs, shape = 100, scale = 10), 
    #   c_D       = 0, 
    #   u_F       = rbeta(n_runs, shape1 =  50.4, shape2 = 12.6), 
    #   u_P       = rbeta(n_runs, shape1 = 49.5, shape2 = 49.5), 
    #   u_D       = 0,
    #   d_c       = 0.03,
    #   d_e       = 0.03,
    #   n_cycle   = 60,
    #   t_cycle   = 0.25
    # )
    
# And then the S_FP_SoC is created from m_coef_weibull_SoC and H_FP_Exp is created from this S_FP_SoC multiplied by the similarly varied HR_FP_Exp and this H_FP_Exp is used to create p_PFSOS_Exp. So, two things that were varied were used to create p_PFSOS_Exp which is used in our cost-effectiveness Markov model, so it must be OK to have two things draw randomly from their distributions, even when they are combined to create something else.
    
    #   t <- seq(from = 0, by = t_cycle, length.out = n_cycle + 1)
    #   S_FP_SoC <- pweibull(
    #     q     = t, 
    #     shape = exp(coef_weibull_shape_SoC), 
    #     scale = exp(coef_weibull_scale_SoC), 
    #     lower.tail = FALSE
    #   )
    #   H_FP_SoC  <- -log(S_FP_SoC)
    #   H_FP_Exp  <- H_FP_SoC * HR_FP_Exp
    #   S_FP_Exp  <- exp(-H_FP_Exp)
    #   p_PFSOS_SoC <- p_PFSOS_Exp <- rep(NA, n_cycle)
    #   for(i in 1:n_cycle) {
    #     p_PFSOS_SoC[i] <- 1 - S_FP_SoC[i+1] / S_FP_SoC[i]
    #     p_PFSOS_Exp[i] <- 1 - S_FP_Exp[i+1] / S_FP_Exp[i]
    #   }    
    # 
        

    # This is also supported by: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Health Economic Modeling in R A Hands-on Introduction\Health-Eco\Markov models\markov_smoking_probabilistic where two probabilistically generated vectors of parameters drawn from distributions are multiplied by each other.    
    
    
    

    # 4) Obtaining the time-dependent transition probabilities from the event-free (i.e. survival) probabilities
    
    # Now we can take the probability of being in the PFS state at each of our cycles, as created above, from 100% (i.e. from 1) in order to get the probability of NOT being in the PFS state, i.e. in order to get the probability of moving into the progressed state, or the OS state.
    
    
    
    p_PFSOS_SoC <- p_PFSOS_Exp <- rep(NA, n_cycle)
    # First we make the probability of going from progression-free (F) to progression (P) blank (i.e. NA) for all the cycles in standard of care and all the cycles under the experimental strategy.
    for(i in 1:n_cycle) {
      p_PFSOS_SoC[i] <- 1 - XNU_S_FP_SoC[i+1] / XNU_S_FP_SoC[i]
      p_PFSOS_Exp[i] <- 1 - S_FP_Exp[i+1] / S_FP_Exp[i]
    }

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
    
    p_PFSOS_SoC
    
    #> p_PFSOS_SoC
    #  [1] 0.005178566 0.017847796 0.031973721 0.046845943 0.062181645
    p_PFSOS_Exp
    
    
    
    
    
    
    # NOW I NEED TO REPEAT THE ABOVE, BUT THIS TIME FOR OS TO DEATH.
    
    # There are a few options for coding in OS to DEATH. 
    
    # I decide the best approach is probably to have a deterministic transition probability, because if I didnt I would need to have a large number of tunnel states, as we won't know how long the individual is in the OS state before they transition to the dead state, so parametric survival analysis won't work as well for them as for someone in the initial PFS state.
    
    
    # THEN I REALISED, THIS ISNT OS TO DEAD. THIS IS PFS TO THE DEAD STATE, SO FIRST LINE THERAPY TO THE DEAD STATE. SO I CHANGED MY APPROACH AS BELOW:
    
    
    # REALISE HERE THEAT P_OSD_SoC ISNT THE PROBABILITY OF PROGRESSION TO DEAD, BUT OF PFS TO DEAD, OF FIRST LINE TO DEAD, BECAUSE OUR APD CURVES ONLY EVER DESCRIBE FIRST LINE TREATMENT, BE THAT FIRST LINE SOC TREATMENT OR FIRST LINE EXP TREATMENT.
    
    
    
    # To make sure that my PFS probabilities only reflect going from PFS to progression, I create the probability of going from PFS to DEAD under standard of care and the experimental, and decrease my PFS to progression probability by the probability of going into the dead state, such that I am only capturing people going into progression, and not people going into death as well. 
    
    
    
    
    
    # 1) Defining the cycle times    
    t <- seq(from = 0, by = t_cycle, length.out = n_cycle + 1)
    
    # I think here we're saying, at each cycle how many of the time periods our individual patient data is measured at have passed? Here our individual patient data is in months, so we have 0 in cycle 0, 0.5 or half a month in cycle 1, and so on.
    
    # Having established that allows us to obtain the transition probabilities for the time we are interested in for our cycles from this longer period individual patient data, so where the individual patient data is in months and our cycles are in fortnight or half months, this allows us to obtain transition probabilities for these fortnights.
    
    # 2) Obtaining the event-free (i.e. survival) probabilities for the cycle times for SoC
    # S_PD_SoC - survival of progression free to progression, i.e. not going to progression, i.e. staying in progression free.
    # Note that the coefficients [that we took from flexsurvreg earlier] need to be transformed to obtain the parameters that the base R function uses
    S_PD_SoC <- pweibull(
      q     = t, 
      shape = exp(coef_TTD_weibull_shape_SoC), 
      scale = exp(coef_TTD_weibull_scale_SoC), 
      lower.tail = FALSE
    )
    
    
    ###### IN THE FUNCTION WE ARE USING WEIBULL, IF IN THE CODE IN MARKOV_3STATE.RMD WE USE SOMETHING OTHER THAN WEIBULL THEN WE WILL HAVE TO UPDATE THIS ACCORDINGLY.
    
    
    # head(cbind(t, S_PD_SoC))
    
    #        t  S_PD_SoC
    # [1,] 0.0 1.0000000
    # [2,] 0.5 0.9948214
    # [3,] 1.0 0.9770661
    # [4,] 1.5 0.9458256
    # [5,] 2.0 0.9015175
    # [6,] 2.5 0.8454597
    
    
    # Having the above header shows that this is probability for surviving in the PFS->DEAD state, i.e., staying in this state, because you can see in time 0 100% of people are in this state, meaning 100% of people hadnt gone to the dead state and were in PFS, if this was instead about the progressed state (i.e. OS), there should be no-one in this state when the model starts, as everyone starts in the PFS state, and it takes a while for people to reach the OS state.
    
    
    
    
    
    # I want to vary my probabilities for the one-way sensitivity analysis, particularly for the tornado       plot of the deterministic sensitivity analysis. 
    
    # The problem here is that df_params_OWSA doesnt like the fact that a different probability for each       cycle (from the time-dependent transition probabilities) gives 122 rows (because there are 60 cycles,      two treatment strategies and a probability for each cycle). It wants the same number of       rows as      there are probabilities, i.e., it would prefer a probability of say 0.50 and then a max and a      min     around that.
    
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
    
    
    # 3) Obtaining the event-free (i.e. survival) probabilities for the cycle times for Experimental treatment (aka the novel therapy) based on a hazard ratio.
    # So here we basically have a hazard ratio for the novel therapy that says you do X much better under the novel therapy than under standard of care, and we want to apply it to standard of care from our individual patient data to see how much improved things would be under the novel therapy.
    # (NB - if we ultimately decide not to use a hazard ratio, I could probably just create my transition probabilities for the experimental therapy from individual patient data that I have digitised from patients under this novel therapy).
    # Here our hazard ratio is 0.6, I can change that for our hazard ratio.
    # - note that S(t) = exp(-H(t)) and, hence, H(t) = -ln(S(t))
    # that is, the survival function is the expoential of the negative hazard function, per:
    # https://faculty.washington.edu/yenchic/18W_425/Lec5_survival.pdf
    # and: 
    # https://web.stanford.edu/~lutian/coursepdf/unit1.pdf
    # Also saved here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\R Code\Parametric Survival Analysis\flexsurv
    # And to multiply by the hazard ratio it's necessary to convert the survivor function into the hazard function, multiply by the hazard ratio, and then convert back to the survivor function, and then these survivor functions are used for the probabilities.     
    
    
    
    #    * ======================================================================================
    
    
    # So here we basically have a hazard ratio that is equal to 1, so it leaves things unchanged for           patients, and we want to apply it to standard of care from our individual patient data to leave things     unchanged in this function, but allow things to change in the sensitivity analysis.
    
    # Here our hazard ratio is 1, things are unchanged.
    
    # - note that S(t) = exp(-H(t)) and, hence, H(t) = -ln(S(t))
    # that is, the survival function is the expoential of the negative hazard function, per:
    # https://faculty.washington.edu/yenchic/18W_425/Lec5_survival.pdf
    # and: 
    # https://web.stanford.edu/~lutian/coursepdf/unit1.pdf
    # Also saved here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\R Code\Parametric Survival Analysis\flexsurv
    # And to multiply by the hazard ratio it's necessary to convert the survivor function into the hazard      function, multiply by the hazard ratio, and then convert back to the survivor function, and then these     survivor functions are used for the probabilities.
    
    head(cbind(t, S_PD_SoC, H_PD_SoC))
    # Then, we create our hazard function for SoC:
    XNU_S_PD_SoC <- S_PD_SoC
    XNU_H_PD_SoC  <- -log(XNU_S_PD_SoC)
    # Then, we multiply this hazard function by our hazard ratio, which is just 1, but which gives us the      opportunity to apply a hazard ratio to standard of care in our code and thus to have a hazard ratio for     standard of care for our one way deterministic sensitivity analysis and tornado diagram.
    XNUnu_H_PD_SoC  <- XNU_H_PD_SoC * HR_PD_SoC
    # 
    XNU_S_PD_SoC  <- exp(-XNUnu_H_PD_SoC)
    
    head(cbind(t, XNU_S_PD_SoC, XNUnu_H_PD_SoC))
    
    
    # I compare the header now, to the header earlier. They should be identical, because all this code does     is add the space for a hazard ratio, it doesnt actually do anything other than convert from a survivor     function to a hazard function, multiply by a hazard ratio equal to one, and then convert back to a         survivor function, just so we can include a hazard ratio for standard of care in our sensitivity           analysis. 
    
    
    # Then, the above survival function is used to generate transition probabilities below, which is the       genius of applying the hazard ratio to the sensitivity analysis, it can have a singular mean with a        static min and max, but applying it how we apply it above allows it to still produce cycle-specific        transition probabilities.
    
    #    * ======================================================================================
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    # I create S_PD_Exp (below) after the code above for SoC in my function, and with XNU_S_PD_SoC in the place of S_PD_SoC, because XNU_S_PD_SoC is S_PD_SoC post multiplication by the SoC hazard ratio. In the OWSA everything but the one thing being varied is held at it's basecase values, so if I am considering changes in HR_PD_Exp for the OWSA the hazard ratio for SoC won't be changing by 20% and thus effecting the S_PD_Exp created by multiplying the exp hazard ratio by the SoC rates because it will be kept at it's base values. However, for the hazard ratio adjustments for SoC and Exp to have a logical covariance in the TWSA, one needs to be drawing from the other so that I can say they are related because the hazard ratio for the experimental strategy is multiplied by the rate of events under soc, and that's not the case if I use S_PD_SoC rather than XNU_S_PD_SoC because they won't be changing together as S_PD_SoC isnt multiplied by the hazard ratio, XNU_S_PD_SoC is, so the rate of events under S_PD_SoC aren't changing. Also, if I don't have this piece of code second, then I apply the exp hazard ratio to the XNU_S_PD_SoC before the XNU_S_PD_SoC has been varied by the SoC hazard ratio and thus they are again not moving together. [Although now that I'm using XNU_S_PD_SoC putting this piece of code first wouldnt work anyway, because XNU_S_PD_SoC would need to be generated first, unlike S_PD_SoC which is generated straight away in this function.]
    
    # it's OK that they are varied at the same time and made from eachother, because if we were changing a rate and a hazard ratio as below, they would be changing at the same time also the hazard ratio would be made from the rate too:
    
    # [[A 2-way uncertainty analysis will be more useful if informed by the covariance between the 2 parameters of interest or on the logical relationship between them (e.g., a 2-way uncertainty analysis might be represented by the control intervention event rate and the hazard ratio with the new treatment). file:///C:/Users/Jonathan/OneDrive%20-%20Royal%20College%20of%20Surgeons%20in%20Ireland/COLOSSUS/Briggs%20et%20al%202012%20model%20parameter%20estimation%20and%20uncertainty.pdf]]
    
    # The fact that he says the logical relationship between the two parameters makes me think I should include XNU_S_PD_SoC because S_PD_SoC won't change with the experimental strategy and thus there won't be a relationship between the two. In a two way sensitivity analysis, I'm supposed to be changing both parameters at the same time, but, if I have this block first, and don't include XNU_S_PD_SoC then the underlying rate isnt changing at the same time as the experimental hazard ratio (because the SoC hazard ratio which I alter in the TWSA only exists to alter this underlying rate and subsequently probabilities under SoC). So, we wouldnt be changing the event rate in the control that the hazard ratio is applied to, so there wouldnt be a covarying movement between the two parameters.
    
    # If I apply the hazard ratio to the rate after it has changed then they will be covarying, because when the rate goes down by 20% the hazard ratio will create a new experimental treatment rate that is a hazard ratio by a SoC rate that is 20% lower, and when the rate goes up by 20%, the hazard ratio will create a new experimental treatment rate that is a hazard ratio by an SoC rate that is 20% higher. So, the hazard ratio will move down when the rate moves down, and the hazard ratio will move up when the rate goes up - because it is created after the rate has changed.
    
    # That's the whole point of the hazard ratio, it's supposed to be making one thing higher or lower than the other, and if I don't apply it as above, then if I do a TWSA the difference between treatment strategies will be more muted.
    
    # i.e., if I say in the TWSA, oh the actual event rate under SoC is 5% less than I thought it was, then by not applying the hazard ratio to this updated 5% lower event rate I am not applying hazard ratios as they are meant to be applied, i.e. to the basecase number of events:
    
    # i.e, for a hazard ratio that is 10% lower:
    
    # SoC: 5% 40 = 2 = 40 - 2 = 38 -> so we are wondering if there are 5% less events than we originally thought how that would change things, so 38 instead of the original 40.
    # Exp: 10% of 40 = 4 = 40 - 4 = 36 -> This is the hazard ratio being applied to SoC pre-changes to what event rates under SoC could be, so the difference between SoC and Exp is two events.
    # Exp: 10% of 38 = 3.8 = 38 - 3.8 = 34.2 -> The difference between Exp and SoC treatment strategies is now 3.8 events, if we apply the experimental hazard ratio after we've adjusted SoC's event rates to what they could be in our SA.
    # So, if we want to maintain a hazard ratio that is at all times X percent higher or lower than standard of care for our TWSA where they are both being changed together (i.e., in TWSA they step through from min value we gave to the max value we gave in order and at the same time together), then we need to make the event rate under the Exp from the event rate under the adjusted SoC events.
    # And even if we are moving both the SoC and Exp events down by X% in the sensitivity analysis we should still be able to maintain that 10% difference because they should both be X% lower at the start together (because TWSA moves both at the same time and in order while holding everything else constant) which will still maintain a 10% difference, particularly in our situation where we will be changing rates in SoC by changing a hazard ratio which is 1 +/- a certain amount (i.e., baseline hazard ratio +/- a certain %) and in Exp we will also be changing rates by a hazard ratio +/- a certain percent, and because we are changing both by 20% in our paper - which will maintain the inherent difference between SoC and hazard ratio Exp.
    
    # In the probabilistic sensitivity analysis where we are picking randomly from the range around the parameters the event rate under the Exp will always be some percent lower than under the SoC, provided it's applied to the SoC that has the sensitivity analysis applied to it. If, however, it is applied to the SoC without the sensitivity analysis applied to it, it means that we are applying percentage changes to just a random number that is pretty static, so, the Exp event rate could be higher than the SoC event rate if the SoC from the sensitivity analysis is 20% lower than the static number and the Exp from the sensitivity analysis is 20% higher than this static number. If, however, we apply the Exp to the SoC after the sensitivity analysis, no matter how much the SoC varies under the sensitivity analysis, the Exp will always be a percentage of that, so will always be lower as it is meant to be, i.e, it's supposed to be that the experimental treatment is better for your health - and taking Exp as a percentage of SoC means that it will always give you less of the bad health events, no matter how we vary the bad health events. 
    
    
    H_PD_SoC  <- -log(XNU_S_PD_SoC)
    H_PD_Exp  <- H_PD_SoC * HR_PD_Exp
    S_PD_Exp  <- exp(-H_PD_Exp)
    
    
    # head(cbind(t, S_PD_SoC, H_PD_SoC, H_PD_Exp, S_PD_Exp))
    
    # The question is, for the probabilistic model where things other than the parameter we are interested in varying arent being held constant and we'll be varying all the parameters all at once, does it make sense to have two things that vary when they are combined to make another parameter? Or is that doubling up in the varying and does it mess things up?
    
    # Well, in oncologySemiMarkov_illustration in the ISPOR demonstration (C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\R Code\Parametric Survival Analysis\ISPOR WEBINAR Health Economic Modelling in R), both m_coef_weibull_SoC and HR_PD_Exp have values taken randomly from their distributions as below:
    
    # m_coef_weibull_SoC <- mvrnorm(
    #   n     = n_runs, 
    #   mu    = l_TTP_SoC_weibull$coefficients, 
    #   Sigma = l_TTP_SoC_weibull$cov
    # )
    # 
    # head(m_coef_weibull_SoC)
    # 
    # df_PA_input <- data.frame(
    #   coef_weibull_shape_SoC = m_coef_weibull_SoC[ , "shape"],
    #   coef_weibull_scale_SoC = m_coef_weibull_SoC[ , "scale"],
    #   HR_PD_Exp = exp(rnorm(n_runs, log(0.6), 0.08)),
    #   p_FD      = rbeta(n_runs, shape1 = 16, shape2 = 767),
    #   P_OSD_SoC      = rbeta(n_runs, shape1 = 22.4, shape2 = 201.6),
    #   c_F_SoC   = rgamma(n_runs, shape = 16, scale = 25), 
    #   c_F_Exp   = rgamma(n_runs, shape = 16, scale = 50), 
    #   c_P       = rgamma(n_runs, shape = 100, scale = 10), 
    #   c_D       = 0, 
    #   u_F       = rbeta(n_runs, shape1 =  50.4, shape2 = 12.6), 
    #   u_P       = rbeta(n_runs, shape1 = 49.5, shape2 = 49.5), 
    #   u_D       = 0,
    #   d_c       = 0.03,
    #   d_e       = 0.03,
    #   n_cycle   = 60,
    #   t_cycle   = 0.25
    # )
    
    # And then the S_PD_SoC is created from m_coef_weibull_SoC and H_PD_Exp is created from this S_PD_SoC multiplied by the similarly varied HR_PD_Exp and this H_PD_Exp is used to create p_PFSD_Exp. So, two things that were varied were used to create p_PFSD_Exp which is used in our cost-effectiveness Markov model, so it must be OK to have two things draw randomly from their distributions, even when they are combined to create something else.
    
    #   t <- seq(from = 0, by = t_cycle, length.out = n_cycle + 1)
    #   S_PD_SoC <- pweibull(
    #     q     = t, 
    #     shape = exp(coef_weibull_shape_SoC), 
    #     scale = exp(coef_weibull_scale_SoC), 
    #     lower.tail = FALSE
    #   )
    #   H_PD_SoC  <- -log(S_PD_SoC)
    #   H_PD_Exp  <- H_PD_SoC * HR_PD_Exp
    #   S_PD_Exp  <- exp(-H_PD_Exp)
    #   p_PFSD_SoC <- p_PFSD_Exp <- rep(NA, n_cycle)
    #   for(i in 1:n_cycle) {
    #     p_PFSD_SoC[i] <- 1 - S_PD_SoC[i+1] / S_PD_SoC[i]
    #     p_PFSD_Exp[i] <- 1 - S_PD_Exp[i+1] / S_PD_Exp[i]
    #   }    
    # 
    
    
    # This is also supported by: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Health Economic Modeling in R A Hands-on Introduction\Health-Eco\Markov models\markov_smoking_probabilistic where two probabilistically generated vectors of parameters drawn from distributions are multiplied by each other.    
    
    
    
    
    # 4) Obtaining the time-dependent transition probabilities from the event-free (i.e. survival) probabilities
    
    # Now we can take the probability of being in the PFS state at each of our cycles, as created above, from 100% (i.e. from 1) in order to get the probability of NOT being in the PFS state, i.e. in order to get the probability of moving into the progressed state, or the OS state.
    
    
    
    p_PFSD_SoC <- p_PFSD_Exp <- rep(NA, n_cycle)
    # First we make the probability of going from progression-free (F) to progression (P) blank (i.e. NA) for all the cycles in standard of care and all the cycles under the experimental strategy.
    for(i in 1:n_cycle) {
      p_PFSD_SoC[i] <- 1 - XNU_S_PD_SoC[i+1] / XNU_S_PD_SoC[i]
      p_PFSD_Exp[i] <- 1 - S_PD_Exp[i+1] / S_PD_Exp[i]
    }

    # Then we generate our transition probability under standard of care and under the experimental treatement using survival functions that havent and have had the hazard ratio from above applied to them, respectively.
    
    
    # The way this works is the below, you take next cycles probability of staying in this state, divide it by this cycles probability of staying in this state, and take it from 1 to get the probability of leaving this state. 
    
    # > head(cbind(t, S_PD_SoC))
    #        t  S_PD_SoC
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
    
    p_PFSD_SoC
    
    #> p_PFSD_SoC
    #  [1] 0.005178566 0.017847796 0.031973721 0.046845943 0.062181645
    p_PFSD_Exp
    
    
    # Finally, now that I create transition probabilities from treatment to death under SoC and the Exp treatment I can take them from the transition probabilities from treatment to progression for SoC and Exp treatment, because the OS here from Angiopredict is transitioning from the first line treatment to dead, not from second line treatment to death, and once we get rid of the people who were leaving first line treatment to die in PFS, all we have left is people leaving first line treatment to progress. And then we can keep the first line treatment to death probabilities we've created from the OS curves to capture people who have left first line treatment to transition into death rather than second line treatment.
    
    # p_PFSOS_SoC
    # p_PFSD_SoC
    # p_PFSOS_SoC <- p_PFSOS_SoC - p_PFSD_SoC
    # p_PFSOS_SoC
    # 
    # p_PFSOS_Exp
    # p_PFSD_Exp
    # p_PFSOS_Exp <- p_PFSOS_Exp - p_PFSD_Exp
    # p_PFSOS_Exp
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    v_names_strats <- c("Standard of Care", "Experimental Treatment")         # Store the strategy names
    v_names_states <- c("PFS", "OS", "Dead")   # state names # These are the health states in our model, PFS, Adverse Event 1, Adverse Event 2, Adverse Event 3, OS, Death.
    n_strats       <- length(v_names_strats)                        # number of strategies
    n_states       <- length(v_names_states)                        # number of states # We're just taking the number of health states from the number of names we came up with, i.e. the number of names to reflect the number of health states 
    
    
    # Markov cohort trace matrix ----
    
    # Initialize matrices to store the Markov cohort traces for each strategy
    
    # - note that the number of rows is n_cycle + 1, because R doesn't use index 0 (i.e. cycle 0)  --> What we mean here, is that when we do our calculations later they need to be for cycle-1 to reflect cycle 0.
    
    
    m_M_SoC <- m_M_Exp <- matrix(
      data = NA, 
      nrow = n_cycle,  
      ncol = n_states, 
      dimnames = list(paste('Cycle', 1:n_cycle), v_names_states)
    )
    
    # Specifying the initial state for the cohorts (all patients start in PFS)
    m_M_SoC[1, "PFS"] <- m_M_Exp[1, "PFS"] <- 1
    m_M_SoC[1, "OS"]  <- m_M_Exp[1, "OS"]  <- 0
    m_M_SoC[1, "Dead"]<- m_M_Exp[1, "Dead"]  <- 0
    
    
    # Inspect whether properly defined
    head(m_M_SoC)
    head(m_M_Exp)
    #head(m_M_Exp_trtB)
    
    ## If there were time varying transition probabilities, i.e. the longer you are in the model there are changes in your transition probability into death as you get older, etc., you would build a transition probability array, rather than a transition probability matrix, per: 
    
    # 04.2 of:
    
    # "C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modeling for Public Health_DARTH\5_Nov_29\4_Cohort state-transition models (cSTM) - time-dependent models_material\Markov_3state_time"
    
    # with the 1hour: 02minute mark of: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Cost-Effectiveness and Decision Modeling using R Workshop _ DARTH\August_24\Live Session Recording\Live Session Recording August 24th.mp4
    
    
    ## Initialize transition probability matrix, [i.e. build the framework or empty scaffolding of the transition probability matrix]
    # all transitions to a non-death state are assumed to be conditional on survival
    # - starting with standard of care
    # - note that these are now 3-dimensional matrices because we are including time.
    
    
    # m_P_SoC  <- matrix(0,
    #                    nrow = n_states, ncol = n_states,
    #                    dimnames = list(v_names_states, v_names_states)) # define row and column names
    # m_P_SoC
    
    
    # Initialize matrices for the transition probabilities
    # - note that these are now 3-dimensional matrices (so, above we originally included dim = nrow and ncol, but now we also include n_cycle - i.e. the number of cycles).
    
    # - starting with standard of care
    m_P_SoC <- array(
      data = 0,
      dim  = c(n_states, n_states, n_cycle),
      dimnames = list(v_names_states, v_names_states, paste0("Cycle", 1:n_cycle))
    )
    
    # define row and column names - then name each array after which cycle it's for, i.e. cycle 1 all the way through to cycle 120. So Cycle 1 will have all of our patients in PFS, while cycle 120 will have most people in the dead state.
    
    
    head(m_P_SoC)
    
    
    # Setting the transition probabilities from PFS based on the model parameters
    # So, when individuals are in PFS what are their probabilities of going into the other states that they can enter from PFS?  
    m_P_SoC["PFS", "PFS", ] <- (1 - p_PFSOS_SoC)*(1 - p_PFSD_SoC)
    m_P_SoC["PFS", "OS", ]     <- p_PFSOS_SoC*(1 - p_PFSD_SoC) 
    m_P_SoC["PFS", "Dead", ]            <- p_PFSD_SoC
    
    # Setting the transition probabilities from OS
    
    m_P_SoC["OS", "OS", ] <- 1 - P_OSD_SoC
    m_P_SoC["OS", "Dead", ]        <- P_OSD_SoC
    
    # Setting the transition probabilities from Dead
    m_P_SoC["Dead", "Dead", ] <- 1
    
    # 
    # # Setting the transition probabilities from AE1
    # m_P_SoC["AE1", "PFS", ] <- p_A1F_SoC
    # m_P_SoC["AE1", "Dead", ] <- p_A1D_SoC
    # 
    # # Setting the transition probabilities from AE2
    # m_P_SoC["AE2", "PFS", ] <- p_A2F_SoC
    # m_P_SoC["AE2", "Dead", ] <- p_A2D_SoC
    # 
    # # Setting the transition probabilities from AE3
    # m_P_SoC["AE3", "PFS", ] <- p_A3F_SoC
    # m_P_SoC["AE3", "Dead", ] <- p_A3D_SoC
    # 
    m_P_SoC
    
    # Using the transition probabilities for standard of care as basis, update the transition probabilities that are different for the experimental strategy
    
    # So, you'll see below we copy the matrix of transition probabilities for standard of care over the empty matrix of transition probilities for the experimental treatment, then copy the transition probabilities that are different for the experimental strategy over this:
    
    m_P_Exp <- m_P_SoC
    m_P_Exp["PFS", "PFS", ] <- (1 - p_PFSOS_Exp) * (1 - p_PFSD_Exp)
    m_P_Exp["PFS", "OS", ]     <- p_PFSOS_Exp*(1 - p_PFSD_Exp)
    m_P_Exp["PFS", "Dead", ]            <- p_PFSD_Exp
    
    # Setting the transition probabilities from OS
    m_P_Exp["OS", "OS", ] <- 1 - P_OSD_Exp
    m_P_Exp["OS", "Dead", ]        <- P_OSD_Exp
    
    # Setting the transition probabilities from Dead
    m_P_Exp["Dead", "Dead", ] <- 1
    
    
    
    # If I decided the following was different under the experimental strategy I would have to code these in also:
    # 
    # m_P_Exp["PFS", "AE1", ]     <- 
    # m_P_Exp["PFS", "AE2", ]     <- 
    # m_P_Exp["PFS", "AE3", ]     <- 
    # m_P_Exp["PFS", "Dead", ]            <- 
    # 
    
    # Setting the transition probabilities from AE1
    # m_P_Exp["AE1", "PFS", ] <- 
    # m_P_Exp["AE1", "Dead", ] <- 
    # 
    # # Setting the transition probabilities from AE2
    # m_P_Exp["AE2", "PFS", ] <- 
    # m_P_Exp["AE2", "Dead", ] <- 
    # 
    # # Setting the transition probabilities from AE3
    # m_P_Exp["AE3", "PFS", ] <- 
    # m_P_Exp["AE3", "Dead", ] <- 
    
    
    # If I decided to use parametric survival analysis to generate probabilistic transition probabilities from progressed to death after all then I would have to do the following:
    
    # Setting the transition probabilities from OS
    #    m_P_Exp["OS", "OS", ] <-  
    #    m_P_Exp["OS", "Dead", ]        <- 
    
    m_P_Exp
    
    # I need to remove the comments when I've fixed the issue where probabilities don't sum to 1.
    
    
    #     check_transition_probability(m_P_SoC, verbose = TRUE)
    #    check_transition_probability(m_P_Exp, verbose = TRUE)
    
    #    check_sum_of_transition_array(m_P_SoC, n_states = n_states, n_cycles = n_cycle, verbose = TRUE)
    #    check_sum_of_transition_array(m_P_Exp, n_states = n_states, n_cycles = n_cycle, verbose = TRUE)
    
    # So here I once again create the Markov cohort trace by looping over all cycles
    # - note that the trace can easily be obtained using matrix multiplications
    # - note that now the right probabilities for the cycle need to be selected, like I explained in Markov_3state.Rmd.    
    
    for(i_cycle in 1:(n_cycle-1)) {
      m_M_SoC[i_cycle + 1, ] <- m_M_SoC[i_cycle, ] %*% m_P_SoC[ , , i_cycle]
      m_M_Exp[i_cycle + 1, ] <- m_M_Exp[i_cycle, ] %*% m_P_Exp[ , , i_cycle]
    }
    
    
    # I have to include the generation of utility in this function to ensure that when I change the utility value in PFS and the disutility of the various adverse events in the code for the sensitivity analysis, that these value will change here also to ensure that my analysis results will change for these values in the sensitivity analysis:
    
    
    daily_utility <- u_F/14
    AE1_discounted_daily_utility <- daily_utility * (1-AE1_DisUtil)
    AE2_discounted_daily_utility <- daily_utility * (1-AE2_DisUtil)
    AE3_discounted_daily_utility <- daily_utility * (1-AE3_DisUtil)
    
    
    u_AE1 <- (AE1_discounted_daily_utility*7) + (daily_utility*7)
    u_AE2 <- (AE2_discounted_daily_utility*7) + (daily_utility*7)
    u_AE3 <- (AE3_discounted_daily_utility*7) + (daily_utility*7)
    
    
    # I then adjust my state costs and utilities:
    
    # uState<-uState-pAE1*duAE1
    
    u_F_SoC<-u_F
    u_F_Exp<-u_F
    
    
    u_F_SoC<-u_F-p_FA1_STD*u_AE1 -p_FA2_STD*u_AE2 -p_FA3_STD*u_AE3
    u_F_Exp<-u_F-p_FA1_EXPR*u_AE1 -p_FA2_EXPR*u_AE2 -p_FA3_EXPR*u_AE3
    
    c_F_SoC       <- administration_cost + c_PFS_Folfox  # cost of one cycle in PFS state under standard of care
    c_F_Exp       <- administration_cost + c_PFS_Folfox + c_PFS_Bevacizumab # cost of one cycle in PFS state under the experimental treatment 
     c_P       <- c_OS_Folfiri  + administration_cost# cost of one cycle in progression state (I assume in OS everyone gets the same treatment so it costs everyone the same to be treated).

    
    c_F_SoC<-c_F_SoC +p_FA1_STD*c_AE1 +p_FA2_STD*c_AE2 +p_FA3_STD*c_AE3
    c_F_Exp<-c_F_Exp +p_FA1_EXPR*c_AE1 +p_FA2_EXPR*c_AE2 +p_FA3_EXPR*c_AE3
    
    
   # Calculate the costs and QALYs per cycle by multiplying m_M (the Markov trace) with the cost/utility           vectors for the different states
    
    v_tc_SoC <- m_M_SoC %*% c(c_F_SoC, c_P, c_D)
    v_tc_Exp <- m_M_Exp %*% c(c_F_Exp, c_P, c_D)
    
    v_tc_SoC
    v_tc_Exp
    
    v_tc_Exp["Cycle 1", ] <- v_tc_Exp["Cycle 1", ] + subtyping_test_cost
    
    # I add the subtyping cost as above.
    
    v_tc_Exp
    
    v_tu_SoC <- m_M_SoC %*% c(u_F_SoC, u_P, u_D)
    v_tu_Exp <- m_M_Exp %*% c(u_F_Exp, u_P, u_D)
    
    
    v_tu_SoC
    v_tu_Exp    
    
    # BUT, we need to remember that the above displays the amount of utilitie's gathered in each cycle.
    
    sum(v_tu_SoC)
    sum(v_tu_Exp)
    
    # Particularly, these are quality adjusted cycles, these are quality adjusted life years where cycles are annual, so I need to consider what this means for utility where cycles are monthly, or fortnightly.
    
    # When I calculate the QALYs above, I don’t convert these quality adjusted cycles to years. If I sum each of v_tu_SoC and v_tu_Exp I get 16.7 quality adjusted cycles in the SoC arm and 21.1 quality adjusted cycles in the Exp arm. I can convert these quality adjusted cycles to years for fortnights by working out how many fortnights there are in a year (26.0714) and then divide by this number. These correspond to 0.64 and 0.81 QALYs respectively so 0.17 QALYs gained.
    
    v_tu_SoC <- v_tu_SoC/26.0714
    v_tu_Exp <- v_tu_Exp/26.0714
    
    # So, these are per-cycle utility values, but, our cycles aren't years, they are fortnights, so these are per fortnight values, if we want this value to reflect the per year value, so that we have a quality adjusted life year, or QALY, then we need to adjust this utility value by how many of these fortnights there are in a year (26.0714), that is divide by how many fortnights there are in a year to bring the per fortnight value to a per year value
    
    
    # James, I'd like your thoughts on what I've done here and whether this seems reasonable.
    
    
    sum(v_tu_SoC)
    sum(v_tu_Exp)
    
    # I've already updated the discount rate in the main file as below, so I don't do this again or I would be dividing something I had divided by 365 by 365 again:
    
    # d_c <- d_c/365
    # d_e <- d_e/365
    
    
    
    
    
    
    
    
    
    
    
    # Finally, we'll aggregate these costs and utilities into overall discounted mean (average) costs and           utilities.
    
    # Obtain the discounted costs and QALYs by multiplying the vectors of total cost and total utility we           created above by the discount rate for each cycle:
    
    # - note first the discount rate for each cycle needs to be defined accounting for the cycle length, as         below:
    
    v_dwc <- 1 / ((1 + d_c) ^ ((0:(n_cycle-1)) * t_cycle)) 
    v_dwe <- 1 / ((1 + d_e) ^ ((0:(n_cycle-1)) * t_cycle))
    
    # Discount costs by multiplying the cost vector with discount weights (v_dwc) 
    
    tc_d_SoC <-  t(v_tc_SoC) %*% v_dwc 
    tc_d_Exp <-  t(v_tc_Exp) %*% v_dwc
    
    # Discount QALYS by multiplying the QALYs vector with discount weights (v_dwe) [probably utilities would be     a better term here, as it's monthly health state quality of life, rather than yearly health state quality of     life]
    
    tu_d_SoC <-  t(v_tu_SoC) %*% v_dwe
    tu_d_Exp <-  t(v_tu_Exp) %*% v_dwe
    
    # Store them into a vector -> So, we'll take the single values for cost for an average person under standard     of care and the experimental treatment and store them in a vector v_tc_d:
    
    v_tc_d    <- c(tc_d_SoC, tc_d_Exp)
    v_tu_d    <- c(tu_d_SoC, tu_d_Exp)
    
    v_tc_d
    v_tu_d
    
    v_nmb_d   <- v_tu_d * n_wtp - v_tc_d
    
    # Here we create the net monetary benefit as the utilities times the willingness to pay minus the costs.
    
    
    (df_DSAcea <- calculate_icers(cost       = c(tc_d_SoC, tc_d_Exp),
                                   effect     = c(tu_d_SoC, tu_d_Exp),
                                   strategies = v_names_strats))
    df_DSAcea
     
    DSA_ICER    <- c(df_DSAcea[2,6])
    
    # I'm picking the row and column where the ICER value appears in the df_DSAcea dataframe created by calculate_icers.
    

    df_ce <- data.frame(Strategy = v_names_strats,
                        Cost     = v_tc_d,
                        Effect   = v_tu_d,
                        DSAICER  = DSA_ICER)

   return(df_ce)
#    return(c(v_names_strats, DSA_ICER))
  
    # I'm not using NMB so I remove this from the above dataframe and put the DSAICER in it's spot
    
    # ,
    # NMB      = v_nmb_d)    

    # Previously where DSAICER was, there was the above.
    
        
#   If I was creating an ICER tornado plot I would add the below to the df_ce above:  
#    DSAICER  = DSA_ICER,
    
    # Generate the ouput
    # return(c(v_names_strats, v_tc_d, v_tu_d, DSA_ICER))
    
  })
  
}