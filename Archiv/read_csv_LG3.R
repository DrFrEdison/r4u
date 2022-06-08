input <- list(); input$R <- paste0(Sys.getenv("OneDriveCommercial"), "/FE_Methoden/", "Allgemein/R_dt_project/")
source(paste0(input$R,"R/source_read.R"))

input$customer <- "CCEP" # Customer
input$location <- "Dorsten" # Location
input$line <- "DC" # Line

input$firstday <- "2021-01-01" # Date range min
input$lastday <- "2021-12-31" # Date range max

.customer.location.line.products(input$customer, input$location, input$line, input$firstday, input$lastday, input$product_ID) # All product ID's and names in the chosen timeframe
.customer.location.line.productID(customer = input$customer, location = input$location, line = input$line, product_ID = input$product_ID) # All product ID's on this line
input$product <- c(11) # Choose Product ID

input$typecode <- NA # NA, everything, 0, Produktion, 2, Anfahren, 16, Handmessung if NA, all spc will be exported.

input$typeof <- c("spc", "ref", "drk") # spc, ref, drk

input$export_directory = wd$csvtemp # Where to export

input$slim <- T # Slim file with solely useful columns

input$entertain <- T # Let me entertain you!

# to here ####
LG3_csv <- read.csv.LG3(firstday = input$firstday
                        , lastday = input$lastday
                        , customer = input$customer
                        , location = input$location 
                        , line = input$line
                        , product = input$product
                        , typecode = input$typecode
                        , export_directory = input$export_directory
                        , typeof = input$typeof
                        , slim = input$slim
                        , return.R = F)
if(input$entertain==T){play.audioSample(.entertainment$drum);suppressMessages(.breakfun(10));par(mfrow = c(1,1));plot(.entertainment$alarm_image,axes=F);suppressMessages(.breakfun(10))}
