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
LogisticMod <- function(N_0, N_max, r_max, t){
  return((N_0 * N_max * exp(r_max*t)) / (N_max + N_0 * (exp(r_max*t) - 1)))
}

# Nt = population size at time t, PopBio
# N_0 = initial population size
# N_max = carrying capacity (K)
# r = maximum growth rate (rmax)
# t = time

###Defining the Gompertz model
GompertzMod <- function(N_0, N_max, r_max, t, t_lag){ # Modified gompertz growth model (Zwietering 1990)
  return(N_0 + (N_max - N_0) * exp(-exp(r_max * exp(1) * (t_lag - t)/((N_max - N_0) * log(10)) + 1)))
}
  

# N_t = population size at time t, PopBio
# N_0 = initial population size
# N_max = carrying capacity (K)
# r = maximum growth rate (rmax)
# t = time
# t_lag = is the x-axis intercept to this tangent (duration of the delay before the popuation starts growing exponentially)

###Defining the Baranyi model
BaranyiMod <- function(N_0, N_max, r_max, t, t_lag){ # Baranyi model (Baranyi 1993)
  return(N_max + log10((-1+exp(r_max*t_lag) + exp(r_max*t))/(exp(r_max*t) - 1 + exp(r_max*t_lag) * 10^(N_max-N_0))))
}

###Creating the dataframe to hold all stats results
StatsRESULTS <- data.frame(ID = character(), Straight_Line_AIC = numeric(), Quadrtic_AIC = numeric(), Cubic_AIC = numeric(), Logistic_AIC = numeric(), Gompertz_AIC = numeric(), Baranyi_AIC = numeric(), stringsAsFactors = FALSE)

###Fitting Linear models and recording RSq, AIC and BIC for all models for each ID

###Fitting a straight line model iteratively over all the dataset
for (i in 1:length(Data2$data)){
  ModelData <- Data2$data[[i]] #Getting one set of data at a time for each of the models
  
  ###Startig values
  N_0 <- min(ModelData$PopBio) #Starting value for N0 being the mininmum of the PopBio data
  N_max <- max(ModelData$PopBio) #Starting value for Nmax being the maximum of the PopBio data 
  
  rdata <- ModelData
  a <- lm(rdata$PopBio ~ rdata$Time)
  r_max <- a$coefficients[2]
  y_int <- a$coefficients[1]
  for(j in 1:(dim(ModelData)[1] - 2)){
    rdata <- rdata[-c(which(ModelData$Time == max(ModelData$Time))), ]
    if(length(unique(rdata$Time)) != 1){
      a2 <- lm(rdata$PopBio ~ rdata$Time)
      r_max2 <- a2$coefficients[2]
      y_int2 <- a2$coefficients[1]
      if(r_max < r_max2){
        r_max <- r_max2
        y_int <- y_int2
      }
    }
    # if (r > 0.9) {
    #   break
    # }
  }
  r_max <- as.numeric(r_max)
  y_int <- as.numeric(y_int)
  #A <- log(Nmax / N0)
 # A <- max(ModelData$PopBio) 
#  tlag <- min(ModelData$PopBio)
 t_lag <- (-y_int) / r_max
   
  ###Fiting the models
  ID <- Data2$ID[i] #Getting the ID for each dataset modelled
  StraiFit <- lm(PopBio ~ Time, data = ModelData) #Running the straight line model  
  StraiAIC <- AIC(StraiFit) #Calling the AIC of the straight line model
  
  QuaFit <- lm(PopBio ~ poly(Time, 2), data = ModelData) #Runing the quadratic model    
  QuaiAIC <- AIC(QuaFit)
  
  CubFit <- lm(PopBio ~ poly(Time, 3), data = ModelData) #Running the cubic model    
  CubAIC <- AIC(CubFit)
  
  LogisFit <- try(nlsLM(PopBio ~ LogisticMod(N_0, N_max, r_max, t = Time), data = ModelData, start = c(N_0 = N_0, N_max = N_max, r_max = r_max), control = nls.lm.control(maxiter = 100)), silent = T) #Running the logistic model with prior estimated starting values, but using try to keep going when it fails to optimise
  if (class(LogisFit) != 'try-error'){
    LogisAIC <- AIC(LogisFit)
  } else {
    LogisAIC <- "NA"
  }
  
  GompertzFit <- try(nlsLM(PopBio ~ GompertzMod(N_0, N_max, r_max, t = Time, t_lag), data = ModelData, start = c(N_0 = N_0, N_max = N_max, r_max = r_max, t_lag = t_lag), control = nls.lm.control(maxiter = 100)), silent = T) #Running the Gompertz model with prior estimated starting values, but using try to keep going when it fails to optimise
  if (class(GompertzFit) != 'try-error'){
    GompertzAIC <- AIC(GompertzFit)
  } else {
    GompertzAIC <- "NA"
  }

  BaranyiFit <- try(nlsLM(PopBio ~ BaranyiMod(N_0, N_max, r_max, t = Time, t_lag), data = ModelData, start = c(N_0 = N_0, N_max = N_max, r_max = r_max, t_lag = t_lag), control = nls.lm.control(maxiter = 100)), silent = T) #Running the Baranyi model with prior estimated starting values, but using try to keep going when it fails to optimise
  if (class(BaranyiFit) != 'try-error'){
    BaranyiAIC <- AIC(BaranyiFit)
  } else {
    BaranyiAIC <- "NA"
  }    
  temp.vector <- c(ID, StraiAIC, QuaiAIC, CubAIC, LogisAIC, GompertzAIC, BaranyiAIC)
  
  StatsRESULTS[i, ] <- temp.vector
}

counter <- 0
for(i in StatsRESULTS$Logistic_AIC){ if(i != "NA"){counter <- counter + 1}}
counter2 <- 0
for(i in StatsRESULTS$Gompertz_AIC){ if(i != "NA"){counter <- counter + 1}}

#For both AIC and BIC, If model A has AIC lower by 2-3 or more than
#model B, it’s better — Differences of less than 2-3 don’t really matter
#row,column