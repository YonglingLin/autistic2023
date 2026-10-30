###
# prepare the data file
# Clear existing objects and set working directory to this script's location.
rm(list=ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Load shared libraries, plotting theme settings, and utility functions.
source('environPrepar.R')

# Input/output folders used throughout the script.
rawdatapath = '../1_data/outfrommat'
datapath='../3_ana_out'
path_figs='../5_figs'
today_tag <- format(Sys.Date(), "%Y%m%d")

# Small helper to keep CSV export naming consistent.
save_dated_csv <- function(data, prefix, out_dir = datapath) {
  out_file <- file.path(out_dir, paste0(prefix, "_", today_tag, ".csv"))
  write.csv(data, file = out_file, row.names = FALSE)
}

# Read experiment-level source tables.
Lab         <- read.csv(file.path(rawdatapath, "Lab_FULLTABLE_29-Jul-2021_ridgeALL.csv"), header=TRUE, sep=",")
Online1_2   <- read.csv(file.path(rawdatapath, 'Online1_Online2_standard_07-Sep-2023_ridgeALL.csv'), header=TRUE, sep=',')
Online3     <- read.csv(file.path(rawdatapath, 'Online3_standard_07-Sep-2023_ridgeALL.csv'), header=TRUE, sep=',')

#-----------------------------------------------------------------------------
# Define four versions: Lab; Online1; Online2; Online3
#-----------------------------------------------------------------------------

Lab$ver <- c('lab')
Online1_2$ver <- ifelse(Online1_2$groupver==0,'online2','online1')
Online3$ver <- c('online3')

#- Create a full dataset;
# Build the full participant-level table and derive analysis variables.
Fulldata <- setFull(Lab, Online1_2, Online3)
Fulldata <- addBehIndex(Fulldata)
Fulldata$mode <- ifelse(Fulldata$ver=='lab','lab','online')
Fulldata$AQcutoff <- ifelse(Fulldata$AQbinary_total>=32,'aboveAQcutoff','belowAQcutoff')

file_name <- paste(datapath,"/Fulldata_", format(Sys.Date(), "%Y%m%d"), ".csv", sep = "")
save_dated_csv(Fulldata, "Fulldata")



#
# export dataset

online1 <- subset(Fulldata, ver=='online1')
save_dated_csv(online1, "online1")

online2 <- subset(Fulldata, ver=='online2')
save_dated_csv(online2, "online2")

online3 <- subset(Fulldata, ver=='online3')
save_dated_csv(online3, "online3")

lab <- subset(Fulldata, ver=='lab')
save_dated_csv(lab, "lab")

