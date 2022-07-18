# Drop file in folder with .spc files. If you also want so transform .spc files in recursive folders, set F to T
library(devtools); suppressMessages(install_github("DrFrEdison/r4dt", dependencies = T) ); library(r4dt); dt <- list()
drop_spc(dirname(rstudioapi::getSourceEditorContext()$path), F)
