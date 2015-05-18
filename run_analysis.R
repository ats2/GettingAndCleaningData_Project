### Coursera JHU Data Science Specialization 
### Getting And Cleaning Data 
### Course Project 

## Data for the project: 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

## Tidy Dataset:
# 1.Each variable forms a column
# 2.Each observation forms a row
# 3.Each type of observational unit forms a table.

## Project steps:
# 1.Merges the training and the test sets to create one data set.
# 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3.Uses descriptive activity names to name the activities in the data set
# 4.Appropriately labels the data set with descriptive variable names. 
# 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

# Clear environment and set working directory 
rm(list = ls())
setwd("C:\\Users\\atsilcox\\Dropbox\\Allison\\Coursera\\3_Getting_Data")

# create data folder if does not already exist
if (!file.exists("data")) {dir.create("data")}
library(dplyr)

# read in train, test, and features, labels files
subject_train <- read.table("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
y_train <- read.table("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
X_train <- read.table("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
subject_test <- read.table("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
y_test <- read.table("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
X_test <- read.table("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
activity_labels <- read.table("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
features <- read.table("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt")

## 1.Merges the training and the test sets to create one data set.
# append train and test files of X, y, subject
X <- bind_rows(X_train,X_test)
y <- bind_rows(y_train,y_test)
subject<-bind_rows(subject_train,subject_test)
  
## 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
features_ms<-grep("mean|std", features[, 2],ignore.case=TRUE)
X <- X[, features_ms]

## 3.Uses descriptive activity names to name the activities in the data set
# merge activity labels
names(y)<-"activity_class"
names(activity_labels)<-c("activity_class","activity")

## 4.Appropriately labels the data set with descriptive variable names. 
# apply variable labels
names(X)<-features$V2[features_ms]
subject<-rename(subject, subject = V1)
# concatentate activity class, subject, and features 
dataset <- bind_cols(y, subject, X)
dataset<-merge(dataset,activity_labels, by.x="activity_class", by.y="activity_class")
 
## 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
dsn_agg<-aggregate(. ~ subject + activity_class + activity, dataset, mean)
dsn_agg<-dsn_agg[order(dsn_agg$activity,dsn_agg$subject),]
write.table(dsn_agg, file = "./GettingAndCleaningData_Project/tidydata.txt",row.name=FALSE)

