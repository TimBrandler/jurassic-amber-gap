# Workflow script
# This should only require clicking the "source" button
# If not please raise an issue

#libraries
install.packages("rgplates", "terra", "sf", "divDyn", "here")

path <- here::here() 
source(paste0(path,"/scripts/functions.R"))

# datas
library(divDyn)
data("stages")

# Path
conis <- read.csv(paste0(path, "/data/conis.csv"), sep = ",", header = T) # 
### Plot
# NOTE:: If some of the plotted symbols (usually circle or square) look cut off, try again with an empty environment or in base R.

scale_factor <- 0.3

## The following plots based on midpoint of the age ranges i.e. main text figure
svg(paste0(path,"/output_plots/j_coni_map_raw.svg") )
   ### Prepare plot margins and layout
  layout(matrix(c(1, 2, 3, 4), nrow = 1), widths = c(2, 2, 2, 1))
  par(mar = c(0,0,0,0))
  par(oma = c(0,0,0,0))
  pal.plot(p.map(conis, "Lower Jurassic", "mid", resolution = 1e6), scale_factor = scale_factor)
  pal.plot(p.map(conis, "Middle Jurassic", "mid", resolution = 1e6), scale_factor = scale_factor)
  pal.plot(p.map(conis, "Upper Jurassic", "mid", resolution = 1e6), scale_factor = scale_factor)
  plot.new()
    legend(
    "center",
    legend = c("1", "10", "50", "100"),
    col = "#38106Ca0",
    pch = 16,
    pt.cex = sqrt(c(1, 10, 50, 100)) * scale_factor,
    title = "# Occurrences",
    bty = "n"
  )
dev.off()

# =============================================================================================
## The following produces the plots based on the other two methods. i.e the supplementary plots

svg(paste0(path,"output_plots/supp_map_raw.svg") )
layout(matrix(c(1, 2, 3, 4, 5, 6, 7, 8), nrow = 2), widths = c(2, 2, 2, 1, 2, 2, 2,1))
par(mar = c(0,0,0,0))
par(oma = c(0,0,0,0))
pal.plot(p.map(conis, "Lower Jurassic", "complete"), scale_factor = scale_factor)
pal.plot(p.map(conis, "Lower Jurassic", "range"), scale_factor = scale_factor)
pal.plot(p.map(conis, "Middle Jurassic", "complete"), scale_factor = scale_factor)
pal.plot(p.map(conis, "Middle Jurassic", "range"), scale_factor = scale_factor)
pal.plot(p.map(conis, "Upper Jurassic", "complete"), scale_factor = scale_factor)
pal.plot(p.map(conis, "Upper Jurassic", "range"), scale_factor = scale_factor)
plot.new()
legend(
  "center",
  legend = c("1", "10", "50", "100"),
  col = "#38106Ca0",
  pch = 16,
  pt.cex = sqrt(c(1, 10, 50, 100)) * scale_factor,
  title = "# Occurrences",
  bty = "n"
)
dev.off()

# ======================================================================
## This chunk produces the other supplementary plot

m.conis <- conis[which(conis$min_ma < 225 & conis$max_ma > 125),]
m.conis <- m.conis[order(m.conis$min_ma+m.conis$max_ma),]
# ===============================================================================
# This bit is from an earlier version that I wanted to keep somewhere, just in case it becomes handy 
#ej <- which(((m.conis$min_ma+m.conis$max_ma)/2) <= 201.36 & ((m.conis$min_ma+m.conis$max_ma)/2) >= 174.7 ) 
#mj <- which(((m.conis$min_ma+m.conis$max_ma)/2) <= 174.7 & ((m.conis$min_ma+m.conis$max_ma)/2) >= 161.53 ) 
#uj <- which(((m.conis$min_ma+m.conis$max_ma)/2) <= 161.53 & ((m.conis$min_ma+m.conis$max_ma)/2) >= 143.1 ) 
#ej <- seq_along(m.conis$X)[ej]
#mj <- seq_along(m.conis$X)[mj]
#uj <- seq_along(m.conis$X)[uj]
#col <- rep("black", length(m.conis$X))
#col[ej] <- "#0261ea80"
#col[mj] <- "#84cfee80"
#col[uj] <- "#bbe4fa80"
# ============================================================================================0
ej <- "#0261ea80"
mj <- "#84cfee80"
uj <- "#bbe4fa80"

svg(paste0(path,"output_plots/occ_ranges_supp.svg") )

  divDyn::tsplot(stages, shading="series" ,boxes="sys", boxes.col = "systemCol", shading.col = "#ffffff40" , xlim = c(220, 120), ylim = c(0, length(m.conis$X)), ylab = "Occurrence #", plot.args = list(cex.axis = 1.2, cex.lab = 1.2))
  polygon(c(stages$bottom[59], stages$bottom[63], stages$bottom[63], stages$bottom[59]), y = c(10000,10000,0,0), col = ej, border = NA)
  polygon(c(stages$bottom[63], stages$bottom[67], stages$bottom[67], stages$bottom[63]), y = c(10000,10000,0,0), col = mj, border = NA)
  polygon(c(stages$bottom[67], stages$bottom[70], stages$bottom[70], stages$bottom[67]), y = c(10000,10000,0,0), col = uj, border = NA)

  for (i in seq_along(m.conis$X)) {
  
    lines( x = c(m.conis$min_ma[i], m.conis$max_ma[i]), y = c(i, i), col = "#A6A6A6")
  }
  for (i in seq_along(m.conis$X)) {
  
    points(x = sum(m.conis$min_ma[i], m.conis$max_ma[i])/2, y = i, col = "#38106C", pch = 18, cex = 0.5)
  }
dev.off()