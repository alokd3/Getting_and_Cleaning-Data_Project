

# **Usage**
 #
This project is for the "Getting and Cleaning Data" course from Coursera 2014.


# Data #
The data used for this project is the accelerometer data from the Samsung Galaxy S smartphone located here.

The data should be downloaded and extracted prior to running the R code found in this project, as per the description in the project requirements:


The code should have a file run_analysis.R in the main directory that can be run as long as the Samsung data is in your working directory. 

By default the data extracts to the directory "HCI HAR Dataset", which is where the script looks for the data.



# Files #
The only file required by this code is the "run_analysis.R" script. Sourcing the script into R will produce the desired output, which will be written to "tidy_mean.csv".

# Example #

Example Usage> source('~C:/Users/alok/GDrive/Course/Getting and Cleaning Data/Data/getdata_projectfiles_UCI HAR Dataset/run_analysis.R')
Loading and Merging Training and Test Data..
Writing tidy data (Mean of Mean & StdDev variables per Subject by Activity) to tidy_mean.csv

