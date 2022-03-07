library(tidyverse)
library(leaflet)
library(sp)

# TODO decide on information to show in popups and improve readability of map
gage_sites <- read_csv("scripts/exploratory-analysis/data/gage_sites.csv") %>%
  mutate(latitude = jitter(latitude, factor = .07),
         longitude = jitter(longitude, factor = .07))

cdec_sites <- gage_sites %>% 
  filter(gage_agency == "CDEC") 

usgs_sites <- gage_sites %>% 
  filter(gage_agency == "USGS")  

rst_sites <- read_csv("scripts/exploratory-analysis/data/rst_sites.csv") %>%
  mutate(latitude = jitter(latitude, factor = .07),
         longitude = jitter(longitude, factor = .07))

leaflet(gage_sites)  %>% 
  addProviderTiles(providers$Esri.WorldTopoMap, group = "Map") %>% 
  addCircleMarkers(data = cdec_sites,  label = cdec_sites$gage_number, 
                   weight = 1.5, color = "orange",
                   opacity =  1, fillOpacity = .25, 
                   labelOptions = labelOptions(noHide = T, # Set to F to hide labels
                                               style = list("font-size" = "14px")), 
                   popup = paste(sep = "<br/>",
                                 cdec_sites$site_name,
                                 case_when(cdec_sites$flow_gage == TRUE & 
                                             cdec_sites$temp_gage == TRUE ~ "FLow & Temp",
                                           cdec_sites$flow_gage == TRUE ~ "Flow",
                                           cdec_sites$temp_gage == TRUE ~ "Temp",
                                           TRUE ~ "No Flow or Temp Data"))
  ) %>%
  addCircleMarkers(data = usgs_sites,  label = usgs_sites$gage_number, 
                   weight = 1.5, color = "green",
                   opacity =  1, fillOpacity = .25, 
                   labelOptions = labelOptions(noHide = T, # Set to F to hide labels
                                               style = list("font-size" = "14px")), 
                   popup = paste(sep = "<br/>",
                                 usgs_sites$site_name,
                                 case_when(usgs_sites$flow_gage == TRUE & 
                                             usgs_sites$temp_gage == TRUE ~ "FLow & Temp",
                                           usgs_sites$flow_gage == TRUE ~ "Flow",
                                           usgs_sites$temp_gage == TRUE ~ "Temp",
                                           TRUE ~ "No Flow or Temp Data"))
  ) %>%
  addCircleMarkers(data = rst_sites,  label = rst_sites$site_name, 
                   weight = 1.5, color = "blue",
                   opacity =  1, fillOpacity = .25, 
                   labelOptions = labelOptions(noHide = T, # Set to F to hide labels
                                               style = list("font-size" = "14px")), 
                   popup = paste(sep = "<br/>",
                                 rst_sites$sub_site_name,
                                 paste("River Mile:", rst_sites$river_mile),
                                 paste("RST Size:", rst_sites$rst_size),
                                 paste("RST Season:", rst_sites$trapping_season))
  ) %>%
  addScaleBar()

