library(tidyverse)
library(knitr)
library(Hmisc)
library(lubridate)

knights_camp <- here::here("data-raw", "qc-markdowns", "rst", "lower-sac", "knights_landing", "CAMP.mdb")
mdb.get(knights_camp, tables = T)

catch_raw <- mdb.get(knights_camp, tables = "CatchRaw")
trap_visit <- mdb.get(knights_camp, tables = "TrapVisit")
mark <-  mdb.get(knights_camp, tables = "MarkExisting")
# might be able to pull some information from 2016, 2021, 2022
release <- mdb.get(knights_camp, tables = "Release")
# no helpful information in this table
release_fish <- mdb.get(knights_camp, tables = "ReleaseFish")
environmental <- mdb.get(knights_camp, tables = "EnvDataRaw")

# pull lookup tables
visit_type_lu <- mdb.get(knights_camp, "luVisitType") %>% 
  select(-activeID) %>%glimpse

run_lu <- mdb.get(knights_camp, "luRun") %>% 
  select(-activeID) %>% glimpse

run_method_lu <- mdb.get(knights_camp, "luRunMethod") %>% 
  select(-activeID) %>% glimpse

lifestage_lu <- mdb.get(knights_camp, "luLifeStage") %>% 
  select(-activeID) %>% glimpse

taxon_lu <-  mdb.get(knights_camp, "luTaxon") %>% 
  mutate(taxonID = as.numeric(taxonID)) %>% 
  select(taxonID, commonName) %>% glimpse

origin_lu <-  mdb.get(knights_camp, "luFishOrigin") %>% 
  select(-activeID) %>% glimpse

debris_volume_lu <- mdb.get(knights_camp,  "luDebrisVolumeCat") %>% 
  select(-activeID) %>% 
  glimpse

trap_function_lu <- mdb.get(knights_camp, "luTrapFunctioning") %>%
  select(-activeID) %>% 
  glimpse

processed_lu <- mdb.get(knights_camp, "luFishProcessed") %>%
  select(-activeID) %>% 
  glimpse

subsite_lu <- mdb.get(knights_camp, "SubSite") %>% 
  select(subSiteName, subSiteID, siteID) %>% 
  filter(subSiteName != "N/A")

site_lu <- mdb.get(knights_camp, "Site") %>% 
  select(siteName, siteID)

sample_gear_lu <- mdb.get(knights_camp, "luSampleGear") %>% 
  select(-activeID) %>% glimpse()

no_yes_lu <- mdb.get(knights_camp, "luNoYes")

# lookups for existing mark
color_lu <- mdb.get(knights_camp, "luColor") %>%
  select(-activeID) %>% glimpse()

mark_type_lu <- mdb.get(knights_camp, "luMarkType") %>%
  select(-activeID) %>% glimpse()

body_part_lu <- mdb.get(knights_camp, "luBodyPart") %>%
  select(-activeID) %>% glimpse()

# lookups for releases
release_purpose_lu <- mdb.get(knights_camp, "luReleasePurpose") %>% 
  select(-activeID) %>% glimpse()

light_condition_lu <- mdb.get(knights_camp, "luLightCondition") %>% 
  select(-activeID) %>% glimpse()

unit_lu <- mdb.get(knights_camp, "luUnit") %>% 
  select(-activeID) %>% glimpse()