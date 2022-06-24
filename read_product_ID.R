# Package update and initialization ####
library(devtools)
suppressMessages(install_github("DrFrEdison/r4dt", dependencies = T, upgrade = "always", quiet = T) )
library(r4dt)

# Read product ID from ServiceBackup csv files####
dt <- list()

for(i in 1:nrow(dt_customer))
produkt_per_day_year(customer = dt_customer$customer[i]
                     , location = dt_customer$location[i]
                     , line = dt_customer$line[i]
                     , LG = dt_customer$LG[i]
                     , year = substr(Sys.Date(),1,4))
