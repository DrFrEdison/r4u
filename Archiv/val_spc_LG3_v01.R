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
### Version 01
### Date = 2022-03-25
###
### required functions and packages are loaded from source_read.R and source_pls.R

# load all required functions and packages ####
dt <- list(); dt$R <- paste0(Sys.getenv("OneDriveCommercial"), "/FE_Methoden/", "Allgemein/R_dt_project/")
source(paste0(dt$R,"R/source_read.R"))
source(paste0(dt$R,"R/source_pls.R"))

# set working directory ####
setwd(dt$wd <- paste0(wd$fe$CCEP$Mastermodelle, "Fanta_Orange_Zero/Modellvalidierung/Produktionsdaten"))

# list and read files ####
beverage <- list()
beverage$para$location <- "Moenchengladbach"
beverage$para$line <- "G9"
beverage$para$beverage <- "Fanta_Zero"
beverage$para$main <- paste(beverage$para$location, beverage$para$line, beverage$para$beverage, sep = "_")

# List files
beverage$files$ref <- grep("ref", dir(pattern = ".csv$")[grep(beverage$para$main, dir())], value = T) # Background spc 
beverage$files$drk <- grep("rk", dir(pattern = ".csv$")[grep(beverage$para$main, dir())], value = T) # Dark spc
beverage$files$spc <- grep("spc", dir(pattern = ".csv$")[grep(beverage$para$main, dir())], value = T) # Production spc

# get file info
beverage$txt <- lapply(beverage$files, .txt.file)

# read files
beverage$raw$ref <- lapply(beverage$files$ref, function(x) fread(x, dec = ",", sep = ";")) # Background spc 
beverage$raw$drk <- lapply(beverage$files$drk, function(x) fread(x, dec = ",", sep = ";")) # Dark spc
beverage$raw$spc <- lapply(beverage$files$spc, function(x) fread(x, dec = ",", sep = ";")) # Production spc

# set names
names(beverage$raw$ref) <- beverage$txt$ref$loc.line
names(beverage$raw$drk) <- beverage$txt$drk$loc.line
names(beverage$raw$spc) <- beverage$txt$spc$loc.line

# read wavelength columns
beverage$ppp <- lapply(beverage$raw, function(x) lapply(x, .transfer_csv.num.col))

# Service Berichte ####
beverage$service <- data.frame(date1 = c("2021-01-01", "2021-07-15")
                           , date2 = c("2021-02-15", "2021-10-14")
                           , reason = c("Fluss_Druck_Problem", "Produktnahmeventil defekt"))
for(i in 1:nrow(beverage$service)){
  beverage$raw$spc$Moenchengladbach_G9 <- beverage$raw$spc$Moenchengladbach_G9[beverage$raw$spc$Moenchengladbach_G9$date < beverage$service$date1[i] | beverage$raw$spc$Moenchengladbach_G9$date > beverage$service$date2[i]]  
}

# Validate References ####
# 2nd derivative for ref #
beverage$trs$ref <- lapply(beverage$raw$ref, .transfer_csv)

# validation algorithm
beverage$val$ref <- lapply(beverage$trs$ref, \(location) apply(location$spc2nd, 1, \(x) spectra.validation.ref.LG3(spc = x)))

# set colors
beverage$val.col$ref <- lapply(beverage$val$ref, spectra.validation.col)

png(paste0(.date(), "_", beverage$para$main, "validation_ref.png"),xxx<-4800,xxx/16*9,"px",12,"white",res=500,"sans",T,"cairo")
for(i in 1:length(beverage$trs$ref))
  
  matplot(beverage$trs$ref[[i]]$wl
          , t(beverage$trs$ref[[i]]$spc)
          , type = "l", lty = 1, xlab = .lambda, ylab = "Counts"
          , col = beverage$val.col$ref[[i]], main = paste0("Background spektra in ", beverage$txt$drk$loc.line[i], "\nduring ", beverage$para$beverage, " production"))

legend("topright", as.character(levels(beverage$val$ref[[i]]))[1:3], col = c("darkgreen", "orange", "red"), lty = 1, lwd = 1.5)
dev.off()

# Validate Dark spectra ####
# validation algorithm
beverage$val$drk <- mapply(\(spc, col) apply(spc[ , col$numcol, with = F], 1, \(x) spectra.validation.drk(spc = x))
                       , spc = beverage$raw$drk
                       , col = beverage$ppp$drk
                       , SIMPLIFY = F)
# set colors
beverage$val.col$drk <- lapply(beverage$val$drk, spectra.validation.col)

png(paste0(.date(), "_", beverage$para$main, "validation_drk.png"),xxx<-4800,xxx/16*9,"px",12,"white",res=500,"sans",T,"cairo")
for(i in 1:length(beverage$raw$drk))
  
  matplot(beverage$ppp$drk[[i]]$wl
          , t(beverage$raw$drk[[i]][ , beverage$ppp$drk[[i]]$numcol, with = F])
          , type = "l", lty = 1, xlab = .lambda, ylab = "Counts"
          , col = beverage$val.col$drk[[i]], main = paste0("Dark spektra in ", beverage$txt$drk$loc.line[i], "\nduring ", beverage$para$beverage, " production"))

legend("topright", as.character(levels(beverage$val$drk[[i]]))[1:3], col = c("darkgreen", "orange", "red"), lty = 1, lwd = 1.5)
dev.off()

# get range of bad ref and drk ####
beverage$val.range$ref <- mapply(\(val.vector, ref.date, spc.date) spectra.validation.range(valid.vector = val.vector 
                                                                                        , drkref.datetime = ref.date$data$datetime
                                                                                        , spc.datetime = spc.date$datetime
                                                                                        , pattern = "invalid")
                             , val.vector = beverage$val$ref # validation vector
                             , ref.date = beverage$trs$ref # datetime vector of background spectra
                             , spc.date = beverage$raw$spc
                             , SIMPLIFY = F) #  datetime vector of production spectra

beverage$val.range$drk <- mapply(\(val.vector, drk.date, spc.date) spectra.validation.range(valid.vector = val.vector
                                                                                        , drkref.datetime = drk.date$datetime
                                                                                        , spc.datetime = spc.date$datetime
                                                                                        , pattern = "invalid")
                             , val.vector = beverage$val$drk # validation vector
                             , drk.date = beverage$raw$drk # datetime vector of dark spectra
                             , spc.date = beverage$raw$spc
                             , SIMPLIFY = F) #  datetime vector of production spectra

# merge and unify validation vectors
beverage$val.range$drkref <- mapply(\(x,y) sort(unique(c(x,y)))
                                , x = beverage$val.range$ref
                                , y = beverage$val.range$drk
                                , SIMPLIFY = F)

beverage$val.range$drkref <- mapply(function(x,y) !(1:nrow(y)) %in% x
                                , x = beverage$val.range$drkref
                                , y = beverage$raw$spc
                                , SIMPLIFY = F)

# remove spectra after invalid references and dark spectra ####
for(i in 1:length(beverage$raw$spc)) beverage$raw$spc[[i]] <- beverage$raw$spc[[i]][beverage$val.range$drkref[[i]]]

# Validate production spectra ####
beverage$pca.para$spc.para$ncomp <- 2
beverage$pca.para$spc.para$ncomp.val <- 1
beverage$pca.para$spc.para$alpha <- .3
beverage$pca.para$spc.para$gamma <- .5
beverage$pca.para$spc.para$alphagamma <- "alpha"
beverage$pca.para$spc.para$alphagamma.choose <- ifelse(beverage$pca.para$spc.para$alphagamma == "alpha", 1, 2)

beverage$pca$spc <- mapply(function(x , y) mdatools::pca(x[ , y$numcol, with = F]
                                                     , ncomp = beverage$pca.para$spc.para$ncomp
                                                     , gamma = beverage$pca.para$spc.para$gamma
                                                     , alpha = beverage$pca.para$spc.para$alpha)
                       , x = beverage$raw$spc
                       , y = beverage$ppp$spc
                       , SIMPLIFY = F)
beverage$pca.para$spc <- lapply(beverage$pca$spc, function(x) .pca.plot(x, beverage$pca.para$spc.para$alphagamma.choose, beverage$pca.para$spc.para$ncomp.val))

png(paste0(.date(), "_", beverage$para$main, "validation_spc_pca.png"),xxx<-4800,xxx/16*9,"px",12,"white",res=500,"sans",T,"cairo")

for(i in 1:length(beverage$raw$spc)){
  plot(beverage$pca$spc[[i]]$calres$T2[ , beverage$pca.para$spc.para$ncomp.val]
       , beverage$pca$spc[[i]]$calres$Q[ , beverage$pca.para$spc.para$ncomp.val]
       , main = paste0(beverage$para$beverage, " production spectra validation\nin ", beverage$txt$drk$loc.line[i])
       , xlab = paste0("Hotelling's T2. PC", beverage$pca.para$spc.para$ncomp.val)
       , ylab = paste0("Q Residuals PC", beverage$pca.para$spc.para$ncomp.val)
       , col = beverage$pca.para$spc[[i]]$colp
       , xlim = beverage$pca.para$spc[[i]]$xlimp
       , ylim = beverage$pca.para$spc[[i]]$ylimp)
  
  abline(v = beverage$pca$spc[[i]]$T2lim[ beverage$pca.para$spc.para$alphagamma.choose , beverage$pca.para$spc.para$ncomp.val]
         , h = beverage$pca$spc[[i]]$Qlim[ beverage$pca.para$spc.para$alphagamma.choose , beverage$pca.para$spc.para$ncomp.val], lty = 2)
  
  legend(.parusr("topleft", xx = .1)[[1]], .parusr("topleft", yy = .25)[[2]]
         , as.character(levels(beverage$pca.para$spc[[i]]$val))
         , xpd = T, bty = "n", pch = 1
         , col = c("darkgreen", "orange", "red"))
}
dev.off()

png(paste0(.date(), "_", beverage$para$main, "validation_spc.png"),xxx<-4800,xxx/16*9,"px",12,"white",res=500,"sans",T,"cairo")
for(i in 1:length(beverage$raw$spc)){
  
matplot(beverage$ppp$spc[[i]]$wl
        , t(beverage$raw$spc[[i]][ , beverage$ppp$spc[[i]]$numcol, with = F])
        , type = "l", lty = 1, xlab = .lambda, ylab = "AU"
        , main = paste0(beverage$para$beverage, " production spectra \nin ", beverage$txt$drk$loc.line[i])
        , col = beverage$pca.para$spc[[i]]$colp)

legend("topright"
       , as.character(levels(beverage$pca.para$spc[[i]]$val))
       , xpd = T, bty = "n", lty = 1
       , col = c("darkgreen", "orange", "red"))
}
dev.off()

# remove invalid spectra ####
for(i in 1:length(beverage$raw$spc)) beverage$raw$spc[[i]] <- beverage$raw$spc[[i]][which(beverage$pca.para$spc[[i]]$val == "valid")]

png(paste0(.date(), "_", beverage$para$main, "validation_spc_clean.png"),xxx<-4800,xxx/16*9,"px",12,"white",res=500,"sans",T,"cairo")
for(i in 1:length(beverage$raw$spc)){
  
  matplot(beverage$ppp$spc[[i]]$wl
          , t(beverage$raw$spc[[i]][ , beverage$ppp$spc[[i]]$numcol, with = F])
          , type = "l", lty = 1, xlab = .lambda, ylab = "AU"
          , main = paste0("Validated ", beverage$para$beverage, " production spectra \nin ", beverage$txt$drk$loc.line[i]))
}
dev.off()


setwd(dt$wd)

paste0(beverage$files$spc)
for(i in 1:length(beverage$raw$spc)){
  fwrite(beverage$raw$spc[[i]], gsub(".csv", "_validated.csv", beverage$files$spc), dec = ",", sep = ";")
}





