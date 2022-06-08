input <- list(); input$sourcep <- paste0(Sys.getenv("OneDriveCommercial"), "/FE_Methoden/")
input$linux <- F;source(paste0(input$sourcep,"Allgemein/R_dt_project/R/source_read.R"));input$task <- "read_csv";input$LG <- 3
input$customerlist <- read.csv2(paste0(wd$data,"customer_list.csv"),sep="\t");input$customerlist[input$customerlist$LG=="3",]

require(lubridate)
require(MMWRweek)

# Just change things from here ####
input$customer <- "CCEP"

for(i in 1:nrow(input$customerlist[input$customerlist$LG=="3",])){
  
  input$location <- input$customerlist[input$customerlist$LG=="3","location"][i]
  input$unit <- input$customerlist[input$customerlist$LG=="3","unit"][i]
  input$entertain <- F # Let me entertain you!
  source(paste0(wd$scripts,"choose_work_horse.R"))
 
  input$firstday <- MMWRweek2Date(year(today()) , week(today()) - 1)
  input$lastday <- today()
  
  input$product <- NA
  
  input$typeof <- c("spc", "ref", "dark") # which type of spectra do you want to export?
  input$fastplot <- F # Diagnostic Plot (T or F)
  input$export_directory = "C:/csvtemp"
  # to here ####
  
  LG3_csv <- read_csv_files_LG3(firstday = input$firstday, 
                                lastday = input$lastday, 
                                location = input$location, 
                                unit = input$unit, 
                                product = input$product, 
                                export_directory = input$export_directory,
                                fastplot = input$fastplot,  
                                typeof = input$typeof)
  
  if(length(grep("NULL", LG3_csv$spc$data$DTproductName)) > 0)  LG3_csv$spc$data <- LG3_csv$spc$data[-grep("NULL", LG3_csv$spc$data$DTproductName) , ]
  
  for(j in 1:length(unique(LG3_csv$spc$data$DTproductName))){
    product <- unique(LG3_csv$spc$data$DTproductName)[j]
    product_r <- which(LG3_csv$spc$data$DTproductName == product)
    day_product <- LG3_csv$spc$data$date[product_r]
    
    caffein <- LG3_csv$spc$data$caffeineyPredictedCorr[product_r]
    caffein <- as.numeric(gsub(",",".",caffein))
    
    GS2 <- LG3_csv$spc$data$GS2yPredictedCorr[product_r]
    GS2 <- as.numeric(gsub(",",".",GS2))
    
    acid <- LG3_csv$spc$data$totalAcidyPredictedCorr[product_r]
    acid <- as.numeric(gsub(",",".",acid))
    
    product_list <- list(caffein, GS2, acid)
    names_list <- c("Coffein", "GS2", "Acid")
    
    empty_product <- which(is.na(lapply(product_list, sum)) | lapply(product_list, sum) == 0)
    if(length(empty_product) == 3) next
    
    names_list <- names_list[-empty_product]
    
    png(filename = paste0(
      paste0(.service_path(input$customer, input$location, input$unit),"03_Einsatz/Wochencheck/"),
      paste0(lubridate::year(input$firstday), "_KW", formatC(lubridate::week(input$firstday), width = 2, format = "d", flag = "0"),"_"),
      paste0(paste(input$customer, input$location, input$unit, product, names_list[1], sep = "_"),".png")
    )
    ,width = 7*1.5, height = 7/1.1,type="cairo",units="in",pointsize=12,res=500)
    for(k in rev(empty_product)) product_list[[k]] <- NULL
    par(mfrow = c(3 - length(empty_product), 1), mar = c(4, 3, 3, 1))
    
    plot(product_list[[1]]
         , ylim = c(quantile(product_list[[1]], na.rm = T)[2] * .8, quantile(product_list[[1]], na.rm = T)[2] * 1.2)
         , pch = 20, cex = .75
         , xlab = "Datum", ylab = paste(names_list[1],"Prediction %"), main = paste(input$location, input$unit, product, names_list[1])
         , axes = F)
    .xaxisdate(day_product, type = "p", ydata = product_list[[1]])
    
    if(length(names_list) == 2){
      plot(product_list[[2]]
           , ylim = c(quantile(product_list[[2]], na.rm = T)[2] * .8, quantile(product_list[[2]], na.rm = T)[2] * 1.2)
           , pch = 20, cex = .75
           , xlab = "Datum", ylab = paste(names_list[2],"Prediction %"), main = paste(input$location, input$unit, product, names_list[2])
           , axes = F)
      .xaxisdate(day_product, type = "p", ydata = product_list[[2]])
      
    }
    dev.off()
  }
  
  png(filename = paste0(
    paste0(.service_path(input$customer, input$location, input$unit),"03_Einsatz/Wochencheck/"),
    paste0(lubridate::year(input$firstday), "_KW", formatC(lubridate::week(input$firstday), width = 2, format = "d", flag = "0"),"_"),
    "Referenzen",".png")
    ,width = 7*1.5, height = 7/1.1,type="cairo",units="in",pointsize=12,res=500)
  par(mfrow = c(1,1), mar = c(4, 3, 3, 1))
  
  colp <- rainbow(length(unique(LG3_csv$ref$data$date)))
  colp2 <- colp[factor(LG3_csv$ref$data$date)]
  matplot(LG3_csv$ref$wl
          , t(LG3_csv$ref$spc)
          , lty = 1, type = "l", xlab = "lambda in nm", ylab = "Counts", main = "Referenz", col = colp2)
  legend("topright", as.character(levels(factor(LG3_csv$ref$data$date))), lty = 1, col = colp)
  dev.off()
  
  png(filename = paste0(
    paste0(.service_path(input$customer, input$location, input$unit),"03_Einsatz/Wochencheck/"),
    paste0(lubridate::year(input$firstday), "_KW", formatC(lubridate::week(input$firstday), width = 2, format = "d", flag = "0"),"_"),
    "Dunkelwert",".png")
    ,width = 7*1.5, height = 7/1.1,type="cairo",units="in",pointsize=12,res=500)
  par(mfrow = c(1,1), mar = c(4, 3, 3, 1))
  
  colp <- rainbow(length(unique(LG3_csv$dark$data$date)))
  colp2 <- colp[factor(LG3_csv$dark$data$date)]
  matplot(LG3_csv$dark$wl
          , t(LG3_csv$dark$spc)
          , lty = 1, type = "l", xlab = "lambda in nm", ylab = "Counts", main = "Dunkelwert", col = colp2)
  legend("topright", as.character(levels(factor(LG3_csv$ref$data$date))), lty = 1, col = colp)
  dev.off()
  
  parap <- list()
  parap$Druck_Fluss_Temp <- c("FluidPressure", "FluidFlow", "FluidTemperature", "SpectrometerTemperature", "RackTemperature", "AmbientTemperature")
  parap$Druck_Fluss_Temp_names <- c("Druck", "Fluss", "Temperatur Flüssigkeit", "Temperatur Spektrometer", "Temperatur Rack", "Temperatur Umgebung")
  
  parap$optik <- c("integrationTime", "accumulations", "lightPath")
  parap$optik_names <- c("Integrationszeit", "Mittelungen", "Lichtpfad")
  
  parap$customer <- c("brix", "diet", "co2", "conductivity")
  parap$customer_names <- c("Brix", "Diet", "CO2", "Leitfähigkeit")
  
  png(filename = paste0(
    paste0(.service_path(input$customer, input$location, input$unit),"03_Einsatz/Wochencheck/"),
    paste0(lubridate::year(input$firstday), "_KW", formatC(lubridate::week(input$firstday), width = 2, format = "d", flag = "0"),"_"),
    "Fluss_Druck_Temperatur",".png")
    ,width = 7*1.5, height = 7/1.1,type="cairo",units="in",pointsize=12,res=500)
  par(mfrow = c(2,3), mar = c(4, 3, 3, 1))
  for(i in 1:length(parap$Druck_Fluss_Temp)){
    dat <- as.numeric(LG3_csv$spc$data[ , which(names(LG3_csv$spc$data) == parap$Druck_Fluss_Temp[i])])
    plot(dat
         , pch = 20, xlab = "Tag", ylab = parap$Druck_Fluss_Temp_names[i]
         , ylim = c(quantile(dat, na.rm = T)[2] * .8, quantile(dat, na.rm = T)[4] * 1.2)
         , axes = F
         , main = paste(parap$Druck_Fluss_Temp_names[i], input$location, input$unit))
    .xaxisdate(LG3_csv$spc$data$date, type = NA)
  }
  dev.off()
  
  png(filename = paste0(
    paste0(.service_path(input$customer, input$location, input$unit),"03_Einsatz/Wochencheck/"),
    paste0(lubridate::year(input$firstday), "_KW", formatC(lubridate::week(input$firstday), width = 2, format = "d", flag = "0"),"_"),
    "Optische_Parameter",".png")
    ,width = 7*1.5, height = 7/1.1,type="cairo",units="in",pointsize=12,res=500)
  par(mfrow = c(1,3), mar = c(4, 3, 3, 1))
  for(i in 1:length(parap$optik)){
    dat <- as.numeric(LG3_csv$spc$data[ , which(names(LG3_csv$spc$data) == parap$optik[i])])
    plot(dat
         , pch = 20, xlab = "Tag", ylab = parap$optik_names[i]
         , ylim = c(quantile(dat, na.rm = T)[2] * .8, quantile(dat, na.rm = T)[4] * 1.2)
         , axes = F
         , main = paste(parap$optik_names[i], input$location, input$unit))
    .xaxisdate(LG3_csv$spc$data$date, type = NA)
  }
  dev.off()
 
  png(filename = paste0(
    paste0(.service_path(input$customer, input$location, input$unit),"03_Einsatz/Wochencheck/"),
    paste0(lubridate::year(input$firstday), "_KW", formatC(lubridate::week(input$firstday), width = 2, format = "d", flag = "0"),"_"),
    "Externe_Parameter",".png")
    ,width = 7*1.5, height = 7/1.1,type="cairo",units="in",pointsize=12,res=500)
  par(mfrow = c(2,2), mar = c(4, 3, 3, 1))
  for(i in 1:length(parap$customer)){
    dat <- as.numeric(LG3_csv$spc$data[ , which(names(LG3_csv$spc$data) == parap$customer[i])])
    if(length(dat) == 0){
      plot(1:1
           , pch = 20, xlab = "Tag", ylab = parap$customer_names[i]
           , type = "n"
           # , ylim = c(quantile(dat, na.rm = T)[2] * .8, quantile(dat, na.rm = T)[4] * 1.2)
           # , axes = F
           , main = paste(parap$customer_names[i], input$location, input$unit))  
    }
    if(length(dat) == 0) next
    plot(dat
         , pch = 20, xlab = "Tag", ylab = parap$customer_names[i]
         , ylim = c(quantile(dat, na.rm = T)[2] * .8, quantile(dat, na.rm = T)[4] * 1.2)
         , axes = F
         , main = paste(parap$customer_names[i], input$location, input$unit))
    .xaxisdate(LG3_csv$spc$data$date, type = NA)
  }
  dev.off()
}
