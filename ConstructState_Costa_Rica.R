library(sp)
library(raster)
library(sf)
library(ggplot2)
library(exactextractr)
library(terra)
library(dplyr)
library(tidyr)
sf_use_s2(FALSE)

nl.d = read.csv("./costa_rica_outputs/block_level_nightlight.csv")
nl.d = nl.d %>% select(-c(X))

state.nl.d = nl.d %>% select(-c(ID, NOMB_UGEP, NOMB_UGEC, NOMB_UGED, FUENTE, FECHA_ACTU, ID_MGN)) %>%
  group_by(COD_UGED)%>%
  summarise(nightlight_2012 = sum(nightlight_2012 * AREA_M2) / sum(AREA_M2),
            nightlight_2013 = sum(nightlight_2013 * AREA_M2) / sum(AREA_M2),
            nightlight_2014 = sum(nightlight_2014 * AREA_M2) / sum(AREA_M2),
            nightlight_2015 = sum(nightlight_2015 * AREA_M2) / sum(AREA_M2),
            nightlight_2016 = sum(nightlight_2016 * AREA_M2) / sum(AREA_M2),
            nightlight_2017 = sum(nightlight_2017 * AREA_M2) / sum(AREA_M2),
            nightlight_2018 = sum(nightlight_2018 * AREA_M2) / sum(AREA_M2),
            nightlight_2019 = sum(nightlight_2019 * AREA_M2) / sum(AREA_M2),
            nightlight_2020 = sum(nightlight_2020 * AREA_M2) / sum(AREA_M2),
            nightlight_2021 = sum(nightlight_2021 * AREA_M2) / sum(AREA_M2),
            nightlight_2022 = sum(nightlight_2022 * AREA_M2) / sum(AREA_M2),
            nightlight_2023 = sum(nightlight_2023 * AREA_M2) / sum(AREA_M2),
            AREA_M2 = sum(AREA_M2))

bound_output_file = file.path("./costa_rica_outputs/", "state_level_nightlight.csv")
write.csv(state.nl.d, bound_output_file)
