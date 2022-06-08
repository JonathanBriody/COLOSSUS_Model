# This script is used in the Markov_3state.R script to define the function that evaluates the three-state semi-Markov model for a specific set of parameter values.

# This "function" is basically just repeating the code from the Markov_3state.R script again.

DONT FORGET TO ADD ADVERSE EVENTS!!!!!

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
    
    
    head(cbind(t, S_FP_SoC))
    
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
    
    head(cbind(t, S_FP_SoC, H_FP_SoC, H_FP_Exp, S_FP_Exp))
    
    
    # 4) Obtaining the time-dependent transition probabilities from the event-free (i.e. survival) probabilities
    
    # Now we can take the probability of being in the PFS state at each of our cycles, as created above, from 100% (i.e. from 1) in order to get the probability of NOT being in the PFS state, i.e. in order to get the probability of moving into the progressed state, or the OS state.
    
    
    p_FP_SoC <- p_FP_Exp <- rep(NA, n_cycle)
    
    # First we make the probability of going from progression-free (F) to progression (P) blank (i.e. NA) for all the cycles in standard of care and all the cycles under the experimental strategy.
    
    
    for(i in 1:n_cycle) {
      p_FP_SoC[i] <- 1 - S_FP_SoC[i+1] / S_FP_SoC[i]
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
    
    
    
    # TRANSITION PROBABILITIES: Time-To-Dead TTD
    
    
    # Time-dependent transition probabilities are obtained in four steps
    # 1) Defining the cycle times [we already did this above]
    # 2) Obtaining the event-free (i.e. overall survival) probabilities for the cycle times for SoC
    # 3) Obtaining the event-free (i.e. overall survival) probabilities for the cycle times for Exp based on a hazard ratio if we think we will be applying a hazard ratio in the OS -> Death setting. Probably not, probably what we'll be doing is saying that once you get into the OS state under the experimental strategy, you recieve the same second-line treatment as standard of care again and thus your event-free (i.e. overall survival) probabilities for the cycle times are the same as for SoC. - I'll code in both options here and I can make a decision when applying this.
    # 4) Obtaining the time-dependent transition probabilities from the event-free (i.e. overall survival) probabilities
    
    # 1) Defining the cycle times
    t <- seq(from = 0, by = t_cycle, length.out = n_cycle + 1)
    
    # 2) Obtaining the event-free (i.e. overall survival) probabilities for the cycle times for SoC
    # S_PD_SoC - survival of progression to dead, i.e. not going to dead, i.e. staying in progression.
    # Note that the coefficients [that we took from flexsurvreg earlier] need to be transformed to obtain the parameters that the base R function uses
    
    
    S_PD_SoC <- pweibull(
      q     = t, 
      shape = exp(coef_TTD_weibull_shape_SoC), 
      scale = exp(coef_TTD_weibull_scale_SoC), 
      lower.tail = FALSE
    )
    
    head(cbind(t, S_PD_SoC))
    
    
    
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
    H_PD_SoC  <- -log(S_PD_SoC)
    H_PD_Exp  <- H_PD_SoC * HR_PD_Exp
    S_PD_Exp  <- exp(-H_PD_Exp)
    
    head(cbind(t, S_PD_SoC, H_PD_SoC, H_PD_Exp, S_PD_Exp))
    
    
    # If I decide that, as I said,  once you get into the OS state under the experimental strategy, you recieve the same second-line treatment as standard of care again and thus your event-free (i.e. overall survival) probabilities for the cycle times are the same as for SoC, then I can use the following coding - which is just repeating what I did for standard of care but this time giving it to the experimental stratgey:
    
    S_PD_Exp <- pweibull(
      q     = t, 
      shape = exp(coef_TTD_weibull_shape_SoC), 
      scale = exp(coef_TTD_weibull_scale_SoC), 
      lower.tail = FALSE
    )
    
    head(cbind(t, S_PD_Exp))
    
    # I've coded in both options here and I can make a decision when applying this.
    
    
    
    
    # 4) Obtaining the time-dependent transition probabilities from the event-free (i.e. overall survival) probabilities
    
    # Now we can take the probability of being in the OS state at each of our cycles, as created above, from 100% (i.e. from 1) in order to get the probability of NOT being in the OS state, i.e. in order to get the probability of moving into the deda state.
    
    
    p_PD_SoC <- p_PD_Exp <- rep(NA, n_cycle)
    
    # First we make the probability of going from progression (P) to dead (D) blank (i.e. NA) for all the cycles in standard of care and all the cycles under the experimental strategy.
    
    
    for(i in 1:n_cycle) {
      p_PD_SoC[i] <- 1 - S_PD_SoC[i+1] / S_PD_SoC[i]
      p_PD_Exp[i] <- 1 - S_PD_Exp[i+1] / S_PD_Exp[i]
    }
    
    
    # Then we generate our transition probability under standard of care and under the experimental treatement using survival functions that havent and have had the hazard ratio from above applied to them, respectively. [If we decide not to apply a hazard ratio for the experimental strategy going from progression to dead then neither may have a hazard ratio applied to them].
    
    
    # The way this works is, you take next cycles probability of staying in this state, divide it by this cycles probability of staying in this state, and take it from 1 to get the probability of leaving this state. 
    
    p_PD_SoC
    
    p_PD_Exp
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
        
    v_names_strats <- c("Standard of Care", "Experimental")         # strategy names
    v_names_states <- c("ProgressionFree", "Progression", "Dead")   # state names
    n_strats       <- length(v_names_strats)                        # number of strategies
    n_states       <- length(v_names_states)                        # number of states
    
    m_M_SoC <- m_M_Exp <- matrix(
      data = NA, 
      nrow = n_cycle,  
      ncol = n_states, 
      dimnames = list(paste('Cycle', 1:n_cycle), v_names_states)
    )
    
    m_M_SoC[1, "ProgressionFree"] <- m_M_Exp[1, "ProgressionFree"] <- 1
    m_M_SoC[1, "Progression"]     <- m_M_Exp[1, "Progression"]     <- 0
    m_M_SoC[1, "Dead"]            <- m_M_Exp[1, "Dead"]            <- 0
    
    m_P_SoC <- array(
      data = 0,
      dim  = c(n_states, n_states, n_cycle),
      dimnames = list(v_names_states, v_names_states, paste0("Cycle", 1:n_cycle))
    )
    
    m_P_SoC["ProgressionFree", "ProgressionFree", ] <- (1 - p_FD) * (1 - p_FP_SoC)
    m_P_SoC["ProgressionFree", "Progression", ]     <- (1 - p_FD) * p_FP_SoC
    m_P_SoC["ProgressionFree", "Dead", ]            <- p_FD
    
    m_P_SoC["Progression", "Progression", ] <- 1 - p_PD
    m_P_SoC["Progression", "Dead", ]        <- p_PD
    
    m_P_SoC["Dead", "Dead", ] <- 1
    
    m_P_Exp <- m_P_SoC
    m_P_Exp["ProgressionFree", "ProgressionFree", ] <- (1 - p_FD) * (1 - p_FP_Exp)
    m_P_Exp["ProgressionFree", "Progression", ]     <- (1 - p_FD) * p_FP_Exp
    
    check_transition_probability(m_P_SoC, verbose = TRUE)
    check_transition_probability(m_P_Exp, verbose = TRUE)
    
    check_sum_of_transition_array(m_P_SoC, n_states = n_states, n_cycles = n_cycle, verbose = TRUE)
    check_sum_of_transition_array(m_P_Exp, n_states = n_states, n_cycles = n_cycle, verbose = TRUE)
    
    for(i_cycle in 1:(n_cycle-1)) {
      m_M_SoC[i_cycle + 1, ] <- m_M_SoC[i_cycle, ] %*% m_P_SoC[ , , i_cycle]
      m_M_Exp[i_cycle + 1, ] <- m_M_Exp[i_cycle, ] %*% m_P_Exp[ , , i_cycle]
    }
    
    v_tc_SoC <- m_M_SoC %*% c(c_F_SoC, c_P, c_D)
    v_tc_Exp <- m_M_Exp %*% c(c_F_Exp, c_P, c_D)
    
    v_tu_SoC <- m_M_SoC %*% c(u_F, u_P, u_D) * t_cycle
    v_tu_Exp <- m_M_Exp %*% c(u_F, u_P, u_D) * t_cycle
    
    v_dwc <- 1 / ((1 + d_c) ^ ((0:(n_cycle-1)) * t_cycle)) 
    v_dwe <- 1 / ((1 + d_e) ^ ((0:(n_cycle-1)) * t_cycle))
    
    tc_d_SoC <-  t(v_tc_SoC) %*% v_dwc 
    tc_d_Exp <-  t(v_tc_Exp) %*% v_dwc
    
    tu_d_SoC <-  t(v_tu_SoC) %*% v_dwe
    tu_d_Exp <-  t(v_tu_Exp) %*% v_dwe
    
    v_tc_d    <- c(tc_d_SoC, tc_d_Exp)
    v_tu_d    <- c(tu_d_SoC, tu_d_Exp)
    
    v_nmb_d   <- v_tu_d * n_wtp - v_tc_d
    
    df_ce <- data.frame(Strategy = v_names_strats,
                        Cost     = v_tc_d,
                        Effect   = v_tu_d,
                        NMB      = v_nmb_d)
    
    return(df_ce)
    
  })
  
}
