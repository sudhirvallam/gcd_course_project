rsis <- function() {
    url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

    dirn <- "analysis_tmp"
    # check of directory already exists. if yes then delete it
    if(file.exists(dirn))
        unlink(dirn, recursive = TRUE, force = TRUE)
    
    message("Create analysis directory")
    dir.create(dirn)
    
    # download file
    message("Downloading zipped data set...")
    dnf <- paste0(dirn,"/dataset.zip")
    download.file(url, destfile = dnf, method = "curl")
    
    # uzip file
    message("unzipping file...")
    unzip(dnf,exdir = dirn)
    
    # load feature
    library(data.table)
    ftrs <- read.table(paste0(dirn,"/UCI HAR Dataset/features.txt"))
    
    # function to merge and bind the train set files
    mrgData <- function(typ) {
        subdf <- read.table(paste0(dirn,"/UCI HAR Dataset/",typ,"/subject_",typ,".txt"), col.names = c("subject"))
        lbndf <- read.table(paste0(dirn,"/UCI HAR Dataset/",typ,"/y_",typ,".txt"), col.names = c("label"))
        dtdf <- read.table(paste0(dirn,"/UCI HAR Dataset/",typ,"/X_",typ,".txt"), col.names = ftrs[,2])
        mrgdf <- cbind(subdf, lbndf, dtdf)   
        mrgdf
    }
    
    # merge data sets
    message("Load/merge train data set..")
    trnDf <- mrgData("train")
    message("Load/merge test data set..")
    tstDf <- mrgData("test")
    
    # merge test and train data sets
    message("Merge test and train data sets...")
    df <- rbind(trnDf,tstDf)
    
    # filter and keep only columns with mean and std measurements
    # colmn names. Add 2 since the first two columns "subject" and "labels" need to be accounted for
    message("Removing columns other than mean and std")
    cols <- grep("mean|std",ftrs[,2]) + 2
    cols <- append(cols,c(1,2),0)
    df <- df[,cols]
    
    # add descriptive activity label names
    message("Load descriptive label activity names")
    lblNames <- read.table(paste0(dirn,"/UCI HAR Dataset/activity_labels.txt"), col.names = c("label", "label_name"))
    
    # add descriptive label names to data
    message("Add descriptive label activity names")
    df <- merge(df, lblNames, by.x="label", by.y = "label")
    
    #add descriptive column names to data
    message("Adding descriptive column names to data...")
    currnames <- names(df)
    nwnames <- gsub("\\.mean\\.+"," mean ", currnames)
    nwnames <- gsub("\\.std\\.+"," std dev ", nwnames)
    nwnames <- gsub("\\.meanFreq\\.+"," mean frequency", nwnames)
    nwnames <- sub("label_name","activity_name", nwnames)
    nwnames <- sub("label","activity_id", nwnames)
    colnames(df) = nwnames
    
    # create average of each variable for each activity and each subject
    message("Generating average of each variable for each activity and each subject...")
    library(dplyr)
    grpd <- group_by(df,subject,activity_id,activity_name)
    mngrp <- summarise_each(grpd,funs(mean))
    # add descriptive column names
    colnames(mngrp) <- append(names(mngrp)[1:3],sub("^","mean ",names(mngrp)[-c(1:3)]))
    
    message("Writing data to file...")
    write.table(mngrp, file = paste0(dirn,"/resultset.txt"), row.name = FALSE)
    message("Function end")
}