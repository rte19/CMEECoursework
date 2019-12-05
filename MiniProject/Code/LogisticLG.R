#!usr/bin/env R

rm(list = ls())
graphics.off()

library(dplyr)
library(tidyr)
library(ggplot2)
library(minpack.lm)

Data <- read.csv("../Data/LogisticGrowthData.csv", header = TRUE) #Reading in the original data
Data$Temp <- as.factor(Data$Temp) #Making the temperature values factors - categorical instead of continuous

###Nested the data for each unique combination of species, medium and temp, to then run models on each of these dataframes
Data2 <- Data %>%
  nest(-Temp,-Medium,-Species) #using tidyrverse to create loads of dataframes for each combination of Temp, Medium, Species

###Defining the Logistic equation
LogisticMod <- function(N0, Nmax, r, t){
  return((N0 * Nmax * exp(1)^(r*t)) / Nmax + N0 * (exp(1)^(r*t) - 1))
}

# Nt = population size at time t, PopBio
# N0 = initial population size
# Nmax = carrying capacity (K)
# r = maximum growth rate (rmax)
# t = time

###Finding starting value for N0
LogisData <- Data2$data[[1]] #Isolating the datafrme of the species, medium and temp combination
N0 <- min(LogisData$PopBio)

###Finding starting value for Nmax
Nmax <- max(LogisData$PopBio)

###Finding starting value for r
rDataMax <- max(LogisData$PopBio) #Finding the maximum of the PopBio
rData <- dplyr::filter(LogisData, PopBio < (rDataMax - rDataMax * 0.04))
#Extracting everything less than 4% of the max, to isolate the growth portion of the graph

rDataFit <- lm(rData$PopBio ~ rData$Time)
summary(rDataFit)
r <- rDataFit$coefficients[2]

###Fitting the Logistic model to the data with these calculated starting values
LogisFit <- nlsLM 