library(dplyr)
library(magrittr)

test.subject = read.table(unz("getdata-projectfiles-UCI HAR Dataset.zip", "UCI HAR Dataset/test/subject_test.txt"), col.names = c('subject'))
test.X = read.table(unz("getdata-projectfiles-UCI HAR Dataset.zip", "UCI HAR Dataset/test/X_test.txt"))
test.y = read.table(unz("getdata-projectfiles-UCI HAR Dataset.zip", "UCI HAR Dataset/test/y_test.txt"), col.names = c('activity'))

train.subject = read.table(unz("getdata-projectfiles-UCI HAR Dataset.zip", "UCI HAR Dataset/train/subject_train.txt"), col.names = c('subject'))
train.X = read.table(unz("getdata-projectfiles-UCI HAR Dataset.zip", "UCI HAR Dataset/train/X_train.txt"))
train.y = read.table(unz("getdata-projectfiles-UCI HAR Dataset.zip", "UCI HAR Dataset/train/y_train.txt"), col.names = c('activity'))

data.subject = rbind(test.subject, train.subject)
data.X = rbind(test.X, train.X)
data.y = rbind(test.y, train.y)

features = read.table(unz("getdata-projectfiles-UCI HAR Dataset.zip", "UCI HAR Dataset/features.txt"))
activity_labels = read.table(unz("getdata-projectfiles-UCI HAR Dataset.zip", "UCI HAR Dataset/activity_labels.txt"), col.names = c('activity', 'label'))

names(data.X) = features[, 2]

data.X = data.X[, grepl('-(mean|std)\\(\\)', names(data.X))]

data.y %<>% mutate(activity = as.factor(activity))

levels(data.y$activity) = activity_labels$label

data = cbind(data.subject, data.y, data.X)

data = tbl_df(data)

data %<>% group_by(subject, activity) %>% summarise_each(funs(mean))

data

write.table(data, "data.txt", row.names = FALSE)
