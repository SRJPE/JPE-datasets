library(tidyverse)
library(lubridate)
library(googleCloudStorageR)
library(knitr)
library(hms)
library(zoo)
library(suncalc)


# Input google cloud bucket information 
Sys.setenv("GCS_DEFAULT_BUCKET" = "jpe-dev-bucket", "GCS_AUTH_FILE" = "config.json")

gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
# # Set global bucket 
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

colors <- c("#9A8822", "#F5CDB4", "#F8AFA8", "#FDDDA0", "#74A089", #Royal 2
            "#899DA4", "#C93312", "#DC863B" # royal 1 (- 3)
            )

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
  mutate(release_date = as_date(release_date), 
         # night_end = hms::as_hms(suncalc::getSunlightTimes(date = release_date, 
         #                                    lat = 38.575764, 
         #                                    lon = -121.478851, tz = "UTC", keep = "nightEnd") %>% 
         #   pull(nightEnd) - hours(7)),
         # night = hms::as_hms(suncalc::getSunlightTimes(date = release_date, 
         #                                    lat = 38.575764, 
         #                                    lon = -121.478851, tz = "UTC", keep = "night") %>% 
         #   pull(night) - hours(7))
         ) %>% 
  left_join(recapture_raw, 
            by = c("release_id" = "release_id", "stream" = "stream")) %>% 
  # filter(release_time < night_end | 
  #          release_time >= night, 
         # stream == watershed & site == sites) %>% 
  filter(release_time < hms::as_hms('04:00:00') | 
           release_time >= hms::as_hms('18:00:00'), 
         stream == watershed & site == sites) %>% 
  group_by(stream, site, release_id, release_time, release_date, number_released) %>%
  summarise(total_fish_recaptured = sum(number_recaptured, na.rm = TRUE),
            flow = mean(flow_at_release, na.rm = TRUE)) %>% 
  mutate(`Night Efficiency` = (total_fish_recaptured + 1)/(number_released + 1)) %>% 
  glimpse

print(paste("There are", nrow(night_releases), "night releases"))

day_releases <- release_raw %>% 
  mutate(release_date = as_date(release_date), 
         # day = hms::as_hms(suncalc::getSunlightTimes(date = release_date, 
         #                                                   lat = 38.575764, 
         #                                                   lon = -121.478851, tz = "UTC", keep = "goldenHourEnd") %>% 
         #                           pull(goldenHourEnd) - hours(7)),
         # day_end = hms::as_hms(suncalc::getSunlightTimes(date = release_date, 
         #                                               lat = 38.575764, 
         #                                               lon = -121.478851, tz = "UTC", keep = "goldenHour") %>% 
         #                       pull(goldenHour) - hours(7))
         ) %>% 
  left_join(recapture_raw, 
            by = c("release_id" = "release_id", "stream" = "stream")) %>% 
  # filter(release_time < day_end & 
  #          release_time >= day,
  #        stream == watershed, site == sites) %>%
  filter(release_time < hms::as_hms('18:00:00') & 
           release_time >= hms::as_hms('04:00:00'),
         stream == watershed, site == sites) %>%
  group_by(stream, site, release_id, release_time, release_date, number_released) %>%
  summarise(total_fish_recaptured = sum(number_recaptured, na.rm = TRUE),
            flow = mean(flow_at_release, na.rm = TRUE)) %>% 
  mutate(`Day Efficiency` = (total_fish_recaptured + 1)/(number_released + 1)) %>% glimpse

print(paste("There are", nrow(day_releases), "day releases"))

# boxplot 
# bind_rows(night_releases, day_releases) %>%
#   pivot_longer(cols = c(`Night Efficiency`, `Day Efficiency`),
#                names_to = "Timing of Trials",
#                values_to = "efficiency") %>%
#   filter(efficiency < 1) %>%
#   ggplot() +
#   geom_boxplot(aes(x = efficiency, y = `Timing of Trials`)) +
#   theme_minimal() +
#   labs(title = paste0("Day vs Night Efficiency (", watershed, ", ", sites, ")"),
#        y = " ",
#        x = "Efficiency") + theme(text = element_text(size = 15)) 

# t test
# t.test(day_releases %>% pull(day_efficiency), night_releases %>% pull(night_efficiency))

tibble(stream = watershed,
       site = sites,
       mean_efficiency_day = day_releases %>% pull(`Day Efficiency`) %>% mean(na.rm = T),
       mean_efficiency_night = night_releases %>% pull(`Night Efficiency`) %>% mean(na.rm = T),
       median_efficiency_day = day_releases %>% pull(`Day Efficiency`) %>% median(na.rm = T),
       median_efficiency_night = night_releases %>% pull(`Night Efficiency`) %>% median(na.rm = T),
       sd_day = day_releases %>% pull(`Day Efficiency`) %>% sd(na.rm = T),
       sd_night = night_releases %>% pull(`Night Efficiency`) %>% sd(na.rm = T))
summary(night_releases)
# # point plot
# bind_rows(night_releases, day_releases) %>%
#   rename(Night = `Night Efficiency`, Day = `Day Efficiency`) %>% 
#   pivot_longer(cols = c(Night, Day),
#                        names_to = "Timing of Trial",
#                        values_to = "efficiency") %>%
#   filter(efficiency < 1) %>%
#   ggplot() +
#   geom_point(aes(x = flow, y = efficiency, color = `Timing of Trial`)) +
#   scale_color_manual(values = c(colors[8], colors[11])) + 
#   theme_minimal() +
#   labs(title = paste0("Efficiency vs Flow (", watershed, ", ", sites, ")"),
#        y = "Efficiency",
#        x = "Flow") + 
#   theme(text = element_text(size = 15)) 

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
