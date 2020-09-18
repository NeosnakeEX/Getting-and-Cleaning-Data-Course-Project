x_test <- read.table('X_test.txt')
y_test <- read.table('y_test.txt')
x_train <- read.table('X_train.txt')
y_train <- read.table('y_train.txt')

merged_test <- cbind(x_test,y_test)
merged_train <- cbind(x_train,y_train)
merged_data <- rbind(merged_test,merged_train)

rename_cols <- read.table('features.txt')
rename_cols <- as.vector(rename_cols[,2])
names(merged_data) <- c(rename_cols,'Activities')

mean_std_col_indices <- grep('\\bmean()\\b|std()',names(merged_data))

merged_data <- merged_data[,c(mean_std_col_indices,562)]

activity_labels <- read.table('activity_labels.txt')
activity_labels <- as.vector(activity_labels[,2])

for (i in 1:length(activity_labels)){
  merged_data$Activities <- gsub(i,activity_labels[i],merged_data$Activities)
}


subject_test <- read.table('subject_test.txt')
subject_train <- read.table('subject_train.txt')
total_subjects <- rbind(subject_test,subject_train)
names(total_subjects) <- c('Subjects')

merged_data_with_subjects <- cbind(merged_data,total_subjects)

averaged <- aggregate(merged_data_with_subjects,list(Subjects=merged_data_with_subjects$Subjects,Activities=merged_data_with_subjects$Activities),mean)
averaged <- averaged[,1:(length(averaged)-2)]
