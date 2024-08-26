# Getting-and-Cleaning-Data-Course-Project
## The original data came form the following source.

Human Activity Recognition Using Smartphones Dataset
Version 1.0
===================================================================================================
Jorge L. Reyes-Ortiz(1,2), Davide Anguita(1), Alessandro Ghio(1), Luca Oneto(1) and Xavier Parra(2)
1 - Smartlab - Non-Linear Complex Systems Laboratory
DITEN - Università  degli Studi di Genova, Genoa (I-16145), Italy. 
2 - CETpD - Technical Research Centre for Dependency Care and Autonomous Living
Universitat Politècnica de Catalunya (BarcelonaTech). Vilanova i la Geltrú (08800), Spain
activityrecognition '@' smartlab.ws 
===================================================================================================

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:
======================================

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

## Transformed Output Variables
The tidy_data.csv holds the output of the data transformation. 
There are three columns that provide description variables to the data set.

subjects: contains which subject that row of data is for
activity: describes what activity the subject was doing when the observation took place
data_set: describes weather the observation was apart of the training or test data set

There are then 3 recorded variable types and one test variable set. Each of these have the mean and standard deviation of a 128 element vector taken for each observation which comprises of one row.  The 3 recorded variable types each have data for x, y, and z axis.
x: x data is just a test set of data
total_acc: The acceleration signal from the smartphone accelerometer from either the X, Y, or Z axis in standard gravity units 'g'.
body_acc: The body acceleration signal obtained by subtracting the gravity from the total acceleration.
body_gyro: The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second.

## Transormations preformed
The following transformations were performed.
1) the y variables were transformed to activity and instead of numbers each activity was writen as a discriptive string
2) for the x, total_acc, body_acc, and body_gyro each txt file was downloaded and written into R.  The data was provided in an 128 element vector for each observation.  Both the mean and standard deviation was taken of each observation and put into a table. 
3) the subjects, activity, x, and other variable data frames were then merged for both the test and training data sets.
4) a new column named data_set was then created to differentiate if the subject was in either the training or test data sets.
5) these two data sets were then merged together
6) a summary data set was then created to see the average of each variable in terms of each subject and activity combination
