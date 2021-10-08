feather-river-adult-holding-redd-survey-qc-checklist-2009
================
Inigo Peng
10/6/2021

# Feather River Redd Survey Data

## Description of Monitoring Data

**Timeframe:** 2009

**Completeness of Record throughout timeframe: ** \*Longitude and
latitude data are not available for 2009,2010, 2011,2012,2019, 2020. NA
values will be filled in for these data sets in final cleaned data set.

\*No data was recroded for “depth\_m”, “pot\_depth\_m”, and
“velocity\_m/s” in 2009 data. NA values only.

**Sampling Location:** Feather River

**Data Contact:** [Chris Cook](Chris.Cook@water.ca.gov)

Additional Info: *1. *Latitude and longitude are in NAD 1983 UTM Zone
10N *2. *The substrate is observed visually and an estimate of the
percentage of 5 size classes. Fines &lt;1cm, small 1-5cm, medium 6-15cm,
large 16-30cm, boulder &gt;30cm

## Access Cloud Data

``` r
# Run Sys.setenv() to specify GCS_AUTH_FILE and GCS_DEFAULT_BUCKET before running
# Open object from google cloud storage
# Set your authentication using gcs_auth
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
# Set global bucket 
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))
gcs_list_objects()
# git data and save as xlsx
gcs_get_object(object_name = "adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2009_Chinook_Redd_Survey_Data_raw.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "2009_Chinook_Redd_Survey_Data_raw.xlsx",
               overwrite = TRUE)
```

Read in data from google cloud, glimpse raw data:

``` r
raw_data_2009 = readxl::read_excel("2009_Chinook_Redd_Survey_Data_raw.xlsx",
                                   sheet="2009 All Data")
glimpse(raw_data_2009)
```

    ## Rows: 301
    ## Columns: 17
    ## $ Location             <chr> "Table Mountain", "Table Mountain", "Table Mounta~
    ## $ File                 <chr> "4", "1", "3", "5", "7", "8", "9", "6", "11", "12~
    ## $ `Type (D, A, P)`     <chr> "Area", "Point", "Area", "Area", "Area", "Area", ~
    ## $ Remeasured           <chr> "No", "No", "No", "No", "No", "No", "No", "No", "~
    ## $ `#  Redds`           <dbl> 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 2, 1~
    ## $ `# Salmon`           <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0~
    ## $ `Depth (m)`          <chr> "0.78", "0.56000000000000005", "0.64", "0.5", "0.~
    ## $ `Pot depth (m)`      <chr> "0", "0", "0", "0", "0", "0", "0", "0", NA, NA, N~
    ## $ `Velocity (m/s)`     <chr> "0", "0", "0", "0", "0", "0", "0", "0", NA, NA, N~
    ## $ `% Fines (<1 cm)`    <dbl> 10, 5, 15, 30, 25, 5, 5, 20, NA, NA, NA, NA, NA, ~
    ## $ `% Small (1-5 cm)`   <dbl> 20, 20, 30, 50, 15, 15, 20, 20, NA, NA, NA, NA, N~
    ## $ `% Medium (5-15 cm)` <dbl> 40, 30, 20, 20, 60, 30, 20, 60, NA, NA, NA, NA, N~
    ## $ `% Large (15-30 cm)` <dbl> 30, 40, 30, 0, 0, 50, 45, 0, NA, NA, NA, NA, NA, ~
    ## $ `% Boulder (>30 cm)` <dbl> 0, 5, 5, 0, 0, 0, 0, 0, NA, NA, NA, NA, NA, NA, 0~
    ## $ `Redd Width (ft)`    <dbl> NA, 3, 3, 3, 4, 3, 3, 12, NA, 4, 2, 2, 3, 4, 3, 4~
    ## $ `Redd Lenght (ft)`   <dbl> NA, 4, 5, 4, 6, 3, 3, 4, NA, 4, 3, 3, 4, 5, 3, 6,~
    ## $ `Survey Date`        <dttm> 2009-09-29, 2009-09-29, 2009-09-29, 2009-09-29, ~

\#\#Data Transformation \#TODO don’t add NA columns/remove na columns
\#TODO bind removed columns in final script

``` r
raw_data_2009$'Redd Width (ft)' = raw_data_2009$'Redd Width (ft)'/3.281
raw_data_2009$'Redd Lenght (ft)' = raw_data_2009$'Redd Lenght (ft)'/3.281
cleaner_data_2009 <- raw_data_2009 %>%
  select(-c(Remeasured, File, '#  Redds')) %>%
  # add_column(longitude = NA) %>% 
  # add_column(latitude = NA) %>% 
  relocate('Survey Date', .before = 'Location') %>% 
  # relocate('latitude', .after = '# Salmon') %>%
  # relocate('longitude', .before = 'Depth (m)') %>%  
  rename('Date' = 'Survey Date',
         'type' = 'Type (D, A, P)', 
         'salmon_counted' = '# Salmon', 
         'depth_m' = 'Depth (m)',
         'pot_depth_m' = 'Pot depth (m)',
         'velocity_m/s' = 'Velocity (m/s)',
         'percent_fine_substrate' = '% Fines (<1 cm)',
         'percent_small_substrate' = '% Small (1-5 cm)',
         'percent_medium_substrate'= '% Medium (5-15 cm)',
         'percent_large_substrate' =  '% Large (15-30 cm)',
         'percent_boulder' = '% Boulder (>30 cm)',
         'redd_width_m' = 'Redd Width (ft)',
         'redd_length_m' = 'Redd Lenght (ft)') %>%
  mutate('depth_m' = as.numeric('depth_m'),
         'pot_depth_m' = as.numeric('pot_depth_m'),
         'velocity_m/s'= as.numeric('velocity_m/s'))
         # 'latitude' = as.numeric(latitude),
         # 'longitude' = as.numeric(longitude)) 
```

``` r
cleaner_data_2009 <- cleaner_data_2009 %>% 
  set_names(tolower(colnames(cleaner_data_2009))) %>% 
  mutate(date = as.Date(date)) %>% 
  glimpse()
```

    ## Rows: 301
    ## Columns: 14
    ## $ date                     <date> 2009-09-29, 2009-09-29, 2009-09-29, 2009-09-~
    ## $ location                 <chr> "Table Mountain", "Table Mountain", "Table Mo~
    ## $ type                     <chr> "Area", "Point", "Area", "Area", "Area", "Are~
    ## $ salmon_counted           <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
    ## $ depth_m                  <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ pot_depth_m              <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ `velocity_m/s`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ percent_fine_substrate   <dbl> 10, 5, 15, 30, 25, 5, 5, 20, NA, NA, NA, NA, ~
    ## $ percent_small_substrate  <dbl> 20, 20, 30, 50, 15, 15, 20, 20, NA, NA, NA, N~
    ## $ percent_medium_substrate <dbl> 40, 30, 20, 20, 60, 30, 20, 60, NA, NA, NA, N~
    ## $ percent_large_substrate  <dbl> 30, 40, 30, 0, 0, 50, 45, 0, NA, NA, NA, NA, ~
    ## $ percent_boulder          <dbl> 0, 5, 5, 0, 0, 0, 0, 0, NA, NA, NA, NA, NA, N~
    ## $ redd_width_m             <dbl> NA, 0.9143554, 0.9143554, 0.9143554, 1.219140~
    ## $ redd_length_m            <dbl> NA, 1.2191405, 1.5239256, 1.2191405, 1.828710~

\#\#Explore Categorical Variables

``` r
cleaner_data_2009 %>% 
  select_if(is.character) %>% colnames()
```

    ## [1] "location" "type"

### Variable: `location`

``` r
table(cleaner_data_2009$location)
```

    ## 
    ##              Alec           Bedrock        Cottonwood               Eye 
    ##                 1                 7                15                 3 
    ##           Gateway    Hatchery Ditch     Hatchery Pipe   Hatchery Riffle 
    ##                 1                 6                11                24 
    ##  Lower Auditorium    Lower Robinson          Matthews Middle Auditorium 
    ##               123                14                14                 3 
    ##       Moe's Ditch             Steep    Table Mountain      Trailer Park 
    ##                13                 6                20                17 
    ##  Upper Auditorium    Upper Robinson              Wier 
    ##                14                 7                 2

Locations names are changed to be consistent with the rest of the
Feather River redd survey files:

``` r
cleaner_data_2009 <- cleaner_data_2009 %>% 
  mutate(location = tolower(location), 
         location = if_else(location == "alec", "aleck", location), 
         location = if_else(location == "matthews", "mathews", location), 
         location = if_else(location == "middle auditorium", "mid auditorium", location),
         )
table(cleaner_data_2009$location)
```

    ## 
    ##            aleck          bedrock       cottonwood              eye 
    ##                1                7               15                3 
    ##          gateway   hatchery ditch    hatchery pipe  hatchery riffle 
    ##                1                6               11               24 
    ## lower auditorium   lower robinson          mathews   mid auditorium 
    ##              123               14               14                3 
    ##      moe's ditch            steep   table mountain     trailer park 
    ##               13                6               20               17 
    ## upper auditorium   upper robinson             wier 
    ##               14                7                2

-   0 % of values in the `location` column are NA.

Variable: `Type` area - polygon mapped with Trimble GPS unit“,”point -
points mapped with Trimble GPS unit" “questionable redds - polygon
mapped with Trimble GPS unit where the substrate was disturbed but did
not have the proper characteristics to be called a redd - it was no
longer recorded after 2011”

``` r
table(cleaner_data_2009$type)
```

    ## 
    ##  Area Point 
    ##   290    11

``` r
# cleaner_data_2009 <- cleaner_data_2009 %>% 
#   mutate(type = tolower(type),
# table(cleaner_data_2009$type)
```

``` r
# types <- distinct(cleaner_data_2009, type) %>% 
#   drop_na() %>% 
#   unlist()
# 
# types_description <- c(
#   "area - polygon mapped with Trimble GPS unit",
#   "point - points mapped with Trimble GPS unit"
#   # "questionable redds - polygon mapped with Trimble GPS unit where the substrate was disturbed but did not have the proper characteristics to be called a redd - it was no longer recorded after 2011"
# )
# 
# write_rds(types_description, paste0(getwd(),"/adult-holding-redd-and-carcass-surveys/feather-river/data/types_description.rds"))
# 
# tibble(code = types,
#        definitions = types_description)
```

\#\#Expore Numeric Variables

``` r
cleaner_data_2009 %>% 
  select_if(is.numeric) %>% colnames()
```

    ##  [1] "salmon_counted"           "depth_m"                 
    ##  [3] "pot_depth_m"              "velocity_m/s"            
    ##  [5] "percent_fine_substrate"   "percent_small_substrate" 
    ##  [7] "percent_medium_substrate" "percent_large_substrate" 
    ##  [9] "percent_boulder"          "redd_width_m"            
    ## [11] "redd_length_m"

Numerical Data \#\#\# Variable: `salmon_counted` \#\#\#\#Plotting salmon
counted in 2009

``` r
cleaner_data_2009 %>% 
  ggplot(aes(x = date, y = salmon_counted)) + 
  geom_col() +
  facet_wrap(~year(date), scales = "free") +
  scale_x_date(labels = date_format("%b"), date_breaks = "1 month")+
  theme_minimal() +
  theme(axis.text.x = element_text(size = 10,angle = 90, vjust = 0.5, hjust=0.1)) +
  theme(axis.text.y = element_text(size = 8))+
  labs(title = "Daily Count of Salmon Counted in 2009")
```

![](feather-river-redd-survey-qc-checklist-2009_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->

``` r
cleaner_data_2009  %>%
  ggplot(aes(x = location, y = salmon_counted))+
  geom_boxplot() +
  theme_minimal() +
  theme(text = element_text(size = 12))+
  theme(axis.text.x = element_text(size = 10,angle = 90, vjust = 0.5, hjust=0.1))+
  labs(title = "Salmon Count By Locations")
```

![](feather-river-redd-survey-qc-checklist-2009_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->
**Numeric Daily Summary of Salmon Counted over 2009**

``` r
cleaner_data_2009 %>%
  group_by(date) %>%
  summarise(count = sum(salmon_counted, na.rm = T)) %>%
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    0.00    5.50   10.50   21.42   32.50   76.00

**NA and Unknown Values** \* 0 % of values in the `salmon_counted`
column are NA.

### Variable: `percent_fine_substrate`

``` r
cleaner_data_2009 %>%
  group_by(location) %>% 
  summarise(mean_fine_substrate = mean(percent_fine_substrate, na.rm = TRUE)) %>%
  ggplot(aes(x = location, y = mean_fine_substrate)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  theme(axis.text.x = element_text(angle = 90))+
  labs(title = "Average Fine Substrate By Location")
```

![](feather-river-redd-survey-qc-checklist-2009_files/figure-gfm/unnamed-chunk-15-1.png)<!-- -->
**Numeric Summary of percent\_fine\_substrate over 2009**

``` r
summary(cleaner_data_2009$percent_fine_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00    5.00   10.00   12.37   20.00   33.00     214

NA and Unknown Values\*\* \* 71.1 % of values in the
`percent_fine_substrate` column are NA.

### Variable: `percent_small_substrate`

``` r
cleaner_data_2009 %>%
  group_by(location) %>% 
  summarise(mean_small_substrate = mean(percent_small_substrate, na.rm = TRUE)) %>%
  ggplot(aes(x = location, y = mean_small_substrate)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  theme(axis.text.x = element_text(angle = 90))+
  labs(title = "Average Percent Small Substrate By Location")
```

![](feather-river-redd-survey-qc-checklist-2009_files/figure-gfm/unnamed-chunk-17-1.png)<!-- -->

**Numeric Summary of percent\_small\_substrate over 2009**

``` r
summary(cleaner_data_2009$percent_small_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    5.00   20.00   30.00   31.37   40.00   80.00     212

NA and Unknown Values\*\* \* 70.4 % of values in the
`percent_small_substrate` column are NA.

### Variable: `percent_medium_substrate`

``` r
cleaner_data_2009 %>%
  group_by(location) %>% 
  summarise(mean_medium_substrate = mean(percent_medium_substrate, na.rm = TRUE)) %>%
  ggplot(aes(x = location, y = mean_medium_substrate)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  theme(axis.text.x = element_text(angle = 90))+
  labs(title = "Average Percent Medium Substrate By Location")
```

![](feather-river-redd-survey-qc-checklist-2009_files/figure-gfm/unnamed-chunk-19-1.png)<!-- -->
**Numeric Summary of percent\_medium\_substrate over 2009**

``` r
summary(cleaner_data_2009$percent_medium_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   10.00   30.00   40.00   38.54   50.00   80.00     211

NA and Unknown Values\*\* \* 70.1 % of values in the
`percent_medium_substrate` column are NA.

### Variable: `percent_large_substrate`

``` r
cleaner_data_2009 %>%
  group_by(location) %>% 
  summarise(mean_large_substrate = mean(percent_large_substrate, na.rm = TRUE)) %>%
  ggplot(aes(x = location, y = mean_large_substrate)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  theme(axis.text.x = element_text(angle = 90))+
  labs(title = "Average Percent Large Substrate By Location")
```

![](feather-river-redd-survey-qc-checklist-2009_files/figure-gfm/unnamed-chunk-21-1.png)<!-- -->
**Numeric Summary of percent\_large\_substrate over 2009**

``` r
summary(cleaner_data_2009$percent_large_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00   10.00   20.00   21.96   30.00   60.00     232

NA and Unknown Values\*\* \* 77.1 % of values in the
`percent_large_substrate` column are NA.

### Variable: `percent_boulder`

``` r
cleaner_data_2009 %>%
  group_by(location) %>% 
  summarise(mean_boulder = mean(percent_boulder, na.rm = TRUE)) %>%
  ggplot(aes(x = location, y = mean_boulder)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  theme(axis.text.x = element_text(angle = 90))+
  labs(title = "Average Percent Boulder By Location")
```

![](feather-river-redd-survey-qc-checklist-2009_files/figure-gfm/unnamed-chunk-23-1.png)<!-- -->
**Numeric Summary of percent\_boulder over 2009**

``` r
summary(cleaner_data_2009$percent_large_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00   10.00   20.00   21.96   30.00   60.00     232

**NA and Unknown Values** NA and Unknown Values\*\* \* 88.4 % of values
in the `percent_large_substrate` column are NA.

### Variable: `redd_width_m`

``` r
cleaner_data_2009 %>%
  group_by(location) %>%
  summarise(mean_redd_width = mean(redd_width_m, na.rm = TRUE)) %>%
  ggplot(aes(x = location, y = mean_redd_width)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  theme(axis.text.x = element_text(angle = 90))+
  labs(title = "Mean Redd Width By Location")
```

![](feather-river-redd-survey-qc-checklist-2009_files/figure-gfm/unnamed-chunk-25-1.png)<!-- -->

``` r
cleaner_data_2009 %>%
  ggplot(aes(x = redd_width_m)) +
  geom_histogram(binwidth = 0.2, color = "black", fill = "white") +
  scale_x_continuous(breaks = round(seq(min(cleaner_data_2009$redd_width_m, na.rm = TRUE), max(cleaner_data_2009$redd_width_m, na.rm = TRUE), by = 0.2),1))+
  labs(title = "Count of Redd Width")
```

![](feather-river-redd-survey-qc-checklist-2009_files/figure-gfm/unnamed-chunk-26-1.png)<!-- -->

**Numeric Summary of redd\_width\_m over 2009**

``` r
summary(cleaner_data_2009$redd_width_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  0.6096  0.9144  0.9144  1.2395  1.2191  3.6574     286

**NA and Unknown Values** \* 95 % of values in the `redd_width_m` column
are NA.

### Variable: `redd_length_m`

``` r
cleaner_data_2009 %>%
  group_by(location) %>%
  summarise(mean_redd_length = mean(redd_length_m, na.rm = TRUE)) %>%
  ggplot(aes(x = location, y = mean_redd_length)) +
  geom_col() +
  theme_minimal() +
  theme(text = element_text(size = 8)) +
  theme(axis.text.x = element_text(angle = 90))+
  labs(title = "Mean Redd Length By Location")
```

![](feather-river-redd-survey-qc-checklist-2009_files/figure-gfm/unnamed-chunk-28-1.png)<!-- -->

``` r
cleaner_data_2009 %>%
  ggplot(aes(x = redd_length_m)) +
  geom_histogram(binwidth = 0.2, color = "black", fill = "white") +
  scale_x_continuous(breaks = round(seq(min(cleaner_data_2009$redd_length_m, na.rm = TRUE), max(cleaner_data_2009$redd_length_m, na.rm = TRUE), by = 0.2),1))+
  labs(title = "Count of Redd Length")
```

![](feather-river-redd-survey-qc-checklist-2009_files/figure-gfm/unnamed-chunk-29-1.png)<!-- -->
**Numeric Summary of redd\_length\_m over 2009**

``` r
summary(cleaner_data_2009$redd_length_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  0.9144  0.9144  1.2191  1.2191  1.3715  1.8287     286

**NA and Unknown Values** \* 95 % of values in the `redd_length_m`
column are NA.
