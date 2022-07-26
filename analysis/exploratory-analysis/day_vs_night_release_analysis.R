library(tidyverse)
library(lubridate)
library(googleCloudStorageR)
library(knitr)
library(hms)
library(zoo)


# Input google cloud bucket information 
Sys.setenv("GCS_DEFAULT_BUCKET" = "jpe-dev-bucket", "GCS_AUTH_FILE" = "config.json")

gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
# # Set global bucket 
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

# Load datasets
# gcs_get_object(object_name = "standard-format-data/standard_recapture.csv",
#                bucket = gcs_get_global_bucket(),
#                saveToDisk = "data/standard-format-data/standard_mark_recaptures.csv",
#                overwrite = TRUE)
# 
# gcs_get_object(object_name = "standard-format-data/standard_rst_catch.csv",
#                bucket = gcs_get_global_bucket(),
#                saveToDisk = "data/standard-format-data/standard_rst_catch.csv",
#                overwrite = TRUE)
# 
# gcs_get_object(object_name = "standard-format-data/standard_rst_catch_lad.csv",
#                bucket = gcs_get_global_bucket(),
#                saveToDisk = "data/standard-format-data/standard_rst_catch_lad.csv",
#                overwrite = TRUE)

release_raw <- read_csv(here::here("data","standard-format-data", "standard_release.csv"))  

recapture_raw <- read_csv(here::here("data","standard-format-data", "standard_recapture.csv"))


release_raw %>%
  filter(stream == "sacramento river") %>% pull(release_id) %>% unique() %>% length()
  # group_by(night_release) %>%
  # summarise(min = as_datetime(as.numeric(min(release_time, na.rm = T))),
  #           mean = as_datetime(as.numeric(mean(release_time, na.rm = T))),
  #           max = as_datetime(as.numeric(max(release_time, na.rm = T)))
  #           )


plot_day_or_night <- function(watershed, sites) {
night_releases <- release_raw %>% 
  left_join(recapture_raw, 
            by = c("release_id" = "release_id", "stream" = "stream")) %>% 
  filter(release_time < hms::as_hms('04:00:00') | 
           release_time >= hms::as_hms('18:00:00'), 
         stream == watershed & site == sites) %>% 
  group_by(stream, site, release_id, release_time, release_date, number_released) %>%
  summarise(total_fish_recaptured = sum(number_recaptured, na.rm = TRUE),
            flow = mean(flow_at_release, na.rm = TRUE)) %>% 
  mutate(night_efficiency = (total_fish_recaptured + 1)/(number_released + 1)) %>% 
  glimpse
print(paste("There are", nrow(night_releases), "night releases"))
# 208 

day_releases <- release_raw %>% 
  left_join(recapture_raw, 
            by = c("release_id" = "release_id", "stream" = "stream")) %>% 
  filter(release_time < hms::as_hms('18:00:00') & 
           release_time >= hms::as_hms('04:00:00'),
         stream == watershed, site == sites) %>%
  group_by(stream, site, release_id, release_time, release_date, number_released) %>%
  summarise(total_fish_recaptured = sum(number_recaptured, na.rm = TRUE),
            flow = mean(flow_at_release, na.rm = TRUE)) %>% 
  mutate(day_efficiency = (total_fish_recaptured + 1)/(number_released + 1)) %>% glimpse

print(paste("There are", nrow(day_releases), "day releases"))

# ttest
# t.test(day_releases %>% pull(day_efficiency), night_releases %>% pull(night_efficiency))

# boxplot 
# bind_rows(night_releases, day_releases) %>% 
#   pivot_longer(cols = c(night_efficiency, day_efficiency), 
#                names_to = "timing", 
#                values_to = "efficiency") %>%
#   filter(efficiency < 1) %>% 
#   ggplot() + 
#   geom_boxplot(aes(x = efficiency, y = timing)) + 
#   theme_minimal() + 
#   labs(title = paste0("Day vs Night Efficiency (", watershed, ", ", sites, ")"), 
#        y = " ", 
#        x = "Efficiency") 

# tibble(stream = watershed,
#        site = sites,
#        mean_efficiency_day = day_releases %>% pull(day_efficiency) %>% mean(na.rm = T),
#        mean_efficiency_night = night_releases %>% pull(night_efficiency) %>% mean(na.rm = T))

# point plot 
# bind_rows(night_releases, day_releases) %>% 
#   pivot_longer(cols = c(night_efficiency, day_efficiency), names_to = "timing", 
#                values_to = "efficiency") %>%
#   filter(efficiency < 1) %>% 
#   ggplot() + 
#   geom_point(aes(x = efficiency, y = flow, color = timing)) + 
#   theme_minimal() + 
#   labs(title = paste0("Efficiency vs Flow (", watershed, ", ", sites, ")"), 
#        y = "Flow", 
#        x = "Efficiency") 

}
plot_day_or_night("battle creek", sites = "ubc")
plot_day_or_night("clear creek", "lcc")
plot_day_or_night("clear creek", "ucc")
plot_day_or_night("feather river", "gateway riffle")
plot_day_or_night("feather river", "herringer riffle")


plot_day_or_night("feather river", "eye riffle")
plot_day_or_night("feather river", "live oak")
plot_day_or_night("feather river", "herringer riffle")
plot_day_or_night("feather river", "steep riffle")
plot_day_or_night("feather river", "sunset pumps")
plot_day_or_night("feather river", "gateway riffle")
# dot plot efficiency, flow, color by night or day 
# not related to flow /: 
bind_rows(night_releases, day_releases) %>% 
  pivot_longer(cols = c(night_efficiency, day_efficiency), names_to = "timing", 
               values_to = "efficiency") %>%
  filter(efficiency < 1) %>% 
  ggplot() + 
  geom_point(aes(x = efficiency, y = flow, color = timing)) 
