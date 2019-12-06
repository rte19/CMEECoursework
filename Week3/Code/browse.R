#!/usr/bin/env R

rm(list = ls())
graphics.off()

###Debugging the code using browser()

Exponential <- function(N0 = 1, r = 1, generations = 10){
  #Runs a simulation of exponential growth
  #Returns a vector of length generations
  
  N <- rep(NA, generations) #Creates a vector of NA
  
  N[1] <- N0
  for( t in 2:generations){
    N[t] <- N[t-1] * exp(r)
    browser()
  }
  return(N)
}

plot(Exponential(), type = "l", main = "Exponential growth")


#The script will be run till the first iteration of the for loop and 
#the console will enter the browser mode, which looks like this:

#Browse[1]>

#Now, you can examine the variables present at that point. Also, at 
#the browser console, you can enter expressions as normal, or use a 
#few particularly useful debug commands (similar to the Python 
#debugger):

#n: single-step
#c: exit browser and continue
#Q: exit browser and abort, return to top-level.
