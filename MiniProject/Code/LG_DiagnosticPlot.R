#!usr/bin/env R

rm(list =ls())
graphics.off()

library(tidyr)
library(ggplot2)

Data <- read.csv("../Data/LogisticGrowthData.csv", header = TRUE) #Reading in the original data
Data$Temp <- as.factor(Data$Temp) #Making the temperature values factors - categorical instead of continuous

#Constructing the diagnostic plots
z <- Data %>%
  nest(-Species) #using tidyrverse to create loads of dataframes for all the data for each Species

for (k in 1:length(z$data)){ #Setting up the for loop range
  z$data[[k]] %>%  #assigning the i-th nested dataframe to z. Then piping to ggplot
    ggplot(aes(x=Time, y=PopBio, colour = Temp)) + #making the ggplot with Time x-axis and PopBio being y-axis, with a scatter plot for each temperature
    geom_point() + #plotting the ggplot
    facet_wrap(vars(Medium)) #then wrapping by Medium. So as to have all the plots of each medium for each species together
  ggsave(paste("../Results/", z$Species[k], ".png"), device = png())
  dev.off() ##saving the wrapped (multi) ggplot of z in the Results directory, with the species name for the title, as a png file and then closing the plot with dev.off, to begin the loop again for the next species
} 

