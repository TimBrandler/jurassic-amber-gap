#libraries

library(divDyn)
#library(rgplates)
#library(terra)
#library(viridis)
#library(sf)
#library(fields)

# datas
data("stages")
source("C:/Users/tbrandler/jurassic-amber-gap/scripts/functions.R")

# Path
path <- "C:/Users/tbrandler/jurassic-amber-gap/"   # !!

#plants <- read.csv("C:/Users/tbrandler/WP1/data/plants_clean.csv") 
#coni_lookup <- read.csv(paste0(path, "/conifer_genera_done.csv"), sep = ";", header = F)
#new <- coni_lookup$V1[which(coni_lookup$V2 == "conifer")]
#gym <- plants[which(plants$phylum %in% c("Coniferophyta", "Pinophyta")),]
#gym$phylum[which(gym$genus %in% new)] <- "Coniferophyta"
#conis <- gym[which(gym$phylum == "Coniferophyta"),]
#write.csv(conis, paste0(path,"/conis.csv"))
conis <- read.csv(paste0(path, "data/conis.csv"), sep = ",", header = T) # 
### Plot
# NOTE:: Plotting is sometimes incomplete. I think it's related to how full the RStudio memory is. So maybe don't have other projects in your environment OR run in base R.

## The following plots based on midpoint of the age ranges i.e. main text figure
svg(paste0(path,"output_plots/j_coni_maps_main.svg") )
  par(mfrow=c(1,3)) ### Prepare plot margins
  par(mar = c(0,0,0,0))
  par(oma = c(0,0,0,0))
  pal.plot(p.map(conis, "Lower Jurassic", "mid"))
  pal.plot(p.map(conis, "Middle Jurassic", "mid"))
  pal.plot(p.map(conis, "Upper Jurassic", "mid"))
dev.off()


svg(paste0(path,"output_plots/j_coni_maps_supp.svg") )
  par(mfrow=c(2,3))
  par(mar = c(0,0,0,0))
  par(oma = c(0,0,0,0))
  ## This plots the supplementary figure
  pal.plot(p.map(conis, "Lower Jurassic", "complete"))
  pal.plot(p.map(conis, "Middle Jurassic", "complete"))
  pal.plot(p.map(conis, "Upper Jurassic", "complete"))
  pal.plot(p.map(conis, "Lower Jurassic", "range"))
  pal.plot(p.map(conis, "Middle Jurassic", "range"))
  pal.plot(p.map(conis, "Upper Jurassic", "range"))
dev.off()

#############################################################

m.conis <- conis[which(conis$min_ma < 225 & conis$max_ma > 125),]
m.conis <- m.conis[order(m.conis$min_ma+m.conis$max_ma),]
ej <- which(((m.conis$min_ma+m.conis$max_ma)/2) <= 201.36 & ((m.conis$min_ma+m.conis$max_ma)/2) >= 174.7 ) 
mj <- which(((m.conis$min_ma+m.conis$max_ma)/2) <= 174.7 & ((m.conis$min_ma+m.conis$max_ma)/2) >= 161.53 ) 
uj <- which(((m.conis$min_ma+m.conis$max_ma)/2) <= 161.53 & ((m.conis$min_ma+m.conis$max_ma)/2) >= 143.1 ) 

ej <- seq_along(m.conis$X)[ej]
mj <- seq_along(m.conis$X)[mj]
uj <- seq_along(m.conis$X)[uj]

col <- rep("black", length(m.conis$X))
col[ej] <- "#0261ea80"
col[mj] <- "#84cfee80"
col[uj] <- "#bbe4fa80"

svg(paste0(path,"output_plots/occ_ranges_supp.svg") )

  divDyn::tsplot(stages, shading="series" ,boxes="sys", boxes.col = "systemCol", shading.col = "#ffffff40" , xlim = c(220, 120), ylim = c(0, length(m.conis$X)), ylab = "Occurence #")
  polygon(c(stages$bottom[59], stages$bottom[63], stages$bottom[63], stages$bottom[59]), y = c(10000,10000,0,0), col = col[ej], border = NA)
  polygon(c(stages$bottom[63], stages$bottom[67], stages$bottom[67], stages$bottom[63]), y = c(10000,10000,0,0), col = col[mj], border = NA)
  polygon(c(stages$bottom[67], stages$bottom[70], stages$bottom[70], stages$bottom[67]), y = c(10000,10000,0,0), col = col[uj], border = NA)

  for (i in seq_along(m.conis$X)) {
  
    lines( x = c(m.conis$min_ma[i], m.conis$max_ma[i]), y = c(i, i), col = "#a0a0a0d0")
  }
  for (i in seq_along(m.conis$X)) {
  
    points(x = sum(m.conis$min_ma[i], m.conis$max_ma[i])/2, y = i, col = "#38106Cd0", pch = 18, cex = 0.5)
  }
dev.off()



