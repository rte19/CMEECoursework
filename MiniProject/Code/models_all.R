#!usr/bin/env R

rm(list = ls())
graphics.off()

library(dplyr)
library(tidyr)
library(ggplot2)
library(minpack.lm)

Data <- read.csv("../Data/LogisticGrowthData.csv", header = TRUE) #Reading in the original data
Data$Temp <- as.factor(Data$Temp) #Making the temperature values factors - categorical instead of continuous

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

###Creating the variables to hold all stats results
StatsRESULTS <- as.data.frame(matrix(nrow = 1, ncol = 9))

###Fitting Linear models and recording RSq, AIC and BIC for all models for each ID

###Fitting a straight line model iteratively over all the dataset
for (i in 1:length(Data2$data)){
  ModelData <- Data2$data[[i]] #Getting one set of data at a time for each of the models
  
  N0 <- min(ModelData$PopBio) #Starting value for N0 being the mininmum of the PopBio data
  Nmax <- max(ModelData$PopBio) #Starting value for Nmax being the maximum of the PopBio data
  
  # ModelDataMax <- dplyr::filter(ModelData, PopBio == max(ModelData$PopBio)) #Extracting the row with the maximum PopBio
  # ModelDataMaxTime <- as.numeric(as.data.frame(ModelDataMax[1,2])) #Obtaining the Time of the maximum PopBio
  # rData <- dplyr::filter(ModelData, Time <= ModelDataMaxTime) #Extracting the rows all with Times <= the Time of the maximum PopBio
  # rDataFit <- lm(rData$PopBio ~ rData$Time) #Running a straight line through all these data points at and before the maximum PopBio
  # r <- rDataFit$coefficients[2] #Starting value of r being the gradient of these extracted data points
  
  rdata <- ModelData
  a <- lm(rdata$PopBio ~ rdata$Time)
  r <- a$coefficients[2]
  for(i in 1:(dim(ModelData)[1] - 2)){
    rdata <- rdata[-c(which(ModelData$Time == max(ModelData$Time))), ]
    a2 <- lm(rdata$PopBio ~ rdata$Time)
    r2 <- a2$coefficients[2]
    if(r < r2){
      r <- r2
    }
  }
  r <- as.numeric(r)
  
  ID <- Data2$ID[i] #Getting the ID for each dataset modelled
  StraiFit <- lm(PopBio ~ Time, data = ModelData) #Running the straight line model  
  StraiModel <- "StraightLine" #Defining the name of the model
#  StraiRSq <- RSqfun(StraiFit, ModelData$PopBio) #Calling the RSq of the straight line model
  StraiAIC <- AIC(StraiFit) #Calling the AIC of the straight line model
#  StraiBIC <- BIC(StraiFit) #Calling the BIC of the straight line model
  
  QuaFit <- lm(PopBio ~ poly(Time, 2), data = ModelData) #Runing the quadratic model    
  QuaModel <- "Quadratic" #Calling the model name, RSq, AIC and BIC of the quadratic linear model
#  QuaRSq <- RSqfun(QuaFit, ModelData$PopBio)
  QuaiAIC <- AIC(QuaFit)
#  QuaBIC <- BIC(QuaFit)
  
  CubFit <- lm(PopBio ~ poly(Time, 3), data = ModelData) #Running the cubic model    
  CubModel <- "Cubic" #Calling the model name, RSq, AIC and BIC of the cubic linear model
#  CubRSq <- RSqfun(CubFit, ModelData$PopBio)
  CubAIC <- AIC(CubFit)
#  CubBIC <- BIC(CubFit)
  
  LogisFit <- try(nlsLM(PopBio ~ LogisticMod(N0, Nmax, r, t = Time), data = ModelData, start = c(N0 = N0, Nmax = Nmax, r = r)), silent = T) #Running the logistic model with prior estimated starting values, but using try to keep going when it fails to optimise 
  LogisModel <- "Logistic"
  if (class(LogisFit) != 'try-error'){
#    LogisRSq <- RSqfun(LogisFit, ModelData$PopBio)
    LogisAIC <- AIC(LogisFit)
#    LogisBIC <- BIC(LogisFit)
  } else {
#    LogisRSq <- "NA"
    LogisAIC <- "NA"
#    LogisBIC <- "NA"
  }
  
#  temp.vector <- c(ID, StraiModel, StraiRSq, StraiAIC, StraiBIC, QuaModel, QuaRSq, QuaiAIC, QuaBIC, CubModel, CubRSq, CubAIC, CubBIC, LogisModel, LogisRSq, LogisAIC, LogisBIC)
  temp.vector <- c(ID, StraiModel, StraiAIC, QuaModel, QuaiAIC, CubModel, CubAIC, LogisModel, LogisAIC)
  
  StatsRESULTS <- rbind(StatsRESULTS, temp.vector)
}
#names(StatsRESULTS) <- c("ID", "Model_Name", "RSq", "AIC", "BIC", "Model_Name", "RSq", "AIC", "BIC", "Model_Name", "RSq", "AIC", "BIC", "Model_Name", "RSq", "AIC", "BIC")
names(StatsRESULTS) <- c("ID", "Model_Name", "AIC", "Model_Name", "AIC", "Model_Name", "AIC", "Model_Name", "AIC")


#For both AIC and BIC, If model A has AIC lower by 2-3 or more than
#model B, it’s better — Differences of less than 2-3 don’t really matter
#row,column