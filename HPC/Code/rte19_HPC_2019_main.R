# CMEE 2019 HPC excercises R code main proforma
# you don't HAVE to use this but it will be very helpful.  If you opt to write everything yourself from scratch please ensure you use EXACTLY the same function and parameter names and beware that you may loose marks if it doesn't work properly because of not using the proforma.

name <- "Ryan Ellis"
preferred_name <- "Ryan"
email <- "ryan.ellis19@imperial.ac.uk"
username <- "rte19"
personal_speciation_rate <- 0.002 # will be assigned to each person individually in class and should be between 0.002 and 0.007

# Question 1
species_richness <- function(community){
  return(length(unique(community)))
}

# Question 2
init_community_max <- function(size){
  return(seq(size))
}

# Question 3
init_community_min <- function(size){
  return(seq(size) ^ 0)
}

# Question 4
choose_two <- function(max_value){
  return(sample(1:max_value, 2, replace = FALSE))
}

# Question 5
neutral_step <- function(community){
  choice <- choose_two(length(community))
  community[choice[1]] <- community[choice[2]]
  return(community)
}

# Question 6
neutral_generation <- function(community){
  if( length(community) %% 2 == 0){
    gen <- length(community) / 2 
  }
  else{
    gen <- (length(community) + sample(c(-1,1), size = 1)) / 2
  }
  for( i in 1:gen){
    community <- neutral_step(community)
  }
  return(community)
}

# Question 7
neutral_time_series <- function(community,duration)  {
  richness.series <- species_richness(community)
  for( i in 1:duration){
    community <- neutral_generation(community)
    richness.series <- c(richness.series, species_richness(community))
  }
return(richness.series)
}

# Question 8
question_8 <- function() {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  community <- init_community_max(100)
  duration <- 200
  ydata <- neutral_time_series(community, duration)
  xdata <- c(0, seq(duration))
  plot(ydata ~ xdata, ylab = "Species richness", xlab = "Generation")
  return("With enough generations, the system will always converge to a system of only one species. This is because of the stochastic nature of the system, one will always dominate in the end.")
}

# Question 9
neutral_step_speciation <- function(community,speciation_rate)  {
  speciation <- sample(c(1, 0), size = 1, prob = c(speciation_rate, 1 - speciation_rate))
  if( speciation == 1){
    species <- max(unique(community)) + 1
    choice <- choose_two(length(community))
    community[choice[1]] <- species
  }
  else{
    choice <- choose_two(length(community))
    community[choice[1]] <- community[choice[2]]
  }
  return(community)
}

# Question 10
neutral_generation_speciation <- function(community,speciation_rate)  {
  if( length(community) %% 2 == 0){
    gen <- length(community) / 2 
  }
  else{
    gen <- (length(community) + sample(c(-1,1), size = 1)) / 2
  }
  for( i in 1:gen){
    community <- neutral_step_speciation(community, speciation_rate)
  }
  return(community)
}

# Question 11
neutral_time_series_speciation <- function(community,speciation_rate,duration)  {
  richness.series <- species_richness(community)
  for( i in 1:duration){
    community <- neutral_generation_speciation(community, speciation_rate)
    richness.series <- c(richness.series, species_richness(community))
  }
  return(richness.series)
}

# Question 12
question_12 <- function()  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  community.max <- init_community_max(100)
  community.min <- init_community_min(100)
  duration <- 200
  speciation_rate <- 0.1
  ydata1 <- neutral_time_series_speciation(community.max, speciation_rate, duration)
  ydata2 <- neutral_time_series_speciation(community.min, speciation_rate, duration)
  xdata <- c(0, seq(duration))
  plot(ydata1 ~ xdata, ylab = "Species richness", xlab = "Generation", col = "green", type = "l")
  lines(ydata2 ~ xdata, col = "blue")
  legend(5, 95, legend = c("Initial max community", "Initial min community"), col = c("green", "blue"), lty = 1)
  return("With an initial community maximum, within the first few generations the species richness dramatically reduces. This reduction in species richness thereafter fluctuates around a steady state. This is due to species continually being out competed but because of the high number of individuals, the species richness can be rescued by speciation. 
         However, when we start with a initial community minimum, due to there being a high number of individuals, speciation occurs at the beginning, raising the species richness. Once the species richness reaches a certain level however, it too fluctuates around a steady state, maintind by the opposing forces of speciation and extinction. 
         The self sustaining oscillations of both comunities is in the long term very similar, given the fact that they are bound by identical parameters of population size and speciation rate.")
}

# Question 13
species_abundance <- function(community)  {
  abundance_vector <- sort(table(community), decreasing = TRUE) #tables are just vectors with added labels and frills
  return(as.vector(abundance_vector))
}

# Question 14
octaves <- function(abundance_vector) {
  max <- max(abundance_vector)
  n <- seq(ceiling(log10(max) / log10(2)))
  upper <- c()
  lower <- c()
  for(i in n){
    upper <- c(upper, 2 ^ (i))
    lower <- c(lower, 2 ^ (i - 1))
  }
  octave.vector <- c()
  for( j in 1:length(lower)){
    octave.vector <- c(octave.vector, length(which(abundance_vector >= lower[j] & abundance_vector < upper[j])))
  }
  return(octave.vector)
}
#>= 2^(n-1) 1 2 4 8  16 32 64  128
#<  2^n     2 4 8 16 32 64 128 256

# Question 15
sum_vect <- function(x, y){
  xlength <- length(x)
  ylength <- length(y)
  if( xlength == ylength){
    sumvect <- x + y
  }
  else{
    if( xlength < ylength){
      dif <- seq(ylength - xlength)
      for( i in dif){
        x <- c(x, 0)
      }
      sumvect <- x + y
    }
    else{
      dif <- seq(xlength - ylength)
      for( i in dif){
        y <- c(y, 0)
      }
      sumvect <- x + y
    }
  }
  return(sumvect)
}

# Question 16 
question_16 <- function()  {
  graphics.off()
  community.max <- init_community_max(100)
  community.min <- init_community_min(100)
  duration <- 200
  speciation_rate <- 0.1
  for( i in 1:duration){
    community1 <- neutral_generation_speciation(community = community.max, speciation_rate = speciation_rate)
    community2 <- neutral_generation_speciation(community = community.min, speciation_rate = speciation_rate)
  }
  octave.vector1 <- octaves(species_abundance(community1))
  octave.vector2 <- octaves(species_abundance(community2))
  
  generations <- 2000
  record.every <- 20
  octave.vector1.sum <- octave.vector1
  octave.vector2.sum <- octave.vector2
  for( j in 1:(generations/record.every)){
    for( k in 1:record.every){
      community1 <- neutral_generation_speciation(community = community1, speciation_rate = speciation_rate)
      community2 <- neutral_generation_speciation(community = community2, speciation_rate = speciation_rate)
    }
      octave.vector1.sum <- sum_vect(octave.vector1.sum, octaves(species_abundance(community1)))
      octave.vector2.sum <- sum_vect(octave.vector2.sum, octaves(species_abundance(community2)))
  }
  octave.vector1.av <- octave.vector1.sum/(generations/record.every)
  octave.vector2.av <- octave.vector2.sum/(generations/record.every)
  
  length1 <- length(octave.vector1.av)
  length2 <- length(octave.vector2.av)
  if( length1 != length2){
    if( length1 < length2){
      dif <- length2 - length1
      for( n in seq(dif)){
        octave.vector1.av <- c(octave.vector1.av, 0)
      }
    }
    else{
      dif <- length1 - length2
      for( n in seq(dif)){
        octave.vector2.av <- c(octave.vector2.av, 0)
      }
    }
  }
  my.df <- data.frame(initial_community_max = octave.vector1.av,
                      initial_community_min = octave.vector2.av)
  barplot(t(as.matrix(my.df)),
          beside = TRUE,
          legend.text = TRUE,
          args.legend = list(x = "topright", bty="n", inset=c(-0.10,0), xpd = TRUE))
  
  return("The initial condition of the community, whether it is a communtiy maximum or minimum makes no difference to the average state of the community after 200 years, for the next 2000 years.
         This is because ultimately the two communities are governed by the same population size and speciation rate. This means that the opposing forces for speciation and extinction will reach a dynamic equilibrium the same in both communities, given enough time.")
}

# Question 17
cluster_run <- function(speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, output_file_name)  {
  
}

# Questions 18 and 19 involve writing code elsewhere to run your simulations on the cluster

# Question 20 
process_cluster_results <- function()  {
  # clear any existing graphs and plot your graph within the R window
  combined_results <- list() #create your list output here to return
  return(combined_results)
}

# Question 21
question_21 <- function()  {
  return("type your written answer here")
}

# Question 22
question_22 <- function()  {
  return("type your written answer here")
}

# Question 23
chaos_game <- function()  {
  # clear any existing graphs and plot your graph within the R window
  return("type your written answer here")
}

# Question 24
turtle <- function(start_position, direction, length)  {

  return() # you should return your endpoint here.
}

# Question 25
elbow <- function(start_position, direction, length)  {
  
}

# Question 26
spiral <- function(start_position, direction, length)  {
  return("type your written answer here")
}

# Question 27
draw_spiral <- function()  {
  # clear any existing graphs and plot your graph within the R window
  
}

# Question 28
tree <- function(start_position, direction, length)  {
  
}
draw_tree <- function()  {
  # clear any existing graphs and plot your graph within the R window
}

# Question 29
fern <- function(start_position, direction, length)  {
  
}
draw_fern <- function()  {
  # clear any existing graphs and plot your graph within the R window
}

# Question 30
fern2 <- function(start_position, direction, length)  {
  
}
draw_fern2 <- function()  {
  # clear any existing graphs and plot your graph within the R window
}

# Challenge questions - these are optional, substantially harder, and a maximum of 16% is available for doing them.  

# Challenge question A
Challenge_A <- function() {
  # clear any existing graphs and plot your graph within the R window
}

# Challenge question B
Challenge_B <- function() {
  # clear any existing graphs and plot your graph within the R window
}

# Challenge question C
Challenge_C <- function() {
  # clear any existing graphs and plot your graph within the R window
}

# Challenge question D
Challenge_D <- function() {
  # clear any existing graphs and plot your graph within the R window
  return("type your written answer here")
}

# Challenge question E
Challenge_E <- function() {
  # clear any existing graphs and plot your graph within the R window
  return("type your written answer here")
}

# Challenge question F
Challenge_F <- function() {
  # clear any existing graphs and plot your graph within the R window
  return("type your written answer here")
}

# Challenge question G should be written in a separate file that has no dependencies on any functions here.


