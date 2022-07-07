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

# Right Click in UNSB Prediction "Copy with Headers"
# Run the following line afterwards
unsb_raw <- readClipboard()

show_else <- F # set to T if you want to see also Y_Deviation
write <- F # set to T if you want to export a .csv in your working directory

unsb_read <- read_unsb_prediction(unsb_raw, show_else = show_else, write = write); print(unsb_read)


# Result should be more or less zero
round(olup_read$Y_Pred - unsb_read$Y_Pred, 3)
