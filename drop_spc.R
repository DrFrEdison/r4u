dt <- list(); dt$R <- paste0(Sys.getenv("OneDriveCommercial"), "/FE_Methoden/", "Allgemein/R_dt_project/")
dt$linux <- F;source(paste0(dt$R,"R/source_spc_files.R"))
drop_spc(dirname(rstudioapi::getSourceEditorContext()$path), F)
