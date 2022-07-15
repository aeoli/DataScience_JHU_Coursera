### Load relevant libraries
library(dplyr)


### Load files
setwd("Getting_and_Cleaning_data/Final project/")
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
              "./Final_project.zip")
unzip("./Final_project.zip", exdir = ".")
list.files(".")

features <- read.table("./UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "code")


# 1. Merge the training and the test sets to create one data set.
x_data <- rbind(x_train, x_test) # stack x data (rows)
y_data <- rbind(y_train, y_test) # stack y data (rows)
sbj_data <- rbind(subject_train, subject_test) # stack participants data (rows)
main_df <- cbind(x_data, y_data, sbj_data) # all together (columns)

# 3. Extracts only the measurements on the mean and standard deviation for each measurement. 
subset <- main_df %>% 
  select(subject, code, contains("mean"), contains("std"))

# 4. Uses descriptive activity names to name the activities in the data set
subset$code <- activities[subset$code, 2]

# 4. Appropriately labels the data set with descriptive variable names. 
names(subset)[1] <- "Subject"
names(subset)[2] <- "Activity"
names(subset)<-gsub("^t", "Time_", names(subset))
names(subset)<-gsub("^f", "Frequency_", names(subset))
names(subset)<-gsub("(Body){1,3}", "Body_", names(subset))
names(subset)<-gsub("Acc", "Accelerometer_", names(subset))
names(subset)<-gsub("Gyro", "Gyroscope_", names(subset))
names(subset)<-gsub("Mag", "Magnitude_", names(subset))
names(subset)<-gsub("Jerk", "Jerk_", names(subset))
names(subset)<-gsub("tBody", "Time_Body_", names(subset))
names(subset)<-gsub("mean", "AVG_", names(subset), ignore.case = TRUE)
names(subset)<-gsub("std", "STD_", names(subset), ignore.case = TRUE)
names(subset)<-gsub("Freq\\.", "Frequency_", names(subset), ignore.case = TRUE)
names(subset)<-gsub("angle", "Angle_", names(subset))
names(subset)<-gsub("gravity", "Gravity_", names(subset))
names(subset)<-gsub("(\\.){1,3}", "_", names(subset), ignore.case = TRUE)
names(subset)<-gsub("(_){2,3}", "_", names(subset))
names(subset)<-gsub("_$", "", names(subset))

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of  
# each variable for each activity and each subject.
final <- subset %>% group_by(Subject, Activity) 
final <- summarise_all(final, mean)

write.table(final, "./grouped_tidy_dataset.txt", row.name=FALSE)
