# Package update and initialization ####
library(devtools)
suppressMessages(install_github("DrFrEdison/r4dt", dependencies = T, upgrade = "always", quiet = T) )
suppressPackageStartupMessages(library(r4dt))

# Unzip files to service backup ####
dt <- list()
dt$line <-F # do you want to execute the function only for the chosen customer / location / unit? If yes, than set to T
dt_customer
dt$customer <- "MEG"
dt$location <- "Loeningen"
dt$line.choose <- "SG"
dt$LG <- "SG"
dt$date <- NA # Unzip only one date?

dt$year <- "2022"

dt$unzip.dir <- "C:/csvtemp"

dt$entertain <- F
# to here
unzip.merge.LG2(year = dt$year
                , date = dt$date
                , line = dt$line
                , unzip.dir = dt$unzip.dir)
if(dt$entertain==T){play.audioSample(.entertainment$alarm);suppressMessages(.breakfun(10));par(mfrow=c(1,1));plot(.entertainment$egal_image,axes=F);suppressMessages(.breakfun(10))}
