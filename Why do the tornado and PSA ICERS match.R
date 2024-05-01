# I was somewhat perturbed by the fact that the ICER displayed as the mean on the tornado diagram and the ICER reported following the PSA were so similar.

# That is, I would have expected them to differ more, given that the tornado is not probabilistic like the PSA, so the tornado is only varying by 20%, I would have anticipated that the tornado would have been closer to the deterministic reults reported earlier in the code, whereas the range for the PSA is a lot wider, as described in my email to Eline and James.

# To look into this, the first thing I did was run the PSA without running the tornado first, in case there was some copy over of my tornado ICER into the PSA ICER, but the PSA ICER remained unchanged. The next thing I did was copy the tornado code as below, but vary the minimum values more widely, because the PSA typically uses the maximum values in it's calculations from the range, rather than the minimum, if I change the minimum here it shouldnt change the PSA results, but I should see a change in the tornado diagram average.

# I changed the minimum value to be -099 rather than -0.20, so it is 99% lowerrather than 20% and my tornado diagram does change, not by a huge amount but it shifts closer to 80 than it previously was, but my results from my PSA stay completely the same (that is 79486 for Ireland).

# So, from this I can conclude that it's not some issue with the OWSA code messing up the PSA code and somehow changing it, they are producing values independent of eachtoher.

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


# Entering parameter values:


UpperCI <- 0.87
LowerCI <- 0.53

HR_FP_Exp

Minimum_HR_FP_Exp <- LowerCI
Maximum_HR_FP_Exp <- UpperCI


HR_FP_SoC

Minimum_HR_FP_SoC <- HR_FP_SoC - 0.99*HR_FP_SoC
Maximum_HR_FP_SoC <- HR_FP_SoC + 0.20*HR_FP_SoC


# Now that we're using the OS curves, I add hazard ratios for PFS to dead that reflect the hazard ratio of the experimental strategy changing the probability of going from PFS to Death, and the hazard ratio of 1 that I apply in standard of care so that I can vary transition probabilities under standard of care in this one-way sensitivity analysis:

HR_PD_SoC

Minimum_HR_PD_SoC <- HR_PD_SoC - 0.99*HR_PD_SoC
Maximum_HR_PD_SoC <- HR_PD_SoC + 0.20*HR_PD_SoC


OS_UpperCI <- 0.86
OS_LowerCI <- 0.49


HR_PD_Exp

Minimum_HR_PD_Exp <- OS_LowerCI
Maximum_HR_PD_Exp <- OS_UpperCI








# Probability of progressive disease to death:

# Under the assumption that everyone will get the same second line therapy, I give them all the same probability of going from progessed (i.e., OS) to dead, and thus only need to include p_PD here once - because it is applied in oncologySemiMarkov_function.R for both SoC and Exp. ACTUALLY I THINK IT SHOULD BE P_OSD_SoC P_OSD_Exp BOTH INCLUDED.

P_OSD_SoC

Minimum_P_OSD_SoC <- 0.12
Maximum_P_OSD_SoC <- 0.22

P_OSD_Exp

Minimum_P_OSD_Exp <- 0.12
Maximum_P_OSD_Exp <- 0.22







# Probability of going from PFS to Death states under the standard of care treatment and the experimental treatment:

# # HR_PD_SoC and HR_PD_Exp address this as above:

# p_FD_SoC
# 
# Minimum_p_FD_SoC <- p_FD_SoC - 0.99*p_FD_SoC
# Maximum_p_FD_SoC <- p_FD_SoC + 0.20*p_FD_SoC
# 
# p_FD_Exp
# 
# Minimum_p_FD_Exp<- p_FD_Exp - 0.99*p_FD_Exp
# Maximum_p_FD_Exp <- p_FD_Exp + 0.20*p_FD_Exp



# Probability of Adverse Events:

p_FA1_STD
Minimum_p_FA1_STD <- p_FA1_STD - 0.99*p_FA1_STD
Maximum_p_FA1_STD <- p_FA1_STD + 0.20*p_FA1_STD

p_FA2_STD
Minimum_p_FA2_STD <- p_FA2_STD - 0.99*p_FA2_STD
Maximum_p_FA2_STD <- p_FA2_STD + 0.20*p_FA2_STD

p_FA3_STD
Minimum_p_FA3_STD <- p_FA3_STD - 0.99*p_FA3_STD
Maximum_p_FA3_STD <- p_FA3_STD + 0.20*p_FA3_STD


p_FA1_EXPR
Minimum_p_FA1_EXPR <- p_FA1_EXPR - 0.99*p_FA1_EXPR
Maximum_p_FA1_EXPR <- p_FA1_EXPR + 0.20*p_FA1_EXPR

p_FA2_EXPR
Minimum_p_FA2_EXPR <- p_FA2_EXPR - 0.99*p_FA2_EXPR
Maximum_p_FA2_EXPR <- p_FA2_EXPR + 0.20*p_FA2_EXPR

p_FA3_EXPR
Minimum_p_FA3_EXPR <- p_FA3_EXPR - 0.99*p_FA3_EXPR
Maximum_p_FA3_EXPR <- p_FA3_EXPR + 0.20*p_FA3_EXPR




# Cost:

# If I decide to include the cost of the test for patients I will also need to include this in the sensitivity analysis here:

administration_cost

Minimum_administration_cost <- administration_cost - 0.99*administration_cost
Maximum_administration_cost <- administration_cost + 0.20*administration_cost

c_PFS_Folfox

Minimum_c_PFS_Folfox  <- c_PFS_Folfox - 0.99*c_PFS_Folfox
Maximum_c_PFS_Folfox  <- c_PFS_Folfox + 0.20*c_PFS_Folfox

c_PFS_Bevacizumab 

Minimum_c_PFS_Bevacizumab  <- c_PFS_Bevacizumab - 0.99*c_PFS_Bevacizumab
Maximum_c_PFS_Bevacizumab  <- c_PFS_Bevacizumab + 0.20*c_PFS_Bevacizumab

c_OS_Folfiri 

Minimum_c_OS_Folfiri  <- c_OS_Folfiri - 0.99*c_OS_Folfiri
Maximum_c_OS_Folfiri  <- c_OS_Folfiri + 0.20*c_OS_Folfiri

subtyping_test_cost 

Minimum_subtyping_test_cost  <- subtyping_test_cost - 0.99*subtyping_test_cost
Maximum_subtyping_test_cost <- subtyping_test_cost + 0.20*subtyping_test_cost

c_D  

Minimum_c_D  <- c_D - 0.99*c_D
Maximum_c_D  <- c_D + 0.20*c_D

c_AE1

Minimum_c_AE1  <- c_AE1 - 0.99*c_AE1
Maximum_c_AE1  <- c_AE1 + 0.20*c_AE1

c_AE2

Minimum_c_AE2  <- c_AE2 - 0.99*c_AE2
Maximum_c_AE2  <- c_AE2 + 0.20*c_AE2

c_AE3

Minimum_c_AE3  <- c_AE3 - 0.99*c_AE3
Maximum_c_AE3  <- c_AE3 + 0.20*c_AE3


# Utilities:

u_F

Minimum_u_F <- 0.68
Maximum_u_F <- 1.00


u_P

Minimum_u_P <- 0.52
Maximum_u_P <- 0.78 


u_D

Minimum_u_D <- u_D - 0.99*u_D
Maximum_u_D <- u_D + 0.20*u_D 


AE1_DisUtil

Minimum_AE1_DisUtil <- AE1_DisUtil - 0.99*AE1_DisUtil
Maximum_AE1_DisUtil <- AE1_DisUtil + 0.20*AE1_DisUtil 


AE2_DisUtil

Minimum_AE2_DisUtil <- AE2_DisUtil - 0.99*AE2_DisUtil
Maximum_AE2_DisUtil <- AE2_DisUtil + 0.20*AE2_DisUtil 


AE3_DisUtil

Minimum_AE3_DisUtil <- AE3_DisUtil - 0.99*AE3_DisUtil
Maximum_AE3_DisUtil <- AE3_DisUtil + 0.20*AE3_DisUtil 




# Discount factor
# Cost Discount Factor
# Utility Discount Factor
# I divided these by 365 earlier in the R markdown document, so no need to do that again here:

d_e

Minimum_d_e <- 0
Maximum_d_e <- 0.08/365



d_c

Minimum_d_c <- 0
Maximum_d_c <- 0.08/365


# I am concerned that the min or max may go above 1 or below 0 in cases where parameter values should be bounded at 1 or 0, therefore, in such cases I say, replace the minimum I created with 0 or the maximum I created with 1, if the minimum is below 0 or the maximum is above 1:


HR_FP_Exp
Minimum_HR_FP_Exp<- replace(Minimum_HR_FP_Exp, Minimum_HR_FP_Exp<0, 0)
Maximum_HR_FP_Exp<- replace(Maximum_HR_FP_Exp, Maximum_HR_FP_Exp>1, 1)

HR_FP_SoC
Minimum_HR_FP_SoC<- replace(Minimum_HR_FP_SoC, Minimum_HR_FP_SoC<0, 0)
Maximum_HR_FP_SoC<- replace(Maximum_HR_FP_SoC, Maximum_HR_FP_SoC>1, 1)

HR_PD_SoC
Minimum_HR_PD_SoC<- replace(Minimum_HR_PD_SoC, Minimum_HR_PD_SoC<0, 0)
Maximum_HR_PD_SoC<- replace(Maximum_HR_PD_SoC, Maximum_HR_PD_SoC>1, 1)

HR_PD_Exp
Minimum_HR_PD_Exp<- replace(Minimum_HR_PD_Exp, Minimum_HR_PD_Exp<0, 0)
Maximum_HR_PD_Exp<- replace(Maximum_HR_PD_Exp, Maximum_HR_PD_Exp>1, 1)

P_OSD_SoC
Minimum_P_OSD_SoC<- replace(Minimum_P_OSD_SoC, Minimum_P_OSD_SoC<0, 0)
Maximum_P_OSD_SoC<- replace(Maximum_P_OSD_SoC, Maximum_P_OSD_SoC>1, 1)

P_OSD_Exp
Minimum_P_OSD_Exp<- replace(Minimum_P_OSD_Exp, Minimum_P_OSD_Exp<0, 0)
Maximum_P_OSD_Exp<- replace(Maximum_P_OSD_Exp, Maximum_P_OSD_Exp>1, 1)

p_FA1_STD
Minimum_p_FA1_STD<- replace(Minimum_p_FA1_STD, Minimum_p_FA1_STD<0, 0)
Maximum_p_FA1_STD<- replace(Maximum_p_FA1_STD, Maximum_p_FA1_STD>1, 1)

p_FA2_STD
Minimum_p_FA2_STD<- replace(Minimum_p_FA2_STD, Minimum_p_FA2_STD<0, 0)
Maximum_p_FA2_STD<- replace(Maximum_p_FA2_STD, Maximum_p_FA2_STD>1, 1)

p_FA3_STD
Minimum_p_FA3_STD<- replace(Minimum_p_FA3_STD, Minimum_p_FA3_STD<0, 0)
Maximum_p_FA3_STD<- replace(Maximum_p_FA3_STD, Maximum_p_FA3_STD>1, 1)

p_FA1_EXPR
Minimum_p_FA1_EXPR<- replace(Minimum_p_FA1_EXPR, Minimum_p_FA1_EXPR<0, 0)
Maximum_p_FA1_EXPR<- replace(Maximum_p_FA1_EXPR, Maximum_p_FA1_EXPR>1, 1)

p_FA2_EXPR
Minimum_p_FA2_EXPR<- replace(Minimum_p_FA2_EXPR, Minimum_p_FA2_EXPR<0, 0)
Maximum_p_FA2_EXPR<- replace(Maximum_p_FA2_EXPR, Maximum_p_FA2_EXPR>1, 1)

p_FA3_EXPR
Minimum_p_FA3_EXPR<- replace(Minimum_p_FA3_EXPR, Minimum_p_FA3_EXPR<0, 0)
Maximum_p_FA3_EXPR<- replace(Maximum_p_FA3_EXPR, Maximum_p_FA3_EXPR>1, 1)

u_F
Minimum_u_F<- replace(Minimum_u_F, Minimum_u_F<0, 0)
Maximum_u_F<- replace(Maximum_u_F, Maximum_u_F>1, 1)

u_P
Minimum_u_P<- replace(Minimum_u_P, Minimum_u_P<0, 0)
Maximum_u_P<- replace(Maximum_u_P, Maximum_u_P>1, 1)

AE1_DisUtil
Minimum_AE1_DisUtil<- replace(Minimum_AE1_DisUtil, Minimum_AE1_DisUtil<0, 0)
Maximum_AE1_DisUtil<- replace(Maximum_AE1_DisUtil, Maximum_AE1_DisUtil>1, 1)

AE2_DisUtil
Minimum_AE2_DisUtil<- replace(Minimum_AE2_DisUtil, Minimum_AE2_DisUtil<0, 0)
Maximum_AE2_DisUtil<- replace(Maximum_AE2_DisUtil, Maximum_AE2_DisUtil>1, 1)

AE3_DisUtil
Minimum_AE3_DisUtil<- replace(Minimum_AE3_DisUtil, Minimum_AE3_DisUtil<0, 0)
Maximum_AE3_DisUtil<- replace(Maximum_AE3_DisUtil, Maximum_AE3_DisUtil>1, 1)

