library(tidyverse)
library(readr)
# RST and gage locations
sheets <- readxl::excel_sheets("analysis/exploratory-analysis/data-raw/JPE-rst-and-gage-sites.xlsx")
rst_years <- readxl::read_excel("analysis/exploratory-analysis/data-raw/JPE-rst-and-gage-sites.xlsx", sheet = "rst_year_lookup")

rst_sites <- readxl::read_excel("analysis/exploratory-analysis/data-raw/JPE-rst-and-gage-sites.xlsx", sheet = "rst") %>%
  # mutate(
  #   degree = degree(latitude, longitude),
  #        latitude = ifelse(coordinate_units == "lat/long", degree$lat, latitude), 
  #        longitude = ifelse(coordinate_units == "lat/long", degree$long, longitude)) %>%
  select(-coordinate_units) %>% 
  left_join(rst_years) %>% glimpse

rst_sites$site_name

write_csv(rst_sites, "analysis/exploratory-analysis/data-raw/rst_sites.csv")

gage_years <- readxl::read_excel("analysis/exploratory-analysis/data-raw/JPE-rst-and-gage-sites.xlsx", sheet = "gage_year_lookup")

gage_sites <- readxl::read_excel("analysis/exploratory-analysis/data-raw/JPE-rst-and-gage-sites.xlsx", sheet = "gage")  %>% 
  group_by(identifier) %>% 
  filter(row_number() == 1) %>%
  left_join(gage_years) %>%
  ungroup()
gage_sites
write_csv(gage_sites, "analysis/exploratory-analysis/data-raw/gage_sites.csv")
