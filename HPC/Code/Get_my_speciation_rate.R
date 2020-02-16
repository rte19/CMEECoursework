# written by james rosindell james@rosindell.org Imperial college london released open source under an MIT license

# Assign random speciation rates to class
CMEE_2019 <- c(
  "vlb19",
  "jb1919",
  "ead19",
  "rte19",
  "hg816",
  "leg19",
  "ph419",
  "lh1019",
  "ojs19",
  "abs119",
  "ys219",
  "hw2419",
  "yy5819",
  "xz4419",
  "wz2812",
  "yz2919",
  "ha819",
  "db319",
  "mlc19",
  "rbk119",
  "pl1619",
  "xl15918",
  "sl6719",
  "imm19",
  "ams119",
  "sat19",
  "yz12119"
  )

choose_student <- function(class) {
    print(sample(class,1))
}

choose_student_2 <- function(class,seedin = 1) {
    set.seed(seedin)
    print(sample(class,1))
}

choose_student_3 <- function(class,seedin=-1) {
    if (seedin <= 0){
        set.seed(floor(proc.time()[3]*1000))
    }
    else {
        set.seed(seedin)
    }
    print(sample(class,1))
}

assign_student_number <- function(class=CMEE_2019,seedin=2019,min=0.002,max=0.007,sigfig=4,unique=TRUE) {
    if (seedin <= 0){
        set.seed(floor(proc.time()[3]*1000))
    }
    else {
        set.seed(seedin)
    }
    speciation_values <- signif(runif(length(class))*(max-min)+min,sigfig)
    if (unique){
        while(length(unique(speciation_values)) < length(class)){
            speciation_values <- signif(runif(length(class))*(max-min)+min,sigfig)
        }
    }
    return(cbind(speciation_values,class))
}

print(assign_student_number())