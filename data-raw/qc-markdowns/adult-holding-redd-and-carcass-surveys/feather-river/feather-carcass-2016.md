Feather Carcass QC 2016
================
Inigo Peng
2022-07-21

# Feather River Carcass Data

## Description of Monitoring Data

**Timeframe:**

**Video Season:**

**Completeness of Record throughout timeframe:**

**Sampling Location:**

**Data Contact:**

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
```

Read in data from google cloud, glimpse raw data and domain description
sheet:

``` r
gcs_get_object(object_name = "adult-holding-redd-and-carcass-surveys/feather-river/data-raw/carcass/2016/Chops_2016.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "Chops_2016.xlsx",
               overwrite = TRUE)
#
gcs_get_object(object_name = "adult-holding-redd-and-carcass-surveys/feather-river/data-raw/carcass/2016/ChopHeader_2016.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "ChopHeader_2016.xlsx",
               overwrite = TRUE)

# 
gcs_get_object(object_name = "adult-holding-redd-and-carcass-surveys/feather-river/data-raw/carcass/2016/CWTHeader_2016.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "CWTHeader_2016.xlsx",
               overwrite = TRUE)

gcs_get_object(object_name = "adult-holding-redd-and-carcass-surveys/feather-river/data-raw/carcass/2016/CWT_2016.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "CWT_2016.xlsx",
               overwrite = TRUE)
```

## Raw Data Glimpse:

### Chop_raw

``` r
Chop_raw <- read_excel("Chops_2016.xlsx") %>%
  rename("ID" = `Chop Header ID`,
         "Count" = `Total Count`) %>%
  glimpse()
```

    ## Rows: 976
    ## Columns: 5
    ## $ `Chop ID` <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ ID        <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, ~
    ## $ Section   <chr> "21", "20", "19", "18", "17", "16", "15", "14", "13", "12", ~
    ## $ Minutes   <dbl> 28, 10, 17, 8, 14, 27, 28, 28, 20, 12, 14, 25, 16, 10, 9, 6,~
    ## $ Count     <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~

### ChopHeader_raw

``` r
ChopHeader_raw <- read_excel("ChopHeader_2016.xlsx") %>% 
  rename(ID = `Chop Header ID`,
         week_number = `Week #`) %>%
  glimpse()
```

    ## Rows: 115
    ## Columns: 7
    ## $ Date        <dttm> 2016-08-17, 2016-08-18, 2016-08-22, 2016-08-23, 2016-08-2~
    ## $ week_number <chr> NA, "pre carcass", "pre carcass", "pre carcass", "pre-carc~
    ## $ Weather     <chr> "sun", "sun", "sun", "sun", "sun", "sun", "sun", "sun", "s~
    ## $ Time        <chr> "09:20", "9:00", "8:55", "12:30", "10:00", NA, "9:15", "9:~
    ## $ Crew        <chr> "tk, mh", "jcall, tv", "mh,tk", "mh, tk", "mh,tk", NA, "mh~
    ## $ Comments    <chr> "PRE CARCASS", NA, NA, NA, NA, NA, NA, NA, "The two chops ~
    ## $ ID          <dbl> 1, 2, 4, 3, 5, 6, 10, 11, 12, 13, 14, 15, 16, 17, 19, 18, ~

### cwt_raw

``` r
cwt_raw <- read_excel("CWT_2016.xlsx") %>% 
  rename("ID" = `CWT Header ID`) %>% 
  glimpse
```

    ## Rows: 6,892
    ## Columns: 16
    ## $ `CWT ID`                 <dbl> 41396, 41188, 41198, 41441, 41207, 41370, 412~
    ## $ ID                       <dbl> 1644, 1635, 1635, 1648, 1636, 1642, 1635, 163~
    ## $ `River Section`          <dbl> 27, 14, 12, 21, 12, 3, 12, 1, 29, 12, 1, 8, 6~
    ## $ `Tag ID#`                <chr> "7916", "7805", "7810", NA, "7814", "7906", "~
    ## $ `Tag, Recapture or Chop` <chr> "T", "T", "T", "C", "T", "T", "T", "T", "T", ~
    ## $ Sex                      <chr> "F", "F", "M", "M", "F", "F", "F", "F", "F", ~
    ## $ `Spawning Condition`     <chr> "S", "S", "UK", "UK", "S", "S", "S", "S", "S"~
    ## $ `Adipose Fin Clipped?`   <chr> "Y", "N", "Y", "N", "N", "UK", "Y", "Y", "Y",~
    ## $ `Samples Collected`      <chr> "H&S&O", "S&O", "H", "S&O", "S&O", "S&O", "H&~
    ## $ `Fork Length`            <dbl> 74, 87, 67, 63, 92, 69, 93, 75, 75, 75, 82, 7~
    ## $ `Head Tag Number`        <chr> "24826", NA, "24817", NA, NA, NA, "24818", "2~
    ## $ Scales                   <chr> "16554", "16611", "16606", "16281", "16603", ~
    ## $ Otoliths                 <chr> "498", "496", "495", "494", "492", "491", "49~
    ## $ `Hallprint Color`        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ Hallprint                <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ Comments                 <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, "SCAL~

### cwt_header_raw

``` r
cwt_header_raw <- read_excel("CWTHeader_2016.xlsx") %>% 
  rename("ID" = `CWT Header ID` ) %>% 
  glimpse
```

    ## Rows: 299
    ## Columns: 10
    ## $ ID                    <dbl> 1353, 1354, 1355, 1356, 1357, 1358, 1359, 1360, ~
    ## $ Date                  <dttm> 2016-08-06, 2016-08-17, 2016-08-22, 2016-08-23,~
    ## $ Crew                  <chr> "SR, MI, Tk", "TK, MH", "tk, mh", "mh, tk", "mh,~
    ## $ `Week #`              <dbl> 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 4, 4, 4, 4, 4, 5, ~
    ## $ `Tag Color`           <chr> NA, NA, NA, NA, NA, NA, NA, NA, "blue", "SILVER"~
    ## $ Morale                <chr> "PRE CARCASS", "Pre Carcass", "Pre Carcass", "Pr~
    ## $ `Section Group 1-10`  <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ `Section Group 11-15` <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ `Section Group 16-21` <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ `Section Group 22-38` <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~

## Data transformations:

### Counts

The `chop` table contains carcass counts by chop/tagged based on clips

``` r
#1. chop table (with dates and tag color)
chop_join <- full_join(ChopHeader_raw %>% 
                                 select(ID, Date),
                               Chop_raw) %>% 
  clean_names() %>% 
  rename(sec = "section",
         min = "minutes") %>% 
  mutate(sec = as.numeric(sec)) %>% glimpse
```

    ## Joining, by = "ID"

    ## Rows: 976
    ## Columns: 6
    ## $ id      <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2,~
    ## $ date    <dttm> 2016-08-17, 2016-08-17, 2016-08-17, 2016-08-17, 2016-08-17, 2~
    ## $ chop_id <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ sec     <dbl> 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5,~
    ## $ min     <dbl> 28, 10, 17, 8, 14, 27, 28, 28, 20, 12, 14, 25, 16, 10, 9, 6, 8~
    ## $ count   <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,~

### Survey

The `chop_header` table contains survey metadata and covariates

``` r
chop_header <- ChopHeader_raw %>% 
  clean_names() %>% glimpse
```

    ## Rows: 115
    ## Columns: 7
    ## $ date        <dttm> 2016-08-17, 2016-08-18, 2016-08-22, 2016-08-23, 2016-08-2~
    ## $ week_number <chr> NA, "pre carcass", "pre carcass", "pre carcass", "pre-carc~
    ## $ weather     <chr> "sun", "sun", "sun", "sun", "sun", "sun", "sun", "sun", "s~
    ## $ time        <chr> "09:20", "9:00", "8:55", "12:30", "10:00", NA, "9:15", "9:~
    ## $ crew        <chr> "tk, mh", "jcall, tv", "mh,tk", "mh, tk", "mh,tk", NA, "mh~
    ## $ comments    <chr> "PRE CARCASS", NA, NA, NA, NA, NA, NA, NA, "The two chops ~
    ## $ id          <dbl> 1, 2, 4, 3, 5, 6, 10, 11, 12, 13, 14, 15, 16, 17, 19, 18, ~

### CWT

The `cwt` table contains coded wire tag information.

``` r
cwt <- full_join(cwt_header_raw, cwt_raw) %>% 
  clean_names() %>% 
  rename(fl = "fork_length") %>% 
  mutate(head_tag_number = as.numeric(head_tag_number),
         tag_id_number = as.numeric(tag_id_number),
         scales = as.numeric(scales),
         otoliths = as.numeric(otoliths))%>% glimpse()
```

    ## Joining, by = "ID"

    ## Rows: 6,893
    ## Columns: 25
    ## $ id                    <dbl> 1353, 1354, 1354, 1354, 1354, 1354, 1354, 1354, ~
    ## $ date                  <dttm> 2016-08-06, 2016-08-17, 2016-08-17, 2016-08-17,~
    ## $ crew                  <chr> "SR, MI, Tk", "TK, MH", "TK, MH", "TK, MH", "TK,~
    ## $ week_number           <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
    ## $ tag_color             <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ morale                <chr> "PRE CARCASS", "Pre Carcass", "Pre Carcass", "Pr~
    ## $ section_group_1_10    <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ section_group_11_15   <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ section_group_16_21   <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ section_group_22_38   <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ cwt_id                <dbl> 34342, 34354, 34353, 34352, 34351, 34350, 34349,~
    ## $ river_section         <dbl> 14, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, ~
    ## $ tag_id_number         <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ tag_recapture_or_chop <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ sex                   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ spawning_condition    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ adipose_fin_clipped   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ samples_collected     <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ fl                    <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ head_tag_number       <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ scales                <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ otoliths              <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ hallprint_color       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ hallprint             <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ comments              <chr> "No Fish", "No Fish", "No Fish", "No Fish", "No ~

## Explore Numeric Variables:

``` r
# Filter clean data to show only numeric variables 
chop_join %>% 
  select_if(is.numeric) %>%
  colnames()
```

    ## [1] "id"    "sec"   "min"   "count"

### Chop Join Variable: `id`, `section`, `min`

``` r
summary(chop_join$id)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    1.00   21.00   52.00   56.35   92.00  115.00

``` r
summary(chop_join$sec)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    1.00   10.00   19.00   19.55   29.00   39.00       1

``` r
summary(chop_join$min)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    1.00   10.00   16.00   31.02   30.00  350.00       4

### Chop Join Variable: `count`

**Numeric Summary of `count` over Period of Record**

``` r
summary(chop_join$count)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00    0.00    1.00   23.63   14.50  603.00       1

**NA and Unknown Values**

-   0.1 % of values in the `count` column are NA.

**Plotting count over Period of Record**

``` r
# daily chop count over time
chop_join %>% 
  ggplot(aes(x = date, y = count)) +
  geom_point() + 
  theme_minimal() +
  theme(text = element_text(size = 15))
```

![](feather-carcass-2016_files/figure-gfm/unnamed-chunk-15-1.png)<!-- -->

This plot shows the daily chops collected each day from August to
December 2016. The data from 2016 does not contain tags information - it
only has count.

**Plotting total chops over Period of Record**

``` r
chop_join %>% 
  group_by(date) %>% 
  summarize(total_chops = sum(count, na.rm = T)) %>% 
  ggplot(aes(x = date, y = total_chops)) + 
  geom_col() + 
  theme_minimal()
```

![](feather-carcass-2016_files/figure-gfm/unnamed-chunk-16-1.png)<!-- -->

This plot shows the daily total chops collected between August and
December. \### Chop Header Variable: `id`

``` r
chop_header %>% 
  select_if(is.numeric) %>% 
  colnames()
```

    ## [1] "id"

``` r
summary(chop_header$id)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##     1.0    29.5    58.0    58.0    86.5   115.0

### CWT Variable: `ID`, `sect`, `fl`, `header_id`, `week_num`

``` r
cwt %>% 
  select_if(is.numeric) %>% 
  colnames()
```

    ##  [1] "id"              "week_number"     "cwt_id"          "river_section"  
    ##  [5] "tag_id_number"   "fl"              "head_tag_number" "scales"         
    ##  [9] "otoliths"        "hallprint"

``` r
summary(cwt$fl)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   28.00   73.00   78.00   77.77   84.00  108.00    3045

``` r
summary(cwt$river_section)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    1.00    8.00   10.00   10.28   12.00   38.00       1

-   44.2 % of values in the `fl` column are NA.
-   0 % of values in the `sect` column are NA.

``` r
#Create a cwt_count column
#Pivot table to expand sex column to female_cwt, male_cwt, and unknown_cwt 
#Is this graph helpful?
unique(cwt$sex)
```

    ## [1] NA  "F" "M"

``` r
cwt_count <- cwt %>% 
  mutate(count = 1) %>%
  mutate(sex = case_when(sex == "ND"|is.na(sex)|sex =="UK" ~ "U",
                         TRUE ~ sex)) %>% 
  pivot_wider(names_from = sex, values_from = count, values_fill = 0) %>% 
  # unnest() %>% 
  rename("male_cwt" = M,
         "female_cwt" = F,
         "unknown_cwt" = U) %>% glimpse
```

    ## Rows: 6,893
    ## Columns: 27
    ## $ id                    <dbl> 1353, 1354, 1354, 1354, 1354, 1354, 1354, 1354, ~
    ## $ date                  <dttm> 2016-08-06, 2016-08-17, 2016-08-17, 2016-08-17,~
    ## $ crew                  <chr> "SR, MI, Tk", "TK, MH", "TK, MH", "TK, MH", "TK,~
    ## $ week_number           <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
    ## $ tag_color             <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ morale                <chr> "PRE CARCASS", "Pre Carcass", "Pre Carcass", "Pr~
    ## $ section_group_1_10    <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ section_group_11_15   <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ section_group_16_21   <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ section_group_22_38   <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ cwt_id                <dbl> 34342, 34354, 34353, 34352, 34351, 34350, 34349,~
    ## $ river_section         <dbl> 14, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, ~
    ## $ tag_id_number         <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ tag_recapture_or_chop <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ spawning_condition    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ adipose_fin_clipped   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ samples_collected     <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ fl                    <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ head_tag_number       <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ scales                <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ otoliths              <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ hallprint_color       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ hallprint             <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ comments              <chr> "No Fish", "No Fish", "No Fish", "No Fish", "No ~
    ## $ unknown_cwt           <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ~
    ## $ female_cwt            <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
    ## $ male_cwt              <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~

``` r
total_cwt_summary <- cwt_count %>% 
  mutate(male_cwt = ifelse(is.na(male_cwt), 0, male_cwt), # fill na
         female_cwt = ifelse(is.na(female_cwt), 0, female_cwt),
         unknown_cwt = ifelse(is.na(unknown_cwt), 0, unknown_cwt),
         total_cwt = unknown_cwt + male_cwt + female_cwt) %>% 
  group_by(month(date)) %>% 
  summarise(total_cwt = sum(total_cwt),
            male_cwt = sum(male_cwt),
            female_cwt = sum(female_cwt),
            unknown_cwt = sum(unknown_cwt))
```

``` r
total_cwt_summary %>% 
  pivot_longer(cols = c(male_cwt, female_cwt, unknown_cwt), names_to = "sex", values_to = "count") %>% 
  mutate(proportions = (count / total_cwt)) %>% 
  ggplot(aes(x = `month(date)`, y = proportions, fill = sex)) + 
  geom_bar(stat = "identity", position = "stack") +
  scale_fill_manual(name = "chops", 
                    labels = c("CWT Male", "CWT Female", "CWT Unknown")) +
  theme_minimal() + 
  labs(y = "Proportion", x = "Month") +
  scale_fill_manual(values = wes_palette("Moonrise2"))
```

    ## Scale for 'fill' is already present. Adding another scale for 'fill', which
    ## will replace the existing scale.

![](feather-carcass-2016_files/figure-gfm/unnamed-chunk-23-1.png)<!-- -->

**Plotting fork length of each sex**

``` r
cwt %>% 
  mutate(sex = case_when(sex == "ND"|is.na(sex)|sex =="UK" ~ "Unknown",
                         TRUE ~ sex))%>% 
  ggplot(aes(x = sex, y = fl)) + 
  geom_boxplot() + 
  theme_minimal() + 
  labs(y = "FL", x = "Sex")
```

![](feather-carcass-2016_files/figure-gfm/unnamed-chunk-24-1.png)<!-- -->

## Explore Categorical variables:

### Chop Clean Data

Fix inconsistencies with spelling, capitalization, and dates

``` r
chop_join %>% 
  select_if(is.character) %>%
  colnames()
```

    ## character(0)

``` r
chop_cleaner <- chop_join %>%
  mutate(date = as_date(date)) %>%
  mutate_if(is.character, str_to_lower) %>% 
  select(-chop_id)

chop_cleaner
```

    ## # A tibble: 976 x 5
    ##       id date         sec   min count
    ##    <dbl> <date>     <dbl> <dbl> <dbl>
    ##  1     1 2016-08-17    21    28     0
    ##  2     1 2016-08-17    20    10     0
    ##  3     1 2016-08-17    19    17     0
    ##  4     1 2016-08-17    18     8     0
    ##  5     1 2016-08-17    17    14     0
    ##  6     1 2016-08-17    16    27     0
    ##  7     1 2016-08-17    15    28     0
    ##  8     1 2016-08-17    14    28     0
    ##  9     1 2016-08-17    13    20     0
    ## 10     1 2016-08-17    12    12     0
    ## # ... with 966 more rows

### Chop Header Clean Data

``` r
chop_header %>% 
  select_if(is.character) %>% 
  colnames()
```

    ## [1] "week_number" "weather"     "time"        "crew"        "comments"

``` r
unique(chop_header$crew)
```

    ##   [1] "tk, mh"         "jcall, tv"      "mh,tk"          "mh, tk"        
    ##   [5] NA               "tk,kt"          "sr,mi,tk"       "cm,tk,cc"      
    ##   [9] "tv,ac,cm"       "cm,cc,tk"       "cm,bf,ai"       "tk,ac,mh"      
    ##  [13] "cm,tk,ai,bf"    "ai,mi,cc,bf"    "kt,tk,sr"       "sr,mi,tk,bf"   
    ##  [17] "cc,ai,tk,bi"    "ac,sr,mi,tk"    "bf,ai,kt,cs"    "ai,kt,sr,tk"   
    ##  [21] "gc, bf,tk"      "tk,tex,cc"      "cjc, tk, ac,ai" "mh,mi,cm,tv"   
    ##  [25] "tk,cc,sr"       "ai,kt,tx"       "bf,tv,mh"       "ai,kt,cjc,tk"  
    ##  [29] "jk,ai,mi,tk"    "mh,sr,cjc,kl"   "kt,jk,ai,cc"    "mh,mi,sr,tk"   
    ##  [33] "sr,tk"          "cc,mi"          "mh,sr,csc,jk"   "cm,kl,sm,tk"   
    ##  [37] "bf,kt,mi,sk"    "mh,cjc,ai,tv"   "mh,jk,mi,bf"    "kt,tk,cjc, ai" 
    ##  [41] "jc,cc.kl"       "mh,tv,bf"       "ai,cjc,tk"      "cm,mi,cc"      
    ##  [45] "mh,sr"          "kt,ai,tk,sr"    "jk,sr,bf,tk"    "mi,ai,cjc,mh"  
    ##  [49] "sm,tv,kt,jc"    "mh,jr,bf"       "kt,mi,jk,tv"    "ai,sr"         
    ##  [53] "sr,tv,mi"       "kt,bf,cm,kh"    "cc,cc,ai,tv"    "CC,JC"         
    ##  [57] "CM,TV,BF"       "SR,JK,AI"       "MH,SR"          "SR,TV,KT,AI"   
    ##  [61] "MH,CJC,MI,JK"   "BF,SR,MI,TV"    "MH,CJC,AI,JK"   "ai,cjc,kt,jk"  
    ##  [65] "MH,MI,SR"       "BF,SM"          "MH,MI,TV,SR"    "JC,CC,CC,AI"   
    ##  [69] "AI,SR"          "MH,AH"          "JC,CJC"         "AC,TK,SR,TEX"  
    ##  [73] "AI,MI,CC,TJ"    "AI,CM"          "BF,TW,TV,JC"    "MH,SR,MI"      
    ##  [77] "MH,MI,AI"       "BF,TV,SR,TK"    "BF,TW,JC,TV"    "KT,MI,TV"      
    ##  [81] "TJ,CM,AI,SR"    "CJC,CC,MH,BI"   "BF,CJC,CM,TV"   "MH,SR,JC"      
    ##  [85] "KT,AI,CC,TJ"    "SR,TX"          "CM,TV"          "BF,TW,AI"      
    ##  [89] "bf,ai,mh,cjc"   "ai,tj,tx,mi"    "BF,CM,CJC,SR"   "CM,CC,BF,MH"   
    ##  [93] "TK,MH"          "BF,TJ"          "BF,TEX,CM,AC"   "cm,mh,tj,mi"   
    ##  [97] "bf,ai,sr,cjc"   "bf,tex,tk"      "ai,bf"          "mh,cjc"        
    ## [101] "tex,cjc,tv"     "bf,tex,tj,tv"   "bf,tex,tj"      "ac,cjc,tex"    
    ## [105] "MH,TV"

``` r
unique(chop_header$weather)
```

    ##  [1] "sun"         "cld"         "clr"         "cld/rain"    "rain"       
    ##  [6] NA            "SUN"         "SUN/CLD"     "CLD"         "sun/cld/ran"
    ## [11] "cld,rain"    "BF,TJ"

``` r
chop_header_cleaner <- chop_header %>%
  mutate_if(is.character, str_to_lower) %>% 
  mutate(crew = str_replace_all(crew, " ", ","),
         crew = str_replace_all(crew, ",,", ","),
         weather = case_when(weather == "cld" ~ "cloudy",
                             weather == "cld/rain" ~ "cloudy, rain",
                             weather == "sun/cld" ~ "sun, cloudy",
                             weather == "sun/cld/ran" ~ "sun, cloudy, rain",
                             TRUE ~ weather),
         weather = str_replace_all(weather, " ", ""),
         weather = str_replace_all(weather, "/", ",")) %>% 
  select(-c(time))

chop_header_cleaner
```

    ## # A tibble: 115 x 6
    ##    date                week_number weather crew     comments                  id
    ##    <dttm>              <chr>       <chr>   <chr>    <chr>                  <dbl>
    ##  1 2016-08-17 00:00:00 <NA>        sun     tk,mh    pre carcass                1
    ##  2 2016-08-18 00:00:00 pre carcass sun     jcall,tv <NA>                       2
    ##  3 2016-08-22 00:00:00 pre carcass sun     mh,tk    <NA>                       4
    ##  4 2016-08-23 00:00:00 pre carcass sun     mh,tk    <NA>                       3
    ##  5 2016-08-24 00:00:00 pre-carcass sun     mh,tk    <NA>                       5
    ##  6 2016-08-24 00:00:00 pre carcass sun     <NA>     <NA>                       6
    ##  7 2016-08-29 00:00:00 pre carcass sun     mh,tk    <NA>                      10
    ##  8 2016-08-30 00:00:00 pre carcass sun     tk,kt    <NA>                      11
    ##  9 2016-09-06 00:00:00 1           sun     sr,mi,tk the two chops were fi~    12
    ## 10 2016-09-07 00:00:00 1           sun     cm,tk,cc <NA>                      13
    ## # ... with 105 more rows

### CWT Clean Data

``` r
cwt %>% 
  select_if(is.character) %>% 
  colnames
```

    ##  [1] "crew"                  "tag_color"             "morale"               
    ##  [4] "tag_recapture_or_chop" "sex"                   "spawning_condition"   
    ##  [7] "adipose_fin_clipped"   "samples_collected"     "hallprint_color"      
    ## [10] "comments"

``` r
unique(cwt$spawning_condition)
```

    ## [1] NA   "S"  "UK" "U"

``` r
unique(cwt$adipose_fin_clipped)
```

    ## [1] NA   "Y"  "N"  "UK"

``` r
unique(cwt$crew)
```

    ##   [1] "SR, MI, Tk"      "TK, MH"          "tk, mh"          "mh, tk"         
    ##   [5] "sr,mi,tk"        "mh,tk"           "tk, ac, mh"      "AI, MI, CC, BF" 
    ##   [9] "kt, sr, tk"      "ai, mi, bf, cc"  "kt, tk, sr"      "sr,mi,tk,bf"    
    ##  [13] "cc,ai,tk,bf"     "bf, ai, cs, kt"  "ac,tk,mi,sr"     "ak,tk,sr,mi"    
    ##  [17] "ac, sr, tk, mi"  "ac, sr, mi, tk"  "ac, tk,sr, mi"   "BF, AI, CS, KT" 
    ##  [21] "ai, sr, kt, tk"  "gc, bf,tk"       "cjc,tk,mh"       "cjc, ai, ac, tk"
    ##  [25] "cc,ac,ai"        "tk,ai,ac"        "tk, cc,br"       "mh,mi,cs,tv"    
    ##  [29] "ai,tk,sr,cjc"    "ai,tk,cjc,sr"    "mh,mi,cm,tv"     "sr,tk,cjc,ai"   
    ##  [33] "ai,kt,tx"        "ai,kt,cjc,tk"    "ai,kt,cjc"       "ai,kt,tk,cjc"   
    ##  [37] "ai,tk"           "JK,AI,TK,MI"     "MH,SR,CJC,KL"    "mh,sr,cjc,kl"   
    ##  [41] "sr, tk"          "JK,TK,MI,AI"     "jk,ai,tk,mi"     "jk,ai,mi,tk"    
    ##  [45] "MH,TV,KL,SR"     "mh,mi,sr,tk"     "jk,cc,ai,kl"     "mh, mi, sr, tk" 
    ##  [49] "kt, jk,ai,cc"    "cc,mi"           "jk,sr,mh,cjc"    "sm,kt,tk"       
    ##  [53] "cm,kl,sm,tk"     "cm,kl,tk,sm"     "mh,sr,jk,cjc"    "mh,sr,cjc,jk"   
    ##  [57] "mh,jk,cjc,sr"    NA                "bf,kt,mi,sr"     "BF,KT,SR,MI"    
    ##  [61] "BG,KT,MI,SR"     "BF,KL,SR,MI"     "MH,AI,CJC,TV"    "MY,AI,CJC,TV"   
    ##  [65] "mh,tv,cjc,ai"    "cjc,ai,tv,mh"    "BF,KT,MI,SR"     "kt,tk,ai,cjc"   
    ##  [69] "mh,rf,jk,mi"     "kt,jc,cjc,ai"    "mh,bf,jk,mi"     "mh,jk,mi"       
    ##  [73] "kt,tk,cjc,ai"    "ai"              "jc,kl,cc"        "jc,cc,kl"       
    ##  [77] "cr,jk,ai,bf"     "tv,mh,bf"        "MH,SR"           "ai,kt,bf,tk"    
    ##  [81] "kt,ai,tk,sr,bf"  "sr,tk,kt,ai"     "cm,cc,mi"        "CM,CC,MI,TV"    
    ##  [85] "mh,sr"           "CM,CC,MI"        "mh,mi,ai,cjc"    "bf,jk,sr,tk"    
    ##  [89] "jf,bf,sr,tk"     "cjc,mi,ai,mi"    "mh,ai,mi,cjc"    "sm,tv,kt,jc"    
    ##  [93] "sm,jc,kt,tv"     "10"              "MH,CJC,MI,AI"    "mi,ai,mh,cjc"   
    ##  [97] "BF,JK,SR,TK"     "ai,cjc,sr,tk"    "tv,mi,jk"        "jk,mi"          
    ## [101] "kt,jk,tv,mi"     "mh,bf,jc"        "ai,sr,cj"        "cjc,tk,sr,ai"   
    ## [105] "ai,sr,cjc,tk"    "ec,cc,ai,tk"     "sr.tv.,I"        "cc,cc,ai,tk"    
    ## [109] "cl,cc,ai,tk"     "kt,bf,cm,kh"     "sr,tv,mi"        "cc,jc"          
    ## [113] "sr,jk,ai"        "cm,tv,bf"        "MI,CJC,TK"       "sr,tv,kt,ai"    
    ## [117] "ai,kh,kt,tv"     "AI,TV,KH,KT"     "sr,mh"           "SR,MH"          
    ## [121] "MI,TK,CJC"       "MH,CJC,MI,TK"    "MH,MI,TK,CJC"    "MH,CJC,TK,MI"   
    ## [125] "bf,sr,mi,tv"     "mh,ai,cjc,jk"    "mh,cjc,ai,jk"    "mh,jk,ai,cjc"   
    ## [129] "mh,ai,jk,cjc"    "bf,se,mi,tv"     "kt,jk,cjc,ai"    "kt,jk"          
    ## [133] "bf,cm,tv,kh"     "ai,cjc,kt,jk"    "mh,sr,mi"        "mh,jc,mi,sr"    
    ## [137] "mh,jc,sr,mi"     "mh,sr,mi,jc"     "ai,kt,cjc,jk"    "mi,jc,sr,mh"    
    ## [141] "mh,sr,jc,mi"     "mh,sr,mi,tv"     "bf, sm"          "cc,ai,jc,cjc"   
    ## [145] "ai,cc,cjc,jc"    "ai,cc,cjc,jk"    "mh,tv,sr,mi"     "jc,cc,ai"       
    ## [149] "jc,cjc"          "sr,ai"           "mh, ah"          "ai,mi,cc,tj"    
    ## [153] "ai,mi,cc,tc"     "ac,tk,sr,tex"    "AC,TK,SR,TEX"    "AI,MI,CC,TJ"    
    ## [157] "mh,mi,sr"        "BF,TW,TV,JC"     "bf,tw,tv,jc"     "ai,cm"          
    ## [161] "bf,tw,sr,tk"     "MH,CC,MI,AI"     "MI,MH,AI"        "bf,tj,sr,tk"    
    ## [165] "bf,tw,jc,tv"     "AI,SR,CM,TJ"     "KT,MI,TV,AC"     "KT,MI,TV"       
    ## [169] "CM,SR,TJ,AI"     "CM,AI,SR,TJ"     "BF,CJC,CC,MH"    "bf,cjc,cc,mh"   
    ## [173] "cjc,cc,mh,bf"    "BF,CJC,CM,TV"    "MH,SR,JC"        "MH,JC,SR"       
    ## [177] "mh,sr,jc"        "KT,CC,AI,TJ"     "kt,ai,cc,tj"     "cm,tv"          
    ## [181] "sr,tx"           "BF,TX,CJC,AI"    "bf,mh,ai,cjc"    "BF,AI,MH,CJC"   
    ## [185] "bf,cm,cjc,sr"    "MH,AI,MI,TW"     "AI,TJ,TX,MI"     "MH,MI,AI,TW"    
    ## [189] "cj,bf,mh,ccam"   "ac,cjc,tex"      "bf,tj"           "bf,tex,cm,ac"   
    ## [193] "cm,mh,mi,tj"     "bf,ai,sr,cjc"    "bf,ai,sk,cjc"    "cm,mi,tj,mh"    
    ## [197] "cm,ch,mi,tj"     "bf,tex,tk"       "MH, CJC"         "af, bf"         
    ## [201] "TEX, CJC, TV"    "tex,cjc,tv"      "bf,tex,tj,tv"    "BF,TJ"

``` r
unique(cwt$tag_recapture_or_chop)
```

    ## [1] NA  "T" "R" "C"

``` r
unique(cwt$samples_collected)
```

    ## [1] NA      "H&S&O" "S&O"   "H"

``` r
unique(cwt$tag_color)
```

    ## [1] NA       "blue"   "SILVER" "silver"

``` r
unique(cwt$hallprint_color)
```

    ## [1] NA  "G"

``` r
#Dropping sectiongroup and morale
cwt_cleaner <- cwt %>% 
  mutate_if(is.character, str_to_lower) %>% 
  rename(datetime = "date") %>% 
  mutate(crew = str_replace_all(crew, " ", ","),
         crew = str_replace_all(crew, ",,", ","),
         sex = case_when(sex == "nd"|is.na(sex) ~ "unknown",
                         TRUE ~ sex),
         tag_recapture_or_chop = case_when(tag_recapture_or_chop == "T" ~ "tagged",
                                         tag_recapture_or_chop == "R" ~ "recapture",
                                         tag_recapture_or_chop == "C" ~ "chop",
                                         TRUE ~ tag_recapture_or_chop),
         adipose_fin_clipped = case_when(adipose_fin_clipped == "UK" ~ "unknown",
                                         adipose_fin_clipped == "Y" ~ "yes",
                                         adipose_fin_clipped == "N" ~ "no",
                                         TRUE ~ adipose_fin_clipped),
         hallprint_color = case_when(hallprint_color == "grey" ~ "G",
                                     TRUE ~ hallprint_color),
         spawning_condition = case_when(spawning_condition == "UK" ~ "unknown",
                                        TRUE ~ spawning_condition)) %>% 
  select(-c(morale, section_group_1_10, section_group_11_15, section_group_16_21, section_group_22_38)) %>% 
  glimpse
```

    ## Rows: 6,893
    ## Columns: 20
    ## $ id                    <dbl> 1353, 1354, 1354, 1354, 1354, 1354, 1354, 1354, ~
    ## $ datetime              <dttm> 2016-08-06, 2016-08-17, 2016-08-17, 2016-08-17,~
    ## $ crew                  <chr> "sr,mi,tk", "tk,mh", "tk,mh", "tk,mh", "tk,mh", ~
    ## $ week_number           <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
    ## $ tag_color             <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ cwt_id                <dbl> 34342, 34354, 34353, 34352, 34351, 34350, 34349,~
    ## $ river_section         <dbl> 14, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, ~
    ## $ tag_id_number         <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ tag_recapture_or_chop <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ sex                   <chr> "unknown", "unknown", "unknown", "unknown", "unk~
    ## $ spawning_condition    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ adipose_fin_clipped   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ samples_collected     <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ fl                    <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ head_tag_number       <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ scales                <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ otoliths              <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ hallprint_color       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ hallprint             <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ comments              <chr> "no fish", "no fish", "no fish", "no fish", "no ~

## Data Dictionaries

### Chop Count

``` r
percent_na <- chop_cleaner %>%
  summarise_all(list(name = ~sum(is.na(.))/length(.))) %>%
  pivot_longer(cols = everything())


counts_data_dictionary <- tibble(variables = colnames(chop_cleaner),
                          description = c("ID",
                                          'Date',
                                          "Sect",
                                          "Min", 
                                          "Carcass chopped count"),
                          percent_na = round(percent_na$value*100,
                                             digits = 1))

kable(counts_data_dictionary)
```

| variables | description           | percent_na |
|:----------|:----------------------|-----------:|
| id        | ID                    |        0.0 |
| date      | Date                  |        0.0 |
| sec       | Sect                  |        0.1 |
| min       | Min                   |        0.4 |
| count     | Carcass chopped count |        0.1 |

### Survey

``` r
percent_na <- chop_header_cleaner %>%
  summarise_all(list(name = ~sum(is.na(.))/length(.))) %>%
  pivot_longer(cols = everything())

chop_header_data_dictionary <- tibble(variables = colnames(chop_header_cleaner),
                          description = c("Date of survey",
                                          "Week number",
                                          "Weather",
                                          "Crew memeber initials that collected",
                                          "Comments",
                                          "ID"),
                          percent_na = round(percent_na$value*100,
                                             digits = 1))

kable(chop_header_data_dictionary)
```

| variables   | description                          | percent_na |
|:------------|:-------------------------------------|-----------:|
| date        | Date of survey                       |        0.0 |
| week_number | Week number                          |        0.9 |
| weather     | Weather                              |        1.7 |
| crew        | Crew memeber initials that collected |        3.5 |
| comments    | Comments                             |       97.4 |
| id          | ID                                   |        0.0 |

### CWT

``` r
percent_na <- cwt_cleaner %>%
  summarise_all(list(name = ~sum(is.na(.))/length(.))) %>%
  pivot_longer(cols = everything())

cwt_data_dictionary <- tibble(variables = colnames(cwt_cleaner),
                          description = c("ID",
                                          "Date",
                                          "Crew",
                                          "Week number",
                                          "Tag colour",
                                          "CWT ID",
                                          "River section",
                                          "Tag ID number",
                                          "Tag recapture or chop",
                                          "Sex",
                                          "Spawning condition",
                                          "Adipose fin clipped",
                                          "Samples collected",
                                          "Fork length",
                                          "Head tag number",
                                          "Scales",
                                          "Otoliths",
                                          "Hallprint color",
                                          "Hallprint",
                                          "Comments"),
                          percent_na = round(percent_na$value*100))

kable(cwt_data_dictionary)
```

| variables             | description           | percent_na |
|:----------------------|:----------------------|-----------:|
| id                    | ID                    |          0 |
| datetime              | Date                  |          0 |
| crew                  | Crew                  |          2 |
| week_number           | Week number           |          0 |
| tag_color             | Tag colour            |         97 |
| cwt_id                | CWT ID                |          0 |
| river_section         | River section         |          0 |
| tag_id_number         | Tag ID number         |          6 |
| tag_recapture_or_chop | Tag recapture or chop |          1 |
| sex                   | Sex                   |          0 |
| spawning_condition    | Spawning condition    |         44 |
| adipose_fin_clipped   | Adipose fin clipped   |         44 |
| samples_collected     | Samples collected     |         77 |
| fl                    | Fork length           |         44 |
| head_tag_number       | Head tag number       |         80 |
| scales                | Scales                |         94 |
| otoliths              | Otoliths              |         94 |
| hallprint_color       | Hallprint color       |         94 |
| hallprint             | Hallprint             |        100 |
| comments              | Comments              |         98 |

## Saved cleaned data back to google cloud

``` r
#Ignore chop recovery as its 100% NA
feather_carcass_chops_2016 <- chop_cleaner %>% glimpse()
```

    ## Rows: 976
    ## Columns: 5
    ## $ id    <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 4~
    ## $ date  <date> 2016-08-17, 2016-08-17, 2016-08-17, 2016-08-17, 2016-08-17, 201~
    ## $ sec   <dbl> 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4~
    ## $ min   <dbl> 28, 10, 17, 8, 14, 27, 28, 28, 20, 12, 14, 25, 16, 10, 9, 6, 8, ~
    ## $ count <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0~

``` r
feather_carcass_cwt_2016 <- cwt_cleaner %>% glimpse()
```

    ## Rows: 6,893
    ## Columns: 20
    ## $ id                    <dbl> 1353, 1354, 1354, 1354, 1354, 1354, 1354, 1354, ~
    ## $ datetime              <dttm> 2016-08-06, 2016-08-17, 2016-08-17, 2016-08-17,~
    ## $ crew                  <chr> "sr,mi,tk", "tk,mh", "tk,mh", "tk,mh", "tk,mh", ~
    ## $ week_number           <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
    ## $ tag_color             <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ cwt_id                <dbl> 34342, 34354, 34353, 34352, 34351, 34350, 34349,~
    ## $ river_section         <dbl> 14, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, ~
    ## $ tag_id_number         <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ tag_recapture_or_chop <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ sex                   <chr> "unknown", "unknown", "unknown", "unknown", "unk~
    ## $ spawning_condition    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ adipose_fin_clipped   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ samples_collected     <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ fl                    <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ head_tag_number       <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ scales                <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ otoliths              <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ hallprint_color       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ hallprint             <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ comments              <chr> "no fish", "no fish", "no fish", "no fish", "no ~

``` r
feather_carcass_chop_header_2016 <- chop_header_cleaner %>% glimpse()
```

    ## Rows: 115
    ## Columns: 6
    ## $ date        <dttm> 2016-08-17, 2016-08-18, 2016-08-22, 2016-08-23, 2016-08-2~
    ## $ week_number <chr> NA, "pre carcass", "pre carcass", "pre carcass", "pre-carc~
    ## $ weather     <chr> "sun", "sun", "sun", "sun", "sun", "sun", "sun", "sun", "s~
    ## $ crew        <chr> "tk,mh", "jcall,tv", "mh,tk", "mh,tk", "mh,tk", NA, "mh,tk~
    ## $ comments    <chr> "pre carcass", NA, NA, NA, NA, NA, NA, NA, "the two chops ~
    ## $ id          <dbl> 1, 2, 4, 3, 5, 6, 10, 11, 12, 13, 14, 15, 16, 17, 19, 18, ~

``` r
f <- function(input, output) write_csv(input, file = output)

gcs_upload(feather_carcass_chops_2016,
           object_function = f,
           type = "csv",
           name = "adult-holding-redd-and-carcass-surveys/feather-river/data/feather_carcass_chops_and_tags_2016.csv")
gcs_upload(feather_carcass_cwt_2016,
           object_function = f,
           type = "csv",
           name = "adult-holding-redd-and-carcass-surveys/feather-river/data/feather_carcass_cwt_2016.csv")
gcs_upload(feather_carcass_chop_header_2016,
           object_function = f,
           type = "csv",
           name = "adult-holding-redd-and-carcass-surveys/feather-river/data/feather_carcass_chop_header_2016.csv")
```
