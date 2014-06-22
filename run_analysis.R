# SET SETWD as per file located in “getdata_projectfiles_UCI HAR Dataset")
”############
setwd ("C:/Users/alok/GDrive/Course/Getting and Cleaning Data/Data/getdata_projectfiles_UCI HAR Dataset")


# Basic Configuration for file Read and dump #############
DataPath <- "./UCI HAR Dataset"   # Path where the data is found. (Still assumes same layout provided by compressed archive)
OutputFile <- "tidy_mean.csv"    # Path to the file where the tidy data should be written to.
###################################

train_path <- paste(DataPath, "/train/", sep="")
test_path <- paste(DataPath, "/test/", sep="")

loadData <- function(X_file, Y_file, Subj_file) {
  # Read Descriptive variable names
  labels_tbl <- read.table(paste(DataPath,"/features.txt", sep=""))
  labels <- labels_tbl[[2]]
  
  # Read X_train data.. measurements.
  X <- read.table(X_file, col.names=labels, check.names=FALSE)
  
  # Read Y_train data... activities.
  Y <- read.table(Y_file)
  X$ActivityId <- Y[[1]]
  
  # Read subject data..
  Subjects <- read.table(Subj_file)
  X$Subject <- Subjects[[1]]
  
  X
}

loadMergedData <- function() {
  TrainingData <- loadData(paste(train_path,"/X_train.txt",sep=""), paste(train_path,"/y_train.txt",sep=""), paste(train_path,"/subject_train.txt", sep=""))
  TestData <- loadData(paste(test_path, "/X_test.txt",sep=""), paste(test_path, "/y_test.txt",sep=""), paste(test_path, "/subject_test.txt", sep=""))
  rbind(TrainingData, TestData)
}

mergeDatasets <- function(data1, data2) {
  rbind(data1, data2)
}

extractMeanStd <- function(data) {
  colnames <- names(data)
  meancolnames <- grep("-mean()", colnames, fixed=TRUE)
  stdcolnames <- grep("-std()", colnames, fixed=TRUE)
  colnums <- c(meancolnames, stdcolnames, match(c("ActivityId", "Subject"), colnames))
  data[, colnums]
}

meanEachActivity <- function(data) {
  splitData <- split(data, factor(data$ActivityId))
  splitMeans <- sapply(splitData, colMeans)
}

meanEachSubject <- function(data) {
  splitData <- split(data, factor(data$Subject))
  meanList <- lapply(splitData, meanEachActivity)
  meanDF <- as.data.frame(t(data.frame(meanList))) # Flip the data, so we have the right look-n-feel
  rownames(meanDF) <- NULL # Remove row names  
  meanDF
}

replaceActivityIdWithLabel <- function(data) {
  Activities <<- read.table(paste(DataPath, "/activity_labels.txt",sep=""), col.names=c("ID", "Activity"), check.names=FALSE, stringsAsFactors=FALSE)
  data$Activity <- sapply(data$ActivityId, function(x) as.character(Activities[x,2]))
  data$ActivityId <- NULL
  
  colnames <- names(data[!(names(data) %in% c("Subject", "Activity"))]) # Names minus Subject and Activity (so we can put them in front)
  colnames <- c("Subject", "Activity", colnames)
  
  lapply(data, function(x) if (is.list(x)) print(x))
  data[colnames]
}

if (!exists("MergedData")) {
  message("Loading and Merging Training and Test Data..")
  MergedData <- loadMergedData()
} else message("Not loading training and test data due to MergedData existance")

# Extract the Std Deviation and Mean variables from the merged data..
MeanStdData <- extractMeanStd(MergedData)

# Calculate the Mean of all of the stddev and means for each activity, grouped by subject.
meanOfAllData <- meanEachSubject(MeanStdData)

# Apply descriptive activity names..
meanOfAllData <- replaceActivityIdWithLabel(meanOfAllData)

message(paste("Writing tidy data (Mean of Mean & StdDev variables per Subject by Activity) to", OutputFile, sep=" "))
write.csv(meanOfAllData, file=OutputFile, row.names=FALSE)
