#!usr/bin/env R

# This function calculates heighs of trees given distance of each tree
# from its base and angle to its top, using the trigonometric formula
#
# height = distance * tan(radians)
#
# ARGUMENTS
# degrees:  The angle of levation of tree
# distance: The distance from base of tree (e.g., meters)
#
# OUTPUT
# The height of the tree, same units as "distance"


Trees <- read.csv("../Data/trees.csv")

TreesDegrees <- Trees$Angle.degrees
TreesHeight <- Trees$Distance.m


TreeHeight <- function(degrees, distance){
  radians <- degrees * pi / 180
  height <- distance * tan(radians)

}

a <- TreeHeight(TreesDegrees, TreesHeight)

b <- cbind(Trees, a)
colnames(b)[4] <- "Tree.Height.m"
write.csv(b, "../Data/TreeHts.csv", row.names=FALSE)