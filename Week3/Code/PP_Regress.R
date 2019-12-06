#!/usr/bin/env R

###A script that makes a fancy figure out of its data and saves the
###regression statistics in a csv file

rm(list = ls())
graphics.off()

library(ggplot2)
library(tidyr)
library(dplyr)

MyData <- read.csv("../Data/EcolArchives-E089-51-D1.csv") #Reading in the data
#head(MyData)

#Saving the figure as a pdf
pdf("../Results/PP_Regress.pdf")

#Plotting the figure
p <- ggplot(MyData, aes(x = Prey.mass,
                    y = Predator.mass,
                    colour = Predator.lifestage)) +
                    scale_x_log10() +
                    scale_y_log10() +
                    xlab("Prey Mass in Grams") +
                    ylab("Predator Mass in Grams") +
                    theme(legend.position = "bottom") +
                    geom_point(shape = I(3)) + #shaping the points as crosses
                    geom_smooth(method = "lm", fullrange = TRUE) + #straight lines that extrapolate to the edge of the axises
                    facet_grid(Type.of.feeding.interaction~.) #facetting by type of feeding interaction in a column 
p    

graphics.off()

RSqfun <- function(ModelFit, ModelData){
  RSS <- sum(residuals(ModelFit)^2) #Residual sum of squares of quadratic
  TSS <- sum((ModelData - mean(ModelData))^2) #Total sum of squares of quadratic
  RSq <- 1 - (RSS/TSS) #R-squared value
  return(RSq)
}

PP_Regress_Results <- as.data.frame(matrix(nrow = 1, ncol = 6))
names(PP_Regress_Results) <- c("Type.Of.Feeding.Interaction_Predator.Lifestage", "Slope", "Y.Intercept", "Rsq", "Fstatistic", "pvalue")

Data <- MyData %>%
  nest(-Type.of.feeding.interaction, -Predator.lifestage)

Data$ID <- paste(Data$Type.of.feeding.interaction, Data$Predator.lifestage, sep = "_")

for(i in 1:length(Data$data)){
  ModelData <- Data$data[[i]]
  line <- lm(log(Predator.mass) ~ log(Prey.mass), ModelData)
  ID <- Data$ID[i]  
  slope <- coef(line)["log(Prey.mass)"]
  intercept <- coef(line)["(Intercept)"]
  Rsq <- RSqfun(line, log(ModelData$Predator.mass))
  Fstatistic <- anova(lm(log(Predator.mass) ~ log(Prey.mass), ModelData))[1, 4]
  pvalue <- anova(lm(log(Predator.mass) ~ log(Prey.mass), ModelData))[1, 5]
  
  temp.vector <- c(ID, slope, intercept, Rsq, Fstatistic, pvalue)
  PP_Regress_Results <- rbind(PP_Regress_Results, temp.vector)
}

write.csv(PP_Regress_Results, "../Results/PP_Regress_Results.csv")
