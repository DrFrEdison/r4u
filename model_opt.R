input <- list(); input$R <- paste0(Sys.getenv("OneDriveCommercial"), "/FE_Methoden/", "Allgemein/R_dt_project/")
source(paste0(input$R,"R/source_pls.R"))
input$customerlist <- read.csv2(paste0(wd$data,"customer_list.csv"),sep="\t")

input$export_directory <- paste0(wd$fe$Pepsi$Mastermodelle,"Pepsi_Light//Modelloptimierung//"); setwd(input$export_directory)

input$date <- "220318"
input$parameter <- "Coffein"

# read prod data ####
setwd(input$export_directory)
setwd(paste0("./", input$date, "_", input$parameter))
setwd("./Produktionsdaten")

Pepsi.Light <- list()
Pepsi.Light$prod$LG <- fread("Produktionsspektren_Nieder_Roden_LG_Pepsi_Cola_Light_spc_clean.csv", dec = ",")
Pepsi.Light$prod$LG <- Pepsi.Light$prod$LG[ !duplicated(Pepsi.Light$prod$LG$datetime) , ]

Pepsi.Light$para$location <- c("Nieder_Roden")
Pepsi.Light$para$LG <- c("LG")
Pepsi.Light$para$beverage <- c("Pepsi_Light")

Pepsi.Light$para$main <- paste(Pepsi.Light$para$location, Pepsi.Light$para$LG)

Pepsi.Light$para$version <- "V_01"

# clean data ####
par(mfrow=c(1,2))
for(i in 1:length(Pepsi.Light$prod))  boxplot(Pepsi.Light$prod[[i]]$X270,main=Pepsi.Light$main[i])
Pepsi.Light$prod$LG <- Pepsi.Light$prod$LG[which(Pepsi.Light$prod$LG$X270>.38),]

for(i in 1:length(Pepsi.Light$prod))  boxplot(Pepsi.Light$prod[[i]]$X220,main=Pepsi.Light$main[i])

for(i in 1:length(Pepsi.Light$prod))  boxplot(Pepsi.Light$prod[[i]]$X200,main=Pepsi.Light$main[i])

for(i in 1:length(Pepsi.Light$prod))  boxplot(Pepsi.Light$prod[[i]]$X400,main=Pepsi.Light$main[i])

# transfer and reduce data amount ####
lapply(Pepsi.Light$prod, nrow)
Pepsi.Light$prod <- lapply(Pepsi.Light$prod, function(x) .transfer_csv(x, data.table.set = T))

# plot prod data ####
matplots(Pepsi.Light$prod$LG, "spc", "day", filename = paste0(.date(),"_Pepsi_Light_LG_prod_spc"))
matplots(Pepsi.Light$prod$LG, "1st", "day", filename = paste0(.date(),"_Pepsi_Light_LG_prod_1st"))

# Model Matrix ####
setwd(input$export_directory)
setwd(paste0("./", input$date, "_", input$parameter))
setwd("./Modellmatrix")

Pepsi.Light$model <- fread("220318_Pepsi_Light_Modellspektren_Ausmischung_match.csv", dec = ",")
Pepsi.Light$model <- Pepsi.Light$model[which(Pepsi.Light$model$Probe_Anteil != "SL") , ]
fwrite(Pepsi.Light$model, paste0(.datetime(), "_Pepsi_Light_Model_matrix.csv"), row.names = F, dec = ",", sep = ";")
Pepsi.Light$model <- .transfer_csv(csv.file = Pepsi.Light$model, data.table.set = T)

# PLS para####
Pepsi.Light$plspara$wlr <- .wlr_function(220:450, 260:450, 5)
nrow(Pepsi.Light$plspara$wlr)
Pepsi.Light$plspara$wlm <- .wlr_function_multi(240:300, 280:400, 10)
nrow(Pepsi.Light$plspara$wlm)
Pepsi.Light$plspara$wl <- rbind.fill(Pepsi.Light$plspara$wlm, Pepsi.Light$plspara$wlr)
nrow(Pepsi.Light$plspara$wl)

Pepsi.Light$plspara$ncomp <- 4
Pepsi.Light$plspara$substance <- "Coffein"
Pepsi.Light$para$unit <- bquote("%")
Pepsi.Light$para$ylab <- bquote("Coffein in %")

# Validation until here ####
# RAM ####
gc()
memory.limit(99999)

# PLS and LM ####
Pepsi.Light$pls$FS <- pls_function(csv_transfered = Pepsi.Light$model
                            , substance = Pepsi.Light$plspara$substance
                            , wlr = Pepsi.Light$plspara$wl 
                            , ncomp = Pepsi.Light$plspara$ncomp)

Pepsi.Light$pls_lm$FS <- pls_lm_function(Pepsi.Light$pls$FS
                                  , csv_transfered = Pepsi.Light$model
                                  , substance = Pepsi.Light$plspara$substance
                                  , wlr = Pepsi.Light$plspara$wl 
                                  , ncomp = Pepsi.Light$plspara$ncomp)

# Prediction ####
Pepsi.Light$pred$FS <- lapply(Pepsi.Light$prod,function(x) produktion_prediction(csv_transfered = x, pls_function_obj = Pepsi.Light$pls$FS, ncomp = Pepsi.Light$plspara$ncomp))

# Find the best model ####
Pepsi.Light$pls_merge$FS <- lapply(Pepsi.Light$pred$FS, function(x) .merge_pls(pls_pred = x, Pepsi.Light$pls_lm$FS ,R2=.85))
lapply(Pepsi.Light$pls_merge$FS, head)

# Prediciton ####
mod_c <- list()
mod_c$ncomp <- 2
mod_c$wl1 <- 265
mod_c$wl2 <- 335
mod_c$wl3 <- NA
mod_c$wl4 <- NA
mod_c$spc <- "2nd"

pred_final <- list()
par(mfrow = c(1,1))

pred_final$LG <- pred_of_new_model(Pepsi.Light$model
                                   , Pepsi.Light$plspara$substance, mod_c$wl1 , mod_c$wl2, mod_c$wl3, mod_c$wl4,  mod_c$ncomp, mod_c$spc
                                   , Pepsi.Light$prod$LG)

require(forecast)
pred_final$LG <- as.numeric(ma(pred_final$LG, 5))

plot(pred_final$LG - .bias(median(pred_final$LG, na.rm = T), 0, 100)
     , pch = 20, col = "blue", xlab = "KW", ylab = "Coffein", axes = F, ylim = c(90, 110))
.xaxisdate(Pepsi.Light$prod$LG$data$datetime)
sd(pred_final$LG, na.rm = T);mad(pred_final$LG, na.rm = T)

pred_final$model <- pls_function(Pepsi.Light$model, "Coffein", data.frame(mod_c$wl1, mod_c$wl2, mod_c$wl3, mod_c$wl4), mod_c$ncomp, spc = mod_c$spc)
pred_final$model <- pred_final$model[[grep(mod_c$spc, names(pred_final$model))[1]]][[1]]

plot(pred_final$model$loadings[ , 1], type = "l", col = "red", lwd = 2)
lines(pred_final$model$loadings[ , 2], col = "darkgreen", lwd = 2)

pls_analyse_plot(pls_function_obj = pred_final$model
                 , model_matrix = Pepsi.Light$model
                 , colp = "Probe"
                 , wl1 = mod_c$wl1
                 , wl2 = mod_c$wl2
                 , wl3 = mod_c$wl3
                 , wl4 = mod_c$wl4
                 , ncomp = mod_c$ncomp
                 , derivative = mod_c$spc
                 , pc_scores = c(1,2)
                 #, pl_regression_and_pred_vs_ref = ncomp
                 , var_xy = "y"
                 , val = F
                 , pngname = paste0(.datetime(), "_Modellanalyse_PC"
                                    , mod_c$ncomp, "_", mod_c$wl1, "_", mod_c$wl2, "_", mod_c$wl3, "_", mod_c$wl4, "_"
                                    , mod_c$spc))

# read Labordaten ####
setwd(input$export_directory)
setwd("..")
setwd("..")
setwd("./Validierung")
setwd("./Labordaten")

# Genshagen G6
Pepsi.Light$labordaten$G6 <- read.xlsx("211206_Fanta_Orange_Zero_GEN_G3_G6_Citronensaeure.xlsx")
Pepsi.Light$labordaten$G6$Probenahmedat. <- convertToDate(Pepsi.Light$labordaten$G6$Probenahmedat.)
Pepsi.Light$labordaten$G6$Zeit <- strftime(convertToDateTime(Pepsi.Light$labordaten$G6$Zeit), format = "%H:%M:%S")

names(Pepsi.Light$labordaten$G6)[which(names(Pepsi.Light$labordaten$G6) == "Probenahmedat.")] <- "Datum"
names(Pepsi.Light$labordaten$G6)[which(names(Pepsi.Light$labordaten$G6) == "Zeit")] <- "Uhrzeit"
Pepsi.Light$labordaten$G6$Date <- as.POSIXct(paste(Pepsi.Light$labordaten$G6$Datum, Pepsi.Light$labordaten$G6$Uhrzeit))
Pepsi.Light$labordaten$G6 <- Pepsi.Light$labordaten$G6[ , .moveme(colnames(Pepsi.Light$labordaten$G6), "Uhrzeit first; Datum first; Date first")]

# MOG LG
Pepsi.Light$labordaten$LG <- read.csv2("211124_Fanta_Orange_Zero_MOG_LG_Citronensaeure.csv")

Pepsi.Light$labordaten$LG$Datum <- as.Date(Pepsi.Light$labordaten$LG$Datum, "%d.%m.%Y")
Pepsi.Light$labordaten$LG$Uhrzeit <- strftime(as.POSIXct(as.character(Pepsi.Light$labordaten$LG$Uhrzeit),format="%H:%M"),format="%H:%M:%S")
Pepsi.Light$labordaten$LG$Date <- as.POSIXct(paste(Pepsi.Light$labordaten$LG$Datum,Pepsi.Light$labordaten$LG$Uhrzeit), format="%Y-%m-%d %H:%M:%S")
Pepsi.Light$labordaten$LG <- Pepsi.Light$labordaten$LG[.moveme(names(Pepsi.Light$labordaten$LG),"Citronensaeure last")]
Pepsi.Light$labordaten$LG$LG3 <- NA

Pepsi.Light$labordaten$LG <- Pepsi.Light$labordaten$LG[Pepsi.Light$labordaten$LG$Datum < "2021-07-15" | Pepsi.Light$labordaten$LG$Datum > "2021-09-22" , ]
Pepsi.Light$labordaten$LG <- Pepsi.Light$labordaten$LG[-which(Pepsi.Light$labordaten$LG$Date == "2021-02-22 17:33:00") , ]
Pepsi.Light$labordaten$LG <- Pepsi.Light$labordaten$LG[-which(Pepsi.Light$labordaten$LG$Date == "2021-06-21 14:06:00") , ]

# read prod data ##### 
setwd(input$export_directory)
Pepsi.Light$prod$G6 <- read.csv2("210101_211206_Genshagen_G6_Fanta_Zero_8_spc.csv")
Pepsi.Light$prod$LG <- read.csv2("210101_211206_Moenchengladbach_LG_Fanta_Zero_9_spc.csv")

# clean data ####
par(mfrow=c(1,2))
for(i in 1:length(Pepsi.Light$prod))  boxplot(Pepsi.Light$prod[[i]]$X270,main=Pepsi.Light$main[i])
Pepsi.Light$prod$G6 <- Pepsi.Light$prod$G6[which(Pepsi.Light$prod$G6$X270>.11),]
Pepsi.Light$prod$LG <- Pepsi.Light$prod$LG[which(Pepsi.Light$prod$LG$X270>.25),]

for(i in 1:length(Pepsi.Light$prod))  boxplot(Pepsi.Light$prod[[i]]$X220,main=Pepsi.Light$main[i])
Pepsi.Light$prod$LG <- Pepsi.Light$prod$LG[which(Pepsi.Light$prod$LG$X220>.65),]

for(i in 1:length(Pepsi.Light$prod))  boxplot(Pepsi.Light$prod[[i]]$X200,main=Pepsi.Light$main[i])
Pepsi.Light$prod$LG <- Pepsi.Light$prod$LG[which(Pepsi.Light$prod$LG$X200>.75),]

for(i in 1:length(Pepsi.Light$prod))  boxplot(Pepsi.Light$prod[[i]]$X400,main=Pepsi.Light$main[i])

# transfer and reduce data amount ####
lapply(Pepsi.Light$prod, nrow)
Pepsi.Light$prod <- lapply(Pepsi.Light$prod, .transfer_csv)

# Pred final ####
pred_final$G6 <- pred_of_new_model(Pepsi.Light$model
                                   , Pepsi.Light$plspara$substance, mod_c$wl1 , mod_c$wl2, mod_c$wl3, mod_c$wl4,  mod_c$ncomp, mod_c$spc
                                   , Pepsi.Light$prod$G6)
pred_final$LG <- pred_of_new_model(Pepsi.Light$model
                                   , Pepsi.Light$plspara$substance, mod_c$wl1 , mod_c$wl2, mod_c$wl3, mod_c$wl4,  mod_c$ncomp, mod_c$spc
                                   , Pepsi.Light$prod$LG)

require(forecast)
pred_final$G6 <- as.numeric(ma(pred_final$G6, 5))
pred_final$LG <- as.numeric(ma(pred_final$LG, 5))

# match Labor with Prediction ####
Pepsi.Light$match_lab_prod$G6 <- match_labor_produktion(daytime_labor = Pepsi.Light$labordaten$G6$Date
                                                 , daytime_produktion = Pepsi.Light$prod$G6$data$datetime
                                                 , parameter_labor = Pepsi.Light$labordaten$G6$Messwert
                                                 , parameter_produktion = pred_final$G6
                                                 , bias = 4.54
                                                 , optimize_match = T
                                                 , time = 3)
Pepsi.Light$bias$G6 <- print(mean(Pepsi.Light$match_lab_prod$G6$LG3_vs_lab, na.rm = T))

Pepsi.Light$match_lab_prod$LG <- match_labor_produktion(Pepsi.Light$labordaten$LG$Date
                                                 , Pepsi.Light$prod$LG$data$datetime
                                                 , Pepsi.Light$labordaten$LG$Citronensaeure 
                                                 , pred_final$LG
                                                 , -3.86
                                                 , optimize_match = T
                                                 , time = 5)
Pepsi.Light$bias$LG <- print(mean(Pepsi.Light$match_lab_prod$LG$LG3_vs_lab, na.rm = T))

# Create export csv ####
Pepsi.Light$export$G6 <-   data.frame(NR = 1:nrow(Pepsi.Light$prod$G6$data)
                               , Day = Pepsi.Light$prod$G6$data$date
                               , time = Pepsi.Light$prod$G6$data$time
                               , LG3 = pred_final$G6
                               , Lab = NA
                               , Charge = NA)

Pepsi.Light$export$G6$Lab[Pepsi.Light$match_lab_prod$G6$vec] <- Pepsi.Light$match_lab_prod$G6$parameter_labor
Pepsi.Light$export$G6 <- Pepsi.Light$export$G6[which(!is.na(Pepsi.Light$export$G6$LG3)),]
rownames(Pepsi.Light$export$G6) <- 1:nrow(Pepsi.Light$export$G6)
Pepsi.Light$export$G6$NR <- 1:nrow(Pepsi.Light$export$G6)

Pepsi.Light$export$LG <-   data.frame(NR = 1:nrow(Pepsi.Light$prod$LG$data)
                               , Day = Pepsi.Light$prod$LG$data$date
                               , time = Pepsi.Light$prod$LG$data$time
                               , LG3 = pred_final$LG
                               , Lab = NA
                               , Charge = NA)

Pepsi.Light$export$LG$Lab[Pepsi.Light$match_lab_prod$LG$vec] <- Pepsi.Light$match_lab_prod$LG$parameter_labor  
Pepsi.Light$export$LG <- Pepsi.Light$export$LG[which(!is.na(Pepsi.Light$export$LG$LG3)),]
rownames(Pepsi.Light$export$LG) <- 1:nrow(Pepsi.Light$export$LG)
Pepsi.Light$export$LG$NR <- 1:nrow(Pepsi.Light$export$LG)

# Check export csv ####
lapply(Pepsi.Light$export, function(x) mad(x$LG3))
lapply(Pepsi.Light$export, function(x) sd(x$LG3))
lapply(Pepsi.Light$export, function(x) median(x$LG3))

# Biaskorrektur ####
Pepsi.Light$bias$G6 <- print(.bias(median(Pepsi.Light$export$G6$LG3), 0, mean(Pepsi.Light$export$G6$Lab, na.rm = T)))
Pepsi.Light$bias$LG <- print(.bias(median(Pepsi.Light$export$LG$LG3), 0, mean(Pepsi.Light$export$LG$Lab, na.rm = T)))

Pepsi.Light$export$G6$LG3 <- Pepsi.Light$export$G6$LG3 - Pepsi.Light$bias$G6
Pepsi.Light$export$LG$LG3 <- Pepsi.Light$export$LG$LG3 - Pepsi.Light$bias$LG

quantile(Pepsi.Light$export$G6$LG3, na.rm = T)
quantile(Pepsi.Light$export$LG$LG3, na.rm = T)

# Plot and Clean export csv ####
par(mfrow = c(1,1))
plot(Pepsi.Light$export$G6$LG3)
Pepsi.Light$export$G6 <- Pepsi.Light$export$G6[which(Pepsi.Light$export$G6$LG3 > 92.5) , ]
Pepsi.Light$export$G6 <- Pepsi.Light$export$G6[which(Pepsi.Light$export$G6$LG3 < 102) , ]

plot(Pepsi.Light$export$LG$LG3)
Pepsi.Light$export$LG <- Pepsi.Light$export$LG[which(Pepsi.Light$export$LG$LG3 > 94) , ]

# stat para export csv ####
mean(Pepsi.Light$export$LG$LG3 - Pepsi.Light$export$LG$Lab, na.rm = T)
sd(Pepsi.Light$export$LG$LG3[which(!is.na(Pepsi.Light$export$LG$Lab))]  - Pepsi.Light$export$LG$Lab[which(!is.na(Pepsi.Light$export$LG$Lab))]) * 2

mean(Pepsi.Light$export$G6$LG3 - Pepsi.Light$export$G6$Lab, na.rm = T)
sd(Pepsi.Light$export$G6$LG3[which(!is.na(Pepsi.Light$export$G6$Lab))]  - Pepsi.Light$export$G6$Lab[which(!is.na(Pepsi.Light$export$G6$Lab))]) * 2

# Export ####
setwd(input$export_directory)
setwd("..")
setwd("..")
setwd("./Validierung")

mapply(function(x, y)
  write.csv2(x, paste0(.date(), "_Fanta_Orange_Zero_", y, "_export.csv"), row.names = F, na="")
  , x = Pepsi.Light$export
  , y = paste(Pepsi.Light$location, Pepsi.Light$unit, sep = "_")
)

write.csv2(rev(pred_final$linear + mean(Pepsi.Light$linearitaet_mog$data$Acid - pred_final$linear))
           , paste0(.date(), "_Fanta_Orange_Zero_LG_Linearitaet.csv"), row.names = F, na="")

Pepsi.Light$bias
