Is there anyway to update this code to produce a plot that will have a layout that is more similar to this plot I created earlier: # Plotting the Gamma Distribution:
  
  
  # Plotting the Gamma Distribution:
  
  
  # Generate some random values and plot a histogram: This is a good way to visually check if your data follows the expected gamma distribution. You can overlay the theoretical gamma distribution on your histogram to see if they match.
  # Generate random values
  
  # This code is as per Plotting PSA Distributions, so a lot of useful information on what the different pieces of code are doing:
  
  # So, I can immediately generate some random values from my gamma distribution using these parameters and plot a histogram:

random_values <- rgamma(n_runs, shape = a.cIntervention, scale = b.cIntervention)

# To check if the distribution has the expected mean and variance, I can calculate these statistics from my random values:

# Calculate sample mean and variance
data_mean <- mean(random_values)
data_var <- var(random_values)

# Calculate theoretical mean and variance
theoretical_mean <- a.cIntervention * b.cIntervention
theoretical_var <- a.cIntervention * b.cIntervention^2

# As part of my plotting, I want to  overlay the theoretical gamma distribution curve on my histogram. I do this by using the curve function in R:

# First, I generate the histogram of my random values without plotting it:  

# Generate histogram of random values
hist_data <- hist(random_values, plot = FALSE)

# Open a graphics device to save the plot to a file
png(filename = paste0(plotted_variable, "_", country_name, "_histogram.png"), width = 800, height = 600)

# I was experiencing issue due to the size of the plotting area being too small for the amount of content I'm trying to fit in. I can try adjusting the margins of the plot to make more room for the title. The par function in R allows you to set graphical parameters, including the margins of the plot (mar), which is specified as a vector of four values indicating the number of lines of margin to be specified on the bottom, left, top, and right of the plot, respectively.
# Adjust the margins (bottom, left, top, right)
par(mar = c(5, 4, 4, 2) + 0.1)

# In this code, par(mar = c(5, 4, 4, 2) + 0.1) sets the bottom margin to 5 lines, the left margin to 4 lines, the top margin to 4 lines, and the right margin to 2 lines. You can adjust these values as needed to create more space for your title.

# Plot histogram

hist(random_values, breaks=50, freq = FALSE, main = "", xlab = "Values", ylim = c(0, max(hist_data$density) * 1.2))

# Then I add theoretical gamma distribution curve
curve(dgamma(x, shape = a.cIntervention, scale = b.cIntervention), add = TRUE, col = "darkblue", lwd = 2)

# I can add vertical lines to my plot using the abline function in R. 

# Add vertical lines for mean, min, and max
abline(v = mean, col = "red", lwd = 2, lty = 2)  # Mean
abline(v = min, col = "green", lwd = 2, lty = 2)  # Min
abline(v = max, col = "blue", lwd = 2, lty = 2)  # Max

# In this code, abline(v = value) adds a vertical line at the specified value. The col parameter sets the color of the line, lwd sets the line width, and lty sets the line type (1 = solid, 2 = dashed, etc.).

# This will add vertical lines at the mean, min, and max values to the histogram. The mean line is red, the min line is green, and the max line is blue.

# Add rug plot
rug(random_values, col = "darkred")

# In this code, rug(random_values) adds a rug plot at the bottom of the histogram, which shows the individual data points as small vertical lines.

# Add legend for mean and variance of data and theoretical distribution
legend("topright", inset = c(-0.037, 0), legend = c(paste("Data Mean: ", round(data_mean, 3)), paste("Data Variance: ", round(data_var, 3)), paste("Theoretical Mean: ", round(theoretical_mean, 3)), paste("Theoretical Variance: ", round(theoretical_var, 3)), "Mean (red line)", "Min (green line)", "Max (blue line)", "Rug plot (dark red ticks)", "Theoretical Gamma Distribution (dark blue curve)"), cex = 0.8, xpd = TRUE)

# Instead of specifying the coordinates directly, you can use the inset parameter in the legend function to adjust the legend position relative to the corner of the plot. The inset parameter takes a two-element numeric vector indicating the x (horizontal) and y (vertical) distances from the corner of the plot.

# In this code, inset = c(-0.2, 0) shifts the legend 20% of the plot width to the left from the top right corner. You can adjust these values as needed to move the legend to the desired position. The negative value for the x-coordinate shifts the legend to the left.

# Add title
title(main = paste("Histogram with Gamma Distribution for", variable_label, "in PSA for", country_name), line = 2, cex.main = 1)

# Decrease the size of the title text: You can use the cex.main argument in the title function to adjust the size of the title text. cex.main is a numerical value giving the amount by which plotting text and symbols should be scaled relative to the default. 1=default, 1.5 is 50% larger, 0.5 is 50% smaller, etc. In this code, cex.main = 0.8 decreases the size of the title text by 20%.





# Close the graphics device
dev.off()
