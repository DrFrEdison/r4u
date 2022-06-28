# move all .csv and .spc files to service backup
library(r4dt)
dt <- list()
wartung <- list()

# csv ####
# Genshagen ####
wartung$csv$Genshagen <- dir(wd$wartung$CCEP$Genshagen, ".csv$", recursive = T)
wartung$csvsub$Genshagen$G2 <- wartung$csv$Genshagen[grep("_G2_", wartung$csv$Genshagen)]
wartung$csvsub$Genshagen$G3 <- wartung$csv$Genshagen[grep("_G3_", wartung$csv$Genshagen)]
wartung$csvsub$Genshagen$G6 <- wartung$csv$Genshagen[grep("_G6_", wartung$csv$Genshagen)]

wartung$csvfiles$Genshagen$G2 <- substr(wartung$csvsub$Genshagen$G2, unlist(lapply(gregexpr("/", wartung$csvsub$Genshagen$G2), max)) + 1, nchar(wartung$csvsub$Genshagen$G2))
wartung$csvfiles$Genshagen$G3 <- substr(wartung$csvsub$Genshagen$G3, unlist(lapply(gregexpr("/", wartung$csvsub$Genshagen$G3), max)) + 1, nchar(wartung$csvsub$Genshagen$G3))
wartung$csvfiles$Genshagen$G6 <- substr(wartung$csvsub$Genshagen$G6, unlist(lapply(gregexpr("/", wartung$csvsub$Genshagen$G6), max)) + 1, nchar(wartung$csvsub$Genshagen$G6))


wartung$csvsub$Genshagen$G2 <- wartung$csvsub$Genshagen$G2[which(!is.na(as.numeric(substr(wartung$csvfiles$Genshagen$G2, 1, 4))))]
wartung$csvfiles$Genshagen$G2 <- wartung$csvfiles$Genshagen$G2[which(!is.na(as.numeric(substr(wartung$csvfiles$Genshagen$G2, 1, 4))))]

wartung$csvsub$Genshagen$G3 <- wartung$csvsub$Genshagen$G3[which(!is.na(as.numeric(substr(wartung$csvfiles$Genshagen$G3, 1, 4))))]
wartung$csvfiles$Genshagen$G3 <- wartung$csvfiles$Genshagen$G3[which(!is.na(as.numeric(substr(wartung$csvfiles$Genshagen$G3, 1, 4))))]

wartung$csvsub$Genshagen$G6 <- wartung$csvsub$Genshagen$G6[which(!is.na(as.numeric(substr(wartung$csvfiles$Genshagen$G6, 1, 4))))]
wartung$csvfiles$Genshagen$G6 <- wartung$csvfiles$Genshagen$G6[which(!is.na(as.numeric(substr(wartung$csvfiles$Genshagen$G6, 1, 4))))]


wartung$csvsub$Genshagen$G2 <- wartung$csvsub$Genshagen$G2[which(unlist(lapply(gregexpr("-",wartung$csvfiles$Genshagen$G2), max)) >0)]
wartung$csvfiles$Genshagen$G2 <- wartung$csvfiles$Genshagen$G2[which(unlist(lapply(gregexpr("-",wartung$csvfiles$Genshagen$G2), max)) >0)]

wartung$csvcheck$Genshagen$G2 <- substr(wartung$csvfiles$Genshagen$G2, unlist(lapply(gregexpr("-",wartung$csvfiles$Genshagen$G2), min))+1, unlist(lapply(gregexpr("-",wartung$csvfiles$Genshagen$G2), max))-1)
wartung$csvsub$Genshagen$G2 <- wartung$csvsub$Genshagen$G2[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$csvcheck$Genshagen$G2))))))]
wartung$csvfiles$Genshagen$G2 <- wartung$csvfiles$Genshagen$G2[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$csvcheck$Genshagen$G2))))))]


wartung$csvsub$Genshagen$G3 <- wartung$csvsub$Genshagen$G3[which(unlist(lapply(gregexpr("-",wartung$csvfiles$Genshagen$G3), max)) >0)]
wartung$csvfiles$Genshagen$G3 <- wartung$csvfiles$Genshagen$G3[which(unlist(lapply(gregexpr("-",wartung$csvfiles$Genshagen$G3), max)) >0)]

wartung$csvcheck$Genshagen$G3 <- substr(wartung$csvfiles$Genshagen$G3, unlist(lapply(gregexpr("-",wartung$csvfiles$Genshagen$G3), min))+1, unlist(lapply(gregexpr("-",wartung$csvfiles$Genshagen$G3), max))-1)
wartung$csvsub$Genshagen$G3 <- wartung$csvsub$Genshagen$G3[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$csvcheck$Genshagen$G3))))))]
wartung$csvfiles$Genshagen$G3 <- wartung$csvfiles$Genshagen$G3[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$csvcheck$Genshagen$G3))))))]


wartung$csvsub$Genshagen$G6 <- wartung$csvsub$Genshagen$G6[which(unlist(lapply(gregexpr("-",wartung$csvfiles$Genshagen$G6), max)) >0)]
wartung$csvfiles$Genshagen$G6 <- wartung$csvfiles$Genshagen$G6[which(unlist(lapply(gregexpr("-",wartung$csvfiles$Genshagen$G6), max)) >0)]

wartung$csvcheck$Genshagen$G6 <- substr(wartung$csvfiles$Genshagen$G6, unlist(lapply(gregexpr("-",wartung$csvfiles$Genshagen$G6), min))+1, unlist(lapply(gregexpr("-",wartung$csvfiles$Genshagen$G6), max))-1)
wartung$csvsub$Genshagen$G6 <- wartung$csvsub$Genshagen$G6[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$csvcheck$Genshagen$G6))))))]
wartung$csvfiles$Genshagen$G6 <- wartung$csvfiles$Genshagen$G6[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$csvcheck$Genshagen$G6))))))]

setwd(wd$wartung$CCEP$Genshagen)
if(!all(wartung$csvfiles$Genshagen$G2 %in% dir(paste0(wd$servicebackup$CCEP$Genshagen$G2, "CSV/"))) ) file.copy(wartung$csvsub$Genshagen$G2, paste0(wd$servicebackup$CCEP$Genshagen$G2, "CSV/",wartung$csvfiles$Genshagen$G2))
if(!all(wartung$csvfiles$Genshagen$G3 %in% dir(paste0(wd$servicebackup$CCEP$Genshagen$G3, "CSV/"))) ) file.copy(wartung$csvsub$Genshagen$G3, paste0(wd$servicebackup$CCEP$Genshagen$G3, "CSV/", wartung$csvfiles$Genshagen$G3))
if(!all(wartung$csvfiles$Genshagen$G6 %in% dir(paste0(wd$servicebackup$CCEP$Genshagen$G6, "CSV/"))) ) file.copy(wartung$csvsub$Genshagen$G6, paste0(wd$servicebackup$CCEP$Genshagen$G6, "CSV/", wartung$csvfiles$Genshagen$G6))

# Woerth ####
wartung$csv$Woerth <- dir(wd$wartung$MEG$Woerth, ".csv$", recursive = T)
wartung$csvsub$Woerth$A3 <- wartung$csv$Woerth[grep("_A3_", wartung$csv$Woerth)]
wartung$csvsub$Woerth$A5 <- wartung$csv$Woerth[grep("_A5_", wartung$csv$Woerth)]
wartung$csvsub$Woerth$A6 <- wartung$csv$Woerth[grep("_A6_", wartung$csv$Woerth)]

wartung$csvfiles$Woerth$A3 <- substr(wartung$csvsub$Woerth$A3, unlist(lapply(gregexpr("/", wartung$csvsub$Woerth$A3), max)) + 1, nchar(wartung$csvsub$Woerth$A3))
wartung$csvfiles$Woerth$A5 <- substr(wartung$csvsub$Woerth$A5, unlist(lapply(gregexpr("/", wartung$csvsub$Woerth$A5), max)) + 1, nchar(wartung$csvsub$Woerth$A5))
wartung$csvfiles$Woerth$A6 <- substr(wartung$csvsub$Woerth$A6, unlist(lapply(gregexpr("/", wartung$csvsub$Woerth$A6), max)) + 1, nchar(wartung$csvsub$Woerth$A6))


wartung$csvsub$Woerth$A3 <- wartung$csvsub$Woerth$A3[which(!is.na(as.numeric(substr(wartung$csvfiles$Woerth$A3, 1, 4))))]
wartung$csvfiles$Woerth$A3 <- wartung$csvfiles$Woerth$A3[which(!is.na(as.numeric(substr(wartung$csvfiles$Woerth$A3, 1, 4))))]

wartung$csvsub$Woerth$A5 <- wartung$csvsub$Woerth$A5[which(!is.na(as.numeric(substr(wartung$csvfiles$Woerth$A5, 1, 4))))]
wartung$csvfiles$Woerth$A5 <- wartung$csvfiles$Woerth$A5[which(!is.na(as.numeric(substr(wartung$csvfiles$Woerth$A5, 1, 4))))]

wartung$csvsub$Woerth$A6 <- wartung$csvsub$Woerth$A6[which(!is.na(as.numeric(substr(wartung$csvfiles$Woerth$A6, 1, 4))))]
wartung$csvfiles$Woerth$A6 <- wartung$csvfiles$Woerth$A6[which(!is.na(as.numeric(substr(wartung$csvfiles$Woerth$A6, 1, 4))))]


wartung$csvsub$Woerth$A3 <- wartung$csvsub$Woerth$A3[which(unlist(lapply(gregexpr("-",wartung$csvfiles$Woerth$A3), max)) >0)]
wartung$csvfiles$Woerth$A3 <- wartung$csvfiles$Woerth$A3[which(unlist(lapply(gregexpr("-",wartung$csvfiles$Woerth$A3), max)) >0)]

wartung$csvcheck$Woerth$A3 <- substr(wartung$csvfiles$Woerth$A3, unlist(lapply(gregexpr("-",wartung$csvfiles$Woerth$A3), min))+1, unlist(lapply(gregexpr("-",wartung$csvfiles$Woerth$A3), max))-1)
wartung$csvsub$Woerth$A3 <- wartung$csvsub$Woerth$A3[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$csvcheck$Woerth$A3))))))]
wartung$csvfiles$Woerth$A3 <- wartung$csvfiles$Woerth$A3[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$csvcheck$Woerth$A3))))))]


wartung$csvsub$Woerth$A5 <- wartung$csvsub$Woerth$A5[which(unlist(lapply(gregexpr("-",wartung$csvfiles$Woerth$A5), max)) >0)]
wartung$csvfiles$Woerth$A5 <- wartung$csvfiles$Woerth$A5[which(unlist(lapply(gregexpr("-",wartung$csvfiles$Woerth$A5), max)) >0)]

wartung$csvcheck$Woerth$A5 <- substr(wartung$csvfiles$Woerth$A5, unlist(lapply(gregexpr("-",wartung$csvfiles$Woerth$A5), min))+1, unlist(lapply(gregexpr("-",wartung$csvfiles$Woerth$A5), max))-1)
wartung$csvsub$Woerth$A5 <- wartung$csvsub$Woerth$A5[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$csvcheck$Woerth$A5))))))]
wartung$csvfiles$Woerth$A5 <- wartung$csvfiles$Woerth$A5[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$csvcheck$Woerth$A5))))))]


wartung$csvsub$Woerth$A6 <- wartung$csvsub$Woerth$A6[which(unlist(lapply(gregexpr("-",wartung$csvfiles$Woerth$A6), max)) >0)]
wartung$csvfiles$Woerth$A6 <- wartung$csvfiles$Woerth$A6[which(unlist(lapply(gregexpr("-",wartung$csvfiles$Woerth$A6), max)) >0)]

wartung$csvcheck$Woerth$A6 <- substr(wartung$csvfiles$Woerth$A6, unlist(lapply(gregexpr("-",wartung$csvfiles$Woerth$A6), min))+1, unlist(lapply(gregexpr("-",wartung$csvfiles$Woerth$A6), max))-1)
wartung$csvsub$Woerth$A6 <- wartung$csvsub$Woerth$A6[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$csvcheck$Woerth$A6))))))]
wartung$csvfiles$Woerth$A6 <- wartung$csvfiles$Woerth$A6[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$csvcheck$Woerth$A6))))))]

setwd(wd$wartung$MEG$Woerth)
if(!all(wartung$csvfiles$Woerth$A3 %in% dir(paste0(wd$servicebackup$MEG$Woerth$A3, "CSV/"))) ) file.copy(wartung$csvsub$Woerth$A3, paste0(wd$servicebackup$MEG$Woerth$A3, "CSV/", wartung$csvfiles$Woerth$A3))
if(!all(wartung$csvfiles$Woerth$A5 %in% dir(paste0(wd$servicebackup$MEG$Woerth$A5, "CSV/"))) ) file.copy(wartung$csvsub$Woerth$A5, paste0(wd$servicebackup$MEG$Woerth$A5, "CSV/", wartung$csvfiles$Woerth$A5))
if(!all(wartung$csvfiles$Woerth$A6 %in% dir(paste0(wd$servicebackup$MEG$Woerth$A6, "CSV/"))) ) file.copy(wartung$csvsub$Woerth$A6, paste0(wd$servicebackup$MEG$Woerth$A6, "CSV/", wartung$csvfiles$Woerth$A6))

# Kirkel ####
wartung$csv$Kirkel <- dir(wd$wartung$MEG$Kirkel, ".csv$", recursive = T)
wartung$csvsub$Kirkel$A4 <- wartung$csv$Kirkel

wartung$csvfiles$Kirkel$A4 <- substr(wartung$csvsub$Kirkel$A4, unlist(lapply(gregexpr("/", wartung$csvsub$Kirkel$A4), max)) + 1, nchar(wartung$csvsub$Kirkel$A4))

wartung$csvsub$Kirkel$A4 <- wartung$csvsub$Kirkel$A4[which(unlist(lapply(gregexpr("-",wartung$csvfiles$Kirkel$A4), max)) >0)]
wartung$csvfiles$Kirkel$A4 <- wartung$csvfiles$Kirkel$A4[which(unlist(lapply(gregexpr("-",wartung$csvfiles$Kirkel$A4), max)) >0)]


wartung$csvsub$Kirkel$A4 <- wartung$csvsub$Kirkel$A4[which(!is.na(as.numeric(substr(wartung$csvfiles$Kirkel$A4, 1, 4))))]
wartung$csvfiles$Kirkel$A4 <- wartung$csvfiles$Kirkel$A4[which(!is.na(as.numeric(substr(wartung$csvfiles$Kirkel$A4, 1, 4))))]


wartung$csvcheck$Kirkel$A4 <- substr(wartung$csvfiles$Kirkel$A4, unlist(lapply(gregexpr("-",wartung$csvfiles$Kirkel$A4), min))+1, unlist(lapply(gregexpr("-",wartung$csvfiles$Kirkel$A4), max))-1)
wartung$csvsub$Kirkel$A4 <- wartung$csvsub$Kirkel$A4[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$csvcheck$Kirkel$A4))))))]
wartung$csvfiles$Kirkel$A4 <- wartung$csvfiles$Kirkel$A4[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$csvcheck$Kirkel$A4))))))]

setwd(wd$wartung$MEG$Kirkel)
if(!all(wartung$csvfiles$Kirkel$A4 %in% dir(paste0(wd$servicebackup$MEG$Kirkel$A4, "CSV/")))) file.copy(wartung$csvsub$Kirkel$A4, paste0(wd$servicebackup$MEG$Kirkel$A4, "CSV/", wartung$csvfiles$Kirkel$A4))

# Karlsruhe ####
wartung$csv$Karlsruhe <- dir(wd$wartung$CCEP$Karlsruhe, ".csv$", recursive = T)
wartung$csvsub$Karlsruhe$LG <- wartung$csv$Karlsruhe

wartung$csvfiles$Karlsruhe$LG <- substr(wartung$csvsub$Karlsruhe$LG, unlist(lapply(gregexpr("/", wartung$csvsub$Karlsruhe$LG), max)) + 1, nchar(wartung$csvsub$Karlsruhe$LG))


wartung$csvsub$Karlsruhe$LG <- wartung$csvsub$Karlsruhe$LG[which(unlist(lapply(gregexpr("-",wartung$csvfiles$Karlsruhe$LG), max)) >0)]
wartung$csvfiles$Karlsruhe$LG <- wartung$csvfiles$Karlsruhe$LG[which(unlist(lapply(gregexpr("-",wartung$csvfiles$Karlsruhe$LG), max)) >0)]


wartung$csvsub$Karlsruhe$LG <- wartung$csvsub$Karlsruhe$LG[which(!is.na(as.numeric(substr(wartung$csvfiles$Karlsruhe$LG, 1, 4))))]
wartung$csvfiles$Karlsruhe$LG <- wartung$csvfiles$Karlsruhe$LG[which(!is.na(as.numeric(substr(wartung$csvfiles$Karlsruhe$LG, 1, 4))))]


wartung$csvcheck$Karlsruhe$LG <- substr(wartung$csvfiles$Karlsruhe$LG, unlist(lapply(gregexpr("-",wartung$csvfiles$Karlsruhe$LG), min))+1, unlist(lapply(gregexpr("-",wartung$csvfiles$Karlsruhe$LG), max))-1)
wartung$csvsub$Karlsruhe$LG <- wartung$csvsub$Karlsruhe$LG[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$csvcheck$Karlsruhe$LG))))))]
wartung$csvfiles$Karlsruhe$LG <- wartung$csvfiles$Karlsruhe$LG[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$csvcheck$Karlsruhe$LG))))))]


setwd(wd$wartung$CCEP$Karlsruhe)
if(!all(wartung$csvfiles$Karlsruhe$LG %in% dir(paste0(wd$servicebackup$CCEP$Karlsruhe$LG, "CSV/"))) ) file.copy(wartung$csvsub$Karlsruhe$LG, paste0(wd$servicebackup$CCEP$Karlsruhe$LG, "CSV/", wartung$csvfiles$Karlsruhe$LG))

# Nieder_Roden ####
wartung$csv$Nieder_Roden <- dir(wd$wartung$Pepsi$Nieder_Roden, ".csv$", recursive = T)
wartung$csvsub$Nieder_Roden$LG <- wartung$csv$Nieder_Roden

wartung$csvfiles$Nieder_Roden$LG <- substr(wartung$csvsub$Nieder_Roden$LG, unlist(lapply(gregexpr("/", wartung$csvsub$Nieder_Roden$LG), max)) + 1, nchar(wartung$csvsub$Nieder_Roden$LG))


wartung$csvsub$Nieder_Roden$LG <- wartung$csvsub$Nieder_Roden$LG[which(unlist(lapply(gregexpr("-",wartung$csvfiles$Nieder_Roden$LG), max)) >0)]
wartung$csvfiles$Nieder_Roden$LG <- wartung$csvfiles$Nieder_Roden$LG[which(unlist(lapply(gregexpr("-",wartung$csvfiles$Nieder_Roden$LG), max)) >0)]


wartung$csvsub$Nieder_Roden$LG <- wartung$csvsub$Nieder_Roden$LG[which(!is.na(as.numeric(substr(wartung$csvfiles$Nieder_Roden$LG, 1, 4))))]
wartung$csvfiles$Nieder_Roden$LG <- wartung$csvfiles$Nieder_Roden$LG[which(!is.na(as.numeric(substr(wartung$csvfiles$Nieder_Roden$LG, 1, 4))))]


wartung$csvcheck$Nieder_Roden$LG <- substr(wartung$csvfiles$Nieder_Roden$LG, unlist(lapply(gregexpr("-",wartung$csvfiles$Nieder_Roden$LG), min))+1, unlist(lapply(gregexpr("-",wartung$csvfiles$Nieder_Roden$LG), max))-1)
wartung$csvsub$Nieder_Roden$LG <- wartung$csvsub$Nieder_Roden$LG[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$csvcheck$Nieder_Roden$LG))))))]
wartung$csvfiles$Nieder_Roden$LG <- wartung$csvfiles$Nieder_Roden$LG[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$csvcheck$Nieder_Roden$LG))))))]

setwd(wd$wartung$Pepsi$Nieder_Roden)
if(!all(wartung$csvfiles$Nieder_Roden$LG %in% dir(paste0(wd$servicebackup$CCEP$Nieder_Roden$LG, "CSV/"))) ) file.copy(wartung$csvsub$Nieder_Roden$LG, paste0(wd$servicebackup$Pepsi$Nieder_Roden$LG, "CSV/", wartung$csvfiles$Nieder_Roden$LG))

# zip ####
# Genshagen ####
wartung$zip$Genshagen <- dir(wd$wartung$CCEP$Genshagen, ".zip$", recursive = T)
wartung$zipsub$Genshagen$G2 <- wartung$zip$Genshagen[grep("_G2_", wartung$zip$Genshagen)]
wartung$zipsub$Genshagen$G3 <- wartung$zip$Genshagen[grep("_G3_", wartung$zip$Genshagen)]
wartung$zipsub$Genshagen$G6 <- wartung$zip$Genshagen[grep("_G6_", wartung$zip$Genshagen)]

wartung$zipfiles$Genshagen$G2 <- substr(wartung$zipsub$Genshagen$G2, unlist(lapply(gregexpr("/", wartung$zipsub$Genshagen$G2), max)) + 1, nchar(wartung$zipsub$Genshagen$G2))
wartung$zipfiles$Genshagen$G3 <- substr(wartung$zipsub$Genshagen$G3, unlist(lapply(gregexpr("/", wartung$zipsub$Genshagen$G3), max)) + 1, nchar(wartung$zipsub$Genshagen$G3))
wartung$zipfiles$Genshagen$G6 <- substr(wartung$zipsub$Genshagen$G6, unlist(lapply(gregexpr("/", wartung$zipsub$Genshagen$G6), max)) + 1, nchar(wartung$zipsub$Genshagen$G6))


wartung$zipsub$Genshagen$G2 <- wartung$zipsub$Genshagen$G2[which(!is.na(as.numeric(substr(wartung$zipfiles$Genshagen$G2, 1, 4))))]
wartung$zipfiles$Genshagen$G2 <- wartung$zipfiles$Genshagen$G2[which(!is.na(as.numeric(substr(wartung$zipfiles$Genshagen$G2, 1, 4))))]

wartung$zipsub$Genshagen$G3 <- wartung$zipsub$Genshagen$G3[which(!is.na(as.numeric(substr(wartung$zipfiles$Genshagen$G3, 1, 4))))]
wartung$zipfiles$Genshagen$G3 <- wartung$zipfiles$Genshagen$G3[which(!is.na(as.numeric(substr(wartung$zipfiles$Genshagen$G3, 1, 4))))]

wartung$zipsub$Genshagen$G6 <- wartung$zipsub$Genshagen$G6[which(!is.na(as.numeric(substr(wartung$zipfiles$Genshagen$G6, 1, 4))))]
wartung$zipfiles$Genshagen$G6 <- wartung$zipfiles$Genshagen$G6[which(!is.na(as.numeric(substr(wartung$zipfiles$Genshagen$G6, 1, 4))))]


wartung$zipsub$Genshagen$G2 <- wartung$zipsub$Genshagen$G2[which(unlist(lapply(gregexpr("-",wartung$zipfiles$Genshagen$G2), max)) >0)]
wartung$zipfiles$Genshagen$G2 <- wartung$zipfiles$Genshagen$G2[which(unlist(lapply(gregexpr("-",wartung$zipfiles$Genshagen$G2), max)) >0)]

wartung$zipcheck$Genshagen$G2 <- substr(wartung$zipfiles$Genshagen$G2, unlist(lapply(gregexpr("-",wartung$zipfiles$Genshagen$G2), min))+1, unlist(lapply(gregexpr("-",wartung$zipfiles$Genshagen$G2), max))-1)
wartung$zipsub$Genshagen$G2 <- wartung$zipsub$Genshagen$G2[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$zipcheck$Genshagen$G2))))))]
wartung$zipfiles$Genshagen$G2 <- wartung$zipfiles$Genshagen$G2[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$zipcheck$Genshagen$G2))))))]


wartung$zipsub$Genshagen$G3 <- wartung$zipsub$Genshagen$G3[which(unlist(lapply(gregexpr("-",wartung$zipfiles$Genshagen$G3), max)) >0)]
wartung$zipfiles$Genshagen$G3 <- wartung$zipfiles$Genshagen$G3[which(unlist(lapply(gregexpr("-",wartung$zipfiles$Genshagen$G3), max)) >0)]

wartung$zipcheck$Genshagen$G3 <- substr(wartung$zipfiles$Genshagen$G3, unlist(lapply(gregexpr("-",wartung$zipfiles$Genshagen$G3), min))+1, unlist(lapply(gregexpr("-",wartung$zipfiles$Genshagen$G3), max))-1)
wartung$zipsub$Genshagen$G3 <- wartung$zipsub$Genshagen$G3[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$zipcheck$Genshagen$G3))))))]
wartung$zipfiles$Genshagen$G3 <- wartung$zipfiles$Genshagen$G3[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$zipcheck$Genshagen$G3))))))]


wartung$zipsub$Genshagen$G6 <- wartung$zipsub$Genshagen$G6[which(unlist(lapply(gregexpr("-",wartung$zipfiles$Genshagen$G6), max)) >0)]
wartung$zipfiles$Genshagen$G6 <- wartung$zipfiles$Genshagen$G6[which(unlist(lapply(gregexpr("-",wartung$zipfiles$Genshagen$G6), max)) >0)]

wartung$zipcheck$Genshagen$G6 <- substr(wartung$zipfiles$Genshagen$G6, unlist(lapply(gregexpr("-",wartung$zipfiles$Genshagen$G6), min))+1, unlist(lapply(gregexpr("-",wartung$zipfiles$Genshagen$G6), max))-1)
wartung$zipsub$Genshagen$G6 <- wartung$zipsub$Genshagen$G6[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$zipcheck$Genshagen$G6))))))]
wartung$zipfiles$Genshagen$G6 <- wartung$zipfiles$Genshagen$G6[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$zipcheck$Genshagen$G6))))))]

setwd(wd$wartung$CCEP$Genshagen)
if(!all(wartung$zipfiles$Genshagen$G2 %in% dir(paste0(wd$servicebackup$CCEP$Genshagen$G2, "ZIP/"))) ) file.copy(wartung$zipsub$Genshagen$G2, paste0(wd$servicebackup$CCEP$Genshagen$G2, "ZIP/",wartung$zipfiles$Genshagen$G2))
if(!all(wartung$zipfiles$Genshagen$G3 %in% dir(paste0(wd$servicebackup$CCEP$Genshagen$G3, "ZIP/"))) ) file.copy(wartung$zipsub$Genshagen$G3, paste0(wd$servicebackup$CCEP$Genshagen$G3, "ZIP/", wartung$zipfiles$Genshagen$G3))
if(!all(wartung$zipfiles$Genshagen$G6 %in% dir(paste0(wd$servicebackup$CCEP$Genshagen$G6, "ZIP/"))) ) file.copy(wartung$zipsub$Genshagen$G6, paste0(wd$servicebackup$CCEP$Genshagen$G6, "ZIP/", wartung$zipfiles$Genshagen$G6))

# Woerth ####
wartung$zip$Woerth <- dir(wd$wartung$MEG$Woerth, ".zip$", recursive = T)
wartung$zipsub$Woerth$A3 <- wartung$zip$Woerth[grep("_A3_", wartung$zip$Woerth)]
wartung$zipsub$Woerth$A5 <- wartung$zip$Woerth[grep("_A5_", wartung$zip$Woerth)]
wartung$zipsub$Woerth$A6 <- wartung$zip$Woerth[grep("_A6_", wartung$zip$Woerth)]

wartung$zipfiles$Woerth$A3 <- substr(wartung$zipsub$Woerth$A3, unlist(lapply(gregexpr("/", wartung$zipsub$Woerth$A3), max)) + 1, nchar(wartung$zipsub$Woerth$A3))
wartung$zipfiles$Woerth$A5 <- substr(wartung$zipsub$Woerth$A5, unlist(lapply(gregexpr("/", wartung$zipsub$Woerth$A5), max)) + 1, nchar(wartung$zipsub$Woerth$A5))
wartung$zipfiles$Woerth$A6 <- substr(wartung$zipsub$Woerth$A6, unlist(lapply(gregexpr("/", wartung$zipsub$Woerth$A6), max)) + 1, nchar(wartung$zipsub$Woerth$A6))


wartung$zipsub$Woerth$A3 <- wartung$zipsub$Woerth$A3[which(!is.na(as.numeric(substr(wartung$zipfiles$Woerth$A3, 1, 4))))]
wartung$zipfiles$Woerth$A3 <- wartung$zipfiles$Woerth$A3[which(!is.na(as.numeric(substr(wartung$zipfiles$Woerth$A3, 1, 4))))]

wartung$zipsub$Woerth$A5 <- wartung$zipsub$Woerth$A5[which(!is.na(as.numeric(substr(wartung$zipfiles$Woerth$A5, 1, 4))))]
wartung$zipfiles$Woerth$A5 <- wartung$zipfiles$Woerth$A5[which(!is.na(as.numeric(substr(wartung$zipfiles$Woerth$A5, 1, 4))))]

wartung$zipsub$Woerth$A6 <- wartung$zipsub$Woerth$A6[which(!is.na(as.numeric(substr(wartung$zipfiles$Woerth$A6, 1, 4))))]
wartung$zipfiles$Woerth$A6 <- wartung$zipfiles$Woerth$A6[which(!is.na(as.numeric(substr(wartung$zipfiles$Woerth$A6, 1, 4))))]


wartung$zipsub$Woerth$A3 <- wartung$zipsub$Woerth$A3[which(unlist(lapply(gregexpr("-",wartung$zipfiles$Woerth$A3), max)) >0)]
wartung$zipfiles$Woerth$A3 <- wartung$zipfiles$Woerth$A3[which(unlist(lapply(gregexpr("-",wartung$zipfiles$Woerth$A3), max)) >0)]

wartung$zipcheck$Woerth$A3 <- substr(wartung$zipfiles$Woerth$A3, unlist(lapply(gregexpr("-",wartung$zipfiles$Woerth$A3), min))+1, unlist(lapply(gregexpr("-",wartung$zipfiles$Woerth$A3), max))-1)
wartung$zipsub$Woerth$A3 <- wartung$zipsub$Woerth$A3[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$zipcheck$Woerth$A3))))))]
wartung$zipfiles$Woerth$A3 <- wartung$zipfiles$Woerth$A3[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$zipcheck$Woerth$A3))))))]


wartung$zipsub$Woerth$A5 <- wartung$zipsub$Woerth$A5[which(unlist(lapply(gregexpr("-",wartung$zipfiles$Woerth$A5), max)) >0)]
wartung$zipfiles$Woerth$A5 <- wartung$zipfiles$Woerth$A5[which(unlist(lapply(gregexpr("-",wartung$zipfiles$Woerth$A5), max)) >0)]

wartung$zipcheck$Woerth$A5 <- substr(wartung$zipfiles$Woerth$A5, unlist(lapply(gregexpr("-",wartung$zipfiles$Woerth$A5), min))+1, unlist(lapply(gregexpr("-",wartung$zipfiles$Woerth$A5), max))-1)
wartung$zipsub$Woerth$A5 <- wartung$zipsub$Woerth$A5[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$zipcheck$Woerth$A5))))))]
wartung$zipfiles$Woerth$A5 <- wartung$zipfiles$Woerth$A5[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$zipcheck$Woerth$A5))))))]


wartung$zipsub$Woerth$A6 <- wartung$zipsub$Woerth$A6[which(unlist(lapply(gregexpr("-",wartung$zipfiles$Woerth$A6), max)) >0)]
wartung$zipfiles$Woerth$A6 <- wartung$zipfiles$Woerth$A6[which(unlist(lapply(gregexpr("-",wartung$zipfiles$Woerth$A6), max)) >0)]

wartung$zipcheck$Woerth$A6 <- substr(wartung$zipfiles$Woerth$A6, unlist(lapply(gregexpr("-",wartung$zipfiles$Woerth$A6), min))+1, unlist(lapply(gregexpr("-",wartung$zipfiles$Woerth$A6), max))-1)
wartung$zipsub$Woerth$A6 <- wartung$zipsub$Woerth$A6[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$zipcheck$Woerth$A6))))))]
wartung$zipfiles$Woerth$A6 <- wartung$zipfiles$Woerth$A6[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$zipcheck$Woerth$A6))))))]

setwd(wd$wartung$MEG$Woerth)
if(!all(wartung$zipfiles$Woerth$A3 %in% dir(paste0(wd$servicebackup$MEG$Woerth$A3, "ZIP/"))) ) file.copy(wartung$zipsub$Woerth$A3, paste0(wd$servicebackup$MEG$Woerth$A3, "ZIP/", wartung$zipfiles$Woerth$A3))
if(!all(wartung$zipfiles$Woerth$A5 %in% dir(paste0(wd$servicebackup$MEG$Woerth$A5, "ZIP/"))) ) file.copy(wartung$zipsub$Woerth$A5, paste0(wd$servicebackup$MEG$Woerth$A5, "ZIP/", wartung$zipfiles$Woerth$A5))
if(!all(wartung$zipfiles$Woerth$A6 %in% dir(paste0(wd$servicebackup$MEG$Woerth$A6, "ZIP/"))) ) file.copy(wartung$zipsub$Woerth$A6, paste0(wd$servicebackup$MEG$Woerth$A6, "ZIP/", wartung$zipfiles$Woerth$A6))

# Kirkel ####
wartung$zip$Kirkel <- dir(wd$wartung$MEG$Kirkel, ".zip$", recursive = T)
wartung$zipsub$Kirkel$A4 <- wartung$zip$Kirkel

wartung$zipfiles$Kirkel$A4 <- substr(wartung$zipsub$Kirkel$A4, unlist(lapply(gregexpr("/", wartung$zipsub$Kirkel$A4), max)) + 1, nchar(wartung$zipsub$Kirkel$A4))

wartung$zipsub$Kirkel$A4 <- wartung$zipsub$Kirkel$A4[which(unlist(lapply(gregexpr("-",wartung$zipfiles$Kirkel$A4), max)) >0)]
wartung$zipfiles$Kirkel$A4 <- wartung$zipfiles$Kirkel$A4[which(unlist(lapply(gregexpr("-",wartung$zipfiles$Kirkel$A4), max)) >0)]


wartung$zipsub$Kirkel$A4 <- wartung$zipsub$Kirkel$A4[which(!is.na(as.numeric(substr(wartung$zipfiles$Kirkel$A4, 1, 4))))]
wartung$zipfiles$Kirkel$A4 <- wartung$zipfiles$Kirkel$A4[which(!is.na(as.numeric(substr(wartung$zipfiles$Kirkel$A4, 1, 4))))]


wartung$zipcheck$Kirkel$A4 <- substr(wartung$zipfiles$Kirkel$A4, unlist(lapply(gregexpr("-",wartung$zipfiles$Kirkel$A4), min))+1, unlist(lapply(gregexpr("-",wartung$zipfiles$Kirkel$A4), max))-1)
wartung$zipsub$Kirkel$A4 <- wartung$zipsub$Kirkel$A4[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$zipcheck$Kirkel$A4))))))]
wartung$zipfiles$Kirkel$A4 <- wartung$zipfiles$Kirkel$A4[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$zipcheck$Kirkel$A4))))))]

setwd(wd$wartung$MEG$Kirkel)
if(!all(wartung$zipfiles$Kirkel$A4 %in% dir(paste0(wd$servicebackup$MEG$Kirkel$A4, "ZIP/")))) file.copy(wartung$zipsub$Kirkel$A4, paste0(wd$servicebackup$MEG$Kirkel$A4, "ZIP/", wartung$zipfiles$Kirkel$A4))

# Karlsruhe ####
wartung$zip$Karlsruhe <- dir(wd$wartung$CCEP$Karlsruhe, ".zip$", recursive = T)
wartung$zipsub$Karlsruhe$LG <- wartung$zip$Karlsruhe

wartung$zipfiles$Karlsruhe$LG <- substr(wartung$zipsub$Karlsruhe$LG, unlist(lapply(gregexpr("/", wartung$zipsub$Karlsruhe$LG), max)) + 1, nchar(wartung$zipsub$Karlsruhe$LG))


wartung$zipsub$Karlsruhe$LG <- wartung$zipsub$Karlsruhe$LG[which(unlist(lapply(gregexpr("-",wartung$zipfiles$Karlsruhe$LG), max)) >0)]
wartung$zipfiles$Karlsruhe$LG <- wartung$zipfiles$Karlsruhe$LG[which(unlist(lapply(gregexpr("-",wartung$zipfiles$Karlsruhe$LG), max)) >0)]


wartung$zipsub$Karlsruhe$LG <- wartung$zipsub$Karlsruhe$LG[which(!is.na(as.numeric(substr(wartung$zipfiles$Karlsruhe$LG, 1, 4))))]
wartung$zipfiles$Karlsruhe$LG <- wartung$zipfiles$Karlsruhe$LG[which(!is.na(as.numeric(substr(wartung$zipfiles$Karlsruhe$LG, 1, 4))))]


wartung$zipcheck$Karlsruhe$LG <- substr(wartung$zipfiles$Karlsruhe$LG, unlist(lapply(gregexpr("-",wartung$zipfiles$Karlsruhe$LG), min))+1, unlist(lapply(gregexpr("-",wartung$zipfiles$Karlsruhe$LG), max))-1)
wartung$zipsub$Karlsruhe$LG <- wartung$zipsub$Karlsruhe$LG[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$zipcheck$Karlsruhe$LG))))))]
wartung$zipfiles$Karlsruhe$LG <- wartung$zipfiles$Karlsruhe$LG[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$zipcheck$Karlsruhe$LG))))))]


setwd(wd$wartung$CCEP$Karlsruhe)
if(!all(wartung$zipfiles$Karlsruhe$LG %in% dir(paste0(wd$servicebackup$CCEP$Karlsruhe$LG, "ZIP/"))) ) file.copy(wartung$zipsub$Karlsruhe$LG, paste0(wd$servicebackup$CCEP$Karlsruhe$LG, "ZIP/", wartung$zipfiles$Karlsruhe$LG))

# Nieder_Roden ####
wartung$zip$Nieder_Roden <- dir(wd$wartung$Pepsi$Nieder_Roden, ".zip$", recursive = T)
wartung$zipsub$Nieder_Roden$LG <- wartung$zip$Nieder_Roden

wartung$zipfiles$Nieder_Roden$LG <- substr(wartung$zipsub$Nieder_Roden$LG, unlist(lapply(gregexpr("/", wartung$zipsub$Nieder_Roden$LG), max)) + 1, nchar(wartung$zipsub$Nieder_Roden$LG))


wartung$zipsub$Nieder_Roden$LG <- wartung$zipsub$Nieder_Roden$LG[which(unlist(lapply(gregexpr("-",wartung$zipfiles$Nieder_Roden$LG), max)) >0)]
wartung$zipfiles$Nieder_Roden$LG <- wartung$zipfiles$Nieder_Roden$LG[which(unlist(lapply(gregexpr("-",wartung$zipfiles$Nieder_Roden$LG), max)) >0)]


wartung$zipsub$Nieder_Roden$LG <- wartung$zipsub$Nieder_Roden$LG[which(!is.na(as.numeric(substr(wartung$zipfiles$Nieder_Roden$LG, 1, 4))))]
wartung$zipfiles$Nieder_Roden$LG <- wartung$zipfiles$Nieder_Roden$LG[which(!is.na(as.numeric(substr(wartung$zipfiles$Nieder_Roden$LG, 1, 4))))]


wartung$zipcheck$Nieder_Roden$LG <- substr(wartung$zipfiles$Nieder_Roden$LG, unlist(lapply(gregexpr("-",wartung$zipfiles$Nieder_Roden$LG), min))+1, unlist(lapply(gregexpr("-",wartung$zipfiles$Nieder_Roden$LG), max))-1)
wartung$zipsub$Nieder_Roden$LG <- wartung$zipsub$Nieder_Roden$LG[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$zipcheck$Nieder_Roden$LG))))))]
wartung$zipfiles$Nieder_Roden$LG <- wartung$zipfiles$Nieder_Roden$LG[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$zipcheck$Nieder_Roden$LG))))))]

setwd(wd$wartung$Pepsi$Nieder_Roden)
if(!all(wartung$zipfiles$Nieder_Roden$LG %in% dir(paste0(wd$servicebackup$CCEP$Nieder_Roden$LG, "ZIP/"))) ) file.copy(wartung$zipsub$Nieder_Roden$LG, paste0(wd$servicebackup$Pepsi$Nieder_Roden$LG, "ZIP/", wartung$zipfiles$Nieder_Roden$LG))

# CapriSun Eppelheim ####
wartung$zip$Eppelheim <- dir(wd$wartung$CapriSun$Eppelheim, "\\.zip$", recursive = T)
wartung$zipsub$Eppelheim$TS1 <- wartung$zip$Eppelheim[c(grep("_TS1_", wartung$zip$Eppelheim), grep("_TS100_", wartung$zip$Eppelheim))]
wartung$zipsub$Eppelheim$TS2 <- wartung$zip$Eppelheim[c(grep("_TS2_", wartung$zip$Eppelheim), grep("_TS200_", wartung$zip$Eppelheim))]
wartung$zipsub$Eppelheim$TS3 <- wartung$zip$Eppelheim[c(grep("_TS3_", wartung$zip$Eppelheim), grep("_TS300_", wartung$zip$Eppelheim))]
wartung$zipsub$Eppelheim$TS4 <- wartung$zip$Eppelheim[c(grep("_TS4_", wartung$zip$Eppelheim), grep("_TS400_", wartung$zip$Eppelheim))]
wartung$zipsub$Eppelheim$TS5 <- wartung$zip$Eppelheim[c(grep("_TS5_", wartung$zip$Eppelheim), grep("_TS500_", wartung$zip$Eppelheim), grep("_SG500_", wartung$zip$Eppelheim), grep("_SG5_", wartung$zip$Eppelheim))]

wartung$zipfiles$Eppelheim$TS1 <- substr(wartung$zipsub$Eppelheim$TS1, unlist(lapply(gregexpr("/", wartung$zipsub$Eppelheim$TS1), max)) + 1, nchar(wartung$zipsub$Eppelheim$TS1))
wartung$zipfiles$Eppelheim$TS2 <- substr(wartung$zipsub$Eppelheim$TS2, unlist(lapply(gregexpr("/", wartung$zipsub$Eppelheim$TS2), max)) + 1, nchar(wartung$zipsub$Eppelheim$TS2))
wartung$zipfiles$Eppelheim$TS3 <- substr(wartung$zipsub$Eppelheim$TS3, unlist(lapply(gregexpr("/", wartung$zipsub$Eppelheim$TS3), max)) + 1, nchar(wartung$zipsub$Eppelheim$TS3))
wartung$zipfiles$Eppelheim$TS4 <- substr(wartung$zipsub$Eppelheim$TS4, unlist(lapply(gregexpr("/", wartung$zipsub$Eppelheim$TS4), max)) + 1, nchar(wartung$zipsub$Eppelheim$TS4))
wartung$zipfiles$Eppelheim$TS5 <- substr(wartung$zipsub$Eppelheim$TS5, unlist(lapply(gregexpr("/", wartung$zipsub$Eppelheim$TS5), max)) + 1, nchar(wartung$zipsub$Eppelheim$TS5))

wartung$zipsub$Eppelheim$TS1 <- wartung$zipsub$Eppelheim$TS1[which(!is.na(as.numeric(substr(wartung$zipfiles$Eppelheim$TS1, 1, 4))))]
wartung$zipfiles$Eppelheim$TS1 <- wartung$zipfiles$Eppelheim$TS1[which(!is.na(as.numeric(substr(wartung$zipfiles$Eppelheim$TS1, 1, 4))))]

wartung$zipsub$Eppelheim$TS2 <- wartung$zipsub$Eppelheim$TS2[which(!is.na(as.numeric(substr(wartung$zipfiles$Eppelheim$TS2, 1, 4))))]
wartung$zipfiles$Eppelheim$TS2 <- wartung$zipfiles$Eppelheim$TS2[which(!is.na(as.numeric(substr(wartung$zipfiles$Eppelheim$TS2, 1, 4))))]

wartung$zipsub$Eppelheim$TS3 <- wartung$zipsub$Eppelheim$TS3[which(!is.na(as.numeric(substr(wartung$zipfiles$Eppelheim$TS3, 1, 4))))]
wartung$zipfiles$Eppelheim$TS3 <- wartung$zipfiles$Eppelheim$TS3[which(!is.na(as.numeric(substr(wartung$zipfiles$Eppelheim$TS3, 1, 4))))]

wartung$zipsub$Eppelheim$TS4 <- wartung$zipsub$Eppelheim$TS4[which(!is.na(as.numeric(substr(wartung$zipfiles$Eppelheim$TS4, 1, 4))))]
wartung$zipfiles$Eppelheim$TS4 <- wartung$zipfiles$Eppelheim$TS4[which(!is.na(as.numeric(substr(wartung$zipfiles$Eppelheim$TS4, 1, 4))))]

wartung$zipsub$Eppelheim$TS5 <- wartung$zipsub$Eppelheim$TS5[which(!is.na(as.numeric(substr(wartung$zipfiles$Eppelheim$TS5, 1, 4))))]
wartung$zipfiles$Eppelheim$TS5 <- wartung$zipfiles$Eppelheim$TS5[which(!is.na(as.numeric(substr(wartung$zipfiles$Eppelheim$TS5, 1, 4))))]


wartung$zipsub$Eppelheim$TS1 <- wartung$zipsub$Eppelheim$TS1[which(unlist(lapply(gregexpr("-",wartung$zipfiles$Eppelheim$TS1), max)) >0)]
wartung$zipfiles$Eppelheim$TS1 <- wartung$zipfiles$Eppelheim$TS1[which(unlist(lapply(gregexpr("-",wartung$zipfiles$Eppelheim$TS1), max)) >0)]

wartung$zipcheck$Eppelheim$TS1 <- substr(wartung$zipfiles$Eppelheim$TS1, unlist(lapply(gregexpr("-",wartung$zipfiles$Eppelheim$TS1), min))+1, unlist(lapply(gregexpr("-",wartung$zipfiles$Eppelheim$TS1), max))-1)
wartung$zipsub$Eppelheim$TS1 <- wartung$zipsub$Eppelheim$TS1[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$zipcheck$Eppelheim$TS1))))))]
wartung$zipfiles$Eppelheim$TS1 <- wartung$zipfiles$Eppelheim$TS1[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$zipcheck$Eppelheim$TS1))))))]


wartung$zipsub$Eppelheim$TS2 <- wartung$zipsub$Eppelheim$TS2[which(unlist(lapply(gregexpr("-",wartung$zipfiles$Eppelheim$TS2), max)) >0)]
wartung$zipfiles$Eppelheim$TS2 <- wartung$zipfiles$Eppelheim$TS2[which(unlist(lapply(gregexpr("-",wartung$zipfiles$Eppelheim$TS2), max)) >0)]

wartung$zipcheck$Eppelheim$TS2 <- substr(wartung$zipfiles$Eppelheim$TS2, unlist(lapply(gregexpr("-",wartung$zipfiles$Eppelheim$TS2), min))+1, unlist(lapply(gregexpr("-",wartung$zipfiles$Eppelheim$TS2), max))-1)
wartung$zipsub$Eppelheim$TS2 <- wartung$zipsub$Eppelheim$TS2[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$zipcheck$Eppelheim$TS2))))))]
wartung$zipfiles$Eppelheim$TS2 <- wartung$zipfiles$Eppelheim$TS2[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$zipcheck$Eppelheim$TS2))))))]


wartung$zipsub$Eppelheim$TS3 <- wartung$zipsub$Eppelheim$TS3[which(unlist(lapply(gregexpr("-",wartung$zipfiles$Eppelheim$TS3), max)) >0)]
wartung$zipfiles$Eppelheim$TS3 <- wartung$zipfiles$Eppelheim$TS3[which(unlist(lapply(gregexpr("-",wartung$zipfiles$Eppelheim$TS3), max)) >0)]

wartung$zipcheck$Eppelheim$TS3 <- substr(wartung$zipfiles$Eppelheim$TS3, unlist(lapply(gregexpr("-",wartung$zipfiles$Eppelheim$TS3), min))+1, unlist(lapply(gregexpr("-",wartung$zipfiles$Eppelheim$TS3), max))-1)
wartung$zipsub$Eppelheim$TS3 <- wartung$zipsub$Eppelheim$TS3[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$zipcheck$Eppelheim$TS3))))))]
wartung$zipfiles$Eppelheim$TS3 <- wartung$zipfiles$Eppelheim$TS3[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$zipcheck$Eppelheim$TS3))))))]


wartung$zipsub$Eppelheim$TS4 <- wartung$zipsub$Eppelheim$TS4[which(unlist(lapply(gregexpr("-",wartung$zipfiles$Eppelheim$TS4), max)) >0)]
wartung$zipfiles$Eppelheim$TS4 <- wartung$zipfiles$Eppelheim$TS4[which(unlist(lapply(gregexpr("-",wartung$zipfiles$Eppelheim$TS4), max)) >0)]

wartung$zipcheck$Eppelheim$TS4 <- substr(wartung$zipfiles$Eppelheim$TS4, unlist(lapply(gregexpr("-",wartung$zipfiles$Eppelheim$TS4), min))+1, unlist(lapply(gregexpr("-",wartung$zipfiles$Eppelheim$TS4), max))-1)
wartung$zipsub$Eppelheim$TS4 <- wartung$zipsub$Eppelheim$TS4[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$zipcheck$Eppelheim$TS4))))))]
wartung$zipfiles$Eppelheim$TS4 <- wartung$zipfiles$Eppelheim$TS4[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$zipcheck$Eppelheim$TS4))))))]


wartung$zipsub$Eppelheim$TS5 <- wartung$zipsub$Eppelheim$TS5[which(unlist(lapply(gregexpr("-",wartung$zipfiles$Eppelheim$TS5), max)) >0)]
wartung$zipfiles$Eppelheim$TS5 <- wartung$zipfiles$Eppelheim$TS5[which(unlist(lapply(gregexpr("-",wartung$zipfiles$Eppelheim$TS5), max)) >0)]

wartung$zipcheck$Eppelheim$TS5 <- substr(wartung$zipfiles$Eppelheim$TS5, unlist(lapply(gregexpr("-",wartung$zipfiles$Eppelheim$TS5), min))+1, unlist(lapply(gregexpr("-",wartung$zipfiles$Eppelheim$TS5), max))-1)
wartung$zipsub$Eppelheim$TS5 <- wartung$zipsub$Eppelheim$TS5[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$zipcheck$Eppelheim$TS5))))))]
wartung$zipfiles$Eppelheim$TS5 <- wartung$zipfiles$Eppelheim$TS5[which(!is.na(as.numeric(gsub("_","",gsub(" ","",gsub("-","",wartung$zipcheck$Eppelheim$TS5))))))]

setwd(wd$wartung$CapriSun$Eppelheim)
if(!all(wartung$zipfiles$Eppelheim$TS1 %in% dir(paste0(wd$servicebackup$CapriSun$Eppelheim$TS1, "ZIP/")))) file.copy(wartung$zipsub$Eppelheim$TS1, paste0(wd$servicebackup$CapriSun$Eppelheim$TS1, "ZIP/", wartung$zipfiles$Eppelheim$TS1))
if(!all(wartung$zipfiles$Eppelheim$TS2 %in% dir(paste0(wd$servicebackup$CapriSun$Eppelheim$TS2, "ZIP/")))) file.copy(wartung$zipsub$Eppelheim$TS2, paste0(wd$servicebackup$CapriSun$Eppelheim$TS2, "ZIP/", wartung$zipfiles$Eppelheim$TS2))
if(!all(wartung$zipfiles$Eppelheim$TS3 %in% dir(paste0(wd$servicebackup$CapriSun$Eppelheim$TS3, "ZIP/")))) file.copy(wartung$zipsub$Eppelheim$TS3, paste0(wd$servicebackup$CapriSun$Eppelheim$TS3, "ZIP/", wartung$zipfiles$Eppelheim$TS3))
if(!all(wartung$zipfiles$Eppelheim$TS4 %in% dir(paste0(wd$servicebackup$CapriSun$Eppelheim$TS4, "ZIP/")))) file.copy(wartung$zipsub$Eppelheim$TS4, paste0(wd$servicebackup$CapriSun$Eppelheim$TS4, "ZIP/", wartung$zipfiles$Eppelheim$TS4))
if(!all(wartung$zipfiles$Eppelheim$TS5 %in% dir(paste0(wd$servicebackup$CapriSun$Eppelheim$SG500FS, "ZIP/")))) file.copy(wartung$zipsub$Eppelheim$TS5, paste0(wd$servicebackup$CapriSun$Eppelheim$TS5, "ZIP/", wartung$zipfiles$Eppelheim$TS5))


setwd(this.dir())
setwd("./logs")
dir.create(newwd <- as.character(gsub("[0-9.-]", "", Sys.info()["nodename"])), showWarnings = F)
setwd(this.dir())
file.copy(paste0(getwd(), "/service_copy.log")
          , paste0(getwd(), "/logs/", newwd, "/", substr(gsub("-","", lg_master$today), 3, 8), "_service_copy.log"))
file.remove(paste0(getwd(), "/service_copy.log"))
