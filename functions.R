## Custom workflow functions
## for the JAG-paper Seyfullah et al. 2026 (?)
## by Tim Brandler

p.map <- function(x = NULL, age = NULL, method = "mid", feature = "static_polygons", model = "MERDITH2021", resolution = 500000, time.data = stages){

  u.age <- vector()  
  
  ### Age  ###
  if(age %in% time.data$stage){
    u.age[1] <- time.data$top[time.data$stage == age] 
    u.age[2] <- time.data$bottom[time.data$stage == age] 
  } else if(age %in% time.data$series){
    u.age[1] <- min(time.data$top[time.data$series == age]) 
    u.age[2] <- max(time.data$bottom[time.data$series == age]) 
  } else if(age %in% time.data$system){
    u.age[1] <- min(time.data$top[time.data$system == age]) 
    u.age[2] <- max(time.data$bottom[time.data$system == age]) 
  }else stop("Check the age-string for spelling")
  
  ### Method ###
  if(startsWith(method, "m")){
    x <- x[((x$min_ma + x$max_ma)/2 <= u.age[2]) & ((x$min_ma + x$max_ma)/2 >= u.age[1]), ]
  } else if(startsWith(method, "r")){
    x <- x[(x$min_ma <= u.age[2]) & (x$max_ma >= u.age[1]), ]
  } else if(startsWith(method, "c")){
    x <- x[(x$max_ma <= u.age[2]) & (x$min_ma >= u.age[1]), ]
  } else stop("Invalid 'method'. Use 'mid', 'range' or 'complete'")
  
  ### Reconstruct  ###
  map <- rgplates::reconstruct(feature, age = mean(u.age), model = model)
  p <- rgplates::reconstruct(cbind(x$lng, x$lat), age = mean(u.age), model = model)
  
  coords <- as.data.frame(p)
  colnames(coords) <- c("lon","lat")
  coords <- coords[complete.cases(coords), ]
  
  sp_p <- terra::vect(coords, geom = c("lon", "lat"), crs = "EPSG:4326")
  
  ### Equal-area rasterization ###
  # Use Mollweide equal-area projection
  crs <- "+proj=moll +datum=WGS84"
  sp_p_eq <- terra::project(sp_p, crs)
  
  r_eq <- terra::rast(terra::ext(sp_p_eq), resolution = resolution, crs = crs)
  r_count_eq <- terra::rasterize(sp_p_eq, r_eq, fun = "count", background = 0)   # terra or raster?
 
  out <- list(
    map = map,
    points_matrix = p,
    n_NA_filtered = nrow(p) - nrow(coords),  
    sp_points = sp_p,
    raster = r_count_eq
  )
  
  return(out)
}


pal.plot <- function(x = NULL, layout = par(mfrow=c(1,1)), main = "", plot = TRUE, legend = FALSE, pt_col = "#38106Ccc", viridis = "magma", alpha = 0.8, begin = 1, end = 0, max = NULL, style = "circle", scale_factor = 0.5){
  
  map_polys <- lapply(x$map, function(poly) {
    sf::st_as_sf(as.data.frame(poly), crs = 4326)
  })
  
  # Project to Mollweide
  map_eq <- lapply(map_polys, sf::st_transform, crs = "+proj=moll +datum=WGS84")
  
  r_pts <- terra::as.points(x$raster)
  r_pts <- r_pts[r_pts[[1]] > 0, ]
  
  count_vals <- as.numeric(terra::values(r_pts)[,1])
  r_pts <- r_pts[order(count_vals), ]
  
  vals <- as.numeric(terra::values(r_pts)[,1])
  
  if(startsWith(pt_col, "vir")){
  
  pt_col <- viridis::viridis(max, alpha = alpha, begin = begin, end = end, option = viridis)[vals]  #max(vals)
  }
  
  if(plot){
    plot(map_eq[[1]]$geometry, col = "#a9a9a9cc", border = NA, main = main)
    
    if(style == "box"){
      terra::points(r_pts, col = pt_col, pch = 15, cex = 1.5)
    } else if (style == "circle"){
      # cex is proportional to the square root of values to scale by area, not diameter
      terra::points(r_pts, col = pt_col, pch = 16, cex = sqrt(vals) * scale_factor)
    }
    
    if(legend){
      col_palette <- viridis::viridis(max, alpha = 1, begin = begin, end = end, option = viridis)
      fields::image.plot(legend.only = TRUE, zlim = range(vals),
                         col = col_palette, legend.lab = "# Occurrences",
                         smallplot = c(0.85, 0.88, 0.2, 0.8))
    }
  } else {
    return(list(map_eq = map_eq, r_pts = r_pts, colors = pt_col))
  }
}

