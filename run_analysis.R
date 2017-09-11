##
## run_analysis.R - Course Project 2 - Coursera - week 4 - Getting and Cleaning Data
##

## This R Script solves Course Project 2

## First, we download the corresponding zip-file and extract test and training data.
library(data.table)
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
UCItestX <- read.table(unz(temp,"UCI HAR Dataset/test/X_test.txt"))
UCItestY <- read.table(unz(temp,"UCI HAR Dataset/test/y_test.txt"))
UCItrainX <- read.table(unz(temp,"UCI HAR Dataset/train/X_train.txt"))
UCItrainY <- read.table(unz(temp,"UCI HAR Dataset/train/y_train.txt"))
UCILabels <- read.table(unz(temp,"UCI HAR Dataset/activity_labels.txt"))
UCIFeatures <- read.table(unz(temp,"UCI HAR Dataset/features.txt"))
UCISubjectTest<- read.table(unz(temp,"UCI HAR Dataset/test/subject_test.txt"))
UCISubjectTrain<- read.table(unz(temp,"UCI HAR Dataset/train/subject_train.txt"))
unlink(temp)

# 1. Merges the training and the test sets to create one data set.
UCImergedXY_1 <- cbind(UCItestX,UCItestY)
UCImergedXY_2 <- cbind(UCItrainX,UCItrainY)
UCImergedXY <- rbind(UCImergedXY_1,UCImergedXY_2)
rm(UCImergedXY_1,UCImergedXY_2)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
column_log <- grepl("mean",UCIFeatures$V2)|grepl("std",UCIFeatures$V2)
UCImergedXY <- UCImergedXY[,c(column_log,TRUE)]

# 3. Uses descriptive activity names to name the activities in the data set
# First, we avoid that two columns are named "V1" and set the last col, that stems from UCItrainY and 
# UCItestY as the numeric activity index.
colnames(UCImergedXY)[80] <- "activity"
# Then, we create a factor variable named "activity" with the corresponding levels from the UCILabels table.
UCImergedXY$activity <- factor(UCImergedXY$activity, levels = UCILabels$V1, labels = UCILabels$V2)

# 4. Appropriately labels the data set with descriptive variable names.
# We find the corresponding column names stored in the UCIFeatures data.frame as factors.
colnames(UCImergedXY)[1:79] <- as.character(UCIFeatures$V2[column_log])

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each 
# variable for each activity and each subject.
# We add the subjects data to the merged data frame
UCIsubjectMerged <- rbind(UCISubjectTest,UCISubjectTrain)
UCImergedXY <- cbind(UCImergedXY,UCIsubjectMerged)
colnames(UCImergedXY)[81] <- "subject"

# We introduce a new data frame containing the subject by number and activity by name as a string. In this
# case we find 30 subjects with 6 activities resulting in 180 rows for the new data frame.
# The aggregate function gives a solution to the given problem 
results <- aggregate(UCImergedXY[,1:81], FUN=mean, na.rm=TRUE,
                                    by=list(UCImergedXY$activity,UCImergedXY$subject) )
# Delete Subject to produce tidy data.
results <- results[,-c(82:83)]
# Rename the first two columns
colnames(results)[1:2] <- c("activity","subject")
rm(UCItestY,UCImergedXY,UCIFeatures,UCILabels,UCISubjectTest,UCISubjectTrain,UCIsubjectMerged,UCItestX,UCItrainX,UCItrainY)
