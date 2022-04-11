# install.packages("RODBC")
library(RODBC)
library(tidyverse)
library(lubridate)

# Set up connection with CAMP access database 
knights_landing_camp <- odbcConnectAccess2007("../../../projects/JPE/CAMP_knights_landing/CAMP.mdb")

# Pull in relevant data 
CatchRaw <- sqlFetch(knights_landing_camp, "CatchRaw") 
TrapVisit <- sqlFetch(knights_landing_camp, "TrapVisit") %>% glimpse
Release <- sqlFetch(knights_landing_camp, "Release") %>% glimpse

# pull lookup tables
visit_type_lu <- sqlFetch(knights_landing_camp, "luVisitType") %>% 
  select(-activeID) %>%glimpse

run_lu <- sqlFetch(knights_landing_camp, "luRun") %>% 
  select(-activeID) %>% glimpse

run_method_lu <- sqlFetch(knights_landing_camp, "luRunMethod") %>% 
  select(-activeID) %>% glimpse

lifestage_lu <- sqlFetch(knights_landing_camp, "luLifestage") %>% 
  select(-activeID) %>% glimpse

taxon_lu <-  sqlFetch(knights_landing_camp, "luTaxon") %>% 
  mutate(taxonID = as.numeric(taxonID)) %>%
  select(taxonID, commonName) %>% glimpse

origin_lu <-  sqlFetch(knights_landing_camp, "luFishOrigin") %>% 
  select(-activeID) %>% glimpse

# select relevant column
selected_trap_visit <- TrapVisit %>%
  select(trapVisitID, visitTime, visitTime2) %>%
  left_join(visit_type_lu, by = c("trapVisitID" = "visitTypeID")) %>%
  select(-activeID) %>%
  glimpse

selected_catch <- CatchRaw %>% 
  select(catchRawID, taxonID, finalRunID, finalRunMethodID, fishOriginID, lifeStageID, forkLength, weight, n, trapVisitID) %>% 
  left_join(taxon_lu, by = c("taxonID" = "taxonID")) %>%
  filter(commonName == "Chinook salmon") %>% 
  left_join(run_lu, by = c("finalRunID" = "runID")) %>%
  left_join(run_method_lu, by = c("finalRunMethodID" = "runMethodID")) %>%
  left_join(lifestage_lu, by = c("lifeStageID" = "lifeStageID")) %>%
  left_join(origin_lu, by = c("fishOriginID" = "fishOriginID")) %>%
  select(-lifeStageID, -finalRunMethodID, -finalRunID, -taxonID, -fishOriginID) %>%
  left_join(selected_trap_visit) %>%
  glimpse


# Save data 
write_rds(selected_catch, "data/rst/knights_landing_raw_catch.rds")
