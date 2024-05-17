# Define the min and max values for the uniform distribution
min_val <- 0
max_val <- 0.08 / 365

# Generate random samples for discount rates using a uniform distribution
d_c_samples <- runif(n_runs, min = min_val, max = max_val)
d_e_samples <- runif(n_runs, min = min_val, max = max_val)
random_draws <- runif(n_runs, min = 0, max = 0.08/365)


# Compare summary statistics: Compare the mean and variance of your data to the theoretical mean and variance of a uniform distribution. For a uniform distribution with parameters min and max, the theoretical mean is (min + max) / 2 and the variance is (max - min)^2 / 12. If your sample mean and variance are close to these theoretical values, then your data might follow a uniform distribution.


# This is supported by: https://study.com/skill/learn/calculating-the-mean-of-a-continuous-uniform-distribution-explanation.html and this: https://www.ncl.ac.uk/webtemplate/ask-assets/external/maths-resources/business/probability/uniform-distribution.html


# Calculate sample mean and variance
sample_mean <- mean(random_draws)
sample_variance <- var(random_draws)

# Calculate theoretical mean and variance
theoretical_mean <- (0 + 0.08/365) / 2
theoretical_variance <- (0.08/365 - 0)^2 / 12

# Print values
cat("Sample Mean:", sample_mean, "\n")
cat("Theoretical Mean:", theoretical_mean, "\n")
cat("Sample Variance:", sample_variance, "\n")
cat("Theoretical Variance:", theoretical_variance, "\n")


# Construct the file name
file_name <- paste(country_name, "uniform_histograms.png", sep = "_")

# Open a PNG device
png(file_name, width = 1200, height = 600)


# Set up the plotting area to display two plots side by side
par(mfrow = c(1, 2))

# Plot histogram for d_c_samples with density
hist(d_c_samples, breaks = 50, probability = TRUE, 
     main = "Histogram of Discount Rate for Costs - Uniform Distribution",
     xlab = "Discount Rate (d_c)", border = "white")


# Add rug plot for d_c_samples
rug(d_c_samples, col = "darkred")

# Add theoretical uniform distribution curve for d_c_samples
curve(dunif(x, min = min_val, max = max_val), col = "darkblue", lwd = 2, add = TRUE)

# Plot histogram for d_e_samples with density
hist(d_e_samples, breaks = 50, probability = TRUE, 
     main = "Histogram of Discount Rate for Effects - Uniform Distribution",
     xlab = "Discount Rate (d_e)", border = "white")

# Add theoretical uniform distribution curve for d_e_samples
curve(dunif(x, min = min_val, max = max_val), col = "darkblue", lwd = 2, add = TRUE)

# Add rug plot for d_e_samples
rug(d_e_samples, col = "darkred")

# In this code, rug(random_values) adds a rug plot at the bottom of the histogram, which shows the individual data points as small vertical lines.

# Add legend for mean and variance of data and theoretical distribution
legend("topright", inset = c(-0.037, 0), legend = c(paste("Data Mean: ", round(data_mean, 3)), paste("Data Variance: ", round(data_var, 3)), paste("Theoretical Mean: ", round(theoretical_mean, 3)), paste("Theoretical Variance: ", round(theoretical_var, 3)), "Mean (red line)", "Min (green line)", "Max (blue line)", "Rug plot (dark red ticks)", "Theoretical Log-normal Distribution (dark blue curve)"), cex = 0.8, xpd = TRUE)



# Reset plotting area to default
par(mfrow = c(1, 1))



# Close the PNG device
dev.off()

# Print a message indicating the file has been saved
cat("Plot saved as", file_name, "\n")