rm(list = ls())

#Reading in the data
d <- read.table("../../Week4/Data/SparrowSize.txt", header = TRUE)

#Getting just the wing subset without NA values
d1 <- subset(d, d$Wing != "NA")
#Getting some descriptives
summary(d1$Wing)

#Plotting histogram
hist(d1$Wing)

#linear model
model1 <- lm(Wing~Sex.1, data = d1)
summary(model1)

#boxplots
boxplot(d1$Wing~d1$Sex.1, ylab="Wing length (mm)")

#ANAOVA
anova(model1)

#t test
t.test(d1$Wing~d1$Sex.1, var.equal=TRUE)

#Now we want o know if wing length changes over time, as we have multiple
#measurements for each Bird. So going to test this again but with BirdID
#as the explanator factor

boxplot(d1$Wing~d1$BirdID, ylab="Wing length (mm)")

#Want to know how many individual birds there are
require(dplyr)
tibble::as.tibble(d1)
glimpse(d1)

d$Mass %>% cor.test(d$Tarsus, na.rm=TRUE)

d1 %>%
  group_by(BirdID) %>%
  summarise(count=length(BirdID)) #This shows us how many times each BirdID shows up
