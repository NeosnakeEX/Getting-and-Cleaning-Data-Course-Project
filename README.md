# Getting-and-Cleaning-Data-Course-Project

Here I will explain how run_analysis.R works.

First, the script reads in the testing and training data.

x_test <- read.table('X_test.txt')
y_test <- read.table('y_test.txt')
x_train <- read.table('X_train.txt')
y_train <- read.table('y_train.txt')



Then, The testing data is merged into one with the cbind function. This applies to the training data as well. Then, the two are merged using the rbind function.

merged_test <- cbind(x_test,y_test)
merged_train <- cbind(x_train,y_train)
merged_data <- rbind(merged_test,merged_train)

Next,
The rename_cols variable reads in the data from features.txt and selects the second column containing the names of the different measurements.
The column names of merged_data are renamed to the ones in the rename_cols and the last column is the Activities column containing the numbers 1-6 indicating the activity.

rename_cols <- read.table('features.txt')
rename_cols <- as.vector(rename_cols[,2])
names(merged_data) <- c(rename_cols,'Activities')

Then,
The mean_std_col_indices finds the indices where either mean() or std() appear in the column names of merged_data. (Note: This does not include meanFreq().)

mean_std_col_indices <- grep('\\bmean()\\b|std()',names(merged_data))


The merged_data variable is then filtered using the indices from the previous variables as well as the last column which is the activities column.

merged_data <- merged_data[,c(mean_std_col_indices,562)]

Then,
the activity_labels variable is assigned to the activity labels found in the text document and then converted into a vector.

activity_labels <- read.table('activity_labels.txt')
activity_labels <- as.vector(activity_labels[,2])

for (i in 1:length(activity_labels)){
  merged_data$Activities <- gsub(i,activity_labels[i],merged_data$Activities)
}

The for loop goes through and renames the integers in the Activities column using the activity_labels vector. (Ex. 1 gets turned into 'WALKING')

The next step is to read in the subject test and training data and then merging them into one variable, total_subjects, using the rbind function. Then, the column name is renamed to 'Subjects'.

subject_test <- read.table('subject_test.txt')
subject_train <- read.table('subject_train.txt')
total_subjects <- rbind(subject_test,subject_train)
names(total_subjects) <- c('Subjects')

Then the merged_data variable is merged with the total_subjects variable using the cbind function.

merged_data_with_subjects <- cbind(merged_data,total_subjects)

The last step is to calculate the average of each variable for each activity for each subject. The aggregate function is used to split the merged_data_with_subjects variable by
Subjects and Activites and then to calculate the mean of each column. The last step is to drop the last two columns which contained the Subjects and Activities data which are no longer needed as they are now the first two columns.

averaged <- aggregate(merged_data_with_subjects,list(Subjects=merged_data_with_subjects$Subjects,Activities=merged_data_with_subjects$Activities),mean)
averaged <- averaged[,1:(length(averaged)-2)]
