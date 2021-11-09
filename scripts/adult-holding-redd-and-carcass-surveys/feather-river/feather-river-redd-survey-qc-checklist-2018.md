feather-river-redd-survey-qc-checklist-2018
================
Inigo Peng
10/6/2021

# Feather River Redd Survey Data

## Description of Monitoring Data

**Timeframe:** 2018

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
gcs_get_object(object_name = "adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2018_Chinook_Redd_Survey_Data_raw.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "2018_Chinook_Redd_Survey_Data_raw.xlsx",
               overwrite = TRUE)
```

Read in data from google cloud, glimpse raw data:

``` r
raw_data_2018 = readxl::read_excel("2018_Chinook_Redd_Survey_Data_raw.xlsx")
glimpse(raw_data_2018)
```

    ## Rows: 4,156
    ## Columns: 19
    ## $ Date              <dttm> 2018-09-18, 2018-09-18, 2018-09-18, 2018-09-18, 201~
    ## $ `Survey Wk`       <chr> "1-1", "1-1", "1-1", "1-1", "1-1", "1-1", "1-1", "1-~
    ## $ Location          <chr> "Lower Auditorium", "Lower Auditorium", "Lower Audit~
    ## $ `File #`          <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 1~
    ## $ Type              <chr> "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p~
    ## $ `# redds`         <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1~
    ## $ `# salmon`        <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1~
    ## $ `Latitude mN`     <dbl> 4374970, NA, 4374978, 4374983, 4374987, 4374984, 437~
    ## $ `Longitude mE`    <dbl> 623743.6, NA, 623812.0, 623810.8, 623810.3, 623819.6~
    ## $ `Depth (m)`       <dbl> 0.58, 0.38, 0.46, 0.44, 0.32, 0.46, 0.52, 0.41, 0.75~
    ## $ `Pot Depth (m)`   <dbl> 0.58, 0.46, 0.48, 0.52, 0.34, 0.56, 0.58, 0.41, 0.68~
    ## $ `Velocity (m/s)`  <dbl> 0.36, 0.39, 0.27, 0.52, 0.66, 0.55, 0.75, 0.47, 0.66~
    ## $ `% fines`         <dbl> 25, 10, 10, 20, 20, 20, 10, 15, 5, 10, 5, 10, 5, 5, ~
    ## $ `% small`         <dbl> 20, 15, 10, 30, 50, 40, 20, 30, 25, 40, 50, 55, 55, ~
    ## $ `% med`           <dbl> 40, 50, 55, 25, 25, 25, 60, 50, 65, 40, 40, 35, 25, ~
    ## $ `% large`         <dbl> 15, 25, 25, 25, 5, 15, 10, 5, 5, 10, 5, 0, 15, 30, 1~
    ## $ `% boulder`       <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0~
    ## $ `redd width (m)`  <dbl> 3.00, 1.75, 1.50, 2.00, 1.50, 1.00, 2.50, 1.50, 1.75~
    ## $ `redd length (m)` <dbl> 1.75, 2.50, 2.50, 2.50, 2.50, 1.75, 2.50, 2.25, 2.25~

## Data Transformation

``` r
cleaner_data_2018 <- raw_data_2018 %>% 
  select(-c('Survey Wk', 'File #')) %>% 
  rename('redd_count' = '# redds',
         'salmon_count'= '# salmon',
         'latitude' = 'Latitude mN',
         'longitude' = 'Longitude mE',
         'depth_m' = 'Depth (m)',
         'pot_depth_m' = 'Pot Depth (m)',
         'velocity_m_per_s' = 'Velocity (m/s)',
         'percent_fine_substrate' = '% fines',
         'percent_small_substrate' = '% small',
         'percent_medium_substrate'= '% med',
         'percent_large_substrate' = '% large',
         'percent_boulder' = '% boulder',
         'redd_width_m' = 'redd width (m)',
         'redd_length_m' = 'redd length (m)',) %>%
    mutate(Date = as.Date(Date)) 
cleaner_data_2018 <- cleaner_data_2018 %>% 
  set_names(tolower(colnames(cleaner_data_2018))) %>% 
  glimpse()
```

    ## Rows: 4,156
    ## Columns: 17
    ## $ date                     <date> 2018-09-18, 2018-09-18, 2018-09-18, 2018-09-~
    ## $ location                 <chr> "Lower Auditorium", "Lower Auditorium", "Lowe~
    ## $ type                     <chr> "p", "p", "p", "p", "p", "p", "p", "p", "p", ~
    ## $ redd_count               <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ~
    ## $ salmon_count             <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, ~
    ## $ latitude                 <dbl> 4374970, NA, 4374978, 4374983, 4374987, 43749~
    ## $ longitude                <dbl> 623743.6, NA, 623812.0, 623810.8, 623810.3, 6~
    ## $ depth_m                  <dbl> 0.58, 0.38, 0.46, 0.44, 0.32, 0.46, 0.52, 0.4~
    ## $ pot_depth_m              <dbl> 0.58, 0.46, 0.48, 0.52, 0.34, 0.56, 0.58, 0.4~
    ## $ velocity_m_per_s         <dbl> 0.36, 0.39, 0.27, 0.52, 0.66, 0.55, 0.75, 0.4~
    ## $ percent_fine_substrate   <dbl> 25, 10, 10, 20, 20, 20, 10, 15, 5, 10, 5, 10,~
    ## $ percent_small_substrate  <dbl> 20, 15, 10, 30, 50, 40, 20, 30, 25, 40, 50, 5~
    ## $ percent_medium_substrate <dbl> 40, 50, 55, 25, 25, 25, 60, 50, 65, 40, 40, 3~
    ## $ percent_large_substrate  <dbl> 15, 25, 25, 25, 5, 15, 10, 5, 5, 10, 5, 0, 15~
    ## $ percent_boulder          <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
    ## $ redd_width_m             <dbl> 3.00, 1.75, 1.50, 2.00, 1.50, 1.00, 2.50, 1.5~
    ## $ redd_length_m            <dbl> 1.75, 2.50, 2.50, 2.50, 2.50, 1.75, 2.50, 2.2~

## Explore `date`

``` r
cleaner_data_2018 %>%
  ggplot(aes(x = date)) +
  geom_histogram(binwidth = 7, position = 'stack', color = "black") +
  labs(title = "Value Counts For Survey Season Dates")+
  theme(legend.text = element_text(size = 8))
```

![](feather-river-redd-survey-qc-checklist-2018_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

**Numeric summary of date in 2018**

``` r
summary(cleaner_data_2018$date)
```

    ##         Min.      1st Qu.       Median         Mean      3rd Qu.         Max. 
    ## "2018-09-18" "2018-10-17" "2018-10-24" "2018-10-23" "2018-11-01" "2018-11-28"

**NA and Unknown Values**

-   0 % of values in the `date` column are NA.

## Explore Categorical Variables

``` r
cleaner_data_2018 %>% 
  select_if(is.character) %>% colnames()
```

    ## [1] "location" "type"

### Variable:`location`

``` r
table(cleaner_data_2018$location)
```

    ## 
    ##                   Aleck                 Bedrock  Below Lower Auditorium 
    ##                      52                      62                      13 
    ##                 Big Bar           Big Hole East           Big Hole West 
    ##                       8                      20                       2 
    ##              Big Riffle              Cottonwood                     Eye 
    ##                       6                      57                       7 
    ##        Eye Side Channel                G95 East         G95 East Bottom 
    ##                      33                      15                       9 
    ##   G95 East Side Channel            G95 East Top                G95 Main 
    ##                      17                       2                       2 
    ##                G95 West                 Gateway                   Goose 
    ##                       9                      13                       3 
    ##                Hatchery           Hatchery Pipe   Hatchery Side Channel 
    ##                     280                      53                      77 
    ##                 Keister        Lower Auditorium        Lower Big Riffle 
    ##                      12                     724                       8 
    ##              Lower Hour          Lower Robinson    Lower Table Mountain 
    ##                      33                      50                      44 
    ##                 Mathews        Middle Auditoium      Moe's Side Channel 
    ##                      40                     216                     433 
    ##                    Palm                   Steep      Steep Side Channel 
    ##                       5                      20                      18 
    ##          Table Mountain       Top of Auditorium            Trailer Park 
    ##                     107                     530                     181 
    ##        Upper Auditorium           Upper Bedrock        Upper Cottonwood 
    ##                     414                      47                      13 
    ##          Upper Hatchery              Upper Hour           Upper Mathews 
    ##                     208                      21                      38 
    ##         Upper Mcfarland          Upper Robinson              Vance East 
    ##                       7                     179                      15 
    ## Vance East Side Channel              Vance West                    Weir 
    ##                       1                      24                      28

Locations names are changed to be consistent with the rest of the
Feather River redd survey files:

``` r
cleaner_data_2018 <- cleaner_data_2018 %>% 
  mutate(location = str_to_title(location),
         location = if_else(location == "Moe's Side Channel", "Moes Side Channel", location),
         location = if_else(location == "G95 East", "G95 East Side Channel", location),
         location = if_else(location == "G95 East Bottom", "G95 East Side Channel Bottom", location),
         location = if_else(location == "G95 East Top", "G95 East Side Channel Top", location),
         location = if_else(location == "G95 West", "G95 West Side Channel", location),
         location = if_else(location == "Middle Auditoium", "Mid Auditorium", location),
         location = if_else(location == "Vance East Side Channel", "Vance East", location),
         location = if_else(location == "Upper Mcfarland", "Upper McFarland", location)
         )
table(cleaner_data_2018$location)
```

    ## 
    ##                        Aleck                      Bedrock 
    ##                           52                           62 
    ##       Below Lower Auditorium                      Big Bar 
    ##                           13                            8 
    ##                Big Hole East                Big Hole West 
    ##                           20                            2 
    ##                   Big Riffle                   Cottonwood 
    ##                            6                           57 
    ##                          Eye             Eye Side Channel 
    ##                            7                           33 
    ##        G95 East Side Channel G95 East Side Channel Bottom 
    ##                           32                            9 
    ##    G95 East Side Channel Top                     G95 Main 
    ##                            2                            2 
    ##        G95 West Side Channel                      Gateway 
    ##                            9                           13 
    ##                        Goose                     Hatchery 
    ##                            3                          280 
    ##                Hatchery Pipe        Hatchery Side Channel 
    ##                           53                           77 
    ##                      Keister             Lower Auditorium 
    ##                           12                          724 
    ##             Lower Big Riffle                   Lower Hour 
    ##                            8                           33 
    ##               Lower Robinson         Lower Table Mountain 
    ##                           50                           44 
    ##                      Mathews               Mid Auditorium 
    ##                           40                          216 
    ##            Moes Side Channel                         Palm 
    ##                          433                            5 
    ##                        Steep           Steep Side Channel 
    ##                           20                           18 
    ##               Table Mountain            Top Of Auditorium 
    ##                          107                          530 
    ##                 Trailer Park             Upper Auditorium 
    ##                          181                          414 
    ##                Upper Bedrock             Upper Cottonwood 
    ##                           47                           13 
    ##               Upper Hatchery                   Upper Hour 
    ##                          208                           21 
    ##                Upper Mathews              Upper McFarland 
    ##                           38                            7 
    ##               Upper Robinson                   Vance East 
    ##                          179                           16 
    ##                   Vance West                         Weir 
    ##                           24                           28

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
table(cleaner_data_2018$type)
```

    ## 
    ##    p 
    ## 4156

``` r
cleaner_data_2018 <- cleaner_data_2018 %>% 
  mutate(type = tolower(type),
         type = if_else(type == 'p', 'Point', type))
table(cleaner_data_2018$type)
```

    ## 
    ## Point 
    ##  4156

## Explore Numeric Variables

``` r
cleaner_data_2018 %>% 
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
cleaner_data_2018 %>% 
  ggplot(aes(x = date, y = salmon_count)) + 
  geom_col() +
  facet_wrap(~year(date), scales = "free") +
  scale_x_date(labels = date_format("%b"), date_breaks = "1 month")+
  theme_minimal() +
  theme(axis.text.x = element_text(size = 10,angle = 90, vjust = 0.5, hjust=0.1)) +
  theme(axis.text.y = element_text(size = 8))+
  labs(title = "Daily Salmon Count in 2018")
```

![](feather-river-redd-survey-qc-checklist-2018_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->

**Numeric Daily Summary of salmon\_count Over 2018**

``` r
cleaner_data_2018 %>%
  group_by(date) %>%
  summarise(count = sum(salmon_count, na.rm = T)) %>%
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    0.00   12.00   30.00   37.45   55.00  125.00

``` r
#Find the most distinctive colours for visual
colourCount = length(unique(cleaner_data_2018$location))
getPalette = colorRampPalette(brewer.pal(12, "Paired"))

cleaner_data_2018  %>%
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

![](feather-river-redd-survey-qc-checklist-2018_files/figure-gfm/unnamed-chunk-14-1.png)<!-- -->

**Numeric summary of salmon\_count by location in 2018**

``` r
cleaner_data_2018 %>%
  group_by(location) %>% 
  summarise(count = sum(salmon_count, na.rm = T)) %>% 
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    0.00    3.00    7.50   25.24   19.50  158.00

**NA and Unknown Values**

-   0 % of values in the `salmon_count` column are NA.

### Variable:`redd_count`

``` r
cleaner_data_2018 %>% 
  ggplot(aes(x = date, y = redd_count)) + 
  geom_col() +
  facet_wrap(~year(date), scales = "free") +
  scale_x_date(labels = date_format("%b"), date_breaks = "1 month")+
  theme_minimal() +
  theme(axis.text.x = element_text(size = 10,angle = 90, vjust = 0.5, hjust=0.1)) +
  theme(axis.text.y = element_text(size = 8))+
  labs(title = "Daily Count of Redds in 2018")
```

![](feather-river-redd-survey-qc-checklist-2018_files/figure-gfm/unnamed-chunk-16-1.png)<!-- -->

**Numeric Daily Summary of redd\_count Over 2018**

``` r
cleaner_data_2018 %>%
  group_by(date) %>%
  summarise(count = sum(redd_count, na.rm = T)) %>%
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##     5.0    38.0    84.0   134.1   220.0   440.0

**NA and Unknown Values**

-   0 % of values in the `redd_count` column are NA.

### Variable:`redd_width_m`

``` r
cleaner_data_2018 %>%
  ggplot(aes(x = redd_width_m)) +
  geom_histogram(binwidth = 0.3, color = "black", fill = "white") +
  scale_x_continuous(breaks = round(seq(min(cleaner_data_2018$redd_width_m, na.rm = TRUE), max(cleaner_data_2018$redd_width_m, na.rm = TRUE), by = 0.5),0))+
  labs(title = "Redd Width Distribution")
```

![](feather-river-redd-survey-qc-checklist-2018_files/figure-gfm/unnamed-chunk-18-1.png)<!-- -->

**Numeric Summary of redd\_width\_m Over 2018**

``` r
summary(cleaner_data_2018$redd_width_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.100   1.000   1.225   1.381   1.700   4.500    3610

**NA and Unknown Values**

-   86.9 % of values in the `redd_width_m` column are NA.

### Variable: `redd_length_m`

``` r
cleaner_data_2018 %>%
  ggplot(aes(x = redd_length_m)) +
  geom_histogram(binwidth = 0.5, color = "black", fill = "white") +
  scale_x_continuous(breaks = round(seq(min(cleaner_data_2018$redd_length_m, na.rm = TRUE), max(cleaner_data_2018$redd_length_m, na.rm = TRUE), by = 1),0))+
  labs(title = "Redd Length Distribution")
```

![](feather-river-redd-survey-qc-checklist-2018_files/figure-gfm/unnamed-chunk-20-1.png)<!-- -->

**Numeric Summary of redd\_length\_m Over 2018**

``` r
summary(cleaner_data_2018$redd_length_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.320   2.300   3.000   3.034   3.700   6.000    3610

**NA and Unknown Values**

-   86.9 % of values in the `redd_length_m` column are NA.

### Physical Attributes

### Variable: `longitude and latitude`

``` r
utm_coords <- na.omit(subset(cleaner_data_2018, select = c("longitude", "latitude")))
utm_coords <- SpatialPoints(utm_coords,
                            proj4string=CRS("+proj=utm +zone=10 +datum=WGS84"))
long_lat_coords <- spTransform(utm_coords, CRS("+proj=longlat +datum=WGS84"))
summary(long_lat_coords)
```

    ## Object of class SpatialPoints
    ## Coordinates:
    ##                  min        max
    ## longitude -121.56048 -121.55101
    ## latitude    39.51546   39.51789
    ## Is projected: FALSE 
    ## proj4string : [+proj=longlat +datum=WGS84 +no_defs]
    ## Number of points: 57

**NA and Unknown Values**

-   98.6 % of values in the `longitude` column are NA.

-   98.6 % of values in the `latitude` column are NA.

### Variable:`percent_fine_substrate`

``` r
cleaner_data_2018 %>%
  ggplot(aes(x = percent_fine_substrate, fill = location)) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 5, position = 'stack', color = "black") +
  labs(title = "Percent Fine Substrate Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 21))
```

![](feather-river-redd-survey-qc-checklist-2018_files/figure-gfm/unnamed-chunk-23-1.png)<!-- -->

**Numeric Summary of percent\_fine\_substrate Over 2018**

``` r
summary(cleaner_data_2018$percent_fine_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.000   0.000   5.000   6.421  10.000  40.000    3614

**NA and Unknown Values**

-   87 % of values in the `percent_fine_substrate` column are NA.

### Variable:`percent_small_substrate`

``` r
cleaner_data_2018 %>%
  ggplot(aes(x = percent_small_substrate, fill = location)) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 10, position = 'stack', color = "black") +
  labs(title = "Percent Small Substrate Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 21))
```

![](feather-river-redd-survey-qc-checklist-2018_files/figure-gfm/unnamed-chunk-25-1.png)<!-- -->

**Numeric Summary of percent\_small\_substrate Over 2018**

``` r
summary(cleaner_data_2018$percent_small_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00   20.00   30.00   31.41   40.00   80.00    3613

**NA and Unknown Values**

-   86.9 % of values in the `percent_small_substrate` column are NA.

### Variable:`percent_medium_substrate`

``` r
cleaner_data_2018 %>%
  ggplot(aes(x = percent_medium_substrate, fill = location)) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 10, position = 'stack', color = "black") +
  labs(title = "Percent Medium Substrate Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 21))
```

![](feather-river-redd-survey-qc-checklist-2018_files/figure-gfm/unnamed-chunk-27-1.png)<!-- -->

**Numeric Summary of percent\_medium\_substrate Over 2018**

``` r
summary(cleaner_data_2018$percent_medium_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00   30.00   40.00   42.79   55.00   90.00    3613

**NA and Unknown Values**

-   86.9 % of values in the `percent_medium_substrate` column are NA.

### Variable:`percent_large_substrate`

``` r
cleaner_data_2018 %>%
  ggplot(aes(x = percent_large_substrate, fill = location)) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 10, position = 'stack', color = "black") +
  labs(title = "Percent Large Substrate Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 21))
```

![](feather-river-redd-survey-qc-checklist-2018_files/figure-gfm/unnamed-chunk-29-1.png)<!-- -->

**Numeric Summary of percent\_large\_substrate Over 2018**

``` r
summary(cleaner_data_2018$percent_large_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00    5.00   15.00   16.11   25.00   80.00    3613

**NA and Unknown Values**

-   86.9 % of values in the `percent_large_substrate` column are NA.

### Variable:`percent_boulder`

``` r
cleaner_data_2018 %>%
  ggplot(aes(x = percent_boulder, fill = location)) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 3, position = 'stack', color = "black") +
  labs(title = "Percent Boulder Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 21))
```

![](feather-river-redd-survey-qc-checklist-2018_files/figure-gfm/unnamed-chunk-31-1.png)<!-- -->

**Numeric Summary of percent\_boulder Over 2018**

``` r
summary(cleaner_data_2018$percent_large_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00    5.00   15.00   16.11   25.00   80.00    3613

**NA and Unknown Values**

-   86.9 % of values in the `percent_boulder` column are NA.

### Summary of Mean Percent Substrate In Each Location

``` r
cleaner_data_2018 %>% 
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

![](feather-river-redd-survey-qc-checklist-2018_files/figure-gfm/unnamed-chunk-33-1.png)<!-- -->

### Variable: `depth_m`

``` r
cleaner_data_2018 %>%
  ggplot(aes(x = depth_m, fill = location, )) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 0.1, position = 'stack', color = "black") +
  labs(title = "Depth Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 21))
```

![](feather-river-redd-survey-qc-checklist-2018_files/figure-gfm/unnamed-chunk-34-1.png)<!-- -->

**Numeric Summary of depth\_m Over 2018**

``` r
summary(cleaner_data_2018$depth_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.070   0.338   0.430   0.452   0.550   0.960    3596

**NA and Unknown Values**

-   86.5 % of values in the `depth_m` column are NA.

### Variable: `pot_depth_m`

``` r
cleaner_data_2018 %>%
  ggplot(aes(x = pot_depth_m, fill = location, )) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 0.1, position = 'stack', color = "black") +
  labs(title = "Pot Depth Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 21))
```

![](feather-river-redd-survey-qc-checklist-2018_files/figure-gfm/unnamed-chunk-36-1.png)<!-- -->

**Numeric Summary of pot\_depth\_m Over 2018**

``` r
summary(cleaner_data_2018$pot_depth_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.170   0.430   0.510   0.537   0.622   1.100    3596

**NA and Unknown Values**

-   86.5 % of values in the `pot_depth_m` column are NA.

### Variable: `velocity_m_per_s`

``` r
cleaner_data_2018 %>%
  ggplot(aes(x = velocity_m_per_s, fill = location, )) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 0.1, position = 'stack', color = "black") +
  labs(title = "Velocity Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 21))
```

![](feather-river-redd-survey-qc-checklist-2018_files/figure-gfm/unnamed-chunk-38-1.png)<!-- -->

**Numeric Summary of velocity\_m\_per\_s Over 2018**

``` r
summary(cleaner_data_2018$`velocity_m_per_s`)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.140   0.450   0.560   0.607   0.750   1.570    3960

**NA and Unknown Values**

-   95.3 % of values in the `velocity_m_per_s` column are NA.

### Add cleaned data back onto google cloud

``` r
feather_redd_survey_2018 <- cleaner_data_2018 %>% glimpse()
```

    ## Rows: 4,156
    ## Columns: 17
    ## $ date                     <date> 2018-09-18, 2018-09-18, 2018-09-18, 2018-09-~
    ## $ location                 <chr> "Lower Auditorium", "Lower Auditorium", "Lowe~
    ## $ type                     <chr> "Point", "Point", "Point", "Point", "Point", ~
    ## $ redd_count               <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ~
    ## $ salmon_count             <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, ~
    ## $ latitude                 <dbl> 4374970, NA, 4374978, 4374983, 4374987, 43749~
    ## $ longitude                <dbl> 623743.6, NA, 623812.0, 623810.8, 623810.3, 6~
    ## $ depth_m                  <dbl> 0.58, 0.38, 0.46, 0.44, 0.32, 0.46, 0.52, 0.4~
    ## $ pot_depth_m              <dbl> 0.58, 0.46, 0.48, 0.52, 0.34, 0.56, 0.58, 0.4~
    ## $ velocity_m_per_s         <dbl> 0.36, 0.39, 0.27, 0.52, 0.66, 0.55, 0.75, 0.4~
    ## $ percent_fine_substrate   <dbl> 25, 10, 10, 20, 20, 20, 10, 15, 5, 10, 5, 10,~
    ## $ percent_small_substrate  <dbl> 20, 15, 10, 30, 50, 40, 20, 30, 25, 40, 50, 5~
    ## $ percent_medium_substrate <dbl> 40, 50, 55, 25, 25, 25, 60, 50, 65, 40, 40, 3~
    ## $ percent_large_substrate  <dbl> 15, 25, 25, 25, 5, 15, 10, 5, 5, 10, 5, 0, 15~
    ## $ percent_boulder          <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
    ## $ redd_width_m             <dbl> 3.00, 1.75, 1.50, 2.00, 1.50, 1.00, 2.50, 1.5~
    ## $ redd_length_m            <dbl> 1.75, 2.50, 2.50, 2.50, 2.50, 1.75, 2.50, 2.2~

``` r
f <- function(input, output) write_csv(input, file = output)

gcs_upload(feather_redd_survey_2018,
           object_function = f,
           type = "csv",
           name = "adult-holding-redd-and-carcass-surveys/feather-river/data/feather_redd_2018.csv")
```

    ## i 2021-10-27 10:21:22 > File size detected as  297.2 Kb

    ## i 2021-10-27 10:21:22 > Request Status Code:  400

    ## ! API returned: Cannot insert legacy ACL for an object when uniform bucket-level access is enabled. Read more at https://cloud.google.com/storage/docs/uniform-bucket-level-access - Retrying with predefinedAcl='bucketLevel'

    ## i 2021-10-27 10:21:22 > File size detected as  297.2 Kb

    ## ==Google Cloud Storage Object==
    ## Name:                adult-holding-redd-and-carcass-surveys/feather-river/data/feather_redd_2018.csv 
    ## Type:                csv 
    ## Size:                297.2 Kb 
    ## Media URL:           https://www.googleapis.com/download/storage/v1/b/jpe-dev-bucket/o/adult-holding-redd-and-carcass-surveys%2Ffeather-river%2Fdata%2Ffeather_redd_2018.csv?generation=1635355281994216&alt=media 
    ## Download URL:        https://storage.cloud.google.com/jpe-dev-bucket/adult-holding-redd-and-carcass-surveys%2Ffeather-river%2Fdata%2Ffeather_redd_2018.csv 
    ## Public Download URL: https://storage.googleapis.com/jpe-dev-bucket/adult-holding-redd-and-carcass-surveys%2Ffeather-river%2Fdata%2Ffeather_redd_2018.csv 
    ## Bucket:              jpe-dev-bucket 
    ## ID:                  jpe-dev-bucket/adult-holding-redd-and-carcass-surveys/feather-river/data/feather_redd_2018.csv/1635355281994216 
    ## MD5 Hash:            Ex02DqmfD6ZU5ynP1eFIXQ== 
    ## Class:               STANDARD 
    ## Created:             2021-10-27 17:21:22 
    ## Updated:             2021-10-27 17:21:22 
    ## Generation:          1635355281994216 
    ## Meta Generation:     1 
    ## eTag:                COjjqJWN6/MCEAE= 
    ## crc32c:              UGOl7A==
