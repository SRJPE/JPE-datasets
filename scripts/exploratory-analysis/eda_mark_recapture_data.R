library(tidyverse)
library(googleCloudStorageR)

# script to prep data for eda 
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))

# Set global bucket 
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))


# rst data pull 
battle_mark_recapture <- gcs_get_object(object_name = "rst/battle-creek/data/battle_mark_reacpture.csv",
                                        bucket = gcs_get_global_bucket(),
                                        saveToDisk = "data/rst/battle_mark_recapture.csv",
                                        overwrite = TRUE)
clear_mark_recapture <- gcs_get_object(object_name = "rst/clear-creek/data/clear_mark_reacpture.csv",
                                        bucket = gcs_get_global_bucket(),
                                        saveToDisk = "data/rst/clear_mark_recapture.csv",
                                        overwrite = TRUE)

battle_mark_recap <- read_csv("data/rst/battle_mark_recapture.csv") %>% 
  mutate(watershed = "Battle Creek") %>% glimpse

clear_mark_recap <- read_csv("data/rst/clear_mark_recapture.csv")  %>% 
  mutate(watershed = "Clear Creek") %>% glimpse

combined_mark_recapture <- bind_rows(battle_mark_recap, clear_mark_recap) %>% glimpse

write_rds(combined_mark_recapture, "data/rst/combined_mark_recap.rds")


# Dist of percent recapture per day 
percent_recaps_per_day <- combined_mark_recapture %>% 
  mutate(percent_recap_day_1 = caught_day_1/recaps * 100, 
         percent_recap_day_2 = caught_day_2/recaps * 100, 
         percent_recap_day_3 = caught_day_3/recaps * 100, 
         percent_recap_day_4 = caught_day_4/recaps * 100, 
         percent_recap_day_5 = caught_day_5/recaps * 100) %>% 
  filter(percent_recap_day_1 <= 100) 

ggplot(data = percent_recaps_per_day) +
  geom_histogram(aes(x = percent_recap_day_1, fill = "Day 1"), 
                 binwidth = 5, alpha=0.5) + 
  geom_histogram(aes(x = percent_recap_day_2, fill ="Day 2"), 
                 binwidth = 5, alpha=0.5) + 
  geom_histogram(aes(x = percent_recap_day_3, fill ="Day 3"), 
                 binwidth = 5, alpha=0.5) + 
  geom_histogram(aes(x = percent_recap_day_4, fill ="Day 4"), 
                 binwidth = 5, alpha=0.5) + 
  geom_histogram(aes(x = percent_recap_day_5, fill ="Day 5"), 
                 binwidth = 5, alpha=0.5) + 
  scale_fill_manual(values = wesanderson::wes_palette("BottleRocket2")) + 
  labs(x = "Percent Recaptured by Day") + 
  theme_minimal()

ggplot(data = percent_recaps_per_day) +
  geom_histogram(aes(x = percent_recap_day_2, fill = watershed), 
                 binwidth = 5, alpha=0.5) + 
  scale_fill_manual(values=c("#69b3a2", "#404080")) + 
  theme_minimal()

ggplot(data = percent_recaps_per_day) +
  geom_histogram(aes(x = percent_recap_day_3, fill = watershed), 
                 binwidth = 5, alpha=0.5) + 
  scale_fill_manual(values=c("#69b3a2", "#404080")) + 
  theme_minimal()

# TODO Density plot cuml recaptured,frequency ? 

# Scatter Plot Baileys efficiency and flow, temp, turbidity 
combined_mark_recapture %>% 
  mutate(bailey_effciency = (recaps + 1)/(no_released + 1)) %>% 
  ggplot() + 
  geom_point(aes(x = mean_flow_day_of_rel, y = bailey_effciency, color = watershed))

combined_mark_recapture %>% 
  mutate(bailey_effciency = (recaps + 1)/(no_released + 1)) %>% 
  ggplot() + 
  geom_point(aes(x = mean_temp_day_of_rel, y = bailey_effciency, color = watershed))

combined_mark_recapture %>% 
  mutate(bailey_effciency = (recaps + 1)/(no_released + 1)) %>% 
  ggplot() + 
  geom_point(aes(x = release_turbidity, y = bailey_effciency, color = watershed))
