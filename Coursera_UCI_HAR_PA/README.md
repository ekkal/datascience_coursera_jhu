# Coursera_UCI_HAR_PA"

## Project Details

This project is about creating a tidy dataset from the original raw dataset available at

[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

The dataset contains data collected from the *accelerometers* from the *Samsung Galaxy S smartphone*.

The project contains the following files

1. The script **run_analysis.R**, which analyzes the above data files and creates a tidy dataset which is appropriate for further analysis.

2. The file **Codebook.md**, which describes the variables in the final tidy dataset created and the various steps involved.

## To run the script

1. Download and store the [zip file](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) into working directory.

2. Untar the zip file into 'data' directory. After unzip, go to 'data' dir and rename "getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset" to "UCI_HAR_Dataset".  The directory 'UCI_HAR_Dataset' contains following files.

        + train/X_train.txt - Train datasets with features observations 
        + train/y_train.txt - Activity labels for train datasets
        + test/X_test.txt - Train datasets with features observations
        + test/y_test.txt - Activity lables for test datasets
        + train/subject_train.txt - subject id for the train data set
        + test/subject_test.txt - subject id for the test data set
        + features.txt - features for which observations were noted
        + activity_labels.txt - activity labels

3. Download and copy the script **run_analysis.R** into working directory.

4. Install the package **tidyverse**, **readr**, **stringr** in your R environment, if it is not already installed.

        install.packages("tidyverse")
        install.packages("readr")
        install.packages("stringr")

5. To run the script, source **run_analysis.R** script into the R environment.

        > source( "run_analysis.R")

6. Step 5 above creates output file called "tidy_data.tsv" in tsv format in 'data' directory.

7. To see the tidy data in R type **tidy_data** at R command prompt.
