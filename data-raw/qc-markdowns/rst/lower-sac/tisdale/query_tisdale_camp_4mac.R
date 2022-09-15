library(tidyverse)
library(knitr)
library(Hmisc)
library(lubridate)
library(chron)

tisdale_camp <- here::here("data-raw", "qc-markdowns", "rst", "lower-sac", "tisdale", "CAMP.mdb")
mdb.get(tisdale_camp, tables = T)

catch_raw <- mdb.get(tisdale_camp, tables = "CatchRaw")
trap_visit <- mdb.get(tisdale_camp, tables = "TrapVisit") %>% 
  mutate(visitTime = as.POSIXct(visitTime),
         visitTime2 = as.POSIXct(vistTime2))
mark <-  mdb.get(tisdale_camp, tables = "MarkExisting")
# might be able to pull some information from 2016, 2021, 2022
release <- mdb.get(tisdale_camp, tables = "Release") %>% 
  mutate(releaseTime = as.POSIXct(releaseTime))
# no helpful information in this table
release_fish <- mdb.get(tisdale_camp, tables = "ReleaseFish")
environmental <- mdb.get(tisdale_camp, tables = "EnvDataRaw")
mark_applied <- mdb.get(tisdale_camp, tables = "MarkApplied")

# pull lookup tables
visit_type_lu <- mdb.get(tisdale_camp, "luVisitType") %>% 
  select(-activeID) %>%glimpse

run_lu <- mdb.get(tisdale_camp, "luRun") %>% 
  select(-activeID) %>% glimpse

run_method_lu <- mdb.get(tisdale_camp, "luRunMethod") %>% 
  select(-activeID) %>% glimpse

lifestage_lu <- mdb.get(tisdale_camp, "luLifeStage") %>% 
  select(-activeID) %>% glimpse

taxon_lu <-  mdb.get(tisdale_camp, "luTaxon") %>% 
  mutate(taxonID = as.numeric(taxonID)) %>% 
  select(taxonID, commonName) %>% glimpse

origin_lu <-  mdb.get(tisdale_camp, "luFishOrigin") %>% 
  select(-activeID) %>% glimpse

debris_volume_lu <- mdb.get(tisdale_camp,  "luDebrisVolumeCat") %>% 
  select(-activeID) %>% 
  glimpse

trap_function_lu <- mdb.get(tisdale_camp, "luTrapFunctioning") %>%
  select(-activeID) %>% 
  glimpse

processed_lu <- mdb.get(tisdale_camp, "luFishProcessed") %>%
  select(-activeID) %>% 
  glimpse

subsite_lu <- mdb.get(tisdale_camp, "SubSite") %>% 
  select(subSiteName, subSiteID, siteID) %>% 
  filter(subSiteName != "N/A")

site_lu <- mdb.get(tisdale_camp, "Site") %>% 
  select(siteName, siteID)

sample_gear_lu <- mdb.get(tisdale_camp, "luSampleGear") %>% 
  select(-activeID) %>% glimpse()

no_yes_lu <- mdb.get(tisdale_camp, "luNoYes")

# lookups for existing mark
color_lu <- mdb.get(tisdale_camp, "luColor") %>%
  select(-activeID) %>% glimpse()

mark_type_lu <- mdb.get(tisdale_camp, "luMarkType") %>%
  select(-activeID) %>% glimpse()

body_part_lu <- mdb.get(tisdale_camp, "luBodyPart") %>%
  select(-activeID) %>% glimpse()

# lookups for releases
release_purpose_lu <- mdb.get(tisdale_camp, "luReleasePurpose") %>% 
  select(-activeID) %>% glimpse()

light_condition_lu <- mdb.get(tisdale_camp, "luLightCondition") %>% 
  select(-activeID) %>% glimpse()

unit_lu <- mdb.get(tisdale_camp, "luUnit") %>% 
  select(-activeID) %>% glimpse()