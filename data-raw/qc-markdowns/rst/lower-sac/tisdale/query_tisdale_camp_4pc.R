## install.packages("RODBC")
library(RODBC)
library(tidyverse)
library(lubridate)

# Set up connection with CAMP access database 
tisdale_camp <- odbcConnectAccess2007(here::here("data-raw", "qc-markdowns", "rst", "lower-sac", "tisdale", "CAMP.mdb"))

catch_raw <- sqlFetch(tisdale_camp, "CatchRaw") 
trap_visit <- sqlFetch(tisdale_camp, "TrapVisit")
mark <-  sqlFetch(tisdale_camp, tables = "MarkExisting")
# might be able to pull some information from 2016, 2021, 2022
release <- sqlFetch(tisdale_camp, tables = "Release")
# no helpful information in this table
release_fish <- sqlFetch(tisdale_camp, tables = "ReleaseFish")
environmental <- sqlFetch(tisdale_camp, tables = "EnvDataRaw")
mark_applied <- sqlFetch(tisdale_camp, tables = "MarkApplied")

# pull lookup tables
visit_type_lu <- sqlFetch(tisdale_camp, "luVisitType") %>% 
  select(-activeID) %>%glimpse

run_lu <- sqlFetch(tisdale_camp, "luRun") %>% 
  select(-activeID) %>% glimpse

run_method_lu <- sqlFetch(tisdale_camp, "luRunMethod") %>% 
  select(-activeID) %>% glimpse

lifestage_lu <- sqlFetch(tisdale_camp, "luLifeStage") %>% 
  select(-activeID) %>% glimpse

taxon_lu <-  sqlFetch(tisdale_camp, "luTaxon") %>% 
  mutate(taxonID = as.numeric(taxonID)) %>% 
  select(taxonID, commonName) %>% glimpse

origin_lu <-  sqlFetch(tisdale_camp, "luFishOrigin") %>% 
  select(-activeID) %>% glimpse

debris_volume_lu <- sqlFetch(tisdale_camp,  "luDebrisVolumeCat") %>% 
  select(-activeID) %>% 
  glimpse

trap_function_lu <- sqlFetch(tisdale_camp, "luTrapFunctioning") %>%
  select(-activeID) %>% 
  glimpse

processed_lu <- sqlFetch(tisdale_camp, "luFishProcessed") %>%
  select(-activeID) %>% 
  glimpse

subsite_lu <- sqlFetch(tisdale_camp, "SubSite") %>% 
  select(subSiteName, subSiteID, siteID) %>% 
  filter(subSiteName != "N/A")

site_lu <- sqlFetch(tisdale_camp, "Site") %>% 
  select(siteName, siteID)

sample_gear_lu <- sqlFetch(tisdale_camp, "luSampleGear") %>% 
  select(-activeID) %>% glimpse()

no_yes_lu <- sqlFetch(tisdale_camp, "luNoYes")

# lookups for existing mark
color_lu <- sqlFetch(tisdale_camp, "luColor") %>%
  select(-activeID) %>% glimpse()

mark_type_lu <- sqlFetch(tisdale_camp, "luMarkType") %>%
  select(-activeID) %>% glimpse()

body_part_lu <- sqlFetch(tisdale_camp, "luBodyPart") %>%
  select(-activeID) %>% glimpse()

# lookups for releases
release_purpose_lu <- sqlFetch(tisdale_camp, "luReleasePurpose") %>% 
  select(-activeID) %>% glimpse()

light_condition_lu <- sqlFetch(tisdale_camp, "luLightCondition") %>% 
  select(-activeID) %>% glimpse()

unit_lu <- sqlFetch(tisdale_camp, "luUnit") %>% 
  select(-activeID) %>% glimpse()