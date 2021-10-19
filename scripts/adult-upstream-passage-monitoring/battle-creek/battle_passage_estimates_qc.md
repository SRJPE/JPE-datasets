Battle Creek Adult Upstream Passage Estimates QC
================
Erin Cain
9/29/2021

# Battle Creek Adult Upstream Passage Estimates

## Description of Monitoring Data

This dataset contains video outage information and extrapolated passage
estimates for Chinook Salmon using count data from the Video and Trap
and Spawning Building worksheets from 2001 to 2019. Estimates include
all runs of Chinook Salmon.

**Timeframe:** 2001 - 2019

**Completeness of Record throughout timeframe:** Passage estimates
calculated for every year in timeframe.

**Sampling Location:** Battle Creek

**Data Contact:** [Natasha Wingerter](mailto:natasha_wingerter@fws.gov)

Any additional info?

## Access Cloud Data

``` r
# Run Sys.setenv() to specify GCS_AUTH_FILE and GCS_DEFAULT_BUCKET before running 
# getwd() to see how to specify paths 
# Open object from google cloud storage
# Set your authentication using gcs_auth
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
# Set global bucket 
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

# git data and save as xlsx
gcs_get_object(object_name = 
                 "adult-upstream-passage-monitoring/battle-creek/data-raw/battle_creek_upstream_passage_datas.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "raw_battle_creek_passage_data.xlsx",
               overwrite = TRUE)
```

Read in data from google cloud, glimpse raw data and domain description
sheet:

``` r
# read in data to clean 
sheets <- readxl::excel_sheets("raw_battle_creek_passage_data.xlsx")
sheets
```

    ## [1] "Notes and Metadata"         "Video"                     
    ## [3] "Trap and Spawning Building" "Upstream Passage Estimates"

``` r
raw_passage_estimates <- read_excel("raw_battle_creek_passage_data.xlsx", 
                                    sheet = "Upstream Passage Estimates") %>% glimpse()
```

    ## Rows: 466
    ## Columns: 11
    ## $ Year                          <dbl> 2001, 2001, 2001, 2001, 2001, 2001, 2001~
    ## $ Dates                         <chr> "3-10 March", "11-17 March", "18-24 Marc~
    ## $ Week                          <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 11, 1~
    ## $ Method                        <chr> "Trap", "Trap", "Trap", "Trap", "Trap", ~
    ## $ `Hours of passage`            <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ `Hours of taped passage`      <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ `Actual number  clipped`      <chr> "3", "4", "3", "1", "0", "1", "0", "2", ~
    ## $ `Actual number unclipped`     <chr> "3", "0", "1", "2", "1", "2", "1", "13",~
    ## $ `Actual number unknown`       <chr> "0", "0", "0", "0", "0", "0", "0", "0", ~
    ## $ `Passage estimate: clipped`   <chr> "0", "0", "0", "0", "0", "0", "0", "0", ~
    ## $ `Passage estimate: unclipped` <chr> "3", "0", "1", "2", "1", "2", "1", "11",~

## Data transformations

``` r
cleaner_passage_estimates <- raw_passage_estimates %>% 
  janitor::clean_names() %>% 
  mutate(actual_number_clipped = as.numeric(actual_number_clipped),
         actual_number_unclipped = as.numeric(actual_number_unclipped),
         actual_number_unknown = as.numeric(actual_number_unknown),
         passage_estimate_clipped = as.numeric(passage_estimate_clipped),
         passage_estimate_unclipped = as.numeric(passage_estimate_unclipped)) %>%
  glimpse()
```

    ## Rows: 466
    ## Columns: 11
    ## $ year                       <dbl> 2001, 2001, 2001, 2001, 2001, 2001, 2001, 2~
    ## $ dates                      <chr> "3-10 March", "11-17 March", "18-24 March",~
    ## $ week                       <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 11, 12, ~
    ## $ method                     <chr> "Trap", "Trap", "Trap", "Trap", "Trap", "Tr~
    ## $ hours_of_passage           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 120~
    ## $ hours_of_taped_passage     <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 70.~
    ## $ actual_number_clipped      <dbl> 3, 4, 3, 1, 0, 1, 0, 2, 0, 0, 1, 1, 0, 1, 0~
    ## $ actual_number_unclipped    <dbl> 3, 0, 1, 2, 1, 2, 1, 13, 4, 3, 6, 16, 12, 6~
    ## $ actual_number_unknown      <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0~
    ## $ passage_estimate_clipped   <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 0, 1, 0~
    ## $ passage_estimate_unclipped <dbl> 3, 0, 1, 2, 1, 2, 1, 11, 5, 3, 10, 23, 12, ~

``` r
# want count, count_type = passage_estimate, actual number, adipose = cliped, unclipped, unknown

cleaner_passage_long <- cleaner_passage_estimates %>% 
  pivot_longer(!year:hours_of_taped_passage, 
               names_to = c("type", "type2", "adipose"), 
               names_sep = "_",
               values_to = "count") %>%
  mutate(count_type = paste(type, type2, sep = "_")) %>%
  select(-type, -type2) %>% glimpse()
```

    ## Rows: 2,330
    ## Columns: 9
    ## $ year                   <dbl> 2001, 2001, 2001, 2001, 2001, 2001, 2001, 2001,~
    ## $ dates                  <chr> "3-10 March", "3-10 March", "3-10 March", "3-10~
    ## $ week                   <dbl> 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 4,~
    ## $ method                 <chr> "Trap", "Trap", "Trap", "Trap", "Trap", "Trap",~
    ## $ hours_of_passage       <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ hours_of_taped_passage <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ adipose                <chr> "clipped", "unclipped", "unknown", "clipped", "~
    ## $ count                  <dbl> 3, 3, 0, 0, 3, 4, 0, 0, 0, 0, 3, 1, 0, 0, 1, 1,~
    ## $ count_type             <chr> "actual_number", "actual_number", "actual_numbe~

## Explore Numeric Variables:

``` r
cleaner_passage_long %>% select_if(is.numeric) %>% colnames()
```

    ## [1] "year"                   "week"                   "hours_of_passage"      
    ## [4] "hours_of_taped_passage" "count"

### Variable: `year`, `week`

**Plotting weeks per year over Period of Record**

``` r
cleaner_passage_long %>% 
  group_by(year) %>% 
  summarise(num_weeks_sampled = max(week)) %>% 
  ggplot() + 
  geom_col(aes(x = year, y = num_weeks_sampled))
```

![](battle_passage_estimates_qc_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

Every year there were between 22 and 28 weeks sampled.

**Numeric Summary of \[Variable\] over Period of Record**

``` r
summary(cleaner_passage_long$week)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    1.00    6.00   12.00   12.08   18.00   28.00

``` r
summary(cleaner_passage_long$year)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    2001    2005    2010    2010    2015    2019

**NA and Unknown Values**

-   0 % of values in the `week` column are NA.
-   0 % of values in the `year` column are NA.

### Variable: `hours_of_passage`, `hours_of_taped_passage`

**Plotting over Period of Record**

``` r
# Make whatever plot is appropriate 
# maybe 2+ plots are appropriate
```

**Numeric Summary of \[Variable\] over Period of Record**

``` r
# Table with summary statistics
```

**NA and Unknown Values**

Provide a stat on NA or unknown values

## Explore Categorical variables:

General notes: If there is an opportunity to turn yes no into boolean do
so, but not if you loose value

``` r
# Filter clean data to show only categorical variables
```

### Variable: `[name]`

``` r
#table() 
```

Fix inconsistencies with spelling, capitalization, and abbreviations.

``` r
# Fix any inconsistencies with categorical variables
```

**Create lookup rda for \[variable\] encoding:**

``` r
# Create named lookup vector
# Name rda [watershed]_[data type]_[variable_name].rda
# save rda to data/ 
```

**NA and Unknown Values**

Provide a stat on NA or unknown values

## Summary of identified issues

-   List things that are funcky/bothering us but that we don’t feel like
    should be changed without more investigation

## Save cleaned data back to google cloud

``` r
# Write to google cloud 
# Name file [watershed]_[data type].csv
```
