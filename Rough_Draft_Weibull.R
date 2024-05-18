# Ensure m_coef_weibull_SoC is properly converted to a data frame before performing operations that use the $ operator.
# Assuming df.m_coef_weibull_SoC is initially a matrix
df.m_coef_weibull_SoC <- as.data.frame(m_coef_weibull_SoC)
colnames(df.m_coef_weibull_SoC) <- c("shape", "scale")  # Set the column names

# Calculate the empirical mean and variance of the shape and scales
# Check for non-positive values
if(any(df.m_coef_weibull_SoC$shape <= 0) | any(df.m_coef_weibull_SoC$scale <= 0)) {
  stop("Data contains non-positive values, which are not suitable for Weibull distribution fitting.")
}

# Calculate the empirical mean and variance
empirical_mean_shape <- mean(df.m_coef_weibull_SoC$shape)
empirical_variance_shape <- var(df.m_coef_weibull_SoC$shape)

empirical_mean_scale <- mean(df.m_coef_weibull_SoC$scale)
empirical_variance_scale <- var(df.m_coef_weibull_SoC$scale)

# Fit Weibull distribution to the 'shape' data
shape_fit <- fitdist(df.m_coef_weibull_SoC$shape, "weibull")

# Extract the estimated parameters for 'shape'
shape_params <- shape_fit$estimate
shape_shape <- shape_params["shape"]
shape_scale <- shape_params["scale"]

# Calculate the theoretical mean and variance for 'shape'
theoretical_mean_shape <- shape_scale * gamma(1 + 1 / shape_shape)
theoretical_variance_shape <- (shape_scale^2) * (gamma(1 + 2 / shape_shape) - (gamma(1 + 1 / shape_shape))^2)

# Fit Weibull distribution to the 'scale' data
scale_fit <- fitdist(df.m_coef_weibull_SoC$scale, "weibull")

# Extract the estimated parameters for 'scale'
scale_params <- scale_fit$estimate
scale_shape <- scale_params["shape"]
scale_scale <- scale_params["scale"]

# Calculate the theoretical mean and variance for 'scale'
theoretical_mean_scale <- scale_scale * gamma(1 + 1 / scale_shape)
theoretical_variance_scale <- (scale_scale^2) * (gamma(1 + 2 / scale_shape) - (gamma(1 + 1 / scale_shape))^2)

# Print the empirical and theoretical mean and variance for 'shape'
cat("Shape Data:\n")
cat("Empirical Mean: ", empirical_mean_shape, "\n")
cat("Theoretical Mean: ", theoretical_mean_shape, "\n")
cat("Empirical Variance: ", empirical_variance_shape, "\n")
cat("Theoretical Variance: ", theoretical_variance_shape, "\n\n")

# Print the empirical and theoretical mean and variance for 'scale'
cat("Scale Data:\n")
cat("Empirical Mean: ", empirical_mean_scale, "\n")
cat("Theoretical Mean: ", theoretical_mean_scale, "\n")
cat("Empirical Variance: ", empirical_variance_scale, "\n")
cat("Theoretical Variance: ", theoretical_variance_scale, "\n")

# Histogram of Shape Parameters with Weibull Fit
# Generate theoretical Weibull density values
x_shape <- seq(min(df.m_coef_weibull_SoC$shape), max(df.m_coef_weibull_SoC$shape), length.out = 100)
y_shape <- dweibull(x_shape, shape = shape_shape, scale = shape_scale)

hist_data <- hist(df.m_coef_weibull_SoC$shape, plot = FALSE)

# Open a graphics device to save the plot to a file
png(filename = paste0(variable_label, "_", country_name, "shape_histogram.png"), width = 800, height = 600)

# Plot histogram and overlay Weibull density curve
hist(df.m_coef_weibull_SoC$shape, breaks = 30, freq = FALSE, main = "", xlab = "Shape")
lines(x_shape, y_shape, col = "darkblue", lwd = 2)

# Add rug plot
rug(df.m_coef_weibull_SoC$shape, col = "darkred")

# Add legend for mean and variance of data and theoretical distribution
legend("topright", inset = c(-0.037, 0), legend = c(paste("Data Mean: ", round(empirical_mean_shape, 3)), paste("Data Variance: ", round(empirical_variance_shape, 3)), paste("Theoretical Mean: ", round(theoretical_mean_shape, 3)), paste("Theoretical Variance: ", round(theoretical_variance_shape, 3)), "Rug plot (dark red ticks)", "Theoretical Weibull Distribution (dark blue curve)"), cex = 0.8, xpd = TRUE)

# Instead of specifying the coordinates directly, you can use the inset parameter in the legend function to adjust the legend position relative to the corner of the plot. The inset parameter takes a two-element numeric vector indicating the x (horizontal) and y (vertical) distances from the corner of the plot.

# In this code, inset = c(-0.2, 0) shifts the legend 20% of the plot width to the left from the top right corner. You can adjust these values as needed to move the legend to the desired position. The negative value for the x-coordinate shifts the legend to the left.

# Add title
title(main = paste("Histogram of Shape Parameters with Weibull fit for first to second line treatment from the multivariate normal distribution in PSA for", country_name), line = 2, cex.main = 1)

# Decrease the size of the title text: You can use the cex.main argument in the title function to adjust the size of the title text. cex.main is a numerical value giving the amount by which plotting text and symbols should be scaled relative to the default. 1=default, 1.5 is 50% larger, 0.5 is 50% smaller, etc. In this code, cex.main = 0.8 decreases the size of the title text by 20%.


# Close the graphics device
dev.off()
