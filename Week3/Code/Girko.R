#!usr/bin/env R

rm(list = ls())
graphics.off()

library(ggplot2)

build_ellipse <- function(hradius, vradius){ # Function tha returns an ellipse
  npoints = 250
  a <- seq(0, 2 * pi, length = npoints + 1)
  x <- hradius * cos(a)
  y <- vradius * sin(a)
  return(data.frame(x = x, y = y))
}

N <- 250 # Assign size of the matrix

M <- matrix(rnorm(N * N), N, N) # Build the matrix

eigvals <- eigen(M)$values # Find the eigenvalues

eigDF <- data.frame("Real" = Re(eigvals), "Imaginary" = Im(eigvals)) # Build a dataframe

my_radius <- sqrt(N) # The radius of the circle is sqrt(N)

ellDF <- build_ellipse(my_radius, my_radius) # Dataframe to plot the ellipse

names(ellDF) <- c("Real", "Imaginary") # Rename the columns

##Saving result figure as a file called Girko.pdf in the results directory
pdf("../Results/Girko.pdf")

#Plot the eigenvalues
p <- ggplot(eigDF, aes(x = Real, y = Imaginary))
p <- p + 
  geom_point(shape = I(3)) +
  theme(legend.position = "none")

#Now add the vertical and horizontal lines
p <- p + geom_hline(aes(yintercept = 0))
p <- p + geom_vline(aes(xintercept = 0))

#Finally, add the elipse
p <- p + geom_polygon(data = ellDF, aes(x = Real, y = Imaginary, alpha = 1/20, fill = "red"))
p

graphics.off()



