# Package update and initialization ####
library(devtools)
suppressMessages(install_github("DrFrEdison/r4dt", dependencies = T, upgrade = "always", quiet = T) )
suppressPackageStartupMessages(library(r4dt))

# Write csv from SQL folder to ServiceBackup ####
dt <- list()

# path to .csv files
setwd(dt$wd <- print(wd$sql$LG3) ) 
# dt$wd <- paste0( wd$VBox, "Spektren/LG3"); setwd(dt$wd)
setwd(dt$wd)

# .csv files
dt$csv <- print(dir(pattern = ".csv$")) 

# function to transfer files to server structure
lapply(dt$csv, function(x) LG3_transform_SQL_update_to_csv(x, file_directory = dt$wd))

# LG3_transform_SQL_update_to_csv(csv_file = dt$csv[[2]], file_directory = dt$wd) 

# delete files ###
##################
##################
##              ##
##  WATCH OUT   ##
##              ##
##################
##################
##              ##
## Delete Files ##
##              ##
##################

setwd(dt$wd)
dir()
file.remove(dt$csv)
dir()
