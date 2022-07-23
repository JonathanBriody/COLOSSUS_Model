# Below I use a different source for my code to create a tornado diagram that includes ICERs to apply in cases where just generating an ICER in the oncologySemiMarkov_function and putting that in  outcomes = c("DSAICER"), doesnt work. 

# I source this code from: https://rpubs.com/mbounthavong/decision_tree_model_tutorial and https://raw.githubusercontent.com/mbounthavong/Decision_Analysis/master/tornado_diagram_code.R also saved here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\R Code\GitHub\COLOSSUS_Model\rpubs-com-mbounthavong-decision_tree_model_tutorial.pdf and here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\R Code\GitHub\COLOSSUS_Model\tornado_diagram_code.pdf

# First I generate the basecase values for some of the parameters that either don't exist in the data currently or that I want to assign different probabilities too.

p_PD  <- 0.05
p_FD  <- 0.02      
u_F <- 0.5
p_FD_SoC  <- 0.05
p_FD_Exp  <- 0.05

p_FA1_SoC  <- p_FA1_STD
p_FA2_SoC  <- p_FA2_STD
p_FA3_SoC  <- p_FA3_STD

# Then I generate a minimum and a maximum for these basecase values as below:

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


# Then I source the function I describe at the above for creating a tornado diagram. If it won't source properly I can always go in and run this R file manually and then go from the input section onwards.

source(file = "function_trial_tornado_code.R")

# I make an input data.frame which is the basecase values of the parameters I want to vary in my tornado diagram as below:

input <- data.frame(
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

# Below I just repeat the above for some reason (I may actually be able to delete this part as it's already done, rather than running it again).

################################
#### Data inputs (parameters)
################################
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


# Here I define the ranges of the parameters, filling in their basecase, minimum and maximum:

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


# Here I create "paramNames", with the names of all the parameters included:

## Parameter names
paramNames <-   c( "HR_FP_Exp", 
                   "HR_FP_SoC"
)

# I've commented out the names of the other parameters I might like to include, but left them below for simplicity's sake:

# , "p_PD", "p_FD_SoC", "p_FD_Exp", "p_FA1_SoC", "p_A1F_SoC", "p_A1D_SoC", "p_FA2_SoC", "p_A2F_SoC", "p_A2D_SoC", "p_FA3_SoC", "p_A3F_SoC", "p_A3D_SoC", "c_F_SoC", "c_F_Exp", "c_P","c_AE1", "c_AE2", "c_AE3", "d_e", "d_c", "u_F", "u_P", "u_AE1", "u_AE2", "u_AE3"

# I create a vector with a list of the inputs I've included. I want to make sure that:

# A. The number at the end of: l.tor.in <- vector("list", 2) matches the number of inputs that I am including. So here I am including 2, if I decide to include more, i.e., up to the 27, I'll need to update this, i.e. up to 27.

# B. Secondly, I need to include the inputs below in the same order as the inputs in the "input" data.frame I create above. i.e., ,     input[-1]) is the first input in this dataframe, ,     input[-2]) is the second input in this dataframe, and so on, so I need to make sure that I am matching things to where they appear in the dataframe, just like in the example code. 


# List of tornado inputs
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


# This is where things get tricky. You'll see that l.tor.in produces what it describes as "A data.frame with 3 rows and 2 columns". Where the types are lists and doubles:
# Which matches what is produced in the example code, which I saved here and can be run easily to confirm: https://rstudio.cloud/spaces/264142/content/4288190 if rstudio.cloud doesnt run for some reason, this can easily be run by taking the content from the online tutorial into R studio.

l.tor.in

# But, you'll see below that although l.tor.out matches the example code until the apply code, once we use the apply code l.tor.out creates Type as "character" and quotation marks around the input values. Whereas in the example code, this is type "double" and has values not within quotation marks.


## List of tornado outputs

# Again, the number at the end of: l.tor.in <- vector("list", 2) matches the number of inputs that I am including. So here I am including 2, if I decide to include more, i.e., up to the 27, I'll need to update this, i.e. up to 27.


l.tor.out <- vector("list", 2)
names(l.tor.out) <- paramNames
l.tor.out

# To combat this, I can manually enter the values that I need for BaseCase, low and high. 

# To get these values in the first place to enter manually I need to generate them as quotation values below:



# Again, the number at the end of: l.tor.in <- vector("list", 2) matches the number of inputs that I am including. So here I am including 2, if I decide to include more, i.e., up to the 27, I'll need to update this, i.e. up to 27.

nul.tor.out <- vector("list", 2)
names(nul.tor.out) <- paramNames
nul.tor.out

## Run model on different parameters 
# NOTE: we select [ , 7] because that is the location of the ICER output in the oncologySemiMarkov function, i.e., it's the seventh value in return(c(v_names_strats, v_tc_d, v_tu_d, DSA_ICER)).

# When I'm applying this to however many parameters I'm including I'll need to update for(i in 1:2){ from :2 (which is how many I look at here) to :however many I go to, so update this to for(i in 1:27){ if I end up including the 27 parameters I have commented out above.
for(i in 1:2){
nul.tor.out[[i]] <- t(apply(l.tor.in[[i]], 1, oncologySemiMarkov))[, 7] 
}

nul.tor.out

# They should be reported from the nul.tor.out and then I can take the values from these and plug them in manually below (I can probably use something like the following to select the BaseCase, low and high automatically and have less reading of results and manual entering, etc., to do: l.tor.out$HR_FP_Exp    <- cbind(HR_FP_Exp   = nuHR_FP_Exp_range,     input[-1])):

l.tor.out[["HR_FP_Exp"]]<- c(BaseCase = 7639.83194526294,    low = 5712.92771714879,  high = 11170.766462452)
l.tor.out[["HR_FP_SoC"]]<- c(BaseCase = 7639.83194526294,    low = 12612.101545163,  high = 5960.03424418494)

# Which, as you'll see, gives us the same type and value layout as in the example code.

l.tor.out

# Then I need to create the matrix for the tornado diagram, with the mean (basecase), min (low) and max (high). 

## Data structure: ymean, ymin, ymax
# Here, I need to make sure that nrow reflects the number of parameters I'm including, like in nul.tor.out above, if I'm going with 2 parameters I'll need 2 rows. But, if I'm going with 27 parameters then I'll need 27 rows. Because the columns just reflect basecase, low and high, the column number of 3 is perfect regardless of the number of rows. 
m.tor <- matrix(unlist(l.tor.out), nrow = 2, ncol = 3, byrow = TRUE, 
                dimnames = list(paramNames, c("basecase", "low", "high")))

# If I decide to go this route, the last thing I need to do is figure out which coloured box is low and which coloured box is high in the outputted diagram, and to go through function_trial_tornado_code.r possibly renaming it so that the function is at the end and R will recognise it as a function and definitely seeing if I need to re-write any bits to make the code more my own and to see if there are sections that might explain what the function is doing and what coloured boxes are for what outcome.


TornadoPlot(main_title = "Tornado Plot", Parms = paramNames, Outcomes = m.tor, 
            outcomeName = "Incremental Cost-Effectiveness Ratio (ICER)", 
            xlab = "ICER", 
            ylab = "Parameters", 
            col1="#3182bd", col2="#6baed6")
