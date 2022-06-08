input <- list(); input$sourcep <- paste0(Sys.getenv("OneDriveCommercial"), "/FE_Methoden/")
input$linux <- F;source(paste0(input$sourcep,"Allgemein/R_dt_project/R/source_pls.R"))
input$export_directory <- paste0(wd$fe$CCEP$Mastermodelle,"Fanta_Orange_Zero//Modelloptimierung//Produktionsdaten"); setwd(input$export_directory)

# Model parameter ####
moda <- list()
moda$customer <- "CCEP"
moda$beverage <- "Fanta_Orange_Zero"
moda$LG <- "3"

# Model substance ####
model_parameter(moda$customer, moda$beverage, moda$LG)
model_parameter(moda$customer, moda$beverage, moda$LG)[ , "Parameter"]
moda$parameter <- print(model_parameter(moda$customer, moda$beverage, moda$LG)[ , "Parameter"][1])

# Model wd ####
moda$wd <- wd$mode[[grep(moda$customer, names(wd$model))]]
# setwd(moda$wd)
setwd("C:/Users/MK/Desktop")

moda$model <- use_model_on_device(moda$customer, moda$beverage, moda$LG, moda$parameter, NA, return_type = "model")

# Colp ####
head(moda$mod$csv$data)
# View(moda$mod$csv$data)

moda$colp$fac <- factor(substr(moda$mod$csv$data$Grobe.Einordnung, 1, 4))
moda$colp$lev <- levels(moda$colp$fac)
moda$colp$colp <- rainbow(length(moda$colp$lev))
moda$colp$colp2 <- moda$colp$colp[moda$colp$fac]

# Scoresplot ####

moda$PCgrid <- expand.grid(1:moda$mod$para$PC, 1:moda$mod$para$PC)
moda$PCgrid <- moda$PCgrid[-which(moda$PCgrid[,1] == moda$PCgrid[,2]) , ]
moda$PCgrid[ , c(1:2)] <- moda$PCgrid[ , c(2:1)]
moda$PCgrid <- moda$PCgrid[-which(moda$PCgrid[,2] < moda$PCgrid[,1]),]
nrow(moda$PCgrid)

png(paste0(.date()
           , "_PC", moda$mod$para$PC
           , "_", moda$mod$para$transform
           , "_", moda$mod$para$wl1
           , "_", moda$mod$para$wl2
           , "_", moda$mod$para$wl3
           , "_", moda$mod$para$wl4, "_Scores.png"), 
    width = 480 * 10, height = 480 * 6,type="cairo",units="px",pointsize=12,res=500)

explvar_y <- c(round(drop(R2(moda$mod$model, estimate = "train", intercept = FALSE)$val)*100,1)[1],
               round(diff(drop(R2(moda$mod$model, estimate = "train", intercept = FALSE)$val)*100),1))

if(moda$mod$para$PC < 4) par(mfrow = c(1,3))
if(moda$mod$para$PC < 7) par(mfrow = c(2,3))
if(moda$mod$para$PC < 11) par(mfrow = c(2,5))
if(moda$mod$para$PC < 16) par(mfrow = c(3,5))
if(moda$mod$para$PC > 15) par(mfrow = c(4,5))

par(mar = c(4,4,2,2))
for(i in 1:nrow(moda$PCgrid))
plot(moda$mod$model$scores[,moda$PCgrid[i,1]], moda$mod$model$scores[,moda$PCgrid[i,2]],
     xlab = paste0("PC",moda$PCgrid[i,1], " (",round(explvar(moda$mod$model)[moda$PCgrid[i,1]],1),"%, ", explvar_y[moda$PCgrid[i,1]],"%)"), 
     ylab = paste("PC",moda$PCgrid[i,2], "(",round(explvar(moda$mod$model)[moda$PCgrid[i,2]],1),"%, ", explvar_y[moda$PCgrid[i,2]],"%)"),
     cex = 1.0, pch = 20, col = moda$colp$colp2#main = paste("PC", moda$PCgrid[i,1], "vs PC", moda$PCgrid[i,2])
     )
dev.off()

# Loadingsplot ####
png(paste0(.date()
           , "_PC", moda$mod$para$PC
           , "_", moda$mod$para$transform
           , "_", moda$mod$para$wl1
           , "_", moda$mod$para$wl2
           , "_", moda$mod$para$wl3
           , "_", moda$mod$para$wl4, "_Loadings.png"), 
    width = 480 * 10, height = 480 * 6,type="cairo",units="px",pointsize=12,res=500)

if(moda$mod$para$PC < 4) par(mfrow = c(1,3))
if(moda$mod$para$PC == 4) par(mfrow = c(2,2))
if(moda$mod$para$PC > 4) par(mfrow = c(2,3))
if(moda$mod$para$PC > 6) par(mfrow = c(2,4))

for(i in 1:moda$mod$para$PC) plot(moda$mod$wl
                                     , moda$mod$model$loadings[,i]
                                     , type = "l", lwd = 2
                                     , lty = 1
                                     , main = paste0("Loadings PC", i)
                                     , xlab = "lambda in nm", ylab = "")
dev.off()

# Predicted_vs_Reference ####
png(paste0(.date()
           , "_PC", moda$mod$para$PC
           , "_", moda$mod$para$transform
           , "_", moda$mod$para$wl1
           , "_", moda$mod$para$wl2
           , "_", moda$mod$para$wl3
           , "_", moda$mod$para$wl4, "_pred_vs_ref.png"), 
    width = 480 * 10 / 1.25, height = 480 * 6 / 1.25,type="cairo",units="px",pointsize=12,res=500)

if(moda$mod$para$PC < 4) par(mfrow = c(1,3))
if(moda$mod$para$PC == 4) par(mfrow = c(2,2))
if(moda$mod$para$PC > 4) par(mfrow = c(2,3))
if(moda$mod$para$PC > 6) par(mfrow = c(2,4))

for(i in 1:moda$mod$para$PC) 
  plot(x <- moda$mod$model$mod$`pls$x`,
     y <- moda$mod$model$fitted.values[,,i],
     col = moda$colp$colp2, pch = 20, cex = 1.25,
     xlab = paste0("Reference Y, PC ",i),
     ylab = paste0("Predicted Y, PC ",i),
     main = paste("Predicted vs. Reference PC", i))

summary(lm(y~x))$r.squared
dev.off()

# Explained Variance ####
png(paste0(.date()
           , "_PC", moda$mod$para$PC
           , "_", moda$mod$para$transform
           , "_", moda$mod$para$wl1
           , "_", moda$mod$para$wl2
           , "_", moda$mod$para$wl3
           , "_", moda$mod$para$wl4, "_Explained_Variance.png"), 
    width = 480 * 10 / 1.25, height = 480 * 6 / 1.25,type="cairo",units="px",pointsize=12,res=500)

par(mar = c(4,5,2,1), mfrow = c(1,1))
plot(0:moda$mod$para$PC, as.numeric(c(0,drop(R2(moda$mod$model, estimate = "train", intercept = FALSE)$val)[1:moda$mod$para$PC])*100), type = "b", col ="blue", lwd = 2,
                       xlab = "Factors", ylab = "Y-Variance", main = "Explained Variance")
dev.off()


