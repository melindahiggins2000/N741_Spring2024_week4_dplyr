# Load packages =================================
library(dplyr)
library(readr)

# READ IN LONG Dataset ==========================
# Each person has from 1 - 3 time points
# time nested within id
# importing required libraries
long1 <- read_csv("long1.csv")
long1

# see who is missing which time point
with(long1, table(id, time))

# time points per id
with(long1, table(id))

# subjects per time point
with(long1, table(time))

# BASE R aggregate() function ===================
# get mean bmi's and mean statisfaction scores
# within each time point
aggregate(cbind(bmi, satis) ~ time, 
          data = long1, 
          FUN = mean)

# More Powerful data.table package ==============
# https://rdatatable.gitlab.io/data.table/
# load package
library(data.table)

# convert long1 from data.frame to data.table class
long1.dt <- data.table(long1)
class(long1)
class(long1.dt)

# dt[any filters,
#    functions to apply,
#    by which variables (aggregate within)]

# for id's 1-5
# get sample size and mean bmi and mean satis
# within each time point
ans <- long1.dt[id < 6,
               .(.N, mean(bmi), mean(satis)),
               by = .(time)]
ans

# example use for making an
# error bar plot
bmi_by_time <-
  long1.dt[,                  # no row filter used
           .(mean(bmi),       # list functions
             sd(bmi)),
           by = .(time)]      # aggregate by
bmi_by_time

# clean up variable names
names(bmi_by_time)
names(bmi_by_time) <- c("time", "bmi", "sd")
names(bmi_by_time)

library(ggplot2)

# make error bar plot
# see http://www.cookbook-r.com/Graphs/Plotting_means_and_error_bars_(ggplot2)/
# mean bmi +/- sd at each time point
# options added to plot
# set y-axis limits
# remove 0.5 time point labels and tick marks - see http://www.sthda.com/english/wiki/ggplot2-axis-ticks-a-guide-to-customize-tick-marks-and-labels
# try different themes
# add nicer labels, titles and a caption

ggplot(bmi_by_time, 
       aes(x=time, y=bmi)) + 
  geom_errorbar(aes(ymin=bmi-sd, ymax=bmi+sd), width=.1) +
  geom_line() +
  geom_point() +
  ylim(20, 40) +
  scale_x_discrete(limits=c("1","2","3")) +
  #theme_classic() +
  #theme_linedraw() +
  theme_light() +
  labs(
    x = "Time Points",
    y = "Body Mass Index",
    title = "BMI (mean +/- sd) Over Time",
    subtitle = "Time 1 (n=10), Time 2 (n=6), Time 3 (n=6)",
    caption = "Note: Summary Statistics Computed Using data.table R Package"
  )

# Note You can "knit" the R script to markdown and HTML
# knitr::spin("aggregate.R", format = "Rmd")
# this creates
#      aggregate.md
#      aggregate.html
  
  
  
  