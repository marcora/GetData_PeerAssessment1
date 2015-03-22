# Getting and Cleaning Data Course Project

The data used for this project are described in and were obtained from [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). Briefly, each of 30 volunteers performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone on the waist. Using its embedded accelerometer and gyroscope, 561 measurements were obtained for each record (time point) while performing each activity. These measurements come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz.  Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).  Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

- tBodyAcc-XYZ
- tGravityAcc-XYZ
- tBodyAccJerk-XYZ
- tBodyGyro-XYZ
- tBodyGyroJerk-XYZ
- tBodyAccMag
- tGravityAccMag
- tBodyAccJerkMag
- tBodyGyroMag
- tBodyGyroJerkMag
- fBodyAcc-XYZ
- fBodyAccJerk-XYZ
- fBodyGyro-XYZ
- fBodyAccMag
- fBodyAccJerkMag
- fBodyGyroMag
- fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

- mean(): Mean value
- std(): Standard deviation

The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The test and training datasets are each split into three parts:

- The 'subject' part containing the subject id for each record
- The 'X' part containing the 561 measurements for each record
- The 'y' part containing the activity id for each record

First, load some useful packages.


```r
library(dplyr)
library(magrittr)
```

Second, read the subject, X and y parts of the test and training datasets from the supplied zip file in the working directory.


```r
test.subject = read.table(unz("getdata-projectfiles-UCI HAR Dataset.zip", "UCI HAR Dataset/test/subject_test.txt"), col.names = c('subject'))
test.X = read.table(unz("getdata-projectfiles-UCI HAR Dataset.zip", "UCI HAR Dataset/test/X_test.txt"))
test.y = read.table(unz("getdata-projectfiles-UCI HAR Dataset.zip", "UCI HAR Dataset/test/y_test.txt"), col.names = c('activity'))

train.subject = read.table(unz("getdata-projectfiles-UCI HAR Dataset.zip", "UCI HAR Dataset/train/subject_train.txt"), col.names = c('subject'))
train.X = read.table(unz("getdata-projectfiles-UCI HAR Dataset.zip", "UCI HAR Dataset/train/X_train.txt"))
train.y = read.table(unz("getdata-projectfiles-UCI HAR Dataset.zip", "UCI HAR Dataset/train/y_train.txt"), col.names = c('activity'))
```

Then, merge the test and training datasets for each part to create one dataset per part.


```r
data.subject = rbind(test.subject, train.subject)
data.X = rbind(test.X, train.X)
data.y = rbind(test.y, train.y)
```

Read descriptive variable and activity names from the supplied zip file in the working directory.


```r
features = read.table(unz("getdata-projectfiles-UCI HAR Dataset.zip", "UCI HAR Dataset/features.txt"))
activity_labels = read.table(unz("getdata-projectfiles-UCI HAR Dataset.zip", "UCI HAR Dataset/activity_labels.txt"), col.names = c('activity', 'label'))
```

Appropriately label the X dataset with descriptive variable names.


```r
names(data.X) = features[, 2]
```

Extract only the measurements on the mean and standard deviation for each measurement.


```r
data.X = data.X[, grepl('-(mean|std)\\(\\)', names(data.X))]
```

Use descriptive activity names to name the activities in the y dataset.


```r
data.y %<>% mutate(activity = as.factor(activity))

levels(data.y$activity) = activity_labels$label
```

Finally merge the subject, X and y datasets into a single tidy dataset.


```r
data = cbind(data.subject, data.y, data.X)
```

Create a second, independent tidy dataset with the average of each variable for each activity and each subject, print it, and then write it to disk.


```r
data = tbl_df(data)

data %<>% group_by(subject, activity) %>% summarise_each(funs(mean))

data
```

```
## Source: local data frame [180 x 68]
## Groups: subject
## 
##    subject           activity tBodyAcc-mean()-X tBodyAcc-mean()-Y
## 1        1            WALKING         0.2773308      -0.017383819
## 2        1   WALKING_UPSTAIRS         0.2554617      -0.023953149
## 3        1 WALKING_DOWNSTAIRS         0.2891883      -0.009918505
## 4        1            SITTING         0.2612376      -0.001308288
## 5        1           STANDING         0.2789176      -0.016137590
## 6        1             LAYING         0.2215982      -0.040513953
## 7        2            WALKING         0.2764266      -0.018594920
## 8        2   WALKING_UPSTAIRS         0.2471648      -0.021412113
## 9        2 WALKING_DOWNSTAIRS         0.2776153      -0.022661416
## 10       2            SITTING         0.2770874      -0.015687994
## ..     ...                ...               ...               ...
## Variables not shown: tBodyAcc-mean()-Z (dbl), tBodyAcc-std()-X (dbl),
##   tBodyAcc-std()-Y (dbl), tBodyAcc-std()-Z (dbl), tGravityAcc-mean()-X
##   (dbl), tGravityAcc-mean()-Y (dbl), tGravityAcc-mean()-Z (dbl),
##   tGravityAcc-std()-X (dbl), tGravityAcc-std()-Y (dbl),
##   tGravityAcc-std()-Z (dbl), tBodyAccJerk-mean()-X (dbl),
##   tBodyAccJerk-mean()-Y (dbl), tBodyAccJerk-mean()-Z (dbl),
##   tBodyAccJerk-std()-X (dbl), tBodyAccJerk-std()-Y (dbl),
##   tBodyAccJerk-std()-Z (dbl), tBodyGyro-mean()-X (dbl), tBodyGyro-mean()-Y
##   (dbl), tBodyGyro-mean()-Z (dbl), tBodyGyro-std()-X (dbl),
##   tBodyGyro-std()-Y (dbl), tBodyGyro-std()-Z (dbl), tBodyGyroJerk-mean()-X
##   (dbl), tBodyGyroJerk-mean()-Y (dbl), tBodyGyroJerk-mean()-Z (dbl),
##   tBodyGyroJerk-std()-X (dbl), tBodyGyroJerk-std()-Y (dbl),
##   tBodyGyroJerk-std()-Z (dbl), tBodyAccMag-mean() (dbl), tBodyAccMag-std()
##   (dbl), tGravityAccMag-mean() (dbl), tGravityAccMag-std() (dbl),
##   tBodyAccJerkMag-mean() (dbl), tBodyAccJerkMag-std() (dbl),
##   tBodyGyroMag-mean() (dbl), tBodyGyroMag-std() (dbl),
##   tBodyGyroJerkMag-mean() (dbl), tBodyGyroJerkMag-std() (dbl),
##   fBodyAcc-mean()-X (dbl), fBodyAcc-mean()-Y (dbl), fBodyAcc-mean()-Z
##   (dbl), fBodyAcc-std()-X (dbl), fBodyAcc-std()-Y (dbl), fBodyAcc-std()-Z
##   (dbl), fBodyAccJerk-mean()-X (dbl), fBodyAccJerk-mean()-Y (dbl),
##   fBodyAccJerk-mean()-Z (dbl), fBodyAccJerk-std()-X (dbl),
##   fBodyAccJerk-std()-Y (dbl), fBodyAccJerk-std()-Z (dbl),
##   fBodyGyro-mean()-X (dbl), fBodyGyro-mean()-Y (dbl), fBodyGyro-mean()-Z
##   (dbl), fBodyGyro-std()-X (dbl), fBodyGyro-std()-Y (dbl),
##   fBodyGyro-std()-Z (dbl), fBodyAccMag-mean() (dbl), fBodyAccMag-std()
##   (dbl), fBodyBodyAccJerkMag-mean() (dbl), fBodyBodyAccJerkMag-std()
##   (dbl), fBodyBodyGyroMag-mean() (dbl), fBodyBodyGyroMag-std() (dbl),
##   fBodyBodyGyroJerkMag-mean() (dbl), fBodyBodyGyroJerkMag-std() (dbl)
```

```r
write.table(data, "data.txt", row.names = FALSE)
```
