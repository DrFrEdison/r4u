### Eingangstest LWL ###
input <- list(); input$sourcep <- paste0(Sys.getenv("OneDriveCommercial"), "/FE_Methoden/")
input$linux <- F;source(paste0(input$sourcep,"Allgemein/R_dt_project/R/source_spc_files.R"));input$task <- "read_plot_spc";input$entertain <- F
source(paste0(input$sourcep,"Allgemein/R_dt_project/R/source_read.R"))
# LWL Eingangstest ####
input$wd <- wd$Eingangstest$LWL
setwd(input$wd)
lwl <- list()

lwl$length <- "100" # Länge des LWLs in cm
lwl$date[[1]] <- "220117"
lwl$ID[[1]] <- "TZ06490"

# Export spc as csv ####
input$baseline = NA
input$pngplot <- F
input$plotlyplot <- F

input$recursive <- T
input$filestext <- NA
input$colp <- NA
input$subfiles <- NA

setwd(input$wd)
setwd(paste0(".///", lwl$length, "cm"))
setwd(paste0(".///", lwl$ID))
setwd(paste0(".///", lwl$date))
setwd(paste0("./Absorption_Transmission_H2O"))

lwl$raw <-  read_spc_files(getwd(),input$baseline,
                           input$pngplot,input$plotlyplot,input$recursive,input$filestext, input$colp, input$subfiles)
write_spc_files(lwl$raw$trans, write = T, filename = lwl$csv <- paste(lwl$date, lwl$ID, paste0(lwl$length, "cm"), sep = "_"), return_R = F)

# read csv ####
lwl$spc[[1]] <- read.csv2(paste0(lwl$csv, ".csv"))

# Import previous tests ####
setwd(input$wd)
setwd(paste0(".///", lwl$length, "cm"))
dir()
lwl$ID[[2]] <- "TZ06490"
setwd(paste0(".///", lwl$ID))

dir()
lwl$date[[2]] <- "200914"
setwd(paste0(".///", lwl$date[[2]]))

lwl$raw <-  read_spc_files(getwd(),input$baseline,
                           input$pngplot,input$plotlyplot,input$recursive,input$filestext, input$colp, input$subfiles)
write_spc_files(lwl$raw$trans, write = T, filename = lwl$csv <- paste(lwl$date[[2]], lwl$ID[[2]], paste0(lwl$length, "cm"), sep = "_"), return_R = F)
lwl$spc[[2]] <-  read.csv2(paste0(lwl$csv, ".csv"))

# Import other LWL's for the sake of comparison ####
# NR 1
setwd(input$wd)
setwd(paste0(".///", lwl$length, "cm"))
dir()
lwl$ID[[3]] <- "TZ07041"
setwd(paste0(".///", lwl$ID[[3]]))

dir()
lwl$date[[3]] <- "210823"
setwd(paste0(".///", lwl$date[[3]]))
setwd(paste0("./Absorption_Transmission_H2O"))

dir()
lwl$raw <-  read_spc_files(getwd(),input$baseline,
                           input$pngplot,input$plotlyplot,input$recursive,input$filestext, input$colp, input$subfiles)
write_spc_files(lwl$raw$trans, write = T, filename = lwl$csv <- paste(lwl$date[[3]], lwl$ID[[3]], paste0(lwl$length, "cm"), sep = "_"), return_R = F)
lwl$spc[[3]] <-  read.csv2(paste0(lwl$csv, ".csv"))

# NR 2
setwd(input$wd)
setwd(paste0(".///", lwl$length, "cm"))
dir()
lwl$ID[[4]] <- "TZ07040"
setwd(paste0(".///", lwl$ID[[4]]))

dir()
lwl$date[[4]] <- "210823"
setwd(paste0(".///", lwl$date[[4]]))
setwd(paste0("./Absorption_Transmission_H2O"))

dir()
lwl$raw <-  read_spc_files(getwd(),input$baseline,
                           input$pngplot,input$plotlyplot,input$recursive,input$filestext, input$colp, input$subfiles)
write_spc_files(lwl$raw$trans, write = T, filename = lwl$csv <- paste(lwl$date[[4]], lwl$ID[[4]], paste0(lwl$length, "cm"), sep = "_"), return_R = F)
lwl$spc[[4]] <-  read.csv2(paste0(lwl$csv, ".csv"))

# merge lwl ####
lwl$spc <- mapply(function(x, y, z) cbind(Date = x, ID = y, DateID = paste(x, y, sep = "_"), z)
                  , x = lwl$date
                  , y = lwl$ID
                  , z = lwl$spc
                  , SIMPLIFY = F)

lwl$trans <- do.call(rbind.fill, lwl$spc)
lwl$trans <- lwl$trans[ , - which(as.numeric(gsub("X", "", colnames(lwl$trans))) < 190 | as.numeric(gsub("X", "", colnames(lwl$trans))) > 598)]

lwl$trans <- .transfer_csv(lwl$trans)
lwl$trans$data$DateID <- factor(lwl$trans$data$DateID)

lwl$trans$data$DateID <- relevel(lwl$trans$data$DateID, unique(lwl$spc[[1]]$DateID))

# Statistic of LWL ####
lwl$stat$x200 <- round( median( lwl$spc[[1]][ , grep(200, colnames(lwl$spc[[1]]))] ) )
lwl$stat$x500 <- round( median( lwl$spc[[1]][ , grep(500, colnames(lwl$spc[[1]]))] ) )
lwl$stat$Iterations <- unique(lwl$spc[[1]]$Iterations)
lwl$stat$Average <- unique(lwl$spc[[1]]$Average)
lwl$stat$nrow <- nrow(lwl$spc[[1]])

# Transmissionsplot ####
setwd(input$wd)
setwd(paste0(".///", lwl$length, "cm"))
setwd(paste0(".///", lwl$ID))
setwd(paste0(".///", lwl$date))
setwd(paste0("./Messprotokoll"))

png(paste0("Transmission_", lwl$date[[1]], "_", lwl$ID[[1]], ".png")
    , width = 480 * 5 * 1.25, height = 480 * 4
    , type="cairo", units="px", pointsize=12, res=500)
par(mar = c(8,4,.5, .5))

lwl$par$col <- .colp[1:length(lwl$spc)]
lwl$par$lwd <- rep(1, nrow(lwl$trans$spc))
lwl$par$lwd[ grep(paste(lwl$date[[1]], lwl$ID[[1]], sep = "_"), lwl$trans$data$DateID)  ] <- 2

lwl$par$font <- rep(1, length(levels(lwl$trans$data$DateID)))
lwl$par$font[ grep(paste(lwl$date[[1]], lwl$ID[[1]], sep = "_"), levels(lwl$trans$data$DateID))  ] <- 2

matplot(lwl$trans$wl
        , t(lwl$trans$spc)
        , lty = 1, type = "l"
        , xlab = "", ylab = "Transmission in %"
        , col = lwl$par$col[lwl$trans$data$DateID]
        , lwd = lwl$par$lwd)

mtext(expression(paste(lambda,  " in nm")), 1, line = 2)

legend(par("usr")[1], par("usr")[3] - diff(par("usr")[3:4] * .3)
       , levels(lwl$trans$data$DateID)
       , col = lwl$par$col, text.font = lwl$par$font, lty = 1, lwd = c(2, 2, 2, 2), xpd = T, bty = "n", cex = .75)

legend(par("usr")[1] + diff(par("usr")[1:2]) * .6, par("usr")[3] - diff(par("usr")[3:4] * .3)
       , c(paste("Integrationszeit =", lwl$stat$Iterations, "ms")
           , paste("Mittelungen =", lwl$stat$Average)
           , paste("Anzahl der Messspektren =", lwl$stat$nrow)
           , paste("Transmission bei 200nm =", lwl$stat$x200, "%")
           , paste("Transmission bei 500nm =", lwl$stat$x500, "%"))
       , xpd = T, bty = "n", cex = .75)

dev.off()
