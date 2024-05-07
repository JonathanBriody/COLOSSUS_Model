# 09.1 Conduct probabilistic sensitivity analysis

# Running the probabilistic analysis :

# First we need to create data.frames to store the output from the PSA:

df_c <- df_e <- data.frame(
SoC = rep(NA, n_runs),
Exp = rep(NA, n_runs)
)
 
df_DSAICER <- data.frame(
SoC = rep(NA, n_runs),
Exp = rep(NA, n_runs)
)


# Of course the DSAICER is going to be the same for SOC and Exp because only one ICER is ever created, but I just didnt know if this would work if I only created a data frame for SoC or Exp and not both, and this was quite a quick and dirty way of calculating the ICERs. 


# As you'll see, first we make blank (repeat NA for the number of runs of the simulationn_runs) data.frames for costs (df_c) and effectiveness (df_e) for SoC and the experimental treatment:

head(df_c)

# > head(df_c)
#   SoC Exp
# 1  NA  NA
# 2  NA  NA
# 3  NA  NA
# 4  NA  NA
# 5  NA  NA
# 6  NA  NA

head(df_e)

# > head(df_e)
#   SoC Exp
# 1  NA  NA
# 2  NA  NA
# 3  NA  NA
# 4  NA  NA
# 5  NA  NA
# 6  NA  NA

# We run the Markov model for each set of parameter values from the PSA input dataset (a set of parameters here is the row of parameter values in the PSA data.frame from whatever run number of the nruns in the PSA dataset we are on, i.e. if we were doing this for run number 10 out of 10,000, we would be on row 10 in the data.frame (as each row refers to a run) and we would use all the values for costs and effect that appear in this row when running the Markov model. So, we would be using all the random draws for that PSA run in the Markov model).

# - I read a note indicating that this loop can be run in parallel to decrease the runtime, something to consider in the future if it takes a very long time...

for(i_run in 1:n_runs){
  
  # Evaluate the model and store the outcomes
  l_out_temp    <- oncologySemiMarkov(l_params_all = df_PA_input[i_run, ], n_wtp = n_wtp)
  # The above is basically saying, apply the oncologySemiMarkov_function, where l_params_all in the function (i.e. the list of parameters the function is to be applied to) is equal to the parameters from the PSA data.frame for the run we are in, and the willingness to pay threshold is n_wtp.
  df_c[i_run, ] <- l_out_temp$Cost
  df_e[i_run, ] <- l_out_temp$Effect
  df_DSAICER[i_run, ] <- l_out_temp$DSAICER
  
  # The above says, for the costs and effectiveness data.frames, store the value of costs and effects for each run that we are on in a row that reflects that run (remembering that [ROW,COLUMN], we are putting each cost and effect in a row that relates to the number of the run we are on, so if we are on run 1, i_run = 1 and we store the costs and effects for that run 1 in row 1. Remembering that our oncologySemiMarkov makes the "Cost" and "Effect" parameters at the end of the function, after applying the Markov cost-effectiveness model to all our input data for the cost-effectiveness model (so, things like, cost, utility and probability), so we are just pulling the ouputted Cost and Effect values calculated from a Markov cost-effectiveness model applied to our input data after the input data has been randomly drawn from a PSA (per the PSA input dataframe)).  
  
  
  # While we're doing this, we might like to display the progress of the simulation:
  if(i_run/(n_runs/10) == round(i_run/(n_runs/10), 0)) { # We've chosen to display progress every 10%
    cat('\r', paste(i_run/n_runs * 100, "% done", sep = " "))
  }
}
   
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


# SO, i NEED TO COME IN HERE AND SAY, HOW MANY ICERS ARE BELOW THE WTP THRESHOLD AND THEN WHAT IS THAT AS A PROPPORTION OF THE NUMBER OF RUNS (BECAUSE THE NUMBER OF RUNS ARE THE NUMBER OF SIMULATIONS) AND THEN OUTPUT A NOTEPAD FILE THAT SAYS "X PERCENT OF ICERS ARE BELOW THE WILLINGNESS TO PAY FOR Y COUNTRY" IN A NOTEPAD THAT IS CALLED "PERCENTAGE OF ICERS BELOW THE WILLINGNESS TO PAY FOR Y COUNTRY".

# I should also report just the general number of ICERs that are below the WTP as: "This is the number of ICERs from the simulation that are below the Willingness to Pay: ", so that I can manually calculate percentages as necessary.

# And report the 50 lowest ICERs to know that when none are reported as below the threshold, that I can eyeball this to be correct and also just to see how far I am from this in general:

# Reporting the DSAICER for SOC and EXP makes a mess of the below calculations, because it's doubled up as it's recored for both SoC and EXP, so it's percentage of number of runs will be doubled, and the number of ICERs reported below the WTP will also be doubled, so I have to correct this as below:


# > DSAICER
# parameter         strategy param_val outcome_val
# 1  HR_FP_Exp Standard.of.Care    0.5300      107460
# 2  HR_FP_Exp Standard.of.Care    0.5334      107512
# 3  HR_FP_Exp Standard.of.Care    0.5369      107563
# 4  HR_FP_Exp Standard.of.Care    0.5403      107614
# 5  HR_FP_Exp Standard.of.Care    0.5437      107665
# 6  HR_FP_Exp Standard.of.Care    0.5472      107717
# 7  HR_FP_Exp Standard.of.Care    0.5506      107769
# 8  HR_FP_Exp Standard.of.Care    0.5540      107820
# 9  HR_FP_Exp Standard.of.Care    0.5575      107872
# 10 HR_FP_Exp Standard.of.Care    0.5609      107924
# 11 HR_FP_Exp Standard.of.Care    0.5643      107977
# 12 HR_FP_Exp Standard.of.Care    0.5678      108029


# I remove everything for standard of care as below, because it's a singular ICER reported twice I could have likewise deleted everything for the Experimental Strategy.

DSAICER <- DSAICER[DSAICER$strategy != "Standard.of.Care", ]



# Calculate the number of DSAICER outcome_val values less than or equal to n_wtp
num_values <- sum(DSAICER$outcome_val <= n_wtp)
num_values

# Calculate the percentage of DSAICER outcome_val values less than or equal to n_wtp
percentage <- (num_values / n_runs) * 100
percentage

# Get the 50 lowest outcome_val values from DSAICER
lowest_values <- sort(DSAICER$outcome_val)[1:50]
lowest_values

# Create the report
report <- paste0("In the PSA ", num_values, " of the ICERs produced by the PSA are less than or equal to the threshold for the WTP for ", country_name, "\n",
                 "That means, in the PSA ", round(percentage, 4), "% of the ICERs produced by the PSA are less than or equal to the threshold for the WTP for ", country_name, "\n",
"The 50 lowest ICER values from DSAICER were: ", paste(lowest_values, collapse = ", "))


# Write the report to a notepad document
writeLines(report, con = paste0("Percentage_PSA_ICERS_Below_WTP_", country_name, ".txt"))


# I checked the above calculations manually using the below and got the same results:

# write.csv(DSAICER,'DSAICER.csv')















