# load reqd. library
library(tidyverse)
library(readr)
library(stringr)

# read data
x_test <- read_table("data/UCI_HAR_Dataset/test/X_test.txt", col_names=FALSE)
x_train <- read_table("data/UCI_HAR_Dataset/train/X_train.txt", col_names=FALSE)

y_test <- read_table("data/UCI_HAR_Dataset/test/y_test.txt", col_names=FALSE)
y_train <- read_table("data/UCI_HAR_Dataset/train/y_train.txt", col_names=FALSE)

subject_test <- read_table("data/UCI_HAR_Dataset/test/subject_test.txt", col_names=FALSE)
subject_train <- read_table("data/UCI_HAR_Dataset/train/subject_train.txt", col_names=FALSE)

activity_labels <- read_table("data/UCI_HAR_Dataset/activity_labels.txt", col_names=FALSE)
features <- read_table2("data/UCI_HAR_Dataset/features.txt", col_names=FALSE)

# name vars 
names(x_test) <- features[[2]]
names(x_train) <- features[[2]]
names(y_test) <- c("activity_id")
names(y_train) <- c("activity_id")
names(subject_test) <- c("subject")
names(subject_train) <- c("subject")
names(activity_labels) <- c("activity_id", "activity_type")

# merge test and train datasets
x_data <- rbind(x_test, x_train)
y_data <- rbind(y_test, y_train)
subject_data <- rbind(subject_test, subject_train)

# label the activity
y_data_labeled <- y_data %>% inner_join(activity_labels) %>% select(-contains("activity_id"))

# merge all datasets into one dataframe
merged_data <- cbind(subject_data, y_data_labeled, x_data)

# filter data to features with mean() and std()
features_mean_std <- grep("mean[()]|std[()]", names(merged_data), value=TRUE)
merged_data_filtered <- merged_data[,c("subject","activity_type",features_mean_std)]

# calculate mean of each feature by subject and activity
tidy_data <- merged_data_filtered %>% group_by(subject, activity_type) %>% summarize_all(funs(mean))

# add "avg_" prefix to metrics header
metrics <- names(tidy_data)[3:68]
new_metrics <- str_c("avg_", metrics)
names(tidy_data) <- c(names(tidy_data)[1:2],new_metrics)

# write results to file
write_tsv(tidy_data, "data/tidy_data.tsv")
