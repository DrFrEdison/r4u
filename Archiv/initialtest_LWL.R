input <- list(); input$sourcep <- paste0(Sys.getenv("OneDriveCommercial"), "/FE_Methoden/")
input$linux <- F;source(paste0(input$sourcep,"Allgemein/R_dt_project/R/source_spc_files.R"));input$task <- "read_plot_spc";input$entertain <- F

# LWL Eingangstest ####
input$wd <- wd$Eingangstest$LWL
setwd(input$wd)

# wo sind die Daten abgelegt ####
input$wd <- "H:/Eingangstest"

# Laenge der LWL's == Ordnername
input$path <- c(33, 100, 150)

# Datum des Tests == Ordnername ####
input$date <- "210823"
i = 1
lwl <- list()

# Erstelle Ordner fuer jeden LWL und verteile die Spektren in die Ordner ####
for(i in 1:3){
  setwd(input$wd)
  setwd(paste0(".///", input$path[i], "cm"))
  
  lwl$files <- unique(substr(dir(), 24, 30))
  
  lwl$ref <- dir(pattern = "_r0")
  lwl$dark <- dir(pattern = "_d0")
  
  lwl$files <- lwl$files[which(!is.na(as.numeric(substr(lwl$files, nchar(lwl$files), nchar(lwl$files)))))]
  
  lapply(lwl$files, dir.create)
  list.dirs(recursive = F)[-1]
  for(k in 1:length(list.dirs(recursive = F)[-1])){
    setwd(input$wd)
    setwd(paste0(".///", input$path[i], "cm"))
    setwd(paste0(".///", list.dirs(recursive = F)[-1][k]))
    dir.create(input$date)
    setwd(paste0(".///", input$date))
    dir.create("Messprotokoll")
    dir.create("Absorption_Transmission_H2O")
    dir.create("Bilddateien")
  }
  
  for(j in 1:length(lwl$files)){
    
    fromp <- grep(lwl$files[j], grep("_c01_", dir( pattern = ".spc"), value = T), value = T)
    top <- paste0(lwl$files[j]
                  , "/210823/Absorption_Transmission_H2O/"
                  , fromp
    )
    
    file.copy(fromp, top)
    unlink(fromp)
    
    fromp <- grep("_d01_", dir( pattern = ".spc"), value = T)
    top <- paste0(lwl$files[j]
                  , "/210823/Absorption_Transmission_H2O/"
                  , fromp
    )
    
    file.copy(fromp, top)
    unlink(fromp)
    
    fromp <- grep("_r01_", dir( pattern = ".spc"), value = T)
    top <- paste0(lwl$files[j]
                  , "/210823/Absorption_Transmission_H2O/"
                  , fromp
    )
    
    file.copy(fromp, top)
    unlink(fromp)
  }
  
  
}

# Bilder der LWL ####
input$pictures <- input$wd

lwl$pictures <- dir(input$pictures)
lwl$pictures <- grep(".jpg", lwl$pictures, value = T)

setwd(input$wd)
input$dirs <- list.dirs(recursive = T, full.names = T)

# Verteile Bilder in die entsprechenden Ordner ####
for(i in 1:length(lwl$pictures)){
  input$todir <- input$dirs[which(unlist(gregexpr(substr(lwl$pictures[i], 1, 7), input$dirs)) > 0)]
  input$todir <- grep("Bilddateien", input$todir, value = T)
  
  setwd(input$pictures)
  file.copy(lwl$pictures[i]
            , gsub("\\//./", "/", paste0(input$wd, input$todir, "/", lwl$pictures[i]))
  )
}

# Erstelle Abbildung der Transmission ####
# plot / read parameter ####
input$baseline = NA
input$pngplot <- F
input$plotlyplot <- F

input$recursive <- T
input$filestext <- NA
input$colp <- NA
input$subfiles <- NA

for(i in 1:length(input$path)){
  
  setwd(input$wd)
  setwd(paste0(".///", input$path[i], "cm"))
  
  lwl$raw <-  read_spc_files(getwd(),input$baseline,
                             input$pngplot,input$plotlyplot,input$recursive,input$filestext, input$colp, input$subfiles)
  write_spc_files(lwl$raw$trans, write = T, filename = paste0("210825_LWL_", input$path[i], "cm"), return_R = F)
  
  lwl$raw <- read.csv2(dir(pattern = paste0(input$path[i], "cm.csv")))
  lwl$trans <- .transfer_csv(lwl$raw)
  
  
  lwl$files <- substr(list.dirs(, recursive = F), 3, nchar(list.dirs(, recursive = F)))
  
  for(j in 1:length(lwl$files)){
    
    setwd(input$wd)
    setwd(paste0(".///", input$path[i], "cm"))
    
    setwd(list.dirs(recursive = F)[grep(lwl$files[j], list.dirs(recursive = F))])
    setwd(paste0("./", input$date))
    setwd("./Messprotokoll")
    
    png(paste0("Transmission_", lwl$files[j], ".png")
        , width = 480 * 5 * 1.25, height = 480 * 4
        , type="cairo", units="px", pointsize=12, res=500)
    par(mar = c(6,4,.5, .5))
    lwl$colp <- rep("blue", length(lwl$trans$data$filenamep))
    lwl$colp[grep(lwl$files[j], lwl$trans$data$filenamep)] <- "red"
    lwl$lwd <- rep(1, length(lwl$trans$data$filenamep))
    lwl$lwd[grep(lwl$files[j], lwl$trans$data$filenamep)] <- 2
    
    matplot(lwl$trans$wl
            , t(lwl$trans$spc)
            , lty = 1, type = "l"
            , xlab = "", ylab = "Transmission in %"
            , col = lwl$colp
            , lwd = lwl$lwd)
    
    mtext("lambda in nm", 1, line = 2)
    
    legend(par("usr")[1], par("usr")[3] - diff(par("usr")[3:4] * .2)
           , c(lwl$files[j]
               , paste("Transmission bei 200nm =", round(median(t(lwl$trans$spc)[grep(200, row.names(t(lwl$trans$spc))) , grep(lwl$files[j], lwl$trans$data$filenamep)]), 1), "%")
               , paste("Transmission bei 500nm =", round(median(t(lwl$trans$spc)[grep(500, row.names(t(lwl$trans$spc))) , grep(lwl$files[j], lwl$trans$data$filenamep)]), 1), "%")
               , "andere LWL mit gleicher Laenge")
           , col = c("red", "red", "red", "blue"), lty = c(1,NA,NA,1), lwd = c(2, NA, NA, 1), xpd = T, bty = "n", cex = .75)
    
    
    legend("bottomright"
           , c(paste("Integrationszeit =", unique(lwl$trans$data[grep(lwl$files[j], lwl$trans$data$filenamep), "Iterations"]))
             , paste("Mittelungen =", unique(lwl$trans$data[grep(lwl$files[j], lwl$trans$data$filenamep), "Average"]))
             , paste("Anzahl der Messspektren =", length(grep(lwl$files[j], lwl$trans$data$filenamep))))
    )
           
    dev.off()
  }
}

# Erstelle Musterworddatei und kopiere Worddateien in die Einzelnen Ordner ####
setwd(input$wd)
input$file <- "210823_TZ07027.docx"
input$Messprotokoll <- list.dirs()[grep("Messprotokoll", list.dirs())]
input$Messprotokoll <- paste0(input$Messprotokoll, "/")

file.copy(input$file
          , 
          paste0(input$Messprotokoll
                 , paste0(input$date, "_", 
                          substr(input$Messprotokoll
                                 , unlist(lapply(gregexpr("\\/", input$Messprotokoll), function(x) x[2])) + 1
                                 , unlist(lapply(gregexpr("\\/", input$Messprotokoll), function(x) x[3])) - 1)
                          , ".docx"
                 )
          )
          , overwrite = T)

# Kopiere alle Worddateien wieder in den Ursprungsordner ####
setwd(input$wd)
file.copy(paste0(getwd(),"/", list.files(dir(), pattern = "docx$", recursive = T, full.names = T))
          , getwd()
)

# Erstelle pdfs mit https://online2pdf.com/convert-docx-to-pdf# ####

# L?sche die kopierten Worddateien

# Signiere PDFs mit Adobe

# Verteile PDFs in die einzelnen Ordner
input$pdffile <- dir(pattern = ".pdf$")
input$Messprotokoll <- list.dirs()[grep("Messprotokoll", list.dirs())]
input$Messprotokoll <- paste0(input$Messprotokoll, "/")

input$pdffilesub <- substr(input$pdffile
                           , unlist(lapply(gregexpr("_", input$pdffile), function(x) x[1]))+ 1
                           , unlist(lapply(gregexpr("\\.", input$pdffile), function(x) x[1])) - 1)

for(i in 1:length(input$pdffilesub)){
  file.copy(input$pdffile[i]
            , paste0(input$Messprotokoll[which(unlist(gregexpr(input$pdffilesub[i], input$Messprotokoll)) > 0)], input$pdffile[i]))
}

unlink(input$pdffile)



