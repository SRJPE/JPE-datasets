## install.packages("RODBC")
library(RODBC)
library(tidyverse)
library(lubridate)

# Set up connection with CAMP access database 
butte_camp <- odbcConnectAccess2007(here::here("data-raw", "qc-markdowns", "rst", "butte-creek", "CAMP.mdb"))

catch_raw <- sqlFetch(butte_camp, "CatchRaw") 
trap_visit <- sqlFetch(butte_camp, "TrapVisit")
mark <-  sqlFetch(butte_camp,  "MarkExisting")
# might be able to pull some information from 2016, 2021, 2022
release <- sqlFetch(butte_camp,  "Release")
# no helpful information in this table
release_fish <- sqlFetch(butte_camp,  "ReleaseFish")
environmental <- sqlFetch(butte_camp,  "EnvDataRaw")
mark_applied <- sqlFetch(butte_camp, "MarkApplied")
# pull lookup tables
visit_type_lu <- sqlFetch(butte_camp, "luVisitType") %>% 
  select(-activeID) %>%glimpse

run_lu <- sqlFetch(butte_camp, "luRun") %>% 
  select(-activeID) %>% glimpse

run_method_lu <- sqlFetch(butte_camp, "luRunMethod") %>% 
  select(-activeID) %>% glimpse

lifestage_lu <- sqlFetch(butte_camp, "luLifeStage") %>% 
  select(-activeID) %>% glimpse

taxon_lu <-  sqlFetch(butte_camp, "luTaxon") %>% 
  mutate(taxonID = as.numeric(taxonID)) %>% 
  select(taxonID, commonName) %>% glimpse

origin_lu <-  sqlFetch(butte_camp, "luFishOrigin") %>% 
  select(-activeID) %>% glimpse

debris_volume_lu <- sqlFetch(butte_camp,  "luDebrisVolumeCat") %>% 
  select(-activeID) %>% 
  glimpse

trap_function_lu <- sqlFetch(butte_camp, "luTrapFunctioning") %>%
  select(-activeID) %>% 
  glimpse

processed_lu <- sqlFetch(butte_camp, "luFishProcessed") %>%
  select(-activeID) %>% 
  glimpse

subsite_lu <- sqlFetch(butte_camp, "SubSite") %>% 
  select(subSiteName, subSiteID, siteID) %>% 
  filter(subSiteName != "N/A")

site_lu <- sqlFetch(butte_camp, "Site") %>% 
  select(siteName, siteID)

sample_gear_lu <- sqlFetch(butte_camp, "luSampleGear") %>% 
  select(-activeID) %>% glimpse()

no_yes_lu <- sqlFetch(butte_camp, "luNoYes")

# lookups for existing mark
color_lu <- sqlFetch(butte_camp, "luColor") %>%
  select(-activeID) %>% glimpse()

mark_type_lu <- sqlFetch(butte_camp, "luMarkType") %>%
  select(-activeID) %>% glimpse()

body_part_lu <- sqlFetch(butte_camp, "luBodyPart") %>%
  select(-activeID) %>% glimpse()

# lookups for releases
release_purpose_lu <- sqlFetch(butte_camp, "luReleasePurpose") %>% 
  select(-activeID) %>% glimpse()

light_condition_lu <- sqlFetch(butte_camp, "luLightCondition") %>% 
  select(-activeID) %>% glimpse()

unit_lu <- sqlFetch(butte_camp, "luUnit") %>% 
  select(-activeID) %>% glimpse()