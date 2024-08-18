.libPaths( c( "~/project/R/4.3" , .libPaths() ) )
library(sp)
library(raster)
library(sf)
library(ggplot2)
library(exactextractr)
library(terra)
library(dplyr)
library(tidyr)

## Unzip the files
# zipF = list.files(path = "./889463807469_s/", pattern = "*.zip", full.names = TRUE)
# for (f in zipF) {
#   outF = gsub(".zip", "/", f)
#   unzip(f, exdir = outF)
# }

# zipF = list.files(path = "./889463807469_s/", pattern = "*.zip", full.names = FALSE)
# for (f in zipF) {
#   outF = gsub(".zip", "/", f)
#   dir.create(file.path("./outputs/", outF))
# }

## Prepare the files list
files = c("./VNL_v21_npp_201204-201212_global_vcmcfg_c202205302300.average_masked.dat.tif",
            "./VNL_v21_npp_2013_global_vcmcfg_c202205302300.average_masked.dat.tif",
             "./VNL_v21_npp_2014_global_vcmslcfg_c202205302300.average_masked.dat.tif",
             "./VNL_v21_npp_2015_global_vcmslcfg_c202205302300.average_masked.dat.tif",
             "./VNL_v21_npp_2016_global_vcmslcfg_c202205302300.average_masked.dat.tif",
             "./VNL_v21_npp_2017_global_vcmslcfg_c202205302300.average_masked.dat.tif",
             "./VNL_v21_npp_2018_global_vcmslcfg_c202205302300.average_masked.dat.tif",
             "./VNL_v21_npp_2019_global_vcmslcfg_c202205302300.average_masked.dat.tif",
             "./VNL_v21_npp_2020_global_vcmslcfg_c202205302300.average_masked.dat.tif",
             "./VNL_v21_npp_2021_global_vcmslcfg_c202205302300.average_masked.dat.tif",
             "./VNL_v22_npp-j01_2022_global_vcmslcfg_c202303062300.average_masked.dat.tif",
             "./VNL_npp_2023_global_vcmslcfg_v2_c202402081600.average_masked.dat.tif")

years = c("2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "2021", "2022", "2023")
bound_files = unlist(list.files(path = "./889463807469_s/", pattern = "*.zip", full.names = TRUE))
for (i in 1:length(bound_files)) {
  bound_files[i] = gsub(".zip", "/", bound_files[i])
}

## Main function
resolution = 0.004166667
for (b in bound_files) {
  if (basename(b) == "MG_2020_Integrado") {
    code = "00"
  }
  else {
    code = unlist(strsplit(basename(b), '_'))[1]  
  }
  
  if (as.integer(code) == 0) {
    next
  }
  bound = read_sf(file.path(b, paste0("conjunto_de_datos/",code,"l.shp")))

  cnt = 1
  for (f in files) {
    y = years[cnt]
    wgs84 <- "+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +no_defs"
    rast = raster(f)
    projection(rast) <- CRS(wgs84)
    
    bound = st_transform(bound, crs = st_crs(rast))
    column_name = paste0("nightlight_", y)
    bound[[column_name]] = NA
    n = nrow(bound)
    for (i in 1:n) {
      test_bound = bound[i,]
      x_min = st_bbox(test_bound)[1] - resolution
      y_min = st_bbox(test_bound)[2] - resolution
      x_max = st_bbox(test_bound)[3] + resolution
      y_max = st_bbox(test_bound)[4] + resolution
      rast_bound = crop(rast, extent(x_min, x_max, y_min, y_max))
      nl = exact_extract(rast_bound, test_bound, 'mean')
      bound[i, column_name] = nl
    }
  
    print(paste0("Completet year ", y, "for ", basename(b)))
    cnt = cnt + 1 
    
  }
  
  bound = bound %>% as_tibble() %>% select(-geometry)
  
  bound_output_file = file.path("./outputs/", basename(b), "loc_level_nightlight.csv")
  write.csv(bound, bound_output_file)
}
