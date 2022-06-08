dt <- list(); dt$R <- paste0(Sys.getenv("OneDriveCommercial"), "/FE_Methoden/", "Allgemein/R_dt_project/")
source(paste0(dt$R,"R/source_read.R"))

for(i in 1:nrow(dt$customerlist))
produkt_per_day_year(customer = dt$customerlist$customer[i]
                     , location = dt$customerlist$location[i]
                     , line = dt$customerlist$line[i]
                     , LG = dt$customerlist$LG[i]
                     , year = substr(Sys.Date(),1,4))
