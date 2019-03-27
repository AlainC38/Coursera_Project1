library(dplyr)

Path_file = "C:\\Coursera\\Final project\\UCI HAR Dataset\\"


# Read training data
data_train <- read.table(paste(Path_file,"train\\X_train.txt", sep="") , header = FALSE, sep = "", dec =".") %>% mutate(set = "training")

# Read test data
data_test <- read.table(paste(Path_file,"test\\X_test.txt", sep=""), header = FALSE, sep = "", dec =".") %>%  mutate(set = "test")

# Read class of activities for training
activity_train <- read.table(paste(Path_file,"train\\Y_train.txt", sep=""), header = FALSE, sep = "")

# Read class of activities for test
activity_test <- read.table(paste(Path_file,"test\\Y_test.txt", sep=""), header = FALSE, sep = "")

# Read training subjects
subject_train <- read.table(paste(Path_file,"train\\subject_train.txt", sep=""), header = FALSE, sep = "")

# Read tests subjects
subject_test <- read.table(paste(Path_file,"test\\subject_test.txt", sep=""), header = FALSE, sep = "")

# Merges the training and the test se,ts to create one data set
activity_all <- rbind(activity_train, activity_test)
data_all <- rbind(data_train, data_test)
subject_all <- rbind(subject_train, subject_test)


# Read column names for features
col_names <- read.table(paste(Path_file,"features.txt", sep=""), header = FALSE)
#select column names  related to mean() or std()
sel_mean <- filter(col_names, grepl('mean()', V2))
sel_std <- filter(col_names, grepl('std()', V2))

# Merge 2 selection of features 
# add a column V3 with features reference to facilitate future selection in dataset
# and re-order them by feature reference
sel_names <- rbind(sel_mean, sel_std)  %>% mutate(V3 = paste("V",V1, sep="")) %>% arrange(V1)

# Extract selected colums/features from data
sel_data <- select(data_all, pull(sel_names,V3))

# rename columns of global selected dataset for clarification using data from table "features"
# sel_names is a referential for data calalog
colnames(sel_data) <- pull(sel_names,V2)

# Read names of activities
activity_labels <- read.table(paste(Path_file,"activity_labels.txt", sep=""), header = FALSE)

# Add a id_record to activities to ensure appropriate re-order in the next step
activity_all <- mutate(activity_all, id_record = as.numeric(rownames(activity_all)))

#Merge labels to get a meaning of the activity class and remove column V1 (class of activity) that is no more useful in a tidy dataset
activity_all_label <- merge(activity_all, activity_labels, by = "V1") %>% arrange(id_record) %>% select(-V1)
colnames(activity_all_label) <- c("id_record", "Lbl_Activity")

# Add activities_label to merged dataset and remove id_record which is no more useful
activity_label_data <- cbind(activity_all_label, sel_data) %>% select (-id_record)

#Rename column and add subjects to dataset
colnames(subject_all) <- c("Id_Subject")
subject_label_data <- cbind(subject_all, activity_label_data)

View(subject_label_data)

========================
Syn_Results <- subject_label_data %>% group_by(Lbl_Activity, Id_Subject) %>% summarise_all("mean")
View(Syn_Results)






