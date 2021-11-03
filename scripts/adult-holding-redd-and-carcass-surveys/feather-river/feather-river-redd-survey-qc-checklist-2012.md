feather-river-redd-survey-qc-checklist-2012
================
Inigo Peng
10/6/2021

# Feather River Redd Survey Data

## Description of Monitoring Data

**Timeframe:** 2012

**Completeness of Record throughout timeframe:**

-   Longitude and latitude data are not available for 2009, 2010, 2011,
    2012, 2019, 2020. NA values will be filled in for these data sets in
    final cleaned data set.

**Sampling Location:** Various sampling locations on Feather River.

**Data Contact:** [Chris Cook](mailto::Chris.Cook@water.ca.gov)

Additional Info:  
1. Latitude and longitude are in NAD 1983 UTM Zone 10N  
2. The substrate is observed visually and an estimate of the percentage
of 5 size classes:

-   fines &lt;1cm  
-   small 1-5cm  
-   medium 6-15cm  
-   large 16-30cm  
-   boulder &gt;30cm

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
gcs_get_object(object_name = "adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2012_Chinook_Redd_Survey_Data_raw.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "2012_Chinook_Redd_Survey_Data_raw.xlsx",
               overwrite = TRUE)
```

Read in data from google cloud, glimpse raw data:

``` r
raw_data_2012 = readxl::read_excel("2012_Chinook_Redd_Survey_Data_raw.xlsx",
                                   col_types = c("date",
                                                 "text",
                                                 "text",
                                                 "numeric",
                                                 "text",
                                                 "numeric",
                                                 "numeric",
                                                 "numeric",
                                                 "numeric",
                                                 "numeric",
                                                 "numeric",
                                                 "numeric",
                                                 "numeric",
                                                 "numeric",
                                                 "numeric",
                                                 "numeric",
                                                 "numeric",
                                                 "numeric",
                                                 "numeric"))
glimpse(raw_data_2012)
```

    ## Rows: 1,774
    ## Columns: 19
    ## $ Date              <dttm> 2012-08-08, 2012-08-08, 2012-08-08, 2012-09-12, 201~
    ## $ `Survey Wk`       <chr> "0", "0", "0", "1", "1", "1", "1", "1", "1", "1", "1~
    ## $ Location          <chr> "Moes", "Moes", "Moes", "Table Mtn", "Table Mtn", "T~
    ## $ `File #`          <dbl> 1, 2, 3, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, ~
    ## $ type              <chr> "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p~
    ## $ `# of redds`      <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1~
    ## $ `# salmon`        <dbl> 0, 0, 1, 0, 2, 0, 0, 2, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0~
    ## $ Latitude          <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ Longitude         <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ `Depth (m)`       <dbl> 0.38, 0.32, 0.22, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ `Pot Depth (m)`   <dbl> 0.40, 0.45, 0.28, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ `Velocity (m/s)`  <dbl> 0.55, 0.64, 0.42, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ `% fines`         <dbl> 0, 10, 10, NA, NA, NA, NA, NA, NA, NA, NA, NA, 0, NA~
    ## $ `% small`         <dbl> 40, 40, 25, NA, NA, NA, NA, NA, NA, NA, NA, NA, 20, ~
    ## $ `% med`           <dbl> 50, 50, 65, NA, NA, NA, NA, NA, NA, NA, NA, NA, 50, ~
    ## $ `% large`         <dbl> 10, 0, 0, NA, NA, NA, NA, NA, NA, NA, NA, NA, 30, NA~
    ## $ `% boulder`       <dbl> 0, 0, 0, NA, NA, NA, NA, NA, NA, NA, NA, NA, 0, NA, ~
    ## $ `redd width (m)`  <dbl> 1.00, 1.00, 0.75, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ `redd length (m)` <dbl> 1.5, 1.5, 1.5, NA, NA, NA, NA, NA, NA, NA, NA, NA, 2~

## Data Transformation

``` r
cleaner_data_2012 <- raw_data_2012 %>% 
 select(-c('Survey Wk', 'File #')) %>% 
  rename('redd_count' = '# of redds',
         'salmon_count'= '# salmon',
         'latitude' = 'Latitude',
         'longitude' = 'Longitude',
         'depth_m' = 'Depth (m)',
         'pot_depth_m' = 'Pot Depth (m)',
         'velocity_m_per_s' = 'Velocity (m/s)',
         'percent_fine_substrate' = '% fines',
         'percent_small_substrate' = '% small',
         'percent_medium_substrate'= '% med',
         'percent_large_substrate' = '% large',
         'percent_boulder' = '% boulder',
         'redd_width_m' = 'redd width (m)',
         'redd_length_m' = 'redd length (m)',
         ) %>%
    mutate(Date = as.Date(Date))
cleaner_data_2012 <- cleaner_data_2012 %>% 
  set_names(tolower(colnames(cleaner_data_2012))) %>% 
  glimpse()  
```

    ## Rows: 1,774
    ## Columns: 17
    ## $ date                     <date> 2012-08-08, 2012-08-08, 2012-08-08, 2012-09-~
    ## $ location                 <chr> "Moes", "Moes", "Moes", "Table Mtn", "Table M~
    ## $ type                     <chr> "p", "p", "p", "p", "p", "p", "p", "p", "p", ~
    ## $ redd_count               <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, ~
    ## $ salmon_count             <dbl> 0, 0, 1, 0, 2, 0, 0, 2, 0, 0, 0, 1, 1, 1, 0, ~
    ## $ latitude                 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ longitude                <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ depth_m                  <dbl> 0.38, 0.32, 0.22, NA, NA, NA, NA, NA, NA, NA,~
    ## $ pot_depth_m              <dbl> 0.40, 0.45, 0.28, NA, NA, NA, NA, NA, NA, NA,~
    ## $ velocity_m_per_s         <dbl> 0.55, 0.64, 0.42, NA, NA, NA, NA, NA, NA, NA,~
    ## $ percent_fine_substrate   <dbl> 0, 10, 10, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ percent_small_substrate  <dbl> 40, 40, 25, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ percent_medium_substrate <dbl> 50, 50, 65, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ percent_large_substrate  <dbl> 10, 0, 0, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ percent_boulder          <dbl> 0, 0, 0, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ redd_width_m             <dbl> 1.00, 1.00, 0.75, NA, NA, NA, NA, NA, NA, NA,~
    ## $ redd_length_m            <dbl> 1.5, 1.5, 1.5, NA, NA, NA, NA, NA, NA, NA, NA~

## Explore `date`

``` r
cleaner_data_2012 %>%
  ggplot(aes(x = date)) +
  geom_histogram(binwidth = 7, position = 'stack', color = "black") +
  labs(title = "Value Counts For Survey Season Dates")+
  theme(legend.text = element_text(size = 8))
```

![](feather-river-redd-survey-qc-checklist-2012_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

**Numeric summary of date in 2012**

``` r
summary(cleaner_data_2012$date)
```

    ##         Min.      1st Qu.       Median         Mean      3rd Qu.         Max. 
    ## "2012-08-08" "2012-09-28" "2012-10-05" "2012-10-09" "2012-10-17" "2012-11-07"

**NA and Unknown Values**

-   0 % of values in the `date` column are NA.

## Explore Categorical Variables

``` r
cleaner_data_2012 %>% 
  select_if(is.character) %>% colnames()
```

    ## [1] "location" "type"

### Variable:`location`

``` r
table(cleaner_data_2012$location)
```

    ## 
    ##                     Aleck                   Bedrock            Below Big Hole 
    ##                        46                        13                         1 
    ##    Below Lower Auditorium                   Big Bar             Big Hole East 
    ##                         4                         3                         3 
    ##            Big River Left Bottom G95 East Side Chnl                Cottonwood 
    ##                         6                        14                        33 
    ##                Developing                       Eye          Eye Side Channel 
    ##                         2                         8                         5 
    ##        G95 West Side Chnl                   Gateway                     Goose 
    ##                         2                         3                         1 
    ##            Hatchery Ditch             Hatchery Pipe           Hatchery Riffle 
    ##                        88                         2                        28 
    ##          Lower Auditorium             Lower Big Bar      Lower Hatchery Ditch 
    ##                       338                         6                        56 
    ##     Lower Hatchery Riffle           Lower McFarland          Lower Moes Ditch 
    ##                        55                         2                        54 
    ##            Lower Robinson     Lower Steep Side Chnl           Lower Table Mtn 
    ##                        98                         3                        49 
    ##        Lower Trailer Park          Lower Vance East                   Mathews 
    ##                        44                         2                         2 
    ##            Mid Auditorium    Mid G95 East Side Chnl                  Mid Hour 
    ##                         8                         9                         1 
    ##             Mid McFarland         Middle Auditorium                      Moes 
    ##                         1                         5                         3 
    ##                Moes Ditch                     Steep        Steep Side Channel 
    ##                        14                        15                        22 
    ##                 Table Mtn                Thermalito         Top Big Hole East 
    ##                        94                         2                        21 
    ##       Top Big River Right    Top G95 East Side Chnl              Top G95 Main 
    ##                         1                         8                        10 
    ##    Top G95 West Side Chnl                  Top Hour               Top Keister 
    ##                         4                        19                         3 
    ##         Top of Auditorium         Top of Moes Ditch            Top Vance East 
    ##                        39                         2                        18 
    ##            Top Vance West              Trailer Park          Upper Auditorium 
    ##                         9                         6                        72 
    ##             Upper Bedrock      Upper Hatchery Ditch     Upper Hatchery Riffle 
    ##                        40                        12                       100 
    ##             Upper Mathews           Upper McFarland                Upper Moes 
    ##                        59                         1                        30 
    ##          Upper Moes Ditch            Upper Robinson               Upper Steep 
    ##                         4                       114                         8 
    ##        Upper Trailer Park                      Weir 
    ##                        17                        32

Locations names are changed to be consistent with the rest of the
Feather River redd survey files:

``` r
cleaner_data_2012 <- cleaner_data_2012 %>% 
  mutate(location = str_to_title(location),
         location = if_else(location == "G95 West Side Chnl", "G95 West Side Channel", location),
         location = if_else(location == "Bottom G95 East Side Chnl", "G95 East Side Channel Bottom", location),
         location = if_else(location == "Lower Steep Side Chnl", "Lower Steep Side Channel", location),
         location = if_else(location == "Lower Table Mtn", "Lower Table Mountain", location),
         location = if_else(location == "Mid G95 East Side Chnl", "G95 East Side Channel Mid", location),
         location = if_else(location == "Moes", "Moes Ditch", location),
         location = if_else(location == "Middle Auditorium", "Mid Auditorium", location),
         location = if_else(location == "Table Mtn", "Table Mountain", location),
         location = if_else(location == "Top G95 East Side Chnl", "G95 East Side Channel Top", location),
         location = if_else(location == "Top G95 West Side Chnl", "G95 West Side Channel Top", location),
         location = if_else(location == "Top G95 Main", "G95 Main Top", location),
         location = if_else(location == "Top Hour", "Top Of Hour", location),
         location = if_else(location == "Upper Moes", "Upper Moes Ditch", location),
         location = if_else(location == "Mid Mcfarland", "Mid McFarland", location),
         location = if_else(location == "Upper Mcfarland", "Upper McFarland", location),
         location = if_else(location == "Lower Mcfarland", "Lower McFarland", location)
         )
table(cleaner_data_2012$location)
```

    ## 
    ##                        Aleck                      Bedrock 
    ##                           46                           13 
    ##               Below Big Hole       Below Lower Auditorium 
    ##                            1                            4 
    ##                      Big Bar                Big Hole East 
    ##                            3                            3 
    ##               Big River Left                   Cottonwood 
    ##                            6                           33 
    ##                   Developing                          Eye 
    ##                            2                            8 
    ##             Eye Side Channel G95 East Side Channel Bottom 
    ##                            5                           14 
    ##    G95 East Side Channel Mid    G95 East Side Channel Top 
    ##                            9                            8 
    ##                 G95 Main Top        G95 West Side Channel 
    ##                           10                            2 
    ##    G95 West Side Channel Top                      Gateway 
    ##                            4                            3 
    ##                        Goose               Hatchery Ditch 
    ##                            1                           88 
    ##                Hatchery Pipe              Hatchery Riffle 
    ##                            2                           28 
    ##             Lower Auditorium                Lower Big Bar 
    ##                          338                            6 
    ##         Lower Hatchery Ditch        Lower Hatchery Riffle 
    ##                           56                           55 
    ##              Lower McFarland             Lower Moes Ditch 
    ##                            2                           54 
    ##               Lower Robinson     Lower Steep Side Channel 
    ##                           98                            3 
    ##         Lower Table Mountain           Lower Trailer Park 
    ##                           49                           44 
    ##             Lower Vance East                      Mathews 
    ##                            2                            2 
    ##               Mid Auditorium                     Mid Hour 
    ##                           13                            1 
    ##                Mid McFarland                   Moes Ditch 
    ##                            1                           17 
    ##                        Steep           Steep Side Channel 
    ##                           15                           22 
    ##               Table Mountain                   Thermalito 
    ##                           94                            2 
    ##            Top Big Hole East          Top Big River Right 
    ##                           21                            1 
    ##                  Top Keister            Top Of Auditorium 
    ##                            3                           39 
    ##                  Top Of Hour            Top Of Moes Ditch 
    ##                           19                            2 
    ##               Top Vance East               Top Vance West 
    ##                           18                            9 
    ##                 Trailer Park             Upper Auditorium 
    ##                            6                           72 
    ##                Upper Bedrock         Upper Hatchery Ditch 
    ##                           40                           12 
    ##        Upper Hatchery Riffle                Upper Mathews 
    ##                          100                           59 
    ##              Upper McFarland             Upper Moes Ditch 
    ##                            1                           34 
    ##               Upper Robinson                  Upper Steep 
    ##                          114                            8 
    ##           Upper Trailer Park                         Weir 
    ##                           17                           32

**NA and Unknown Values**

-   0 % of values in the `location` column are NA.

## Variable:`type`

# Description:

-   Area - polygon mapped with Trimble GPS unit

-   Point - points mapped with Trimble GPS unit

-   Questionable redds - polygon mapped with Trimble GPS unit where the
    substrate was disturbed but did not have the proper characteristics
    to be called a redd - it was no longer recorded after 2011

``` r
table(cleaner_data_2012$type)
```

    ## 
    ##    a    p 
    ##   75 1699

``` r
cleaner_data_2012 <- cleaner_data_2012 %>% 
  mutate(type = tolower(type),
         type = if_else(type == 'a', 'Area', type),
         type = if_else(type == 'p', 'Point', type))
table(cleaner_data_2012$type)
```

    ## 
    ##  Area Point 
    ##    75  1699

## Expore Numeric Variables

``` r
cleaner_data_2012 %>% 
  select_if(is.numeric) %>% colnames()
```

    ##  [1] "redd_count"               "salmon_count"            
    ##  [3] "latitude"                 "longitude"               
    ##  [5] "depth_m"                  "pot_depth_m"             
    ##  [7] "velocity_m_per_s"         "percent_fine_substrate"  
    ##  [9] "percent_small_substrate"  "percent_medium_substrate"
    ## [11] "percent_large_substrate"  "percent_boulder"         
    ## [13] "redd_width_m"             "redd_length_m"

### Variable:`salmon_count`

``` r
cleaner_data_2012 %>% 
  ggplot(aes(x = date, y = salmon_count)) + 
  geom_col() +
  facet_wrap(~year(date), scales = "free") +
  scale_x_date(labels = date_format("%b"), date_breaks = "1 month")+
  theme_minimal() +
  theme(axis.text.x = element_text(size = 10,angle = 90, vjust = 0.5, hjust=0.1)) +
  theme(axis.text.y = element_text(size = 8))+
  labs(title = "Daily Count of Salmon in 2012")
```

![](feather-river-redd-survey-qc-checklist-2012_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->

**Numeric Daily Summary of salmon\_count Over 2012**

``` r
cleaner_data_2012 %>%
  group_by(date) %>%
  summarise(count = sum(salmon_count, na.rm = T)) %>%
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    0.00   42.00   75.00   79.19  121.00  168.00

``` r
#Find the most distinctive colours for visual
colourCount = length(unique(cleaner_data_2012$location))
getPalette = colorRampPalette(brewer.pal(12, "Paired"))

cleaner_data_2012  %>%
  ggplot(aes(x = salmon_count, fill = location))+
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram() +
  theme_minimal() +
  theme(text = element_text(size = 7))+
  theme(axis.text.x = element_text(size = 10,vjust = 0.5, hjust=0.1))+
  labs(title = "Daily Salmon Count Distribution",
       x = 'Daily Salmon Count')+
  guides(fill = guide_legend(nrow = 21),
         shape = guide_legend(orride.aes = list(size =0.5)),
         color = guide_legend(orride.aes = list(size = 0.5)))
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](feather-river-redd-survey-qc-checklist-2012_files/figure-gfm/unnamed-chunk-14-1.png)<!-- -->

**Numeric summary of salmon\_count by location in 2012**

``` r
cleaner_data_2012 %>%
  group_by(location) %>% 
  summarise(count = sum(salmon_count, na.rm = T)) %>% 
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    0.00    1.00    5.00   20.44   20.50  181.00

**NA and Unknown Values**

-   0 % of values in the `salmon_count` column are NA.

### Variable:`redd_count`

``` r
cleaner_data_2012 %>% 
  ggplot(aes(x = date, y = redd_count)) + 
  geom_col() +
  facet_wrap(~year(date), scales = "free") +
  scale_x_date(labels = date_format("%b"), date_breaks = "1 month")+
  theme_minimal() +
  theme(axis.text.x = element_text(size = 10,angle = 90, vjust = 0.5, hjust=0.1)) +
  theme(axis.text.y = element_text(size = 8))+
  labs(title = "Daily Count of Redds in 2012")
```

![](feather-river-redd-survey-qc-checklist-2012_files/figure-gfm/unnamed-chunk-16-1.png)<!-- -->

``` r
cleaner_data_2012  %>%
  ggplot(aes(x = redd_count, fill = location))+
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram() +
  theme_minimal() +
  theme(text = element_text(size = 7))+
  theme(axis.text.x = element_text(size = 10,vjust = 0.5, hjust=0.1))+
  labs(title = "Daily Redd Count Distribution",
       x = 'Daily Redd Count')+
  guides(fill = guide_legend(nrow = 22),
         shape = guide_legend(orride.aes = list(size =0.5)),
         color = guide_legend(orride.aes = list(size = 0.5)))
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](feather-river-redd-survey-qc-checklist-2012_files/figure-gfm/unnamed-chunk-17-1.png)<!-- -->

**Numeric Daily Summary of redd\_count Over 2012**

``` r
cleaner_data_2012 %>%
  group_by(date) %>%
  summarise(count = sum(redd_count, na.rm = T)) %>%
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##     1.0    81.5   139.0   135.1   200.8   297.0

**NA and Unknown Values**

-   0 % of values in the `redd_count` column are NA.

### Variable:`redd_width_m`

``` r
cleaner_data_2012 %>%
  ggplot(aes(x = redd_width_m)) +
  geom_histogram(binwidth = 0.5, color = "black", fill = "white") +
  scale_x_continuous(breaks = round(seq(min(cleaner_data_2012$redd_width_m, na.rm = TRUE), max(cleaner_data_2012$redd_width_m, na.rm = TRUE), by = 1),1))+
  labs(title = "Redd Width Distribution")
```

![](feather-river-redd-survey-qc-checklist-2012_files/figure-gfm/unnamed-chunk-19-1.png)<!-- -->

**Numeric Summary of redd\_width\_m Over 2012**

``` r
summary(cleaner_data_2012$redd_width_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.500   1.000   1.000   1.213   1.075  10.000    1684

**NA and Unknown Values**

-   94.9 % of values in the `redd_width_m` column are NA.

### Variable: `redd_length_m`

``` r
cleaner_data_2012 %>%
  ggplot(aes(x = redd_length_m)) +
  geom_histogram(binwidth = 0.5, color = "black", fill = "white") +
  scale_x_continuous(breaks = round(seq(min(cleaner_data_2012$redd_length_m, na.rm = TRUE), max(cleaner_data_2012$redd_length_m, na.rm = TRUE), by = 1),0))+
  labs(title = "Redd Length Distribution")
```

![](feather-river-redd-survey-qc-checklist-2012_files/figure-gfm/unnamed-chunk-21-1.png)<!-- -->

**Numeric Summary of redd\_length\_m Over 2012**

``` r
summary(cleaner_data_2012$redd_length_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   1.000   1.500   2.000   2.079   2.000  20.000    1684

**NA and Unknown Values**

-   94.9 % of values in the `redd_length_m` column are NA.

### Physical Attributes

### Variable: `longitude and latitude`

``` r
utm_coords <- na.omit(subset(cleaner_data_2012, select = c("longitude", "latitude")))
utm_coords <- SpatialPoints(utm_coords,
                            proj4string=CRS("+proj=utm +zone=10 +datum=WGS84"))
long_lat_coords <- spTransform(utm_coords, CRS("+proj=longlat +datum=WGS84"))
summary(long_lat_coords)
```

    ## Object of class SpatialPoints
    ## Coordinates:
    ##                   min         max
    ## longitude -116.587428 -116.568550
    ## latitude     3.526243    3.530557
    ## Is projected: FALSE 
    ## proj4string : [+proj=longlat +datum=WGS84 +no_defs]
    ## Number of points: 146

**NA and Unknown Values**

-   91.7 % of values in the `longitude` column are NA.

-   91.8 % of values in the `latitude` column are NA.

### Variable:`percent_fine_substrate`

``` r
cleaner_data_2012 %>%
  ggplot(aes(x = percent_fine_substrate, fill = location)) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 5, position = 'stack', color = "black") +
  labs(title = "Percent Fine Substrate Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 10))
```

![](feather-river-redd-survey-qc-checklist-2012_files/figure-gfm/unnamed-chunk-24-1.png)<!-- -->

**Numeric Summary of percent\_fine\_substrate Over 2012**

``` r
summary(cleaner_data_2012$percent_fine_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.000   0.000   5.000   6.319  10.000  40.000    1683

**NA and Unknown Values**

-   94.9 % of values in the `percent_fine_substrate` column are NA.

### Variable:`percent_small_substrate`

``` r
cleaner_data_2012 %>%
  ggplot(aes(x = percent_small_substrate, fill = location)) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 10, position = 'stack', color = "black") +
  labs(title = "Percent Small Substrate Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 10))
```

![](feather-river-redd-survey-qc-checklist-2012_files/figure-gfm/unnamed-chunk-26-1.png)<!-- -->

**Numeric Summary of percent\_small\_substrate Over 2012**

``` r
summary(cleaner_data_2012$percent_small_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00   15.00   20.00   26.59   30.00   70.00    1683

**NA and Unknown Values**

-   94.9 % of values in the `percent_small_substrate` column are NA.

### Variable:`percent_medium_substrate`

``` r
cleaner_data_2012 %>%
  ggplot(aes(x = percent_medium_substrate, fill = location)) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 10, position = 'stack', color = "black") +
  labs(title = "Percent Medium Substrate Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 10))
```

![](feather-river-redd-survey-qc-checklist-2012_files/figure-gfm/unnamed-chunk-28-1.png)<!-- -->

**Numeric Summary of percent\_medium\_substrate Over 2012**

``` r
summary(cleaner_data_2012$percent_medium_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00   40.00   50.00   48.85   60.00   85.00    1683

**NA and Unknown Values**

-   94.9 % of values in the `percent_medium_substrate` column are NA.

### Variable:`percent_large_substrate`

``` r
cleaner_data_2012 %>%
  ggplot(aes(x = percent_large_substrate, fill = location)) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 10, position = 'stack', color = "black") +
  labs(title = "Percent Large Substrate Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 10))
```

![](feather-river-redd-survey-qc-checklist-2012_files/figure-gfm/unnamed-chunk-30-1.png)<!-- -->

**Numeric Summary of percent\_large\_substrate Over 2012**

``` r
summary(cleaner_data_2012$percent_large_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00    5.00   10.00   16.76   20.00   70.00    1683

**NA and Unknown Values**

-   94.9 % of values in the `percent_large_substrate` column are NA.

### Variable:`percent_boulder`

``` r
cleaner_data_2012 %>%
  ggplot(aes(x = percent_boulder, fill = location)) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 3, position = 'stack', color = "black") +
  labs(title = "Percent Boulder Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 10))
```

![](feather-river-redd-survey-qc-checklist-2012_files/figure-gfm/unnamed-chunk-32-1.png)<!-- -->

**Numeric Summary of percent\_boulder Over 2012**

``` r
summary(cleaner_data_2012$percent_boulder)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.000   0.000   0.000   1.154   0.000  25.000    1683

**NA and Unknown Values**

-   94.9 % of values in the `percent_boulder` column are NA.

### Summary of Mean Percent Substrate In Each Location

``` r
cleaner_data_2012 %>% 
  group_by(location) %>% 
  summarise(mean_percent_fine_substrate = mean(percent_fine_substrate, na.rm = TRUE),
            mean_percent_small_substrate = mean(percent_small_substrate, na.rm = TRUE),
            mean_percent_medium_substrate = mean(percent_medium_substrate, na.rm = TRUE),
            mean_percent_large_substrate = mean(percent_large_substrate, na.rm = TRUE),
            mean_percent_boulder = mean(percent_boulder, na.rm = TRUE),
            ) %>% 
  pivot_longer(
    cols = starts_with("mean"),
    names_to = "substrate_type",
    values_to = "percent",
    values_drop_na = TRUE
  ) %>%
  ggplot(aes(fill = substrate_type,
             y = location,
             x = percent))+
  geom_bar(position = 'stack', stat = 'identity', color = 'black')+
  labs(title = "Mean Percent Substrate by Location")
```

![](feather-river-redd-survey-qc-checklist-2012_files/figure-gfm/unnamed-chunk-34-1.png)<!-- -->

### Variable: `depth_m`

``` r
cleaner_data_2012 %>%
  ggplot(aes(x = depth_m, fill = location, )) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 0.1, position = 'stack', color = "black") +
  labs(title = "Depth Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 10))
```

![](feather-river-redd-survey-qc-checklist-2012_files/figure-gfm/unnamed-chunk-35-1.png)<!-- -->

**Numeric Summary of depth\_m Over 2012**

``` r
summary(cleaner_data_2012$depth_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  0.1100  0.2400  0.3400  0.3695  0.5000  0.7700    1683

**NA and Unknown Values**

-   94.9 % of values in the `depth_m` column are NA.

### Variable: `pot_depth_m`

``` r
cleaner_data_2012 %>%
  ggplot(aes(x = pot_depth_m, fill = location, )) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 0.1, position = 'stack', color = "black") +
  labs(title = "Pot Depth Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 10))
```

![](feather-river-redd-survey-qc-checklist-2012_files/figure-gfm/unnamed-chunk-37-1.png)<!-- -->
**Numeric Summary of pot\_depth\_m Over 2012**

``` r
summary(cleaner_data_2012$pot_depth_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  0.1600  0.3200  0.4200  0.4303  0.5250  0.8000    1683

**NA and Unknown Values**

-   94.9 % of values in the `pot_depth_m` column are NA.

### Variable: `velocity_m_per_s`

``` r
cleaner_data_2012 %>%
  ggplot(aes(x = velocity_m_per_s, fill = location, )) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 0.1, position = 'stack', color = "black") +
  labs(title = "Velocity Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 10))
```

![](feather-river-redd-survey-qc-checklist-2012_files/figure-gfm/unnamed-chunk-39-1.png)<!-- -->

**Numeric Summary of velocity\_m\_per\_s Over 2012**

``` r
summary(cleaner_data_2012$`velocity_m_per_s`)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  0.1100  0.3200  0.5000  0.4911  0.6450  0.9800    1683

**NA and Unknown Values**

-   94.9 % of values in the `velocity_m_per_s` column are NA.

### Add cleaned data back onto google cloud

``` r
feather_redd_survey_2012 <- cleaner_data_2012 %>% glimpse()
```

    ## Rows: 1,774
    ## Columns: 17
    ## $ date                     <date> 2012-08-08, 2012-08-08, 2012-08-08, 2012-09-~
    ## $ location                 <chr> "Moes Ditch", "Moes Ditch", "Moes Ditch", "Ta~
    ## $ type                     <chr> "Point", "Point", "Point", "Point", "Point", ~
    ## $ redd_count               <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, ~
    ## $ salmon_count             <dbl> 0, 0, 1, 0, 2, 0, 0, 2, 0, 0, 0, 1, 1, 1, 0, ~
    ## $ latitude                 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ longitude                <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ depth_m                  <dbl> 0.38, 0.32, 0.22, NA, NA, NA, NA, NA, NA, NA,~
    ## $ pot_depth_m              <dbl> 0.40, 0.45, 0.28, NA, NA, NA, NA, NA, NA, NA,~
    ## $ velocity_m_per_s         <dbl> 0.55, 0.64, 0.42, NA, NA, NA, NA, NA, NA, NA,~
    ## $ percent_fine_substrate   <dbl> 0, 10, 10, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ percent_small_substrate  <dbl> 40, 40, 25, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ percent_medium_substrate <dbl> 50, 50, 65, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ percent_large_substrate  <dbl> 10, 0, 0, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ percent_boulder          <dbl> 0, 0, 0, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ redd_width_m             <dbl> 1.00, 1.00, 0.75, NA, NA, NA, NA, NA, NA, NA,~
    ## $ redd_length_m            <dbl> 1.5, 1.5, 1.5, NA, NA, NA, NA, NA, NA, NA, NA~

``` r
f <- function(input, output) write_csv(input, file = output)

gcs_upload(feather_redd_survey_2012,
           object_function = f,
           type = "csv",
           name = "adult-holding-redd-and-carcass-surveys/feather-river/data/feather_redd_2012.csv")
```

    ## i 2021-11-03 15:45:09 > File size detected as  129.8 Kb

    ## i 2021-11-03 15:45:10 > Request Status Code:  400

    ## ! API returned: Cannot insert legacy ACL for an object when uniform bucket-level access is enabled. Read more at https://cloud.google.com/storage/docs/uniform-bucket-level-access - Retrying with predefinedAcl='bucketLevel'

    ## i 2021-11-03 15:45:10 > File size detected as  129.8 Kb

    ## ==Google Cloud Storage Object==
    ## Name:                adult-holding-redd-and-carcass-surveys/feather-river/data/feather_redd_2012.csv 
    ## Type:                csv 
    ## Size:                129.8 Kb 
    ## Media URL:           https://www.googleapis.com/download/storage/v1/b/jpe-dev-bucket/o/adult-holding-redd-and-carcass-surveys%2Ffeather-river%2Fdata%2Ffeather_redd_2012.csv?generation=1635979509917736&alt=media 
    ## Download URL:        https://storage.cloud.google.com/jpe-dev-bucket/adult-holding-redd-and-carcass-surveys%2Ffeather-river%2Fdata%2Ffeather_redd_2012.csv 
    ## Public Download URL: https://storage.googleapis.com/jpe-dev-bucket/adult-holding-redd-and-carcass-surveys%2Ffeather-river%2Fdata%2Ffeather_redd_2012.csv 
    ## Bucket:              jpe-dev-bucket 
    ## ID:                  jpe-dev-bucket/adult-holding-redd-and-carcass-surveys/feather-river/data/feather_redd_2012.csv/1635979509917736 
    ## MD5 Hash:            XagjuGIC+u5P2YdRXjvrag== 
    ## Class:               STANDARD 
    ## Created:             2021-11-03 22:45:09 
    ## Updated:             2021-11-03 22:45:09 
    ## Generation:          1635979509917736 
    ## Meta Generation:     1 
    ## eTag:                CKjQscyi/fMCEAE= 
    ## crc32c:              ZvJG8Q==
