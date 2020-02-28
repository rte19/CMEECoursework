#!usr/bin/env R

rm(list = ls())
graphics.off()

library(tidyr)
library(ggplot2)
library(minpack.lm)

Data <- read.csv("../Data/LogisticGrowthData.csv", header = TRUE) #Reading in the original data
Data$Temp <- as.factor(Data$Temp) #Making the temperature values factors - categorical instead of continuous

Data_positive <- Data
Data_positive <- Data_positive[-c(which(sign(Data_positive$PopBio) == -1)), ] #Only using observations with a positive PopBio

#Data <- Data[-c(which(Data$PopBio == -668.283935900778)), ]
###Nesting the data for each unique combination of species, medium and temp, to then run models on each of these dataframes
Data2 <- Data_positive %>%
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
# t_lag = is the x-axis intercept to this tangent (duration of the delay before the popuation starts growing exponentially)

###Defining the Gompertz model
GompertzMod <- function(N_0, N_max, r_max, t, t_lag){ # Modified gompertz growth model (Zwietering 1990)
  return(N_0 + (N_max - N_0) * exp(-exp(r_max * exp(1) * (t_lag - t)/((N_max - N_0) * log(10)) + 1)))
} #A is expressed in terms of N_max and N_0 for simplicity in obtaining starting values

###Defining the Baranyi model
BaranyiMod <- function(N_0, N_max, r_max, t, t_lag){ # Baranyi model (Baranyi 1993)
  return(N_max + log10((-1+exp(r_max*t_lag) + exp(r_max*t))/(exp(r_max*t) - 1 + exp(r_max*t_lag) * 10^(N_max-N_0))))
}

###Creating the dataframe to hold all stats results
StatsRESULTS <- data.frame(ID = character(), Regression_AIC = numeric(), Quadrtic_AIC = numeric(), Cubic_AIC = numeric(), Logistic_AIC = numeric(), Gompertz_AIC = numeric(), Baranyi_AIC = numeric(), stringsAsFactors = FALSE)

###Fitting Linear and non-linear models and recording AIC for all models for each ID
for (i in 1:length(Data2$data)){
  ModelData <- Data2$data[[i]] #Getting one set of data at a time for each of the models
  
  ###Startig values
  N_0_start <- min(ModelData$PopBio) #Starting value for N0 being the mininmum of the PopBio data
  N_max_start <- max(ModelData$PopBio) #Starting value for Nmax being the maximum of the PopBio data 
  
  rdata <- ModelData #Data to be messed around with to find r_max and t_lag
  a <- lm(rdata$PopBio ~ rdata$Time) #Initial regression fit
  r_max_start <- a$coefficients[2] #Gradient of initial regression fit
  y_int <- a$coefficients[1] #Y-intercept of the initial regression fit
  for(j in 1:(dim(ModelData)[1] - 2)){ #Leaving at least two data points, so regression fit can always be fitted
    rdata <- rdata[-c(which(ModelData$Time == max(ModelData$Time))), ] #Chopping off the observation that has the greatest time value
    if(length(unique(rdata$Time)) != 1){ #Some time points are the same, so even with 2 observations, if the Time points are the same, a regression cannot be fit. This prevents that situation
      a2 <- lm(rdata$PopBio ~ rdata$Time) #Nascent regression fit, of the truncated dataset
      r_max2 <- a2$coefficients[2] #Gradient of the nascent regression fit
      y_int2 <- a2$coefficients[1] #Y-intercept of the nascent regression fit
      if(r_max_start < r_max2){ #If the old gradient is less than the nacent gradient...
        r_max_start <- r_max2 #Make the the old gradient equal to the nascent one
        y_int <- y_int2 #Also make the old y-intercept equal to the nascent one, so the y-intercepts and gradients correspond
      }
    }
  }
  r_max_start <- as.numeric(r_max_start) #Make it a numeric class type
  y_int <- as.numeric(y_int)
  t_lag_start <- (-y_int) / r_max_start #t_lag is the x-intercept of the r_max tangent, so this calculates it
   
  ###Fiting the models
  ID <- Data2$ID[i] #Getting the ID for each dataset modelled
  RegFit <- lm(PopBio ~ Time, data = ModelData) #Running the regression model  
  RegAIC <- AIC(RegFit) #Calling the AIC of the regression model
  
  QuaFit <- lm(PopBio ~ poly(Time, 2), data = ModelData) #Runing the quadratic model    
  QuaAIC <- AIC(QuaFit)
  
  CubFit <- lm(PopBio ~ poly(Time, 3), data = ModelData) #Running the cubic model    
  CubAIC <- AIC(CubFit)
  
  LogisFit <- try(nlsLM(PopBio ~ LogisticMod(N_0, N_max, r_max, t = Time), data = ModelData, start = c(N_0 = N_0_start, N_max = N_max_start, r_max = r_max_start), control = nls.lm.control(maxiter = 100)), silent = T) #Running the logistic model with prior estimated starting values, but using try to keep going when it fails to optimise
  if (class(LogisFit) != 'try-error'){
    LogisAIC <- AIC(LogisFit)
  } else {
    LogisAIC <- "NA"
  }
  
  GompertzFit <- try(nlsLM(PopBio ~ GompertzMod(N_0, N_max, r_max, t = Time, t_lag), data = ModelData, start = c(N_0 = N_0_start, N_max = N_max_start, r_max = r_max_start, t_lag = t_lag_start), control = nls.lm.control(maxiter = 100)), silent = T) #Running the Gompertz model with prior estimated starting values, but using try to keep going when it fails to optimise
  if (class(GompertzFit) != 'try-error'){
    GompertzAIC <- AIC(GompertzFit)
  } else {
    GompertzAIC <- "NA"
  }

  BaranyiFit <- try(nlsLM(PopBio ~ BaranyiMod(N_0, N_max, r_max, t = Time, t_lag), data = ModelData, start = c(N_0 = N_0_start, N_max = N_max_start, r_max = r_max_start, t_lag = t_lag_start), control = nls.lm.control(maxiter = 100)), silent = T) #Running the Baranyi model with prior estimated starting values, but using try to keep going when it fails to optimise
  if (class(BaranyiFit) != 'try-error'){
    BaranyiAIC <- AIC(BaranyiFit)
  } else {
    BaranyiAIC <- "NA"
  }    
  temp.vector <- c(ID, RegAIC, QuaAIC, CubAIC, LogisAIC, GompertzAIC, BaranyiAIC)
  
  StatsRESULTS[i, ] <- temp.vector
  
  ###Creating the plots
  length <- seq(from = min(ModelData$Time), to = max(ModelData$Time), length.out = 200) #x-axis for the models
  
  RegFit_points <- predict.lm(RegFit, data.frame(Time = length)) #Generate the predicted response points from the model with the length as x coords
  df1 <- data.frame(length, RegFit_points) #Store the x and y coords in a dataframe
  df1$Model <- "Regression" #Make a new column for the model name
  names(df1) <- c("length", "PopBio_predict", "Model") #Naming the columns of the dataframe
  df_plot <- df1  #Assigning  this nascent dataframe to another
  
  QuaFit_points <- predict.lm(QuaFit, data.frame(Time = length)) #Same as above but for the quadratic model
  df2 <- data.frame(length, QuaFit_points)
  df2$Model <- "Quadratic"
  names(df2) <- c("length", "PopBio_predict", "Model")
  df_plot <- rbind(df_plot, df2) #rbinding the dataframe for the quadratic onto the df_plot: the dataframe to plot
  
  if(CubAIC != "NA" && is.infinite(CubAIC) == FALSE){ #Only do this if the AIC is both not an NA or infinite
  CubFit_points <- predict.lm(CubFit, data.frame(Time = length)) #Same as above but for cubic
  df3 <- data.frame(length, CubFit_points)
  df3$Model <- "Cubic"
  names(df3) <- c("length", "PopBio_predict", "Model")
  df_plot <- rbind(df_plot, df3)
  }
  if(LogisAIC != "NA" && is.infinite(LogisAIC) == FALSE){ #Only do this if the AIC is both not an NA or infinite
  LogisFit_points <- LogisticMod(t = length, r_max = coef(LogisFit)["r_max"], N_max = coef(LogisFit)["N_max"], N_0 = coef(LogisFit)["N_0"]) ##Generate the predicted response points from the model with the length as x coords. Using the parameters optimised previously
  df4 <- data.frame(length, LogisFit_points)
  df4$Model <- "Logistic"
  names(df4) <- c("length", "PopBio_predict", "Model")
  df_plot <- rbind(df_plot, df4)
  }
  if(GompertzAIC != "NA" && is.infinite(GompertzAIC) == FALSE){ #Same as above but for Gompertz
  GompertzFit_points <- GompertzMod(t = length, r_max = coef(GompertzFit)["r_max"], N_max = coef(GompertzFit)["N_max"], N_0 = coef(GompertzFit)["N_0"], t_lag = coef(GompertzFit)["t_lag"])
  df5 <- data.frame(length, GompertzFit_points)
  df5$Model <- "Gompertz"
  names(df5) <- c("length", "PopBio_predict", "Model")
  df_plot <- rbind(df_plot, df5)
  }
  if(BaranyiAIC != "NA" && is.infinite(BaranyiAIC) == FALSE){ #Same as above but for Baranyi
  BaranyiFit_points <- BaranyiMod(t = length, r_max = coef(BaranyiFit)["r_max"], N_max = coef(BaranyiFit)["N_max"], N_0 = coef(BaranyiFit)["N_0"], t_lag = coef(BaranyiFit)["t_lag"])
  df6 <- data.frame(length, BaranyiFit_points)
  df6$Model <- "Baranyi"
  names(df6) <- c("length", "PopBio_predict", "Model")
  df_plot <- rbind(df_plot, df6)
  }
  
  ###Plotting the models
  ggplot(ModelData, aes(x = Time, y = PopBio)) + #Plotting the dataset points for the unique ID
    geom_point(size = 2) + #Data point size
    geom_line(data = df_plot, aes(x = length, y = PopBio_predict, col = Model), size = 2) + #Plotting on the line models of all the models that fitted for df_plot
    scale_color_manual(values = c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2")) + #Giving the models clour blind friendly colours
    theme(aspect.ratio = 1) + #Making it square
    theme_bw() + #Making it black and white background
    labs(title = paste(ID), x = ("Time (Hours)"), y = paste("Population Biomass (", ModelData$PopBio_units[1],")", sep = "")) #Labels
  
  ggsave(paste("../Results/", ID, ".png", sep = ""), device = png()) #Saving the plot in results
  dev.off() #Destroying the plot, in preparation to make the next one in the next interation of the loop
}

write.csv(x = StatsRESULTS, file = "../Data/AICs.csv", row.names = FALSE)

#For both AIC and BIC, If model A has AIC lower by 2-3 or more than
#model B, it’s better — Differences of less than 2-3 don’t really matter
#row,column