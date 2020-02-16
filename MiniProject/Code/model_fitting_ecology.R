#!/usr/bn/env R

rm(list = ls())
graphics.off()

library("ggplot2")
library("minpack.lm")

powdMod <- function(x, a, b) {
  return((a * x^b))
}

MyData <- read.csv("../Data/GenomeSize.csv")
head(MyData)

Data2Fit <- subset(MyData, Suborder == "Anisoptera")
Data2Fit <- Data2Fit[!is.na(Data2Fit$TotalLength),] #remove NA's

#Plotting
plot(Data2Fit$TotalLength, Data2Fit$BodyWeight)

#Plotting with ggplot
ggplot(Data2Fit, aes(x = TotalLength, y = BodyWeight)) +
  geom_point(size = (3), color = "red") + 
  theme_bw() +
  labs(y = "Body mass (mg)", x = "Wing length (mm)")

#Make NLLS fit of x=powMod(TatolLength), y = BodyWeight
PowFit <- nlsLM(BodyWeight ~ powdMod(TotalLength, a, b), data = Data2Fit, start = list(a = 0.1, b = 0.1))

summary(PowFit)

#Generate a vector of lengths for the graph
Lengths <- seq(min(Data2Fit$TotalLength), max(Data2Fit$TotalLength), len = 60)

#Calculate the predicted line, for this we need the coefficient from the model fit
coef(PowFit)["a"]
coef(PowFit)["b"]
Predic2PlotPow <- powdMod(Lengths, coef(PowFit)["a"], coef(PowFit)["b"])

#Plot the data and the fitted model
plot(Data2Fit$TotalLength, Data2Fit$BodyWeight)
lines(Lengths, Predic2PlotPow, col = 'blue', lwd = 2.5)

#Calculate confidence intervals
confint(PowFit)

#Plotting the same graph as above for ggplot
ggplot(Data2Fit, aes(x = TotalLength, y = BodyWeight)) +
  geom_point(size = (2), fill = (1)) +
  xlab("Total Length (mm)") + ylab("Body Weight (mg)") + 
  geom_smooth(aes(x = Lengths, y = Predic2PlotPow))

##Same as above but we're using the Zygoptera subset instead
Data3Fit <- subset(MyData, Suborder == "Zygoptera")

#NLLS fit
PowFit2 <- nlsLM(BodyWeight ~ powdMod(TotalLength, a, b), data = Data3Fit, start = list(a = 0.1, b = 0.1))
#Lengths
Lengths2 <- seq(min(Data3Fit$TotalLength), max(Data3Fit$TotalLength), len = 38)
#Predicted line
Predic3PlotPow <- powdMod(Lengths2, coef(PowFit2)["a"], coef(PowFit2)["b"])
#Plotting it
ggplot(Data3Fit, aes(x = TotalLength, y = BodyWeight)) +
  geom_point(size = (2)) +
  xlab("Total Length (mm)") + ylab("Body Weight (mg)") +
  geom_smooth(aes(x = Lengths2, y = Predic3PlotPow))

##Fitting a log transformed linear model of the Data2Fit
LogLMFit <- lm(log(BodyWeight) ~ log(TotalLength), data = Data2Fit)
#summary(LogLMFit)
LengthsLog <- seq(min(log(Data2Fit$TotalLength)), max(log(Data2Fit$TotalLength)), len = 60)
PredicLogLMFit <- predict(LogLMFit)
log_fitted_line <- data.frame(log(Data2Fit$TotalLength), PredicLogLMFit)
names(log_fitted_line) <- c("Length", "Prediction")

ggplot(Data2Fit, aes(x = log(TotalLength), y = log(BodyWeight))) +
  geom_point() +
  xlab("Log(Total Length (mm))") + ylab("Log(Body Weight (mg))") +
  geom_line(data = log_fitted_line, aes(x = Length, y = Prediction))
  