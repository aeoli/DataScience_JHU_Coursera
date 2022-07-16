---
title: "CodeBook"
output: html_document
date: '2022-07-14'
---

## Assignment - Getting and Cleaning Data Course Project
  
All processing steps are in the run_analysis.R script and are explained here in details.  
  
### Load relevant libraries and files
First we load dplyr, then we download the .zip with all the files needed, we unzip it, and eventually we load each file in R.  
  
The files are:  
1. features.txt - Names of all features selected for this database, coming from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ.  
2. activity_labels.txt - List of the 6 activities performed during the study.  
3. test/subject_test.txt - List of labels of the 9 volunteers for each observation, for the testing data set.  
4. test/X_test.txt - It contains the actual data recorded as testing data.  
5. test/y_test.txt - It contains the labels of the 6 activities for each observation, for the testing data set.  
6. test/subject_train.txt - List of labels of the 21 volunteers for each observation, for the training data set.  
7. test/X_train.txt - It contains the actual data recorded as training data.  
8. test/y_train.txt - It contains the labels of the 6 activities for each observation, for the training data set.  
  
### Merges the training and the test sets to create one data set
First, we stack the same type of data together:  
* x_data (10299 rows, 561 columns) - Created by stacking x_train and x_test  
* y_data (10299 rows, 1 column) - Created by stacking y_train and y_test  
* sbj_data (10299 rows, 1 column) - Created by stacking subject_train and subject_test  
  
Secondly, we merge everything together:  
* main_df (10299 rows, 563 column) - Created by merging the previous 3 data sets  
  
### Extracts only the measurements on the mean and standard deviation for each measurement
subset (10299 rows, 88 columns) is created by subsetting main_df and selecting only the required columns.  
  
### Use descriptive activity names to name the activities in the data set
We change the label number to activity name using the activities dataset.  

### Appropriately labels the data set with descriptive variable names
The dots (.) were removed, shortened words are replaced with their complete version (e.g., "Acc" was replaced by "Accelerometer"), and words are separated by a underscore (_) sign.  
  
### From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
final (180 rows, 88 columns) - Created by grouping 'subset' by activity and subject, and then applying the mean function.  
The data frame final is then exported as .txt file and the input files are removed.  

