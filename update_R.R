# make sure to update Rtools (https://cran.r-project.org/bin/windows/Rtools/)
# Run R (not R Studio) as administrator
# installing/loading the package:
if(!require(installr)) { install.packages("installr"); require(installr)} #load / install+load installr
updateR(fast = F
        , browse_news = F
        , install_R = T
        , copy_packages = T
        , copy_site_files = T
        , keep_old_packages = F
        , update_packages = T) # only install R (if there is a newer version), and quits it.
source("https://www.r-statistics.com/wp-content/uploads/2010/04/upgrading-R-on-windows.r.txt")
New.R.RunMe()

homefolder <- paste0(Sys.getenv("HOME"), "\\R\\win-library")
setwd(homefolder)
print(dir(homefolder))

oldversion <- dir( homefolder )[ length( dir(homefolder) )]
newversion <- "4.2"
dir.create(newversion )

# copy in folder C:\Users\MK\Documents\R\win-library
file.copy(paste0(".//", oldversion)
          , paste0(".//", newversion)
          , overwrite = T
          , recursive = T)
update.packages(checkBuilt=TRUE, all =T, ask = F, dep = T)