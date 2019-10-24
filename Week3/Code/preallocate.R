#!usr/bin/env R

a <- NA
print(system.time(
  for (i in 1:1000) {
    a <- c(a, i)
    print(a)
    print(object.size(a))
  }
))


a <- rep(NA, 1000)
print(system.time(
  for (i in 1:1000) {
    a[i] <- i
    print(a)
    print(object.size(a))
  }
))
