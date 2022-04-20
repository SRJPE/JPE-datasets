# install.packages("RODBC")
library(RODBC)
library(tidyverse)
library(lubridate)

# Set up connection with CAMP access database 
feather_camp <- odbcConnectAccess2007("../../../projects/JPE/CAMP Feather River/CAMP_RST_29Oct2018/Data/CAMP.mdb")

# Pull in relevant data 
CatchRaw <- sqlFetch(feather_camp, "CatchRaw") 
TrapVisit <- sqlFetch(feather_camp, "TrapVisit") %>% glimpse
Release <- sqlFetch(feather_camp, "Release") %>% glimpse

# pull lookup tables
visit_type_lu <- sqlFetch(feather_camp, "luVisitType") %>% 
  select(-activeID) %>%glimpse

run_lu <- sqlFetch(feather_camp, "luRun") %>% 
  select(-activeID) %>% glimpse

run_method_lu <- sqlFetch(feather_camp, "luRunMethod") %>% 
  select(-activeID) %>% glimpse

lifestage_lu <- sqlFetch(feather_camp, "luLifestage") %>% 
  select(-activeID) %>% glimpse

taxon_lu <-  sqlFetch(feather_camp, "luTaxon") %>% 
  # mutate(taxonID = as.numeric(taxonID)) %>%
  select(taxonID, commonName) %>% glimpse

origin_lu <-  sqlFetch(feather_camp, "luFishOrigin") %>% 
  select(-activeID) %>% glimpse

# select relevant column
selected_trap_visit <- TrapVisit %>%
  select(trapVisitID, visitTime, visitTime2) %>%
  left_join(visit_type_lu, by = c("trapVisitID" = "visitTypeID")) %>%
  glimpse

selected_catch <- CatchRaw %>% 
  select(catchRawID, taxonID, finalRunID, finalRunMethodID, fishOriginID, lifeStageID, forkLength, weight, n, trapVisitID) %>% 
  left_join(taxon_lu, by = c("taxonID" = "taxonID")) %>%
  filter(commonName == "Chinook salmon") %>% 
  left_join(run_lu, by = c("finalRunID" = "runID")) %>%
  left_join(run_method_lu, by = c("finalRunMethodID" = "runMethodID")) %>%
  left_join(lifestage_lu, by = c("lifeStageID" = "lifeStageID")) %>%
  left_join(origin_lu, by = c("fishOriginID" = "fishOriginID")) %>%
  select(-lifeStageID, -finalRunMethodID, -finalRunID, -taxonID, -fishOriginID, -lifeStageCAMPID) %>%
  left_join(selected_trap_visit) %>%
  glimpse


# Save data 
write_rds(selected_catch, "data/rst/feather_camp_raw_catch.rds")
