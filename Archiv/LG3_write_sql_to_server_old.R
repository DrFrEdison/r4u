














# dir()
# csv_file <- "210420_ccep_dor_dc_dark_ref.csv"
# LG3_transform_SQL_update_to_csv(csv_file = csv_file, file_directory = targetdir);if(input$entertain==T){ play.audioSample(.entertainment$alarm);plot(.entertainment$alarm_image,axes=F);suppressMessages(.breakfun(5))};setwd(targetdir)
# 
# csv_file <- "210420_ccep_dor_dc_spc.csv"
# LG3_transform_SQL_update_to_csv(csv_file = csv_file, file_directory = targetdir);if(input$entertain==T){ play.audioSample(.entertainment$alarm);plot(.entertainment$alarm_image,axes=F);suppressMessages(.breakfun(5))}
# 
# 
# .opendir(targetdir)
# #
















# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# csv_file <- "210420_ccep_dor_dc_spc.csv"
# csv_filep <- read.csv2(csv_file, nrows = 1)
# ncol(csv_filep)
# 
# 
# dir()
# 
# 
# 
# # Mannheim ####
# input$location <- "Mannheim"
# input$unit <- "MY"
# file_directory <- .sql_path(input$customer,input$location,input$unit);
# 
# setwd(file_directory);dir()
# 
# # Dark und Ref
# csv_file <- c("210406_man_my_dark_ref.csv")
# sqlquestion <- "dark_ref"
# LG3_transform_SQL_update_to_csv(csv_file = csv_file, sqlquestion = sqlquestion, file_directory = file_directory);if(input$entertain==T){ play.audioSample(.entertainment$alarm);plot(.entertainment$alarm_image,axes=F);suppressMessages(.breakfun(5))}
# 
# # SPC #
# csv_file <- c("210406_man_my_spc.csv")
# sqlquestion <- "production"
# LG3_transform_SQL_update_to_csv(csv_file = csv_file, sqlquestion = sqlquestion, file_directory = file_directory);if(input$entertain==T){ play.audioSample(.entertainment$alarm);plot(.entertainment$alarm_image,axes=F);suppressMessages(.breakfun(5))}
# 
# # Moenchengladbach ####
# input$location <- "Moenchengladbach"
# input$unit <- "G9"
# file_directory <- .sql_path(input$customer,input$location,input$unit); 
# 
# setwd(file_directory);dir()
# # Dark und Ref
# csv_file <- c("210409_ccep_mog_g9_dark_ref.csv")
# sqlquestion <- "dark_ref"
# LG3_transform_SQL_update_to_csv(csv_file = csv_file, sqlquestion = sqlquestion, file_directory = file_directory);if(input$entertain==T){ play.audioSample(.entertainment$alarm);plot(.entertainment$alarm_image,axes=F);suppressMessages(.breakfun(5))}
# 
# # SPC #
# csv_file <- c("210409_ccep_mog_g9_spc.csv")
# sqlquestion <- "production"
# LG3_transform_SQL_update_to_csv(csv_file = csv_file, sqlquestion = sqlquestion, file_directory = file_directory);if(input$entertain==T){ play.audioSample(.entertainment$alarm);plot(.entertainment$alarm_image,axes=F);suppressMessages(.breakfun(5))}
# 
# # Dorsten DS ####
# input$location <- "Dorsten"
# input$unit <- "DS"
# file_directory <- .sql_path(input$customer,input$location,input$unit); 
# 
# setwd(file_directory);dir()
# 
# # Dark und Ref
# csv_file <- c("210409_dorsten_ds_ref_dark.csv")
# sqlquestion <- "dark_ref"
# LG3_transform_SQL_update_to_csv(csv_file = csv_file, sqlquestion = sqlquestion, file_directory = file_directory);if(input$entertain==T){ play.audioSample(.entertainment$alarm);plot(.entertainment$alarm_image,axes=F);suppressMessages(.breakfun(5))}
# 
# # SPC #
# csv_file <- c("210409_dorsten_ds_spc.csv")
# sqlquestion <- "production"
# LG3_transform_SQL_update_to_csv(csv_file = csv_file, sqlquestion = sqlquestion, file_directory = file_directory);if(input$entertain==T){ play.audioSample(.entertainment$alarm);plot(.entertainment$alarm_image,axes=F);suppressMessages(.breakfun(5))}
# 
# # Dorsten DC ####
# input$location <- "Dorsten"
# input$unit <- "DC"
# file_directory <- .sql_path(input$customer,input$location,input$unit); 
# 
# setwd(file_directory);dir()
# 
# # Dark und Ref
# csv_file <- c("210409_ccep_dor_dc_dark_ref.csv")
# sqlquestion <- "dark_ref"
# LG3_transform_SQL_update_to_csv(csv_file = csv_file, sqlquestion = sqlquestion, file_directory = file_directory);if(input$entertain==T){ play.audioSample(.entertainment$alarm);plot(.entertainment$alarm_image,axes=F);suppressMessages(.breakfun(5))}
# 
# # SPC #
# csv_file <- c("210409_ccep_dor_dc_spc.csv")
# sqlquestion <- "production"
# LG3_transform_SQL_update_to_csv(csv_file = csv_file, sqlquestion = sqlquestion, file_directory = file_directory);if(input$entertain==T){ play.audioSample(.entertainment$alarm);plot(.entertainment$alarm_image,axes=F);suppressMessages(.breakfun(5))}