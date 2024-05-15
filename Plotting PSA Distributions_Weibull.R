# Generate random values
random_draws <- rweibull(n_runs, shape = m_coef_weibull_SoC[1], scale = m_coef_weibull_SoC[2])

# Plot histogram
hist(random_draws, main="Histogram of Random Values", xlab="Value", breaks=50, col="lightblue", freq=FALSE)

# Add theoretical Weibull distribution curve
curve(dweibull(x, shape = m_coef_weibull_SoC[1], scale = m_coef_weibull_SoC[2]), add = TRUE, col = "yellow", lwd = 2)


# Calculate sample mean and variance
sample_mean <- mean(random_draws)
sample_variance <- var(random_draws)

# Calculate theoretical mean and variance
theoretical_mean <- m_coef_weibull_SoC[2] * gamma(1 + 1/m_coef_weibull_SoC[1])
theoretical_variance <- m_coef_weibull_SoC[2]^2 * (gamma(1 + 2/m_coef_weibull_SoC[1]) - (gamma(1 + 1/m_coef_weibull_SoC[1]))^2)

# Print values
cat("Sample Mean:", sample_mean, "\n")
cat("Theoretical Mean:", theoretical_mean, "\n")
cat("Sample Variance:", sample_variance, "\n")
cat("Theoretical Variance:", theoretical_variance, "\n")


