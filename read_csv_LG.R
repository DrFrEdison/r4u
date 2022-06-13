library(devtools); suppressMessages(install_github("DrFrEdison/r4dt", dependencies = T) ); library(r4dt); dt <- list()

dt_customer
dt$line <- "G9" #line
dt$info <- customer.location.by.line(line = dt$line, dt_customer)

dt$firstday <- "2022-04-01" # Date range min
dt$lastday <- "2022-04-13" # Date range max

customer.location.line.products(dt$info$customer, dt$info$location, dt$line, dt$firstday, dt$lastday, dt_customer_product_ID) # All product ID's and names in the chosen timeframe
customer.location.line.productID(dt$info$customer, dt$info$location, dt$line, dt_customer_product_ID) # All product ID's on this line

dt$product <- NA
# Only LG3
dt$typecode <- 16 # NA, everything; 0, production; 2, start of production; 16, hand measurement

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
            , return.R =  F
            , product_ID = dt_customer_product_ID
            , customer.list = dt_customer
            , export_directory = wd$csvtemp)
