setwd("/Users/gianluca_astudillo/Documents/GitHub/R-Case-Study") # set my directory

library(tidyverse)
library(lubridate)
library(ggplot2)
library(stringr)
a22_05 = read.csv("Clean_Data/202205-divvy-tripdata.csv")
a22_06 = read.csv("Clean_Data/202206-divvy-tripdata.csv")
a22_07 = read.csv("Clean_Data/202207-divvy-tripdata.csv")
a22_08 = read.csv("Clean_Data/202208-divvy-tripdata.csv")
a22_09 = read.csv("Clean_Data/202209-divvy-tripdata.csv")
a22_10 = read.csv("Clean_Data/202210-divvy-tripdata.csv")
a22_11 = read.csv("Clean_Data/202211-divvy-tripdata.csv")
a22_12 = read.csv("Clean_Data/202212-divvy-tripdata.csv")
a23_01 = read.csv("Clean_Data/202301-divvy-tripdata.csv")
a23_02 = read.csv("Clean_Data/202302-divvy-tripdata.csv")
a23_03 = read.csv("Clean_Data/202303-divvy-tripdata.csv")
a23_04 = read.csv("Clean_Data/202304-divvy-tripdata.csv")

# uploaded all of my data; next lets confirm all files have the same column names
# used relational operator to confirm rows are the same and aligned; a bit redundant but part of data validation!
colnames(a22_05) == colnames(a22_06) 
colnames(a22_06) == colnames(a22_07) 
colnames(a22_07) == colnames(a22_08) 
colnames(a22_08) == colnames(a22_09)
colnames(a22_09) == colnames(a22_10) 
colnames(a22_10) == colnames(a22_11) 
colnames(a22_11) == colnames(a22_12) 
colnames(a22_12) == colnames(a23_01) 
colnames(a23_01) == colnames(a23_02) 
colnames(a23_02) == colnames(a23_03) 
colnames(a23_03) == colnames(a23_04) 

# Next, i combined all of my monthly data into one data frame
# We get a 786,420 x 7 dataframe that contains bike rental data from May 2022 to April 2023
# Everything except the day_of_week column is a character, will need to adjust columns to correct data types for analysis
all_trips <- bind_rows(a22_05, a22_06 ,a22_07 ,a22_08 ,a22_09 ,a22_10 ,a22_11, a22_12, a23_01, a23_02, a23_03, a23_04)
colnames(all_trips)
dim(all_trips)
str(all_trips)

#only two types of user (member or casual); three types of bikes (classic, docked, and electric)
unique(all_trips$member_casual)
unique(all_trips$rideable_type)

#Next, we're going to want to move create individual columns for day, month, year, etc. (need to split date and time column)
all_trips[c('date', 'time')] <- str_split_fixed(all_trips$started_at, ' ', 2) # this separates date and time, now we can separate date
all_trips$date <- as.Date(all_trips$date, "%m/%d/%y") #convert character string to date data type
all_trips$month <- format(as.Date(all_trips$date), "%m")
all_trips$day <- format(as.Date(all_trips$date), "%d")
all_trips$year <- format(as.Date(all_trips$date), "%y")





