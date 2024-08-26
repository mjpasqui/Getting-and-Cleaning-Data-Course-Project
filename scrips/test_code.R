download_unzip <- function() { ## this code downloads and unzips files 
     ## and returns the directory path for the files
     
     ## creates directories for output, and data
     ifelse(!dir.exists("./data"),dir.create("./data"),print("directory exists"))
     ifelse(!dir.exists("./output"),dir.create("./output"),print("directory exists"))
     print("created data and output directories")
     
     ## downloads and unzips data files
     working.dir <- getwd()
     url.unzip <- "https://archive.ics.uci.edu/static/public/240/human+activity+recognition+using+smartphones.zip"
     dest.file <- paste0(working.dir,"/data/data.zip")
     download.file(url.unzip,dest.file)
     print("Downloaded Zip File")
     unzip(dest.file,exdir = "./data")
     unzip("./data/UCI HAR Dataset.zip",exdir = "./data")
     print("Unziped files")
     
     ## unlinks/delets the zip files you no longer need
     unlink("./data/data.zip")
     unlink("./data/UCI HAR Dataset.zip")
     print("unlinked zip files: Completed download and unzip procedure")
}

## this installs the needed packages
install_needed_packages <- function() {
     pack <- "dplyr" %in% rownames(installed.packages())
     if(pack == FALSE){install.packages("dplyr")
          print("dplyr installed")} 
     else {print("dplyr already installed")}
     library(dplyr)
     pack <- "reshape2" %in% rownames(installed.packages())
     if(pack == FALSE){install.packages("reshape2")
          print("reshape2 installed")} 
     else {print("reshape2 already installed")}
     library(reshape2)
     print("dplyr & reshape2 packages loaded")
}

## grabs the activity lables puts them into a list that I can then reference
activity_labels <- function() {
     raw.data <- read.csv("./data/UCI HAR Dataset/activity_labels.txt",header=FALSE)
     len = length(raw.data[[1]])
     df.act <- data.frame()
     raw.data <- raw.data[[1]]
     for (i in 1:len) {
          raw.split <- strsplit(raw.data[i]," ")
          df.act <- df.act %>% rbind(raw.split[[1]][2])
     }
     names(df.act)<-"activity"
     print("activity look up created")
     df.act
}

## turns y data into a dataframe renames activity: must input either test or train
y_data <- function(type = "test") {   ##this reads in the y_test data
     y.test <- read.csv(paste0("./data/UCI HAR Dataset/",type,"/y_",type,".txt"))
     df.act <- activity_labels()
     len <- nrow(y.test)
     df.test.act <- data.frame()
     for (i in 1:len) {
          single <- df.act[y.test[i,],]
          df.test.act <- df.test.act %>% rbind(single)
     }
     names(df.test.act)<-"activity"
     print("y data grabbed and renamed")
     df.test.act
}

## pulls the subject data and stores as a dataframe: Make sure you enter test or train
subject_data <- function(type = "test") {
     df.subject <- read.csv(paste0("./data/UCI HAR Dataset/",type,"/subject_",type,".txt"))
     names(df.subject)<-"subjects"
     print("subject data grabbed")
     df.subject
}

## downloads the x data
x_data <- function(type = "test") {
     x.data <- read.csv(paste0("./data/UCI HAR Dataset/",type,"/X_",type,".txt"))
     x.data.mean <- mean_df(x.data,"x_mean")
     x.data.sd <- sd_df(x.data,"x_sd")
     df.x <- cbind(x.data.mean,x.data.sd)
     print("x data grabbed")
     df.x
}

##grabs all of the files names of the inertial signals directory 
is_files <- function(type="test") {
     path.test <- paste0("./data/UCI HAR Dataset/",type,"/Inertial Signals")
     files <- dir(path.test)
     print("file names grabbed")
     files
}

## this code downloads the Inertial Signals data and then applies the mean
## and sd to them
is_data <- function(files) {
     len <- length(files)
     type <- ifelse(grepl("test",files[1]),"test","train")
     if(grepl("test",files[1])) { ## this code creates column names
          col.names <- gsub("_test.txt","",files)
     } else {col.names <- gsub("_train.txt","",files)}
     print("names created")
     df.is <- NULL
     
     for (i in 1:len) {
          ##Grabs each file in the files fold and reads the data
          current_file <- files[i]
          is.data <- read.csv(paste0("./data/UCI HAR Dataset/",type,"/Inertial Signals/"
                                     ,current_file))
          if(is.null(df.is)){df.is <- data.frame(1:nrow(is.data))}
          ## computes the mean for the current data
          is.data.mean <- mean_df(is.data,paste0(col.names[i],"_mean"))
          ## computes the sd for the current data
          is.data.sd <- sd_df(is.data,paste0(col.names[i],"_sd"))
          df.is <- cbind(df.is,is.data.mean,is.data.sd)
     }
     print("Inertial Signals data pulled: mean and sd calculated")
     df.is <- select(df.is,!names(df.is)[1])
     df.is
}

##takes the raw data that needs to be converted to mean
mean_df <- function(df,cname) {
     length <- nrow(df)
     new.df <- data.frame()
     for (i in 1:length) {
          df.split <- strsplit(df[i,],' ')
          df.split <- df.split[[1]]
          df.numeric <- as.numeric(df.split[!df.split==""])
          df.mean <- mean(df.numeric)
          new.df <- new.df %>% rbind(df.mean)
     }
     names(new.df) <- cname
     print(paste(cname,"mean calculated"))
     new.df
}

##takes the raw data that needs to be converted to sd
sd_df <- function(df,cname) {
     length <- nrow(df)
     new.df <- data.frame()
     for (i in 1:length) {
          df.split <- strsplit(df[i,],' ')
          df.split <- df.split[[1]]
          df.numeric <- as.numeric(df.split[!df.split==""])
          df.sd <- sd(df.numeric)
          new.df <- new.df %>% rbind(df.sd)
     }
     names(new.df) <- cname
     print(paste(cname,"sd calculated"))
     new.df
}

create_tidy <- function() {
     #phase A download and unzip data
     install_needed_packages()
     #download_unzip()
     
     #phase B download and merge test
     #B.1 download all test data into separate dfs
     type.phase <- "test"
     y.data <- y_data(type.phase)
     subject.data <- subject_data(type.phase)
     x.data <- x_data(type.phase)
     is.files <- is_files(type.phase)
     is.data <- is_data(is.files)
     
     #B.2 cbind all data together and create test variable
     test.data <- cbind(subject.data,y.data,x.data,is.data)
     test.data <- test.data %>% mutate(data_set = type.phase)
     test.data
     
     #phase C download and merge train
     type.phase <- "train"
     y.data <- y_data(type.phase)
     subject.data <- subject_data(type.phase)
     x.data <- x_data(type.phase)
     is.files <- is_files(type.phase)
     is.data <- is_data(is.files)
     
     #B.2 cbind all data together and create test variable
     train.data <- cbind(subject.data,y.data,x.data,is.data)
     train.data <- train.data %>% mutate(data_set = type.phase)
     train.data
     
     #phase D merger test and train
     tidy.data <- rbind(test.data,train.data)
     print("data merged")
     tidy.data
     
     #phase E create average data set
     tidy.group <- group_by(tidy.data, subjects, activity, data_set)
     tidy.avg.sum <- 
          summarise(tidy.group, x_mean=mean(x_mean),x_sd=mean(x_sd),
          body_acc_x_mean=mean(body_acc_x_mean),body_acc_x_sd=mean(body_acc_x_sd),
          body_acc_y_mean=mean(body_acc_y_mean),body_acc_y_sd=mean(body_acc_y_sd),
          body_acc_z_mean=mean(body_acc_z_mean),body_acc_z_sd=mean(body_acc_z_sd),
          body_gyro_x_mean=mean(body_gyro_x_mean),body_gyro_x_sd=mean(body_gyro_x_sd),
          body_gyro_y_mean=mean(body_gyro_y_mean),body_gyro_y_sd=mean(body_gyro_y_sd),
          body_gyro_z_mean=mean(body_gyro_z_mean),body_gyro_z_sd=mean(body_gyro_z_sd),
          total_acc_x_mean=mean(total_acc_x_mean),total_acc_x_sd=mean(total_acc_x_sd),
          total_acc_y_mean=mean(total_acc_y_mean),total_acc_y_sd=mean(total_acc_y_sd),
          total_acc_z_mean=mean(total_acc_z_mean),total_acc_z_sd=mean(total_acc_z_sd))
     tidy.avg.sum
     print("tidy avg calculated")
     
     #save data to output
     write.csv(tidy.data, "./output/tidy_data.csv",row.names = FALSE)
     write.csv(tidy.avg.sum, "./output/tidy_data_summary.csv",row.names = FALSE)
     print("data saved to output directory")
}


