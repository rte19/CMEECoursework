#!/usr/bin/env R

rm(list = ls())
graphics.off()

library(ggplot2)

###Let's try mathematical annotation on a axis, and in the plot area
###First create some linear regression "data"

x <- seq(0, 100, by = 0.1)
y <- -4. + 0.25 * x +
  rnorm(length(x), mean = 0., sd = 2.5)

# and put them in a dataframe
my_data <- data.frame(x = x, y = y)

# perform a linear regression
my_lm <- summary(lm(y ~ x, data = my_data))

# Saving the following plot as MyLinReg.pdf
pdf("../Results/MyLinReg.pdf")

# plot the data
p <- ggplot(my_data, aes(x = x, y = y, colour = abs(my_lm$residual))) +
  geom_point() +
  scale_colour_gradient(low = "black", high = "red") +
  theme(legend.position = "none") +
  scale_x_continuous(expression(alpha^2 * pi / beta * sqrt(Theta)))

# add the regression line
p <- p + geom_abline(
  intercept = my_lm$coefficients[1][1],
  slope = my_lm$coefficients[2][1],
  colour = "red")

# throw some maths on the plot
p <- p + geom_text(aes(x = 60, y = 0,
                       label = "sqrt(alpha) * 2 * pi"),
                   parse = TRUE, size = 6,
                   colour = "blue")
p

graphics.off()
