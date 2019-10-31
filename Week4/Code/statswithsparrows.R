## To be interpretted in the directory of statistics_in_R

d <- read.table("SparrowSize.txt", header=TRUE) #Reading this data file

par(mfrow = c(3, 2)) #Tells rstudio how many plots to put in a
#page in the 'Plots' window. In the case a table of them in the 
#format 3 by 2 

hist(d$Tarsus, breaks = 3, col="grey") #Just making some histograms
hist(d$Tarsus, breaks = 10, col="grey")
hist(d$Tarsus, breaks = 30, col="grey")
hist(d$Tarsus, breaks = 100, col="grey")
hist(d$Tarsus, breaks = 100, col="grey")

mean(d$Tarsus, na.rm = TRUE) #The defualt is that NA values are
#kept, na.rm=FALSE, so here we are removing them

median(d$Tarsus, na.rm = TRUE)

range(d$Bill, na.rm=TRUE)

var(d$Mass, na.rm=TRUE) #Variance

sqrt(var(d$Wing, na.rm=TRUE)) #Standard deviation, by square rootig the variance
sd(d$Wing, na.rm=TRUE) #Working out standard deviation directly

# round(varibale, digit = x)    How to round stuff

rm(list=ls()) ##Removes the workspace, clears it totally

#Working standard error out for Tarsus lengths
d <- read.table("SparrowSize.txt", header=TRUE)
d1 <- subset(d, d$Tarsus != "NA")
seTarsus <- sqrt(var(d1$Tarsus)/length(d1$Tarsus))
seTarsus

d12001 <- subset(d1, d1$Year==2001)
seTarsus2001 <- sqrt(var(d12001$Tarsus)/length(d12001$Tarsus))
seTarsus2001

#SE for body mass
d2 <- subset(d, d$Mass != "NA")
seMass <- sqrt(var(d2$Mass)/length(d2$Mass))
seMass

#SE of wing length
d3 <- subset(d, d$Wing != "NA")
seWing <- sqrt(var(d3$Wing)/length(d3$Wing))
seWing


##Doing t tests!!!!
t.test1 <- t.test(d$Mass~d$Sex.1, na.rm=TRUE)
t.test1

#Doing a boxlot with these data
boxplot(d$Mass~d$Sex.1, col = c("red", "blue"), ylab = "Body Mass (g)")

##Doing a power analysis
pwr.t.test(d=(0-5)/0.96, power=0.8, sig.level=0.05)

##Doing a linear regression model analysis
x <- c(1, 2, 3, 4, 8)
y <- c(4, 3, 5, 7, 9)

model1 <- lm(y~x) #making the linear regression
model1 #Gives the y-intercept and slope of the line
summary(model1) #Gives residuals of value. Gives lots of coefficients...
anova(model1) #Perfomrs an ANOVA
resid(model1) #Gives residuals for all corodinates
cov(x,y) #Gives covariance
var(x,y) #Givs variance
plot(y~x) # plot y on x
abline(model1) # plots the linear regression , model1,  on the graph
