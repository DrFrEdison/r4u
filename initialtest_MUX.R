input <- list(); input$sourcep <- paste0(Sys.getenv("OneDriveCommercial"), "/FE_Methoden/")
input$linux <- F;source(paste0(input$sourcep,"Allgemein/R_dt_project/R/source_spc_files.R"));input$task <- "read_plot_spc";input$entertain <- F
source(paste0(wd$scripts,"choose_work_horse.R"))

# Eingangstest MUX
mux <- list()
mux$SN <- "SN39844"
mux$date <- "210831"
mux$pos <- paste0("Pos", c(1,2,3,4,5))
mux$wd <- paste0(wd$Eingangstest$MUX, "SN39844/")

mux$baseline = 450
mux$pngplot <- F
mux$plotlyplot <- T
mux$recursive <- F
mux$filestext <- NA
mux$colp <- NA
mux$subfiles <- NA

setwd(mux$wd)
setwd(mux$date)

# Plot MCL Spektren aus dem Skript "FaulhaberValidation(81 653 41)_1x5" ####
setwd("mcl")

mux$mcl <- read_spc_files(directory <- getwd()
                     , baseline = mux$baseline
                     , pngplot = mux$pngplot
                     , plotlyplot = mux$plotlyplot
                     , recursive = mux$recursive
                     , filestext = mux$filestext
                     , colp = mux$colp
                     , subfiles = mux$subfiles)

# Plot Spektren Eingangstest ####
setwd(mux$wd)
setwd(mux$date)
setwd("./spc")

mux$spc <- read_spc_files(directory <- getwd()
                          , baseline = mux$baseline
                          , pngplot = mux$pngplot
                          , plotlyplot = mux$plotlyplot
                          , recursive = mux$recursive
                          , filestext = mux$filestext
                          , colp = mux$colp
                          , subfiles = mux$subfiles)

write_spc_files(mux$spc$au, write = T, filename = paste0(mux$date, "_", mux$SN, "_", "Eingangstest_spc"), return_R = F)
write_spc_files(mux$spc$au, write = T, baseline = T, filename = paste0(mux$date, "_", mux$SN, "_", "Eingangstest_baseline_spc"), return_R = F)
mux$spc <- NULL
mux$spc <- read.csv2(paste0(mux$date, "_", mux$SN, "_", "Eingangstest_spc.csv"))
mux$spc <- .transfer_csv(mux$spc)
mux$spc_bl <- read.csv2(paste0(mux$date, "_", mux$SN, "_", "Eingangstest_baseline_spc.csv"))
mux$spc_bl <- .transfer_csv(mux$spc_bl)

# Wavelength Accuracy ####
mux$wa$lambda <- c(235, 257, 313, 350)
mux$wa$lambdap <- which(mux$spc$wl %in% mux$wa$lambda)

for(i in 1:4){
  mux$wa$pos[[i]] <- grep(mux$pos[i], grep("UV60", mux$spc$data$filenamep, value = T), value = T)
  mux$wa$pos[[i]] <- apply(mux$spc$spc[which(mux$spc$data$filenamep %in% mux$wa$pos[[i]]), mux$wa$lambdap], 2, mean)
}

mux$wa$result <- cbind(MUX = mux$SN, Test = "Wavelength Accuracy", Position = mux$pos[1:4], do.call(rbind, mux$wa$pos))
mux$wa$result <- data.frame(mux$wa$result)

# Stray Light ####
mux$sl$lambda <- c(198)
mux$sl$lambdap <- which(mux$spc$wl %in% mux$sl$lambda)

for(i in 1:4){
  mux$sl$pos[[i]] <- grep(mux$pos[i], grep("UV1", mux$spc$data$filenamep, value = T), value = T)
  mux$sl$pos[[i]] <- mean(mux$spc$spc[which(mux$spc$data$filenamep %in% mux$sl$pos[[i]]), mux$sl$lambdap])
}

mux$sl$result <- cbind(MUX = mux$SN, Test = "Stray Light", Position = mux$pos[1:4], do.call(rbind, mux$sl$pos))
colnames(mux$sl$result)[4] = "X198"
mux$sl$result <- data.frame(mux$sl$result)

# KD 50 Coffein ####
mux$kd50$lambda <- c(273)
mux$kd50$lambdap <- which(mux$spc_bl$wl %in% mux$kd50$lambda)

mux$kd50$coffein_mean <- mean(mux$spc_bl$spc[which(mux$spc$data$filenamep %in% grep("offein", grep("KD50", mux$spc$data$filenamep, value = T), value = T)) , mux$kd50$lambdap])
mux$kd50$coffein_sd <- sd(mux$spc_bl$spc[which(mux$spc$data$filenamep %in% grep("offein", grep("KD50", mux$spc$data$filenamep, value = T), value = T)) , mux$kd50$lambdap])

# MUX Coffein ####
mux$MUX$lambda <- mux$kd50$lambda
mux$MUX$lambdap <- which(mux$spc$wl %in% mux$MUX$lambda)

mux$MUX$coffein_mean <- mean(mux$spc_bl$spc[which(mux$spc$data$filenamep %in% grep("offein", grep(mux$SN, mux$spc$data$filenamep, value = T), value = T)) , mux$MUX$lambdap])
mux$MUX$coffein_sd <- sd(mux$spc_bl$spc[which(mux$spc$data$filenamep %in% grep("offein", grep(mux$SN, mux$spc$data$filenamep, value = T), value = T)) , mux$MUX$lambdap])

# Result Data frame ####
mux$result <- rbind.fill(mux$wa$result, mux$sl$result)
mux$result <- cbind(mux$result, X273 = NA, difference_in_p = NA)

mux$result <- rbind(mux$result
                    , c(mux$SN, "Coffein", mux$pos[5], NA, NA, NA, NA, NA, mux$MUX$coffein_mean, NA) 
                    , c("KD50", "Coffein", NA, NA, NA, NA, NA, NA, mux$kd50$coffein_mean, (mux$MUX$coffein_mean / mux$kd50$coffein_mean - 1) * 100)
)

mux$result[, 4:ncol(mux$result)] <- apply(mux$result[, 4:ncol(mux$result)], 2, function(x) round(as.numeric(x), 4))
write.csv2(mux$result, paste0(mux$date, "_", mux$SN, "_", "photometric_accuracy_straylight_coffein.csv"), row.names = F)
t(mux$result)
t(mux$result)[1:7 , 1:4]
t(mux$result)[4:7 , 1] <= 0.7471+0.005 | t(mux$result)[4:7 , 1] >= 0.7471-0.005
t(mux$result)[4:7 , 2] <= 0.869+0.005 | t(mux$result)[4:7 , 2] >= 0.869-0.005
t(mux$result)[4:7 , 3] <= 0.2924+0.005 | t(mux$result)[4:7 , 3] >= 0.2924-0.005
t(mux$result)[4:7 , 4] <= 0.6448+0.005 | t(mux$result)[4:7 , 4] >= 0.6448-0.005

t(mux$result)[8 , 5:8]
t(mux$result)[8 , 5:8] > 2

rbind(t(mux$result)[1:3 , 9:10], t(mux$result)[9:10 , 9:10])
