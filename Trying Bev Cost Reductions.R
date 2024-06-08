c_PFS_Bevacizumab

# c_PFS_Bevacizumab <- 100

# c_AE1 <- 500.97


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
  p_OSA1_FOLFIRI = p_OSA1_FOLFIRI,
  p_OSA2_FOLFIRI = p_OSA2_FOLFIRI,
  p_OSA3_FOLFIRI = p_OSA3_FOLFIRI,
  administration_cost = administration_cost,
  #ITS FINE TO INCLUDE THE INGRIDENIENTS THAT MAKE UP c_F_SoC, c_F_Exp, c_P, but don't include c_F_SoC, c_F_Exp, c_P themsleves, BECAUSE WE ARE CHANGING WHAT BUILDS THESE COSTS WITH THE INGRIEDIENTS, SO WE DON'T WANT TO CHANGE IT AGAIN HERE ONCE WE'VE CHANGED WHAT BUILDS IT
  c_PFS_Folfox = c_PFS_Folfox,
  c_PFS_Bevacizumab = c_PFS_Bevacizumab,
  c_OS_Folfiri = c_OS_Folfiri,
  subtyping_test_cost  = subtyping_test_cost,
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
