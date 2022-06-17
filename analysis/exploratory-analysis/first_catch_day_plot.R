library(tidyverse)
library(ggplot2)
library(googleCloudStorageR)
library(lubridate)
library(extrafont)

color_pal <- c("#9A8822",  "#F8AFA8", "#FDDDA0", "#74A089", "#899DA4", "#446455", "#DC863B", "#C93312")

# load in catch data
Sys.setenv("GCS_AUTH_FILE" = "config.json", "GCS_DEFAULT_BUCKET" = "jpe-dev-bucket")
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
# # # Set global bucket 
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))
# # 
View(gcs_list_objects())
# 
# gcs_get_object(object_name = "standard-format-data/standard_rst_catch.csv",
#                bucket = gcs_get_global_bucket(),
#                saveToDisk = "data/standard-format-data/standard_rst_catch.csv",
#                overwrite = TRUE)
# 
# gcs_get_object(object_name = "standard-format-data/standard_rst_trap.csv",
#                bucket = gcs_get_global_bucket(),
#                saveToDisk = "data/standard-format-data/standard_rst_trap.csv",
#                overwrite = TRUE)

# gcs_get_object(object_name = "standard-format-data/standard_rst_catch_lad.csv",
#                bucket = gcs_get_global_bucket(),
#                saveToDisk = "data/standard-format-data/standard_rst_catch_lad.csv",
#                overwrite = TRUE)

# use LAD one! 
# catch <- read_csv("data/standard-format-data/standard_rst_catch.csv") %>% glimpse()
catch <- read_csv("data/standard-format-data/standard_rst_catch_lad.csv") %>% glimpse()

trap_operations <- read_csv("data/standard-format-data/standard_rst_trap.csv") %>% glimpse()

catch$stream %>% unique()
catch$site %>% unique()

trap_operations$stream %>% unique()

trap_and_catch <- catch %>% 
  full_join(trap_operations, by = c("date" = "trap_start_date", 
                                            "stream" = "stream", 
                                            "site" = "site"))

first_catch_days <- catch %>% 
  mutate(monitoring_year = ifelse(month(date) %in% c(9, 10, 11, 12), year(date), year(date) - 1)) %>% 
  group_by(monitoring_year, stream, site, run_rivermodel) %>% 
  summarise(first_spring_catch_date = as.Date(min(date, na.rm = T)),
            count = sum(count, na.rm = T)) %>% 
  filter((run_rivermodel == "spring") & count > 0) %>% 
  select(-count, -run_rivermodel) %>%
  glimpse

first_trap_days <- trap_operations %>% 
  mutate(valid_date = coalesce(trap_start_date, trap_stop_date),
         monitoring_year = ifelse(month(valid_date) %in% c(9, 10, 11, 12), 
                                  year(valid_date), year(valid_date) - 1)) %>% 
  group_by(monitoring_year, stream, site) %>% 
  summarise(first_trap_date = as.Date(min(valid_date, na.rm = T))) %>% glimpse


catch_trap_days <- first_catch_days %>% 
  inner_join(first_trap_days)

# 30 % of the time fish caught on first trap day 
mean(catch_trap_days$first_spring_catch_date == catch_trap_days$first_trap_date, na.rm = T)


# distribution of first day caught facetted
catch_trap_days %>% 
  mutate(days_since = first_spring_catch_date - first_trap_date) %>% 
  filter(stream != "sacramento river") %>% #filter out one -300 value TODO investigate
  ggplot() + 
  geom_histogram(aes(x = days_since, y =..density.., fill = stream), 
                 alpha = .5, position = "identity") + 
  geom_density(aes(x = days_since, color = stream), adjust = 4, size = 1) +
  scale_fill_manual(values = color_pal) +
  scale_color_manual(values = color_pal) +
  theme_minimal()

#distribution first days caught overlayed 
catch_trap_days %>% 
  mutate(days_since = first_spring_catch_date - first_trap_date) %>% 
  filter(stream != "sacramento river") %>% #filter out one -300 value TODO investigate
  ggplot() + 
  geom_histogram(aes(x = days_since, fill = stream), alpha = .5, position = "identity") + 
  scale_fill_manual(values = color_pal) +
  theme_minimal() + 
  facet_wrap(~stream)


plot_barbell_catch <- function(selected_site) {
  selected_site
  catch_trap_days_barbell <- catch_trap_days %>% 
    filter(site == selected_site) %>% 
    pivot_longer(cols = first_spring_catch_date:first_trap_date, names_to = "day_type", values_to = "date") %>% 
    filter(!is.na(date)) %>%
    mutate(fake_date = as.Date(paste0(ifelse(month(date) %in% c(9, 10, 11, 12), "0000-", "0001-"), 
                                      month(date), "-", day(date)))) %>%
    glimpse
  
  first_trap_day <- catch_trap_days_barbell %>% filter(day_type == "first_trap_date") %>% glimpse
  first_spring_day <- catch_trap_days_barbell %>% filter(day_type == "first_spring_catch_date")
    
  catch_trap_days_barbell %>%
    ggplot() +
    geom_segment(data = first_trap_day, aes(x = fake_date, y = monitoring_year, 
                 yend = first_spring_day$monitoring_year, xend = first_spring_day$fake_date),
                 color = "#aeb6bf",
                 size = 3, 
                 alpha = .5) + 
    geom_jitter(aes(x = fake_date, y = monitoring_year, color = day_type), size = 4, width = 0.4, height = 0) + 
    scale_color_manual(values = color_pal) + 
    theme_minimal() + 
    labs(title = paste0("First Trap days and First SR catch day: ", selected_site), 
         y = "Monitoring Year (sept - june)",
         x = "Date") + 
    theme(legend.title = element_blank(), 
          legend.position = "bottom")

}

# Battle Creek 
plot_barbell_catch("battle creek")

# Butte Creek 
plot_barbell_catch("adams dam")
plot_barbell_catch("okie dam")

# Clear Creek 
plot_barbell_catch("ucc")
plot_barbell_catch("lcc")

# Deer Creek 
plot_barbell_catch("deer creek")

# knights landing 
#TODO fix something funky here
plot_barbell_catch("knights landing")

# feather River
plot_barbell_catch("herringer riffle")
plot_barbell_catch("eye riffle")
plot_barbell_catch("steep riffle")
plot_barbell_catch("gateway riffle")
plot_barbell_catch("sunset pumps")
plot_barbell_catch("live oak")
plot_barbell_catch("shawns beach")

# mill creek 
plot_barbell_catch("mill creek")

# tisdale 
#TODO no tisdale since we do not have trap operations data 

# yuba 
plot_barbell_catch("hallwood")
plot_barbell_catch("yuba river")


catch_trap_days$site %>% unique()

# other summary plot 