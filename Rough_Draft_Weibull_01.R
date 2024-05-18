# library(MASS)  # For fitdistr
# install.packages("fitdistrplus")
# install.packages("ggplot2")
# library(fitdistrplus)
# library(ggplot2)
# Load necessary package for the gamma function
# library(stats)


# it is necessary to ensure that m_coef_weibull_SoC is properly converted to a data frame before performing operations that use the $ operator.

# Here is how to can handle this in R, assuming m_coef_weibull_SoC is initially a matrix:

# Assuming df.m_coef_weibull_SoC is a matrix
df.m_coef_weibull_SoC <- as.data.frame(m_coef_weibull_SoC)
colnames(df.m_coef_weibull_SoC) <- c("shape", "scale")  # Set the column names

# Check for non-positive values
if(any(df.m_coef_weibull_SoC$shape <= 0) | any(df.m_coef_weibull_SoC$scale <= 0)) {
  stop("Data contains non-positive values, which are not suitable for Weibull distribution fitting.")
}


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
# shape_fit <- fitdistr(m_coef_weibull_SoC$shape, "weibull", start = shape_initial)


# If you prefer not to provide initial parameter estimates, you can use a more robust fitting method that is less sensitive to initial conditions. One such method is the fitdist function from the fitdistrplus package, which can automatically handle initial parameter estimates.



# Fitting the Weibull distribution: fitdist(m_coef_weibull_SoC$shape, "weibull") fits the Weibull distribution to the shape data and fitdist(m_coef_weibull_SoC$scale, "weibull") fits it to the scale data.

# Fit Weibull distribution to the 'shape' data
shape_fit <- fitdist(df.m_coef_weibull_SoC$shape, "weibull")

# Extract the estimated parameters
shape_params <- shape_fit$estimate
shape_shape <- shape_params["shape"]
shape_scale <- shape_params["scale"]

# Generate theoretical Weibull density values
x_shape <- seq(min(df.m_coef_weibull_SoC$shape), max(df.m_coef_weibull_SoC$shape), length.out = 100)
y_shape <- dweibull(x_shape, shape = shape_shape, scale = shape_scale)

# Generating density values: dweibull generates the density values for the theoretical Weibull distribution.

# Plot histogram and overlay Weibull density curve
hist(df.m_coef_weibull_SoC$shape, breaks = 30, freq = FALSE, main = "Histogram of Shape Parameters with Weibull Fit", xlab = "Shape")
lines(x_shape, y_shape, col = "red", lwd = 2)

# Plotting the histogram: hist plots the histogram of the data.
# Overlaying the density curve: lines adds the Weibull density curve to the histogram.

#  This approach should help visualize how well the Weibull distribution fits the data by overlaying the theoretical density curve on top of the histogram.

