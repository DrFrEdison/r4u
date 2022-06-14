# Package update and initialization ####
library(devtools)
suppressMessages(install_github("DrFrEdison/r4dt", dependencies = T, upgrade = "always", quiet = T) )
library(r4dt)

# Read product ID from ServiceBackup csv files####
dt <- list()

for(i in 1:nrow(dt$customerlist))
produkt_per_day_year(customer = dt$customerlist$customer[i]
                     , location = dt$customerlist$location[i]
                     , line = dt$customerlist$line[i]
                     , LG = dt$customerlist$LG[i]
                     , year = substr(Sys.Date(),1,4))
