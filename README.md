# gcd_course_project
Getting &amp; Cleaning Data Course Project

**** Instructions to run the script ****

*Required Libraries*
Please ensure below libraries are installed
- data.table
- dplyr
- stringr

> source(run_analysis.R)
> rsis()

The generated data set file can be found in {user.home}/analysis_tmp/resultset.txt

**** Script Documentation ****

Step by step code documentation
- Creates a directory {user.home}/analysis_tmp. If one already exists then it deletes and creates a new one
- Downloads the zip file and unzips it
- Creates combined test data set and assigns appropriate column names loaded from "features.txt" file
- Creates combined train data set and assigns appropriate column names loaded from "features.txt" file
- Merges the test and train data set
- Remove all columns except the Mean and Standard Deviation columns
- Loads label names from "activity_labels.txt" and adds descriptive activity names as a new column to merged data
- Tidy the column names and remove any special characters / standardize names
- Group by subject, activity and create means for all other columns

Field descriptions can be found in the codebook.md file