feather-river-redd-survey-qc-checklist-2013
================
Inigo Peng
10/6/2021

# Feather River Redd Survey Data

## Description of Monitoring Data

**Timeframe:** 2013

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
gcs_get_object(object_name = "adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2013_Chinook_Redd_Survey_Data_raw.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "2013_Chinook_Redd_Survey_Data_raw.xlsx",
               overwrite = TRUE)
```

Read in data from google cloud, glimpse raw data:

``` r
raw_data_2013 = readxl::read_excel("2013_Chinook_Redd_Survey_Data_raw.xlsx")
glimpse(raw_data_2013)
```

    ## Rows: 748
    ## Columns: 19
    ## $ All               <chr> "41527", "41527", "41527", "41527", "41527", "41527"~
    ## $ `Survey Wk`       <chr> "1-1", "1-1", "1-1", "1-1", "1-1", "1-1", "1-1", "1-~
    ## $ Location          <chr> "Lower Auditorium", "Lower Auditorium", "Lower Audit~
    ## $ `File #`          <dbl> 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,~
    ## $ type              <chr> "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p~
    ## $ `# of redds`      <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1~
    ## $ `# salmon`        <dbl> 0, 1, 1, 0, 1, 0, 3, 1, 0, 0, 0, 1, 1, 0, 1, 0, 2, 0~
    ## $ Latitude          <dbl> 393055.9, 393056.1, 393055.7, 393055.8, 393056.5, 39~
    ## $ Longitude         <dbl> 1213338, 1213338, 1213338, 1213338, 1213337, 1213337~
    ## $ `Depth (m)`       <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.25, NA, NA, NA~
    ## $ `Pot Depth (m)`   <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.43, NA, NA, NA~
    ## $ `Velocity (m/s)`  <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.71, NA, NA, NA~
    ## $ `% fines`         <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 10, NA, NA, NA, ~
    ## $ `% small`         <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 50, NA, NA, NA, ~
    ## $ `% med`           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 25, NA, NA, NA, ~
    ## $ `% large`         <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 15, NA, NA, NA, ~
    ## $ `% boulder`       <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 0, NA, NA, NA, N~
    ## $ `redd width (m)`  <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 1, NA, NA, NA, N~
    ## $ `redd length (m)` <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 1.5, NA, NA, NA,~

## Data Transformation

``` r
cleaner_data_2013 <- raw_data_2013 %>% 
  select(-c('Survey Wk', 'File #')) %>% 
  rename('date' = All,
         'redd_count' = '# of redds',
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
  mutate(date = as.Date(as.numeric(date), origin = "1899-12-30"))
#Convert to snakecase
cleaner_data_2013 <- cleaner_data_2013 %>% 
  set_names(tolower(colnames(cleaner_data_2013))) %>% 
  glimpse()
```

    ## Rows: 748
    ## Columns: 17
    ## $ date                     <date> 2013-09-10, 2013-09-10, 2013-09-10, 2013-09-~
    ## $ location                 <chr> "Lower Auditorium", "Lower Auditorium", "Lowe~
    ## $ type                     <chr> "p", "p", "p", "p", "p", "p", "p", "p", "p", ~
    ## $ redd_count               <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ~
    ## $ salmon_count             <dbl> 0, 1, 1, 0, 1, 0, 3, 1, 0, 0, 0, 1, 1, 0, 1, ~
    ## $ latitude                 <dbl> 393055.9, 393056.1, 393055.7, 393055.8, 39305~
    ## $ longitude                <dbl> 1213338, 1213338, 1213338, 1213338, 1213337, ~
    ## $ depth_m                  <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.25, NA,~
    ## $ pot_depth_m              <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.43, NA,~
    ## $ velocity_m_per_s         <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.71, NA,~
    ## $ percent_fine_substrate   <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 10, NA, N~
    ## $ percent_small_substrate  <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 50, NA, N~
    ## $ percent_medium_substrate <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 25, NA, N~
    ## $ percent_large_substrate  <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 15, NA, N~
    ## $ percent_boulder          <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 0, NA, NA~
    ## $ redd_width_m             <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 1, NA, NA~
    ## $ redd_length_m            <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 1.5, NA, ~

## Explore `date`

``` r
cleaner_data_2013 %>%
  ggplot(aes(x = date)) +
  geom_histogram(binwidth = 7, position = 'stack', color = "black") +
  labs(title = "Value Counts For Survey Season Dates")+
  theme(legend.text = element_text(size = 8))
```

![](feather-river-redd-survey-qc-checklist-2013_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

**Numeric Summary of date Over 2013**

``` r
summary(cleaner_data_2013$date)
```

    ##         Min.      1st Qu.       Median         Mean      3rd Qu.         Max. 
    ## "2013-09-10" "2013-09-27" "2013-10-04" "2013-10-04" "2013-10-16" "2013-10-22" 
    ##         NA's 
    ##         "34"

## Explore Categorical Variables

``` r
cleaner_data_2013 %>% 
  select_if(is.character) %>% colnames()
```

    ## [1] "location" "type"

### Variable:`location`

``` r
table(cleaner_data_2013$location)
```

    ## 
    ##           Big Bar     Big Hole East      Big HoleWest        Big Riffle 
    ##                15                21                 6                 7 
    ## Developing Riffle               G95   G95 East Bottom      G95 East Top 
    ##                 5                11                49                17 
    ##          G95 Main          G95 West      G95 West Top             Goose 
    ##                 2                11                 4                 3 
    ##   Hatchery Riffle        Hour Glide           Keister       Keister Top 
    ##                56                 4                17                 1 
    ##  Lower Auditorium        lower Hour   Lower McFarland  Lower Vance East 
    ##               327                 5                 3                 8 
    ##    Mid Auditorium Top of Auditorium  Upper Auditorium        Upper Hour 
    ##                11                33                54                18 
    ##   Upper McFarland        Vance East  Vance East Lower        Vance West 
    ##                 8                39                 6                 7

Locations names are changed to be consistent with the rest of the
Feather River redd survey files:

``` r
cleaner_data_2013 <- cleaner_data_2013 %>% 
  mutate(location = str_to_title(location),
         location = if_else(location == "Lower Mcfarland", "Lower McFarland", location),
         location = if_else(location == "Upper Mcfarland", "Upper McFarland", location),
         location = if_else(location == "Big Holewest", "Big Hole West", location),
         location = if_else(location == "G95 East Bottom", "G95 East Side Channel Bottom", location),
         location = if_else(location == "G95 East Top", "G95 East Side Channel Top", location),
         location = if_else(location == "G95 West", "G95 West Side Channel", location),
         location = if_else(location == "G95 West Top", "G95 West Side Channel Top", location),
         location = if_else(location == "Vance East Lower", "Lower Vance East", location),
         )
table(cleaner_data_2013$location)
```

    ## 
    ##                      Big Bar                Big Hole East 
    ##                           15                           21 
    ##                Big Hole West                   Big Riffle 
    ##                            6                            7 
    ##            Developing Riffle                          G95 
    ##                            5                           11 
    ## G95 East Side Channel Bottom    G95 East Side Channel Top 
    ##                           49                           17 
    ##                     G95 Main        G95 West Side Channel 
    ##                            2                           11 
    ##    G95 West Side Channel Top                        Goose 
    ##                            4                            3 
    ##              Hatchery Riffle                   Hour Glide 
    ##                           56                            4 
    ##                      Keister                  Keister Top 
    ##                           17                            1 
    ##             Lower Auditorium                   Lower Hour 
    ##                          327                            5 
    ##              Lower McFarland             Lower Vance East 
    ##                            3                           14 
    ##               Mid Auditorium            Top Of Auditorium 
    ##                           11                           33 
    ##             Upper Auditorium                   Upper Hour 
    ##                           54                           18 
    ##              Upper McFarland                   Vance East 
    ##                            8                           39 
    ##                   Vance West 
    ##                            7

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
table(cleaner_data_2013$type)
```

    ## 
    ##   A   p 
    ##   8 740

``` r
cleaner_data_2013 <- cleaner_data_2013 %>% 
  mutate(type = tolower(type),
         type = if_else(type == 'a', 'Area', type),
         type = if_else(type == 'p', 'Point', type))
table(cleaner_data_2013$type)
```

    ## 
    ##  Area Point 
    ##     8   740

## Expore Numeric Variables

``` r
cleaner_data_2013 %>% 
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
cleaner_data_2013 %>% 
  filter(is.na(date)==FALSE) %>% 
  ggplot(aes(x = date, y = salmon_count)) + 
  geom_col() +
  facet_wrap(~year(date), scales = "free") +
  scale_x_date(labels = date_format("%b"), date_breaks = "1 month")+
  theme_minimal() +
  theme(axis.text.x = element_text(size = 10,angle = 90, vjust = 0.5, hjust=0.1)) +
  theme(axis.text.y = element_text(size = 8))+
  labs(title = "Daily Count of Salmon in 2013")
```

![](feather-river-redd-survey-qc-checklist-2013_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->

**Numeric Daily Summary of salmon\_count Over 2013**

``` r
cleaner_data_2013 %>%
  group_by(date) %>%
  summarise(count = sum(salmon_count, na.rm = T)) %>%
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##     2.0    25.5    57.0    98.0   100.5   382.0

``` r
#Find the most distinctive colours for visual
colourCount = length(unique(cleaner_data_2013$location))
getPalette = colorRampPalette(brewer.pal(12, "Paired"))

cleaner_data_2013  %>%
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

![](feather-river-redd-survey-qc-checklist-2013_files/figure-gfm/unnamed-chunk-14-1.png)<!-- -->
**Numeric summary of salmon\_count by location in 2013**

``` r
cleaner_data_2013 %>%
  group_by(location) %>% 
  summarise(count = sum(salmon_count, na.rm = T)) %>% 
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    0.00    4.50    8.00   50.81   15.50  651.00

**NA and Unknown Values**

-   0 % of values in the `salmon_count` column are NA.

### Variable:`redd_count`

``` r
cleaner_data_2013 %>%
  filter(is.na(date)==FALSE) %>% 
  ggplot(aes(x = date, y = redd_count)) + 
  geom_col() +
  facet_wrap(~year(date), scales = "free") +
  scale_x_date(labels = date_format("%b"), date_breaks = "1 month")+
  theme_minimal() +
  theme(axis.text.x = element_text(size = 10,angle = 90, vjust = 0.5, hjust=0.1)) +
  theme(axis.text.y = element_text(size = 8))+
  labs(title = "Daily Count of Redds in 2013")
```

![](feather-river-redd-survey-qc-checklist-2013_files/figure-gfm/unnamed-chunk-16-1.png)<!-- -->

``` r
cleaner_data_2013  %>%
  ggplot(aes(x = redd_count, fill = location))+
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram() +
  theme_minimal() +
  theme(text = element_text(size = 7))+
  theme(axis.text.x = element_text(size = 10,vjust = 0.5, hjust=0.1))+
  labs(title = "Daily Redd Count Distribution",
       x = 'Daily Redd Count')+
  guides(fill = guide_legend(nrow = 21),
         shape = guide_legend(orride.aes = list(size =0.5)),
         color = guide_legend(orride.aes = list(size = 0.5)))
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](feather-river-redd-survey-qc-checklist-2013_files/figure-gfm/unnamed-chunk-17-1.png)<!-- -->

**Numeric Daily Summary of redd\_count Over 2013**

``` r
cleaner_data_2013 %>%
  group_by(date) %>%
  summarise(count = sum(redd_count, na.rm = T)) %>%
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    4.00   30.50   56.50   80.79   67.75  302.00

**NA and Unknown Values**

-   0 % of values in the `redd_count` column are NA.

### Variable:`redd_width_m`

``` r
cleaner_data_2013 %>%
  ggplot(aes(x = redd_width_m)) +
  geom_histogram(binwidth = 0.2, color = "black", fill = "white") +
  scale_x_continuous(breaks = round(seq(min(cleaner_data_2013$redd_width_m, na.rm = TRUE),
                                        max(cleaner_data_2013$redd_width_m, na.rm = TRUE), by = 0.3),1))+
  labs(title = "Redd Width Distribution")
```

![](feather-river-redd-survey-qc-checklist-2013_files/figure-gfm/unnamed-chunk-19-1.png)<!-- -->

**Numeric Summary of redd\_width\_m Over 2013**

``` r
summary(cleaner_data_2013$redd_width_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.500   1.000   1.200   1.243   1.500   2.000     711

**NA and Unknown Values**

-   95.1 % of values in the `redd_width_m` column are NA.

### Variable: `redd_length_m`

``` r
cleaner_data_2013 %>%
  ggplot(aes(x = redd_length_m)) +
  geom_histogram(binwidth = 0.5, color = "black", fill = "white") +
  scale_x_continuous(breaks = round(seq(min(cleaner_data_2013$redd_length_m, na.rm = TRUE), max(cleaner_data_2013$redd_length_m, na.rm = TRUE), by = 1),0))+
  labs(title = "Redd Length Distribution")
```

![](feather-river-redd-survey-qc-checklist-2013_files/figure-gfm/unnamed-chunk-21-1.png)<!-- -->

**Numeric Summary of redd\_length\_m Over 2013**

``` r
summary(cleaner_data_2013$redd_length_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   1.000   1.500   2.000   1.905   2.000   3.000     711

**NA and Unknown Values**

-   95.1 % of values in the `redd_length_m` column are NA.

### Physical Attributes

### Variable: `longitude and latitude`

``` r
utm_coords <- na.omit(subset(cleaner_data_2013, select = c("longitude", "latitude")))
utm_coords <- SpatialPoints(utm_coords,
                            proj4string=CRS("+proj=utm +zone=10 +datum=WGS84"))
long_lat_coords <- spTransform(utm_coords, CRS("+proj=longlat +datum=WGS84"))
summary(long_lat_coords)
```

    ## Object of class SpatialPoints
    ## Coordinates:
    ##                   min         max
    ## longitude -116.590890 -116.585962
    ## latitude     3.526248    3.533767
    ## Is projected: FALSE 
    ## proj4string : [+proj=longlat +datum=WGS84 +no_defs]
    ## Number of points: 748

**NA and Unknown Values**

-   0 % of values in the `longitude` column are NA.

-   0 % of values in the `latitude` column are NA.

### Variable:`percent_fine_substrate`

``` r
cleaner_data_2013 %>%
  ggplot(aes(x = percent_fine_substrate, fill = location)) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 5, position = 'stack', color = "black") +
  labs(title = "Percent Fine Substrate Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 10))
```

![](feather-river-redd-survey-qc-checklist-2013_files/figure-gfm/unnamed-chunk-24-1.png)<!-- -->

**Numeric Summary of percent\_fine\_substrate Over 2013**

``` r
summary(cleaner_data_2013$percent_fine_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    5.00    5.00   10.00   11.22   10.00   50.00     711

**NA and Unknown Values**

-   95.1 % of values in the `percent_fine_substrate` column are NA.

### Variable:`percent_small_substrate`

``` r
cleaner_data_2013 %>%
  ggplot(aes(x = percent_small_substrate, fill = location)) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 10, position = 'stack', color = "black") +
  labs(title = "Percent Small Substrate Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 10))
```

![](feather-river-redd-survey-qc-checklist-2013_files/figure-gfm/unnamed-chunk-26-1.png)<!-- -->

**Numeric Summary of percent\_small\_substrate Over 2013**

``` r
summary(cleaner_data_2013$percent_small_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    5.00   10.00   20.00   19.59   25.00   50.00     711

**NA and Unknown Values**

-   95.1 % of values in the `percent_small_substrate` column are NA.

### Variable:`percent_medium_substrate`

``` r
cleaner_data_2013 %>%
  ggplot(aes(x = percent_medium_substrate, fill = location)) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 10, position = 'stack', color = "black") +
  labs(title = "Percent Medium Substrate Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 10))
```

![](feather-river-redd-survey-qc-checklist-2013_files/figure-gfm/unnamed-chunk-28-1.png)<!-- -->

**Numeric Summary of percent\_medium\_substrate Over 2013**

``` r
summary(cleaner_data_2013$percent_medium_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   10.00   20.00   30.00   33.65   40.00   70.00     711

**NA and Unknown Values**

-   95.1 % of values in the `percent_medium_substrate` column are NA.

### Variable:`percent_large_substrate`

``` r
cleaner_data_2013 %>%
  ggplot(aes(x = percent_large_substrate, fill = location)) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 10, position = 'stack', color = "black") +
  labs(title = "Percent Large Substrate Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 10))
```

![](feather-river-redd-survey-qc-checklist-2013_files/figure-gfm/unnamed-chunk-30-1.png)<!-- -->

**Numeric Summary of percent\_large\_substrate Over 2013**

``` r
summary(cleaner_data_2013$percent_large_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00   20.00   30.00   31.76   50.00   70.00     711

**NA and Unknown Values**

-   95.1 % of values in the `percent_large_substrate` column are NA.

### Variable:`percent_boulder`

``` r
cleaner_data_2013 %>%
  ggplot(aes(x = percent_boulder, fill = location)) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 3, position = 'stack', color = "black") +
  labs(title = "Percent Boulder Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 10))
```

![](feather-river-redd-survey-qc-checklist-2013_files/figure-gfm/unnamed-chunk-32-1.png)<!-- -->

**Numeric Summary of percent\_boulder Over 2013**

``` r
summary(cleaner_data_2013$percent_boulder)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.000   0.000   0.000   3.784  10.000  20.000     711

**NA and Unknown Values**

-   95.1 % of values in the `percent_boulder` column are NA.

### Summary of Mean Percent Substrate In Each Location

``` r
cleaner_data_2013 %>% 
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

![](feather-river-redd-survey-qc-checklist-2013_files/figure-gfm/unnamed-chunk-34-1.png)<!-- -->

### Variable: `depth_m`

``` r
cleaner_data_2013 %>%
  ggplot(aes(x = depth_m, fill = location, )) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 0.1, position = 'stack', color = "black") +
  labs(title = "Depth Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 20))
```

![](feather-river-redd-survey-qc-checklist-2013_files/figure-gfm/unnamed-chunk-35-1.png)<!-- -->

**Numeric Summary of depth\_m Over 2013**

``` r
summary(cleaner_data_2013$depth_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  0.1200  0.4300  0.4900  0.4992  0.5800  0.9200     543

**NA and Unknown Values**

-   72.6 % of values in the `depth_m` column are NA.

### Variable: `pot_depth_m`

``` r
cleaner_data_2013 %>%
  ggplot(aes(x = pot_depth_m, fill = location, )) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 0.1, position = 'stack', color = "black") +
  labs(title = "Pot Depth Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 10))
```

![](feather-river-redd-survey-qc-checklist-2013_files/figure-gfm/unnamed-chunk-37-1.png)<!-- -->
**Numeric Summary of pot\_depth\_m Over 2013**

``` r
summary(cleaner_data_2013$pot_depth_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.26    0.50    0.61    0.61    0.75    0.92     711

**NA and Unknown Values**

-   95.1 % of values in the `pot_depth_m` column are NA.

### Variable: `velocity_m_per_s`

``` r
cleaner_data_2013 %>%
  ggplot(aes(x = velocity_m_per_s, fill = location, )) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 0.1, position = 'stack', color = "black") +
  labs(title = "Velocity Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 10))
```

![](feather-river-redd-survey-qc-checklist-2013_files/figure-gfm/unnamed-chunk-39-1.png)<!-- -->
**Numeric Summary of velocity\_m\_per\_s Over 2013**

``` r
summary(cleaner_data_2013$`velocity_m_per_s`)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ## -0.0400  0.4100  0.5300  0.5195  0.7000  0.9400     711

**NA and Unknown Values**

-   95.1 % of values in the `velocity_m_per_s` column are NA.

### Add cleaned data back onto google cloud

``` r
feather_redd_survey_2013 <- cleaner_data_2013 %>% glimpse()
```

    ## Rows: 748
    ## Columns: 17
    ## $ date                     <date> 2013-09-10, 2013-09-10, 2013-09-10, 2013-09-~
    ## $ location                 <chr> "Lower Auditorium", "Lower Auditorium", "Lowe~
    ## $ type                     <chr> "Point", "Point", "Point", "Point", "Point", ~
    ## $ redd_count               <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ~
    ## $ salmon_count             <dbl> 0, 1, 1, 0, 1, 0, 3, 1, 0, 0, 0, 1, 1, 0, 1, ~
    ## $ latitude                 <dbl> 393055.9, 393056.1, 393055.7, 393055.8, 39305~
    ## $ longitude                <dbl> 1213338, 1213338, 1213338, 1213338, 1213337, ~
    ## $ depth_m                  <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.25, NA,~
    ## $ pot_depth_m              <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.43, NA,~
    ## $ velocity_m_per_s         <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.71, NA,~
    ## $ percent_fine_substrate   <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 10, NA, N~
    ## $ percent_small_substrate  <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 50, NA, N~
    ## $ percent_medium_substrate <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 25, NA, N~
    ## $ percent_large_substrate  <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 15, NA, N~
    ## $ percent_boulder          <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 0, NA, NA~
    ## $ redd_width_m             <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 1, NA, NA~
    ## $ redd_length_m            <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 1.5, NA, ~

``` r
f <- function(input, output) write_csv(input, file = output)

gcs_upload(feather_redd_survey_2013,
           object_function = f,
           type = "csv",
           name = "adult-holding-redd-and-carcass-surveys/feather-river/data/feather_redd_2013.csv")
```

    ## i 2021-11-03 15:42:21 > File size detected as  69.4 Kb

    ## i 2021-11-03 15:42:21 > Request Status Code:  400

    ## ! API returned: Cannot insert legacy ACL for an object when uniform bucket-level access is enabled. Read more at https://cloud.google.com/storage/docs/uniform-bucket-level-access - Retrying with predefinedAcl='bucketLevel'

    ## i 2021-11-03 15:42:21 > File size detected as  69.4 Kb

    ## ==Google Cloud Storage Object==
    ## Name:                adult-holding-redd-and-carcass-surveys/feather-river/data/feather_redd_2013.csv 
    ## Type:                csv 
    ## Size:                69.4 Kb 
    ## Media URL:           https://www.googleapis.com/download/storage/v1/b/jpe-dev-bucket/o/adult-holding-redd-and-carcass-surveys%2Ffeather-river%2Fdata%2Ffeather_redd_2013.csv?generation=1635979341342576&alt=media 
    ## Download URL:        https://storage.cloud.google.com/jpe-dev-bucket/adult-holding-redd-and-carcass-surveys%2Ffeather-river%2Fdata%2Ffeather_redd_2013.csv 
    ## Public Download URL: https://storage.googleapis.com/jpe-dev-bucket/adult-holding-redd-and-carcass-surveys%2Ffeather-river%2Fdata%2Ffeather_redd_2013.csv 
    ## Bucket:              jpe-dev-bucket 
    ## ID:                  jpe-dev-bucket/adult-holding-redd-and-carcass-surveys/feather-river/data/feather_redd_2013.csv/1635979341342576 
    ## MD5 Hash:            NCqd1U3X4O8578mJrKB1pw== 
    ## Class:               STANDARD 
    ## Created:             2021-11-03 22:42:21 
    ## Updated:             2021-11-03 22:42:21 
    ## Generation:          1635979341342576 
    ## Meta Generation:     1 
    ## eTag:                CPDOgPyh/fMCEAE= 
    ## crc32c:              VhWlwQ==
