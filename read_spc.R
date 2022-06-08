dt <- list(); dt$sourcep <- paste0(Sys.getenv("OneDriveCommercial"), "/FE_Methoden/")
dt$linux <- F;source(paste0(dt$sourcep,"Allgemein/R_dt_project/R/source_spc_files.R"));dt$task <- "read_plot_spc";dt$entertain <- F
source(paste0(wd$scripts,"choose_work_horse.R"))

# Copy the script into the directory where the desired spc files are stored. Than run it.
dt$wd <- dirname(rstudioapi::getSourceEditorContext()$path) # directory with spc-files. 
dir(dt$wd) # check if it is the right directory

dt$recursive <- F # do you want to include subdirectories? Logical, T or F

dt$subfiles <- NA # Only a sub-vector of spc-files to process?

dt$baseline <- NA # baseline correction at x nm, e.g. dt$baseline <- 400 for 400 nm

dt$pngplot <- F # make a fast png plot?  Logical, T or F
dt$plotlyplot <- F # make a html plot !Can take very long if there are many large spc files! Logical, T or F
dt$filestext <- NA # text vector for plot legend ####
dt$colp <- NA # col vector for plot ####

dt$readtoR <- T # read created .csv files directly into R? Logical, T or F
dt$plotlyplotR <- F # make a html plot from .csv files read into R?  Logical, T or F

# which spectra to export ?
# Absorption = "au"
# Transmission = "trans"
# Reference = "ref"
# Dark = "drk"
dt$export <- c("ref", "au", "trans", "drk")

spc_daten <- list()
spc_daten$writename <- list()
spc_daten$readname <- list()
spc_daten$raw <-  read_spc_files(directory = dt$wd
                                 , baseline = dt$baseline
                                 , pngplot = dt$pngplot
                                 , plotlyplot = dt$plotlyplot
                                 , recursive = dt$recursive
                                 , filestext = dt$filestext
                                 , colp = dt$colp
                                 , subfiles = dt$subfiles)

if(dt$readtoR)
  for(i in 1:length(dt$export)){
    if(length(spc_daten$raw[[grep(dt$export[i], names(spc_daten$raw))]]) == 0) dt$export[i] <- NA
    if(is.na(dt$export[i])) next
    
    namep <- paste0(.date(), "_", dt$export[i])
    if(all(dt$export[i] == "au", !is.na(dt$baseline))) namep <- paste0(.date(), "_", dt$export[i], "_bl")
    
    write_spc_files(spc_daten$raw[[grep(dt$export[i], names(spc_daten$raw))]]
                    , baseline = all(dt$export[i] == "au", !is.na(dt$baseline))
                    , write = T
                    , filename = spc_daten$writename[[i]] <- namep
                    , return_R = F)
  };dt$export <- dt$export[which(!is.na(dt$export))];rm(namep)

if(dt$readtoR){  
  spc_daten$readname <- lapply(paste0(spc_daten$writename, ".csv"), read.csv2)
  spc_daten$trans <- lapply(spc_daten$readname, .transfer_csv)
  names(spc_daten$trans) <- dt$export
}

if(all(dt$readtoR, dt$plotlyplotR)){
  for(i in 1:length(dt$export)){
    
    namep <- paste0(.date(), "_", dt$export[i])
    if(all(dt$export[i] == "au", !is.na(dt$baseline))) namep <- paste0(.date(), "_", dt$export[i], "_bl")
    
    plot_plotly_spc(spc_daten$trans[[grep(dt$export[i], names(spc_daten$trans))]]
                    , colp_dat = "filenamep"
                    , "spc"
                    , plot_name = namep
                    , immediately = F
                    , export_html = T)
  }
};rm(namep)
