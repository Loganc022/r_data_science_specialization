# 
# The following R script does the following (after loading data into the environment)
# 1) Merges the training and the test sets to create one data set.
# 2) Extracts only the measurements on the mean and standard deviation for each 
#     measurement. 
# 3) Uses descriptive activity names to name the activities in the data set
# 4) Appropriately labels the data set with descriptive variable names. 
# 5) From the data set in step 4, creates a second, independent tidy 
#     data set with the average of each variable for each activity and each subject.

# Step 1: Load data into environment assuming files on working dir
feature_labels <- read.table("features.txt", col.names=c("num","type"))
data_train_x <- read.table("train/X_train.txt", col.names=feature_labels$type)
data_train_y <- read.table("train/y_train.txt", col.names="activity_key")
data_test_x <- read.table("test/X_test.txt", col.names=feature_labels$type)
data_test_y <- read.table("test/y_test.txt", col.names="activity_key")

activity_labels <- read.table("activity_labels.txt", col.names=c("activity_key", 
                              "activity"))
data_test_subject <- read.table("test/subject_test.txt", col.names="subject")
data_train_subject <- read.table("train/subject_train.txt", col.names="subject")

names(activity_labels) <- c("activity_key","activity")

# Step 2: Merge 4 sets of data into one table
data_x <- rbind(data_train_x, data_test_x)
data_y <- rbind(data_train_y, data_test_y)
data_subject <- rbind(data_train_subject, data_test_subject)
data_full <- cbind(data_subject, data_x, data_y)
data_mean_std <- data_full %>% select(subject,
                                      grep("mean",names(data_full)),
                                      grep("std", names(data_full)),
                                      activity_key
                                      )

# Step 3: Use descriptive activity names instead of activity_key
data_mean_std_labeled <- merge(data_mean_std,activity_labels,by="activity_key")
data_mean_std_labeled <- subset(data_mean_std_labeled, select = -activity_key)

# Step 4: Relabel columns
names(data_mean_std_labeled)<-gsub("Acc","Accelerometer", names(data_mean_std_labeled))
names(data_mean_std_labeled)<-gsub("Gyro", "Gyroscope", names(data_mean_std_labeled))
names(data_mean_std_labeled)<-gsub("BodyBody", "Body", names(data_mean_std_labeled))
names(data_mean_std_labeled)<-gsub("Mag","Magnitude", names(data_mean_std_labeled))
names(data_mean_std_labeled)<-gsub("^t","Time", names(data_mean_std_labeled))
names(data_mean_std_labeled)<-gsub("^f","Frequency", names(data_mean_std_labeled))
names(data_mean_std_labeled)<-gsub("tBody","TimeBody", names(data_mean_std_labeled))
names(data_mean_std_labeled)<-gsub("-mean()","Mean", names(data_mean_std_labeled),
                                   ignore.case = TRUE)
names(data_mean_std_labeled)<-gsub("-std()","STD", names(data_mean_std_labeled),
                                   ignore.case = TRUE)
names(data_mean_std_labeled)<-gsub("-freq()","Frequency", names(data_mean_std_labeled),
                                   ignore.case = TRUE)
names(data_mean_std_labeled)<-gsub("angle","Angle", names(data_mean_std_labeled))
names(data_mean_std_labeled)<-gsub("grav","Gravity", names(data_mean_std_labeled))


# Step 5: Create new data set with average of each feature based on activity:
average_set <- data_mean_std_labeled %>% 
                group_by(subject, activity) %>% 
                summarize_all(mean)
write.table(average_set, "step_5_average_set.txt", row.name=FALSE)


