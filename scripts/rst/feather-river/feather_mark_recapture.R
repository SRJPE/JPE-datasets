# install.packages("RODBC")
library(RODBC)
library(tidyverse)
library(lubridate)

# Set up connection with CAMP access database 
feather_camp <- odbcConnectAccess2007("../../../projects/JPE/CAMP Feather River/CAMP_RST_29Oct2018/Data/CAMP.mdb")

# Pull in relevant data 
CatchRaw <- sqlFetch(feather_camp, "CatchRaw") 
TrapVisit <- sqlFetch(feather_camp, "TrapVisit") %>% glimpse
Release <- sqlFetch(feather_camp, "Release")

# select relevant column
selected_trap_visit <- TrapVisit %>% 
  select(trapVisitID, visitTime) %>% 
  glimpse 

selected_catch <- CatchRaw %>% 
  select(catchRawID, trapVisitID, taxonID, finalRunID, n, releaseID) %>% glimpse

# Look at releases per day 
Release %>% 
  filter(year(releaseTime) > 1970) %>% 
  group_by(releasePurposeID, date = as_date(releaseTime)) %>% 
  summarise(trials_per_day = n()) %>%
  pivot_wider(names_from = releasePurposeID, values_from = trials_per_day) %>% 
  filter(year(date) == 2020)

Release %>% view

selected_release <- Release %>% 
  filter(releasePurposeID == 1) %>% 
  select(releaseID, releaseSiteID, nReleased, releaseTime) %>% 
  mutate(release_date = as_date(releaseTime)) %>% 
  select(-releaseTime) %>% glimpse

# Check catch ID 
catch_trap_id <- CatchRaw$trapVisitID %>% unique() %>% sort()
trap_trap_id <- TrapVisit$trapVisitID %>% unique() %>% sort()

length(catch_trap_id)
length(trap_trap_id)

# Combine all tables 
catch_with_date <- selected_catch %>% 
  left_join(selected_trap_visit, by = c("trapVisitID" = "trapVisitID")) %>% 
  mutate(recaptured_date = as_date(visitTime)) %>% 
  filter(releaseID != 0 & releaseID != 255) %>% 
  group_by(releaseID, recaptured_date) %>% 
  summarise(number_recaptured = sum(n, na.rm = T)) %>% 
  left_join(selected_release, by = c("releaseID" = "releaseID")) %>% 
  mutate(efficiency = number_recaptured/nReleased) %>% 
  glimpse()

# Visualize data 
catch_with_date %>% 
  ggplot(aes(x = efficiency, color = as.character(year(recaptured_date)))) + 
  geom_density()

catch_with_date %>% 
  filter(year(release_date) == 2020) %>% 
  group_by(release_date) %>% 
  summarise(daily_trials = n()) %>% 
  filter(daily_trials > 1)

catch_with_date %>% 
  group_by(year = year(release_date)) %>% 
  summarise(trials_per_year = n()) %>% 
  ggplot(aes(x = as.character(year), y = trials_per_year)) +
  geom_col()

catch_with_date %>% 
  ggplot(aes(x = month(release_date), y = year(release_date), size = efficiency)) +
  geom_point()

# Save data 
write_rds(catch_with_date, "data/rst/feather_mark_recapture_data.rds")
