dt <- list(); dt$R <- paste0(Sys.getenv("OneDriveCommercial"), "/FE_Methoden/", "Allgemein/R_dt_project/")
source(paste0(dt$R,"R/source_read.R"))

dt$customerlist
dt$line <- "L3_PET_CSD" #line
dt$info <- .customer.location.by.line(line = dt$line)

dt$firstday <- "2022-01-01" # Date range min
dt$lastday <- "2022-06-01" # Date range max

.customer.location.line.products(dt$info$customer, dt$info$location, dt$line, dt$firstday, dt$lastday, dt$product_ID) # All product ID's and names in the chosen timeframe
.customer.location.line.productID(dt$info$customer, dt$info$location, dt$line, dt$product_ID) # All product ID's on this line

dt$product <- c(15) # Choose Product ID, NA for everything

# Only LG3
dt$typecode <- NA # NA, everything; 0, production; 2, start of production; 16, hand measurement

# Only LG2
dt$Ringkessel = T # watch out! Only Ringkessel == T exports valid spectra

dt$typeof <- c("spc", "ref", "drk") # c("spc", "ref", "drk")

dt$export_directory = "C://csvtemp"

dt$slim <- T # get only important colums

dt$entertain <- F # Let me entertain you!

read.csv.LG(firstday = dt$firstday
            , lastday = dt$lastday
            , customer =  dt$info$customer
            , location = dt$info$location
            , line =  dt$line
            , product =  dt$product
            , typecode = dt$typecode
            , Ringkessel =  dt$Ringkessel
            , typeof = dt$typeof
            , slim =  dt$slim
            , return.R =  F)
