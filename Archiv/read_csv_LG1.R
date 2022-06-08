input <- list(); input$sourcep <- paste0(Sys.getenv("OneDriveCommercial"), "/FE_Methoden/")
input$linux <- F;source(paste0(input$sourcep,"Allgemein/R_dt_project/R/source_read.R"));input$task <- "read_csv";input$LG <- 1
input$customerlist <- read.csv2(paste0(wd$data,"customer_list.csv"),sep="\t");input$customerlist[input$customerlist$LG!="3",];input$entertain = T

# Just change things from here ####
input$customer <- "Pepsi"
input$location <- "Nieder_Roden"
input$unit <- "LG"

input$entertain <- F # Let me entertain you!
source(paste0(wd$scripts,"choose_work_horse.R"))

input$firstday <- "2021-01-01"
input$lastday <- "2021-05-18"

input$product_ID
input$product <- 5

input$typeof <- c("spc", "ref", "drk") # c("spc", "ref", "drk")

input$fastplot <- F # Diagnostic Plot (T or F)
input$export_directory = "C://csvtemp"
input$Ringkessel = T
# to here ####

LG2_csv <- read_csv_files_LG2(customer = input$customer, location = input$location, unit = input$unit, 
                              firstday = input$firstday, lastday = input$lastday,
                              product = input$product, 
                              Ringkessel = input$Ringkessel,fastplot = input$fastplot, typeof = input$typeof,
                              export_directory = input$export_directory);if(input$entertain==T){play.audioSample(.entertainment$egal);suppressMessages(.breakfun(10));par(mfrow=c(1,1));plot(.entertainment$egal_image,axes=F);suppressMessages(.breakfun(10))}
