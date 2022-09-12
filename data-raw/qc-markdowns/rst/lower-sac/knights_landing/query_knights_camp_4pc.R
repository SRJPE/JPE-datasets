## install.packages("RODBC")
library(RODBC)
library(tidyverse)
library(lubridate)

# Set up connection with CAMP access database 
knights_camp <- odbcConnectAccess2007(here::here("data-raw", "qc-markdowns", "rst", "lower-sac", "knights_landing", "CAMP.mdb"))

catch_raw <- sqlFetch(knights_camp, "CatchRaw") 
trap_visit <- sqlFetch(knights_camp, "TrapVisit")
mark <-  sqlFetch(knights_camp, tables = "MarkExisting")
# might be able to pull some information from 2016, 2021, 2022
release <- sqlFetch(knights_camp, tables = "Release")
# no helpful information in this table
release_fish <- sqlFetch(knights_camp, tables = "ReleaseFish")
environmental <- sqlFetch(knights_camp, tables = "EnvDataRaw")

# pull lookup tables
visit_type_lu <- sqlFetch(knights_camp, "luVisitType") %>% 
  select(-activeID) %>%glimpse

run_lu <- sqlFetch(knights_camp, "luRun") %>% 
  select(-activeID) %>% glimpse

run_method_lu <- sqlFetch(knights_camp, "luRunMethod") %>% 
  select(-activeID) %>% glimpse

lifestage_lu <- sqlFetch(knights_camp, "luLifeStage") %>% 
  select(-activeID) %>% glimpse

taxon_lu <-  sqlFetch(knights_camp, "luTaxon") %>% 
  mutate(taxonID = as.numeric(taxonID)) %>% 
  select(taxonID, commonName) %>% glimpse

origin_lu <-  sqlFetch(knights_camp, "luFishOrigin") %>% 
  select(-activeID) %>% glimpse

debris_volume_lu <- sqlFetch(knights_camp,  "luDebrisVolumeCat") %>% 
  select(-activeID) %>% 
  glimpse

trap_function_lu <- sqlFetch(knights_camp, "luTrapFunctioning") %>%
  select(-activeID) %>% 
  glimpse

processed_lu <- sqlFetch(knights_camp, "luFishProcessed") %>%
  select(-activeID) %>% 
  glimpse

subsite_lu <- sqlFetch(knights_camp, "SubSite") %>% 
  select(subSiteName, subSiteID, siteID) %>% 
  filter(subSiteName != "N/A")

site_lu <- sqlFetch(knights_camp, "Site") %>% 
  select(siteName, siteID)

sample_gear_lu <- sqlFetch(knights_camp, "luSampleGear") %>% 
  select(-activeID) %>% glimpse()

no_yes_lu <- sqlFetch(knights_camp, "luNoYes")

# lookups for existing mark
color_lu <- sqlFetch(knights_camp, "luColor") %>%
  select(-activeID) %>% glimpse()

mark_type_lu <- sqlFetch(knights_camp, "luMarkType") %>%
  select(-activeID) %>% glimpse()

body_part_lu <- sqlFetch(knights_camp, "luBodyPart") %>%
  select(-activeID) %>% glimpse()

# lookups for releases
release_purpose_lu <- sqlFetch(knights_camp, "luReleasePurpose") %>% 
  select(-activeID) %>% glimpse()

light_condition_lu <- sqlFetch(knights_camp, "luLightCondition") %>% 
  select(-activeID) %>% glimpse()

unit_lu <- sqlFetch(knights_camp, "luUnit") %>% 
  select(-activeID) %>% glimpse()