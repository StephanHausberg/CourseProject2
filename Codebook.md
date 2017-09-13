---
title: "Codebook - Course Project 2"
author: "Stephan Hausberg"
date: "8 September 2017"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Getting and Cleaning Data

# Introduction 
This is a Codebook for the corresponding course project 2 from Getting and Cleaning Data.

We download data from:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

with a description that can be found on

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

By running "run_analysis.R" we use some auxiliary data.frames named with a prefix "UCI...".

# Results: 
The "results" data frame has the following variables:

activity: there are 6 different activities as "Standing", "walking", "walking_upstairs", "walking_downstairs", "sitting" and "laying"

subject: In this data frame there are 30 different subjects with number 1 to 30.

The remaining variables are chosen according to the underlaying data set from the smartphone only containing "mean" and "std" substrings in the corresponding units from the codebook of the original data set.

# Transformations on the data.

We begin with downloading the data from the corresponding website and store it in the "temp"-variable. Using "read.table" we create 

UCItestX <- read.table(unz(temp,"UCI HAR Dataset/test/X_test.txt"))
UCItestY <- read.table(unz(temp,"UCI HAR Dataset/test/y_test.txt"))
UCItrainX <- read.table(unz(temp,"UCI HAR Dataset/train/X_train.txt"))
UCItrainY <- read.table(unz(temp,"UCI HAR Dataset/train/y_train.txt"))
UCILabels <- read.table(unz(temp,"UCI HAR Dataset/activity_labels.txt"))
UCIFeatures <- read.table(unz(temp,"UCI HAR Dataset/features.txt"))
UCISubjectTest<- read.table(unz(temp,"UCI HAR Dataset/test/subject_test.txt"))
UCISubjectTrain<- read.table(unz(temp,"UCI HAR Dataset/train/subject_train.txt"))

1st step: Merges the training and the test sets to create one data set.
We cbind UCItestX and UCItestY as well as UCItrainX and UCItrainY to rowbind the resulting data frames afterwards. 

2nd step: We use the grepl function to find a logical vector from the column names stored in UCIFeatures$V2 to classify where "mean" and "std" lies in. Afterwards we subset the data frame from above according to this vector.

3rd step: Then, we create a factor variable named "activity" with the corresponding levels from the UCILabels table. 

4th step: We label the data set with descriptive variable names by subsetting with the logical vector from above.

5th step: We integrate the subjects from UCISubjectTest and UCISubjectTrain and use the aggregate function with FUN = mean on the list "activity" and "subject". After renaming and deleting the  "subject" / "activity" columns we find the tidy data we searched for.