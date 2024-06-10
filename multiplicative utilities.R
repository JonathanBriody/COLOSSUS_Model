# Joshua Sobeil suggested the only thing that may be missing is applying the utilities multiplicatively. Additively applying utilities can be unstable as they are not ‘probabilities’ in the sense they can have a range of < 0 and > 1.

# I spoke to Samuel Aballea about this, per my emails in Outlook.

# Applying utilities additively can be problematic because utilities are not probabilities and can result in values outside the acceptable range (0 to 1).

# To address this, I apply the utilities multiplicatively, which is a more appropriate method for combining the impacts of multiple AEs. 

# I take the disutiltiy of the AEs as below:

# Baseline utility is 1: 

# u_F <- 1

# First I take the percentage disutility of the adverse event (i.e., 50%) as:

# AE1_DisUtil <-0.50
# [1] 0.50
# AE2_DisUtil <-0.20 
# [1] 0.20
# AE3_DisUtil <-0.10 
# [1] 0.10

# Duration_AE <- 14/14

# Thus, for the sake of this example the above reflects the proportion of the cycle the adverse event lasts for as the duration of the cycle.

# To make the example simple I set the probabilities of each adverse event as certain, that is 100%:

# p_FA1_STD <- 1
# p_FA2_STD <- 1
# p_FA3_STD <- 1

# Finally, I apply the following equation to apply the utility decrement of the adverse events to the first line health state, conditional on their probability of occuring and their duration:

# u_F_SoC<-u_F

# Applying the utility decrement multiplicatively

# u_F_SoC <- u_F * (1 - (AE1_DisUtil * p_FA1_STD * Duration_AE)) * (1 - (AE2_DisUtil * p_FA2_STD * Duration_AE)) * (1 - (AE3_DisUtil * p_FA3_STD * Duration_AE))

# u_F_SoC
# [1] 0.36

# So, in the example above this becomes: 

# 1 * (1 - (0.50 * 1 * 1)) * (1 - (0.20 * 1 * 1)) * (1 - (0.10 * 1 * 1))

# Which simplifies to:

# 1 * (1 - 0.50) * (1 - 0.20) * (1 - 0.10)
# = 1 * 0.50 * 0.80 * 0.90
# = 0.36

# The `1` above reflects that u_F is == 1 in this example.

# The final utility value, 0.36, reflects the combined impact of multiple adverse events. Each adverse event reduces the utility from the previous step, ensuring that the utility remains within the valid range (0 to 1) and accurately represents the cumulative effect of multiple AEs.

# The multiplicative application of utility decrements ensures that the combined utility value remains within the valid range (0 to 1) and accurately represents the cumulative effect of multiple adverse events (AEs). This method avoids the instability associated with additive adjustments, where the sum of disutilities could exceed 1, leading to negative utilities.

# Why Multiplicative Adjustment Works:

# 1. Preservation of Valid Range: Multiplicative adjustments ensure that the resulting utility value does not fall below 0 or exceed 1. Each adverse event proportionally reduces the utility based on the remaining utility after accounting for previous AEs [[Because they are multiplied in order like this: # = 1 * 0.50 * 0.80 * 0.90]].

# 2. Interaction of Effects: This method captures the interaction between multiple AEs. Each subsequent AE affects the utility remaining after the previous AE(s), which more realistically models the combined impact on a patient's quality of life.

# 3. Flexibility: The approach can easily accommodate varying probabilities and durations of AEs. Even if the AEs do not occur with certainty or do not span the entire cycle, the method adjusts appropriately.


# Purpose of (1 - ( ... )):

# The (1 - ( ... )) construct is used to calculate the remaining utility after accounting for the utility lost due to each adverse event (AE). Here's a detailed breakdown:

# Utility Lost Due to AE: Each term inside the (1 - ( ... )) calculates the utility lost due to a specific AE. The expression u_AE1 * p_FA1_STD * Duration_AE represents the total utility decrement for AE1:

#   u_AE1: Percentage disutility of AE1 (e.g., 0.50 for 50% disutility).
#   p_FA1_STD: Probability of AE1 occurring (e.g., 1 if certain).

# Duration_AE: Proportion of the cycle affected by AE1 (e.g., 1 if the AE lasts the entire cycle).


# Remaining Utility After AE: The expression 1 - (u_AE1 * p_FA1_STD * Duration_AE) calculates the proportion of utility remaining after accounting for the utility lost due to AE1. For example:

#   If u_AE1 = 0.50, p_FA1_STD = 1, and Duration_AE = 1, the calculation inside the parentheses becomes 0.50 * 1 * 1 = 0.50.

# Subtracting this from 1 gives 1 - 0.50 = 0.50, meaning 50% of the utility remains after AE1.

# Multiplicative Adjustment: By multiplying the baseline utility (u_F) by each of these remaining utility factors, the formula ensures that the combined effect of multiple AEs is appropriately accounted for:

#   For AE2: 1 - (u_AE2 * p_FA2_STD * Duration_AE)

#   For AE3: 1 - (u_AE3 * p_FA3_STD * Duration_AE)



# u_F_SoC <- u_F * (1 - (AE1_DisUtil * p_FA1_STD * Duration_AE)) * (1 - (AE2_DisUtil * p_FA2_STD * Duration_AE)) * (1 - (AE3_DisUtil * p_FA3_STD * Duration_AE))

# u_F * (1 - (0.50 * 1 * 1)) * (1 - (0.20 * 1 * 1)) * (1 - (0.10 * 1 * 1))
 
# u_F * (1 - 0.50) * (1 - 0.20) * (1 - 0.10)
# = u_F * 0.50 * 0.80 * 0.90
# = 1 * 0.50 * 0.80 * 0.90
# = 0.36

# Interpretation:

#  AE1 Adjustment: 1 - 0.50 = 0.50 (remaining utility after AE1).

# AE2 Adjustment: 1 - 0.20 = 0.80 (remaining utility after AE2).

# AE3 Adjustment: 1 - 0.10 = 0.90 (remaining utility after AE3).

# These "remaining utility after AE" are the percentage of your utility that is remaining after the AE. So, after AE 1, 50% of your utility is remaining, after AE 2 80% of your utility is remaining as it's a 20% utility decrement, after adverse event 3 90% of your utility is remaining, as it's a 10% utility decrement.


# Multiplying these factors together with the baseline utility gives the final utility value after accounting for all AEs, which is 0.36.

# The (1 - ( ... )) part of the formula is crucial for calculating the remaining utility after each adverse event. 

# It ensures that the utility lost due to an AE is subtracted from 1, leaving the proportion of utility that remains.

# [[Bear in mind, 1 is 100%, 0.10 is 10%, 0.90 is 90%, etc.]].

# By multiplying these remaining utility fractions, the formula accurately reflects the cumulative impact of multiple AEs on the baseline utility, ensuring the final utility value stays within the valid range (0 to 1).

# So basically: # = u_F * 0.50 * 0.80 * 0.90

# After adverse event 1 you have 50% of you u_F utility left: 1*0.50 = 0.50.

# Then after adverse event 2 you have 0.80% of your now decrease u_F utility left: 0.50*0.80 = 0.40

# Then after adverse event 3 you have 90% of your now further decreased u_F utility left: 0.40*0.90 = 0.36 - which is the value that the following gave us:

# u_F_SoC <- u_F * (1 - (AE1_DisUtil * p_FA1_STD * Duration_AE)) * (1 - (AE2_DisUtil * p_FA2_STD * Duration_AE)) * (1 - (AE3_DisUtil * p_FA3_STD * Duration_AE))
 
# So, each AE's effect is applied to the remaining utility, providing a more nuanced and accurate representation of their combined impact.


# In my actual data this looks like this:

# #### Baseline Utility

# u_F <- 0.85

# #### Percentage Disutilities

# AE1_DisUtil <- 0.45
# AE2_DisUtil <- 0.19
# AE3_DisUtil <- 0.36

# #### Duration of Adverse Events

# Duration_AE <- 5 / 14
# [1] 0.3571429

# #### Probabilities of Adverse Events

# p_FA1_STD <- 0.01886995
# p_FA2_STD <- 0.1589995
# p_FA3_STD <- 0.1589995

# ### Additive Approach
 
# First, we calculate the utility decrement for each adverse event:

# u_AE1 <- AE1_DisUtil * u_F
# u_AE2 <- AE2_DisUtil * u_F
# u_AE3 <- AE3_DisUtil * u_F

# Then, we apply the additive method:

# u_F_SoC <- u_F - p_FA1_STD * u_AE1 * Duration_AE - p_FA2_STD * u_AE2 * Duration_AE - p_FA3_STD * u_AE3 * Duration_AE

# Let's break it down step-by-step:
   
#   1. Calculate the utility decrement for each AE:
# u_AE1 <- 0.45 * 0.85
# u_AE2 <- 0.19 * 0.85
# u_AE3 <- 0.36 * 0.85

# This gives us:
# u_AE1 <- 0.3825
# u_AE2 <- 0.1615
# u_AE3 <- 0.306

# 
# 2. Calculate the total utility decrement:
# decrement_AE1 <- p_FA1_STD * u_AE1 * Duration_AE
# decrement_AE2 <- p_FA2_STD * u_AE2 * Duration_AE
# decrement_AE3 <- p_FA3_STD * u_AE3 * Duration_AE

# This gives us:
# decrement_AE1 <- 0.01886995 * 0.3825 * 0.3571429
# decrement_AE2 <- 0.1589995 * 0.1615 * 0.3571429
# decrement_AE3 <- 0.1589995 * 0.306 * 0.3571429

# Calculating these:
# decrement_AE1 <- 0.002418
# decrement_AE2 <- 0.009158
# decrement_AE3 <- 0.017405

# 3. Subtract these from the baseline utility:
# u_F_SoC <- 0.85 - 0.002418 - 0.009158 - 0.017405
# u_F_SoC <- 0.821019

# So, using the additive approach, the final utility is approximately `0.821`.

 
# ### Multiplicative Approach
 
# Now let's apply the multiplicative approach:

# u_F_SoC <- u_F * (1 - p_FA1_STD * AE1_DisUtil * Duration_AE) * (1 - p_FA2_STD * AE2_DisUtil * Duration_AE) * (1 - p_FA3_STD * AE3_DisUtil * Duration_AE)

# Let's break it down step-by-step:

#   1. Calculate the factors for each AE:

# factor_AE1 <- 1 - p_FA1_STD * AE1_DisUtil * Duration_AE
# factor_AE2 <- 1 - p_FA2_STD * AE2_DisUtil * Duration_AE
# factor_AE3 <- 1 - p_FA3_STD * AE3_DisUtil * Duration_AE

# This gives us:

# factor_AE1 <- 1 - 0.01886995 * 0.45 * 0.3571429
# factor_AE2 <- 1 - 0.1589995 * 0.19 * 0.3571429
# factor_AE3 <- 1 - 0.1589995 * 0.36 * 0.3571429

# Calculating these:

# factor_AE1 <- 0.996965
# factor_AE2 <- 0.989217
# factor_AE3 <- 0.979606

# 2. Multiply these factors with the baseline utility:

# u_F_SoC <- u_F * factor_AE1 * factor_AE2 * factor_AE3

#    Using the calculated factors:

# u_F_SoC <- 0.85 * 0.996965 * 0.989217 * 0.979606


# 3. Perform the multiplication step-by-step:


#    step1 <- 0.85 * 0.996965
#    step1 <- 0.84742025

#    step2 <- 0.84742025 * 0.989217
#    step2 <- 0.83799206

#    step3 <- 0.83799206 * 0.979606
#    step3 <- 0.82093271


# So, using the multiplicative approach, the final utility is approximately `0.8209`.

### Summary

# - **Additive Approach**: The final utility is approximately `0.821`.
# - **Multiplicative Approach**: The final utility is approximately `0.8209`.

# While the difference between the two approaches is small in this particular case, the multiplicative approach provides a more nuanced model of how multiple adverse events impact overall utility by considering the interdependent effects on the remaining utility. This is especially important in more complex scenarios where the interactions between multiple AEs can have a larger compound effect.


# I initially proposed a method to calculate utility per cycle using an additive approach:

# I take the disutiltiy of the AEs as below:

# Baseline utility is 1: 

# u_F <- 1

# First I take the percentage disutility of the adverse event (i.e., 50%) as:

# AE1_DisUtil <-0.50
# [1] 0.50
# AE2_DisUtil <-0.20 
# [1] 0.20
# AE3_DisUtil <-0.10 
# [1] 0.10

# Then I calculate the utility decrement for the adverse event as your utility in the first line health state where the adverse event can occur (u_F), multiplied by the percentage decrement of the event (50%):

# u_AE1 <- AE1_DisUtil*u_F
# [1] 0.50
# u_AE2 <- AE2_DisUtil*u_F
# [1] 0.20
# u_AE3 <- AE3_DisUtil*u_F
# [1] 0.10

# So, I find the proportion of the baseline utility (that is, the utility without an adverse event) that the adverse event would remove if it occured, that is, a 10 percentage disutility of an adverse event would decrease a utility of 1 by 0.10.

# For simplicities sake in this example I take the duration of the adverse events as  all 14 days in my model cycles when I create the variable reflecting duration of adverse event:

# Duration_AE <- 14/14

# Thus, for the sake of this example the above reflects the proportion of the cycle the adverse event lasts for as the duration of the cycle.

# To make the example simple I set the probabilities of each adverse event as certain, that is 100%:

# p_FA1_STD <- 1
# p_FA2_STD <- 1
# p_FA3_STD <- 1

# Finally, I apply the following equation to apply the utility decrement of the adverse events to the first line health state, conditional on their probability of occuring and their duration:

# u_F_SoC<-u_F

# The key part of the code is this line, which implicitly assumes that the utility decrements are additive:

# u_F_SoC<-u_F-p_FA1_STD*u_AE1*Duration_AE - p_FA2_STD*u_AE2*Duration_AE - p_FA3_STD*u_AE3*Duration_AE

# This method does not account for the possibility that AEs can co-occur independently. Instead, it assumes that each AE independently subtracts from the baseline utility without any interaction between them. Therefore, this approach treats the AEs as if they are exclusive because it simply subtracts their disutilities in a linear fashion.

# u_F_SoC
# [1] 0.2

# And this answer made sense to me, if you have a utility of 1 and a 100% chance of decreasing this by 0.50, 0.20 and 0.10,  I would expect the utility you started with to become 0.20, i.e., 1 - 0.50 - 0.20 - 0.10 = 0.20.

# Thus, I felt the adverse events were not exclusive (i.e. a patient with neutropenia can also have diarrhoea, etc) because of the manner in which they add up above.


# However, because my proposed method deducts the disutility of each AE from the baseline utility, it is kind of assuming that AEs are exclusive, that is, that they are exclusive of eachother, and it doesnt consider the combined effects of these adverse events:

# u_F_SoC<-u_F-p_FA1_STD*u_AE1*Duration_AE - p_FA2_STD*u_AE2*Duration_AE - p_FA3_STD*u_AE3*Duration_AE

# Although this approach is straightforward, it can lead to an unrealistic situation where the combined disutilities might exceed the baseline utility, potentially resulting in negative utility values.

# The multiplicative approach I described above adjusts the baseline utility multiplicatively, assuming that AEs can co-occur independently.

# This approach assumes the AEs are independent and calculates the remaining utility after each AE's effect multiplicatively. It allows for the possibility of co-occurring AEs by considering the combined effect on the remaining utility.

# Whereas by subtracting the utility decrements linearly, my additive method implicitly assumed that the adverse events are exclusive. This means it doesn't account for the potential overlap in utility decrements when multiple AEs occur simultaneously.

# This method ensures that the utility remains within the valid range (0 to 1) and more accurately models the cumulative impact of multiple AEs.


# Additive Approach: I subtract the disutility of each AE from the baseline utility in a linear fashion. This method assumes that the total disutility is simply the sum of individual disutilities.

# The Multiplicative Approach multiplies the utility decrements, reflecting the combined effect of multiple AEs in a way that assumes they are independent but can co-occur.

# While the additive approach does account for multiple AEs occurring together, it does not reflect the compound effect of AEs on the utility correctly when considering that utility is a multiplicative scale.

# This is what Samuel means when he says:
   
#   "you assume that a patient with neutropenia cannot also have diarrhoea for example"
 
# In other words, the additive approach does not account for the interaction between AEs in a multiplicative fashion, which is often more realistic in health economics modeling.

# The multiplicative approach reflects that the utility decrement from one AE affects the remaining utility after accounting for other AEs.

# This approach assumes that the disutility from one AE reduces the total remaining utility, and then the next AE further reduces the remaining utility, and so on.


# My additive approach allows for multiple AEs to co-occur, but it doesn't account for the compound effect of AEs on utility in a multiplicative sense. Samuel's point is that the additive approach assumes each AE's impact on utility is independent and linear, which may not be realistic. In contrast, the multiplicative approach assumes that each AE's impact on utility is dependent on the remaining utility, providing a more nuanced and realistic model of how multiple AEs affect overall utility.

# So, while I am technically allowing for co-occurrence of AEs, the way I am modeling their impact on utility does not reflect the compound, multiplicative nature of utility decrements. This is the key distinction Samuel is highlighting.

# I guess when Samuel said "The way you propose to calculate the utility per cycle (u_F_Exp <- u_F - p_FA1 * u_AE1 - p_FA2 * u_AE2 - p_FA3 * u_AE3) looks OK to me, although this would assume that the adverse events are exclusive (i.e. you assume that a patient with neutropenia cannot also have diarrhoea for example)." He might have meant that if neutropenia had an 80% disutility say and nausea had a 20% disutility then the probability of diarrhoea could be 100% but you wouldnt really be able to count it because you've already decreased your utility by 100% through neutropenia and nausea combined?

# By applying the utilities multiplicatively, I account for the combined effect of multiple AEs but also avoid the potential instability of having a utility value that is below 0 when when dealing with multiple adverse events. That is, I ensure the combined utility remains within the valid range (0 to 1).


# This revised approach reflects the multiplicative nature of utility decrements.
