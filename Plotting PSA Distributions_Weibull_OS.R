# library(MASS)  # For fitdistr
# install.packages("fitdistrplus")
# install.packages("ggplot2")
# library(fitdistrplus)
# library(ggplot2)
# Load necessary package for the gamma function
# library(stats)

############## m_coef_weibull_OS_SoC

# I want to plot the shape and scale parameters that make up m_coef_weibull_OS_SoC to show that my random draws for shape and scale matched a Weibull dsitribution and that the theoeretical mean and variance I produced was basically the same as that produced by the data:


# it is necessary to ensure that m_coef_weibull_OS_SoC is properly converted to a data frame before performing operations that use the $ operator.

# Here is how to can handle this in R, assuming m_coef_weibull_OS_SoC is initially a matrix:

# Assuming df.m_coef_weibull_OS_SoC is a matrix
df.m_coef_weibull_OS_SoC <- as.data.frame(m_coef_weibull_OS_SoC)
colnames(df.m_coef_weibull_OS_SoC) <- c("shape", "scale")  # Set the column names

# Calculate the mean and variance of the shape and scales below:

# To compare the empirical mean and variance of your data to the theoretical mean and variance of the fitted Weibull distribution, you can follow these steps:

# Calculate the empirical mean and variance of your data.
# Estimate the parameters of the Weibull distribution using the fitdist function.
# Calculate the theoretical mean and variance of the Weibull distribution using the estimated parameters.
# Compare the empirical and theoretical values.

# Check for non-positive values
if(any(df.m_coef_weibull_OS_SoC$shape <= 0) | any(df.m_coef_weibull_OS_SoC$scale <= 0)) {
  stop("Data contains non-positive values, which are not suitable for Weibull distribution fitting.")
}

# Calculate the empirical mean and variance
empirical_mean_shape <- mean(df.m_coef_weibull_OS_SoC$shape)
empirical_variance_shape <- var(df.m_coef_weibull_OS_SoC$shape)

empirical_mean_scale <- mean(df.m_coef_weibull_OS_SoC$scale)
empirical_variance_scale <- var(df.m_coef_weibull_OS_SoC$scale)

# Empirical Mean and Variance: Calculated directly from your data using the mean and var functions.

# Extract the estimated parameters for 'shape'
shape_params <- shape_fit$estimate
shape_shape <- shape_params["shape"]
shape_scale <- shape_params["scale"]

# Calculate the theoretical mean and variance for 'shape'

# Theoretical Mean and Variance: Calculated using the formulas for the mean and variance of the Weibull distribution, with the parameters estimated by fitting the distribution to your data.

# Load necessary package for the gamma function
# library(stats)

# The mean and variance of a Weibull distribution with shape parameter a and scale parameter b are given by: 

# Mean: bΓ( 1 + 1/ a)

# Variance: b^2 (Γ( 1 + 2/ a) − [Γ(1 + 1/ a)]^2)

# Where Γ is the Gamma function.

# This is supported by: https://stats.libretexts.org/Courses/Saint_Mary%27s_College_Notre_Dame/MATH_345__-_Probability_(Kuter)/4%3A_Continuous_Random_Variables/4.6%3A_Weibull_Distributions also saved here: C:\Users\Jonathan\OneDrive - Royal College of Surgeons in Ireland\COLOSSUS\Training Resources\Decision Modelling - Advanced Course\A2_Making Models Probabilistic\A2.1.2 Distributions for parameters\4.6_ Weibull Distributions - Statistics LibreTexts.pdf


theoretical_mean_shape <- shape_scale * gamma(1 + 1 / shape_shape)
theoretical_variance_shape <- (shape_scale^2) * (gamma(1 + 2 / shape_shape) - (gamma(1 + 1 / shape_shape))^2)

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


# Overlaying the theoretical Weibull distribution curve on the histograms in R involves a few steps. You'll need to:

# Fit the Weibull distribution to your data.
# Generate the theoretical Weibull density values.
# Plot the histogram of your data.
# Overlay the Weibull density curve on the histogram.

# Steps to Fitting Weibull Distribution and Overlaying the Curve

# Fit the Weibull distribution to the  data: Use the fitdistr function from the MASS package to estimate the parameters of the Weibull distribution.
# Generate the theoretical Weibull density values: Use the dweibull function to calculate the density values.
# Plot the histogram: Use the hist function to create the histogram.
# Overlay the Weibull density curve: Use the lines function to add the density curve to the histogram.


# # 2: In densfun(x, parm[1], parm[2], ...) : NaNs produced stackoverflow.com/questions/41227303/fitdistr-warning-with-dbeta-in-densfunx-parm1-parm2-nans-prod, it seems like this wouldnt be a problem and the code would still execute, however, in the future this error message might confuse me and lead me to believe there is some larger issue, or it may pop up and I may not know what it belongs to and spend a long time hunting it down, so I just switch from fitdistr to fitdist. Other description here: https://stats.stackexchange.com/questions/230420/alternatives-to-fitdistr-for-gamma-in-r https://stats.stackexchange.com/questions/158163/why-does-this-data-throw-an-error-in-r-fitdistr

# Initial Parameter Estimates: This is an approach I know nothing about, I don't know if it would produce nonsense data or what may come out...

# Providing initial parameter estimates (shape_initial and scale_initial) can help guide the optimization process and avoid issues with NaNs.

# Provide initial parameter estimates
# shape_initial <- c(shape = 1, scale = 1)
# scale_initial <- c(shape = 1, scale = 1)

# Fitting the Distribution: Using fitdistr with the start argument to provide initial estimates.

# Fit Weibull distribution to the 'shape' data
# shape_fit <- fitdistr(m_coef_weibull_OS_SoC$shape, "weibull", start = shape_initial)


# If you prefer not to provide initial parameter estimates, you can use a more robust fitting method that is less sensitive to initial conditions. One such method is the fitdist function from the fitdistrplus package, which can automatically handle initial parameter estimates.

# Fitting the Weibull distribution: fitdist(m_coef_weibull_OS_SoC$shape, "weibull") fits the Weibull distribution to the shape data and fitdist(m_coef_weibull_OS_SoC$scale, "weibull") fits it to the scale data.

# Check for non-positive values
if(any(df.m_coef_weibull_OS_SoC$shape <= 0) | any(df.m_coef_weibull_OS_SoC$scale <= 0)) {
  stop("Data contains non-positive values, which are not suitable for Weibull distribution fitting.")
}


# Fit Weibull distribution to the 'shape' data
shape_fit <- fitdist(df.m_coef_weibull_OS_SoC$shape, "weibull")

# Extract the estimated parameters
shape_params <- shape_fit$estimate
shape_shape <- shape_params["shape"]
shape_scale <- shape_params["scale"]

# Generate theoretical Weibull density values
x_shape <- seq(min(df.m_coef_weibull_OS_SoC$shape), max(df.m_coef_weibull_OS_SoC$shape), length.out = 100)
y_shape <- dweibull(x_shape, shape = shape_shape, scale = shape_scale)

# Generating density values: dweibull generates the density values for the theoretical Weibull distribution.


hist_data <- hist(df.m_coef_weibull_OS_SoC$shape, plot = FALSE)

# Open a graphics device to save the plot to a file
png(filename = paste0(variable_label, "_", country_name, "shape_histogram.png"), width = 800, height = 600)

# Plot histogram and overlay Weibull density curve
hist(df.m_coef_weibull_OS_SoC$shape, breaks = 30, freq = FALSE, main = "", xlab = "Shape")
lines(x_shape, y_shape, col = "darkblue", lwd = 2)

# In this code the col parameter sets the color of the line, lwd sets the line width, and lty sets the line type (1 = solid, 2 = dashed, etc.).

# Add rug plot
rug(random_values, col = "darkred")

# In this code, rug(random_values) adds a rug plot at the bottom of the histogram, which shows the individual data points as small vertical lines.

# Plotting the histogram: hist plots the histogram of the data.
# Overlaying the density curve: lines adds the Weibull density curve to the histogram.

#  This approach should help visualize how well the Weibull distribution fits the data by overlaying the theoretical density curve on top of the histogram.

# Add legend for mean and variance of data and theoretical distribution
legend("topright", inset = c(-0.037, 0), legend = c(paste("Data Mean: ", round(empirical_mean_shape, 3)), paste("Data Variance: ", round(empirical_variance_shape, 3)), paste("Theoretical Mean: ", round(theoretical_mean_shape, 3)), paste("Theoretical Variance: ", round(theoretical_variance_shape, 3)), "Rug plot (dark red ticks)", "Theoretical Weibull Distribution (dark blue curve)"), cex = 0.8, xpd = TRUE)

# Instead of specifying the coordinates directly, you can use the inset parameter in the legend function to adjust the legend position relative to the corner of the plot. The inset parameter takes a two-element numeric vector indicating the x (horizontal) and y (vertical) distances from the corner of the plot.

# In this code, inset = c(-0.2, 0) shifts the legend 20% of the plot width to the left from the top right corner. You can adjust these values as needed to move the legend to the desired position. The negative value for the x-coordinate shifts the legend to the left.

# Add title
title(main = paste("Histogram of Shape Parameters with Weibull fit for first line treatment to death from the multivariate normal distribution in PSA for", country_name), line = 2, cex.main = 1)

# Decrease the size of the title text: You can use the cex.main argument in the title function to adjust the size of the title text. cex.main is a numerical value giving the amount by which plotting text and symbols should be scaled relative to the default. 1=default, 1.5 is 50% larger, 0.5 is 50% smaller, etc. In this code, cex.main = 0.8 decreases the size of the title text by 20%.


# Close the graphics device
dev.off()


# Histogram of Scale Parameters with Weibull Fit


# Repeat for the 'scale' data
scale_fit <- fitdist(df.m_coef_weibull_OS_SoC$scale, "weibull")

# Extract the estimated parameters
scale_params <- scale_fit$estimate
scale_shape <- scale_params["shape"]
scale_scale <- scale_params["scale"]

# Generate theoretical Weibull density values
x_scale <- seq(min(df.m_coef_weibull_OS_SoC$scale), max(df.m_coef_weibull_OS_SoC$scale), length.out = 100)
y_scale <- dweibull(x_scale, shape = scale_shape, scale = scale_scale)




# Generating density values: dweibull generates the density values for the theoretical Weibull distribution.

hist_data <- hist(df.m_coef_weibull_OS_SoC$scale, plot = FALSE)

# Open a graphics device to save the plot to a file
png(filename = paste0(variable_label, "_", country_name, "shape_histogram.png"), width = 800, height = 600)

# Plot histogram and overlay Weibull density curve
hist(df.m_coef_weibull_OS_SoC$scale, breaks = 30, freq = FALSE, main = "", xlab = "Scale")
lines(x_scale, y_scale, col = "darkblue", lwd = 2)


# In this code the col parameter sets the color of the line, lwd sets the line width, and lty sets the line type (1 = solid, 2 = dashed, etc.).

# Add rug plot
rug(random_values, col = "darkred")

# In this code, rug(random_values) adds a rug plot at the bottom of the histogram, which shows the individual data points as small vertical lines.

# Plotting the histogram: hist plots the histogram of the data.
# Overlaying the density curve: lines adds the Weibull density curve to the histogram.

#  This approach should help visualize how well the Weibull distribution fits the data by overlaying the theoretical density curve on top of the histogram.

# Add legend for mean and variance of data and theoretical distribution
legend("topright", inset = c(-0.037, 0), legend = c(paste("Data Mean: ", round(empirical_mean_scale, 3)), paste("Data Variance: ", round(empirical_variance_scale, 3)), paste("Theoretical Mean: ", round(theoretical_mean_scale, 3)), paste("Theoretical Variance: ", round(theoretical_variance_scale, 3)), "Rug plot (dark red ticks)", "Theoretical Weibull Distribution (dark blue curve)"), cex = 0.8, xpd = TRUE)

# Instead of specifying the coordinates directly, you can use the inset parameter in the legend function to adjust the legend position relative to the corner of the plot. The inset parameter takes a two-element numeric vector indicating the x (horizontal) and y (vertical) distances from the corner of the plot.

# In this code, inset = c(-0.2, 0) shifts the legend 20% of the plot width to the left from the top right corner. You can adjust these values as needed to move the legend to the desired position. The negative value for the x-coordinate shifts the legend to the left.

# Add title
title(main = paste("Histogram of Scale Parameters with Weibull fit for first line treatment to death from the multivariate normal distribution in PSA for", country_name), line = 2, cex.main = 1)

# Decrease the size of the title text: You can use the cex.main argument in the title function to adjust the size of the title text. cex.main is a numerical value giving the amount by which plotting text and symbols should be scaled relative to the default. 1=default, 1.5 is 50% larger, 0.5 is 50% smaller, etc. In this code, cex.main = 0.8 decreases the size of the title text by 20%.


# Close the graphics device
dev.off()


# If I needed to create a scatter plot to observe any potential relationship between the shape and scale parameters.

# Summary statistics
summary(m_coef_weibull_OS_SoC)

# Summary Statistics: Compute the mean, median, standard deviation, and range for both the shape and scale parameters.

# These analyses should help  gain insights into the distribution and relationship of the Weibull parameters in my dataset.

# Scatter plot of Shape Vs Scale:
# plot(df.m_coef_weibull_OS_SoC$shape, df.m_coef_weibull_OS_SoC$scale, 
#     main = "Scatter Plot of Shape vs Scale", 
#     xlab = "Shape", ylab = "Scale")


