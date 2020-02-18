#!usr/bin/env R

rm(list = ls())
graphics.off()

library(dplyr)
library(tidyr)
library(ggplot2)
library(minpack.lm)

Data <- read.csv("../Data/LogisticGrowthData.csv", header = TRUE) #Reading in the original data
Data$Temp <- as.factor(Data$Temp) #Making the temperature values factors - categorical instead of continuous

Data <- Data[-c(which(Data$PopBio == -668.283935900778)), ]
###Nesting the data for each unique combination of species, medium and temp, to then run models on each of these dataframes
Data2 <- Data %>%
  nest(-Temp,-Medium,-Species) #Using tidyr to create loads of dataframes for each combination of Temp, Medium, Species
#Data2 <- nest(Data, c(-Temp, -Medium, -Species)) #Alternative to the way above
Data2$ID <- paste(Data2$Species, Data2$Medium, Data2$Temp, sep = "_") #Creating the unique IDs for each little dataset in format species_medium_temperature

###Function for calculating the R^2
# RSqfun <- function(ModelFit, ModelData){
#   RSS <- sum(residuals(ModelFit)^2) #Residual sum of squares of quadratic
#   TSS <- sum((ModelData - mean(ModelData))^2) #Total sum of squares of quadratic
#   RSq <- 1 - (RSS/TSS) #R-squared value
#   return(RSq)
# }

###Defining the Logistic equation
LogisticMod <- function(N0, Nmax, r, t){
  return((N0 * Nmax * exp(r*t)) / (Nmax + N0 * (exp(r*t) - 1)))
}

# Nt = population size at time t, PopBio
# N0 = initial population size
# Nmax = carrying capacity (K)
# r = maximum growth rate (rmax)
# t = time

###Defining the Gompertz model
GompertzMod <- function(N0, Nmax, r, t, A, tlag){
  return(A * exp(-exp(((rmax * exp(tlag - t)) / A) + 1)))
}

# Nt = population size at time t, PopBio
# N0 = initial population size
# Nmax = carrying capacity (K)
# r = maximum growth rate (rmax)
# t = time
# A = the asymptote A = log(Nmax/N0)
# tlag = is the x-axis intercept to this tangent (duration of the delay before the popuation starts growing exponentially)

###Creating the dataframe to hold all stats results
StatsRESULTS <- data.frame(ID = character(), Straight_Line_AIC = numeric(), Quadrtic_AIC = numeric(), Cubic_AIC = numeric(), Logistic_AIC = numeric(), Gompertz_AIC = numeric(), stringsAsFactors = FALSE)

###Fitting Linear models and recording RSq, AIC and BIC for all models for each ID

###Fitting a straight line model iteratively over all the dataset
for (i in 1:length(Data2$data)){
  ModelData <- Data2$data[[i]] #Getting one set of data at a time for each of the models
  
  N0 <- min(ModelData$PopBio) #Starting value for N0 being the mininmum of the PopBio data
  Nmax <- max(ModelData$PopBio) #Starting value for Nmax being the maximum of the PopBio data 
  
  rdata <- ModelData
  a <- lm(rdata$PopBio ~ rdata$Time)
  r <- a$coefficients[2]
  for(j in 1:(dim(ModelData)[1] - 2)){
    rdata <- rdata[-c(which(ModelData$Time == max(ModelData$Time))), ]
    if(length(unique(rdata$Time)) != 1){
      a2 <- lm(rdata$PopBio ~ rdata$Time)
      r2 <- a2$coefficients[2]
      if(r < r2){
        r <- r2
      }
    }
    # if (r > 0.9) {
    #   break
    # }
  }
  r <- as.numeric(r)
  
  A <- log(Nmax / N0)
  tlag <- min(ModelData$PopBio)
  
  ID <- Data2$ID[i] #Getting the ID for each dataset modelled
  StraiFit <- lm(PopBio ~ Time, data = ModelData) #Running the straight line model  
  StraiAIC <- AIC(StraiFit) #Calling the AIC of the straight line model
  
  QuaFit <- lm(PopBio ~ poly(Time, 2), data = ModelData) #Runing the quadratic model    
  QuaiAIC <- AIC(QuaFit)
  
  CubFit <- lm(PopBio ~ poly(Time, 3), data = ModelData) #Running the cubic model    
  CubAIC <- AIC(CubFit)
  
  LogisFit <- try(nlsLM(PopBio ~ LogisticMod(N0, Nmax, r, t = Time), data = ModelData, start = c(N0 = N0, Nmax = Nmax, r = r), control = nls.lm.control(maxiter = 100)), silent = T) #Running the logistic model with prior estimated starting values, but using try to keep going when it fails to optimise
  if (class(LogisFit) != 'try-error'){
    LogisAIC <- AIC(LogisFit)
  } else {
    LogisAIC <- "NA"
  }
  
  GompertzFit <- try(nlsLM(PopBio ~ GompertzMod(N0, Nmax, r, t = Time, A, tlag), data = ModelData, start = c(N0 = N0, Nmax = Nmax, r = r, A = A, tlag = tlag), control = nls.lm.control(maxiter = 100)), silent = T) #Running the Gompertz model with prior estimated starting values, but using try to keep going when it fails to optimise
  if (class(GompertzFit) != 'try-error'){
    GompertzAIC <- AIC(GompertzFit)
  } else {
    GompertzAIC <- "NA"
  }
  
  temp.vector <- c(ID, StraiAIC, QuaiAIC, CubAIC, LogisAIC, GompertzAIC)
  
  StatsRESULTS[i, ] <- temp.vector
}

counter <- 0
for(i in StatsRESULTS$Logistic_AIC){ if(i != "NA"){counter <- counter + 1}}

#For both AIC and BIC, If model A has AIC lower by 2-3 or more than
#model B, it’s better — Differences of less than 2-3 don’t really matter
#row,column