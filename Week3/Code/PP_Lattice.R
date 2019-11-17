#!usr/bin/env R

rm(list = ls())
graphics.off()

MyDF <- read.csv("../Data/EcolArchives-E089-51-D1.csv") #Reading in the data
#dim(MyDF)
#head(MyDF)

library(lattice) #loading up lattice

pdf("../Results/Pred_Lattice.pdf") #Saving a blank pdf in Results
densityplot(~log(Predator.mass) | Type.of.feeding.interaction, data=MyDF) 
#Plotting the densityplot for the log of Predator masss by categorised by the type of feeding interaction from the data
dev.off() #Terminating the plotting here

pdf("../Results/Prey_Lattice.pdf")
densityplot(~log(Prey.mass) | Type.of.feeding.interaction, data=MyDF)
#Plotting the densityplot for the log of Prey masss by categorised by the type of feeding interaction from the data
dev.off() #Terminating the plotting here

pdf("../Results/SizeRatio_Lattice.pdf")
#Plotting the densityplot for the log of Prey/Predator masss by categorised by the type of feeding interaction from the data
densityplot(~log(Prey.mass/Predator.mass) | Type.of.feeding.interaction, data=MyDF)
dev.off() #Terminating the plotting here

MeanPredatorMass <- log(tapply(X = MyDF$Predator.mass, INDEX = MyDF$Type.of.feeding.interaction, FUN = mean))
#taking the log of the Predator mass data, indexed by the type of feeding interaction, and applying the mean to it
MedianPredatorMass <- log(tapply(X = MyDF$Predator.mass, INDEX = MyDF$Type.of.feeding.interaction, FUN = median))
#taking the log of the Predator mass data, indexed by the type of feeding interaction, and applying the median to it

MeanPreyMass <- log(tapply(X = MyDF$Prey.mass, INDEX = MyDF$Type.of.feeding.interaction, FUN = mean))
#taking the log of the Prey mass data, indexed by the type of feeding interaction, and applying the mean to it
MedianPreyMass <- log(tapply(X = MyDF$Prey.mass, INDEX = MyDF$Type.of.feeding.interaction, FUN = median))
#taking the log of the Prey mass data, indexed by the type of feeding interaction, and applying the median to it

MeanSizeRatio <- log(tapply(X = MyDF$Prey.mass/MyDF$Predator.mass, INDEX = MyDF$Type.of.feeding.interaction, FUN = mean))
#taking the log of the Prey/Predator mass data, indexed by the type of feeding interaction, and applying the mean to it
MedianSizeRatio <- log(tapply(X = MyDF$Prey.mass/MyDF$Predator.mass, INDEX = MyDF$Type.of.feeding.interaction, FUN = median))
#taking the log of the Predator data, indexed by the type of feeding interaction, and applying the mean to it

Frame <- data.frame(MeanPredatorMass, MedianPredatorMass, MeanPreyMass, MedianPreyMass, MeanSizeRatio, MedianSizeRatio)
#Creating a dataframe for all these means and medians
write.csv(Frame, "../Results/PP_Results.csv")
#Writing the dataframe into a csv file into the results directory



