setwd("/Users/gianluca_astudillo/Documents/GitHub/R-Case-Study") # set my directory

library(tidyverse)
library(lubridate)
library(ggplot2)
library(stringr)
library(chron)
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
all_trips_v2 <- all_trips[!(all_trips$ride_length <= 0),]
which(is.na(all_trips_v2$ride_length)) # check there are no NAs
all_trips_v2$ride_length2 <- chron(times=all_trips_v2$ride_length) # this converts our ride_length data from character to time (numeric) so we can perform our calculations
which(is.na(all_trips_v2)) #check there are no NAs after converting data type
which(all_trips_v2$ride_length2 <= 0) # check if there are values less than or equal to 0; there are so we have to remove them

all_trips_v3 <- subset(all_trips_v2, all_trips_v2$ride_length2 > 0 )
which(all_trips_v3$ride_length2 <= 0) # check if there are values less than or equal to 0

colnames(all_trips_v3)
dim(all_trips_v3) # dimension of data set: 786356 x 8
str(all_trips_v3) # checks structure of the compiled data set


# only two types of user (member or casual); three types of bikes (classic, docked, and electric)
unique(all_trips_v3$member_casual)
unique(all_trips_v3$rideable_type)

#Next, we're going to want to move create individual columns for day, month, year, etc. (need to split date and time column)
all_trips_v3[c('date', 'time')] <- str_split_fixed(all_trips_v3$started_at, ' ', 2) # this separates date and time, now we can separate date
all_trips_v3$date <- as.Date(all_trips_v3$date, "%m/%d/%y") #convert character string to date data type
all_trips_v3$month <- format(as.Date(all_trips_v3$date), "%m")
all_trips_v3$day <- format(as.Date(all_trips_v3$date), "%d")
all_trips_v3$year <- format(as.Date(all_trips_v3$date), "%y")
str(all_trips_v3)

# Now that our data is all clean and processed, we can start analyzing
summary(all_trips_v3$ride_length2) # avg ride time: 00:14:24, median 09:00, max- 23:58:07, min- 00:01

aggregate(all_trips_v3$ride_length2 ~ all_trips_v3$member_casual, FUN = mean) # casual avg: 19:44, member avg: 11:31
aggregate(all_trips_v3$ride_length2 ~ all_trips_v3$member_casual, FUN = median) # casual median: 11:08, member median: 08:07
aggregate(all_trips_v3$ride_length2 ~ all_trips_v3$member_casual, FUN = max) # causal max: 23:58:07, member max: 23:43:47, this is okay bc of the day passes
aggregate(all_trips_v3$ride_length2 ~ all_trips_v3$member_casual, FUN = min) # casual min: 00:01, member min: 00:01, wonder why these happen?

which(all_trips_v3$ride_length2 == '00:00:01') # check where ride length is only 1 second

aggregate(all_trips_v3$ride_length2 ~ all_trips_v3$member_casual + all_trips_v3$day_of_week, FUN = mean)
# gives us the average ride time by each day for members or casual riders





