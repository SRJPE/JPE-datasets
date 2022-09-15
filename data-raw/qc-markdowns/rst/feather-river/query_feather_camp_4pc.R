# install.packages("RODBC")
library(RODBC)
library(tidyverse)
library(lubridate)

# Set up connection with CAMP access database 
feather_camp <- odbcConnectAccess2007(here::here("data-raw", "qc-markdowns", "rst", "feather-river", "CAMP.mdb"))

catch_raw <- sqlFetch(feather_camp, "CatchRaw") 
trap_visit <- sqlFetch(feather_camp, "TrapVisit")
mark <-  sqlFetch(feather_camp, "MarkExisting")
# might be able to pull some information from 2016, 2021, 2022
release <- sqlFetch(feather_camp, "Release")
# no helpful information in this table
release_fish <- sqlFetch(feather_camp, "ReleaseFish")
environmental <- sqlFetch(feather_camp, "EnvDataRaw")

# pull lookup tables
visit_type_lu <- sqlFetch(feather_camp, "luVisitType") %>% 
  select(-activeID) %>%glimpse

run_lu <- sqlFetch(feather_camp, "luRun") %>% 
  select(-activeID) %>% glimpse

run_method_lu <- sqlFetch(feather_camp, "luRunMethod") %>% 
  select(-activeID) %>% glimpse

lifestage_lu <- sqlFetch(feather_camp, "luLifeStage") %>% 
  select(-activeID) %>% glimpse

taxon_lu <-  sqlFetch(feather_camp, "luTaxon") %>% 
  mutate(taxonID = as.numeric(taxonID)) %>% 
  select(taxonID, commonName) %>% glimpse

origin_lu <-  sqlFetch(feather_camp, "luFishOrigin") %>% 
  select(-activeID) %>% glimpse

debris_volume_lu <- sqlFetch(feather_camp,  "luDebrisVolumeCat") %>% 
  select(-activeID) %>% 
  glimpse

trap_function_lu <- sqlFetch(feather_camp, "luTrapFunctioning") %>%
  select(-activeID) %>% 
  glimpse

processed_lu <- sqlFetch(feather_camp, "luFishProcessed") %>%
  select(-activeID) %>% 
  glimpse

subsite_lu <- sqlFetch(feather_camp, "SubSite") %>% 
  select(subSiteName, subSiteID, siteID) %>% 
  filter(subSiteName != "N/A")

site_lu <- sqlFetch(feather_camp, "Site") %>% 
  select(siteName, siteID)

sample_gear_lu <- sqlFetch(feather_camp, "luSampleGear") %>% 
  select(-activeID) %>% glimpse()

no_yes_lu <- sqlFetch(feather_camp, "luNoYes")

# lookups for existing mark
color_lu <- sqlFetch(feather_camp, "luColor") %>%
  select(-activeID) %>% glimpse()

mark_type_lu <- sqlFetch(feather_camp, "luMarkType") %>%
  select(-activeID) %>% glimpse()

body_part_lu <- sqlFetch(feather_camp, "luBodyPart") %>%
  select(-activeID) %>% glimpse()

# lookups for releases
release_purpose_lu <- sqlFetch(feather_camp, "luReleasePurpose") %>% 
  select(-activeID) %>% glimpse()

light_condition_lu <- sqlFetch(feather_camp, "luLightCondition") %>% 
  select(-activeID) %>% glimpse()

unit_lu <- sqlFetch(feather_camp, "luUnit") %>% 
  select(-activeID) %>% glimpse()