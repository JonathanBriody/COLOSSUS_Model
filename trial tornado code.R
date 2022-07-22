p_PD  <- 0.05
p_FD  <- 0.02      
u_F <- 0.5
p_FD_SoC  <- 0.05
p_FD_Exp  <- 0.05

p_FA1_SoC  <- p_FA1_STD
p_FA2_SoC  <- p_FA2_STD
p_FA3_SoC  <- p_FA3_STD



# Hazard Ratios:


HR_FP_Exp

Minimum_HR_FP_Exp <- HR_FP_Exp - 0.20*HR_FP_Exp
Maximum_HR_FP_Exp <- HR_FP_Exp + 0.20*HR_FP_Exp



HR_FP_SoC

Minimum_HR_FP_SoC <- HR_FP_SoC - 0.20*HR_FP_SoC
Maximum_HR_FP_SoC <- HR_FP_SoC + 0.20*HR_FP_SoC

# Probability of progressive disease to death:

p_PD

Minimum_p_PD <- p_PD - 0.20*p_PD
Maximum_p_PD <- p_PD + 0.20*p_PD

# Under the assumption that everyone will get the same second line therapy, I give them all the same probability of going from progessed (i.e., OS) to dead, and thus only need to include p_PD here once - because it is applied in oncologySemiMarkov_function.R for both SoC and Exp.


# Probability of going from PFS to Death states under the standard of care treatment and the experimental treatment:

p_FD_SoC

Minimum_p_FD_SoC <- p_FD_SoC - 0.20*p_FD_SoC
Maximum_p_FD_SoC <- p_FD_SoC + 0.20*p_FD_SoC

p_FD_Exp

Minimum_p_FD_Exp<- p_FD_Exp - 0.20*p_FD_Exp
Maximum_p_FD_Exp <- p_FD_Exp + 0.20*p_FD_Exp



# Probability of Adverse Events, from PFS to AE, from AE to PFS and from AE to Death:

# Although these probabilities say _SoC, I make the assumption that everyone has the same probability of AE1, 2 or 3 regardless of what treatment they are under (i.e., SoC or the Experimental). If I decide to get more complicated with treatment specific AE probabilities in the future I can update this to be _SoC and _Exp.


p_FA1_SoC
Minimum_p_FA1_SoC <- p_FA1_SoC - 0.20*p_FA1_SoC
Maximum_p_FA1_SoC <- p_FA1_SoC + 0.20*p_FA1_SoC

p_A1F_SoC
Minimum_p_A1F_SoC <- p_A1F_SoC - 0.20*p_A1F_SoC
Maximum_p_A1F_SoC <- p_A1F_SoC + 0.20*p_A1F_SoC


p_A1D_SoC
Minimum_p_A1D_SoC <- p_A1D_SoC - 0.20*p_A1D_SoC
Maximum_p_A1D_SoC <- p_A1D_SoC + 0.20*p_A1D_SoC

p_FA2_SoC
Minimum_p_FA2_SoC <- p_FA2_SoC - 0.20*p_FA2_SoC
Maximum_p_FA2_SoC <- p_FA2_SoC + 0.20*p_FA2_SoC

p_A2F_SoC
Minimum_p_A2F_SoC <- p_A2F_SoC - 0.20*p_A2F_SoC
Maximum_p_A2F_SoC <- p_A2F_SoC + 0.20*p_A2F_SoC

p_A2D_SoC
Minimum_p_A2D_SoC <- p_A2D_SoC - 0.20*p_A2D_SoC
Maximum_p_A2D_SoC <- p_A2D_SoC + 0.20*p_A2D_SoC

p_FA3_SoC
Minimum_p_FA3_SoC <- p_FA3_SoC - 0.20*p_FA3_SoC
Maximum_p_FA3_SoC <- p_FA3_SoC + 0.20*p_FA3_SoC

p_A3F_SoC
Minimum_p_A3F_SoC <- p_A3F_SoC - 0.20*p_A3F_SoC
Maximum_p_A3F_SoC <- p_A3F_SoC + 0.20*p_A3F_SoC

p_A3D_SoC
Minimum_p_A3D_SoC <- p_A3D_SoC - 0.20*p_A3D_SoC
Maximum_p_A3D_SoC <- p_A3D_SoC + 0.20*p_A3D_SoC


#install.packages("Rmpfr")
#library(Rmpfr)

# 
# Minimum_p_A1D_SoC <- mpfr(Minimum_p_A1D_SoC,200) # set arbitrary precision that's greater than R default
# Maximum_p_A1D_SoC <- mpfr(Maximum_p_A1D_SoC,200) # set arbitrary precision that's greater than R default
# 
# 
# Minimum_p_A2D_SoC <- mpfr(Minimum_p_A2D_SoC,200) # set arbitrary precision that's greater than R default
# Maximum_p_A2D_SoC <- mpfr(Maximum_p_A2D_SoC,200) # set arbitrary precision that's greater than R default
# 
# Minimum_p_A3D_SoC <- mpfr(Minimum_p_A3D_SoC,200) # set arbitrary precision that's greater than R default
# Maximum_p_A3D_SoC <- mpfr(Maximum_p_A3D_SoC,200) # set arbitrary precision that's greater than R default




# Cost:

# If I decide to include the cost of the test for patients I will also need to include this in the sensitivity analysis here:

c_F_SoC

Minimum_c_F_SoC <- c_F_SoC - 0.20*c_F_SoC
Maximum_c_F_SoC <- c_F_SoC + 0.20*c_F_SoC

c_F_Exp

Minimum_c_F_Exp  <- c_F_Exp - 0.20*c_F_Exp
Maximum_c_F_Exp  <- c_F_Exp + 0.20*c_F_Exp

c_P 

Minimum_c_P  <- c_P - 0.20*c_P
Maximum_c_P  <- c_P + 0.20*c_P

c_D  

Minimum_c_D  <- c_D - 0.20*c_D
Maximum_c_D  <- c_D + 0.20*c_D

c_AE1

Minimum_c_AE1  <- c_AE1 - 0.20*c_AE1
Maximum_c_AE1  <- c_AE1 + 0.20*c_AE1

c_AE2

Minimum_c_AE2  <- c_AE2 - 0.20*c_AE2
Maximum_c_AE2  <- c_AE2 + 0.20*c_AE2

c_AE3

Minimum_c_AE3  <- c_AE3 - 0.20*c_AE3
Maximum_c_AE3  <- c_AE3 + 0.20*c_AE3


# Utilities:


u_F

Minimum_u_F <- u_F - 0.20*u_F
Maximum_u_F <- u_F + 0.20*u_F 


u_P

Minimum_u_P <- u_P - 0.20*u_P
Maximum_u_P <- u_P + 0.20*u_P 


u_D

Minimum_u_D <- u_D - 0.20*u_D
Maximum_u_D <- u_D + 0.20*u_D 


u_AE1

Minimum_u_AE1 <- u_AE1 - 0.20*u_AE1
Maximum_u_AE1 <- u_AE1 + 0.20*u_AE1 


u_AE2

Minimum_u_AE2 <- u_AE2 - 0.20*u_AE2
Maximum_u_AE2 <- u_AE2 + 0.20*u_AE2 


u_AE3

Minimum_u_AE3 <- u_AE3 - 0.20*u_AE3
Maximum_u_AE3 <- u_AE3 + 0.20*u_AE3 


# Discount factor
# Cost Discount Factor
# Utility Discount Factor


d_e

Minimum_d_e <- d_e - 0.20*d_e
Maximum_d_e <- d_e + 0.20*d_e



d_c

Minimum_d_c <- d_c - 0.20*d_c
Maximum_d_c <- d_c + 0.20*d_c

source(file = "function_trial_tornado_code.R")


input <- data.frame(
  # coef_weibull_shape_SoC = coef_weibull_shape_SoC,
  # coef_weibull_scale_SoC = coef_weibull_scale_SoC,
  HR_FP_Exp = HR_FP_Exp,
  HR_FP_SoC = HR_FP_SoC
  # p_FD      = p_FD,      
  # p_PD      = p_PD,
  # p_A1F_SoC = p_A1F_SoC,
  # p_A1D_SoC = p_A1D_SoC,
  # p_A2F_SoC = p_A2F_SoC,
  # p_A2D_SoC = p_A2D_SoC,
  # p_A3F_SoC = p_A3F_SoC,
  # p_A3D_SoC = p_A3D_SoC,
  # p_FD_SoC  = p_FD_SoC,
  # p_FD_Exp  = p_FD_Exp,
  # p_PD_SoC = p_PD_SoC,
  # p_PD_Exp = p_PD_Exp,
  # p_FA1_SoC = p_FA1_SoC,
  # p_FA2_SoC = p_FA2_SoC,
  # p_FA3_SoC = p_FA3_SoC,
  # c_F_SoC   = c_F_SoC  
  # c_F_Exp   = c_F_Exp,
  # c_P       = c_P,  
  # c_D       = c_D,    
  # c_AE1 = c_AE1,
  # c_AE2 = c_AE2,
  # c_AE3 = c_AE3,
  # u_F = u_F,   
  # u_P = u_P,   
  # u_D = u_D,  
  # u_AE1 = u_AE1,
  # u_AE2 = u_AE2,
  # u_AE3 = u_AE3,
  # d_e       = d_e,  
  # d_c       = d_c
)









################################
#### Data inputs (parameters)
################################
coef_weibull_shape_SoC = coef_weibull_shape_SoC
coef_weibull_scale_SoC = coef_weibull_scale_SoC
HR_FP_Exp = HR_FP_Exp
HR_FP_SoC = HR_FP_SoC
# p_FD      = p_FD      
# p_PD      = p_PD
# p_A1F_SoC = p_A1F_SoC
# p_A1D_SoC = p_A1D_SoC
# p_A2F_SoC = p_A2F_SoC
# p_A2D_SoC = p_A2D_SoC
# p_A3F_SoC = p_A3F_SoC
# p_A3D_SoC = p_A3D_SoC
# p_FD_SoC  = p_FD_SoC
# p_FD_Exp  = p_FD_Exp
# p_PD_SoC = p_PD_SoC
# p_PD_Exp = p_PD_Exp
# p_FA1_SoC = p_FA1_SoC
# p_FA2_SoC = p_FA2_SoC
# p_FA3_SoC = p_FA3_SoC
# c_F_SoC   = c_F_SoC  
# c_F_Exp   = c_F_Exp
# c_P       = c_P  
# c_D       = c_D    
# c_AE1 = c_AE1
# c_AE2 = c_AE2
# c_AE3 = c_AE3
# u_F = u_F   
# u_P = u_P   
# u_D = u_D  
# u_AE1 = u_AE1
# u_AE2 = u_AE2
# u_AE3 = u_AE3
# d_e       = d_e  
# d_c       = d_c


########################
#### Tornado Plot #2
########################
# Define ranges 
HR_FP_Exp_range     <- c(BaseCase = HR_FP_Exp,    low = Minimum_HR_FP_Exp,  high = Maximum_HR_FP_Exp)
HR_FP_SoC_range     <- c(BaseCase = HR_FP_SoC,    low = Minimum_HR_FP_SoC,  high = Maximum_HR_FP_SoC)
# p_PD_range     <- c(BaseCase = p_PD,    low = Minimum_p_PD,  high = Maximum_p_PD)
# p_FD_SoC_range     <- c(BaseCase = p_FD_SoC,    low = Minimum_p_FD_SoC,  high = Maximum_p_FD_SoC)
# p_FD_Exp_range     <- c(BaseCase = p_FD_Exp,    low = Minimum_p_FD_Exp,  high = Maximum_p_FD_Exp)
# p_FA1_SoC_range     <- c(BaseCase = p_FA1_SoC,    low = Minimum_p_FA1_SoC,  high = Maximum_p_FA1_SoC)
# p_A1F_SoC_range     <- c(BaseCase = p_A1F_SoC,    low = Minimum_p_A1F_SoC,  high = Maximum_p_A1F_SoC)
# p_A1D_SoC_range     <- c(BaseCase = p_A1D_SoC,    low = Minimum_p_A1D_SoC,  high = Maximum_p_A1D_SoC)
# p_FA2_SoC_range     <- c(BaseCase = p_FA2_SoC,    low = Minimum_p_FA2_SoC,  high = Maximum_p_FA2_SoC)
# p_A2F_SoC_range     <- c(BaseCase = p_A2F_SoC,    low = Minimum_p_A2F_SoC,  high = Maximum_p_A2F_SoC)
# p_A2D_SoC_range     <- c(BaseCase = p_A2D_SoC,    low = Minimum_p_A2D_SoC,  high = Maximum_p_A2D_SoC)
# p_FA3_SoC_range     <- c(BaseCase = p_FA3_SoC,    low = Minimum_p_FA3_SoC,  high = Maximum_p_FA3_SoC)
# p_A3F_SoC_range     <- c(BaseCase = p_A3F_SoC,    low = Minimum_p_A3F_SoC,  high = Maximum_p_A3F_SoC)
# p_A3D_SoC_range     <- c(BaseCase = p_A3D_SoC,    low = Minimum_p_A3D_SoC,  high = Maximum_p_A3D_SoC)
# c_F_SoC_range     <- c(BaseCase = c_F_SoC,    low = Minimum_c_F_SoC,  high = Maximum_c_F_SoC )
# c_F_Exp_range     <- c(BaseCase = c_F_Exp,    low = Minimum_c_F_Exp,  high = Maximum_c_F_Exp )
# c_P_range     <- c(BaseCase = c_P,    low = Minimum_c_P,  high = Maximum_c_P )
# c_AE1_range     <- c(BaseCase = c_AE1,    low = Minimum_c_AE1,  high = Maximum_c_AE1 )
# c_AE2_range     <- c(BaseCase = c_AE2,    low = Minimum_c_AE2,  high = Maximum_c_AE2 )
# c_AE3_range     <- c(BaseCase = c_AE3,    low = Minimum_c_AE3,  high = Maximum_c_AE3 )
# d_e_range     <- c(BaseCase = d_e,    low = Minimum_d_e,  high = Maximum_d_e )
# d_c_range     <- c(BaseCase = d_c,    low = Minimum_d_c,  high = Maximum_d_c )
# u_F_range     <- c(BaseCase = u_F,    low = Minimum_u_F,  high = Maximum_u_F )
# u_P_range     <- c(BaseCase = u_P,    low = Minimum_u_P,  high = Maximum_u_P )
# u_AE1_range     <- c(BaseCase = u_AE1,    low = Minimum_u_AE1,  high = Maximum_u_AE1 )
# u_AE2_range     <- c(BaseCase = u_AE2,    low = Minimum_u_AE2,  high = Maximum_u_AE2 )
# u_AE3_range     <- c(BaseCase = u_AE3,    low = Minimum_u_AE3,  high = Maximum_u_AE3 )



## Parameter names
paramNames <-   c( "HR_FP_Exp", 
                   "HR_FP_SoC"
)



# , "p_PD", "p_FD_SoC", "p_FD_Exp", "p_FA1_SoC", "p_A1F_SoC", "p_A1D_SoC", "p_FA2_SoC", "p_A2F_SoC", "p_A2D_SoC", "p_FA3_SoC", "p_A3F_SoC", "p_A3D_SoC", "c_F_SoC", "c_F_Exp", "c_P","c_AE1", "c_AE2", "c_AE3", "d_e", "d_c", "u_F", "u_P", "u_AE1", "u_AE2", "u_AE3"

# List of inputs
l.tor.in <- vector("list", 2)
names(l.tor.in) <- paramNames
l.tor.in$HR_FP_Exp    <- cbind(HR_FP_Exp   = HR_FP_Exp_range,     input[-1])
l.tor.in$HR_FP_SoC    <- cbind(HR_FP_SoC   = HR_FP_SoC_range,     input[-2])
# l.tor.in$p_PD    <- cbind(p_PD   = p_PD_range,     input[-3])
# l.tor.in$p_FD_SoC    <- cbind(p_FD_SoC   = p_FD_SoC_range,     input[-4])
# l.tor.in$p_FD_Exp    <- cbind(p_FD_Exp   = p_FD_Exp_range,     input[-5])
# l.tor.in$p_FA1_SoC    <- cbind(p_FA1_SoC   = p_FA1_SoC_range,     input[-6])
# l.tor.in$p_A1F_SoC    <- cbind(p_A1F_SoC   = p_A1F_SoC_range,     input[-7])
# l.tor.in$p_A1D_SoC    <- cbind(p_A1D_SoC   = p_A1D_SoC_range,     input[-8])
# l.tor.in$p_FA2_SoC    <- cbind(p_FA2_SoC   = p_FA2_SoC_range,     input[-9])
# l.tor.in$p_A2F_SoC    <- cbind(p_A2F_SoC   = p_A2F_SoC_range,     input[-10])
# l.tor.in$p_A2D_SoC    <- cbind(p_A2D_SoC   = p_A2D_SoC_range,     input[-11])
# l.tor.in$p_FA3_SoC    <- cbind(p_FA3_SoC   = p_FA3_SoC_range,     input[-12])
# l.tor.in$p_A3F_SoC    <- cbind(p_A3F_SoC   = p_A3F_SoC_range,     input[-13])
# l.tor.in$p_A3D_SoC    <- cbind(p_A3D_SoC   = p_A3D_SoC_range,     input[-14])
# l.tor.in$c_F_SoC    <- cbind(c_F_SoC   = c_F_SoC_range,     input[-15])
# l.tor.in$c_F_Exp    <- cbind(c_F_Exp= c_F_Exp_range,     input[-16])
# l.tor.in$c_P    <- cbind(c_P   = c_Pc_AE1_range,     input[-17])
# l.tor.in$c_AE1    <- cbind(c_AE1   = c_Pc_AE1_range,     input[-18])
# l.tor.in$c_AE2    <- cbind(c_AE2   = c_AE2_range,     input[-19])
# l.tor.in$c_AE3    <- cbind(c_AE3   = c_AE3_range,     input[-20])
# l.tor.in$d_e    <- cbind(d_e   = d_e_range,     input[-21])
# l.tor.in$d_c    <- cbind(d_c   = d_c_range,     input[-22])
# l.tor.in$u_F    <- cbind(u_F   = u_F_range,     input[-23])
# l.tor.in$u_P    <- cbind(u_P   = u_P_range,     input[-24])
# l.tor.in$u_AE1    <- cbind(u_AE1   = u_AE1_range,     input[-25])
# l.tor.in$u_AE2    <- cbind(u_AE2   = u_AE2_range,     input[-26])
# l.tor.in$u_AE3    <- cbind(u_AE3   = u_AE3_range,     input[-27])
# 
#                          


## List of outputs
l.tor.out <- vector("list", 2)
names(l.tor.out) <- paramNames
#l.tor.out$HR_FP_Exp    <- cbind(HR_FP_Exp   = HR_FP_Exp_range,     input[-1])
# l.tor.out$HR_FP_SoC    <- cbind(HR_FP_SoC   = HR_FP_SoC_range,     input[-2])
l.tor.out

l.tor.out[["HR_FP_Exp"]]<- c(BaseCase = 7639.83194526294,    low = 5712.92771714879,  high = 11170.766462452)
l.tor.out[["HR_FP_SoC"]]<- c(BaseCase = 7639.83194526294,    low = 12612.101545163,  high = 5960.03424418494)
l.tor.out




nul.tor.out <- vector("list", 2)
names(nul.tor.out) <- paramNames
nul.tor.out
## Run model on different parameters 
# NOTE: we select [ , 7] because that is the location of the ICER output.
for(i in 1:2){
  nul.tor.out[[i]] <- t(apply(l.tor.in[[i]], 1, oncologySemiMarkov))[, 7] 
}

nul.tor.out

nuHR_FP_Exp_range     <- c(BaseCase = 7639.83194526294,    low = 5712.92771714879,  high = 11170.766462452)
nuHR_FP_SoC_range     <- c(BaseCase = 7639.83194526294,    low = 12612.101545163,  high = 5960.03424418494)


l.tor.out$HR_FP_Exp    <- cbind(HR_FP_Exp   = nuHR_FP_Exp_range,     input[-1])
l.tor.out$HR_FP_SoC    <- cbind(HR_FP_SoC   = nuHR_FP_SoC_range,     input[-2])
l.tor.out



## Data structure: ymean, ymin, ymax
m.tor <- matrix(unlist(l.tor.out), nrow = 2, ncol = 3, byrow = TRUE, 
                dimnames = list(paramNames, c("basecase", "low", "high")))


TornadoPlot(main_title = "Tornado Plot", Parms = paramNames, Outcomes = m.tor, 
            outcomeName = "Incremental Cost-Effectiveness Ratio (ICER)", 
            xlab = "ICER", 
            ylab = "Parameters", 
            col1="#3182bd", col2="#6baed6")
