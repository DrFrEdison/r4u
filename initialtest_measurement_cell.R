# Main source files ####
dt <- list(); dt$R <- paste0(Sys.getenv("OneDriveCommercial"), "/FE_Methoden/", "Allgemein/R_dt_project/")
source(paste0(dt$R,"R/source_spc_files.R"))

# read .spc and write as .csv
drop_spc(dirname(rstudioapi::getSourceEditorContext()$path), T)
dt$wd <- paste0(wd$Eingangstest[[1]], "Kuevetten/DT0047_Hellma_02000/211202")
setwd(dt$wd)

# Measurement cell parameter
initial.test.mc <- list()
initial.test.mc$maunfacturer <- "Hellma"
initial.test.mc$ID <- "DT0047"
initial.test.mc$ID.Ref <- c("DT0041", "DT0043", "DT0046")
initial.test.mc$pl <- "02000"
initial.test.mc$pl.Ref <- c( 1.994, 1.994, 1.999)
initial.test.mc$type <- c("au", "trans", "ref", "drk")

# rename .csv files
for(i in 1:length(initial.test.mc$type)){
  if(length( dir(pattern = paste0(initial.test.mc$type[i], ".csv"))) > 0) 
    file.rename(dir( pattern = paste0(initial.test.mc$type[i], ".csv"))
                , paste0( substr( dir( pattern = paste0(initial.test.mc$type[i], ".csv") ), 1, 6 ), "_"
                          , initial.test.mc$maunfacturer, "_"
                          , initial.test.mc$ID, "_"
                          , initial.test.mc$pl, "_"
                          , paste0(initial.test.mc$type[i], ".csv")))
}

# read .csv files
if(length( dir(pattern = "au.csv") ) > 0) initial.test.mc$raw$au <- fread(dir(pattern = "au.csv"), sep = ";", dec = ",")
if(length( dir(pattern = "trans.csv") ) > 0) initial.test.mc$raw$trans <- fread(dir(pattern = "trans.csv"), sep = ";", dec = ",")
if(length( dir(pattern = "ref.csv") ) > 0) initial.test.mc$raw$ref <- fread(dir(pattern = "ref.csv"), sep = ";", dec = ",")
if(length( dir(pattern = "drk.csv") ) > 0) initial.test.mc$raw$drk <- fread(dir(pattern = "drk.csv"), sep = ";", dec = ",")

initial.test.mc$tnc <- lapply(initial.test.mc$raw, .transfer_csv.num.col)

# Kurzschluss vergleich ####
initial.test.mc$vergleich.kurzschluss.1$path <- paste0(wd$Eingangstest[[1]], "Kuevetten/DT0013_Starna_02000/Eingangstest")

initial.test.mc$vergleich.kurzschluss.1$raw <-  read_spc_files(directory = initial.test.mc$vergleich.kurzschluss.1$path
                                                               , baseline = NA
                                                               , pngplot = F
                                                               , plotlyplot = F
                                                               , recursive = F
                                                               , filestext = NA
                                                               , colp = NA
                                                               , subfiles = NA)

initial.test.mc$vergleich.kurzschluss.2$path <- paste0(wd$Eingangstest[[1]], "Kuevetten/DT0041_Starna_02000/Eingangstest")

initial.test.mc$vergleich.kurzschluss.2$raw <-  read_spc_files(directory = initial.test.mc$vergleich.kurzschluss.2$path
                                                               , baseline = NA
                                                               , pngplot = F
                                                               , plotlyplot = F
                                                               , recursive = F
                                                               , filestext = NA
                                                               , colp = NA
                                                               , subfiles = NA)

# Kurzschluss Adsorption ####
setwd(dt$wd)
setwd("./Messprotokoll")

initial.test.mc$kurzschluss$au <- initial.test.mc$raw$au[ grep("sorption", initial.test.mc$raw$au$filenamep) , ]
initial.test.mc$kurzschluss$au.vergleich.kurzschluss.1 <- initial.test.mc$vergleich.kurzschluss.1$raw$au$spc
initial.test.mc$kurzschluss$au.vergleich.kurzschluss.2 <- initial.test.mc$vergleich.kurzschluss.2$raw$au$spc

png(paste0(.date(),"_Adsorption_Kurzschluss.png"),xxx<-4800,xxx/16*9,"px",12,"white",res=500,"sans",T,"cairo")
matplot( initial.test.mc$tnc$au$wl
         , t(initial.test.mc$kurzschluss$au[ , initial.test.mc$tnc$au$numcol, with = F])
         , type = "l", lty = 1, col = "red"
         , xlab = .lambda, ylab = "AU", lwd = 2, ylim = c(-.10, .2))
matplot( initial.test.mc$tnc$au$wl
         , do.call(cbind, initial.test.mc$kurzschluss$au.vergleich.kurzschluss.1)
         , type = "l", lty = 1, col = "blue"
         , xlab = .lambda, ylab = "AU", lwd = 2, add = T)
matplot( initial.test.mc$tnc$au$wl
         , do.call(cbind, initial.test.mc$kurzschluss$au.vergleich.kurzschluss.2)
         , type = "l", lty = 1, col = "darkgreen"
         , xlab = .lambda, ylab = "AU", lwd = 2, add = T)

legend("topright", c(initial.test.mc$ID, "DT0013", "DT0041"), lty = 1, col = c("red", "blue", "darkgreen"))
dev.off()

unique(initial.test.mc$kurzschluss$au$Iterations) # Integrationszeit
unique(initial.test.mc$kurzschluss$au$Average) # Mittelungen
nrow(initial.test.mc$kurzschluss$au) # Anzahl Messspektren

# Kurzschluss Transmission ####
setwd(dt$wd)
setwd("./Messprotokoll")

initial.test.mc$kurzschluss$trans <- initial.test.mc$raw$trans[ grep("Transmission", initial.test.mc$raw$trans$filenamep) , ]
initial.test.mc$kurzschluss$trans.vergleich.kurzschluss.1 <- initial.test.mc$vergleich.kurzschluss.1$raw$trans$spc
initial.test.mc$kurzschluss$trans.vergleich.kurzschluss.2 <- initial.test.mc$vergleich.kurzschluss.2$raw$trans$spc

png(paste0(.date(),"_Transmission_Kurzschluss.png"),xxx<-4800,xxx/16*9,"px",12,"white",res=500,"sans",T,"cairo")
matplot( initial.test.mc$tnc$trans$wl
         , t(initial.test.mc$kurzschluss$trans[ , initial.test.mc$tnc$trans$numcol, with = F])
         , type = "l", lty = 1, col = "red"
         , xlab = .lambda, ylab = "AU", lwd = 2)#, ylim = c(65, 95))
matplot( initial.test.mc$tnc$trans$wl
         , do.call(cbind, initial.test.mc$kurzschluss$trans.vergleich.kurzschluss.1)
         , type = "l", lty = 1, col = "blue"
         , xlab = .lambda, ylab = "AU", lwd = 2, add = T)
matplot( initial.test.mc$tnc$trans$wl
         , do.call(cbind, initial.test.mc$kurzschluss$trans.vergleich.kurzschluss.2)
         , type = "l", lty = 1, col = "darkgreen"
         , xlab = .lambda, ylab = "AU", lwd = 2, add = T)

legend("bottomright", c(initial.test.mc$ID, "DT0013", "DT0041"), lty = 1, col = c("red", "blue", "darkgreen"))
dev.off()

unique(initial.test.mc$kurzschluss$trans$Iterations) # Integrationszeit
unique(initial.test.mc$kurzschluss$trans$Average) # Mittelungen
nrow(initial.test.mc$kurzschluss$trans) # Anzahl Messspektren

# Coffein vergleich ####
initial.test.mc$vergleich.coffein.1$path <- paste0(wd$Eingangstest[[1]], "Kuevetten/DT0013_Starna_02000/Koffeinlösung_Testküvette")

initial.test.mc$vergleich.coffein.1$raw <-  read_spc_files(directory = initial.test.mc$vergleich.coffein.1$path
                                                           , baseline = NA
                                                           , pngplot = F
                                                           , plotlyplot = F
                                                           , recursive = F
                                                           , filestext = NA
                                                           , colp = NA
                                                           , subfiles = NA)

initial.test.mc$vergleich.coffein.2$path <- paste0(wd$Eingangstest[[1]], "Kuevetten/DT0041_Starna_02000/Koffeinlösung_Testküvette")

initial.test.mc$vergleich.coffein.2$raw <-  read_spc_files(directory = initial.test.mc$vergleich.coffein.2$path
                                                           , baseline = NA
                                                           , pngplot = F
                                                           , plotlyplot = F
                                                           , recursive = F
                                                           , filestext = NA
                                                           , colp = NA
                                                           , subfiles = NA)

# Coffein Adsorption ####
setwd(dt$wd)
setwd("./Messprotokoll")

initial.test.mc$Coffein$au <- initial.test.mc$raw$au[ grep("offein", initial.test.mc$raw$au$filenamep) , ]
initial.test.mc$Coffein$ID <- initial.test.mc$Coffein$au[ grep(initial.test.mc$ID, initial.test.mc$Coffein$au$filenamep) , ]

initial.test.mc$Coffein$ID.Ref <- lapply(initial.test.mc$ID.Ref, function(x) initial.test.mc$Coffein$a[grep(x, initial.test.mc$Coffein$au$filename) , ])

initial.test.mc$Coffein$au.vergleich.coffein.1 <- initial.test.mc$vergleich.coffein.1$raw$au$spc
initial.test.mc$Coffein$au.vergleich.coffein.2 <- initial.test.mc$vergleich.coffein.2$raw$au$spc

png(paste0(.date(),"_Adsorption_Coffein.png"),xxx<-4800,xxx/16*9,"px",12,"white",res=500,"sans",T,"cairo")
matplot( initial.test.mc$tnc$au$wl
         , t(initial.test.mc$Coffein$ID[ , initial.test.mc$tnc$au$numcol, with = F])
         , type = "l", lty = 1, col = "red"
         , xlab = .lambda, ylab = "AU", lwd = 2, ylim = c(0, 2.5))

matplot( initial.test.mc$tnc$au$wl
         , t(initial.test.mc$Coffein$ID.Ref[[1]][ , initial.test.mc$tnc$au$numcol, with = F])
         , type = "l", lty = 1, col = "orange"
         , xlab = .lambda, ylab = "AU", lwd = 2, add = T)

matplot( initial.test.mc$tnc$au$wl
         , t(initial.test.mc$Coffein$ID.Ref[[2]][ , initial.test.mc$tnc$au$numcol, with = F])
         , type = "l", lty = 1, col = "blue"
         , xlab = .lambda, ylab = "AU", lwd = 2, add = T)

matplot( initial.test.mc$tnc$au$wl
         , t(initial.test.mc$Coffein$ID.Ref[[2]][ , initial.test.mc$tnc$au$numcol, with = F])
         , type = "l", lty = 1, col = "darkgreen"
         , xlab = .lambda, ylab = "AU", lwd = 2, add = T)

legend("topright", c(initial.test.mc$ID, initial.test.mc$ID.Ref), lty = 1, col = c("red", "orange", "blue", "darkgreen"))
dev.off()

initial.test.mc$Coffein$au$ID <- substr(initial.test.mc$Coffein$au$filenamep
                                        , 24
                                        , 29)

initial.test.mc$Coffein$au$ID <- gsub("_", "", initial.test.mc$Coffein$au$ID)
initial.test.mc$Coffein$au$ID <- factor(initial.test.mc$Coffein$au$ID)

tapply(initial.test.mc$Coffein$au$Iterations, initial.test.mc$Coffein$au$ID, unique)
tapply(initial.test.mc$Coffein$au$Average, initial.test.mc$Coffein$au$ID, unique)
tapply(initial.test.mc$Coffein$au$Iterations, initial.test.mc$Coffein$au$ID, length)

# LWLs ####
unique(substr(initial.test.mc$raw$au$filenamep, 8, 14))
unique(substr(initial.test.mc$raw$au$filenamep, 16, 22))
  
# Coffein Peak bei 273 nm ####
initial.test.mc$nm273 <- print( tapply(initial.test.mc$Coffein$au$`273`, initial.test.mc$Coffein$au$ID, mean) )
tapply(initial.test.mc$Coffein$au$`273`, initial.test.mc$Coffein$au$ID, sd)



initial.test.mc$pl.IST <- print( mean(initial.test.mc$nm273[ grep(initial.test.mc$ID, names(initial.test.mc$nm273)) ] / 
                                        unlist(lapply( initial.test.mc$ID.Ref, function( x ) initial.test.mc$nm273[ grep(x, names(initial.test.mc$nm273)) ])) * 
                                        initial.test.mc$pl.Ref))

initial.test.mc$pl.IST - 2
