# CMEE 2019 HPC excercises R code HPC run code proforma

rm(list=ls()) # good practice
graphics.off()
source("rte19_HPC_2019_main.R")
# it should take a faction of a second to source your file
# if it takes longer you're using the main file to do actual simulations
# it should be used only for defining functions that will be useful for your cluster run and which will be marked automatically

iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))
#iter <- 26
set.seed(iter)

if( iter > 0 & iter <= 25){
  size <- 500
}
if( iter > 25 & iter <= 50){
  size <- 1000
}
if( iter > 50 & iter <= 75){
  size <- 2500
}
if( iter > 75 & iter <= 100){
  size <- 5000
}
output_file_name <- paste("cluster_run_output", iter, ".rda", sep = "")
cluster_run(speciation_rate = 0.005091, size = size, wall_time = 11.5, interval_rich = 1, interval_oct = size/10, burn_in_generations = size*8, output_file_name = output_file_name)

# do what you like here to test your functions (this won't be marked)
# for example
#species_richness(c(1,4,4,5,1,6,1))
# should return 4 when you've written the function correctly for question 1

# you may also like to use this file for playing around and debugging
# but please make sure it's all tidied up by the time it's made its way into the main.R file or other files.
