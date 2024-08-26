---
editor_options: 
  markdown: 
    wrap: 72
---

# Description of scripts

This document describes which each of the create functions do. If you
look directly at the run_analysis.R script it also has text explaining
what is being done at each step.

## Primary Script

### create_tidy:

this is the primary function that calls all of the following functions.
It essentially takes all of the individual data that is isolated into
seperate files and combines them for the test and training sets. It then
adds a column to identify each observation as either test or training.
Finally it merges the test and training data sets together and creates a
summary data set. These are then saved into the output directory. There
are 6 phases to the function and they are shown below.

phase A download and unzip data phase B download and merge test phase C
download and merge train phase D merger test and train phase E create
average data set save F data to output

## start up scripts

### download_unzip:

this function download the data into your current working directory and
creates folded for the data and output. It is expected that you created
a folder for the scrips which this README.md file is describing and
upload the scripts to that directory.

### install_needed_packages:

this function downloads any needed packages for the script to
successfully run.

## gathering data

### activity_labels:

this function pulls the activity labels and creates a df to look up the
descriptive names instead of integers

### y_data:

this function pulls the y data and uses the activity lables to transform
the data into descriptive messages instead of integers

### subject_data:

this function pulls the subject data into a df

### x_data:

this function pulls the x data and also transforms the data from each
row equaling a vector of 128 measures into two different variables on
for the mean of the x data and one for the sd of the x data using the
mean_df and sd_df functions respectivly

### is_files:

this pulls the names of the Inertial Signals data locations and is an
input to the is_data function

### is_data:

this function pulls the Inertial Signals data and transforms the data in
the same way as the x_data function.

### mean_df:

this function takes the variable data frames and loops through each row
of the data creating the mean for the 128 measures

### sd_df:

this function takes the variable data frames and loops through each row
of the data creating the sd for the 128 measures
