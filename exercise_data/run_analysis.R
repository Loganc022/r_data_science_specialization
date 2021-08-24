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
data_train_x <- read.table("train/X_train.txt")
data_train_y <- read.table("train/y_train.txt")
data_test_x <- read.table("test/X_test.txt")
data_test_y <- read.table("test/y_test.txt")
feature_labels <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")
names(activity_labels) <- c("activity_key","activity")

# Step 2: Merge 4 sets of data into one table
names(data_train_x) <- feature_labels[,2]
names(data_test_x) <- feature_labels[,2]
names(data_train_y) <- "activity_key"
names(data_test_y) <- "activity_key"
data_train <- cbind(data_train_x, data_train_y)
data_test <- cbind(data_test_x, data_test_y)
data_full <- rbind(data_train,data_test)
data_mean_std <- data_full %>% select(grep("mean\\(\\)-",names(data_full)),
                                      grep("std\\(\\)-", names(data_full)),
                                      grep("activity_key", names(data_full))
                                      )

# Step 3: Use descriptive activity names instead of activity_key
data_mean_std_labeled <- merge(data_mean_std,activity_labels,by="activity_key")
data_mean_std_labeled <- subset(data_mean_std_labeled, select = -activity_key)

# Step 4: Relabel columns with _ instead of - and remove ()
colnames(data_mean_std_labeled) <- gsub("\\(\\)","",colnames(data_mean_std_labeled))
colnames(data_mean_std_labeled) <- gsub("-","_",colnames(data_mean_std_labeled))

# Step 5: Create new data set with average of each feature based on activity:
average_set <- data_mean_std_labeled %>% 
                group_by(activity) %>% 
                summarize(across(tBodyAcc_mean_X:fBodyGyro_std_Z,mean))

