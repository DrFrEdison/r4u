dt <- list(); dt$R <- paste0(Sys.getenv("OneDriveCommercial"), "/FE_Methoden/", "Allgemein/R_dt_project/")
source(paste0(dt$R,"R/source_read.R"))

cg <- list()
cg$wd <- "C:/Users/MK/OneDrive - Dausch Technologies GmbH/Projekte/P200270_CG_R1.1/02_Projektabwicklung/FAT_Methodenentwicklung/210909_UV_Test"
cg$filename <- paste0(substr(gsub("-","",Sys.Date()),3,8), "_CG_export")
cg$recursive <- T
setwd(cg$wd)

# Export a csv here ####
cg$export <- read_txt_files_SG(wd = cg$wd, filename = cg$filename, recursive = cg$recursive)

# Only optional to get a fast overview ####
cg$import <- read.csv2(paste0(cg$filename,".csv"))

cg$type <- c("ABS", "REF", "DRK", "MEA")
cg$dat$spc <- cg$import[which(cg$import$Type == cg$type[1]),]
cg$dat$ref <- cg$import[which(cg$import$Type == cg$type[2]),]
cg$dat$drk <- cg$import[which(cg$import$Type == cg$type[3]),]
cg$dat$mea <- cg$import[which(cg$import$Type == cg$type[4]),]

cg$dat <- lapply(cg$dat, .transfer_csv)

par(mfrow = c(2,2))
matplot(cg$dat$spc$wl, t(cg$dat$spc$spc), type = "l", lty = 1, main = "Absorption Cleanguard", xlab = "lambda", ylab = "AU")
matplot(cg$dat$ref$wl, t(cg$dat$ref$spc), type = "l", lty = 1, main = "Referenz Cleanguard", xlab = "lambda", ylab = "Counts")
matplot(cg$dat$drk$wl, t(cg$dat$drk$spc), type = "l", lty = 1, main = "Dunkelwert Cleanguard", xlab = "lambda", ylab = "Counts")
matplot(cg$dat$mea$wl, t(cg$dat$mea$spc), type = "l", lty = 1, main = "MEA Cleanguard", xlab = "lambda", ylab = "Counts")