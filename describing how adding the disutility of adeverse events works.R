# Why this equation makes sense to add adverse events to our model:

# In R I create the following to study how an adverse event, think of this like a toxicity such as vomiting, decreases the utility of health studied during a 14 day cycle

# p_AE1     <- 1   # The probability of adverse event 1 occuring during each 14 day cycle is 100%.

# There is a percentage utility reduction of the adverse event of 50%, which I code in as below:

# AE1_Percent_Util_Dec <-0.50

#  I create my utility in the health state for each cycle before any adverse events as below:

# U_First_Line <- 1 # That is, it is 100%

# I figure out what the disutility of the adverse event is as below:

# DisUtil_AE1 <- AE1_Percent_Util_Dec *U_First_Line

# DisUtil_AE1
# [1] 0.5 - That is, it decreases your utility in the first line health state by 50%

# However, this disutility doesnt last for the duration of the cycle, it only lasts for 5 out of the 14 days of the cycle

# Duration_AE <- 5/14

# So, below I calculate the utility in the first line health state as the utility before you have an adverse event minus the probability of that adverse event multiplied by the disutility of that adverse event, multiplied by the duration of that adverse event:

# U_First_Line_with_AEs<-U_First_Line-p_AE1*DisUtil_AE1*Duration_AE

# U_First_Line_with_AEs
#[1] 0.8214

# I get the above result, that is, your U_First_Line has decreased from 1 to 0.8214.

# And, when I tried to think through this myself I reached the exact same conclusion.

# I felt that with 14 days in each cycle and the adverse event lasting for 5 days, you would have 9 days of perfect health: 

# 1+1+1+1+1+1+1+1+1
# [1] 9

# And 5 days of half health: 0.5

# Adding 9 days of 1 and 5 days of 0.5 I get the following:

# 1+1+1+1+1+1+1+1+1+0.5+0.5+0.5+0.5+0.5
# [1] 11.5

# If I divide how much health you accrue by how long you acrue it over then I get the following:

# 11.5/14
# [1] 0.8214

# If you had 14 days of perfect health your result would be the following:

# 14/14
# [1] 1


# I repeat and explain how this works for the following, where we can have multiple adverse events:

# p_AE1     <- 1   # probability of adverse event 1
# p_AE2     <- 1  # probability of adverse event 2
# p_AE3     <- 1   # probability of adverse event 3

# I code the percentage utility reduction of the adverse events as below:

# !!! Important to note here, you can of course have all 3 adverse events in the same cycle, so it's important to be careful with the percentage utility decrement, if I used the 50% decrement above and applied it here, then anyone who had all 3 adverse events in the one cycle would have a utility decrement of 150%, which obviously is not realistic:

# AE1_Percent_Util_Dec <-0.50
# AE2_Percent_Util_Dec <-0.50
# AE3_Percent_Util_Dec <-0.50

# Instead I set these to 0.30, because even if all three events occur, then it would only be a 0.90% decrease in utility, which would still keep utility between 0 and 1:

# AE1_Percent_Util_Dec <-0.30
# AE2_Percent_Util_Dec <-0.30
# AE3_Percent_Util_Dec <-0.30

#  I create my utility in the first line health state (100%) as below:

# U_First_Line <- 1

# The disutility of each adverse event is calculated as:

# DisUtil_AE1 <- AE1_Percent_Util_Dec *U_First_Line
# DisUtil_AE2 <- AE2_Percent_Util_Dec *U_First_Line
# DisUtil_AE3 <- AE3_Percent_Util_Dec *U_First_Line

# That is, for U_First_Line = 1 and E1_Percent_Util_Dec <-0.30, then:

# DisUtil_AE = AE_Percent_Util_Dec * U_First_Line = 0.30 * 1 = 0.30

# This makes all DisUtil_AE1, DisUtil_AE2, DisUtil_AE3 = 0.30, as the disutility is the same for all of them.

# That is:

# DisUtil_AE1 = AE1_PercentUtilDec * U_First_Line = 0.30 * 1 = 0.30
# DisUtil_AE2 = AE2_PercentUtilDec * U_First_Line = 0.30 * 1 = 0.30
# DisUtil_AE3 = AE3_PercentUtilDec * U_First_Line = 0.30 * 1 = 0.30


# The duration of each adverse event is 5 out of 14 days (Duration_AE = 5/14).

# Duration_AE <- 5/14

# The utility in the first-line health state with adverse events is calculated as:


# U_First_Line_with_AEs<-U_First_Line-p_AE1*DisUtil_AE1*Duration_AE - p_AE2*DisUtil_AE2*Duration_AE - p_AE3*DisUtil_AE3*Duration_AE

# That is: U_First_Line_with_AEs = 1 - 1 * 0.30 * (5/14) - 1 * 0.30 * (5/14) - 1 * 0.30 * (5/14) = 0.6786

# Substitute the values:
#   U_First_Line_with_AEs = 1 - 1 * 0.30 * (5/14) - 1 * 0.30 * (5/14) - 1 * 0.30 * (5/14)
#   U_First_Line_with_AEs = 1 - 0.30 * (5/14) * 3
#   U_First_Line_with_AEs = 1 - 0.30 * 1.0714
#   U_First_Line_with_AEs = 1 - 0.3214
#   U_First_Line_with_AEs = 0.6786


# U_First_Line_with_AEs
# [1] 0.6786

# Now, let's think through this manually:


# There are 14 days in each cycle.
# Each adverse event lasts for 5 days and decreases utility by 30%.
# Since all three adverse events have a 100% probability of occurring, we can consider them as occurring simultaneously.

# During the 5 days when the adverse events occur, the utility for that day is decreased by 30% for each event, and all 3 events have a 100% probability of occuring, giving us a definite 30% decrease to that 1 three times:
# So:  1 - 0.30 - 0.30 - 0.30 = 0.10

# Days with AEs (5 days): Each AE reduces utility by 0.30, so the total reduction is 

# 3 × 0.30 = 0.90.

# The utility for these days is 

# 1 − 0.90 = 0.10


# Days without AEs (9 days): Utility = 1
# For each of the remaining 9 days, the utility is perfect (1).

# So, we have:
  
#  5 days with a utility of 0.10
#  9 days with a utility of 1

# Calculating the total utility:
#   5 * 0.10 + 9 * 1 = 0.50 + 9 = 9.50
 
# Dividing the total utility by the number of days in the cycle:
#   9.50 / 14 = 0.6786
 
# This manual calculation matches the result obtained using the formula.


# Put another way, 

# Sum the utility for each period:

#  Utility for 9 days without AEs:
#  9 * 1 = 9

#  Utility for 5 days with AEs:
#    5 * 0.10 = 0.50

#    9 + 0.50 = 9.50
  
#    9.50 / 14 = 0.6786
  
# According to Claude:

# The value 0.6786 represents the average utility of the first-line health state over the cycle, taking into account the impact of the three adverse events (AE1, AE2, and AE3).

# In this example:
# - The baseline utility of the first-line health state is 1 (or 100%), meaning perfect health.
# - Each adverse event reduces the utility by 30% and lasts for 5 out of the 14 days in the cycle.
# - All three adverse events have a 100% probability of occurring.

# When we calculate the utility of the first-line health state considering these adverse events, we get an average utility of 0.6786 (or 67.86%) over the cycle.

# This means that, on average, the patient experiences a health state that is 67.86% as good as perfect health during the entire cycle, due to the impact of the adverse events. The utility value takes into account both the severity and the duration of the adverse events.

# In other words, the adverse events reduce the overall quality of life or well-being of the patient during the cycle, resulting in an average utility of 0.6786 compared to a perfect health state with a utility of 1.


# Just to explain why I divide by 14 above:

# If a cycle of 14 days gives you a utility of 1 for that entire cycle, and the utility scale ranges from 0 to 1, then we can figure out the utility for each day within that cycle as below:

# Here's how we can think about it:

# 1. The total utility for the 14-day cycle is 1.
# 2. The utility scale ranges from 0 to 1, with 1 representing the highest possible utility (perfect health).
# 3. Since the total utility for the cycle is the highest possible value (1), and the cycle consists of 14 days, each day must contribute equally to the total utility.
# 4. To find the utility value for each day, we can divide the total utility by the number of days in the cycle:
   # Utility per day = Total utility / Total days
   # Utility per day = 1 / 14 = 0.0714 (rounded to 4 decimal places)

# However, when we multiply the utility per day by the total number of days, we get:
#  0.0714 × 14 = 0.9996 (rounded to 4 decimal places)

# This value is slightly less than 1 due to rounding.

# Anyway, if, as before, we approach the above manually, we can have 9 days of perfect health, or 9 days of 0.0714

# 9*0.0714
# [1] 0.6426

# And 5 days of half this perfect health:

# 0.0714*0.50
# [1] 0.0357

# 0.0357*5
# [1] 0.1785

# 0.1785+0.6426
# 0.8211

# The exact same as the formulas and dividing by 14 approaches above which gives us: 0.8214 (there is a very tiny difference at the end of the decimals due to rounding only). So my dividing by 14 was only necessary as in my manual approach I set every day's utility equal to 1, rather than 1/14th of 1, such that I then had to divide by 14 when I was done.


# Qiushi helped me to best understand and apply the above, he did also provide some very useful advice on adverse events that are not probabilities per cycle in email:

# The approach seems good to me. For your last question, you mentioned that the probability of adverse event is for each cycle – is it really the case? If so, it means that if someone had an adverse event 1 with probability 0.07 in one cycle, he still has a probability of 0.07 to have another adverse event 1 in a different cycle? If it is not this case, then it means that the probability is not for every cycle. If in the original study, the adverse event probability is calculated as a fraction of # of patients having the AE / # of total patients, it is not a probability per cycle. It is an overall probability, and it should be counted once (as what you are currently doing). Hope this clarifies your questions.
