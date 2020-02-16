#!/usr/bin/env R

rm(list = ls())
graphics.off()
#10/02/20
x <- 0:10
y <- dbinom(x, size = 10, prob = 0.4)
plot(x, y, pch=16, ylab = "pmf", xlab="outcome")
sum(y)

x <- rbinom(1000, size = 10, prob = 0.4)
x
hist(x)
mean(x)
var(x)


x <- 0:10
?dpois()
y <- dpois(x, lambda = 2)
y
plot(x, y)

rm(list = ls())
graphics.off()
###11/02/20 Maximum Likelihood Estimation (MLE)
#Write down the likelihood function
binomial.likelihood <- function(p){
  choose(10, 7)*p^7*(1-p)^3
}
#Let us calculate the likelihood value at p=0.1
binomial.likelihood(p=0.1)

#Plot the likelihood function for a range of p
p <- seq(0, 1, 0.1)
likelihood.values <- binomial.likelihood(p)
plot(p, likelihood.values, type = "l")

#More often we use the log-likelihood
#We can reuse the function we've just written
log.binomial.likelihood <- function(p){
  log(binomial.likelihood(p=p))
}
#Plot the log-likelihood
p <- seq(0, 1, 0.1)
log.likelihood.values <- log.binomial.likelihood(p)
plot(p, log.likelihood.values, type = "l")

#Maximise the function numerically via the computer
optimise(binomial.likelihood, interval = c(0, 1), maximum = TRUE)

#Question 6 from practical 2
#Read in the data
recapture.data <- read.csv("../data/recapture.csv", header = TRUE)
#Scatterplot
plot(recapture.data$day, recapture.data$length_diff)
#Log-likelihood for the linear regression
#Parameters have to be input as a vector
regression.log.likelihood <- function(parm, dat){
  #Define the parameters: parm
  #We have three parameters: a, b, sigma. Be careful of the order
  a <- parm[1]
  b <- parm[2]
  sigma <- parm[3]
  
  #Define the data: dat
  #First column is x, second column is y
  x <- dat[,1]
  y <- dat[,2]
  
  #Define the error term
  error.term <- (y-a-b*x)
  
  #Remember the normal pdf
  density <- dnorm(error.term, mean = 0, sd = sigma, log = T)
  
  #The log-likelihood is the sum of individual log-density
  return(sum(density))
}

regression.log.likelihood(c(1,1,1), dat = recapture.data)

#To optimise the log-likelihood function in R
#optimise() is one-dimensional
#optim() generalises to multi-dimensional cases
optim(par = c(1,1,1), regression.log.likelihood, method = "L-BFGS-B", 
      lower = c(-1000, -1000, 0.0001), upper = c(1000, 1000, 10000),
      control = list(fnscale = -1), dat = recapture.data, hessian = T)
#Output:
# $par gives us the the optimised parameter values in respective order
# $value gives us the maximised log-likelihood values
# $message will tell us any error messages. Check it is ok


#12/02/20

#The log-likelihood function for the M1 without an intercept
#M2 is above
regression.no.intercept.log.likelihood <- function(parm, dat){
  #Define parameters
  #No intercept this time
  b <- parm[1]
  sigma <- parm[2]
  
  #Define the data
  x <- dat[,1]
  y <- dat[,2]
  
  #Define the error term, no intercept here
  error.term <- (y - b*x)
  
  #Normal pdf
  density <- dnorm(error.term, mean = 0, sd = sigma, log = T)
  
  #Log-likelihood is the sum of densities
  return(sum(density))
}

#Performing the likelihood-ratio test
M1 <- optim(par = c(1,1), regression.no.intercept.log.likelihood,
            dat = recapture.data, method = "L-BFGS-B",
            lower = c(-1000, 0.0001), upper = c(1000, 10000),
            control = list(fnscale = -1), hessian = T)

M2 <- optim(par = c(1, 1,1), regression.log.likelihood,
            dat = recapture.data, method = "L-BFGS-B",
            lower = c(-1000, -1000, 0.0001), upper = c(1000, 1000, 10000),
            control = list(fnscale = -1), hessian = T)
#The test statistic D
D <- 2 * (M2$value - M1$value)
D
#Critical value
qchisq(0.95, df=1)

#Question 4 Practical 3
flowering <- read.table("../data/flowering.txt", header = T)
names(flowering)

par(mfrow=c(1,2))
plot(flowering$Flowers, flowering$State)
plot(flowering$Root, flowering$State)

# pi = expit(a + b*Flowersi + c*Rooti)
logistic.log.likelihood <- function(parm, dat){
  #Parameters
  a <- parm[1]
  b <- parm[2]
  c <- parm[3]
  #Response variable
  State <- dat[,1]
  #Explanatory variables
  Flowers <- dat[,2]
  Root <- dat[,3]
  #Model our success probability
  p <- exp(a + b*Flowers + c*Root) / (1 + exp(a + b*Flowers + c*Root))
  #The log-likelihood function
  log.like <- sum(State*log(p) + (1-State) * log(1-p))
  
  return(log.like)
}
#Try
logistic.log.likelihood(c(0,0,0), dat = flowering)

M1 <- optim(c(0,0,0), logistic.log.likelihood, dat=flowering, control = list(fnscale=-1))
M1

#Now, doing it with a fourth parameter, the interaction between flowers and roots
logistic.log.likelihood.int <- function(parm, dat){
  #Parameters
  a <- parm[1]
  b <- parm[2]
  c <- parm[3]
  d <- parm[4]
  #Repsonse
  State <- dat[,1]
  #Explanatory
  Flowers <- dat[,2]
  Root <- dat[,3]
  #Model our success probability
  p <- exp(a + b*Flowers + c*Root + d*Flowers*Root) / (1 + exp(a + b*Flowers + c*Root + d*Flowers*Root))
  #The log-likelihood function
  log.like <- sum(State*log(p) + (1-State) * log(1-p))
  return(log.like)
}
#Maximise
M2 <- optim(c(0,0,0,0), logistic.log.likelihood.int, dat=flowering, control = list(fnscale=-1))

#Maximum likelihood test ratio
D <- 2 * (M2$value - M1$value)
D
#Critical value
qchisq(0.95, df=1)


#13/02/20 MLE5.pdf
#Define the rang of parameter to be plotted
b <- seq(2, 4, 0.1)
sigma <- seq(2, 5, 0.1)
#Log-likelihood value is stored in a matrix
log.likelihood.value <- matrix(nr=length(b), nc=length(sigma))
#Compute the log-likelihood value for each pair of parameters
for(i in 1:length(b)){
  for(j in 1:length(sigma)){
    log.likelihood.value[i,j] <- regression.no.intercept.log.likelihood(parm = c(b[i], sigma[j]), dat = recapture.data)
  }
}
#We are interested in knowing the relative log-likelihood value
#Relative to the peak (maximum)
rel.log.likelihood.value <- log.likelihood.value - M1$value

#Function for the 3D plot
persp(b, sigma, rel.log.likelihood.value, theta = 30, phi = 20, 
      xlab = "b", ylab = "sigma", zlab = "rel.log.likelihood.value",
      col = "grey")

#Contour plot
contour(b, sigma, rel.log.likelihood.value, xlab="b", ylab="sigma", 
        xlim = c(2.5, 3.9), ylim = c(2.0, 4.3), levels = c(-1:-5, -10), cex = 2) #Should have contour lines... oh well
#Draw a cross to indicate the maximum
points(M1$par[1], M1$par[2], pch = 3)
contour.line <- contourLines(b, sigma, rel.log.likelihood.value, levels = -1.92)[[1]]
lines(contour.line$x, contour.line$y, col = "red", lty = 2, lwd = 2)



#Question 3 practical 4
#13/02/20
#Profile log-likelihood for b
profile.log.likelihod <- function(b){
  f <- function(parm_acd){
    logistic.log.likelihood.int(c(parm_acd[1], b, parm_acd[2], parm_acd[3], dat=flowering))
  }
  temp <- optim(c(0, 0, 0), f, control = list(fnscale=-1))
  return(temp$value)
}
#Profile log_likelihood value at b=0.03
profile.log.likelihod(b=-0.03)
