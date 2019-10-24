MyDF <- read.csv("../Data/EcolArchives-E089-51-D1.csv")
#dim(MyDF)
#head(MyDF)

library(lattice)

pdf("../Results/Pred_Lattice.pdf")
densityplot(~log(Predator.mass) | Type.of.feeding.interaction, data=MyDF)
dev.off()

pdf("../Results/Prey_Lattice.pdf")
densityplot(~log(Prey.mass) | Type.of.feeding.interaction, data=MyDF)
dev.off()

pdf("../Results/SizeRatio_Lattice.pdf")
densityplot(~log(Prey.mass/Predator.mass) | Type.of.feeding.interaction, data=MyDF)
dev.off()

MeanPredatorMass <- log(tapply(X = MyDF$Predator.mass, INDEX = MyDF$Type.of.feeding.interaction, FUN = mean))
MedianPredatorMass <- log(tapply(X = MyDF$Predator.mass, INDEX = MyDF$Type.of.feeding.interaction, FUN = median))

MeanPreyMass <- log(tapply(X = MyDF$Prey.mass, INDEX = MyDF$Type.of.feeding.interaction, FUN = mean))
MedianPreyMass <- log(tapply(X = MyDF$Prey.mass, INDEX = MyDF$Type.of.feeding.interaction, FUN = median))

MeanSizeRatio <- log(tapply(X = MyDF$Prey.mass/MyDF$Predator.mass, INDEX = MyDF$Type.of.feeding.interaction, FUN = mean))
MedianSizeRatio <- log(tapply(X = MyDF$Prey.mass/MyDF$Predator.mass, INDEX = MyDF$Type.of.feeding.interaction, FUN = median))





