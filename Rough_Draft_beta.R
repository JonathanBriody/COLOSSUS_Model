# Load the utils package
library(utils)

# Assign the value to the variable
P_OSD_SoC <- 0.17

# Add the comment (label)
comment(P_OSD_SoC) <- "probability of dying in OS treatment following test test under standard of care"

# Set your mean and range
plotted_variable <- "P_OSD_SoC"
variable_label <- comment(get(plotted_variable))
max <- 0.22
min <- 0.12
mean <- get(plotted_variable)
se <- ((max)-(mean))/1.96

# Calculate the standard error
std.error <- se

# Generate alpha and beta
alpha.plus.beta <- mean*(1-mean)/(std.error^2)-1
alpha <- mean*alpha.plus.beta
beta <- alpha*(1-mean)/mean

# Generate random values
n_runs <- 10000
random_values <- rbeta(n_runs, shape1 = alpha, shape2 = beta)

# Calculate the mean and variance of your data
data_mean <- mean(random_values)
data_var <- var(random_values)

# Calculate the mean and variance of the theoretical distribution
theoretical_mean <- alpha / (alpha + beta)
theoretical_var <- (alpha * beta) / ((alpha + beta)^2 * (alpha + beta + 1))

# Generate histogram of random values
hist_data <- hist(random_values, plot = FALSE)

# Open a graphics device to save the plot to a file
png(filename = paste0(plotted_variable, "_histogram.png"), width = 800, height = 600)

# Normalize and plot histogram
hist(random_values, freq = FALSE, main = "", xlab = "Values", ylim = c(0, max(hist_data$density) * 1.2))

# Add theoretical beta distribution curve
curve(dbeta(x, shape1 = alpha, shape2 = beta), add = TRUE, col = "darkblue", lwd = 2)

# Add vertical lines for mean, min, and max
abline(v = mean, col = "red", lwd = 2, lty = 2)  # Mean
abline(v = min, col = "green", lwd = 2, lty = 2)  # Min
abline(v = max, col = "blue", lwd = 2, lty = 2)  # Max

# Add rug plot
rug(random_values, col = "darkred")

# Add legend for mean and variance of data and theoretical distribution
legend("topright", legend = c(paste("Data Mean: ", round(data_mean, 3)), paste("Data Variance: ", round(data_var, 3)), paste("Theoretical Mean: ", round(theoretical_mean, 3)), paste("Theoretical Variance: ", round(theoretical_var, 3)), "Mean (red line)", "Min (green line)", "Max (blue line)", "Rug plot (dark red ticks)", "Theoretical Beta Distribution (dark blue curve)"), cex = 0.8)

# Add title
title(main = paste("Histogram with Beta Distribution for", variable_label, "in PSA"), line = -1.5)

# Close the graphics device
dev.off()

