#!usr/bin/env R

rm(list = ls())
graphics.off()

library(dplyr)
library(tidyr)
library(ggplot2)
library(minpack.lm)

Data <- read.csv("../Data/LogisticGrowthData.csv", header = TRUE) #Reading in the original data
Data$Temp <- as.factor(Data$Temp) #Making the temperature values factors - categorical instead of continuous

Data2 <- Data
unique(Data2$PopBio_units)
min(Data2$PopBio)
