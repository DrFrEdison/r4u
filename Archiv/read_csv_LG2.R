input <- list(); input$R <- paste0(Sys.getenv("OneDriveCommercial"), "/FE_Methoden/", "Allgemein/R_dt_project/")
source(paste0(input$R,"R/source_read.R"))

input$customer <- "CCEP" # customer
input$location <- "Genshagen" #location
input$line <- "G6" #line

input$firstday <- "2021-12-01" # Date range min
input$lastday <- "2021-12-31" # Date range max

.customer.location.line.products(input$customer, input$location, input$line, input$firstday, input$lastday, input$product_ID) # All product ID's and names in the chosen timeframe
.customer.location.line.productID(customer = input$customer, location = input$location, line = input$line, product_ID = input$product_ID) # All product ID's on this line
input$product <- c(2) # Choose Product ID

input$Ringkessel = T # watch out! Only Ringkessel == T exports valid spectra

input$typeof <- c("spc", "ref", "drk") # c("spc", "ref", "drk")

input$export_directory = "C://csvtemp"

input$slim <- T

input$entertain <- F # Let me entertain you!

# to here ####

LG2_csv <- read.csv.LG2(customer = input$customer
                        , location = input$location
                        , line = input$line
                        , firstday = input$firstday
                        , lastday = input$lastday
                        , product = input$product 
                        , typeof = input$typeof
                        , export_directory = input$export_directory
                        , slim = input$slim
                        , return.R = F);if(input$entertain==T){play.audioSample(.entertainment$egal);suppressMessages(.breakfun(10));par(mfrow=c(1,1));plot(.entertainment$egal_image,axes=F);suppressMessages(.breakfun(10))}
