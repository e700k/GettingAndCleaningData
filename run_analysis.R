# Summary: 
#
run_alaysis <- function() {
        library(dplyr)
        library(stringr)
        
        # Check if the data file is downloaded into the working directory; download if not
        if(!file.exists("UCI HAR Dataset/test/X_test.txt")) {
                print("Downloading input data...")
                download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                              "acc.zip")
                print("Extracting input data...")
                unzip("acc.zip")
        }
        
        # Read the activity labels into a dplyr data.frame, add column names,
        # and apply sentence case
        print("Reading activity data...")
        activity <- tbl_df(read.table("UCI HAR Dataset/activity_labels.txt"))
        names(activity) <- c("activityId", "activityLabel")
        activity$activityLabel <- str_to_title(gsub("_", " ",activity$activityLabel))
        
        # Read the feature labels into a dplyr data.frame and add column names
        print("Reading feature data...")
        features <- tbl_df(read.table("UCI HAR Dataset/features.txt"))
        names(features) <- c("featureId", "featureLabel")
        
        # TRAINING DATA
        # Read the data into a dplyr data.frames (X, Y and subject) and add column names
        print("Reading and formatting Training data (X, Y, subject)...")
        x_train <- tbl_df(read.table("UCI HAR Dataset/train/X_train.txt"))
        y_train <- tbl_df(read.table("UCI HAR Dataset/train/y_train.txt"))
        subject_train <- tbl_df(read.table("UCI HAR Dataset/train/subject_train.txt"))
        
        names(y_train) <- c("activityId")
        names(subject_train) <- c("subjectId")
        
        # Add features as column names in X
        names(x_train) <- as.vector(features$featureLabel)
        
        # Lookup activity labels from the activity table to add to Y
        y_train <- left_join(y_train, activity, by = "activityId")
        
        # Merge X and Y and delete the activityId column
        x_train <- bind_cols(x_train, y_train)
        x_train$activityId <- NULL
        
        # Merge with subject and reorder columns
        x_train <- bind_cols(x_train, subject_train)
        x_train <- x_train[, c((ncol(x_train) - 1):ncol(x_train), 1:(ncol(x_train) - 2))]
        
        # TEST DATA
        # Read the data into a dplyr data.frames (X, Y and subject) and add column names
        print("Reading and formatting Test data (X, Y, subject)...")
        x_test <- tbl_df(read.table("UCI HAR Dataset/test/X_test.txt"))
        y_test <- tbl_df(read.table("UCI HAR Dataset/test/y_test.txt"))
        subject_test <- tbl_df(read.table("UCI HAR Dataset/test/subject_test.txt"))
        
        names(y_test) <- c("activityId")
        names(subject_test) <- c("subjectId")
        
        # Add features as column names in X
        names(x_test) <- as.vector(features$featureLabel)
        
        # Lookup activity labels from the activity table to add to Y
        y_test <- left_join(y_test, activity, by = "activityId")
        
        # Merge X and Y and delete the activityId column
        x_test <- bind_cols(x_test, y_test)
        x_test$activityId <- NULL
        
        # Merge with subject and reorder columns
        x_test <- bind_cols(x_test, subject_test)
        x_test <- x_test[, c((ncol(x_test) - 1):ncol(x_test), 1:(ncol(x_test) - 2))]

        # Merge Training and Test data set; remove variables
        print("Merging Training and Test data sets...")
        merged_data <- bind_rows(x_train, x_test)
        rm(activity, features, y_train, y_test, subject_train, subject_test, x_train, x_test)
        
        # Creat summary table
        print("Creating and saving summary data table...")
        res <- merged_data %>% group_by(activityLabel, subjectId) %>% summarize_each(c(mean))
        write.table(res, file="run_analysis_output.txt", row.names = FALSE)
        
        print("Analysis saved as run_analysis_output.txt.")
        res
}

