#!usr/bin/env R

rm(list=ls())

bears <- read.csv("../Data/bears.csv", header = FALSE, stringsAsFactors = F)
dim(bears)
