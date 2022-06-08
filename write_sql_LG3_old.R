dt <- list(); dt$R <- paste0(Sys.getenv("OneDriveCommercial"), "/FE_Methoden/", "Allgemein/R_dt_project/")
source(paste0(dt$R,"R/source_read.R"))
source(paste0(wd$scripts,"_function_write_LG3_to_server.R"))

input <- list()
input$customer = "CCEP"
input$location = "Dorsten"
input$unit = "DS"

setwd(wd$sql$LG3)
dir()
LG3_transform_SQL_to_csv(csv_file = "170601_180113_Dorsten_DS.csv"
                         , file_directory = getwd()
                         , sqlquestion = "production")
