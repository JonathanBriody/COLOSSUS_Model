## General setup

# Here we define all our model parameters, so that we can call on these parameters later during our model:

t_cycle <- 30      # cycle length of 2 weeks (in [[days]] - this is assuming the survival curves I am digitising will be in [[days]] if they are in another period I will have to represent my cycle length in that period instead).                                  
n_cycle        <- 44                            
# We set the number of cycles to 143 to reflect 2,000 days from the Angiopredict study (5 Years, 5 Months, 3 Weeks, 1 Day) broken down into fortnightly cycles
v_names_cycles  <- paste("cycle", 0:n_cycle)    
# So here, we just name each cycle by the cycle its on, going from 0 up to the number of cycles there are, here 143
v_names_states  <- c("PFS", "AE1", "AE2", "AE3", "OS", "Dead")  
# These are the health states in our model, PFS, Adverse Event 1, Adverse Event 2, Adverse Event 3, OS, Death.
n_states        <- length(v_names_states)        
# We're just taking the number of health states from the number of names we came up with, i.e. the number of names to reflect the number of health states 

# Strategy names
v_names_strats     <- c("Standard of Care",         
                        "Experimental Treatment") 
# store the strategy names
n_str           <- length(v_names_strats)           
# number of strategies



# TRANSITION PROBABILITIES: Time-To-Transition - TTP:


# Time-dependent transition probabilities are obtained in four steps
# 1) Defining the cycle times
# 2) Obtaining the event-free (i.e. survival) probabilities for the cycle times for SoC
# 3) Obtaining the event-free (i.e. survival) probabilities for the cycle times for Exp based on a hazard ratio
# 4) Obtaining the time-dependent transition probabilities from the event-free (i.e. survival) probabilities

# 1) Defining the cycle times

# I think here we're saying, at each cycle how many of the time periods our individual patient data is measured at have passed? Here our individual patient data is in days, so we have 0 in cycle 0, 14 (or two weeks) in cycle 1, and so on.

# Having established that allows us to obtain the transition probabilities for the time we are interested in for our cycles from this different period individual patient data, so where the individual patient data is in days and our cycles are in fortnight or half months, this allows us to obtain transition probabilities for these fortnights.

# 2) Obtaining the event-free (i.e. survival) probabilities for the cycle times for SoC
# S_FP_SoC - survival of progression free to progression, i.e. not going to progression, i.e. staying in progression free.
# Note that the coefficients [that we took from flexsurvreg earlier] need to be transformed to obtain the parameters that the base R function uses

(t <- seq(from = 0, by = t_cycle, length.out = n_cycle + 1))

x <- pweibull(
  q     = t, 
  shape = exp(coef_weibull_shape_SoC), 
  scale = exp(coef_weibull_scale_SoC), 
  lower.tail = FALSE
)

head(cbind(t, x))
x
S_FP_SoC <- x[-c(1)]
S_FP_SoC

# Having the above header shows that this is probability for surviving in the F->P state, i.e., staying in this state, because you can see in time 0 100% of people are in this state, meaning 100% of people hadnt progressed and were in PFS, if this was instead about the progressed state (i.e. OS), there should be no-one in this state when the model starts, as everyone starts in the PFS state, and it takes a while for people to reach the OS state.


# 3) Obtaining the event-free (i.e. survival) probabilities for the cycle times for Experimental treatment (aka the novel therapy) based on a hazard ratio.
# So here we basically have a hazard ratio for the novel therapy that says you do X much better under the novel therapy than under standard of care, and we want to apply it to standard of care from our individual patient data to see how much improved things would be under the novel therapy.

# - note that S(t) = exp(-H(t)) and, hence, H(t) = -ln(S(t))
# that is, the survival function is the expoential of the negative hazard function.
# And to multiply by the hazard ratio it's necessary to convert the survivor function into the hazard function, multiply by the hazard ratio, and then convert back to the survivor function, and then these survivor functions are used for the probabilities.
HR_FP_Exp <- 0.68
H_FP_SoC  <- -log(S_FP_SoC)
H_FP_Exp  <- H_FP_SoC * HR_FP_Exp
S_FP_Exp  <- exp(-H_FP_Exp)

head(cbind(t, S_FP_SoC, H_FP_SoC, H_FP_Exp, S_FP_Exp))


head(cbind(t, S_FP_SoC, H_FP_SoC))


# 4) Obtaining the time-dependent transition probabilities from the event-free (i.e. survival) probabilities

# Now we can take the probability of being in the PFS state at each of our cycles, as created above, from 100% (i.e. from 1) in order to get the probability of NOT being in the PFS state, i.e. in order to get the probability of moving into the progressed state, or the OS state.


p_PFSOS_SoC <- p_PFSOS_Exp <- rep(NA, n_cycle)

# First we make the probability of going from progression-free (F) to progression (P) blank (i.e. NA) for all the cycles in standard of care and all the cycles under the experimental strategy.


for(i in 1:n_cycle) {
  p_PFSOS_SoC[i] <- 1 - S_FP_SoC[i]
  p_PFSOS_Exp[i] <- 1 - S_FP_Exp[i]
}

# round(p_PFSOS_SoC, digits=2)
# round(p_PFSOS_Exp, digits=2)

# Then we generate our transition probability under standard of care and under the experimental treatement using survival functions that havent and have had the hazard ratio from above applied to them, respectively.


# The way this works is the below, you take next cycles probability of staying in this state, divide it by this cycles probability of staying in this state, and take it from 1 to get the probability of leaving this state. 

p_PFSOS_SoC

p_PFSOS_Exp




# TRANSITION PROBABILITIES: Time-To-Dead TTD

# REALISE HERE THEAT P_PD ISNT THE PROBABILITY OF PROGRESSION TO DEAD, BUT OF PFS TO DEAD, OF FIRST LINE TO DEAD, BECAUSE OUR APD CURVES ONLY EVER DESCRIBE FIRST LINE TREATMENT, BE THAT FIRST LINE SOC TREATMENT OR FIRST LINE EXP TREATMENT.


# To make sure that my PFS probabilities only reflect going from PFS to progression, I create the probability of going from PFS to DEAD under standard of care and the experimental, and decrease my PFS to progression probability by the probability of going into the dead state, such that I am only capturing people going into progression, and not people going into death as well. 


# So, first I create the transition probabilities of progression free into dead for SoC and Exp, then I take all the probabilities (i.e. those for PFS and those for OS), minus them from eachother.


# Time-dependent transition probabilities are obtained in four steps
# 1) Defining the cycle times [we already did this above]
# 2) Obtaining the event-free (i.e. overall survival) probabilities for the cycle times for SoC
# 3) Obtaining the event-free (i.e. overall survival) probabilities for the cycle times for Exp based on a hazard ratio.
# 4) Obtaining the time-dependent transition probabilities from the event-free (i.e. overall survival) probabilities



# 1) Defining the cycle times
(t <- seq(from = 0, by = t_cycle, length.out = n_cycle + 1))

# 2) Obtaining the event-free (i.e. overall survival) probabilities for the cycle times for SoC
# S_PD_SoC - survival of progression to dead, i.e. not going to dead, i.e. staying in progression.

y <- pweibull(
  q     = t, 
  shape = exp(coef_TTD_weibull_shape_SoC), 
  scale = exp(coef_TTD_weibull_scale_SoC), 
  lower.tail = FALSE
)

head(cbind(t, y))
y

S_PD_SoC <- y[-c(1)]
S_PD_SoC


# 3) Obtaining the event-free (i.e. overall survival) probabilities for the cycle times for Experimental treatment (aka the novel therapy) based on a hazard ratio.

HR_PD_Exp <- 0.65
H_PD_SoC  <- -log(S_PD_SoC)
H_PD_Exp  <- H_PD_SoC * HR_PD_Exp
S_PD_Exp  <- exp(-H_PD_Exp)

head(cbind(t, S_PD_SoC, H_PD_SoC, H_PD_Exp, S_PD_Exp))


# 4) Obtaining the time-dependent transition probabilities from the event-free (i.e. survival) probabilities


p_PFSD_SoC <- p_PFSD_Exp <- rep(NA, n_cycle)


for(i in 1:n_cycle) {
  p_PFSD_SoC[i] <- 1 - S_PD_SoC[i]
  p_PFSD_Exp[i] <- 1 - S_PD_Exp[i]
}

# round(p_PFSD_SoC, digits=2)
# round(p_PFSD_Exp, digits=2)

# The way this works is, you take next cycles probability of staying in this state, divide it by this cycles probability of staying in this state, and take it from 1 to get the probability of leaving this state. 

p_PFSD_SoC

p_PFSD_Exp

# Finally, now that I create transition probabilities from treatment to death under SoC and the Exp treatment I can take them from the transition probabilities from treatment to progression for SoC and Exp treatment, because the OS here from Angiopredict is transitioning from the first line treatment to dead, not from second line treatment to death, and once we get rid of the people who were leaving first line treatment to die in PFS, all we have left is people leaving first line treatment to progress. And then we can keep the first line treatment to death probabilities we've created from the OS curves to capture people who have left first line treatment to transition into death rather than second line treatment.



# Probability of going to the adverse event state from the progression free state:


p_FA1_STD     <- 0.040   # probability of adverse event 1 when progression-free under SOC
p_A1_D_STD    <- 0.001    # probability of dying when in adverse event 1 under SOC

p_FA2_STD     <- 0.310   # probability of adverse event 2 when progression-free under SOC
p_A2_D_STD    <- 0.001    # probability of dying when in adverse event 2 under SOC

p_FA3_STD     <- 0.310   # probability of adverse event 3 when progression-free under SOC
p_A3_D_STD    <- 0.001    # probability of dying when in adverse event 3 under SOC


p_FA1_EXPR     <- 0.070   # probability of adverse event 1 when progression-free under EXPR
p_A1_D_EXPR    <- 0.001    # probability of dying when in adverse event 1 under EXPR

p_FA2_EXPR     <- 0.110   # probability of adverse event 2 when progression-free under EXPR
p_A2_D_EXPR    <- 0.001    # probability of dying when in adverse event 2 under EXPR

p_FA3_EXPR     <- 0.070   # probability of adverse event 3 when progression-free under EXPR
p_A3_D_EXPR    <- 0.001    # probability of dying when in adverse event 3 under EXPR

p_PFSD_SoC
p_PFSD_Exp

p_PFSOS_SoC
p_PFSOS_Exp

# I generate the probability of going to death in the second line treatment, and I make the assumption that everyone gets the same second line treatment and give them the same probability under exp and under SoC to go from the second line therapy into dead:

p_FD_SoC   <- 0.17 # Probability of dying when in OS.
p_FD_Exp   <- 0.17 # Probability of dying when in OS.






p_A1D_SoC  <- 0.001 
# Probability of going from AE1 to death
p_A1F_SoC  <- 1-p_A1D_SoC
# Probability of returning from AE1 to PFS is 100% minus the people who have gone into the dead state.


# I repeat this for the other adverse events and for both standard of care and the experimental (novel) treatment:


# PFS -> PFS:

p_PFS_SoC  <-   (1 - p_FA1_STD)* (1 - p_FA2_STD)* (1 - p_FA3_STD)* (1 - p_PFSOS_SoC) * (1 - p_PFSD_SoC) 
p_PFS_Exp  <-   (1 - p_PFSD_Exp) * (1 - p_PFSOS_Exp)* (1 - p_FA1_EXPR)* (1 - p_FA2_EXPR)* (1 - p_FA3_EXPR)


# Probability of A2 when PFS, conditional on surviving, under standard of care
p_FA1_SoC  <- (p_PFS_SoC) * p_FA1_STD
# Probability of going from A2 to death
p_A1D_SoC  <- 0.001 

# Probability of A2 when PFS, conditional on surviving, under standard of care
p_FA2_SoC  <- (p_PFS_SoC) * p_FA2_STD
# Probability of going from A2 to death
p_A2D_SoC  <- 0.001 
# Probability of returning from A2 to PFS is 100% minus the people who have gone into the dead state.
p_A2F_SoC  <- 1-p_A2D_SoC

# Probability of A3 when PFS, conditional on surviving, under standard of care
p_FA3_SoC  <- (p_PFS_SoC) * p_FA3_STD
# Probability of going from A3 to death.
p_A3D_SoC  <- 0.001 
# Probability of returning from A3 to PFS is 100% minus the people who have gone into the dead state.
p_A3F_SoC  <- 1-p_A3D_SoC



# Probability of A1 when PFS, conditional on surviving, under standard of care
p_FA1_EXPR <- (p_PFS_Exp) * p_FA1_EXPR
# Probability of going from A1 to death.
p_A1D_Exp  <- 0.001 
# Probability of returning from A1 to PFS is 100% minus the people who have gone into the dead state.
p_A1F_Exp  <- 1-p_A1D_Exp

# Probability of A2 when PFS, conditional on surviving, under standard of care
p_FA2_Exp  <- (p_PFS_Exp) * p_FA2_EXPR
# Probability of going from A2 to death.
p_A2D_Exp  <- 0.001 
# Probability of returning from A2 to PFS is 100% minus the people who have gone into the dead state.
p_A2F_Exp  <- 1-p_A2D_Exp

# Probability of A3 when PFS, conditional on surviving, under standard of care
p_FA3_Exp  <- (p_PFS_Exp) * p_FA3_EXPR
# Probability of going from A3 to death.
p_A3D_Exp  <- 0.001 
# Probability of returning from A3 to PFS is 100% minus the people who have gone into the dead state.
p_A3F_Exp  <- 1-p_A3D_Exp


## Health State Values (AKA State rewards)
# Costs and utilities  


# Costs

c_PFS_Folfox <-307.81
c_PFS_Bevacizumab <-2580.38
c_OS_Folfiri <-326.02
administration_cost <- 365.00


c_F_SoC       <- administration_cost + c_PFS_Folfox  # cost of one cycle in PFS state under standard of care
c_F_Exp       <- administration_cost + c_PFS_Folfox + c_PFS_Bevacizumab # cost of one cycle in PFS state under the experimental treatment 
c_P       <- c_OS_Folfiri  + administration_cost# cost of one cycle in progression state (I assume in OS everyone gets the same treatment so it costs everyone the same to be treated).
c_D       <- 0     # cost of one cycle in dead state

# We define the costs of the adverse events:

# Leukopenia = AE1 Diarrhea = AE2 Vomiting = AE3

c_AE1 <- 2835.89
c_AE2 <- 1458.80
c_AE3 <- 409.03

# Then we define the utilities per health states.


u_F       <- 0.850     # utility when PFS 
u_P       <- 0.650   # utility when OS
u_D       <- 0     # utility when dead


# We define the utilities in the adverse event states as a percentage lower utility for has the cycle of the PFS state:

daily_utility <- u_F/14
AE1_discounted_daily_utility <- daily_utility * (1-0.45)
AE2_discounted_daily_utility <- daily_utility * (1-0.19)
AE3_discounted_daily_utility <- daily_utility * (1-0.36)


u_AE1 <- (AE1_discounted_daily_utility*7) + (daily_utility*7)
u_AE2 <- (AE2_discounted_daily_utility*7) + (daily_utility*7)
u_AE3 <- (AE3_discounted_daily_utility*7) + (daily_utility*7)



# Discounting factors
d_c             <- 0.04                          
# discount rate for costs (per year)
d_e             <- 0.04                          
# discount rate for QALYs (per year)






# Initialize matrices to store the Markov cohort traces for each strategy

# - note that the number of rows is n_cycle + 1, because R doesn't use index 0 (i.e. cycle 0)  --> What we mean here, is that when we do our calculations later they need to be for cycle-1 to reflect cycle 0.
m_M_SoC <- m_M_Exp  <-  matrix(
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
m_M_SoC[1, "Dead"]<- m_M_Exp[1, "Dead"]  <- 0

# Inspect whether properly defined
# head(m_M_SoC)
# head(m_M_Exp)
#head(m_M_Exp_trtB)



# Initialize matrices for the transition probabilities
# - note that these are now 3-dimensional matrices (so, above we originally included dim = nrow and ncol, but now we also include n_cycle - i.e. the number of cycles).
# - starting with standard of care
m_P_SoC <- array(
  data = 0,
  dim = c(n_states, n_states, n_cycle),
  dimnames = list(v_names_states, v_names_states, paste0("Cycle", 1:n_cycle))
  # define row and column names - then name each array after which cycle it's for, i.e. cycle 1 all the way through to cycle 143. So Cycle 1 will have all of our patients in PFS, while cycle 143 will have most people in the dead state.
)

# head(m_P_SoC)


m_P_Exp <- array(
  data = 0,
  dim = c(n_states, n_states, n_cycle),
  dimnames = list(v_names_states, v_names_states, paste0("Cycle", 1:n_cycle))
  # define row and column names - then name each array after which cycle it's for, i.e. cycle 1 all the way through to cycle 143. So Cycle 1 will have all of our patients in PFS, while cycle 143 will have most people in the dead state.
)

# head(m_P_Exp)



# Setting the transition probabilities from PFS based on the model parameters
# So, when individuals are in PFS what are their probabilities of going into the other states that they can enter from PFS?

m_P_SoC["PFS", "PFS",]<- (1 -p_PFSOS_SoC) * (1 - p_PFSD_SoC)
m_P_SoC["PFS", "OS",]<- p_PFSOS_SoC*(1 - p_PFSD_SoC)
m_P_SoC["PFS", "Dead",]<-p_PFSD_SoC


# Setting the transition probabilities from OS
m_P_SoC["OS", "OS", ] <- 1 - p_FD_SoC
m_P_SoC["OS", "Dead", ]        <- p_FD_SoC

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
# I round my transition matrix so things sum exactly to 1, instead of 0.99999999:
round(m_P_SoC, digits=2) 
m_P_SoC


# This is a check in the DARTH tools package that all the transition probabilities are in [0, 1], i.e., no probabilities are greater than 100%.

check_transition_probability(m_P_SoC,  verbose = TRUE)
#check_transition_probability(m_P_Exp,  verbose = TRUE)
check_sum_of_transition_array(m_P_SoC,  n_states = n_states, n_cycles = n_cycle, verbose = TRUE)
# check_sum_of_transition_array(m_P_Exp,  n_states = n_states, n_cycles = n_cycle, verbose = TRUE)


for(i_cycle in 1:(n_cycle-1)) {
  m_M_SoC[i_cycle + 1, ] <- m_M_SoC[i_cycle, ] %*% m_P_SoC[ , , i_cycle]
}


head(m_M_SoC)  # print the first few lines of the matrix for standard of care (m_M_SoC)
#head(m_M_Exp)  # print the first few lines of the matrix for experimental treatment(m_M_Exp)












