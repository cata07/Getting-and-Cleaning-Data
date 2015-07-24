---
title: "GCD_project_readme"
author: "catalina enescu"
date: "10.07.2015"
---


## The working plann - "Divide et Impera"
According ```README.TXT```:

1. The experiments have been carried out with a group of **30** volunteers. 
2. Dataset has been randomly partitioned into two sets:
    + **70%** of the volunteers was selected for generating the **training** data 
    + **30%** the **test** data. 

#### The files that will be used to load data are:

File  | Cols No | Rows No | Values | File "Label"
-------|------ | ---------|----|----------------------------------------------
```train/subject_train.txt```| 1  | 7352 | contain values from the set {1, 2,..., 30}. 1 means the first subject, 2 means the second subject, etc. | SUBJECT TRAIN FILE
```train/y_train.txt```| 1  | 7352 | contain values from the set {1, 2,..., 6}. A number means one of the activities {WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING} | ACTIVITY TRAIN FILE 
```train/X_train.txt``` |561 | 7352 | a line is the feature vector with the time and frequency domain variables associated with a subject | FEATURE TRAIN FILE
```test/subject_test.txt```| 1  | 2947 | contain values from the set {1, 2,..., 30}. 1 mean the first subject, 2 means the second subject, etc. | SUBJECT TEST FILE
```test/y_test.txt```| 1  | 2947 | contain values from the set {1, 2,..., 6}. A number means one of the activities {WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING} | ACTIVITY TEST FILE 
```test/X_test.txt``` |561 | 2947 | a line is the feature vector with the time and frequency domain variables associated with a subject | FEATURE TEST FILE

#### 1. Merges the training and the test sets to create one data set

What is the purpose here? We want to look at all the data for the entire study: 70% (training) + 30% (test) = 100%. 
Looking at the above table, we conclude that we will obtain first:
1. a data table for  **all Subjects**: 1 col and 10299  rows (7352 rows from train + 2947 rows from test)
2. a data table for **all Activities** associated with subjects: 1 col and 10299 rows (7352 rows from train + 2947 rows from test)
3. a data table for **all Features** associated with the pairs (subject, activity): 561 cols and 10299 rows (7352 rows from train + 2947 rows from test)

But we need just one **tidy** data table for the entire study. So, we will combine the columns of the three data tables having in mind the rules of  the "tidyng data" technique:
1. Each variable is a column
2. Each observation is a row
3. Each type of observational unit is a table

##### Each variable is a column
Variables:
1. subject 
2. activity 
3. feature 1
4. feature 2
...
feature 561

The columns:
1. subject - is the column from **allSubject** data table
2. activityNum - is the column from **allActivity** data table
3. feature 1, feature 2,..., feature 561 - are the columns from **allFeatures** data table
The names for feature 1, feature 2,..., feature 561 are in the *features.txt* file.

##### Each observation is a row
- **Number of rows**: 10299 (7352 rows from train + 2947 rows from test)
- **One row contain**: the subject identifier, its **activity  number** and the 561 - feature vector with the time and frequency domain variables. 

##### Each type of observational unit is a table
All data will be into one data table - **allDataTable** - with 563 columns and 10299 rows.

#### 2. Extracts only the measurements on the mean and standard deviation for each measurement.
From **allDataTable** we will subset just the columns which contain one of the substrings: *mean()or std()*.

#### 3. Uses descriptive activity names to name the activities in the data set
In **allDataTable** we have the column *activityNum* - contain numbers from the set {1,2,3,4,5,6}
In *activityLabels.txt* file, we have the activity name associate with each number from the set {1,2,3,4,5,6}.
So, in **allDataTable** we will add a new column - *activityName* - with the descriptive activity names (we can do a merge between **allDataTable** and a data table with columns *activityNum, activityName* using the common column *activityNum*)


#### 4. Appropriately labels the data set with descriptive variable names. 

##### Rules for identifires
>"A syntactically valid name consists of letters, numbers and the dot or underline characters and starts with a letter or the dot not followed by a number. Names such as ".2way" are not valid, and neither are the reserved words." (help file, ?make.names)

> "Don't use underscores ( _ ) or hyphens ( - ) in identifiers. Identifiers should be named according to the following conventions. The preferred form for variable names is all lower case letters and words separated with dots (```variable.name```), but ```variableName``` is also accepted; function names have initial capital letters and no dots (```FunctionName```); constants are named like functions but with an initial k".
> - ```variable.name``` is preferred, ```variableName``` is accepted 
	- GOOD: ```avg.clicks``` 
	- OK: ```avgClicks ```
	- BAD: ```avg_Clicks```
- ```FunctionName ```
	- GOOD: ```CalculateAvgClicks ```
	- BAD: ```calculate_avg_clicks``` , ```calculateAvgClicks ```
Make function names verbs. 
Exception: When creating a classed object, the function name (constructor) and class should match (e.g., lm).
- ```kConstantName```

> Source: https://google-styleguide.googlecode.com/svn/trunk/Rguide.xml#identifiers

##### Informations from ```features_info.txt``` file

> The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (**prefix 't' to denote time**) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 
.... 

>Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the **'f' to indicate frequency domain signals**). 
...

##### Changes in the column names:
1. first "t" --> "time"
2. first "f" --> "frequency"
3. "-" | "," --> "."
4. "(" | ")" --> ""

If we prefer very short name:
5. "Body" --> "B."
6. "Acc" --> "A."
7. "Gravity" --> "G."
8. "Jerk" --> "J."
9. "Gyro" --> "g."
10. "Mag" --> "M."
11. "Freq" --> "F"
But here I keep the original notations - they are short and suggestive. They will be explained in the code book.

#### 5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
We will create a group by (subject, activity) then apply mean function.

## The code

### Assumption of works
The R code in run_analysis.R download and extract the zip file available at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip in the ```dataset``` folder in the R Working Directory

### Libraries Used
1. ```dplyr```      - "small functions that each do one thing well"; benefits to print
3. ```data.table``` - data.table inherits from data.frame. It offers fast subset, fast grouping, fast update, fast ordered joins and list columns in a short and flexible syntax, for faster development. It is inspired by A[B] syntax in R where A is a matrix and B is a 2-column matrix. Since a data.table is a data.frame, it is compatible with R functions and packages that only accept data.frame.

```
## Load libraries
library(dplyr)
library(data.table)
```

### 1. Merges the training and the test sets to create one data set.
#### 1.1 Extract dataset stored into files from train and test folder.

```
## extract train dataset
dataSubjectTrain  <- read.table("./dataset/UCI HAR Dataset/train/subject_train.txt")
dataActivityTrain <- read.table("./dataset/UCI HAR Dataset/train/y_train.txt")
dataFeaturesTrain <- read.table("./dataset/UCI HAR Dataset/train/X_train.txt") 

## extract test dataset
dataSubjectTest  <- read.table("./dataset/UCI HAR Dataset/test/subject_test.txt")
dataActivityTest <- read.table("./dataset/UCI HAR Dataset/test/y_test.txt")
dataFeaturesTest <- read.table("./dataset/UCI HAR Dataset/test/X_test.txt")
```

* ```read.table {utils}``` - "Reads a file in table format and creates a data frame from it, with cases corresponding to lines and variables to fields in the file." (from Help file)

##### Look at the dimensions of variables
```
> dim(dataSubjectTrain)
[1] 7352    1
> dim(dataActivityTrain)
[1] 7352    1
> dim(dataFeaturesTrain)
[1] 7352  561
```

```
> dim(dataSubjectTest)
[1] 2947    1
> dim(dataActivityTest)
[1] 2947    1
> dim(dataFeaturesTest)
[1] 2947  561
```

#### 1.2 Merges the training and the test sets to create one data set
```
## Combine rows - subject, activity and features
allDataSubject  <- rbind(dataSubjectTrain, dataSubjectTest)
allDataActivity <- rbind(dataActivityTrain, dataActivityTest)
allDataFeatures <- rbind(dataFeaturesTrain, dataFeaturesTest)
```
* ```rbind {base}``` - "Take a sequence of vector, matrix or data-frame arguments and combine by rows. These are generic functions with methods for other R classes." (from Help file)

##### Look at the dimensions of variables
```
> dim(allDataSubject)
[1] 10299     1
> dim(allDataActivity)
[1] 10299     1
> dim(allDataFeatures)
[1] 10299   561
```

#### 1.3 Each variable is a column (Tidyng data). Set column names
```
## set column names for subject and activity
setnames(allDataSubject, "V1", "subject")
setnames(allDataActivity, "V1", "activityNum")

## set column names for features
dataFeatures = read.table("./dataset/UCI HAR Dataset/features.txt")
setnames(dataFeatures, names(dataFeatures), c("featureNum", "featureName"))
colnames(allDataFeatures) <- dataFeatures$featureName
```
#### 1.4 Combine columns - subject, activity, features
```
## Combine columns: subject, activity, features
allDataTable <- cbind(allDataSubject, allDataActivity, allDataFeatures)
```
##### Look at the dimensions of variables
```
> dim(allDataTable)
[1] 10299   564
```
### 2. Extracts only the measurements on the mean and standard deviation for each measurement.
```
## subset columns then contain "mean()" or "std()" substring
meanStdCols <- grep("mean\\(\\)|std\\(\\)", dataFeatures$featureName, value=TRUE)
meanStdCols <- union(meanStdCols, c("subject", "activityNum"))
meanStdDataTable <- subset(allDataTable, select = meanStdCols)
```
### 3. Uses descriptive names to identify the activities in the data set
```
activityLabels<- read.table("./dataset/UCI HAR Dataset/activity_labels.txt", stringsAsFactors=FALSE)
setnames(activityLabels, names(activityLabels), c("activityNum","activityName"))
#allDataTable = merge(allDataTable, activityLabels, by='activityNum', all.x=TRUE)

n <- nrow(allDataTable)
for(i in 1:n){
  j <- allDataTable$activityNum[i]
  allDataTable$activityName[i] = activityLabels[j,2]
}
```

### 4. Appropriately labels the data set with descriptive variable names.
```
allDataTableCols = colnames(allDataTable)
allDataTableCols <- mapply(gsub, "^t", "time", allDataTableCols, USE.NAMES = FALSE)
allDataTableCols <- mapply(gsub, "^f", "frequency", allDataTableCols, USE.NAMES = FALSE)
allDataTableCols <- mapply(gsub, "\\(|\\)", "", allDataTableCols, USE.NAMES = FALSE)
allDataTableCols <- mapply(gsub, "-|,", ".", allDataTableCols, USE.NAMES = FALSE)
# assure that column names are unique and syntactically valid
allDataTableCols <- make.names(names=allDataTableCols, unique=TRUE, allow_ = TRUE)
setnames(allDataTable, allDataTableCols)
```
### 5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

```
allDataTable.avg <- allDataTable %>%
  select(-activityName) %>% # exclude activityName; no avg for it
  group_by(subject, activityNum)  %>%
  summarise_each(funs(mean))
```

### Write tidy data into txt file
```
write.table(allDataTable.avg, "./dataset/tidyData.txt", row.name=FALSE)
```
### Run the script and see the result
```
>source("run_analysis.R")
>View(read.table("./dataset/tidyData.txt"))
```
