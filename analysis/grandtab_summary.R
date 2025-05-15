library(readxl)
library(tidyverse)

grandtab_raw <- read_xls("analysis/GrandTab_2023.xls", sheet = "GrandTab", range = "B190:U255")

yuba <- SRJPEdata::upstream_passage_estimates |> 
  filter(stream == "yuba river", year %in% 2009:2021) |> 
  select(year, stream,passage_estimate) |> 
  rename(estimate = passage_estimate)

grandtab <- grandtab_raw |> 
  filter(!is.na(RunYear)) |> 
  select(RunYear, Battle, ButteCarcass, Clear, Deer, FeaHat, Mill) |> 
  mutate(Sacramento = Battle + Clear + Deer + Mill,
         year = as.numeric(gsub("\\[|\\]", "", RunYear))) |> 
  filter(year %in% 2012:2022) |> 
  select(-RunYear) |> 
  pivot_longer(cols = Battle:Sacramento, names_to = "stream", values_to = "estimate") |> 
  mutate(type = "grandtab") |> 
  bind_rows(yuba)

grandtab_summary <- grandtab |> 
  group_by(stream) |> 
  summarize(average_estimate = mean(estimate, na.rm = T))

