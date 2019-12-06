#!usr/bin/env R

###In this example, we will use the ggplot geom text to annotate a plot

rm(list = ls())
graphics.off()

library(ggplot2)

a <- read.table("../Data/Results.txt", header = TRUE) #Read in the data
head(a) #Check to see it

a$ymin <- rep(0, dim(a)[1]) #Append a column of zeros

##Saving result figure as a file called MyBars.pdf in the results directory
pdf("../Results/MyBars.pdf")

#Print the first linerange
p <- ggplot(a)
p <- p + geom_linerange(data = a, aes(
  x = x,
  ymin = ymin,
  ymax = y1,
  size = (0.5)
  ),
  colour = "#E69F00",
  alpha = 1/2, show.legend = FALSE)

#Print the second linerange
p <- p + geom_linerange(data = a, aes(
  x =x,
  ymin = ymin,
  ymax = y2,
  size = (0.5)
  ),
  colour = "#56B4E9",
  alpha = 1/2, show.legend = FALSE)

#Print the third linerange
p <- p + geom_linerange(data = a, aes(
  x = x,
  ymin = ymin,
  ymax = y3,
  size = (0.5)
  ),
  colour = "#D55E00",
  alpha = 1/2, show.legend = FALSE)

#Annotate he plot with labels
p <- p + geom_text(data = a, aes(x = x, y = -500, label = Label))

#Now set the axis labels, remove the legend, and prepare for bw printing
p <- p + scale_x_continuous("My x axis",
                        breaks = seq(3, 5, by = 0.05)) +
  scale_y_continuous("My y axis") +
  theme_bw() +
  theme(legend.position = "none")

p #You need ths to actually create the gaph into the proposed saved pdf

graphics.off() #You need to also do this to actually get the graph data into the pdf
