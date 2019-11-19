#!usr/bin/env R

rm(list = ls())
graphics.off()

library(minpack.lm)
library(dplyr)
library(tidyr)
library(ggplot2)

Data <- read.csv("../Data/LogisticGrowthData.csv", header = TRUE) #Reading in the original data
Data$Temp <- as.factor(Data$Temp) #Making the temperature values factors - categorical instead of continuous

###Nested the data for each unique combination of species, medium and temp, to then run models on each of these dataframes
Data2 <- Data %>%
  nest(-Temp,-Medium,-Species) #using tidyrverse to create loads of dataframes for each combination of Temp, Medium, Species

###Defining the Logistic equation
LogisticMod <- function(N0, Nmax, r, t){
  return((N0 * Nmax * exp(1)^(r*t)) / Nmax + N0 * (exp(1)^(r*t) - 1))
}


###Defining a y=mx+c model
LinearMod <- function(x, m, c){
  return(m * x + c)
}


###Working out Nmax of the first x
NmaxData <- Data2$data[[1]] #Isolating the datafrme of the species, medium and temp combination
NmaxDataMax <- max(NmaxData$PopBio) #Finding the maximum of the PopBio
NmaxData <- dplyr::filter(NmaxData, PopBio > (NmaxDataMax - NmaxDataMax * 0.04)) 
#Extracting everything greater than 4% of the max, to isolate the carrying capacity portion of the graph
NmaxDataAv <- mean(NmaxData$PopBio) #Finding the average of the extracted PopBio, to use as a rough y-intercept in the LinearMod 

#ggplot(NmaxData, aes(x = Time, y = PopBio)) +
#  geom_point() #Plotting the extracted data to check it

LinearFit <- nlsLM(PopBio ~ LinearMod(Time, m, c), data = NmaxData, start = list(m = 0, c = NmaxDataAv))
#Applying th LinearMod to the extracted data, to fine te the coefficients, particularly the y-intercept, AKA the Nmax (carrying capacity)
#Starting values: Assuming the slope is 0, and the y-intercept is the NmaxDataAv
#summary(LinearFit)  
#coef(LinearFit)["m"]
Nmax <- coef(LinearFit)["c"] #Assigning the y-intercept of this portion of data as the Nmax


###Working out rmax for the first x
rData <- Data2$data[[1]] #Isolating the datafrme of the species, medium and temp combination
rDataMax <- max(rData$PopBio) #Finding the maximum of the PopBio
rData <- dplyr::filter(rData, PopBio < (rDataMax - rDataMax * 0.04))
#Extracting everything less than 4% of the max, to isolate the growth portion of the graph
rDataSlope <- mean(rData$PopBio) / mean(rData$Time) #Finding the mean slope of the graph. mean(m) = mean(y) / mean(x) + 0

#ggplot(rData, aes(x = Time, y = PopBio)) +
#  geom_point() #Plotting this extracted data to check it

LinearFit2 <- nlsLM(PopBio ~ LinearMod(Time, m, c), data = rData, start = list(m = rDataSlope, c = 0))
#Applying th LinearMod to the extracted data, to find the the coefficients, particularly the y-intercept, AKA the Nmax (carrying capacity)
#Starting values: Assuming the slope is rDataSlope, and the y-intercept is 0
#summary(LinearFit2)
r <- coef(LinearFit2)["m"] #Assigning the slope of this portion of data as the r
#coef(LinearFit2)["c"]

a <- lm(PopBio ~ Time, NmaxData)
summary(a)
s <- coef(a)["(Intercept)"]
s
Nmax
## These are the same, which is right?