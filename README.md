# Getting And Cleaning Data - Course Project

The script file **run_analysis.R** contains a single function that is
designed to work with the data set called "UCI HAR Dataset", that
includes

* Activity labels data file;
* Feature labels data file;
* Variables data file with the measured data (Training and Test separately);
* Activity ID data file for the measures (Training and Test separately);
* Subject ID data file for the measures (Training and Test separately).

**RUN_ANALYSIS** has no argument and upon calling it will also download the
datafile if it's not saved into the working directory.

For both the Training and Test data sets the script

* Adds the feautes as column names to X
* Drops all measures (columns) that is not average or standard deviation
* Adds the Y (activity) values to X and covnert its values to Labels
* Adds the subject data to X

The script then merges the 2 data sets and calculates the mean in a result
table grouped by activity and subject. This output is also being saved in
a text file: *run_analysis_output.txt*.
