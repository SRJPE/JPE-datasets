library(readr)

# Read in data 
rst_data <- read_rds("data/rst/combined_rst.rds")
redd_data <- read_rds("data/redd_carcass_holding/combined_redd.rds") %>% 
  glimpse

upstream_passage_data <- read_rds("data/adult-upstream-passage-monitoring/combined_upstream_passage.rds") %>%
  glimpse


# Exploratory visualizations 

# Things we are intersted in 
# Sex ratios 
sex_coulumn <- upstream_passage_data %>% 
  filter(!is.na(sex)) %>% 
  pull(sex)

# Find total num males / num females 
sum(sex_coulumn == "male")
sum(sex_coulumn == "female")


# Age
# Fish Size 
# hist of sizes by sex -do not have data here
# number of redds per year 
# Upstream passage vs juveniles per year 

# Ultimate table:
# year, count, first day fished, last day fished, days not fished, prespawn mortality, sex ratio
