# Drop file in folder with .zip files and the script will write you .csv files 

# csv files from .spc files or .log files?
log_or_spc <- "log" # "log" or "spc"

# set to "SG" if .zip file is from Loeningen
LG <- 2 

# Which spectra? c("spc", "ref", "drk")
filetype <- c("spc", "ref", "drk") 

# delete extraction folder when process is finished
delete_extract = T

drop_zip <- function(path = dirname(rstudioapi::getSourceEditorContext()$path), log_or_spc = log_or_spc, LG = LG, filetype = filetype, delete_extract = delete_extract){
  setwd( path )
  zipfile = dir( pattern = ".zip$")
  lapply(zipfile, function( x )  read_log_files( wd = path
                                                 , zipfile = x
                                                 , LG = LG
                                                 , log_or_spc = log_or_spc
                                                 , filetype = filetype
                                                 , delete_extract = delete_extract))
}
