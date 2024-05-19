# This is how this code works to apply disutilities, it's the probability of the event happening and taking the disutility amount away from the utility you started with, for illustration purposes I set the utility you started with to 100 and the discount to 10% and the probability of the adverse event happening to 100%, so you should 100% lose 10% of your utility, and there are three adverse events following this rule, so you should 100% lose 10% of your baseline utility for each adverse event, so you should lose 30% of your baseline utility. The way this is coded, it basically figures out what x% of your baseline utility is, then it takes that number away from the baseline utility if that adverse event happens, so 10% of 100 is 10, so if that adverse event happens you take away 100-10 giving you 90, if all 3 adverse events happen, it's 100-10-10-10 giving you 70. That's why you have to be careful with your disutilities, because, if all three happen and they were 50%, 50% and 50% you could have a situation of 100-50-50-50, which would mean your utility would be -50, which isnt possible in utilities, as they are bounded by 1 and 0, so you might have to write a piece of code that checks if it is below 0, and when it is to set it == 0 instead.

# In my situation that can't happen, as my disutilities are 0.45+0.19+0.36 which add up to 1, so the very most that could be taken from my baseline utility is 100% of it's value, leaving it at 0 exactly, and my probabilities of each event are quite low, significantly decreasing the likelihood of all three occurring:

# 
# u_F <- 100
# u_F
# 100
# 
# AE1_DisUtil <- 0.10
# u_AE1 <- AE1_DisUtil*u_F
# u_AE1
# 10
# 
# AE2_DisUtil <- 0.10
# u_AE2 <- AE2_DisUtil*u_F
# u_AE2
# 10
# 
# AE3_DisUtil <- 0.10
# u_AE3 <- AE3_DisUtil*u_F
# u_AE3
# 10
# 
# p_FA1_STD <-1
# p_FA2_STD <-1
# p_FA3_STD <-1
# 
# u_F_SoC<-u_F
# 
# u_F_SoC<-u_F-p_FA1_STD*u_AE1 - p_FA2_STD*u_AE2 - p_FA3_STD*u_AE3
# 
# u_F_SoC
# 70


# When disutilities are only for a portion of your cycle:

# Let's say your utility in u_F was 90 at baseline (I recognise utilities are typically like 0.90, but I find it easier to think in whole numbers):

u_F <- 90
u_F

# The disutility of AE1 is 60%, but adverse event 1 only last for 1 week, and cycles are 3 weeks in length.

# So, you divide this disutility by the portion of the cycle it lasts for (21/7 = 3) and then apply it to the whole cycles utility:

AE1_DisUtil <- 0.60/(21/7)
u_AE1 <- AE1_DisUtil*u_F
u_AE1


# Then, in a situation where the event 100% happens, you should have a utility that is equal to 2 weeks of normal utility and 1 week of reduced utility, so if the u_F is == 90, you can think of this as two weeks of 30 each (where the event is not happening) and one week of 30 - 0.60% or 30- 18 (which is 60% of 30), such that u_F is 30 + 30 + 12 = 72 or a full utility week plus a full utility week plus a week with a utility decrement of 60%.

p_FA1_STD <-1

u_F_SoC<-u_F

u_F_SoC<-u_F-p_FA1_STD*u_AE1 

u_F_SoC

90/3

30*0.60

# When you experience an adverse event, you are in the adverse event state for 5 out of the 14 days of the 14-day cycle, so I divide the adverse event diutility by 14/5 as below:



AE1_DisUtil <-0.45/(14/5) # The percentage disutility of the adverse event.
AE2_DisUtil <-0.19/(14/5) # The percentage disutility of the adverse event.
AE3_DisUtil <-0.36/(14/5) # The percentage disutility of the adverse event.












0.085/14
# [1] 0.006071

0.006071*9
# [1] 0.05464

0.006071*5
# [1] 0.03036











# Maybe an addition like this could work:

0.085/14
# [1] 0.006071

AE1_DisUtil <-0.45/14/5
AE2_DisUtil <-0.19
AE3_DisUtil <-0.36

u_AE1 <- (0.006071*9+(0.006071*AE1_DisUtil)*5)
u_AE2 <- (0.006071*9+(0.006071*AE2_DisUtil)*5)
u_AE3 <- (0.006071*9+(0.006071*AE3_DisUtil)*5)




u_F_Exp<-u_F-p_FA1_EXPR*u_AE1 - p_FA2_EXPR*u_AE2 - p_FA3_EXPR*u_AE3




















