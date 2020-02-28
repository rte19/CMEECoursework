#!usr/bin/env R

rm(list = ls())
graphics.off()
###A script to analyse the model fitting results (AICs) produced from the models_all.R script

library(ggplot2)

###Reading in the data
AICs <- read.csv("../Data/AICs.csv")

#For both AIC and BIC, If model A has AIC lower by 2-3 or more than
#model B, it’s better — Differences of less than 2-3 don’t really matter
#row,column

###Function to calculate the fit percentage of a given model in the AICs csv
fit_percentage <- function(model_AIC){
  Counter <-  length(AICs$ID) #Counts the numbers of observations
  Counter_fit <- 0
  for(i in model_AIC){
    if(is.na(i) == FALSE && is.infinite(i) == FALSE){ #If it's not infinite and not NA...
      Counter_fit <- Counter_fit + 1 #Count the AIC observation
    }
  }
  Counter_fit_percentage <- round((Counter_fit / Counter * 100), digits = 1) #The percentage of AICs of observations
  return(as.numeric(Counter_fit_percentage)) #Return the percentage as a numeric
}

###Function that works out, specifically, of how many times the model coverges, what percentage of that does it fit the best
###data = data (AICs), model_column = the column of AIC values for the model of interest (AICs$Regression_AIC), model_test_number = number corresponding to the order of model columns (1)
subset_best_fit <- function(data, model_column, model_test_number){
  subset <- subset(data, subset = !is.na(model_column) & !is.infinite(model_column)) #Filtering out the rows with -Inf or NA for that model of interest
  counter <- 0 #To count the number of times that model has the lowest score
  for(i in 1:length(subset$ID)){ #To iterate through all observations in subset
    a <- c(subset$Regression_AIC[i], subset$Quadrtic_AIC[i], subset$Cubic_AIC[i], subset$Logistic_AIC[i], subset$Gompertz_AIC[i], subset$Baranyi_AIC[i]) #a is the vector of the AIC values for the dataset observation
    for(k in 1:length(a)){
      if(is.infinite(a[k]) == TRUE | is.na(a[k]) == TRUE){ #If a value in a, so if an AIC, is infinite or NA...
        a[k] <- NaN #Make it a NaN
      }
    }
    best_fit <- c(which(a == min(a, na.rm = TRUE))) #Which is the lowest AIC indexes
    for(j in best_fit){ #Loopoing because which(a == min, na.rm = T) can produce more than one index if the lowest AIC is a draw
      if(j == model_test_number){ #If the lowest AIC index corresponds to the model of interest...
        counter <- counter + 1  #Count it
      }
    }
  }
  counter <- round((counter / length(subset$ID) * 100), digits = 1) #Percentage of how many times the model had the lowest AIC, within the datasets it fitted
  return(counter)
}

###How many times did linear regression the fit the datasets?
Counter_Regression_percentage <- fit_percentage(AICs$Regression_AIC) #Percentage of regression AICs made
model1 <- "Regression"
AIC_percentages <- data.frame(model1, Counter_Regression_percentage, stringsAsFactors = FALSE) #Make a dataframe of the model name and AIC percentage
names(AIC_percentages) <- c("Model", "Fit_percentage")

###How many times did the quadratic the fit the datasets?
Counter_Quadratic_percentage <- fit_percentage(AICs$Quadrtic_AIC) #Same as above
model2 <- "Quadratic"
Quadratic_percentage <- c(model2, Counter_Quadratic_percentage)
AIC_percentages <- rbind(AIC_percentages, Quadratic_percentage) #rbind this vector onto the dataframe made before

###How many times did the cubic the fit the datasets?
Counter_Cubic_percentage <- fit_percentage(AICs$Cubic_AIC)
model3 <- "Cubic"
Cubic_percentage <- c(model3, Counter_Cubic_percentage)
AIC_percentages <- rbind(AIC_percentages, Cubic_percentage)

###How many times did the logistic model the fit the datasets?
Counter_Logistic_percentage <- fit_percentage(AICs$Logistic_AIC)
model4 <- "Logistic"
Logistic_percentage <- c(model4, Counter_Logistic_percentage)
AIC_percentages <- rbind(AIC_percentages, Logistic_percentage)

###How many times did Gompertz model the fit the datasets?
Counter_Gompertz_percentage <- fit_percentage(AICs$Gompertz_AIC)
model5 <- "Gompertz"
Gompertz_percentge <- c(model5, Counter_Gompertz_percentage)
AIC_percentages <- rbind(AIC_percentages, Gompertz_percentge)

###How many times did Baranyi model the fit the datasets?
Counter_Baranyi_percentage <- fit_percentage(AICs$Baranyi_AIC)
model6 <- "Baranyi"
Baranyi_percentage <- c(model6, Counter_Baranyi_percentage)
AIC_percentages <- rbind(AIC_percentages, Baranyi_percentage)

AIC_percentages <- transform(AIC_percentages, Fit_percentage = as.numeric(Fit_percentage)) #Making the percentage column numeric for the barplot

###Finding of all the observations, the percentage at which each model fits the best, the lowest AIC
Best_Fit_percentage_overall <- c(0, 0, 0, 0, 0, 0) #Vector to hold all the counts for each time a model has the lowest AIC
for(i in 1:length(AICs$ID)){ #To iterate through all observations
  a <- c(AICs$Regression_AIC[i], AICs$Quadrtic_AIC[i], AICs$Cubic_AIC[i], AICs$Logistic_AIC[i], AICs$Gompertz_AIC[i], AICs$Baranyi_AIC[i]) #a is the vector of the AIC values for the dataset observation
  for(k in 1:length(a)){
    if(is.infinite(a[k]) == TRUE | is.na(a[k]) == TRUE){ #If a value in a, so if an AIC is infinite or NA...
      a[k] <- NaN #Make it a NaN
    }
  }
  best_fit <- c(which(a == min(a, na.rm = TRUE))) #Which is the lowest AIC
  for(j in best_fit){ #Looping through what would be the lowest AIC index. Usually it will only be one number, making the for loop superfulous, but it might be two indexes or more is the lowest AIC values are equal
    if(j == 1){
      Best_Fit_percentage_overall[1] <- Best_Fit_percentage_overall[1] + 1 #If index is 1, add it to the first counter element in the vector. Regession counting.
    }
    else if(j == 2){
      Best_Fit_percentage_overall[2] <- Best_Fit_percentage_overall[2] + 1 #If index is 2, Quadratic
    }
    else if(j == 3){
      Best_Fit_percentage_overall[3] <- Best_Fit_percentage_overall[3] + 1 #If index is 3, Cubic
    }
    else if(j == 4){
      Best_Fit_percentage_overall[4] <- Best_Fit_percentage_overall[4] + 1 #If index is 4, Logistic
    }
    else if(j == 5){
      Best_Fit_percentage_overall[5] <- Best_Fit_percentage_overall[5] + 1 #If index is 5, Gompertz
    }
    else{
      Best_Fit_percentage_overall[6] <- Best_Fit_percentage_overall[6] + 1 #If index is 6, Baranyi
    }
  }
}
Best_Fit_percentage_overall <- round((Best_Fit_percentage_overall / length(AICs$ID) * 100), digits = 1) #Calculate as a percentage of total number of observation datasets

AIC_percentages$Best_Fit_percentage_overall <- Best_Fit_percentage_overall #Appending it into the dataframe of analysis results

###Working out, specifically, of how many times the model coverges, what percentage of that does it fit the best
regression_best_fit_specifically <- subset_best_fit(AICs, AICs$Regression_AIC, 1) #Record the percentage of regression model wins, out of the datasets it fitted
quadratic_best_fit_specifically <- subset_best_fit(AICs, AICs$Quadrtic_AIC, 2) #Record the percentage of quadratic model wins, out of the datasets it fitted
cubic_best_fit_specifically <- subset_best_fit(AICs, AICs$Cubic_AIC, 3) #Record the percentage of cubic model wins, out of the datasets it fitted
logistic_best_fit_specifically <- subset_best_fit(AICs, AICs$Logistic_AIC, 4) #Record the percentage of logistic model wins, out of the datasets it fitted
gompertz_best_fit_specifically <- subset_best_fit(AICs, AICs$Gompertz_AIC, 5) #Record the percentage of gompertz model wins, out of the datasets it fitted
baranyi_best_fit_specifically <- subset_best_fit(AICs, AICs$Baranyi_AIC, 6) #Record the percentage of baranyi model wins, out of the datasets it fitted

Best_Fit_percentage_specifically <- c(regression_best_fit_specifically, quadratic_best_fit_specifically, cubic_best_fit_specifically, logistic_best_fit_specifically, gompertz_best_fit_specifically, baranyi_best_fit_specifically)

AIC_percentages$Best_Fit_percentage_specifically <- Best_Fit_percentage_specifically #Adding the specific percentages onto my dataframe of results

write.csv(AIC_percentages, file = "../Results/AIC_percentages_results.csv")

###Reorganising the AIC_percentages into a format for grouped bar plotting
Model <- c(rep("Regression", 3), rep("Quadratic", 3), rep("Cubic", 3), rep("Logistic", 3), rep("Gompertz", 3), rep("Baranyi", 3)) #Group, categorical
Percentage_type <- rep(c("B.Convergence", "A.Best_Fit_Overall", "C.Best_Fit_Specifically"), 6) #Subgroup, categorical
#Values, numeric
Percentage <- c(AIC_percentages$Fit_percentage[1], AIC_percentages$Best_Fit_percentage_overall[1], AIC_percentages$Best_Fit_percentage_specifically[1], AIC_percentages$Fit_percentage[2], AIC_percentages$Best_Fit_percentage_overall[2], AIC_percentages$Best_Fit_percentage_specifically[2], AIC_percentages$Fit_percentage[3], AIC_percentages$Best_Fit_percentage_overall[3], AIC_percentages$Best_Fit_percentage_specifically[3], AIC_percentages$Fit_percentage[4], AIC_percentages$Best_Fit_percentage_overall[4], AIC_percentages$Best_Fit_percentage_specifically[4], AIC_percentages$Fit_percentage[5], AIC_percentages$Best_Fit_percentage_overall[5], AIC_percentages$Best_Fit_percentage_specifically[5], AIC_percentages$Fit_percentage[6], AIC_percentages$Best_Fit_percentage_overall[6], AIC_percentages$Best_Fit_percentage_specifically[6])
AIC_percentages2 <- data.frame(Model, Percentage_type, Percentage) #Dataframe

write.csv(AIC_percentages2, file = "../Results/AIC_percentages_results_reformatted.csv")
#A. Percentage the model is the best fitting model for all dataset IDs
#B. Percentage the model fits all dataset IDs
#C. Of the dataset IDs the model fits, the percentage at which it fits the datast IDs the best

###Plotting the AIC_percentages2 into a grouped barplot
ggplot(data = AIC_percentages2, aes(fill = Percentage_type, x = Model, y = Percentage)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_bw() +
  labs(title = "Fit percentages of each model across all the dataset IDs", x = "Model", y = "Percentage (%)")
ggsave("../Results/AIC_percentages_results_reformatted.png", device = png())

