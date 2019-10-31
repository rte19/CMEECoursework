#!usr/bin/env R

## A lnear model hypothesising weather sparoows with bigger bills
## eat more..

Data <- read.table("SparrowSize.txt", header=TRUE) #Reding in the data

require(dplyr)
dplyr::slice(Data, 0:10) #Looking at the data

require(tidyr)
Data2 <- drop_na(Data) # Taking out all NA values and making a 
#new table out of it

dplyr::slice(Data2, 0:10) #Having a look at new table

model1 <- lm(Data2$Mass~Data2$Bill) #Performaing linear regression
plot(Data2$Bill, Data2$Mass) #Plotting thr data
abline(model1) #Plotting the line of best fit

summary(model1) #Getting the summary data for coefficients and p values

