# demonstrate parametric report
library(rmarkdown)

flowers <- unique(iris$Species) # setosa, versicolor, virginica - you know them all, don't you?

for (i in seq_along(flowers)) {
  myIris <- flowers[i]  # my species - to be reused as 1) parameter & 2) file name
  render("par-temp.Rmd", 
          params = list(species = myIris), 
          output_file = paste(myIris, '.pdf', sep = ''),
          quiet = T,
          encoding = 'UTF-8')
}

