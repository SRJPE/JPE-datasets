feather-river-redd-survey-qc-checklist-2019
================
Inigo Peng
10/6/2021

# Feather River Redd Survey Data

## Description of Monitoring Data

**Timeframe:** 2019

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
gcs_get_object(object_name = "adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2019_Chinook_Redd_Survey_Data_raw.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "2019_Chinook_Redd_Survey_Data_raw.xlsx",
               overwrite = TRUE)
```

Read in data from google cloud, glimpse raw data:

``` r
raw_data_2019 = readxl::read_excel("2019_Chinook_Redd_Survey_Data_raw.xlsx",
                                   col_types = c("date","text","text","numeric","text","numeric", "numeric", "numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric"
                                                 ,"numeric","numeric","numeric","numeric"))
glimpse(raw_data_2019)
```

    ## Rows: 5,048
    ## Columns: 19
    ## $ Date              <dttm> 2019-09-03, 2019-09-04, 2019-09-05, 2019-09-06, 201~
    ## $ `Survey Wk`       <chr> "1-1", "1-2", "1-3", "1-4", "2-1", "3-1", "3-1", "3-~
    ## $ Location          <chr> NA, NA, NA, NA, NA, "Middle Auditorium", "Middle Aud~
    ## $ `File #`          <dbl> NA, NA, NA, NA, NA, 1, 2, 3, 1, 2, 3, 4, 5, 6, 7, 8,~
    ## $ Type              <chr> NA, NA, NA, NA, NA, "p", "p", "p", "p", "p", "p", "p~
    ## $ `# redds`         <dbl> 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1~
    ## $ `# salmon`        <dbl> 0, 0, 0, 0, 0, 1, 3, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0~
    ## $ `Latitude mN`     <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ `Longitude mE`    <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ `Depth (m)`       <dbl> NA, NA, NA, NA, NA, 0.24, 0.47, 0.56, 0.48, 0.50, 0.~
    ## $ `Pot Depth (m)`   <dbl> NA, NA, NA, NA, NA, 0.34, 0.60, 0.72, 0.52, 0.54, 0.~
    ## $ `Velocity (m/s)`  <dbl> NA, NA, NA, NA, NA, 0.64, 1.10, 0.50, 0.47, 0.69, 0.~
    ## $ `% fines`         <dbl> NA, NA, NA, NA, NA, 10, 0, 0, 5, 0, 0, 5, 5, 40, 10,~
    ## $ `% small`         <dbl> NA, NA, NA, NA, NA, 40, 40, 60, 35, 30, 40, 20, 40, ~
    ## $ `% med`           <dbl> NA, NA, NA, NA, NA, 50, 50, 40, 60, 70, 55, 70, 50, ~
    ## $ `% large`         <dbl> NA, NA, NA, NA, NA, 0, 0, 0, 0, 0, 5, 5, 5, 5, 0, 5,~
    ## $ `% boulder`       <dbl> NA, NA, NA, NA, NA, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0~
    ## $ `redd width (m)`  <dbl> NA, NA, NA, NA, NA, 1.1, 1.5, 2.0, 1.1, 1.0, 1.2, 0.~
    ## $ `redd length (m)` <dbl> NA, NA, NA, NA, NA, 4.5, 4.5, 3.7, 2.0, 1.5, 3.1, 1.~

## Data Transformations

``` r
cleaner_data_2019 <- raw_data_2019 %>% 
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
         'redd_length_m' = 'redd length (m)',
         ) %>% 
  mutate(Date = as.Date(Date))
cleaner_data_2019 <- cleaner_data_2019 %>% 
  set_names(tolower(colnames(cleaner_data_2019))) %>% 
  glimpse()
```

    ## Rows: 5,048
    ## Columns: 17
    ## $ date                     <date> 2019-09-03, 2019-09-04, 2019-09-05, 2019-09-~
    ## $ location                 <chr> NA, NA, NA, NA, NA, "Middle Auditorium", "Mid~
    ## $ type                     <chr> NA, NA, NA, NA, NA, "p", "p", "p", "p", "p", ~
    ## $ redd_count               <dbl> 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ~
    ## $ salmon_count             <dbl> 0, 0, 0, 0, 0, 1, 3, 2, 0, 0, 0, 0, 0, 0, 0, ~
    ## $ latitude                 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ longitude                <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ depth_m                  <dbl> NA, NA, NA, NA, NA, 0.24, 0.47, 0.56, 0.48, 0~
    ## $ pot_depth_m              <dbl> NA, NA, NA, NA, NA, 0.34, 0.60, 0.72, 0.52, 0~
    ## $ velocity_m_per_s         <dbl> NA, NA, NA, NA, NA, 0.64, 1.10, 0.50, 0.47, 0~
    ## $ percent_fine_substrate   <dbl> NA, NA, NA, NA, NA, 10, 0, 0, 5, 0, 0, 5, 5, ~
    ## $ percent_small_substrate  <dbl> NA, NA, NA, NA, NA, 40, 40, 60, 35, 30, 40, 2~
    ## $ percent_medium_substrate <dbl> NA, NA, NA, NA, NA, 50, 50, 40, 60, 70, 55, 7~
    ## $ percent_large_substrate  <dbl> NA, NA, NA, NA, NA, 0, 0, 0, 0, 0, 5, 5, 5, 5~
    ## $ percent_boulder          <dbl> NA, NA, NA, NA, NA, 0, 10, 0, 0, 0, 0, 0, 0, ~
    ## $ redd_width_m             <dbl> NA, NA, NA, NA, NA, 1.1, 1.5, 2.0, 1.1, 1.0, ~
    ## $ redd_length_m            <dbl> NA, NA, NA, NA, NA, 4.5, 4.5, 3.7, 2.0, 1.5, ~

## Explore `date`

``` r
cleaner_data_2019 %>%
  ggplot(aes(x = date)) +
  geom_histogram(binwidth = 7, position = 'stack', color = "black") +
  labs(title = "Value Counts For Survey Season Dates")+
  theme(legend.text = element_text(size = 8))
```

![](feather-river-redd-survey-qc-checklist-2019_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

**Numeric summary of date in 2019**

``` r
summary(cleaner_data_2019$date)
```

    ##         Min.      1st Qu.       Median         Mean      3rd Qu.         Max. 
    ## "2019-09-03" "2019-10-15" "2019-10-25" "2019-10-24" "2019-11-04" "2019-11-22"

**NA and Unknown Values**

-   0 % of values in the `date` column are NA.

## Explore Categorical Variables

``` r
cleaner_data_2019 %>% 
  select_if(is.character) %>% colnames()
```

    ## [1] "location" "type"

### Variable:`location`

``` r
table(cleaner_data_2019$location)
```

    ## 
    ##                Bedrock    Below Big Hole East Below Lower Auditorium 
    ##                    125                      3                    126 
    ##                Big Bar          Big Hole East          Big Hole West 
    ##                      6                     51                      6 
    ##             Big Riffle             Cottonwood                    Eye 
    ##                     11                     93                     21 
    ##       Eye Side Channel        G95 East Bottom           G95 East Top 
    ##                     12                      4                     42 
    ##               G95 Main               G95 West  G95 West Side Channel 
    ##                     11                      4                      1 
    ##                Gateway               Hatchery          Hatchery Pipe 
    ##                     11                    471                    122 
    ##  Hatchery Side Channel              High Flow                Keister 
    ##                      1                      1                      5 
    ##       Lower Auditorium             lower Hour             Lower Hour 
    ##                    737                      5                     14 
    ##         Lower Robinson   Lower Table Mountain       Lower Vance East 
    ##                    224                    197                      6 
    ##               Matthews      Middle Auditorium     Moe's Side Channel 
    ##                     81                    204                    268 
    ##                  Steep     Steep Side Channel         Table Mountain 
    ##                     44                      9                    245 
    ##      Top of Auditorium           Trailer Park       Upper Auditorium 
    ##                    434                    567                    365 
    ##       Upper Cottonwood         Upper Hatchery             Upper Hour 
    ##                     31                    222                      8 
    ##         Upper Matthews        Upper McFarland         Upper Robinson 
    ##                     33                      2                    137 
    ##             Vance East             Vance West                   Weir 
    ##                     21                      4                     58

Locations names are changed to be consistent with the rest of the
Feather River redd survey files:

``` r
cleaner_data_2019 <- cleaner_data_2019 %>% 
  mutate(location = str_to_title(location),
         location = if_else(location == "G95 East Bottom", "G95 East Side Channel Bottom", location),
         location = if_else(location == "G95 East Top", "G95 East Side Channel Top", location),
         location = if_else(location == "G95 West", "G95 West Side Channel", location),
         location = if_else(location == "Matthews", "Mathews", location),
         location = if_else(location == "Moe's Side Channel", "Moes Side Channel", location),
         location = if_else(location == "Middle Auditorium", "Mid Auditorium", location),
         location = if_else(location == "Upper Matthews", "Upper Mathews", location),
         location = if_else(location == "Upper Mcfarland", "Upper McFarland", location)
         )
table(cleaner_data_2019$location)
```

    ## 
    ##                      Bedrock          Below Big Hole East 
    ##                          125                            3 
    ##       Below Lower Auditorium                      Big Bar 
    ##                          126                            6 
    ##                Big Hole East                Big Hole West 
    ##                           51                            6 
    ##                   Big Riffle                   Cottonwood 
    ##                           11                           93 
    ##                          Eye             Eye Side Channel 
    ##                           21                           12 
    ## G95 East Side Channel Bottom    G95 East Side Channel Top 
    ##                            4                           42 
    ##                     G95 Main        G95 West Side Channel 
    ##                           11                            5 
    ##                      Gateway                     Hatchery 
    ##                           11                          471 
    ##                Hatchery Pipe        Hatchery Side Channel 
    ##                          122                            1 
    ##                    High Flow                      Keister 
    ##                            1                            5 
    ##             Lower Auditorium                   Lower Hour 
    ##                          737                           19 
    ##               Lower Robinson         Lower Table Mountain 
    ##                          224                          197 
    ##             Lower Vance East                      Mathews 
    ##                            6                           81 
    ##               Mid Auditorium            Moes Side Channel 
    ##                          204                          268 
    ##                        Steep           Steep Side Channel 
    ##                           44                            9 
    ##               Table Mountain            Top Of Auditorium 
    ##                          245                          434 
    ##                 Trailer Park             Upper Auditorium 
    ##                          567                          365 
    ##             Upper Cottonwood               Upper Hatchery 
    ##                           31                          222 
    ##                   Upper Hour                Upper Mathews 
    ##                            8                           33 
    ##              Upper McFarland               Upper Robinson 
    ##                            2                          137 
    ##                   Vance East                   Vance West 
    ##                           21                            4 
    ##                         Weir 
    ##                           58

**NA and Unknown Values**

-   0.1 % of values in the `location` column are NA.

## Variable:`type`

# Description:

-   Area - polygon mapped with Trimble GPS unit

-   Point - points mapped with Trimble GPS unit

-   Questionable redds - polygon mapped with Trimble GPS unit where the
    substrate was disturbed but did not have the proper characteristics
    to be called a redd - it was no longer recorded after 2011

``` r
table(cleaner_data_2019$type)
```

    ## 
    ##    p 
    ## 5042

``` r
cleaner_data_2019 <- cleaner_data_2019 %>% 
  mutate(type = tolower(type),
         type = if_else(type == 'p', 'Point', type))
table(cleaner_data_2019$type)
```

    ## 
    ## Point 
    ##  5042

## Explore Numeric Variables

``` r
cleaner_data_2019 %>% 
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
cleaner_data_2019 %>% 
  ggplot(aes(x = date, y = salmon_count)) + 
  geom_col() +
  facet_wrap(~year(date), scales = "free") +
  scale_x_date(labels = date_format("%b"), date_breaks = "1 month")+
  theme_minimal() +
  theme(axis.text.x = element_text(size = 10,angle = 90, vjust = 0.5, hjust=0.1)) +
  theme(axis.text.y = element_text(size = 8))+
  labs(title = "Daily Salmon Count in 2019")
```

![](feather-river-redd-survey-qc-checklist-2019_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->

**Numeric Daily Summary of salmon\_count Over 2019**

``` r
cleaner_data_2019 %>%
  group_by(date) %>%
  summarise(count = sum(salmon_count, na.rm = T)) %>%
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    0.00    3.50    7.00   12.88   15.50  101.00

``` r
#Find the most distinctive colours for visual
colourCount = length(unique(cleaner_data_2019$location))
getPalette = colorRampPalette(brewer.pal(12, "Paired"))

cleaner_data_2019  %>%
  filter(!is.na(location)) %>% 
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

![](feather-river-redd-survey-qc-checklist-2019_files/figure-gfm/unnamed-chunk-14-1.png)<!-- -->
**Numeric summary of salmon\_count by location in 2019**

``` r
cleaner_data_2019 %>%
  group_by(location) %>% 
  summarise(count = sum(salmon_count, na.rm = T)) %>% 
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    0.00    0.00    3.50   12.59   11.50  143.00

**NA and Unknown Values**

-   0 % of values in the `salmon_count` column are NA.

### Variable:`redd_count`

``` r
cleaner_data_2019 %>% 
  ggplot(aes(x = date, y = redd_count)) + 
  geom_col() +
  facet_wrap(~year(date), scales = "free") +
  scale_x_date(labels = date_format("%b"), date_breaks = "1 month")+
  theme_minimal() +
  theme(axis.text.x = element_text(size = 10,angle = 90, vjust = 0.5, hjust=0.1)) +
  theme(axis.text.y = element_text(size = 8))+
  labs(title = "Daily Count of Redds in 2019")
```

![](feather-river-redd-survey-qc-checklist-2019_files/figure-gfm/unnamed-chunk-16-1.png)<!-- -->

``` r
cleaner_data_2019  %>%
  filter(!is.na(location)) %>% 
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

![](feather-river-redd-survey-qc-checklist-2019_files/figure-gfm/unnamed-chunk-17-1.png)<!-- -->

**Numeric Daily Summary of redd\_count Over 2019**

``` r
cleaner_data_2019 %>%
  group_by(date) %>%
  summarise(count = sum(redd_count, na.rm = T)) %>%
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##     0.0    35.5   113.0   117.3   157.0   471.0

**NA and Unknown Values**

-   0 % of values in the `redd_count` column are NA.

### Variable:`redd_width_m`

``` r
cleaner_data_2019 %>%
  ggplot(aes(x = redd_width_m)) +
  geom_histogram(binwidth = 0.3, color = "black", fill = "white") +
  scale_x_continuous(breaks = round(seq(min(cleaner_data_2019$redd_width_m, na.rm = TRUE), max(cleaner_data_2019$redd_width_m, na.rm = TRUE), by = 0.5),0))+
  labs(title = "Redd Width Distribution")
```

![](feather-river-redd-survey-qc-checklist-2019_files/figure-gfm/unnamed-chunk-19-1.png)<!-- -->

**Numeric Summary of redd\_width\_m Over 2019**

``` r
summary(cleaner_data_2019$redd_width_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.600   1.200   1.400   1.539   1.900   6.100    4393

**NA and Unknown Values**

-   87 % of values in the `redd_width_m` column are NA.

### Variable: `redd_length_m`

``` r
cleaner_data_2019 %>%
  ggplot(aes(x = redd_length_m)) +
  geom_histogram(binwidth = 0.5, color = "black", fill = "white") +
  scale_x_continuous(breaks = round(seq(min(cleaner_data_2019$redd_length_m, na.rm = TRUE), max(cleaner_data_2019$redd_length_m, na.rm = TRUE), by = 1),0))+
  labs(title = "Redd Length Distribution")
```

![](feather-river-redd-survey-qc-checklist-2019_files/figure-gfm/unnamed-chunk-21-1.png)<!-- -->

**Numeric Summary of redd\_length\_m Over 2019**

``` r
summary(cleaner_data_2019$redd_length_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   1.000   2.110   2.600   2.788   3.300   9.700    4393

**NA and Unknown Values**

-   87 % of values in the `redd_length_m` column are NA.

### Physical Attributes

### Variable:`percent_fine_substrate`

``` r
cleaner_data_2019 %>%
  ggplot(aes(x = percent_fine_substrate, fill = location)) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 5, position = 'stack', color = "black") +
  labs(title = "Percent Fine Substrate Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 20))
```

![](feather-river-redd-survey-qc-checklist-2019_files/figure-gfm/unnamed-chunk-23-1.png)<!-- -->

**Numeric Summary of percent\_fine\_substrate Over 2019**

``` r
summary(cleaner_data_2019$percent_fine_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.000   0.000   5.000   9.263  10.000  90.000    4402

**NA and Unknown Values**

-   87.2 % of values in the `percent_fine_substrate` column are NA.

### Variable:`percent_small_substrate`

``` r
cleaner_data_2019 %>%
  ggplot(aes(x = percent_small_substrate, fill = location)) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 10, position = 'stack', color = "black") +
  labs(title = "Percent Small Substrate Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 20))
```

![](feather-river-redd-survey-qc-checklist-2019_files/figure-gfm/unnamed-chunk-25-1.png)<!-- -->

**Numeric Summary of percent\_small\_substrate Over 2019**

``` r
summary(cleaner_data_2019$percent_small_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00   20.00   30.00   35.03   45.00   90.00    4402

**NA and Unknown Values**

-   87.2 % of values in the `percent_small_substrate` column are NA.

### Variable:`percent_medium_substrate`

``` r
cleaner_data_2019 %>%
  ggplot(aes(x = percent_medium_substrate, fill = location)) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 10, position = 'stack', color = "black") +
  labs(title = "Percent Medium Substrate Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 20))
```

![](feather-river-redd-survey-qc-checklist-2019_files/figure-gfm/unnamed-chunk-27-1.png)<!-- -->

**Numeric Summary of percent\_medium\_substrate Over 2019**

``` r
summary(cleaner_data_2019$percent_medium_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##     0.0    30.0    40.0    39.1    50.0    90.0    4402

**NA and Unknown Values**

-   87.2 % of values in the `percent_medium_substrate` column are NA.

### Variable:`percent_large_substrate`

``` r
cleaner_data_2019 %>%
  ggplot(aes(x = percent_large_substrate, fill = location)) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 10, position = 'stack', color = "black") +
  labs(title = "Percent Large Substrate Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 20))
```

![](feather-river-redd-survey-qc-checklist-2019_files/figure-gfm/unnamed-chunk-29-1.png)<!-- -->

**Numeric Summary of percent\_large\_substrate Over 2019**

``` r
summary(cleaner_data_2019$percent_large_substrate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00    0.00   10.00   14.07   20.00   70.00    4402

**NA and Unknown Values**

-   87.2 % of values in the `percent_large_substrate` column are NA.

### Variable:`percent_boulder`

``` r
cleaner_data_2019 %>%
  ggplot(aes(x = percent_boulder, fill = location)) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 4, position = 'stack', color = "black") +
  labs(title = "Percent Boulder Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 20))
```

![](feather-river-redd-survey-qc-checklist-2019_files/figure-gfm/unnamed-chunk-31-1.png)<!-- -->

**Numeric Summary of percent\_boulder Over 2019**

``` r
summary(cleaner_data_2019$percent_boulder)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.000   0.000   0.000   2.508   5.000  70.000    4402

**NA and Unknown Values**

-   87.2 % of values in the `percent_large_substrate` column are NA.

### Summary of Mean Percent Substrate In Each Location

``` r
cleaner_data_2019 %>% 
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

![](feather-river-redd-survey-qc-checklist-2019_files/figure-gfm/unnamed-chunk-33-1.png)<!-- -->

### Variable: `depth_m`

``` r
cleaner_data_2019 %>%
  ggplot(aes(x = depth_m, fill = location, )) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 0.1, position = 'stack', color = "black") +
  labs(title = "Depth Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 20))
```

![](feather-river-redd-survey-qc-checklist-2019_files/figure-gfm/unnamed-chunk-34-1.png)<!-- -->
**Numeric Summary of depth\_m Over 2019**

``` r
summary(cleaner_data_2019$depth_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.070   0.300   0.420   0.435   0.540   1.200    4389

**NA and Unknown Values**

-   86.9 % of values in the `depth_m` column are NA.

### Variable: `pot_depth_m`

``` r
cleaner_data_2019 %>%
  ggplot(aes(x = pot_depth_m, fill = location, )) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 0.2, position = 'stack', color = "black") +
  labs(title = "Pot Depth Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 20))
```

![](feather-river-redd-survey-qc-checklist-2019_files/figure-gfm/unnamed-chunk-36-1.png)<!-- -->

**Numeric Summary of pot\_depth\_m Over 2019**

``` r
summary(cleaner_data_2019$pot_depth_m)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.100   0.400   0.500   0.523   0.640   1.400    4389

**NA and Unknown Values**

-   86.9 % of values in the `pot_depth_m` column are NA.

### Variable: `velocity_m_per_s`

``` r
cleaner_data_2019 %>%
  ggplot(aes(x = velocity_m_per_s, fill = location, )) +
  scale_fill_manual(values = getPalette(colourCount))+
  geom_histogram(binwidth = 0.1, position = 'stack', color = "black") +
  labs(title = "Velocity Distribution")+
  theme(legend.text = element_text(size = 8)) +
  guides(fill = guide_legend(nrow = 20))
```

![](feather-river-redd-survey-qc-checklist-2019_files/figure-gfm/unnamed-chunk-38-1.png)<!-- -->

**Numeric Summary of velocity\_m\_per\_s Over 2019**

``` r
summary(cleaner_data_2019$`velocity_m_per_s`)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.050   0.330   0.478   0.503   0.648   1.400    4570

**NA and Unknown Values**

-   90.5 % of values in the `velocity_m_per_s` column are NA.

### Add cleaned data back onto google cloud

``` r
feather_redd_survey_2019 <- cleaner_data_2019 %>% glimpse()
```

    ## Rows: 5,048
    ## Columns: 17
    ## $ date                     <date> 2019-09-03, 2019-09-04, 2019-09-05, 2019-09-~
    ## $ location                 <chr> NA, NA, NA, NA, NA, "Mid Auditorium", "Mid Au~
    ## $ type                     <chr> NA, NA, NA, NA, NA, "Point", "Point", "Point"~
    ## $ redd_count               <dbl> 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ~
    ## $ salmon_count             <dbl> 0, 0, 0, 0, 0, 1, 3, 2, 0, 0, 0, 0, 0, 0, 0, ~
    ## $ latitude                 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ longitude                <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ depth_m                  <dbl> NA, NA, NA, NA, NA, 0.24, 0.47, 0.56, 0.48, 0~
    ## $ pot_depth_m              <dbl> NA, NA, NA, NA, NA, 0.34, 0.60, 0.72, 0.52, 0~
    ## $ velocity_m_per_s         <dbl> NA, NA, NA, NA, NA, 0.64, 1.10, 0.50, 0.47, 0~
    ## $ percent_fine_substrate   <dbl> NA, NA, NA, NA, NA, 10, 0, 0, 5, 0, 0, 5, 5, ~
    ## $ percent_small_substrate  <dbl> NA, NA, NA, NA, NA, 40, 40, 60, 35, 30, 40, 2~
    ## $ percent_medium_substrate <dbl> NA, NA, NA, NA, NA, 50, 50, 40, 60, 70, 55, 7~
    ## $ percent_large_substrate  <dbl> NA, NA, NA, NA, NA, 0, 0, 0, 0, 0, 5, 5, 5, 5~
    ## $ percent_boulder          <dbl> NA, NA, NA, NA, NA, 0, 10, 0, 0, 0, 0, 0, 0, ~
    ## $ redd_width_m             <dbl> NA, NA, NA, NA, NA, 1.1, 1.5, 2.0, 1.1, 1.0, ~
    ## $ redd_length_m            <dbl> NA, NA, NA, NA, NA, 4.5, 4.5, 3.7, 2.0, 1.5, ~

``` r
f <- function(input, output) write_csv(input, file = output)

gcs_upload(feather_redd_survey_2019,
           object_function = f,
           type = "csv",
           name = "adult-holding-redd-and-carcass-surveys/feather-river/data/feather_redd_2019.csv")
```

    ## i 2021-10-27 10:24:01 > File size detected as  357.7 Kb

    ## i 2021-10-27 10:24:01 > Request Status Code:  400

    ## ! API returned: Cannot insert legacy ACL for an object when uniform bucket-level access is enabled. Read more at https://cloud.google.com/storage/docs/uniform-bucket-level-access - Retrying with predefinedAcl='bucketLevel'

    ## i 2021-10-27 10:24:01 > File size detected as  357.7 Kb

    ## ==Google Cloud Storage Object==
    ## Name:                adult-holding-redd-and-carcass-surveys/feather-river/data/feather_redd_2019.csv 
    ## Type:                csv 
    ## Size:                357.7 Kb 
    ## Media URL:           https://www.googleapis.com/download/storage/v1/b/jpe-dev-bucket/o/adult-holding-redd-and-carcass-surveys%2Ffeather-river%2Fdata%2Ffeather_redd_2019.csv?generation=1635355441538724&alt=media 
    ## Download URL:        https://storage.cloud.google.com/jpe-dev-bucket/adult-holding-redd-and-carcass-surveys%2Ffeather-river%2Fdata%2Ffeather_redd_2019.csv 
    ## Public Download URL: https://storage.googleapis.com/jpe-dev-bucket/adult-holding-redd-and-carcass-surveys%2Ffeather-river%2Fdata%2Ffeather_redd_2019.csv 
    ## Bucket:              jpe-dev-bucket 
    ## ID:                  jpe-dev-bucket/adult-holding-redd-and-carcass-surveys/feather-river/data/feather_redd_2019.csv/1635355441538724 
    ## MD5 Hash:            n9S5p+UhdPardbGhDkj+5w== 
    ## Class:               STANDARD 
    ## Created:             2021-10-27 17:24:01 
    ## Updated:             2021-10-27 17:24:01 
    ## Generation:          1635355441538724 
    ## Meta Generation:     1 
    ## eTag:                CKTNsuGN6/MCEAE= 
    ## crc32c:              b/KoSQ==
