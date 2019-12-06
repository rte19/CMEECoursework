#!/usr/bin/env R

###Rather than having R throw you out of the code, you would rather 
###catch the error and keep going. This can be done using try. Lets 
###try try.

rm(list = ls())
graphics.off()

###First, let's write a function that runs a simulation that involves 
###sampling from a synthetic population with replacement and takes its 
###mean, but only if at least 30 unique samples are obtained.

doit <- function(x){
  temp_x <- sample(x, replace = TRUE)
  if( length(unique(temp_x)) > 30) { #only take mean if sample was sufficient
    print(paste("Mean of this sample was:", as.character(mean(temp_x))))
  }
  else{
    stop("Couldn't calculate mean: too few unique values!")
  }
}

popn <- rnorm(50) #Generate your population

lapply(1:15, function(i) doit(popn))
# But in most cases, the script will fail because of the stop command
#at some iteration, returning less than the requested 15 mean values, 
#followed by an error stating that the mean could not be calculated 
#because too few unique values were sampled.

result <- lapply(1:15, function(i) try(doit(popn), FALSE))
#In this run, you again asked for the means of 15 samples, and again 
#you (most likely) got less than that but without any error! The 
#FALSE modifier for the try command suppresses any error messages, 
#but result will still contain them so that you can inspect them later

#The errors are stored in th object result: a list that stores the 
#result of each run, even the errors
class(result)

result

#You can also store the results "manually" by using a loop to do the same:
result2 <- vector("list", 15) #Preallocate/Initialise
for( i in 1:15){
  result2[[i]] <- try(doit(popn), FALSE)
}

result2
