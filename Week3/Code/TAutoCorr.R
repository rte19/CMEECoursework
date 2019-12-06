#!usr/bin/env R

rm(list = ls())
graphics.off()

###Autocorrelation in weather: Are temperatures of one year 
###significantly correlated with the next year (successive years), 
###across years in a given location?

MyData <- load("../Data/KeyWestAnnualMeanTemperature.RData") #loading the data
Data <- ats #Assigning the data to Data

plot(Data)

first99 <- Data[1:99, 2] #First 99 of temperatures
last99 <- Data[2:100, 2] #Last 99 of the temperatures
Years <- Data[2:100, 1] #Last 99 of the years

Data2 <- as.data.frame(Years) #Assigning years to a new dataframe
Data2$Temps <- as.data.frame(last99) #Assigning the last 99 to the years
Data2$Temps.less1 <- as.data.frame(first99) #Assigning the first 99 to these data too
#This allows us to hae the same data alligned to itself n - 1

#print(Data2)

DataCor <- cor(Data2$Temps, Data2$Temps.less1) #Calculating the correlation coefficient between the two temp data columns
#print(DataCor)

cor_shuffle <- function(){ #Function that randomly shuffles the temperatures
  DataShuffle <- Data[sample(nrow(Data), replace=FALSE),]
  
  first_99 <- DataShuffle[1:99, 2]
  last_99 <- DataShuffle[2:100, 2]
  
  return(cor(first_99,last_99))
}
RandomCors <- c() #Making empty variable to hold 10000 random autocorrelations
for(i in 1:10000){ #Loop to call the cor_shuffle function and keep appending it into RandomCors

  RandomCors <- c(RandomCors, cor_shuffle())
}
#print(RandomCors)

BigCors <- c() #Making empty variable to contain all correlation coefficients greater than the first one, DataCor
for( cor in RandomCors){ #Appending in all the big cors
  if( cor > DataCor){
    BigCors <- c(BigCors, cor)
  }
}
#print(BigCors)

#print(length(RandomCors))
#print(length(BigCors))
p_value <- length(BigCors)/length(RandomCors) #Working out the p-value

print(paste("p_value:",p_value))
