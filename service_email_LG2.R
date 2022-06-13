#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#
###                         ###
###  ######       ########  ###
###  ##    ##     ########  ###
###  ##     ##       ##     ###
###  ##     ##       ##     ###
###  ##     ##       ##     ###
###  ##     ##       ##     ###
###  ##    ##        ##     ###
###  ######          ##     ###
###                         ###
#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#
###                         ###
### By Markus Kurtz         ###
### For DauschTechnologies  ###
### 2021                    ###
###                         ###
#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#
###
### Script to download and process
### yesterdays .log, .spc and .csv
### files from LG1 and LG2 from
### dauschtechnologiesservice@gmail.com
###
### main info can be found here:
### https://cran.r-project.org/web/packages/mRpostman/vignettes/basics.html
### (Accessed on 2021-10-07)

# Read working directories on the DT-Server ####
library(devtools); suppressMessages(install_github("DrFrEdison/r4dt", dependencies = T) ); library(r4dt); dt <- list()

# dt <- list(); dt$R <- paste0(Sys.getenv("OneDriveCommercial"), "/FE_Methoden/", "Allgemein/R_dt_project/")
# suppressMessages(source(paste0(dt$R,"R/wd.R")))
# source(paste0(dt$R,"R/_function_read_service_backup_path.R"))
# source(paste0(dt$R,"R/_function_service_email_lg2.R"))
# source(paste0(dt$R,"R/_function_service_email_lg2.R"))
# source(paste0(dt$R,"R/_function_unzip_LG2.R"))
# source(paste0(dt$R,"R/_function_read_produktnummer.R"))
# suppressMessages(source(paste0(dt$R,"R/source_read.R")))

# delete task ####
require(taskscheduleR)
suppressWarnings(tasks <- taskscheduler_ls())
if("DT_MK_R_LG2_Read_Email_log" %in% tasks$Aufgabenname) taskscheduler_delete("DT_MK_R_LG2_Read_Email_log")

# Load required packages ####
suppressWarnings(suppressMessages(require(mRpostman)))
suppressWarnings(suppressMessages(require(zip)))
suppressWarnings(suppressMessages(require(this.path)))
suppressWarnings(suppressMessages(require(taskscheduleR)))
# Main Parameter ####
main = list()
main$serviceemail <- "dauschtechnologiesservice@gmail.com" # Email-Adress
main$serviceimap <- "imaps://imap.gmail.com" # IMAP Server
main$pw <- "tkizrjzwjebkoqpe" # Gmail App Password
main$verbose <- T # get info
main$ssl <- T # SSL?
main$folder <- "INBOX" # Inbox folder

# delete ####
main$delete_files <- T
main$delete_mail <- F

if(as.numeric(strftime(Sys.Date(), "%u")) == 2){ # Delete on each Tuesday
  main$delete_files <- T
  main$delete_mail <- T
}

if(as.numeric(strftime(Sys.Date(), "%u")) == 6){ # Delete on each Saturday
  main$delete_files <- T
  main$delete_mail <- T
}

# Master parameter ####
lg_master <- list()
lg_master$dat <- read.csv2(paste0(wd$VBox, "R2go/wd/service_check.csv"), sep = "\t") # Service File
lg_master$wd <- "C:/csvtemp/lg_service" # wd to download files
lg_master$today <- as.Date(Sys.Date())
lg_master$yesterday <- lg_master$today - 1 # Yesterday

# unzip ####
for(i in 4:0){
main$unzip <- T
main$unzip_type <- lg_master$yesterday - i
if(as.numeric(strftime(Sys.Date(), "%u")) == 3){ # Unzip all files on each Wednesday
  main$unzip_type <- NA}

# Function ####
service_email_LG2(today = lg_master$today
                  , yesterday = lg_master$yesterday
                  , systems = lg_master$dat
                  , wd_export = lg_master$wd
                  , servicemail = main$serviceemail
                  , serviceimap = main$serviceimap
                  , pw = main$pw
                  , verbose = main$verbose
                  , ssl = main$ssl
                  , folder = main$folder
                  , delete_files = main$delete_files
                  , delete_emails = main$delete_mail)
}
# unzip ####
dt$lineT <- T # do you want to execute the function only for the chosen customer / location / unit? If yes, than set to T
dt$customer <- "CCEP"
dt$LG <- "2"
dt$date_choose <- lg_master$yesterday # Unzip only one date?
dt$year = "2022"
dt$unzip_to_dir <- "C:/csvtemp"

for(i in 1:nrow(lg_master$dat)){
  dt$location <- lg_master$dat$Standort[i]
  dt$line <- lg_master$dat$Anlage[i]
  unzip.merge.LG2(year = dt$year, date = dt$date_choose, line = dt$lineT, unzip.dir = dt$unzip_to_dir)
}


# Product data ####
for(o in 1:nrow(lg_master$dat)){
  produkt_per_day_year(customer = lg_master$dat$Kunde[o]
                       , location = lg_master$dat$Standort[o]
                       , line = lg_master$dat$Anlage[o]
                       , LG = lg_master$dat$LG[o]
                       , year = year(lg_master$today)
                       , date = lg_master$yesterday)

}


service.email.log <- paste0(wd$R.user.logs, "service_email_LG2_log.R")
taskscheduler_create(taskname = "DT_MK_R_LG2_Read_Email_log", rscript = service.email.log,
                     schedule = "ONCE", starttime = format(Sys.time() + 60, "%H:%M"))
setwd(wd$R.user.logs)
unlink("service_email_LG2_log.log")
