#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#
###                         ###
###  ######       ########  ###
###  ##    ##     ########  ###
###  ##     ##       ##     ###
###  ##     ##       ##     ###
###  ##     ##       ##     ###
###  ##     ##       ##     ###
###  ##    ##        ##     ###
###  ######          ##     ###
###                         ###
#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#
###                         ###
### By Markus Kurtz         ###
### For Dausch Technologies ###
### 2022                    ###
###                         ###
#.#.#.#.#.#.#.#.#.#.#.#.#.#.#.#
###
###
### Script checks validity of model validation spectra
###
### Version 02
### Date = 2022-04-05
###
### required functions and packages are loaded from source_read.R and source_pls.R

# load all required functions and packages ####
dt <- list(); dt$R <- paste0(Sys.getenv("OneDriveCommercial"), "/FE_Methoden/", "Allgemein/R_dt_project/")
source(paste0(dt$R,"R/source_read.R"))
source(paste0(dt$R,"R/source_pls.R"))

# set working directory ####
setwd(dt$wd <- paste0(wd$fe$CCEP$Mastermodelle, "Monster_Energy_Ultra/Modellvalidierung/Produktionsdaten"))

# list and read files ####
beverage <- list()
beverage$para$location <- "Karlsruhe"
beverage$para$line <- "BCANKD"
beverage$para$beverage <- "Monster_Energy_Ultra"
beverage$para$main <- paste(beverage$para$location, beverage$para$line, beverage$para$beverage, sep = "_")

# List files
beverage$files$ref <- grep("ref", dir(pattern = "ref.csv$"), value = T) # Background spc 
beverage$files$drk <- grep("drk", dir(pattern = "drk.csv$"), value = T) # Dark spc
beverage$files$spc <- grep("spc", dir(pattern = "spc.csv$"), value = T) # Production spc

# get file info
beverage$txt <- lapply(beverage$files, .txt.file)

# read files
beverage$raw$ref <- fread(beverage$files$ref, dec = ",", sep = ";")  # Background spc 
beverage$raw$drk <- fread(beverage$files$drk, dec = ",", sep = ";")  # Dark spc
beverage$raw$spc <- fread(beverage$files$spc, dec = ",", sep = ";")  # Production spc

# read wavelength columns
beverage$para$trs <- lapply(beverage$raw, .transfer_csv.num.col)

# Service Berichte ####
beverage$service <- data.frame(date1 = c("2021-04-15") 
                            , date2 = c("2021-04-22")
                           , reason = c("Shutter"))

if(nrow(beverage$service)>0) for(i in 1:nrow(beverage$service)) beverage$raw$spc <- beverage$raw$spc[beverage$raw$spc$date < beverage$service$date1[i] | beverage$raw$spc$date > beverage$service$date2[i]]  

# Validate References ####
beverage$pca.para$ref$ncomp <- 2
beverage$pca.para$ref$limitvalue <- 1
beverage$pca$ref <- pca(beverage$raw$ref[ , beverage$para$trs$ref$numcol, with = F], ncomp = beverage$pca.para$ref$ncomp)
beverage$val$ref <- spectra.validation.pca.spc(beverage$pca$ref, limitvalue = beverage$pca.para$ref$limitvalue, ncomp = beverage$pca.para$ref$ncomp)
beverage$val$ref <- .pca.plot(beverage$pca$ref, limitvalue = beverage$pca.para$ref$limitvalue, ncomp = beverage$pca.para$ref$ncomp)
beverage$val.c$ref <- spectra.validation.range(valid.vector = beverage$val$ref$val
                                               , drkref.datetime = beverage$raw$ref$datetime
                                               , spc.datetime = beverage$raw$spc$datetime
                                               , pattern = c("empty", "critical", "invalid"))

# remove invaldid spc between invalid ref ####
beverage$raw$spc <- beverage$raw$spc[beverage$val.c$ref]

# plot invalid ref ####
png(paste0(.date(), "_", beverage$para$main, "validation_ref.png"),xxx<-4800,xxx/16*9,"px",12,"white",res=500,"sans",T,"cairo")

matplot(beverage$para$trs$ref$wl
        , t(beverage$raw$ref[ , beverage$para$trs$ref$numcol, with = F])
        , type = "l", lty = 1 
        , xlab = .lambda, ylab = "Counts"
        , col = beverage$val$ref$colp, main = paste0("Dark spektra in ", beverage$txt$ref$loc.line, "\nduring ", beverage$para$beverage, " production"))

legend("topright", as.character(levels(beverage$val$ref))[1:3], col = c("darkgreen", "orange", "red"), lty = 1, lwd = 1.5)
dev.off()

# Validate Dark spectra ####
beverage$pca.para$drk$ncomp <- 2
beverage$pca.para$drk$limitvalue <- 1
beverage$pca$drk <- pca(beverage$raw$drk[ , beverage$para$trs$drk$numcol, with = F], ncomp = beverage$pca.para$drk$ncomp)
beverage$val$drk <- spectra.validation.pca.spc(beverage$pca$drk, limitvalue = beverage$pca.para$drk$limitvalue, ncomp = beverage$pca.para$drk$ncomp)
beverage$val$drk <- .pca.plot(beverage$pca$drk, limitvalue = beverage$pca.para$drk$limitvalue, ncomp = beverage$pca.para$drk$ncomp)
beverage$val.c$drk <- spectra.validation.range(valid.vector = beverage$val$drk$val
                                               , drkref.datetime = beverage$raw$drk$datetime
                                               , spc.datetime = beverage$raw$spc$datetime
                                               , pattern = c("empty", "critical", "invalid"))

# remove invaldid spc between invalid drk ####
beverage$raw$spc <- beverage$raw$spc[beverage$val.c$drk]

png(paste0(.date(), "_", beverage$para$main, "validation_drk.png"),xxx<-4800,xxx/16*9,"px",12,"white",res=500,"sans",T,"cairo")

matplot(beverage$para$trs$drk$wl
        , t(beverage$raw$drk[ , beverage$para$trs$drk$numcol, with = F])
        , type = "l", lty = 1 
        , xlab = .lambda, ylab = "Counts"
        , col = beverage$val$drk$colp, main = paste0("Dark spektra in ", beverage$txt$drk$loc.line, "\nduring ", beverage$para$beverage, " production"))

legend("topright", as.character(levels(beverage$val$drk))[1:3], col = c("darkgreen", "orange", "red"), lty = 1, lwd = 1.5)
dev.off()

# Validate production spectra ####
beverage$pca.para$spc$ncomp <- 2
beverage$pca.para$spc$ncomp.val <- 1
beverage$pca.para$spc$alpha <- .3
beverage$pca.para$spc$gamma <- .5
beverage$pca.para$spc$alphagamma <- "alpha"
beverage$pca.para$spc$alphagamma.choose <- ifelse(beverage$pca.para$spc$alphagamma == "alpha", 1, 2)

beverage$pca$spc <- mdatools::pca(beverage$raw$spc[ , beverage$para$trs$spc$numcol, with = F]
                                  , ncomp = beverage$pca.para$spc$ncomp
                                  , gamma = beverage$pca.para$spc$gamma
                                  , alpha = beverage$pca.para$spc$alpha)
beverage$pca.para$spc$val <- .pca.plot(beverage$pca$spc, beverage$pca.para$spc$alphagamma.choose, beverage$pca.para$spc$ncomp.val)

png(paste0(.date(), "_", beverage$para$main, "validation_spc_pca.png"),xxx<-4800,xxx/16*9,"px",12,"white",res=500,"sans",T,"cairo")

plot(beverage$pca$spc$calres$T2[ , beverage$pca.para$spc$ncomp.val]
       , beverage$pca$spc$calres$Q[ , beverage$pca.para$spc$ncomp.val]
       , main = paste0(beverage$para$beverage, " production spectra validation\nin ", beverage$txt$drk$loc.line[i])
       , xlab = paste0("Hotelling's T2. PC", beverage$pca.para$spc$ncomp.val)
       , ylab = paste0("Q Residuals PC", beverage$pca.para$spc$ncomp.val)
       , col = beverage$pca.para$spc$val$colp
       , xlim = beverage$pca.para$spc$val$xlimp
       , ylim = beverage$pca.para$spc$val$ylimp)
  
  abline(v = beverage$pca$spc$T2lim[ beverage$pca.para$spc$alphagamma.choose , beverage$pca.para$spc$ncomp.val]
         , h = beverage$pca$spc$Qlim[ beverage$pca.para$spc$alphagamma.choose , beverage$pca.para$spc$ncomp.val], lty = 2)
  
  legend(.parusr("topleft", xx = .1)[[1]], .parusr("topleft", yy = .25)[[2]]
         , as.character(levels(beverage$pca.para$spc$val$val))
         , xpd = T, bty = "n", pch = 1
         , col = c("darkgreen", "orange", "red"))

dev.off()

png(paste0(.date(), "_", beverage$para$main, "validation_spc.png"),xxx<-4800,xxx/16*9,"px",12,"white",res=500,"sans",T,"cairo")

matplot(beverage$para$trs$spc$wl
        , t(beverage$raw$spc[ , beverage$para$trs$spc$numcol, with = F])
        , type = "l", lty = 1, xlab = .lambda, ylab = "AU"
        , main = paste0(beverage$para$beverage, " production spectra \nin ", beverage$txt$drk$loc.line)
        , col = beverage$pca.para$spc$val$colp)

legend("topright"
       , as.character(levels(beverage$pca.para$spc$val$val))
       , xpd = T, bty = "n", lty = 1
       , col = c("darkgreen", "orange", "red"))

dev.off()

# remove invalid spectra ####
beverage$raw$spc <- beverage$raw$spc[which(beverage$pca.para$spc$val$val == "valid")]

png(paste0(.date(), "_", beverage$para$main, "validation_spc_clean.png"),xxx<-4800,xxx/16*9,"px",12,"white",res=500,"sans",T,"cairo")
  matplot(beverage$para$trs$spc$wl
          , t(beverage$raw$spc[ , beverage$para$trs$spc$numcol, with = F])
          , type = "l", lty = 1, xlab = .lambda, ylab = "AU"
          , main = paste0("Validated ", beverage$para$beverage, " production spectra \nin ", beverage$txt$drk$loc.line[i]))
dev.off()


# export valid spc ####
setwd(dt$wd)
fwrite(beverage$raw$spc, gsub(".csv", "_validated.csv", beverage$files$spc), dec = ",", sep = ";")





