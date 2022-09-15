library(tidyverse)
library(knitr)
library(Hmisc)
library(lubridate)
library(chron)

feather_camp <- (here::here("data-raw", "qc-markdowns", "rst", "feather-river", "CAMP.mdb"))

catch_raw <- mdb.get(feather_camp, tables = "CatchRaw")
trap_visit <- mdb.get(feather_camp, tables = "TrapVisit") %>% 
  mutate(visitTime = as.POSIXct(visitTime),
         visitTime2 = as.POSIXct(vistTime2))
mark <-  mdb.get(feather_camp, tables = "MarkExisting")
release <- mdb.get(feather_camp, tables = "Release") %>% 
  mutate(releaseTime = as.POSIXct(releaseTime))
# TODO check if needed
release_target <- mdb.get(feather_camp, tables = "ReleaseXTargetSite")
environmental <- mdb.get(feather_camp, tables = "EnvDataRaw")
# TODO check if needed
env_raw_target <- mdb.get(feather_camp, "EnvDataRawXTargetSite")
mark_applied <- mdb.get(feather_camp, tables = "MarkApplied")

# pull lookup tables
visit_type_lu <- mdb.get(feather_camp, "luVisitType") %>% 
  select(-activeID) %>%glimpse

run_lu <- mdb.get(feather_camp, "luRun") %>% 
  select(-activeID) %>% glimpse

run_method_lu <- mdb.get(feather_camp, "luRunMethod") %>% 
  select(-activeID) %>% glimpse

lifestage_lu <- mdb.get(feather_camp, "luLifeStage") %>% 
  select(-activeID) %>% glimpse

taxon_lu <-  mdb.get(feather_camp, "luTaxon") %>% 
  mutate(taxonID = as.numeric(taxonID)) %>% 
  select(taxonID, commonName) %>% glimpse

origin_lu <-  mdb.get(feather_camp, "luFishOrigin") %>% 
  select(-activeID) %>% glimpse

debris_volume_lu <- mdb.get(feather_camp,  "luDebrisVolumeCat") %>% 
  select(-activeID) %>% 
  glimpse

trap_function_lu <- mdb.get(feather_camp, "luTrapFunctioning") %>%
  select(-activeID) %>% 
  glimpse

processed_lu <- mdb.get(feather_camp, "luFishProcessed") %>%
  select(-activeID) %>% 
  glimpse

subsite_lu <- mdb.get(feather_camp, "SubSite") %>% 
  select(subSiteName, subSiteID, siteID) %>% 
  filter(subSiteName != "N/A")

site_lu <- mdb.get(feather_camp, "Site") %>% 
  select(siteName, siteID)

sample_gear_lu <- mdb.get(feather_camp, "luSampleGear") %>% 
  select(-activeID) %>% glimpse()

no_yes_lu <- mdb.get(feather_camp, "luNoYes")

# lookups for existing mark
color_lu <- mdb.get(feather_camp, "luColor") %>%
  select(-activeID) %>% glimpse()

mark_type_lu <- mdb.get(feather_camp, "luMarkType") %>%
  select(-activeID) %>% glimpse()

body_part_lu <- mdb.get(feather_camp, "luBodyPart") %>%
  select(-activeID) %>% glimpse()

# lookups for releases
release_purpose_lu <- mdb.get(feather_camp, "luReleasePurpose") %>% 
  select(-activeID) %>% glimpse()

light_condition_lu <- mdb.get(feather_camp, "luLightCondition") %>% 
  select(-activeID) %>% glimpse()

unit_lu <- mdb.get(feather_camp, "luUnit") %>% 
  select(-activeID) %>% glimpse()

