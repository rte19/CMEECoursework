#!/usr/bin/env R

###Creates a world map, then superimposes on the map all the locations 
###from which we have data in the GPDD dataframe

load("../Data/GPDDFiltered.RData")
library(maps)

map(database = "world", regions = ".")
points(gpdd$long, gpdd$lat, pch = 16, col = "green", cex = 1)

#All the data is collected from a few countries around the world,
#that is not representative of the entire world. We also can't, 
#have any indication of density or other details about each data
#point. 