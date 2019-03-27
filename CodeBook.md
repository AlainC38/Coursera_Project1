This CodeBook describes the variables, the data, and any transformations or work that are performed to clean up the data.

About the data (Human Activity Recognition Using Smartphones Dataset):

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years.

Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope the data  captured  are:
- 3-axial linear acceleration and 
- 3-axial angular velocity at a constant rate of 50Hz.

Obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The dataset includes the following files:
=========================================

- 'README.txt'
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features(# 561)
- 'activity_labels.txt': Links the 6 class labels with their 6 activity name (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
- 'train/X_train.txt': Training set (7352 records of 561 features)
- 'train/y_train.txt': Training labels (class of activity for the 7352 records above)
- 'train/subject_test.txt' : Id of subjects for the 7352 records ablove)
- 'test/X_test.txt': Test set  (2947 records of 561 features)
- 'test/y_test.txt': Test labels (class of activity for the 2947 records above)
- 'test/subject_test.txt': Id of subjects for the 2947 records ablove)

- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

Documentation about the script in R:
=========================================
The requirements for the project are the following:
1) Merges the training and the test sets to create one data set.
2) Extracts only the measurements on the mean and standard deviation for each measurement.
3) Uses descriptive activity names to name the activities in the data set
4) Appropriately labels the data set with descriptive variable names.
5) From the data set in step 4, 
- creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Part 1 - Merge DataSets:
========================
- library dplyr is loaded to enable data manipulation
- Data are read from the txt files from training and test sets
- a column 'set' is added to identify the source dataset and to allow some possible debug analysis
- the dataframe used to store data are: data_train, data_test, activity_train, activity_test, subject_train, subject_test
- rbind() function is used to merge the 3 training and test datasets (i. e. data, activity, subject)
- the respective merged dataframe are: data_all, activity_all, subject_all

Part 2 - Extract only the mean and standard deviation:
=======================================================
- col_names dataframe id used to store the names of the 561 features from the file 'features.txt'
- grepl() function is used to select features including mean() or std() in their names (V2 column from col_names dataframe)
- As a result, sel_names dataframe is used to store the features related to mean and standard deviation (rbind of the 2 previous selections)
- a V3 column agregation ("V"+ id of the seleted features) is added to dataframe selnames to enable easier extraction (with select function)
- the dataframe sel_data is used to store the selected data (i.e. mean and std) from dataframe data_all created in part 1

Part 3 & 4 - Uses descriptive activity names & Appropriately labels the data
============================================================================
- colnames() function is used to rename columns of dataframe sel_data with the name of the selected features
- activity_labels dataframe is used to store label of activities from file 'activity_labels.txt'

- column id_record is added to to dataframe activity_all to secure the order/integrity of data after the upcoming merge()
- merge() function is used to translate 'class of activities' (V1 column of activity_all) to a meaningful 'label of activity' (column  V1 of activity_labels). The result is stored in activity_all_label data frame

- colnames() is used to rename columns of activity_all_label data as "id_record" and "Lbl_Activity"
- cbind() function is used to add a the activities(from activity_all_label) for all data selected (in sel_data) and store them in activity_label_data dataframe
- Finally cbind() is used again to add 'Id of subject' (from subject_all) to activity/data already processed and store them in subject_label_data dataframe

As a result of all those steps, the tidy result is available in subject_label_data dataframe with the following columns:
- "Id_Subject": Id of the subject who provided the data
- "Lbl_Activity": label of the activity recorded (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
- List of features related to mean or standard deviation

Part 5 - tidy data set with the average of each variable for each activity and each subject
===========================================================================================
- group_by() function is used to group data in subject_label_data dataframe by Lbl_Activity, Id_Subject
- summarise_all () function is used to calculate mean for all features/variable in the dataframe subject_label_data
- The result is hosted in dataframe Syn_Results

View() function can be used at any step to visualize dataframe


