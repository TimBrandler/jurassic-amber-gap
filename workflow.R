#libraries

library(divDyn)
#library(rgplates)
#library(terra)
#library(viridis)
#library(sf)
#library(fields)

# datas
data("stages")

# Path
path <- "C:/Users/tbrandler/j_amber_gap/"   # !!

#plants <- read.csv("C:/Users/tbrandler/WP1/data/plants_clean.csv")
#coni_lookup <- read.csv(paste0(path, "/conifer_genera_done.csv"), sep = ";", header = F)
#new <- coni_lookup$V1[which(coni_lookup$V2 == "conifer")]
#gym <- plants[which(plants$phylum %in% c("Coniferophyta", "Pinophyta")),]
#gym$phylum[which(gym$genus %in% new)] <- "Coniferophyta"
#conis <- gym[which(gym$phylum == "Coniferophyta"),]
#write.csv(conis, paste0(path,"/conis.csv"))
conis <- read.csv(paste0(path, "/conis.csv"), sep = ",", header = T)
m.conis <- conis[which(conis$min_ma < 237 & conis$max_ma > 100.500),]

### Get Equal Area bins + sample sizes within
### Prepare plot margins

par(mfrow=c(1,3))
par(mar = c(0,0,0,0))
par(oma = c(0,0,0,0))

### Plot
# NOTE:: Plotting is sometimes incomplete. I think it's related to how full the RStudio memory is. So maybe don't have other projects in your environment OR run in base R.

## The following plots based on midpoint of the age ranges i.e. main text figure
pal.plot(p.map(m.conis, "Lower Jurassic", "mid"))
pal.plot(p.map(m.conis, "Middle Jurassic", "mid"))
pal.plot(p.map(m.conis, "Upper Jurassic", "mid"))

par(mfrow=c(2,3))
par(mar = c(0,0,0,0))
par(oma = c(0,0,0,0))
## This plots the supplementary figure
pal.plot(p.map(m.conis, "Lower Jurassic", "complete"))
pal.plot(p.map(m.conis, "Middle Jurassic", "complete"))
pal.plot(p.map(m.conis, "Upper Jurassic", "complete"))
pal.plot(p.map(m.conis, "Lower Jurassic", "range"))
pal.plot(p.map(m.conis, "Middle Jurassic", "range"))
pal.plot(p.map(m.conis, "Upper Jurassic", "range"))

#############################################################

par(mfrow = c(1,1))
par(mar=c(5,4,4,1)+0.1)

col <- rep("black", length(m.conis$X))

divDyn::tsplot(stages, shading="series" ,boxes="sys", boxes.col = "systemCol", xlim = c(240, 110), ylim = c(0, length(m.conis$X)))
m.conis <- m.conis[order(m.conis$min_ma+m.conis$max_ma),]
ej <- which(((m.conis$min_ma+m.conis$max_ma)/2) <= 201.36 & ((m.conis$min_ma+m.conis$max_ma)/2) >= 174.7 ) 
mj <- which(((m.conis$min_ma+m.conis$max_ma)/2) <= 174.7 & ((m.conis$min_ma+m.conis$max_ma)/2) >= 161.53 ) 
uj <- which(((m.conis$min_ma+m.conis$max_ma)/2) <= 161.53 & ((m.conis$min_ma+m.conis$max_ma)/2) >= 143.1 ) 

ej <- seq_along(m.conis$X)[ej]
mj <- seq_along(m.conis$X)[mj]
uj <- seq_along(m.conis$X)[uj]

col[ej] <- "#0261ea"
col[mj] <- "#84cfee"
col[uj] <- "#bbe4fa"

for (i in seq_along(m.conis$X)) {
  
  lines( x = c(m.conis$min_ma[i], m.conis$max_ma[i]), y = c(i, i), col = col[i])
}



