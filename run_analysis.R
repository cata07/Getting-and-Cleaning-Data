## download and unzip files
fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("./dataset")){dir.create("./dataset", mode = "0777")}
if(!file.exists("./datase/UCI HAR Dataset.zip")){download.file(fileUrl, "./dataset/UCI HAR Dataset.zip")}
if(!file.exists("./datase/UCI HAR Dataset")){unzip(zipfile="./dataset/UCI HAR Dataset.zip", exdir="./dataset")}

## load libraries
library(dplyr)
library(data.table)

## extract train dataset
dataSubjectTrain  <- read.table("./dataset/UCI HAR Dataset/train/subject_train.txt")
dataActivityTrain <- read.table("./dataset/UCI HAR Dataset/train/y_train.txt")
dataFeaturesTrain <- read.table("./dataset/UCI HAR Dataset/train/X_train.txt") 

## extract test dataset
dataSubjectTest  <- read.table("./dataset/UCI HAR Dataset/test/subject_test.txt")
dataActivityTest <- read.table("./dataset/UCI HAR Dataset/test/y_test.txt")
dataFeaturesTest <- read.table("./dataset/UCI HAR Dataset/test/X_test.txt")

## 1. Merges the training and the test sets to create one data set.

## Merges rows for subject, activity and features
allDataSubject  <- rbind(dataSubjectTrain, dataSubjectTest)
allDataActivity <- rbind(dataActivityTrain, dataActivityTest)
allDataFeatures <- rbind(dataFeaturesTrain, dataFeaturesTest)

## set column names for subject and activity
setnames(allDataSubject, "V1", "subject")
setnames(allDataActivity, "V1", "activityNum")

## set column names for features
dataFeatures = read.table("./dataset/UCI HAR Dataset/features.txt")
setnames(dataFeatures, names(dataFeatures), c("featureNum", "featureName"))
colnames(allDataFeatures) <- dataFeatures$featureName

## Combine columns: subject, activity, features
allDataTable <- cbind(allDataSubject, allDataActivity, allDataFeatures)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## subset columns then contain "mean()" or "std()" substring
meanStdCols <- grep("mean\\(\\)|std\\(\\)", dataFeatures$featureName, value=TRUE)
meanStdCols <- union(meanStdCols, c("subject", "activityNum"))
meanStdDataTable <- subset(allDataTable, select = meanStdCols)

## 3. Uses descriptive activity names to name the activities in the data set
activityLabels<- read.table("./dataset/UCI HAR Dataset/activity_labels.txt", stringsAsFactors=FALSE)
setnames(activityLabels, names(activityLabels), c("activityNum","activityName"))
#allDataTable = merge(allDataTable, activityLabels, by='activityNum', all.x=TRUE)

n <- nrow(allDataTable)
for(i in 1:n){
  j <- allDataTable$activityNum[i]
  allDataTable$activityName[i] = activityLabels[j,2]
}

## 4. Appropriately labels the data set with descriptive variable names.
allDataTableCols = colnames(allDataTable)
allDataTableCols <- mapply(gsub, "^t", "time", allDataTableCols, USE.NAMES = FALSE)
allDataTableCols <- mapply(gsub, "^f", "frequency", allDataTableCols, USE.NAMES = FALSE)
allDataTableCols <- mapply(gsub, "\\(|\\)", "", allDataTableCols, USE.NAMES = FALSE)
allDataTableCols <- mapply(gsub, "-|,", ".", allDataTableCols, USE.NAMES = FALSE)
# assure that column names are unique and syntactically valid
allDataTableCols <- make.names(names=allDataTableCols, unique=TRUE, allow_ = TRUE)
setnames(allDataTable, allDataTableCols)

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
allDataTable.avg <- allDataTable %>%
  select(-activityName) %>% # exclude activityName; no avg for it
  group_by(subject, activityNum)  %>%
  summarise_each(funs(mean))
write.table(allDataTable.avg, "./dataset/tidyData.txt", row.name=FALSE)