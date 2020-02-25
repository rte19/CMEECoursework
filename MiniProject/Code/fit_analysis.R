#!usr/bin/env R

###A script to analyse the model fitting results (AICs) produced from the models_all.R script

library(ggplot2)

###Reading in the data
AICs <- read.csv("../Data/AICs.csv")

#For both AIC and BIC, If model A has AIC lower by 2-3 or more than
#model B, it’s better — Differences of less than 2-3 don’t really matter
#row,column

###Function to calculate the fit percentage of a given model in the AICs csv
fit_percentage <- function(model_AIC){
  Counter <-  length(AICs$ID)
  Counter_fit <- 0
  for(i in model_AIC){
    if(is.na(i) == FALSE && is.infinite(i) == FALSE){
      Counter_fit <- Counter_fit + 1
    }
  }
  Counter_fit_percentage <- Counter_fit / Counter * 100
  return(as.numeric(Counter_fit_percentage))
}
###How well did linear regression the fit the datasets?
Counter_Regression_percentage <- fit_percentage(AICs$Regression_AIC)
model1 <- "Regression"
AIC_percentages <- data.frame(model1, Counter_Regression_percentage, stringsAsFactors = FALSE)
names(AIC_percentages) <- c("Model", "Fit_percentage")

###How well did the quadratic the fit the datasets?
Counter_Quadratic_percentage <- fit_percentage(AICs$Quadrtic_AIC)
model2 <- "Quadratic"
Quadratic_percentage <- c(model2, Counter_Quadratic_percentage)
AIC_percentages <- rbind(AIC_percentages, Quadratic_percentage)

###How well did the cubic the fit the datasets?
Counter_Cubic_percentage <- fit_percentage(AICs$Cubic_AIC)
model3 <- "Cubic"
Cubic_percentage <- c(model3, Counter_Cubic_percentage)
AIC_percentages <- rbind(AIC_percentages, Cubic_percentage)

###How well did the logistic model the fit the datasets?
Counter_Logistic_percentage <- fit_percentage(AICs$Logistic_AIC)
model4 <- "Logistic"
Logistic_percentage <- c(model4, Counter_Logistic_percentage)
AIC_percentages <- rbind(AIC_percentages, Logistic_percentage)

###How well did Gompertz model the fit the datasets?
Counter_Gompertz_percentage <- fit_percentage(AICs$Gompertz_AIC)
model5 <- "Gompertz"
Gompertz_percentge <- c(model5, Counter_Gompertz_percentage)
AIC_percentages <- rbind(AIC_percentages, Gompertz_percentge)

###How well did Baranyi model the fit the datasets?
Counter_Baranyi_percentage <- fit_percentage(AICs$Baranyi_AIC)
model6 <- "Baranyi"
Baranyi_percentage <- c(model6, Counter_Baranyi_percentage)
AIC_percentages <- rbind(AIC_percentages, Baranyi_percentage)

AIC_percentages <- transform(AIC_percentages, Fit_percentage = as.numeric(Fit_percentage))
ggplot(data = AIC_percentages, aes(x = AIC_percentages$Model, y = AIC_percentages$Fit_percentage)) +
  geom_bar(stat = "identity") +
  labs(title = "Fit percentage of each model across all the dataset IDs", x = "Model", y = "Percentage (%)")
