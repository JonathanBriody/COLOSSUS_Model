
# Country-specific cost data:


# Basically, what I have is 1 Rmarkdown document with appropriate CEA code, but 3 countries I want to separately apply this code to, because costs (and willingness to pay thresholds) are different in each of these 3 countries.

# To do this, I used to feed in the cost data from each country for parameters that differ across countries, just uncomment the country you want to run this code for:


# Now I have this separte R Script that calls the markdown document and executes everything within instead, updating the costs that way:



# Define a list of countries and their corresponding values
countries <- list(
  "Ireland" = list(
country_name <- "Ireland",
c_PFS_Folfox <- 141.66,
c_PFS_Bevacizumab <- 1187.55,
c_OS_Folfiri <- 150.04,
administration_cost <- 365.00,
subtyping_test_cost <- 400,
c_AE1 <- 2835.89,
c_AE2 <- 1458.80,
c_AE3 <- 409.03,
n_wtp = 45000
  ),
  "Germany" = list(
    country_name <- "Germany",
    c_PFS_Folfox <- ((1276.66 / 30) * 14),
    c_PFS_Bevacizumab <- ((2952.24 / 30) * 14),
    c_OS_Folfiri <- ((1309.64 / 30) * 14),
    administration_cost <- 1794.40,
    subtyping_test_cost <- 400,
    c_AE1 <- 3837,
    c_AE2 <- 1816.37,
    c_AE3 <- 68,
    n_wtp = 78871
),
  "Spain" = list(
    country_name <- "Spain",
    c_PFS_Folfox <- 297.97,
    c_PFS_Bevacizumab <- 1325.87,
    c_OS_Folfiri <- 139.58,
    administration_cost <- 314.94,
    subtyping_test_cost <- 400,
    c_AE1 <- 4885.95,
    c_AE2 <- 285.49,
    c_AE3 <- 32.81,
    n_wtp = 30000
    )
)

# Load the rmarkdown package
library(rmarkdown)


# Loop over the list of countries
for (country_name in names(countries)) {
  # Define the parameters for the current country
  params <- list(
    country_name = country_name,
    c_PFS_Folfox = countries[[country_name]]$c_PFS_Folfox,
    c_PFS_Bevacizumab = countries[[country_name]]$c_PFS_Bevacizumab,
    c_OS_Folfiri = countries[[country_name]]$c_OS_Folfiri,
    administration_cost = countries[[country_name]]$administration_cost,
    subtyping_test_cost = countries[[country_name]]$subtyping_test_cost,
    c_AE1 = countries[[country_name]]$c_AE1,
    c_AE2 = countries[[country_name]]$c_AE2,
    c_AE3 = countries[[country_name]]$c_AE3,
    n_wtp = countries[[country_name]]$n_wtp
  )



  # Render the R Markdown document with the current parameters
  rmarkdown::render("Markov_3state.Rmd", params = params)
}



