feather-river-redd-survey-qc-checklist-2015
================
Inigo Peng
10/6/2021

# Feather River Redd Survey Data

## Description of Monitoring Data

**Timeframe:** 2015

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
gcs_get_object(object_name = "adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2015_Chinook_Redd_Survey_Data_raw.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "2015_Chinook_Redd_Survey_Data_raw.xlsx",
               overwrite = TRUE)
```

Read in data from google cloud, glimpse raw data:

``` r
raw_data_2015 = readxl::read_excel("2015_Chinook_Redd_Survey_Data_raw.xlsx")
glimpse(raw_data_2015)
```

    ## Rows: 2,344
    ## Columns: 19
    ## $ Date              <dttm> 2015-09-16, 2015-09-16, 2015-09-16, 2015-09-16, 201~
    ## $ `Survey Wk`       <chr> "1-1", "1-1", "1-1", "1-1", "1-1", "1-1", "1-1", "1-~
    ## $ Location          <chr> "Lower Auditorium", "Lower Auditorium", "Lower Audit~
    ## $ `File #`          <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 1~
    ## $ type              <chr> "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p~
    ## $ `# of redds`      <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1~
    ## $ `# salmon`        <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 5, 3~
    ## $ Latitude          <dbl> 4375000, 4374955, 4374977, 4374978, 4374985, 4374991~
    ## $ Longitude         <dbl> 623703.5, 623760.0, 623766.3, 623766.7, 623762.2, 62~
    ## $ `Depth (m)`       <dbl> 0.40, 0.40, 0.56, 0.56, 0.50, 0.42, 0.37, 0.40, 0.37~
    ## $ `Pot Depth (m)`   <dbl> 0.50, 0.60, 0.60, 0.60, 0.60, 0.55, 0.45, 0.60, 0.45~
    ## $ `Velocity (m/s)`  <dbl> 0.40, 0.59, 0.53, 0.53, 0.55, 0.32, 0.74, 0.60, 0.61~
    ## $ `% fines`         <dbl> 20, 0, 0, 0, 0, 0, 10, 10, 10, 10, 10, 0, 0, 0, 20, ~
    ## $ `% small`         <dbl> 40, 30, 30, 30, 30, 20, 40, 30, 30, 20, 30, 10, 20, ~
    ## $ `% med`           <dbl> 40, 40, 30, 30, 30, 50, 50, 60, 50, 50, 60, 60, 40, ~
    ## $ `% large`         <dbl> 0, 30, 40, 40, 40, 30, 0, 0, 10, 20, 0, 30, 30, 30, ~
    ## $ `% boulder`       <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 20, 0, 0, 0,~
    ## $ `redd width (m)`  <dbl> 1.20, 1.10, 0.75, 0.75, 1.50, 1.60, 1.20, 1.00, 1.70~
    ## $ `redd length (m)` <dbl> 1.75, 1.75, 1.00, 1.00, 1.75, 2.00, 1.75, 1.20, 3.00~

## Data Transformation

``` r
cleaner_data_2015 <- raw_data_2015 %>% 
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
cleaner_data_2015 <- cleaner_data_2015 %>% 
  set_names(tolower(colnames(cleaner_data_2015))) %>% 
  glimpse()
```

    ## Rows: 2,344
    ## Columns: 17
    ## $ date                     <date> 2015-09-16, 2015-09-16, 2015-09-16, 2015-09-~
    ## $ location                 <chr> "Lower Auditorium", "Lower Auditorium", "Lowe~
    ## $ type                     <chr> "p", "p", "p", "p", "p", "p", "p", "p", "p", ~
    ## $ redd_count               <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ~
    ## $ salmon_count             <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
    ## $ latitude                 <dbl> 4375000, 4374955, 4374977, 4374978, 4374985, ~
    ## $ longitude                <dbl> 623703.5, 623760.0, 623766.3, 623766.7, 62376~
    ## $ depth_m                  <dbl> 0.40, 0.40, 0.56, 0.56, 0.50, 0.42, 0.37, 0.4~
    ## $ pot_depth_m              <dbl> 0.50, 0.60, 0.60, 0.60, 0.60, 0.55, 0.45, 0.6~
    ## $ velocity_m_per_s         <dbl> 0.40, 0.59, 0.53, 0.53, 0.55, 0.32, 0.74, 0.6~
    ## $ percent_fine_substrate   <dbl> 20, 0, 0, 0, 0, 0, 10, 10, 10, 10, 10, 0, 0, ~
    ## $ percent_small_substrate  <dbl> 40, 30, 30, 30, 30, 20, 40, 30, 30, 20, 30, 1~
    ## $ percent_medium_substrate <dbl> 40, 40, 30, 30, 30, 50, 50, 60, 50, 50, 60, 6~
    ## $ percent_large_substrate  <dbl> 0, 30, 40, 40, 40, 30, 0, 0, 10, 20, 0, 30, 3~
    ## $ percent_boulder          <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 20, 0~
    ## $ redd_width_m             <dbl> 1.20, 1.10, 0.75, 0.75, 1.50, 1.60, 1.20, 1.0~
    ## $ redd_length_m            <dbl> 1.75, 1.75, 1.00, 1.00, 1.75, 2.00, 1.75, 1.2~

## Explore `date`

``` r
cleaner_data_2015 %>%
  ggplot(aes(x = date)) +
  geom_histogram(binwidth = 7, position = 'stack', color = "black") +
  labs(title = "Value Counts For Survey Season Dates")+
  theme(legend.text = element_text(size = 8))
```

![](feather-river-redd-survey-qc-checklist-2015_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

**Numeric Summary of `date` in 2015**

``` r
summary(cleaner_data_2015$date)
```

    ##         Min.      1st Qu.       Median         Mean      3rd Qu.         Max. 
    ## "2015-09-16" "2015-10-06" "2015-10-19" "2015-10-20" "2015-10-30" "2015-12-04"

**NA and Unknown Values**

-   0 % of values in the `date` column are NA.

## Explore Categorical Variables

``` r
cleaner_data_2015 %>% 
  select_if(is.character) %>% colnames()
```

    ## [1] "location" "type"

### Variable:`location`

``` r
table(cleaner_data_2015$location)
```

    ## 
    ##                      Big Bar                Big Hole East 
    ##                            4                            2 
    ##                   Big Riffle                   Cottonwood 
    ##                           16                          128 
    ##                   Developing       G-95 East Side Channel 
    ##                            1                            1 
    ##                    G-95 Main G95 East Side Channel Bottom 
    ##                            1                            8 
    ##    G95 East side Channel Top                     G95 Main 
    ##                            4                            8 
    ##        G95 West Side Channel                        Goose 
    ##                            5                           16 
    ##                     Hatchery        Hatchery Side Channel 
    ##                          255                            9 
    ##                         Hour                      Keister 
    ##                           29                            5 
    ##             Lower Auditorium                   Lower Hour 
    ##                          648                            7 
    ##              Lower McFarland            Middle Auditorium 
    ##                            7                          180 
    ##           Moe's Side Channel               Table Mountain 
    ##                          215                            5 
    ##            Top of Auditorium             Upper Auditorium 
    ##                          178                          164 
    ##             Upper Cottonwood               Upper Hatchery 
    ##                          143                          281 
    ##                   Upper Hour              Upper McFarland 
    ##                            8                            2 
    ##                   Vance East 
    ##                           14

Locations names are changed to be consistent with the rest of the
Feather River redd survey files:

``` r
cleaner_data_2015 <- cleaner_data_2015 %>% 
  mutate(location = str_to_title(location),
         location = if_else(location == "Lower Mcfarland", "Lower McFarland", location),
         location = if_else(location == "Upper Mcfarland", "Upper McFarland", location),
         location = if_else(location == "G-95 East Side Channel", "G95 East Side Channel", location),
         location = if_else(location == "G-95 Main", "G95 Main", location),
         location = if_else(location == "Middle Auditorium", "Mid Auditorium", location),
         location = if_else(location == "Moe's Side Channel", "Moes Side Channel", location)
         )
table(cleaner_data_2015$location)
```

    ## 
    ##                      Big Bar                Big Hole East 
    ##                            4                            2 
    ##                   Big Riffle                   Cottonwood 
    ##                           16                          128 
    ##                   Developing        G95 East Side Channel 
    ##                            1                            1 
    ## G95 East Side Channel Bottom    G95 East Side Channel Top 
    ##                            8                            4 
    ##                     G95 Main        G95 West Side Channel 
    ##                            9                            5 
    ##                        Goose                     Hatchery 
    ##                           16                          255 
    ##        Hatchery Side Channel                         Hour 
    ##                            9                           29 
    ##                      Keister             Lower Auditorium 
    ##                            5                          648 
    ##                   Lower Hour              Lower McFarland 
    ##                            7                            7 
    ##               Mid Auditorium            Moes Side Channel 
    ##                          180                          215 
    ##               Table Mountain            Top Of Auditorium 
    ##                            5                          178 
    ##             Upper Auditorium             Upper Cottonwood 
    ##                          164                          143 
    ##               Upper Hatchery                   Upper Hour 
    ##                          281                            8 
    ##              Upper McFarland                   Vance East 
    ##                            2                           14

**NA and Unknown Values**

-   0 % of values in the `location` column are NA.

## Variable:`type`

Description:

-   Area - polygon mapped with Trimble GPS unit

-   Point - points mapped with Trimble GPS unit

-   Questionable redds - polygon mapped with Trimble GPS unit where the
    substrate was disturbed but did not have the proper characteristics
    to be called a redd - it was no longer recorded after 2011

``` r
table(cleaner_data_2015$type)
```

    ## 
    ##    p 
    ## 2344

``` r
cleaner_data_2015 <- cleaner_data_2015 %>% 
  mutate(type = tolower(type),
         type = if_else(type == 'a', 'Area', type),
         type = if_else(type == 'p', 'Point', type))
table(cleaner_data_2015$type)
```

    ## 
    ## Point 
    ##  2344

## Expore Numeric Variables

``` r
cleaner_data_2015 %>% 
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
cleaner_data_2015 %>% 
  filter(is.na(date)==FALSE) %>% 
  ggplot(aes(x = date, y = salmon_count)) + 
  geom_col() +
  facet_wrap(~year(date), scales = "free") +
  scale_x_date(labels = date_format("%b"), date_breaks = "1 month")+
  theme_minimal() +
  theme(axis.text.x = element_text(size = 10,angle = 90, vjust = 0.5, hjust=0.1)) +
  theme(axis.text.y = element_text(size = 8))+
  labs(title = "Daily Count of Salmon in 2015")
```

![](feather-river-redd-survey-qc-checklist-2015_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->

**Numeric Daily Summary of salmon\_count Over 2015**

``` r
cleaner_data_2015 %>%
  group_by(date) %>%
  summarise(count = sum(salmon_count, na.rm = T)) %>%
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    0.00   15.75   43.50   47.33   76.00  124.00

``` r
#Find the most distinctive colours for visual
colourCount = length(unique(cleaner_data_2015$location))
getPalette = colorRampPalette(brewer.pal(12, "Paired"))

cleaner_data_2015  %>%
  ggplot(aes(x = salmon_count, fill = location))+
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram() +
  theme_minimal() +
  theme(text = element_text(size = 7))+
  theme(axis.text.x = element_text(size = 10,vjust = 0.5, hjust=0.1))+
  labs(title = "Daily Salmon Count Distribution",
       x = 'Daily Salmon Count')+
  guides(fill = guide_legend(nrow = 15),
         shape = guide_legend(orride.aes = list(size =0.5)),
         color = guide_legend(orride.aes = list(size = 0.5)))
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](feather-river-redd-survey-qc-checklist-2015_files/figure-gfm/unnamed-chunk-14-1.png)<!-- -->

**Numeric summary of salmon\_count by location in 2015**

``` r
cleaner_data_2015 %>%
  group_by(location) %>% 
  summarise(count = sum(salmon_count, na.rm = T)) %>% 
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    0.00    0.00    3.00   60.86  102.00  527.00

**NA and Unknown Values**

-   0 % of values in the `salmon_count` column are NA.

### Variable:`redd_count`

``` r
cleaner_data_2015 %>% 
  filter(is.na(date)==FALSE) %>% 
  ggplot(aes(x = date, y = redd_count)) + 
  geom_col() +
  facet_wrap(~year(date), scales = "free") +
  scale_x_date(labels = date_format("%b"), date_breaks = "1 month")+
  theme_minimal() +
  theme(axis.text.x = element_text(size = 10,angle = 90, vjust = 0.5, hjust=0.1)) +
  theme(axis.text.y = element_text(size = 8))+
  labs(title = "Daily Count of Redds in 2015")
```

![](feather-river-redd-survey-qc-checklist-2015_files/figure-gfm/unnamed-chunk-16-1.png)<!-- -->

``` r
cleaner_data_2015  %>%
  ggplot(aes(x = redd_count, fill = location))+
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram() +
  theme_minimal() +
  theme(text = element_text(size = 7))+
  theme(axis.text.x = element_text(size = 10,vjust = 0.5, hjust=0.1))+
  labs(title = "Daily Redd Count Distribution",
       x = 'Daily Redd Count')+
  guides(fill = guide_legend(nrow = 15),
         shape = guide_legend(orride.aes = list(size =0.5)),
         color = guide_legend(orride.aes = list(size = 0.5)))
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](feather-river-redd-survey-qc-checklist-2015_files/figure-gfm/unnamed-chunk-17-1.png)<!-- -->

**Numeric Daily Summary of redd\_count Over 2015**

``` r
cleaner_data_2015 %>%
  group_by(date) %>%
  summarise(count = sum(redd_count, na.rm = T)) %>%
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    9.00   39.00   64.00   65.36   91.25  132.00

**NA and Unknown Values**

-   0 % of values in the `redd_count` column are NA.

### Variable:`redd_width_m`

``` r
cleaner_data_2015 %>%
  ggplot(aes(x = redd_width_m)) +
  geom_histogram(binwidth = 0.3, color = "black", fill = "white") +
  scale_x_continuous(breaks = round(seq(min(cleaner_data_2015$redd_width_m, na.rm = TRUE), max(cleaner_data_2015$redd_width_m, na.rm = TRUE), by = 0.5),0))+
  labs(title = "Redd Width Distribution")
```

![](feather-river-redd-survey-qc-checklist-2015_files/figure-gfm/unnamed-chunk-19-1.png)<!-- -->

**Numeric Summary of redd\_width\_m Over 2015**

``` r
summary(cleaner_data_2015$redd_width_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.500   1.000   1.300   1.374   1.600   3.800    1745

**NA and Unknown Values**

-   74.4 % of values in the `redd_width_m` column are NA.

### Variable: `redd_length_m`

``` r
cleaner_data_2015 %>%
  ggplot(aes(x = redd_length_m)) +
  geom_histogram(binwidth = 0.5, color = "black", fill = "white") +
  scale_x_continuous(breaks = round(seq(min(cleaner_data_2015$redd_length_m, na.rm = TRUE), max(cleaner_data_2015$redd_length_m, na.rm = TRUE), by = 1),0))+
  labs(title = "Redd Length Distribution")
```

![](feather-river-redd-survey-qc-checklist-2015_files/figure-gfm/unnamed-chunk-21-1.png)<!-- -->

**Numeric Summary of redd\_length\_m Over 2015**

``` r
summary(cleaner_data_2015$redd_length_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.800   1.600   2.000   2.131   2.500   5.600    1745

**NA and Unknown Values**

-   74.4 % of values in the `redd_length_m` column are NA.

### Physical Attributes

### Variable: `longitude and latitude`

``` r
utm_coords <- na.omit(subset(cleaner_data_2015, select = c("longitude", "latitude")))
utm_coords <- SpatialPoints(utm_coords,
                            proj4string=CRS("+proj=utm +zone=10 +datum=WGS84"))
long_lat_coords <- spTransform(utm_coords, CRS("+proj=longlat +datum=WGS84"))
summary(long_lat_coords)
```

    ## Object of class SpatialPoints
    ## Coordinates:
    ##                   min       max
    ## longitude -121.927652 -69.99173
    ## latitude     3.945821  39.52471
    ## Is projected: FALSE 
    ## proj4string : [+proj=longlat +datum=WGS84 +no_defs]
    ## Number of points: 2337

**NA and Unknown Values**

-   0.3 % of values in the `longitude` column are NA.

-   0.3 % of values in the `latitude` column are NA.

### Variable:`percent_fine_substrate`

``` r
cleaner_data_2015 %>%
  ggplot(aes(x = percent_fine_substrate, fill = location)) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 5, position = 'stack', color = "black") +
  labs(title = "Percent Fine Substrate Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 10))
```

![](feather-river-redd-survey-qc-checklist-2015_files/figure-gfm/unnamed-chunk-24-1.png)<!-- -->

**Numeric Summary of percent\_fine\_substrate Over 2015**

``` r
summary(cleaner_data_2015$percent_fine_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.000   0.000   5.000   7.963  10.000  80.000    1745

**NA and Unknown Values**

-   74.4 % of values in the `percent_fine_substrate` column are NA.

### Variable:`percent_small_substrate`

``` r
cleaner_data_2015 %>%
  ggplot(aes(x = percent_small_substrate, fill = location)) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 10, position = 'stack', color = "black") +
  labs(title = "Percent Small Substrate Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 10))
```

![](feather-river-redd-survey-qc-checklist-2015_files/figure-gfm/unnamed-chunk-26-1.png)<!-- -->

**Numeric Summary of percent\_small\_substrate Over 2015**

``` r
summary(cleaner_data_2015$percent_small_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00   20.00   30.00   31.66   40.00   90.00    1745

**NA and Unknown Values**

-   74.4 % of values in the `percent_small_substrate` column are NA.

### Variable:`percent_medium_substrate`

``` r
cleaner_data_2015 %>%
  ggplot(aes(x = percent_medium_substrate, fill = location)) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 10, position = 'stack', color = "black") +
  labs(title = "Percent Medium Substrate Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 10))
```

![](feather-river-redd-survey-qc-checklist-2015_files/figure-gfm/unnamed-chunk-28-1.png)<!-- -->

**Numeric Summary of percent\_medium\_substrate Over 2015**

``` r
summary(cleaner_data_2015$percent_medium_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    5.00   30.00   40.00   42.92   50.00   95.00    1745

**NA and Unknown Values**

-   74.4 % of values in the `percent_medium_substrate` column are NA.

### Variable:`percent_large_substrate`

``` r
cleaner_data_2015 %>%
  ggplot(aes(x = percent_large_substrate, fill = location)) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 10, position = 'stack', color = "black") +
  labs(title = "Percent Large Substrate Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 10))
```

![](feather-river-redd-survey-qc-checklist-2015_files/figure-gfm/unnamed-chunk-30-1.png)<!-- -->

**Numeric Summary of percent\_large\_substrate Over 2015**

``` r
summary(cleaner_data_2015$percent_large_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00    0.00   10.00   14.36   20.00   80.00    1745

**NA and Unknown Values**

-   74.4 % of values in the `percent_large_substrate` column are NA.

### Variable:`percent_boulder`

``` r
cleaner_data_2015 %>%
  ggplot(aes(x = percent_boulder, fill = location, )) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 7, position = 'stack', color = "black") +
  labs(title = "Percent Boulder Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 10))
```

![](feather-river-redd-survey-qc-checklist-2015_files/figure-gfm/unnamed-chunk-32-1.png)<!-- -->

**Numeric Summary of percent\_boulder Over 2015**

``` r
summary(cleaner_data_2015$percent_boulder)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.000   0.000   0.000   3.045   3.500  40.000    1745

**NA and Unknown Values**

-   74.4 % of values in the `percent_large_substrate` column are NA.

### Summary of Mean Percent Substrate In Each Location

``` r
cleaner_data_2015 %>% 
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

![](feather-river-redd-survey-qc-checklist-2015_files/figure-gfm/unnamed-chunk-34-1.png)<!-- -->

### Variable: `depth_m`

``` r
cleaner_data_2015 %>%
  ggplot(aes(x = depth_m, fill = location )) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 0.15, position = 'stack', color = "black") +
  labs(title = "Depth Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 10))
```

![](feather-river-redd-survey-qc-checklist-2015_files/figure-gfm/unnamed-chunk-35-1.png)<!-- -->

**Numeric Summary of depth\_m Over 2015**

``` r
summary(cleaner_data_2015$depth_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  0.0800  0.3200  0.4300  0.4534  0.5600  1.3000    1745

**NA and Unknown Values**

-   74.4 % of values in the `depth_m` column are NA.

### Variable: `pot_depth_m`

``` r
cleaner_data_2015 %>%
  ggplot(aes(x = pot_depth_m, fill = location, )) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 0.15, position = 'stack', color = "black") +
  labs(title = "Pot Depth Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 10))
```

![](feather-river-redd-survey-qc-checklist-2015_files/figure-gfm/unnamed-chunk-37-1.png)<!-- -->

**Numeric Summary of pot\_depth\_m Over 2015**

``` r
summary(cleaner_data_2015$pot_depth_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  0.1500  0.4200  0.5200  0.5312  0.6200  1.7000    1745

**NA and Unknown Values**

-   74.4 % of values in the `pot_depth_m` column are NA.

### Variable: `velocity_m_per_s`

``` r
cleaner_data_2015 %>%
  ggplot(aes(x = velocity_m_per_s, fill = location, )) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 0.25, position = 'stack', color = "black") +
  labs(title = "Velocity Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 10))
```

![](feather-river-redd-survey-qc-checklist-2015_files/figure-gfm/unnamed-chunk-39-1.png)<!-- -->

**Numeric Summary of velocity\_m\_per\_s Over 2015**

``` r
summary(cleaner_data_2015$`velocity_m_per_s`)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  0.0100  0.3100  0.4300  0.4588  0.5700  1.5000    1745

**NA and Unknown Values**

-   74.4 % of values in the `velocity_m_per_s` column are NA.

### Add cleaned data back onto google cloud

``` r
feather_redd_survey_2015 <- cleaner_data_2015 %>% glimpse()
```

    ## Rows: 2,344
    ## Columns: 17
    ## $ date                     <date> 2015-09-16, 2015-09-16, 2015-09-16, 2015-09-~
    ## $ location                 <chr> "Lower Auditorium", "Lower Auditorium", "Lowe~
    ## $ type                     <chr> "Point", "Point", "Point", "Point", "Point", ~
    ## $ redd_count               <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ~
    ## $ salmon_count             <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
    ## $ latitude                 <dbl> 4375000, 4374955, 4374977, 4374978, 4374985, ~
    ## $ longitude                <dbl> 623703.5, 623760.0, 623766.3, 623766.7, 62376~
    ## $ depth_m                  <dbl> 0.40, 0.40, 0.56, 0.56, 0.50, 0.42, 0.37, 0.4~
    ## $ pot_depth_m              <dbl> 0.50, 0.60, 0.60, 0.60, 0.60, 0.55, 0.45, 0.6~
    ## $ velocity_m_per_s         <dbl> 0.40, 0.59, 0.53, 0.53, 0.55, 0.32, 0.74, 0.6~
    ## $ percent_fine_substrate   <dbl> 20, 0, 0, 0, 0, 0, 10, 10, 10, 10, 10, 0, 0, ~
    ## $ percent_small_substrate  <dbl> 40, 30, 30, 30, 30, 20, 40, 30, 30, 20, 30, 1~
    ## $ percent_medium_substrate <dbl> 40, 40, 30, 30, 30, 50, 50, 60, 50, 50, 60, 6~
    ## $ percent_large_substrate  <dbl> 0, 30, 40, 40, 40, 30, 0, 0, 10, 20, 0, 30, 3~
    ## $ percent_boulder          <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 20, 0~
    ## $ redd_width_m             <dbl> 1.20, 1.10, 0.75, 0.75, 1.50, 1.60, 1.20, 1.0~
    ## $ redd_length_m            <dbl> 1.75, 1.75, 1.00, 1.00, 1.75, 2.00, 1.75, 1.2~

``` r
f <- function(input, output) write_csv(input, file = output)

gcs_upload(feather_redd_survey_2015,
           object_function = f,
           type = "csv",
           name = "adult-holding-redd-and-carcass-surveys/feather-river/data/feather_redd_2015.csv")
```

    ## i 2021-10-27 10:14:23 > File size detected as  206.5 Kb

    ## i 2021-10-27 10:14:23 > Request Status Code:  400

    ## ! API returned: Cannot insert legacy ACL for an object when uniform bucket-level access is enabled. Read more at https://cloud.google.com/storage/docs/uniform-bucket-level-access - Retrying with predefinedAcl='bucketLevel'

    ## i 2021-10-27 10:14:23 > File size detected as  206.5 Kb

    ## ==Google Cloud Storage Object==
    ## Name:                adult-holding-redd-and-carcass-surveys/feather-river/data/feather_redd_2015.csv 
    ## Type:                csv 
    ## Size:                206.5 Kb 
    ## Media URL:           https://www.googleapis.com/download/storage/v1/b/jpe-dev-bucket/o/adult-holding-redd-and-carcass-surveys%2Ffeather-river%2Fdata%2Ffeather_redd_2015.csv?generation=1635354863158091&alt=media 
    ## Download URL:        https://storage.cloud.google.com/jpe-dev-bucket/adult-holding-redd-and-carcass-surveys%2Ffeather-river%2Fdata%2Ffeather_redd_2015.csv 
    ## Public Download URL: https://storage.googleapis.com/jpe-dev-bucket/adult-holding-redd-and-carcass-surveys%2Ffeather-river%2Fdata%2Ffeather_redd_2015.csv 
    ## Bucket:              jpe-dev-bucket 
    ## ID:                  jpe-dev-bucket/adult-holding-redd-and-carcass-surveys/feather-river/data/feather_redd_2015.csv/1635354863158091 
    ## MD5 Hash:            V2qjBC85bFiPVtedESt8BA== 
    ## Class:               STANDARD 
    ## Created:             2021-10-27 17:14:23 
    ## Updated:             2021-10-27 17:14:23 
    ## Generation:          1635354863158091 
    ## Meta Generation:     1 
    ## eTag:                CMuGzc2L6/MCEAE= 
    ## crc32c:              KzQ8qA==
