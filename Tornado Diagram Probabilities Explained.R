# Tornado Diagram Probabilities Explained:

# Whether or not boxes appear seems to definitely depend on the values of transition probabilities,


# The size of

# p_FD      = 0.90, 

# in L_params_all will influence the size of:

# m_P_SoC["ProgressionFree", "ProgressionFree", ] <- (1 - p_FD) * (1 - p_FP_SoC)
# m_P_SoC["ProgressionFree", "Progression", ]     <- (1 - p_FD) * p_FP_SoC

# Because it's multiplied by this, as illustrated below, which will in turn influence how much of a difference +/- 20% p_FP_SoC is on the tornado diagram, a smaller probability will obviously have less of an influence on things.


# > (1-0.90)*(1-p_FP_SoC)
# [1] 0.099482143 0.098215220 0.096802628 0.095315406 0.093781835 0.092218219
# [7] 0.090635386 0.089041131 0.087441354 0.085840684 0.084242839 0.082650866
# [13] 0.081067294 0.079494242 0.077933504 0.076386601 0.074854833 0.073339308
# [19] 0.071840974 0.070360641 0.068898998 0.067456629 0.066034025 0.064631597
# [25] 0.063249685 0.061888561 0.060548444 0.059229499 0.057931846 0.056655562
# [31] 0.055400690 0.054167236 0.052955177 0.051764463 0.050595019 0.049446747
# [37] 0.048319529 0.047213230 0.046127695 0.045062758 0.044018238 0.042993942
# [43] 0.041989665 0.041005195 0.040040309 0.039094778 0.038168365 0.037260828
# [49] 0.036371919 0.035501386 0.034648975 0.033814425 0.032997475 0.032197861
# [55] 0.031415318 0.030649580 0.029900378 0.029167444 0.028450512 0.027749312
# [61] 0.027063577 0.026393041 0.025737438 0.025096503 0.024469975 0.023857591
# [67] 0.023259093 0.022674222 0.022102724 0.021544345 0.020998836 0.020465948
# [73] 0.019945436 0.019437057 0.018940571 0.018455741 0.017982334 0.017520117
# [79] 0.017068864 0.016628349 0.016198351 0.015778651 0.015369033 0.014969285
# [85] 0.014579198 0.014198568 0.013827190 0.013464865 0.013111399 0.012766597
# [91] 0.012430271 0.012102234 0.011782304 0.011470299 0.011166044 0.010869364
# [97] 0.010580090 0.010298055 0.010023093 0.009755044 0.009493750 0.009239056
# [103] 0.008990809 0.008748860 0.008513064 0.008283276 0.008059356 0.007841167
# [109] 0.007628574 0.007421443 0.007219646 0.007023057 0.006831549 0.006645003
# [115] 0.006463298 0.006286319 0.006113950 0.005946081 0.005782602 0.005623406

# > (1-0.10)*(1-p_FP_SoC)
# [1] 0.89533929 0.88393698 0.87122365 0.85783865 0.84403652 0.82996397 0.81571847
# [8] 0.80137018 0.78697219 0.77256616 0.75818555 0.74385780 0.72960564 0.71544818
# [15] 0.70140153 0.68747941 0.67369350 0.66005377 0.64656877 0.63324577 0.62009098
# [22] 0.60710966 0.59430622 0.58168438 0.56924716 0.55699705 0.54493600 0.53306549
# [29] 0.52138661 0.50990006 0.49860621 0.48750512 0.47659659 0.46588017 0.45535517
# [36] 0.44502072 0.43487576 0.42491907 0.41514926 0.40556482 0.39616414 0.38694547
# [43] 0.37790699 0.36904675 0.36036278 0.35185300 0.34351528 0.33534745 0.32734727
# [50] 0.31951248 0.31184077 0.30432982 0.29697727 0.28978075 0.28273787 0.27584622
# [57] 0.26910340 0.26250700 0.25605461 0.24974380 0.24357219 0.23753737 0.23163694
# [64] 0.22586853 0.22022977 0.21471832 0.20933183 0.20406800 0.19892451 0.19389911
# [71] 0.18898953 0.18419353 0.17950892 0.17493351 0.17046514 0.16610167 0.16184100
# [78] 0.15768106 0.15361978 0.14965515 0.14578516 0.14200786 0.13832129 0.13472356
# [85] 0.13121279 0.12778711 0.12444471 0.12118379 0.11800259 0.11489938 0.11187244
# [92] 0.10892011 0.10604073 0.10323269 0.10049439 0.09782428 0.09522081 0.09268249
# [99] 0.09020784 0.08779540 0.08544375 0.08315150 0.08091728 0.07873974 0.07661757
# [106] 0.07454948 0.07253421 0.07057050 0.06865716 0.06679299 0.06497682 0.06320751
# [113] 0.06148394 0.05980503 0.05816968 0.05657687 0.05502555 0.05351473 0.05204342
# [120] 0.05061065

# Look at the difference of 0.005623406 vs 0.05061065 for position 120.





# I think also any change in probability will ultimately change the cost-effectiveness or net monetary benefit, which will have a knock on effect for the tornado diagram.

# For example, p_PD = 0.05, has a range of 106,000 to 128,000 on the bottom of this tornado diagram, while p_PD = 0.50, has a range of 70-90,000 on the bottom of this tornado diagram, which influences the size of the boxes on it.

# In the function:

# m_P_SoC["Progression", "Progression", ] <- 1 - p_PD
# m_P_SoC["Progression", "Dead", ]        <- p_PD

# So you can see that with p_PD = 0.05 95% of people will be left in the progression state at each cycle, which will mean people live for longer and the model runs for longer with more things happening, whereas when p_PD = 0.50, half of people will be left in the progression free state at each cycle, which obviously means half your cohort is dead after one cycle and people live for a much shorter time. And all this will have an influence on the NMB and cost-effectiveness. 

# The influence that a change in another value - be it cost, utility or probability - can have on things will differ too. i.e. even if you change the cost of the "Progression" state by +/-20% it won't have much time to influence things if half your cohort leaves that state to go to the "Dead" state after one cycle and don't have that "Progression" state cost applied to them over a number of cycles in the "Progression" state.


# And I think the same holds for the below:


# Setting the transition probabilities from AE into progression matters for the tornado diagram because the more people who can go into the progression free state, the more important variety in progression free probability, utility and cost will be for results.
# m_P_SoC["AE1", "ProgressionFree", ] <- 0.01
# m_P_SoC["AE1", "Dead", ] <- 0.01

# So, to make sure the code I've written works I'll create the tornado diagram with all the variables I want to vary included, and see if they all get boxes on the diagram, if not I'll mess with the probability and other values, making them as extreme as necessary until I get boxes for everything. Then when I have the true values I can put them in knowing that if something doesnt turn up on the tornado diagram it's because it wasnt relevant.

WHEN I COME BACK TO THIS, ILL GET THE WORKING FUNCTION AND 3 STATE AND THEN ALMAGAMATE IT WITH MY OWN CODE THAT I WAS ORIGINALLY USING.













