
###Practical on genetic drift, mutation and divergence
rm(list = ls())

##Reading in the data
western_banded <- read.csv("../Data/western_banded_gecko.csv", header = F, stringsAsFactors = F, colClasses=rep("character", 20000))
bent_toad <- read.csv("../Data/bent-toed_gecko.csv", header = F, stringsAsFactors = F, colClasses=rep("character", 20000))
leopard <- read.csv("../Data/leopard_gecko.csv", header = F, stringsAsFactors = F, colClasses=rep("character", 20000))

##Identifying the non-snp data
w_banded_nonsnp <- c()
for (i in 1:ncol(western_banded)) {
  if (length(unique(western_banded[,i]))==1) w_banded_nonsnp <- c(w_banded_nonsnp, i)
}

i <- c()

b_toad_nonsnp <- c()
for (i in 1:ncol(bent_toad)) {
  if (length(unique(bent_toad[,i]))==1) b_toad_nonsnp <- c(b_toad_nonsnp, i)
}

i <- c()

##Finding the snp data
w_banded_snp <- c()
for (i in 1:ncol(western_banded)) {
  if (length(unique(western_banded[,i])) > 1) w_banded_snp <- c(w_banded_snp, i)
}

i <- c()

b_toad_snp <- c()
for (i in 1:ncol(bent_toad)) {
  if (length(unique(bent_toad[,i])) > 1) b_toad_snp <- c(b_toad_snp, i)
}

i <- c()

##Attempting to take out the snp columns
for (i in ncol())


##Identifying non-snp data for both bent-toad and wester banded together
wb_bt_nonsnp <- c()
for (i in 1:ncol(western_banded & bent_toad)) {
  if (length(unique(western_banded & bent_toad[,i]))==1) wb_bt_nonsnp <- c(wb_bt_nonsnp, i)
}
