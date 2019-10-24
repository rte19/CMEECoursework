#!usr/bin/env R

MyData <- load("../Data/KeyWestAnnualMeanTemperature.RData")
Data <- ats

plot(Data)

first99 <- Data[1:99, 2]
last99 <- Data[2:100, 2]
Years <- Data[2:100, 1]

Data2 <- as.data.frame(Years)
Data2$Temps <- as.data.frame(last99)
Data2$Temps.less1 <- as.data.frame(first99)

#print(Data2)

cor.coefficient <- cor(Data2$Temps, Data2$Temps.less1)
DataCor <- cor.coefficient
#print(DataCor)

cor_shuffle <- function(){
  DataShuffle <- Data[sample(nrow(Data), replace=FALSE),]
  
  first_99 <- DataShuffle[1:99, 2]
  last_99 <- DataShuffle[2:100, 2]
  
  return(cor(first_99,last_99))
}
RandomCors <- 0
for(i in 1:10000){

  RandomCors <- c(RandomCors, cor_shuffle())
}
RandomCors <- RandomCors[-1]
#print(RandomCors)

BigCors <- 0
for( cor in RandomCors){
  if( cor > DataCor){
    BigCors <- c(BigCors, cor)
  }
}
BigCors <- BigCors[-1]
print(BigCors)

print(length(RandomCors))
print(length(BigCors))
p_value <- length(BigCors)/length(RandomCors)

paste("p_value:",p_value)
