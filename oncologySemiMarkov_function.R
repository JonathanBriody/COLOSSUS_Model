##----------------------------------------------------------------------------------------------------------------##
##                                                                                                                ##
##                      ISPOR STUDENT NETWORK WEBINAR: HEALTH ECONOMIC MODELLING IN R                             ##
##                                                                                                                ##
##                               by Petros Pechlivanoglou and Koen Degeling                                       ##
##                                                                                                                ##
##----------------------------------------------------------------------------------------------------------------##
#
# This script is used in the oncologySemiMarkov_illustration.R script to define the function that evaluates the 
# three-state semi-Markov model for a specific set of parameter values.

oncologySemiMarkov <- function(l_params_all, n_wtp = 10000) {
  
  with(as.list(l_params_all), {
    
    t <- seq(from = 0, by = t_cycle, length.out = n_cycle + 1)
    S_FP_SoC <- pweibull(
      q     = t, 
      shape = exp(coef_weibull_shape_SoC), 
      scale = exp(coef_weibull_scale_SoC), 
      lower.tail = FALSE
    )
    H_FP_SoC  <- -log(S_FP_SoC)
    H_FP_Exp  <- H_FP_SoC * HR_FP_Exp
    S_FP_Exp  <- exp(-H_FP_Exp)
    
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
    
    p_FP_SoC <- p_FP_Exp <- rep(NA, n_cycle)
    for(i in 1:n_cycle) {
      p_FP_SoC[i] <- 1 - XNU_S_FP_SoC[i+1] / XNU_S_FP_SoC[i]
      p_FP_Exp[i] <- 1 - S_FP_Exp[i+1] / S_FP_Exp[i]
    }
    
    v_names_strats <- c("Standard of Care", "Experimental")         # strategy names
    v_names_states <- c("ProgressionFree", "Progression", "AE1", "AE2", "AE3", "Dead")   # state names
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
    m_M_SoC[1, "AE1"] <- m_M_Exp[1, "AE1"] <- 0
    m_M_SoC[1, "AE2"] <- m_M_Exp[1, "AE2"] <- 0
    m_M_SoC[1, "AE3"] <- m_M_Exp[1, "AE3"] <- 0
    m_M_SoC[1, "Dead"] <- m_M_Exp[1, "Dead"]            <- 0
    
    m_P_SoC <- array(
      data = 0,
      dim  = c(n_states, n_states, n_cycle),
      dimnames = list(v_names_states, v_names_states, paste0("Cycle", 1:n_cycle))
    )
    
    m_P_SoC["ProgressionFree", "ProgressionFree", ] <- (1 - p_FD) * (1 - p_FP_SoC)
    m_P_SoC["ProgressionFree", "Progression", ]     <- (1 - p_FD) * p_FP_SoC
    m_P_SoC["ProgressionFree", "AE1", ]     <- p_FA1_SoC
    m_P_SoC["ProgressionFree", "AE2", ]     <- p_FA2_SoC
    m_P_SoC["ProgressionFree", "AE3", ]     <- p_FA3_SoC
    m_P_SoC["ProgressionFree", "Dead", ]            <- p_FD
    
    m_P_SoC["Progression", "Progression", ] <- 1 - p_PD
    m_P_SoC["Progression", "Dead", ]        <- p_PD
    
    m_P_SoC["Dead", "Dead", ] <- 1
    
    
    # Setting the transition probabilities from AE1
    m_P_SoC["AE1", "ProgressionFree", ] <- 0.01
    m_P_SoC["AE1", "Dead", ] <- 0.01
    
    # Setting the transition probabilities from AE2
    m_P_SoC["AE2", "ProgressionFree", ] <- 0.01
    m_P_SoC["AE2", "Dead", ] <- 0.01
    
    # Setting the transition probabilities from AE3
    m_P_SoC["AE3", "ProgressionFree", ] <- 0.01
    m_P_SoC["AE3", "Dead", ] <- 0.01
    
    m_P_Exp <- m_P_SoC
    m_P_Exp["ProgressionFree", "ProgressionFree", ] <- (1 - p_FD) * (1 - p_FP_Exp)
    m_P_Exp["ProgressionFree", "Progression", ]     <- (1 - p_FD) * p_FP_Exp
    
    #     check_transition_probability(m_P_SoC, verbose = TRUE)
    #    check_transition_probability(m_P_Exp, verbose = TRUE)
    
    #    check_sum_of_transition_array(m_P_SoC, n_states = n_states, n_cycles = n_cycle, verbose = TRUE)
    #    check_sum_of_transition_array(m_P_Exp, n_states = n_states, n_cycles = n_cycle, verbose = TRUE)
    
    for(i_cycle in 1:(n_cycle-1)) {
      m_M_SoC[i_cycle + 1, ] <- m_M_SoC[i_cycle, ] %*% m_P_SoC[ , , i_cycle]
      m_M_Exp[i_cycle + 1, ] <- m_M_Exp[i_cycle, ] %*% m_P_Exp[ , , i_cycle]
    }
    
    v_tc_SoC <- m_M_SoC %*% c(c_F_SoC, c_AE1, c_AE2, c_AE3, c_P, c_D)
    v_tc_Exp <- m_M_Exp %*% c(c_F_Exp, c_AE1, c_AE2, c_AE3, c_P, c_D)
    
    v_tu_SoC <- m_M_SoC %*% c(u_F, u_AE1, u_AE2, u_AE3, u_P, u_D) * t_cycle
    v_tu_Exp <- m_M_Exp %*% c(u_F, u_AE1, u_AE2, u_AE3, u_P, u_D) * t_cycle
    
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