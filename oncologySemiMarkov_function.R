# This script is used in the Markov_3state.R script to define the function that evaluates the three-state semi-Markov model for a specific set of parameter values.

# This "function" is basically just repeating the code from the Markov_3state.R script again.

oncologySemiMarkov <- function(l_params_all, n_wtp = 10000) {
  
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
    
    
    H_FP_SoC  <- -log(S_FP_SoC)
    H_FP_Exp  <- H_FP_SoC * HR_FP_Exp
    S_FP_Exp  <- exp(-H_FP_Exp)
  

    # head(cbind(t, S_FP_SoC, H_FP_SoC, H_FP_Exp, S_FP_Exp))
    
    
    
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

    # 4) Obtaining the time-dependent transition probabilities from the event-free (i.e. survival) probabilities
    
    # Now we can take the probability of being in the PFS state at each of our cycles, as created above, from 100% (i.e. from 1) in order to get the probability of NOT being in the PFS state, i.e. in order to get the probability of moving into the progressed state, or the OS state.
    
    
    
        
    p_FP_SoC <- p_FP_Exp <- rep(NA, n_cycle)
    # First we make the probability of going from progression-free (F) to progression (P) blank (i.e. NA) for all the cycles in standard of care and all the cycles under the experimental strategy.
    for(i in 1:n_cycle) {
      p_FP_SoC[i] <- 1 - XNU_S_FP_SoC[i+1] / XNU_S_FP_SoC[i]
      p_FP_Exp[i] <- 1 - S_FP_Exp[i+1] / S_FP_Exp[i]
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
    
    p_FP_SoC
    
    #> p_FP_SoC
    #  [1] 0.005178566 0.017847796 0.031973721 0.046845943 0.062181645
    p_FP_Exp
    
    
    
    
    
    
    # NOW I NEED TO REPEAT THE ABOVE, BUT THIS TIME FOR OS TO DEATH.
    
    # There are a few options for coding in OS to DEATH. 
    
    # I decide the best approach is probably to have a deterministic transition probability, because if I didnt I would need to have a large number of tunnel states, as we won't know how long the individual is in the OS state before they transition to the dead state, so parametric survival analysis won't work as well for them as for someone in the initial PFS state.
    
    
    
    
    # TRANSITION PROBABILITIES: Time-To-Dead TTD
    
    
    # Time-dependent transition probabilities are obtained in four steps
    # 1) Defining the cycle times [we already did this above]
    # 2) Obtaining the event-free (i.e. overall survival) probabilities for the cycle times for SoC
    # 3) Obtaining the event-free (i.e. overall survival) probabilities for the cycle times for Exp based on a hazard ratio if we think we will be applying a hazard ratio in the OS -> Death setting. Probably not, probably what we'll be doing is saying that once you get into the OS state under the experimental strategy, you recieve the same second-line treatment as standard of care again and thus your event-free (i.e. overall survival) probabilities for the cycle times are the same as for SoC. - I'll code in both options here and I can make a decision when applying this.
    # 4) Obtaining the time-dependent transition probabilities from the event-free (i.e. overall survival) probabilities
    
    # 1) Defining the cycle times
#    t <- seq(from = 0, by = t_cycle, length.out = n_cycle + 1)
    
    # 2) Obtaining the event-free (i.e. overall survival) probabilities for the cycle times for SoC
    # S_PD_SoC - survival of progression to dead, i.e. not going to dead, i.e. staying in progression.
    # Note that the coefficients [that we took from flexsurvreg earlier] need to be transformed to obtain the parameters that the base R function uses
    
    
#    S_PD_SoC <- pweibull(
#      q     = t, 
#      shape = exp(coef_TTD_weibull_shape_SoC), 
#      scale = exp(coef_TTD_weibull_scale_SoC), 
#      lower.tail = FALSE
#    )
    
#    head(cbind(t, S_PD_SoC))
    
    
    
    # Having the above header shows that this is probability for surviving in the P->D state, i.e., staying in this state, because you should see in time 0 0% of people are in this state, meaning 100% of people hadnt gone into the progressed state and were in PFS, which make sense in this model, the model starts with everyone in PFS, no-one starts the model in OS, and it takes a while for people to reach the OS state.
    
    
    # 3) Obtaining the event-free (i.e. overall survival) probabilities for the cycle times for Experimental treatment (aka the novel therapy) based on a hazard ratio.
    # So here we basically have a hazard ratio for the novel therapy that says you do X much better under the novel therapy than under standard of care, and we want to apply it to standard of care from our individual patient data to see how much improved things would be under the novel therapy.
    
    # Here our hazard ratio is 0.6, I can change that for our hazard ratio.
    # - note that S(t) = exp(-H(t)) and, hence, H(t) = -ln(S(t))
    # that is, the survival function is the expoential of the negative hazard function, per:
    # https://faculty.washington.edu/yenchic/18W_425/Lec5_survival.pdf
    # and: 
    # https://web.stanford.edu/~lutian/coursepdf/unit1.pdf
    # Also saved here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\R Code\Parametric Survival Analysis\flexsurv
    # And to multiply by the hazard ratio it's necessary to convert the survivor function into the hazard function, multiply by the hazard ratio, and then convery back to the survivor function, and then these survivor functions are used for the probabilities.
    # H_PD_SoC  <- -log(S_PD_SoC)
    # H_PD_Exp  <- H_PD_SoC * HR_PD_Exp
    # S_PD_Exp  <- exp(-H_PD_Exp)
    # 
    # head(cbind(t, S_PD_SoC, H_PD_SoC, H_PD_Exp, S_PD_Exp))
    # 
    # 
    # If I decide that, as I said,  once you get into the OS state under the experimental strategy, you recieve the same second-line treatment as standard of care again and thus your event-free (i.e. overall survival) probabilities for the cycle times are the same as for SoC, then I can use the following coding - which is just repeating what I did for standard of care but this time giving it to the experimental stratgey:
    
    # S_PD_Exp <- pweibull(
    #   q     = t, 
    #   shape = exp(coef_TTD_weibull_shape_SoC), 
    #   scale = exp(coef_TTD_weibull_scale_SoC), 
    #   lower.tail = FALSE
    # )
    # 
    # head(cbind(t, S_PD_Exp))
    # 
    # I've coded in both options here and I can make a decision when applying this.
    
    
    
    
    # 4) Obtaining the time-dependent transition probabilities from the event-free (i.e. overall survival) probabilities
    
    # Now we can take the probability of being in the OS state at each of our cycles, as created above, from 100% (i.e. from 1) in order to get the probability of NOT being in the OS state, i.e. in order to get the probability of moving into the deda state.
    
    
#    p_PD_SoC <- p_PD_Exp <- rep(NA, n_cycle)
    
    # First we make the probability of going from progression (P) to dead (D) blank (i.e. NA) for all the cycles in standard of care and all the cycles under the experimental strategy.
    
    # 
    # for(i in 1:n_cycle) {
    #   p_PD_SoC[i] <- 1 - S_PD_SoC[i+1] / S_PD_SoC[i]
    #   p_PD_Exp[i] <- 1 - S_PD_Exp[i+1] / S_PD_Exp[i]
    # }
    # 
    
    # Then we generate our transition probability under standard of care and under the experimental treatement using survival functions that havent and have had the hazard ratio from above applied to them, respectively. [If we decide not to apply a hazard ratio for the experimental strategy going from progression to dead then neither may have a hazard ratio applied to them].
    
    
    # The way this works is, you take next cycles probability of staying in this state, divide it by this cycles probability of staying in this state, and take it from 1 to get the probability of leaving this state. 
    
  #   p_PD_SoC
  #   
  #   p_PD_Exp
  # }
  # 
  # 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
        
    
    
        
    v_names_strats <- c("Standard of Care", "Experimental Treatment")         # Store the strategy names
    v_names_states <- c("PFS", "AE1", "AE2", "AE3", "OS", "Dead")   # state names # These are the health states in our model, PFS, Adverse Event 1, Adverse Event 2, Adverse Event 3, OS, Death.
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
    m_M_SoC[1, "AE1"] <- m_M_Exp[1, "AE1"] <- 0
    m_M_SoC[1, "AE2"] <- m_M_Exp[1, "AE2"] <- 0
    m_M_SoC[1, "AE3"] <- m_M_Exp[1, "AE3"] <- 0
    m_M_SoC[1, "OS"]  <- m_M_Exp[1, "OS"]  <- 0
    m_M_SoC[1, "Dead"] <- m_M_Exp[1, "Dead"]            <- 0
    
    
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
    m_P_SoC["PFS", "PFS", ] <- (1 - p_FD_SoC) * (1 - p_FP_SoC)
    m_P_SoC["PFS", "AE1", ]     <- p_FA1_SoC
    m_P_SoC["PFS", "AE2", ]     <- p_FA2_SoC
    m_P_SoC["PFS", "AE3", ]     <- p_FA3_SoC
    m_P_SoC["PFS", "OS", ]     <- (1 - p_FD_SoC) * p_FP_SoC
    m_P_SoC["PFS", "Dead", ]            <- p_FD_SoC
    
    # Setting the transition probabilities from OS
    
    m_P_SoC["OS", "OS", ] <- 1 - p_PD
    m_P_SoC["OS", "Dead", ]        <- p_PD
    
    # Setting the transition probabilities from Dead
    m_P_SoC["Dead", "Dead", ] <- 1
    
    
    # Setting the transition probabilities from AE1
    m_P_SoC["AE1", "PFS", ] <- p_A1F_SoC
    m_P_SoC["AE1", "Dead", ] <- p_A1D_SoC
    
    # Setting the transition probabilities from AE2
    m_P_SoC["AE2", "PFS", ] <- p_A2F_SoC
    m_P_SoC["AE2", "Dead", ] <- p_A2D_SoC
    
    # Setting the transition probabilities from AE3
    m_P_SoC["AE3", "PFS", ] <- p_A3F_SoC
    m_P_SoC["AE3", "Dead", ] <- p_A3D_SoC
    
    m_P_SoC
    
    # Using the transition probabilities for standard of care as basis, update the transition probabilities that are different for the experimental strategy
    
    # So, you'll see below we copy the matrix of transition probabilities for standard of care over the empty matrix of transition probilities for the experimental treatment, then copy the transition probabilities that are different for the experimental strategy over this:
    
    m_P_Exp <- m_P_SoC
    m_P_Exp["PFS", "PFS", ] <- (1 - p_FD_Exp) * (1 - p_FP_Exp)
    m_P_Exp["PFS", "OS", ]     <- (1 - p_FD_Exp) * p_FP_Exp
    m_P_Exp["PFS", "Dead", ]            <- p_FD_Exp
    
    
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
    
    # Calculate the costs and QALYs per cycle by multiplying m_M (the Markov trace) with the cost/utility           vectors for the different states
    
    v_tc_SoC <- m_M_SoC %*% c(c_F_SoC, c_AE1, c_AE2, c_AE3, c_P, c_D)
    v_tc_Exp <- m_M_Exp %*% c(c_F_Exp, c_AE1, c_AE2, c_AE3, c_P, c_D)
    
    v_tc_SoC
    v_tc_Exp
    
     v_tu_SoC <- m_M_SoC %*% c(u_F, u_AE1, u_AE2, u_AE3, u_P, u_D)
     v_tu_Exp <- m_M_Exp %*% c(u_F, u_AE1, u_AE2, u_AE3, u_P, u_D)
    
    
    v_tu_SoC
    v_tu_Exp    
    
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
    
    
    df_ce <- data.frame(Strategy = v_names_strats,
                        Cost     = v_tc_d,
                        Effect   = v_tu_d,
                        NMB      = v_nmb_d)
    
    return(df_ce)
    
  })
  
}