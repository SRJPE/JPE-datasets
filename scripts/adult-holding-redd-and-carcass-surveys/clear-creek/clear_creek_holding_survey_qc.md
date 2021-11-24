clear\_holding\_survey\_qc
================
Inigo Peng
11/4/2021

# Clear Creek Adult Holding Survey

## Description of Monitoring Data

These data were collected by the U.S. Fish and Wildlife Service’s, Red
Bluff Fish and Wildlife Office’s, Clear Creek Monitoring Program.These
data encompass spring-run Chinook Salmon redd index data from 2000 to
2019. Data were collected on lower Clear Creek from Whiskeytown Dam
located at river mile 18.1, (40.597786N latitude, -122.538791W longitude
\[decimal degrees\]) to the Clear Creek Video Station located at river
mile 0.0 (40.504836N latitude, -122.369693W longitude \[decimal
degrees\]) near the confluence with the Sacramento River.

**Timeframe:** 2008 - 2019

**Completeness of Record throughout timeframe:**

**Sampling Location:** Clear Creek

**Data Contact:** [Ryan Schaefer](mailto:ryan_a_schaefer@fws.gov)

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
gcs_get_object(object_name = "adult-holding-redd-and-carcass-surveys/clear-creek/data-raw/FlowWest SCS JPE Data Request_Clear Creek.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "raw_redd_holding_carcass_data.xlsx")
               # Overwrite = TRUE)
```

Read in data from google cloud, glimpse raw data sheet:

## Data Transformation

``` r
cleaner_data <- raw_holding_data %>% 
  janitor::clean_names() %>% 
  select(-c('survey','method','qc_type','qc_date','inspector','year')) %>% #all method is snorkel, year could be extracted from date, 
  rename('longitude' = 'point_x',
         'latitude' = 'point_y',
         'count' = 'total_fish',
         'jack_count' = 'num_of_jacks') %>% 
  mutate(date = as.Date(date)) %>% 
  glimpse()
```

    ## Rows: 1,435
    ## Columns: 12
    ## $ river_mile     <dbl> 17.641632, 16.697440, 15.571744, 15.473638, 14.886228, ~
    ## $ longitude      <dbl> -122.5459, -122.5452, -122.5336, -122.5327, -122.5300, ~
    ## $ latitude       <dbl> 40.59089, 40.58410, 40.57378, 40.57257, 40.56494, 40.56~
    ## $ date           <date> 2008-06-02, 2008-06-02, 2008-06-02, 2008-06-02, 2008-0~
    ## $ reach          <chr> "R1", "R1", "R2", "R2", "R2", "R2", "R2", "R3", "R3", "~
    ## $ count          <dbl> 1, 3, 1, 1, 1, 1, 2, 1, 1, 1, 1, 3, 1, 2, 1, 1, 1, 1, 4~
    ## $ jack_count     <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0~
    ## $ comments       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ species        <chr> "CHINOOK", "CHINOOK", "CHINOOK", "CHINOOK", "CHINOOK", ~
    ## $ survey_intent  <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ pw_location_rm <dbl> 7.4, 7.4, 7.4, 7.4, 7.4, 7.4, 7.4, 7.4, 7.4, 7.4, 7.4, ~
    ## $ pw_relate      <chr> "Above", "Above", "Above", "Above", "Above", "Above", "~

## Explore Date

``` r
summary(cleaner_data$date)
```

    ##         Min.      1st Qu.       Median         Mean      3rd Qu.         Max. 
    ## "2008-06-02" "2011-08-25" "2013-08-26" "2013-06-29" "2015-06-12" "2019-10-10"

**NA and Unknown Values**

-   0 % of values in the `date` column are NA.

## Explore Categorical Variables

``` r
cleaner_data %>% 
  select_if(is.character) %>% colnames()
```

    ## [1] "reach"         "comments"      "species"       "survey_intent"
    ## [5] "pw_relate"

### Variable: `reach`

**Description:** reach surveyed on each survey day

``` r
table(cleaner_data$reach)
```

    ## 
    ##  R1  R2  R3  R4  R5 R5A R5B R5C  R6 R6A  R7 
    ## 153 274 183 280   9  68  98  95 258   2  15

**NA and Unknown Values**

-   0 % of values in the `reach` column are NA.

### Variable: `comments`

``` r
unique(cleaner_data$comments)[1:5]
```

    ## [1] NA                             "taken with BC#2 wp 3 (+/-29)"
    ## [3] "Carcass Pool"                 "North State Pool"            
    ## [5] "Nude Beach Pool"

**NA and Unknown Values**

-   88.1 % of values in the `comments` column are NA.

### Variable: `species`

Change to lower-case capitalization; we are only interested in chinook
data.

``` r
cleaner_data <- cleaner_data %>% 
  mutate(species = tolower(species)) %>% 
  filter(species == 'chinook') 

table(cleaner_data$species)
```

    ## 
    ## chinook 
    ##    1430

**NA and Unknown Values**

-   0 % of values in the `species` column are NA.

### Variable: `survey_intent`

``` r
cleaner_data <- cleaner_data %>% 
  mutate(survey_intent = tolower(survey_intent))

table(cleaner_data$survey_intent)
```

    ## 
    ##          august index picket weir placement            pulse flow 
    ##                   233                     3                   442 
    ##       spawning survey         weir location            winter run 
    ##                   613                     2                     2

**NA and Unknown Values**

-   9.4 % of values in the `survey_intent` column are NA.

### Variable: `pw_relate`

**Description:** Fish above or below Picket Weir

``` r
cleaner_data <- cleaner_data %>% 
  mutate(pw_relate = tolower(pw_relate))
table(cleaner_data$pw_relate)
```

    ## 
    ## above below 
    ##   994   436

## Explore Numerical Variables

``` r
cleaner_data %>% 
  select_if(is.numeric) %>% colnames()
```

    ## [1] "river_mile"     "longitude"      "latitude"       "count"         
    ## [5] "jack_count"     "pw_location_rm"

### Variable: `river_mile`

Plotting river mile over Period of Record

``` r
cleaner_data %>% 
  mutate(year = as.factor(year(date))) %>% 
  ggplot(aes(x = river_mile, y = year)) +
  geom_point(alpha = .5, size = 1.5, color = "blue") +
  labs(x = "River Mile", y = "Year", title = "River Mile Over the Years")
```

![](clear_creek_holding_survey_qc_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->

``` r
cleaner_data %>% 
  mutate(year = as.factor(year(date))) %>% 
  ggplot(aes(x= river_mile, y = count, color = year))+
  geom_point()+
  theme_minimal()+
  labs(title = "Total Fish Count Per River Mile")
```

![](clear_creek_holding_survey_qc_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

**Numeric Summary of river\_mile Over the Years**

``` r
summary(cleaner_data$river_mile)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##  0.3019  7.1417 10.1530 10.4114 14.0534 18.2856

**NA and Unknown Values**

-   0 % of values in the `river_mile` column are NA.

## Variable: `longitude` and `latitude`

**Numeric Summary of longitude over Period of Record**

``` r
summary(cleaner_data$longitude)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  -122.6  -122.5  -122.5  -122.5  -122.5  -122.4       1

**Numeric Summary of latitude over Period of Record**

``` r
summary(cleaner_data$latitude)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   40.49   40.49   40.51   40.52   40.55   40.60       1

**NA and Unknown Values**

-   0.1 % of values in the `longitude` column are NA.

-   0.1 % of values in the `latitude` column are NA.

## Variable: `count`

**Description:** total number of Adult Chinook Salmon encountered
including the number of 2-year olds (Jacks/Jills)

``` r
cleaner_data %>% 
  mutate(year = as.factor(year(date)),
         fake_date = as.Date(paste0("1990", "-", month(date), "-", day(date)))) %>% 
  ggplot(aes(x = fake_date, y = count)) + 
  geom_col() + 
  facet_wrap(~year(date), scales = "free_y") + 
  scale_x_date(labels = date_format("%b"), date_breaks = "1 month") + 
  theme_minimal() + 
  theme(text = element_text(size = 13),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + 
  labs(title = "Daily Holding Count", 
       x = "Date")  
```

![](clear_creek_holding_survey_qc_files/figure-gfm/unnamed-chunk-17-1.png)<!-- -->

``` r
cleaner_data %>% 
  group_by(date) %>%
  summarise(daily_count = sum(count)) %>%
  mutate(year = as.factor(year(date))) %>% 
  ggplot(aes(x = year, y = daily_count)) + 
  geom_boxplot() + 
  theme_minimal() +
  labs(title = "Daily Count Summarized by Year") + 
  theme(text = element_text(size = 13),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))   + 
  scale_y_continuous(limits = c(0, 101))
```

    ## Warning: Removed 15 rows containing non-finite values (stat_boxplot).

![](clear_creek_holding_survey_qc_files/figure-gfm/unnamed-chunk-18-1.png)<!-- -->

``` r
cleaner_data  %>%
  mutate(year = as.factor(year(date))) %>%
  group_by(year(date)) %>%
  mutate(total_catch = sum(count)) %>%
  ungroup() %>%
  ggplot(aes(x = year, y = total_catch)) + 
  geom_col() + 
  theme_minimal() +
  labs(title = "Total Yearly Fish Count",
       y = "Total fish count") + 
  theme(text = element_text(size = 13),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) 
```

![](clear_creek_holding_survey_qc_files/figure-gfm/unnamed-chunk-19-1.png)<!-- -->

**Numeric Summary of count over Period of Record**

``` r
summary(cleaner_data$count)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   1.000   1.000   1.000   3.746   3.000  89.000

**NA and Unknown Values**

-   0 % of values in the `count` column are NA.

## Variable: `jack_count`

**Description:** total number of 2-year old Chinook Salmon (Jacks/Jills)
encountered

``` r
cleaner_data %>% 
  ggplot(aes(x = jack_count)) +
  geom_histogram(bins = 4) +
  theme_minimal() + 
  theme(text = element_text(size = 15)) 
```

![](clear_creek_holding_survey_qc_files/figure-gfm/unnamed-chunk-21-1.png)<!-- -->

**Numeric Summary of jack count over Period of Record**

``` r
summary(cleaner_data$jack_count)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##  0.0000  0.0000  0.0000  0.1112  0.0000  6.0000

**NA and Unknown Values**

-   0 % of values in the `jack_count` column are NA.

## Variable: `pw_location_rm`

**Description:** location of the Picket Weir

``` r
cleaner_data %>% 
  ggplot(aes(x = pw_location_rm)) +
  geom_histogram(bins = 4) +
  theme_minimal() + 
  theme(text = element_text(size = 15))+
  labs(title = "Distribution of pw_location_rm")
```

![](clear_creek_holding_survey_qc_files/figure-gfm/unnamed-chunk-23-1.png)<!-- -->

**Numeric Summary of pw\_location\_rm over Period of Record**

``` r
summary(cleaner_data$pw_location_rm)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   7.400   7.400   7.400   7.753   8.200   8.200

Seems like there are two locations

**NA and Unknown Values**

-   0 % of values in the `pw_location_rm` column are NA.

## Save cleaned data back to google cloud

``` r
clear_holding <- cleaner_data  
```

``` r
gcs_list_objects()
f <- function(input, output) write_csv(input, file = output)
gcs_upload(clear_holding,
           object_function = f,
           type = "csv",
           name = "adult-holding-redd-and-carcass-surveys/clear-creek/data/clear_holding.csv")
```
