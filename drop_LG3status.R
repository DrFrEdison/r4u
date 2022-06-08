dt <- list(); dt$R <- paste0(Sys.getenv("OneDriveCommercial"), "/FE_Methoden/", "Allgemein/R_dt_project/")
source(paste0(dt$R,"R/source_read.R"))
dt$wd <- dirname(rstudioapi::getSourceEditorContext()$path); setwd(dt$wd)

status <- list()
status$tz = "Europe/Berlin"

# which csv status files to modify in the folder?
dir(pattern = ".csv$")
status$csv <- c("210805_Linie_DS.csv", "210816_Linie_DS.csv")

# read and modify status csv's ####
status$raw <- lapply(status$csv, function(x) LG3.status(x))

# write modified status csv's ####

mapply( function( x, y ) write.csv2(x, y, row.names = F)
        , x = status$raw
        , y = gsub(".csv", "_mod.csv", status$csv) )