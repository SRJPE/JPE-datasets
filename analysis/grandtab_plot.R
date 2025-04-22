# create plot of grandtab estimates
library(tidyverse)
grandtab_raw <- read_csv("analysis/grandtab_spring.csv")

grandtab <- grandtab_raw |> 
  separate(`Hatcheries In-River`, into = c("hatchery", "river"), sep = " ") |> 
  mutate(hatchery = as.numeric(gsub(",", "", hatchery)),
         river = as.numeric(gsub(",","", river)),
         year = as.numeric(gsub("\\[|\\]", "", year)))

grandtab |> 
  pivot_longer(cols = c(hatchery, river, TOTAL), names_to = "type", values_to = "adult_population") |> 
  filter(type == "river", year >= 1999) |> 
  ggplot(aes(x = year, y = adult_population, color = type)) +
  geom_point() +
  geom_line() +
  geom_smooth()
