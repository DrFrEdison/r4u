library(taskscheduleR)
library(r4dt)
dt <- list()
dt$R <- "D://OneDrive - Dausch Technologies GmbH//FE_Methoden//Allgemein//r4u"

service_email <- paste0(dt$R, "/service_email_LG2.R")
taskscheduler_create(taskname = "DT_R_LG2_Read_Email", rscript = service_email,
                     schedule = "DAILY", starttime = "05:00")

service_copy <- paste0(dt$R, "/service_copy.R")
taskscheduler_create(taskname = "DT_R_Wartung_Copy", rscript = service_copy,
                     schedule = "WEEKLY", starttime = "22:30")

unzip_R <- paste0(dt$R, "/unzip_LG2.R")
taskscheduler_create(taskname = "DT_R_LG2_Unzip", rscript = unzip_R,
                     schedule = "DAILY", starttime = "23:00")
taskscheduler_create(taskname = "DT_R_LG2_Unzip_email", rscript = unzip_R,
                     schedule = "DAILY", starttime = "06:30")


# tasks <- taskscheduler_ls()
# grep("DT_", tasks$Aufgabenname, value = T)
# tasks[grep("DT_", tasks$Aufgabenname, value = F) , ]
# taskscheduler_delete("DT_R_LG2_Read_Email")
# taskscheduler_delete("DT_R_Wartung_Copy")
# taskscheduler_delete("DT_R_LG2_Unzip")
# taskscheduler_delete("DT_R_LG2_Unzip_email")
# taskscheduler_delete("DT_R_LG2_Read_Email_log")
# taskscheduler_delete("DT_R_LG2_Read_Email_ONCE")

# service_email <- paste0(dt$R, "/service_email_LG2.R")
# taskscheduler_delete("DT_R_LG2_Read_Email_ONCE")
# taskscheduler_create(taskname = "DT_R_LG2_Read_Email_ONCE", rscript = service_email,
#                     schedule = "ONCE")
