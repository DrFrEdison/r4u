dt <- list(); dt$R <- paste0(Sys.getenv("OneDriveCommercial"), "/FE_Methoden/", "Allgemein/R_dt_project/")
source(paste0(dt$R,"R/source_read.R"))

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
