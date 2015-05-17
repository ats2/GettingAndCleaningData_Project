rm(list = ls())
setwd("C:\\Users\\atsilcox\\Dropbox\\Allison\\Coursera\\3_Getting_Data")

Here are the data for the project: 
  
  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

You should create one R script called run_analysis.R that does the following. 
1.Merges the training and the test sets to create one data set.
2.Extracts only the measurements on the mean and standard deviation 
for each measurement. 
3.Uses descriptive activity names to name the activities in the 
data set
4.Appropriately labels the data set with descriptive variable names. 
5.From the data set in step 4, creates a second, independent tidy
data set with the average of each variable for each activity and 
each subject

Please upload the tidy data set created in step 5 of the instructions. 
Please upload your data set as a txt file created with 
write.table() using row.name=FALSE (do not cut and paste a 
dataset directly into the text box, as this may cause errors aving your submission).

Tidy Dataset:
1.Each variable forms a column
2.Each observation forms a row
3.Each type of observational unit forms a table.

Thus:
. Column headers are variable names (not values).
. One variable per column.
. One type of observational unit per table.
. A single observational unit is stored in one table (not multiple tables).

The five most common problems with messy datasets:
. Column headers are values, not variable names.
. Multiple variables are stored in one column.
. Variables are stored in both rows and columns.
. Multiple types of observational units are stored in the same table.
. A single observational unit is stored in multiple tables.

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
subject_test <- subject_test %>% mutate(status = "test")
subject_train <- subject_train %>% mutate(status = "train")
subject<-bind_rows(subject_train,subject_test)
  
## 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
features_ms<-grep("mean|std", features[, 2],ignore.case=TRUE)
X <- X[, features_ms]

## 3.Uses descriptive activity names to name the activities in the data set
# merge activity labels
names(y)<-"activity_class"
names(activity_labels)<-c("activity_class","activity")
y<-merge(activity_labels,y, by.x="activity_class", by.y="activity_class")

## 4.Appropriately labels the data set with descriptive variable names. 
# apply variable labels
names(X)<-features_ms
subject<-rename(subject, subject = V1)

# concatentate activity class, subject, and features 
dataset <- bind_cols(y, subject, X)
 
## 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
dsn_agg<-aggregate(. ~activity+subject+activity_class+status, dataset, mean)
dsn_agg<-dsn_agg[order(dsn_agg$activity,dsn_agg$subject),]
write.table(dsn_agg, file = "./data/tidydata.txt",row.name=FALSE)


dsn_agg <-
  dsn_final %>%
  group_by(activity,subject) %>%
  summarize(.,. = mean(.)) %>%
  arrange(activity,subject) %>%
  print
     
  

subfeatures<-features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]

####
data <- read.table(file_path, header = TRUE) #if they used some other way of saving the file than a default write.table, this step will be different
View(data)

A person wanting to make life easy for their marker would give the code for reading the file back into R in the readMe

you want a run_analysis R script, a ReadMe markdown document, a Codebook markdown document, and a tidy data text file