# Package update and initialization ####
suppressMessages(devtools::install_github("DrFrEdison/r4dt", upgrade = "always", build = F, quiet = T))
suppressPackageStartupMessages(library(r4dt))

# Read csv from ServiceBackup ####
dt <- list()
dt_customer
dt$line <- "L3_PET_CSD" #line
dt$info <- customer.location.by.line(line = dt$line, dt_customer)

# date range
dt$firstday <- "2022-06-01" # Date range min
dt$lastday <- "2022-07-12" # Date range max

# product overview
customer.location.line.products(dt$info$customer, dt$info$location, dt$line, dt$firstday, dt$lastday, dt_customer_product_ID) # All product ID's and names in the chosen timeframe
customer.location.line.productID(dt$info$customer, dt$info$location, dt$line, dt_customer_product_ID) # All product ID's on this line

# choose product
dt$product <- NA # NA for all

# Only LG3
dt_LG3_typecode
dt$typecode <- NA
if( !is.na(dt$typecode) ) message("Typecode is not NA")

# Only LG2
dt$Ringkessel = F # watch out! Only Ringkessel == T exports valid spectra

# type of spectra c("spc", "ref", "drk")
dt$typeof <- c("spc")

# export directory
dt$export_directory = "C://csvtemp"

# slim data output with less columns
dt$slim <- T

# entertainment needed?
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

