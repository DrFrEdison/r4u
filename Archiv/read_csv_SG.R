input <- list(); input$R <- paste0(Sys.getenv("OneDriveCommercial"), "/FE_Methoden/", "Allgemein/R_dt_project/")
source(paste0(input$R,"R/source_read.R"))

# Just change things from here ####
input$customer <- "MEG"
input$location <- "Loeningen"
input$unit <- "SG"

input$entertain <- F # Let me entertain you!
source(paste0(wd$scripts,"choose_work_horse.R"))

input$firstday <- "2021-01-01"
input$lastday <- "2021-11-30"

input$product_ID
input$product <- "KS_Energy_Zero"

input$typeof <- c("spc") # c("spc", "ref", "drk")

input$fastplot <- F # Diagnostic Plot (T or F)
input$export_directory = "C://csvtemp"
# to here ####

SG_csv <- read.csv.SG(customer = input$customer, location = input$location, line = input$line, 
                      firstday = input$firstday, lastday = input$lastday,
                      product = input$product, 
                      fastplot = input$fastplot, typeof = input$typeof,
                      export_directory = input$export_directory);if(input$entertain==T){play.audioSample(.entertainment$alarm);suppressMessages(.breakfun(10));par(mfrow=c(1,1));plot(.entertainment$egal_image,axes=F);suppressMessages(.breakfun(10))}
