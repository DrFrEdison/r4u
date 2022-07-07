# Package update and initialization ####
suppressMessages(devtools::install_github("DrFrEdison/r4dt", upgrade = "always", build = T, quiet = T))
suppressPackageStartupMessages(library(r4dt))
setwd(wd$csvtemp)

# Right Click in OlupClient "Result Matrices"
# "Alles Auswaehlen"
# STRG + C
# Run the following line afterwards
olup_raw <- readClipboard()

ncomp <- NA # Searches automatically for the highest Principal Component, but you can choose another one
show_else <- F # set to T if you want to see also Scores and Leverages
write <- F # set to T if you want to export a .csv in your working directory

olup_read <- read_olup( olup_raw = olup_raw, ncomp = ncomp, write = write, show_else = show_else); print(olup_read)
