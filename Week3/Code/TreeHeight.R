#!usr/bin/env R

# This function calculates heights of trees given distance of each tree
# from its base and angle to its top, using the trigonometric formula
#
# height = distance * tan(radians)
#
# ARGUMENTS
# degrees:  The angle of elevation of tree
# distance: The distance from base of tree (e.g., meters)
#
# OUTPUT
# The height of the tree, same units as "distance"

rm(list = ls())
graphics.off()

Trees <- read.csv("../Data/trees.csv")

TreesDegrees <- Trees$Angle.degrees
TreesHeight <- Trees$Distance.m


TreeHeight <- function(degrees, distance){ #Function that works out the height of that tree, based on distance and degrees
  radians <- degrees * pi / 180
  height <- distance * tan(radians)

}

Height <- TreeHeight(TreesDegrees, TreesHeight) #Making a vector of all the tree heights

TreeHts <- cbind(Trees, Height) #Inserting the height vector onto the original data so we can see how tall each tree is
colnames(TreeHts)[4] <- "Tree.Height.m"
write.csv(TreeHts, "../Data/TreeHts.csv", row.names=FALSE)
