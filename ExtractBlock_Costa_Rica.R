.libPaths( c( "~/project/R/4.3" , .libPaths() ) )
library(sp)
library(raster)
library(sf)
library(ggplot2)
library(exactextractr)
library(terra)
library(dplyr)
library(tidyr)

bound = read_sf("./CostaRica/UGM_MGN_2022.shp")

# dir.create("./costa_rica_outputs")

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

resolution = 0.004166667
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

  tmp.bound = bound %>% as_tibble() %>% select(-geometry)
  bound_output_file = file.path("./costa_rica_outputs/", "block_level_nightlight.csv")
  write.csv(tmp.bound, bound_output_file)

  print(paste0("Completet year ", y))
  cnt = cnt + 1


}

bound = bound %>% as_tibble() %>% select(-geometry)
bound_output_file = file.path("./costa_rica_outputs/", "block_level_nightlight.csv")
write.csv(bound, bound_output_file)