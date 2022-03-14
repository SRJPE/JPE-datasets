library(tidyverse)
library(OSMscale)
library(readr)
# RST and gage locations
rst_sites <- readxl::read_excel("scripts/exploratory-analysis/data/JPE-rst-and-gage-sites.xlsx", sheet = "rst") %>%
  mutate(degree = degree(latitude, longitude),
         latitude = ifelse(coordinate_units == "lat/long", degree$lat, latitude), 
         longitude = ifelse(coordinate_units == "lat/long", degree$long, longitude)) %>%
  select(-degree, -coordinate_units) %>% glimpse

rst_sites
write_csv(rst_sites, "scripts/exploratory-analysis/data/rst_sites.csv")

gage_sites <- readxl::read_excel("scripts/exploratory-analysis/data/JPE-rst-and-gage-sites.xlsx", sheet = "gage")  %>% 
  group_by(identifier) %>% 
  filter(row_number() == 1) %>%
  ungroup()
gage_sites
write_csv(gage_sites, "scripts/exploratory-analysis/data/gage_sites.csv")
