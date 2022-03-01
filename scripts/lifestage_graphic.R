# Graphic of salmon life stage, administration/water use timeline
library(tidyverse)
library(lubridate)
library(ggplot2)
# data prep

# Life stage categories: Adult upstream migration, Adult holding, Spawning,
# Juvenile outmigration, Fry holding, Yearling outmigration

clear_upstream <- tibble(Lifestage = c(rep("Adult upstream migration",2)),
                         Month = c("04","05"),
                         Day = c(rep("01",2)),
                         Year = c(rep("1",2)))
clear_holding <- tibble(Lifestage = c(rep("Adult holding",4)),
                        Month = c("05","06","07","08"),
                        Day = c(rep("01",3), "15"),
                        Year = c(rep("1",4)))
clear_spawning <- tibble(Lifestage = c(rep("Spawning",4)),
                         Month = c("08","09","10","11"),
                         Day = c("15","01","01","15"),
                         Year = c(rep("1",4)))
clear_outmigration <- tibble(Lifestage = c(rep("Juvenile outmigration", 8)),
                             Month = c("11","12","01","02","03","04","05","06"),
                             Day = c("15","31", rep("01",5), "15"),
                             Year = c("1","1", rep("2", 6)))
clear <- bind_rows(clear_upstream, clear_holding, clear_spawning, clear_outmigration) %>%
  mutate(Date = case_when(Year == 1 ~ paste0(1999, "-", Month, "-",Day),
                          T ~ paste0(2000, "-",Month, "-",Day)),
         Date = ymd(Date),
         Lifestage = fct_relevel(Lifestage, "Juvenile outmigration","Spawning","Adult holding","Adult upstream migration"))
clear1 <- filter(clear, Year == 1)
clear2 <- filter(clear, Year == 2)

battle_upstream <- tibble(Lifestage = c(rep("Adult upstream migration",4)),
                          Month = c("02","03","04","05"),
                          Day = c(rep("01",4)),
                          Year = c(rep("1",4)))
battle_holding <- tibble(Lifestage = c(rep("Adult holding",5)),
                         Month = c("05","06","07","08","09"),
                         Day = c(rep("01",5)),
                         Year = c(rep("1",5)))
battle_spawning <- tibble(Lifestage = c(rep("Spawning",3)),
                          Month = c("09","10","11"),
                          Day = c("01","01","15"),
                          Year = c(rep("1",3)))
battle_outmigration <- tibble(Lifestage = c(rep("Juvenile outmigration", 8)),
                              Month = c("11","12","01","02","03","04","05","06"),
                              Day = c("15","31", rep("01",5), "15"),
                              Year = c("1","1", rep("2", 6)))
battle <- bind_rows(battle_upstream, battle_holding, battle_spawning, battle_outmigration) %>%
  mutate(Date = case_when(Year == 1 ~ paste0(1999, "-", Month, "-",Day),
                          T ~ paste0(2000, "-",Month, "-",Day)),
         Date = ymd(Date),
         Lifestage = fct_relevel(Lifestage, "Juvenile outmigration","Spawning","Adult holding","Adult upstream migration"))
battle1 <- filter(battle, Year == 1)
battle2 <- filter(battle, Year == 2)

mill_upstream <- tibble(Lifestage = c(rep("Adult upstream migration",7)),
                        Month = c("02","03","04","05","06","07", "07"),
                        Day = c("15", rep("01",5), "15"),
                        Year = c(rep("1",7)))
mill_holding <- tibble(Lifestage = c(rep("Adult holding",2)),
                       Month = c("07","08"),
                       Day = c(rep("15",2)),
                       Year = c(rep("1",2)))
mill_spawning <- tibble(Lifestage = c(rep("Spawning",4)),
                        Month = c("08","09","10","11"),
                        Day = c("15","01","01","01"),
                        Year = c(rep("1",4)))
mill_outmigration <- tibble(Lifestage = c(rep("Juvenile outmigration", 9)),
                            Month = c("11","12","01","02","03","04","05","06", "07"),
                            Day = c("01","31", rep("01",7)),
                            Year = c("1","1", rep("2", 7)))
mill <- bind_rows(mill_upstream, mill_holding, mill_spawning, mill_outmigration) %>%
  mutate(Date = case_when(Year == 1 ~ paste0(1999, "-", Month, "-",Day),
                          T ~ paste0(2000, "-",Month, "-",Day)),
         Date = ymd(Date),
         Lifestage = fct_relevel(Lifestage, "Juvenile outmigration","Spawning","Adult holding","Adult upstream migration"))
mill1 <- filter(mill, Year == 1)
mill2 <- filter(mill, Year == 2)

deer_upstream <- tibble(Lifestage = c(rep("Adult upstream migration",7)),
                        Month = c("02","03","04","05","06","07","08"),
                        Day = c(rep("01",7)),
                        Year = c(rep("1",7)))
deer_holding <- tibble(Lifestage = c(rep("Adult holding",2)),
                       Month = c("08","08"),
                       Day = c("01", "15"),
                       Year = c(rep("1",2)))
deer_spawning <- tibble(Lifestage = c(rep("Spawning",4)),
                        Month = c("08","09","10","11"),
                        Day = c("15","01","01","01"),
                        Year = c(rep("1",4)))
deer_outmigration <- tibble(Lifestage = c(rep("Juvenile outmigration", 9)),
                            Month = c("11","12","01","02","03","04","05","06", "07"),
                            Day = c("01","31", rep("01",7)),
                            Year = c("1","1", rep("2", 7)))
deer <- bind_rows(deer_upstream, deer_holding, deer_spawning, deer_outmigration) %>%
  mutate(Date = case_when(Year == 1 ~ paste0(1999, "-", Month, "-",Day),
                          T ~ paste0(2000, "-",Month, "-",Day)),
         Date = ymd(Date),
         Lifestage = fct_relevel(Lifestage, "Juvenile outmigration","Spawning","Adult holding","Adult upstream migration"))
deer1 <- filter(deer, Year == 1)
deer2 <- filter(deer, Year == 2)

butte_upstream <- tibble(Lifestage = c(rep("Adult upstream migration",4)),
                         Month = c("02","03","04","05"),
                         Day = c(rep("01",4)),
                         Year = c(rep("1",4)))
butte_holding <- tibble(Lifestage = c(rep("Adult holding",5)),
                         Month = c("05","06","07","08","09"),
                         Day = c(rep("01",5)),
                         Year = c(rep("1",5)))
butte_spawning <- tibble(Lifestage = c(rep("Spawning",3)),
                         Month = c("09","10","11"),
                         Day = c("01","01","01"),
                         Year = c(rep("1",3)))
butte_outmigration <- tibble(Lifestage = c(rep("Juvenile outmigration", 5)),
                             Month = c("12","12","01","02","03"),
                             Day = c("01","31", rep("01",3)),
                             Year = c("1","1", rep("2", 3)))
butte <- bind_rows(butte_upstream, butte_holding, butte_spawning, butte_outmigration) %>%
  mutate(Date = case_when(Year == 1 ~ paste0(1999, "-", Month, "-",Day),
                          T ~ paste0(2000, "-",Month, "-",Day)),
         Date = ymd(Date),
         Lifestage = fct_relevel(Lifestage, "Juvenile outmigration","Spawning","Adult holding","Adult upstream migration"))
butte1 <- filter(butte, Year == 1)
butte2 <- filter(butte, Year == 2)

yuba_upstream <- tibble(Lifestage = c(rep("Adult upstream migration",3)),
                        Month = c("03","04","05"),
                        Day = c(rep("01",3)),
                        Year = c(rep("1",3)))
yuba_holding <- tibble(Lifestage = c(rep("Adult holding",5)),
                       Month = c("05","06","07","08","09"),
                       Day = c(rep("01",5)),
                       Year = c(rep("1",5)))
yuba_spawning <- tibble(Lifestage = c(rep("Spawning",2)),
                        Month = c("09","10"),
                        Day = c("01","15"),
                        Year = c(rep("1",2)))
yuba_outmigration <- tibble(Lifestage = c(rep("Juvenile outmigration", 9)),
                            Month = c("11","12","01","02","03","04","05","06", "07"),
                            Day = c("15","31", rep("01",7)),
                            Year = c("1","1", rep("2", 7)))
yuba <- bind_rows(yuba_upstream, yuba_holding, yuba_spawning, yuba_outmigration) %>%
  mutate(Date = case_when(Year == 1 ~ paste0(1999, "-", Month, "-",Day),
                          T ~ paste0(2000, "-",Month, "-",Day)),
         Date = ymd(Date),
         Lifestage = fct_relevel(Lifestage, "Juvenile outmigration","Spawning","Adult holding","Adult upstream migration"))
yuba1 <- filter(yuba, Year == 1)
yuba2 <- filter(yuba, Year == 2)

feather_upstream <- tibble(Lifestage = c(rep("Adult upstream migration",3)),
                           Month = c("04","05","06"),
                           Day = c(rep("01",2), "15"),
                           Year = c(rep("1",3)))
feather_holding <- tibble(Lifestage = c(rep("Adult holding",4)),
                          Month = c("06","07","08","09"),
                          Day = c("15", rep("01",3)),
                          Year = c(rep("1",4)))
feather_spawning <- tibble(Lifestage = c(rep("Spawning",2)),
                           Month = c("09","10"),
                           Day = c("01","15"),
                           Year = c(rep("1",2)))
feather_outmigration <- tibble(Lifestage = c(rep("Juvenile outmigration", 8)),
                               Month = c("11","12","01","02","03","04","05","06"),
                               Day = c("15","31", rep("01",5), "15"),
                               Year = c("1","1", rep("2", 6)))
feather <- bind_rows(feather_upstream, feather_holding, feather_spawning, feather_outmigration) %>%
  mutate(Date = case_when(Year == 1 ~ paste0(1999, "-", Month, "-",Day),
                          T ~ paste0(2000, "-",Month, "-",Day)),
         Date = ymd(Date),
         Lifestage = fct_relevel(Lifestage,"Juvenile outmigration","Spawning","Adult holding","Adult upstream migration"))
feather1 <- filter(feather, Year == 1)
feather2 <- filter(feather, Year == 2)

#######
adult_upstream <- tibble(Lifestage = c(rep("Adult upstream migration",7)),
                         Month = c("02","03","04","05","06","07","08"),
                         Day = c(rep("01",7)),
                         Year = c(rep("1",7)))
adult_holding <- tibble(Lifestage = c(rep("Adult holding",7)),
                        Month = c("05","06","07","08","09","10","11"),
                        Day = c(rep("01",7)),
                        Year = c(rep("1",7)))
spawning <- tibble(Lifestage = c(rep("Spawning",4)),
                   Month = c("08","09","10","11"),
                   Day = c("15","01","01","15"),
                   Year = c(rep("1",4)))
juvenile_migration <- tibble(Lifestage = c(rep("Juvenile outmigration", 8)),
                             Month = c("11","12","01","02","03","04","05","06"),
                             Day = c("15","31", rep("01",6)),
                             Year = c("1","1", rep("2", 6)))
life_stage_dat <- bind_rows(adult_upstream,adult_holding,spawning,
                            juvenile_migration) %>%
  mutate(Date = case_when(Year == 1 ~ paste0(1999, "-", Month, "-",Day),
                          T ~ paste0(2000, "-",Month, "-",Day)),
         Date = ymd(Date),
         Lifestage = fct_relevel(Lifestage, "Juvenile outmigration","Spawning","Adult holding","Adult upstream migration"))

life_stage_dat1 <- filter(life_stage_dat, Lifestage != "Juvenile outmigration") %>%
  rbind(filter(life_stage_dat, Lifestage == "Juvenile outmigration", Year == "1"))

# battle - 1 year; butte - less than 1 month; clear - 3 mon; deer - 1 mon; feather - unknown; mill - 1 mon; yuba - 1 mon
# mode - 1 month
upstream_data <- tibble(Lifestage = c(rep("Adult upstream migration",12)),
                        Month = c("09", "10","11","12", "01", "02", "03", "04", "05", "06", "07", "08"),
                        Day = c(rep("01",12)),
                        Year = c(rep("1",4), rep("2", 8)))
upstream_data_mode <- tibble(Lifestage = "Adult upstream migration",
                        Month = "09",
                        Day = "01",
                        Year = "1")
# battle - 2 weeks; butte - 2 weeks or end of sampling season for carcass; clear - 2 weeks; deer - immediate; feather - semi real-time; mill - near immediate;
# yuba - unknown
# mode - 2 weeks
spawning_data <- tibble(Lifestage = c("Spawning"),
                       Month = c(rep(c("11","12"),2)),
                       Day = c(rep(c("15","01"),2)),
                       Year = c("1","1", "2","2"))
spawning_data_mode <- tibble(Lifestage = "Spawning",
                        Month = "12",
                        Day = "01",
                        Year = "1")

holding_data <- tibble(Lifestage = c("Adult holding"),
                       Month = c(rep(c("11","12"),2)),
                       Day = c(rep(c("15","01"),2)),
                       Year = c("1","1", "2","2"))

holding_data_mode <- tibble(Lifestage = "Adult holding",
                            Month = "12",
                            Day = "01",
                            Year = "1")
# rst mode = 1 week
# battle - 6 mon, Butte - 1 week; clear - 3 mon; deer - only historical; feather - 3 mon; sac knl - 1 week; sac tisdale 1 week
# mill - only historical, yuba - only historical

juvenile_migration <- tibble(Lifestage = c(rep("Juvenile outmigration",6)),
                             Month = c("07","08","09","10","11","12"),
                             Day = c(rep("01",6)),
                             Year = c(rep("2",6)))
juvenile_migration_mode <- tibble(Lifestage = "Juvenile outmigration",
                                  Month = "07",
                                  Day = "08",
                                  Year = "2")
data_available <- bind_rows(spawning_data_mode, holding_data_mode, juvenile_migration_mode, upstream_data_mode) %>%
  mutate(Date = case_when(Year == 1 ~ paste0(1999, "-", Month, "-",Day),
                          T ~ paste0(2000, "-",Month, "-",Day)),
         Date = ymd(Date),
         Lifestage = fct_relevel(Lifestage, "Juvenile outmigration","Spawning","Adult holding","Adult upstream migration"))

# data_all_some <- filter(data_available, Lifestage != "Adult upstream migration") %>%
#   group_by(Year, Lifestage) %>%
#   summarize(some = min(Date),
#             all = max(Date)) %>%
#   rbind(filter(data_available, Lifestage == "Adult upstream migration") %>%
#           group_by(Lifestage) %>%
#           summarize(some = min(Date),
#                     all = max(Date))) %>%
#   pivot_longer(cols = c("some","all"), values_to = "Date")

mycolors <- c("#1b9e77", "#d95f02", "#7570b3","#e7298a")
names(mycolors) <- c("Juvenile outmigration",  "Adult holding",
                     "Adult upstream migration", "Spawning")

ggplot(life_stage_dat, aes(x = Date, y = Lifestage)) +
  geom_line(clear1, mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 4, alpha = 0.2) +
  geom_line(clear2, mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 4, alpha = 0.2) +
  geom_line(battle1, mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 4, alpha = 0.2) +
  geom_line(battle2, mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 4, alpha = 0.2) +
  geom_line(mill1, mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 4, alpha = 0.2) +
  geom_line(mill2, mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 4, alpha = 0.2) +
  geom_line(deer1, mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 4, alpha = 0.2) +
  geom_line(deer2, mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 4, alpha = 0.2) +
  geom_line(butte1, mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 4, alpha = 0.2) +
  geom_line(butte2, mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 4, alpha = 0.2) +
  geom_line(yuba1, mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 4, alpha = 0.2) +
  geom_line(yuba2, mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 4, alpha = 0.2) +
  geom_line(feather1, mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 4, alpha = 0.2) +
  geom_line(feather2, mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 4, alpha = 0.2) +
  geom_point(data_available, mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 4, alpha = 0.4) +
  scale_x_date(date_breaks = "1 month", date_labels = "%b") +
  scale_color_manual(name = "Lifestage", values = mycolors) +
  geom_vline(xintercept = ymd("2000-01-01"), linetype = "dashed", alpha = 0.6) +
  #annotate("curve", x = ymd("2000-01-25"), y = "Adult holding", xend = ymd("2000-01-07"), yend = "Adult upstream migration",
           #curvature = .3, arrow = arrow(length = unit(2, "mm")), alpha = 0.6) +
  #annotate("text", x = ymd("2000-02-20"), y = "Adult holding", label = "JPE needed", size = 3) +
  #annotate("curve", x = ymd("2000-04-05"), y = "Spawning", xend = ymd("2000-04-01"), yend = "Adult upstream migration",
           #curvature = .3, arrow = arrow(length = unit(2, "mm")), alpha = 0.6) +
  #annotate("text", x = ymd("2000-05-21"), y = "Spawning", label = "Juveniles enter delta", size = 3) +
  #annotate("text", x = ymd("1999-10-13"), y = "Adult upstream migration", label = "—Data available", size = 3) +
  #annotate("curve", x = ymd("1999-11-17"), y = "Adult upstream migration", xend = ymd("1999-11-25"), yend = "Adult holding",
           #curvature = .3, arrow = arrow(length = unit(2, "mm")), alpha = 0.6) +
  xlab("") +
  ylab("") +
  theme_minimal() +
  theme(legend.position = "none")


ggsave("lifestage_plot_updated.png", width = 8.50, height = 2, units = "in")


### scrap code below ####

ggplot(life_stage_dat, aes(x = Date, y = Lifestage)) +
  geom_line(life_stage_dat1, mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 2) +
  geom_line(filter(life_stage_dat, Lifestage == "Juvenile outmigration", Year == "2"), mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 2) +
  geom_point(data_available, mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 3, alpha = 0.4) +
  scale_x_date(date_breaks = "1 month", date_labels = "%b") +
  scale_color_manual(name = "Lifestage", values = mycolors) +
  geom_vline(xintercept = ymd("2000-01-01"), linetype = "dashed", alpha = 0.6) +
  annotate("curve", x = ymd("2000-01-25"), y = "Adult holding", xend = ymd("2000-01-07"), yend = "Adult upstream migration",
           curvature = .3, arrow = arrow(length = unit(2, "mm")), alpha = 0.6) +
  annotate("text", x = ymd("2000-02-20"), y = "Adult holding", label = "JPE needed", size = 3) +
  annotate("curve", x = ymd("2000-04-05"), y = "Spawning", xend = ymd("2000-04-01"), yend = "Adult upstream migration",
           curvature = .3, arrow = arrow(length = unit(2, "mm")), alpha = 0.6) +
  annotate("text", x = ymd("2000-05-19"), y = "Spawning", label = "Juveniles enter delta", size = 3) +
  annotate("text", x = ymd("1999-10-08"), y = "Adult upstream migration", label = "—Data available", size = 3) +
  annotate("curve", x = ymd("1999-11-15"), y = "Adult upstream migration", xend = ymd("1999-11-25"), yend = "Adult holding",
           curvature = .3, arrow = arrow(length = unit(2, "mm")), alpha = 0.6) +
  xlab("") +
  ylab("") +
  theme_minimal() +
  theme(legend.position = "bottom") 

# splitting up plots #####
lifestage <- ggplot(life_stage_dat, aes(x = Date, y = Lifestage)) +
  #geom_vline(xintercept = ymd("1999-12-01"), linetype = "dashed", alpha = 0.6) +
  #annotate("text", x = ymd("1999-09-15"), y = "Yearling outmigration", label = "SWP Initial designation", size = 3) +
  #geom_vline(xintercept = ymd("2000-04-01"), linetype = "dashed", alpha = 0.6) +
  # annotate("text", x = ymd("2000-06-15"), y = "Yearling outmigration", label = "Juveniles enter delta", size = 3) +
  geom_line(filter(life_stage_dat, Lifestage == "Juvenile outmigration", Date < ymd("2000-11-01")), mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 2) +
  geom_line(filter(life_stage_dat, Lifestage == "Juvenile outmigration", Date > ymd("2000-11-01")), mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 2) +
  geom_line(year_1, mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 2) +
  geom_line(year_2, mapping = aes(x = Date, y= Lifestage, color = Lifestage), size = 2) +
  #geom_line(filter(life_stage_dat, Lifestage %in% c("Fry holding", "Yearling outmigration")), mapping = aes(x = Date, y= Lifestage, color = Lifestage, fill = "black"), size = 2) + 
  #geom_line(filter(data_available, Year == 1, Lifestage != "Adult upstream migration"), mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 5, alpha = 0.4) +
  #geom_line(filter(data_available, Year == 2, Lifestage != "Adult upstream migration"), mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 5, alpha = 0.4) +
  #geom_line(filter(data_available, Lifestage == "Adult upstream migration"), mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 5, alpha = 0.4) +
  scale_x_date(date_breaks = "1 month", date_labels = "%b") +
  scale_color_manual(name = "Lifestage", values = mycolors) +
  xlab("") +
  ylab("") +
  theme_minimal() +
  theme(legend.position = "none") 
lifestage

data <- ggplot(data_available, aes(x = Date, y = Lifestage)) +
  geom_vline(xintercept = ymd("1999-12-01"), linetype = "dashed", alpha = 0.6) +
  annotate("text", x = ymd("1999-10-15"), y = "Yearling outmigration", label = "SWP Initial designation", size = 3) +
  geom_vline(xintercept = ymd("2000-04-01"), linetype = "dashed", alpha = 0.6) +
  annotate("text", x = ymd("2000-05-15"), y = "Yearling outmigration", label = "Juveniles enter delta", size = 3) +
  # geom_line(filter(life_stage_dat, Lifestage == "Juvenile outmigration", Date < ymd("2000-11-01")), mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 2) +
  # geom_line(filter(life_stage_dat, Lifestage == "Juvenile outmigration", Date > ymd("2000-11-01")), mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 2) +
  # geom_line(year_1, mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 2) +
  # geom_line(year_2, mapping = aes(x = Date, y= Lifestage, color = Lifestage), size = 2) +
  #geom_line(filter(life_stage_dat, Lifestage %in% c("Fry holding", "Yearling outmigration")), mapping = aes(x = Date, y= Lifestage, color = Lifestage, fill = "black"), size = 2) +
  geom_line(filter(data_available, Year == 1, Lifestage != "Adult upstream migration"), mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 5, alpha = 0.6) +
  geom_line(filter(data_available, Year == 2, Lifestage != "Adult upstream migration"), mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 5, alpha = 0.6) +
  geom_line(filter(data_available, Lifestage == "Adult upstream migration"), mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 5, alpha = 0.6) +
  scale_x_date(date_breaks = "1 month", date_labels = "%b") +
  scale_color_manual(name = "Lifestage", values = mycolors) +
  xlab("") +
  ylab("") +
  theme_minimal() +
  theme(legend.position = "bottom") 
data

gridExtra::grid.arrange(lifestage,data)

# adding points

mycolors <- c("#1b9e77","#66a61e", "#d95f02", "#e6ab02", "#7570b3","#e7298a", "dark gray", "black")
names(mycolors) <- c("Juvenile outmigration", "Yearling outmigration", "Adult holding", "Fry holding",
                     "Adult upstream migration", "Spawning", "some", "all")
ggplot(life_stage_dat, aes(x = Date, y = Lifestage)) +
  geom_vline(xintercept = ymd("1999-12-01"), linetype = "dashed", alpha = 0.6) +
  annotate("text", x = ymd("1999-09-15"), y = "Yearling outmigration", label = "SWP Initial designation", size = 3) +
  geom_vline(xintercept = ymd("2000-04-01"), linetype = "dashed", alpha = 0.6) +
  annotate("text", x = ymd("2000-06-15"), y = "Yearling outmigration", label = "Juveniles enter delta", size = 3) +
  geom_line(filter(life_stage_dat, Lifestage == "Juvenile outmigration", Date < ymd("2000-11-01")), mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 2) +
  geom_line(filter(life_stage_dat, Lifestage == "Juvenile outmigration", Date > ymd("2000-11-01")), mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 2) +
  geom_line(year_1, mapping = aes(x = Date, y = Lifestage, color = Lifestage), size = 2) +
  geom_line(year_2, mapping = aes(x = Date, y= Lifestage, color = Lifestage), size = 2) +
  geom_point(data_all_some, mapping = aes(x = Date, y = Lifestage, color = name), size = 2) +
  scale_color_manual(values = mycolors) +
  scale_x_date(date_breaks = "1 month", date_labels = "%b") +
  xlab("") +
  ylab("") +
  theme_minimal() +
  theme(legend.position = "bottom") 
ggsave("lifestage_plot2.png", width = 11, height = 3, units = "in")
# Using vistime #
library(vistime)
adult_upstream <- tibble(Lifestage = c(rep("Adult upstream migration",14)),
                         Month = c(rep(c("02","03","04","05","06","07","08"),2)),
                         Day = c(rep("01",14)),
                         Year = c(rep("1",7), rep("2",7)))
adult_holding <- tibble(Lifestage = c(rep("Adult holding",14)),
                        Month = c(rep(c("05","06","07","08","09","10","11"),2)),
                        Day = c(rep("01",14)),
                        Year = c(rep("1",7), rep("2",7)))
spawning <- tibble(Lifestage = c(rep("Spawning",8)),
                   Month = c(rep(c("08","09","10","11"),2)),
                   Day = c(rep(c("15","01","01","15"),2)),
                   Year = c(rep("1",4), rep("2",4)))
juvenile_migration <- tibble(Lifestage = c(rep("Juvenile outmigration", 10)),
                             Month = c("11","12","01","02","03","04","05","06","11","12"),
                             Day = c("15",rep("01",7),"15","01"),
                             Year = c("1","1", rep("2", 8)))
fry_holding <- tibble(Lifestage = c(rep("Fry holding",3)),
                      Month = c("06","07","08"),
                      Day = c("01","01","01"),
                      Year = c("2","2","2"))
yearling_outmigration <- tibble(Lifestage = c(rep("Yearling outmigration",4)),
                                Month = c("09","10","11","12"),
                                Day = c(rep("01",4)),
                                Year = c(rep("2",4)))

life_stage_dat <- tibble(lifestage = c(rep("Adult upstream migration",2), rep("Adult holding",2),
                         start = c("1999-02-01", "2000-02-01", "1999-05-01"),
                         stop = c("1999-08-01", "2000-08-01", "1999-11-01"),
                         type = c(rep("lifestage",2)),
                         )

