features <- read.table("features.txt", col.names = c("index", "feature"))
activities <- read.table("activity_labels.txt", col.names = c("id", "activity"))


x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt", col.names = "activity")
subject_train <- read.table("train/subject_train.txt", col.names = "subject")


x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt", col.names = "activity")
subject_test <- read.table("test/subject_test.txt", col.names = "subject")


x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)


colnames(x_data) <- features$feature


mean_std_cols <- grep("mean\\(\\)|std\\(\\)", features$feature)
x_data <- x_data[, mean_std_cols]


data <- cbind(subject_data, y_data, x_data)


data$activity <- activities$activity[data$activity]


names(data) <- gsub("\\(\\)", "", names(data))
names(data) <- gsub("-", "_", names(data))
names(data) <- gsub("^t", "Time_", names(data))
names(data) <- gsub("^f", "Frequency_", names(data))
names(data) <- gsub("Acc", "Accelerometer", names(data))
names(data) <- gsub("Gyro", "Gyroscope", names(data))
names(data) <- gsub("Mag", "Magnitude", names(data))
names(data) <- gsub("BodyBody", "Body", names(data))


library(dplyr)

tidy_data <- data %>%
  group_by(subject, activity) %>%
  summarise_all(mean)


write.table(
  tidy_data,
  file = "tidy_data.txt",
  row.names = FALSE
)


