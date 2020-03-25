This document provides details about the variables stored in the final tidy data set and workings of the script.

## Description of Variables in the Final Tidy dataset

Following are the variables in the final tidy dataset stored in UCI-HAR-Dataset-Tidy.txt, which is the final output of the script

* __subject__  - integer 

        subject is the id of the volunteers for this experiment.

* __activity_type__   - character

        Is one of the following activities that was monitored for recording accelerometer parameters
  
        + LAYING
        + SITTING
        + STANDING
        + WALKING
        + WALKING_DOWNSTAIRS
        + WALKING_UPSTAIRS

* __Mean value of observed measurements of mean and standard deviations__ ( Column 3 thorugh 68 ) - numeric
 
        Are the average values of selected measurements of mean and standard deviation of the features  recorded from accelerometers of samsung phones of the volunteers. Following is the _list of the variables from column 3 through 68_, in that order.

        subject
        activity_type
        avg_tBodyAcc-mean()-X
        avg_tBodyAcc-mean()-Y
        avg_tBodyAcc-mean()-Z
        avg_tBodyAcc-std()-X
        avg_tBodyAcc-std()-Y
        avg_tBodyAcc-std()-Z
        avg_tGravityAcc-mean()-X
        avg_tGravityAcc-mean()-Y
        avg_tGravityAcc-mean()-Z
        avg_tGravityAcc-std()-X
        avg_tGravityAcc-std()-Y
        avg_tGravityAcc-std()-Z
        avg_tBodyAccJerk-mean()-X
        avg_tBodyAccJerk-mean()-Y
        avg_tBodyAccJerk-mean()-Z
        avg_tBodyAccJerk-std()-X
        avg_tBodyAccJerk-std()-Y
        avg_tBodyAccJerk-std()-Z
        avg_tBodyGyro-mean()-X
        avg_tBodyGyro-mean()-Y
        avg_tBodyGyro-mean()-Z
        avg_tBodyGyro-std()-X
        avg_tBodyGyro-std()-Y
        avg_tBodyGyro-std()-Z
        avg_tBodyGyroJerk-mean()-X
        avg_tBodyGyroJerk-mean()-Y
        avg_tBodyGyroJerk-mean()-Z
        avg_tBodyGyroJerk-std()-X
        avg_tBodyGyroJerk-std()-Y
        avg_tBodyGyroJerk-std()-Z
        avg_tBodyAccMag-mean()
        avg_tBodyAccMag-std()
        avg_tGravityAccMag-mean()
        avg_tGravityAccMag-std()
        avg_tBodyAccJerkMag-mean()
        avg_tBodyAccJerkMag-std()
        avg_tBodyGyroMag-mean()
        avg_tBodyGyroMag-std()
        avg_tBodyGyroJerkMag-mean()
        avg_tBodyGyroJerkMag-std()
        avg_fBodyAcc-mean()-X
        avg_fBodyAcc-mean()-Y
        avg_fBodyAcc-mean()-Z
        avg_fBodyAcc-std()-X
        avg_fBodyAcc-std()-Y
        avg_fBodyAcc-std()-Z
        avg_fBodyAccJerk-mean()-X
        avg_fBodyAccJerk-mean()-Y
        avg_fBodyAccJerk-mean()-Z
        avg_fBodyAccJerk-std()-X
        avg_fBodyAccJerk-std()-Y
        avg_fBodyAccJerk-std()-Z
        avg_fBodyGyro-mean()-X
        avg_fBodyGyro-mean()-Y
        avg_fBodyGyro-mean()-Z
        avg_fBodyGyro-std()-X
        avg_fBodyGyro-std()-Y
        avg_fBodyGyro-std()-Z
        avg_fBodyAccMag-mean()
        avg_fBodyAccMag-std()
        avg_fBodyBodyAccJerkMag-mean()
        avg_fBodyBodyAccJerkMag-std()
        avg_fBodyBodyGyroMag-mean()
        avg_fBodyBodyGyroMag-std()
        avg_fBodyBodyGyroJerkMag-mean()
        avg_fBodyBodyGyroJerkMag-std()

## Explaining run_analysis.R Script

+ load reqd. library

        library(tidyverse)
        library(readr)
        library(stringr)
        
+ read data

        x_test <- read_table("data/UCI_HAR_Dataset/test/X_test.txt", col_names=FALSE)
        x_train <- read_table("data/UCI_HAR_Dataset/train/X_train.txt", col_names=FALSE)
        
        y_test <- read_table("data/UCI_HAR_Dataset/test/y_test.txt", col_names=FALSE)
        y_train <- read_table("data/UCI_HAR_Dataset/train/y_train.txt", col_names=FALSE)
        
        subject_test <- read_table("data/UCI_HAR_Dataset/test/subject_test.txt", col_names=FALSE)
        subject_train <- read_table("data/UCI_HAR_Dataset/train/subject_train.txt", col_names=FALSE)
        
        activity_labels <- read_table("data/UCI_HAR_Dataset/activity_labels.txt", col_names=FALSE)
        features <- read_table2("data/UCI_HAR_Dataset/features.txt", col_names=FALSE)
        
+ name vars 

        names(x_test) <- features[[2]]
        names(x_train) <- features[[2]]
        names(y_test) <- c("activity_id")
        names(y_train) <- c("activity_id")
        names(subject_test) <- c("subject")
        names(subject_train) <- c("subject")
        names(activity_labels) <- c("activity_id", "activity_type")
        
+ merge test and train datasets

        x_data <- rbind(x_test, x_train)
        y_data <- rbind(y_test, y_train)
        subject_data <- rbind(subject_test, subject_train)
        
+ label the activity

        y_data_labeled <- y_data %>% inner_join(activity_labels) %>% select(-contains("activity_id"))
        
+ merge all datasets into one dataframe

        merged_data <- cbind(subject_data, y_data_labeled, x_data)
        
+ filter data to features with mean() and std()

        features_mean_std <- grep("mean[()]|std[()]", names(merged_data), value=TRUE)
        merged_data_filtered <- merged_data[,c("subject","activity_type",features_mean_std)]
        
+ calculate mean of each feature by subject and activity

        tidy_data <- merged_data_filtered %>% group_by(subject, activity_type) %>% summarize_all(funs(mean))
        
+ add "avg_" prefix to metrics header

        metrics <- names(tidy_data)[3:68]
        new_metrics <- str_c("avg_", metrics)
        names(tidy_data) <- c(names(tidy_data)[1:2],new_metrics)
        
+ write results to file

        write_tsv(tidy_data, "data/tidy_data.tsv")
