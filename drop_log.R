# Drop file in folder with .log files. If .log files are from Loeningen, put SG = T

library(devtools); suppressMessages(install_github("DrFrEdison/r4dt", dependencies = T) ); suppressPackageStartupMessages(library(r4dt))
drop_log(dirname(rstudioapi::getSourceEditorContext()$path), SG = F)
