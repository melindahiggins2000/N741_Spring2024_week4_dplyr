# Restructuring - R Script ============================
# RESTRUCTURE from long to wide =================
library(dplyr)
library(readr)

# READ IN LONG Dataset =========================
long1 <- read_csv("long1.csv")
long1

# Each person has 3 time points
# time nested within id
# importing required libraries 

library(data.table)
long1.dt <- data.table(long1)
aggregate(cbind(bmi, satis) ~ time, 
          data = long1.dt, 
          FUN = sum)


