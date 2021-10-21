Battle Creek Redd Survey QC
================
Erin Cain
9/29/2021

# Battle Creek Redd Survey

## Description of Monitoring Data

These data were aquired via snorkel and kayak surveys on Battle Creek
from 2001 to 2019. Red location, size, substrate and flow were measured.
Annual monitoring questions and conditions drove the frequency and
detail of individual redd measurements.

**Timeframe:** 2001 - 2019

**Survey Season:**

**Completeness of Record throughout timeframe:** Sampled each year

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
```

Read in data from google cloud, glimpse raw data and domain description
sheet:

``` r
sheets <- excel_sheets("raw_adult_spawn_hold_carcass.xlsx")
sheets 
```

    ## [1] "Notes and Metadata"    "Redd Survey"           "Carcass"              
    ## [4] "Live Holding Spawning"

``` r
raw_redd_data <-read_excel("raw_adult_spawn_hold_carcass.xlsx", 
                           sheet = "Redd Survey",
                           col_types = c("text", "numeric", "numeric", "numeric", "date", 
                                         "text", "numeric", "text", "text", "text", "text", 
                                         "text", "text", "text", "date", "numeric", "numeric", 
                                         "numeric", "numeric", "numeric", "text", "numeric", "numeric",
                                         "date", "date", "numeric", "numeric", "numeric", "text")) %>% glimpse()
```

    ## Rows: 1,605
    ## Columns: 29
    ## $ Project     <chr> "Snorkel", "Snorkel", "Snorkel", "Snorkel", "Snorkel", "Sn~
    ## $ LONGITUDE   <dbl> -121.9688, -121.9742, -121.9742, -121.9688, -121.9688, -12~
    ## $ LATITUDE    <dbl> 40.40218, 40.40279, 40.40279, 40.40218, 40.40218, 40.41850~
    ## $ YEAR        <dbl> 2001, 2001, 2001, 2001, 2001, 2001, 2001, 2001, 2001, 2001~
    ## $ Sample_Date <dttm> 2001-09-18, 2001-10-03, 2001-10-03, 2001-10-03, 2001-10-0~
    ## $ REACH       <chr> "R3", "R3", "R3", "R3", "R3", "R1", "R1", "R1", "R1", "R2"~
    ## $ RIVER_MILE  <dbl> 2.48, 2.14, 2.14, 2.48, 2.48, 2.94, 2.91, 2.88, 2.85, 1.64~
    ## $ Species_Run <chr> "SCS", "SCS", "SCS", "SCS", "SCS", "SCS", "SCS", "SCS", "S~
    ## $ PRE_SUB     <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ SIDES_SUB   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ TAIL_SUB    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ FOR_        <chr> "UNK", "UNK", "UNK", "UNK", "UNK", "UNK", "UNK", "UNK", "U~
    ## $ MEASURE     <chr> "NO", "YES", "YES", "YES", "YES", "NO", "NO", "NO", "NO", ~
    ## $ WHY_NOT_ME  <chr> "UNK", "UNK", "UNK", "UNK", "UNK", "UNK", "UNK", "UNK", "U~
    ## $ DATE_MEASU  <dttm> NA, 2001-10-03, 2001-10-03, 2001-10-03, 2001-10-03, NA, N~
    ## $ PRE_DEPTH   <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 18, 16, NA, NA, NA, NA~
    ## $ PIT_DEPTH   <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 23, 21, NA, NA, NA, NA~
    ## $ TAIL_DEPTH  <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 11, 10, NA, NA, NA, NA~
    ## $ LENGTH_IN   <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 77, 166, NA, NA, NA, N~
    ## $ WIDTH_IN    <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 37, 129, NA, NA, NA, N~
    ## $ FLOW_METER  <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ FLOW_FPS    <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ START       <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ END_        <dttm> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ TIME_       <dttm> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ START_80    <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ END_80      <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ SECS_80_    <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ Comments    <chr> "wp 66", "wp 65; unable to associate measurements with ind~

## Data transformations

``` r
cleaner_redd_data <- raw_redd_data %>% 
  janitor::clean_names() %>% 
  rename("date" = sample_date,
         "fish_garding" = `for`, 
         "redd_measured" = measure, 
         "why_not_measured" = why_not_me,
         "date_measured" = date_measu, 
         "pre_redd_substrate_size" = pre_sub, 
         "redd_substrate_size" = sides_sub, 
         "tail_substrate_size" = tail_sub,
         "pre_redd_depth" = pre_depth, 
         "redd_pit_depth" = pit_depth, 
         "redd_tail_depth" = tail_depth,
         "redd_length_in" = length_in, 
         "redd_width_in" = width_in
         ) %>%
  mutate(date = as.Date(date)) %>%
  select(-project, -year, -date_measured, 
         -species_run) %>% #All are spring run 
  glimpse()
```

    ## Rows: 1,605
    ## Columns: 25
    ## $ longitude               <dbl> -121.9688, -121.9742, -121.9742, -121.9688, -1~
    ## $ latitude                <dbl> 40.40218, 40.40279, 40.40279, 40.40218, 40.402~
    ## $ date                    <date> 2001-09-18, 2001-10-03, 2001-10-03, 2001-10-0~
    ## $ reach                   <chr> "R3", "R3", "R3", "R3", "R3", "R1", "R1", "R1"~
    ## $ river_mile              <dbl> 2.48, 2.14, 2.14, 2.48, 2.48, 2.94, 2.91, 2.88~
    ## $ pre_redd_substrate_size <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ redd_substrate_size     <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ tail_substrate_size     <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ fish_garding            <chr> "UNK", "UNK", "UNK", "UNK", "UNK", "UNK", "UNK~
    ## $ redd_measured           <chr> "NO", "YES", "YES", "YES", "YES", "NO", "NO", ~
    ## $ why_not_measured        <chr> "UNK", "UNK", "UNK", "UNK", "UNK", "UNK", "UNK~
    ## $ pre_redd_depth          <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 18, 16, NA~
    ## $ redd_pit_depth          <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 23, 21, NA~
    ## $ redd_tail_depth         <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 11, 10, NA~
    ## $ redd_length_in          <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 77, 166, N~
    ## $ redd_width_in           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 37, 129, N~
    ## $ flow_meter              <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ flow_fps                <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ start                   <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ end                     <dttm> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ time                    <dttm> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ start_80                <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ end_80                  <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ secs_80                 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ comments                <chr> "wp 66", "wp 65; unable to associate measureme~

## Explore Numeric Variables:

``` r
cleaner_redd_data %>% select_if(is.numeric) %>% colnames()
```

    ##  [1] "longitude"       "latitude"        "river_mile"      "pre_redd_depth" 
    ##  [5] "redd_pit_depth"  "redd_tail_depth" "redd_length_in"  "redd_width_in"  
    ##  [9] "flow_fps"        "start"           "start_80"        "end_80"         
    ## [13] "secs_80"

``` r
unique(cleaner_redd_data$start_80)
```

    ## [1]     NA      0 492000 496000 351000

### Variable: `longitude`, `latitude`

``` r
summary(cleaner_redd_data$latitude)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   40.39   40.42   40.42   40.42   40.42   40.43

``` r
summary(cleaner_redd_data$longitude)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##  -122.2  -122.0  -122.0  -122.0  -122.0  -121.9

All values look within an expected range

**NA and Unknown Values**

-   0 % of values in the `latitude` column are NA.
-   0 % of values in the `longitude` column are NA.

### Variable: `river_mile`

**Plotting river mile over Period of Record**

``` r
cleaner_redd_data %>% 
  ggplot(aes(x = river_mile, y = year(date))) +
  geom_point(size = 1.4, alpha = .5, color = "blue") + 
  labs(x = "River Mile", 
       y = "Date") +
  theme_minimal() + 
  theme(text = element_text(size = 15)) 
```

![](battle_creek_redd_qc_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

It looks like river miles 0 - 4 and 11 - 12 most commonly have redds. In
most recent years almost all the redds are before mile 5.

``` r
cleaner_redd_data %>% 
  ggplot(aes(x = river_mile)) +
  geom_histogram(alpha = .75) + 
  labs(x = "River Mile") +
  theme_minimal() + 
  theme(text = element_text(size = 15)) 
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](battle_creek_redd_qc_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

**Numeric Summary of river mile over Period of Record**

``` r
summary(cleaner_redd_data$river_mile)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   0.000   1.390   2.270   5.054   7.410  16.790

**NA and Unknown Values**

-   0 % of values in the `river_mile` column are NA.

### Variable: `pre_redd_depth`

**Plotting distribution of pre redd depth**

``` r
cleaner_redd_data %>%
  ggplot(aes(x = pre_redd_depth)) +
  geom_histogram() +
  labs(x = "Redd Depth", 
       y = "Count") +
  theme_minimal() + 
  theme(text = element_text(size = 15)) 
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](battle_creek_redd_qc_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

**Numeric Summary of pre redd depth over Period of Record**

``` r
summary(cleaner_redd_data$pre_redd_depth)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00   11.00   15.00   15.14   20.00   50.00     999

**NA and Unknown Values**

-   62.2 % of values in the `pre_redd_depth` column are NA.
-   There are a lot of 0 values. Could these also be NA?

### Variable: \`redd\_pit\_depth\`\`

**Plotting distribution of redd pit depth**

``` r
cleaner_redd_data %>% 
  ggplot(aes(x = redd_pit_depth)) +
  geom_histogram() +
  labs(x = "River Pitt Depth", 
       y = "Count") +
  theme_minimal() + 
  theme(text = element_text(size = 15)) 
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](battle_creek_redd_qc_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->

**Numeric Summary of Redd pit depth over Period of Record**

``` r
summary(cleaner_redd_data$redd_pit_depth)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00   16.00   21.00   19.73   26.00   56.00    1001

**NA and Unknown Values**

-   62.4 % of values in the `redd_pit_depth` column are NA.
-   There are a lot of 0 values. Could these be NA?

### Variable: `redd_tail_depth`

**Plotting distribution of redd tail depth**

``` r
cleaner_redd_data %>% 
  ggplot(aes(x = redd_tail_depth)) +
  geom_histogram() +
  labs(x = "Redd tail depth", 
       y = "count") +
  theme_minimal() + 
  theme(text = element_text(size = 15)) 
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](battle_creek_redd_qc_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

**Numeric Summary of Redd tail depth over Period of Record**

``` r
summary(cleaner_redd_data$redd_tail_depth)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00    6.00    9.00    9.31   13.00   37.00    1002

**NA and Unknown Values**

-   62.4 % of values in the `redd_tail_depth` column are NA.
-   There are a lot of 0 values. Could these be NA?

### Variable: `redd_length_in`

**Plotting distribution of redd length inches**

``` r
cleaner_redd_data %>% 
  ggplot(aes(x = redd_length_in)) +
  geom_histogram() +
  labs(x = "Redd Length In", 
       y = "Cpunt") +
  theme_minimal() + 
  theme(text = element_text(size = 15)) 
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](battle_creek_redd_qc_files/figure-gfm/unnamed-chunk-15-1.png)<!-- -->

**Numeric Summary of Redd length inches over Period of Record**

``` r
summary(cleaner_redd_data$redd_length_in)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##     0.0    98.0   152.0   148.8   203.0   455.0     884

**NA and Unknown Values**

-   55.1 % of values in the `redd_length_in` column are NA.
-   There are a lot of 0 values. Could these be NA?

### Variable: \`redd\_width\_in\`\`

**Plotting distribution of redd width inches**

``` r
cleaner_redd_data %>% 
  ggplot(aes(x = redd_width_in)) +
  geom_histogram() +
  labs(x = "Redd Width In", 
       y = "Count") +
  theme_minimal() + 
  theme(text = element_text(size = 15)) 
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](battle_creek_redd_qc_files/figure-gfm/unnamed-chunk-17-1.png)<!-- -->

**Numeric Summary of Redd width inches over Period of Record**

``` r
summary(cleaner_redd_data$redd_width_in)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00   53.00   78.00   81.73  108.25  270.00     885

**NA and Unknown Values**

-   55.1 % of values in the `redd_width_in` column are NA.
-   There are a lot of 0 values. Could these be NA?

### Variable: `flow_fps`

**Plotting distribution of flow feet per second**

``` r
cleaner_redd_data %>% 
  ggplot(aes(x = flow_fps)) +
  geom_histogram() +
  labs(x = "Flow Feet per second", 
       y = "Count") +
  theme_minimal() + 
  theme(text = element_text(size = 15)) 
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](battle_creek_redd_qc_files/figure-gfm/unnamed-chunk-19-1.png)<!-- -->

``` r
cleaner_redd_data %>% 
  ggplot(aes(x = flow_fps, y = reach)) +
  geom_boxplot() +
  labs(x = "Flow Feet Per Second", 
       y = "Reach") +
  theme_minimal() + 
  theme(text = element_text(size = 15)) 
```

![](battle_creek_redd_qc_files/figure-gfm/unnamed-chunk-20-1.png)<!-- -->
**Numeric Summary of flow over Period of Record**

``` r
summary(cleaner_redd_data$flow_fps)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.000   0.978   1.501   1.479   1.986   5.240    1029

**NA and Unknown Values**

-   64.1 % of values in the `flow_fps` column are NA.
-   There are a lot of 0 values. Could these be NA?

TODO Add in start, end, time, start\_80, end\_80, time\_80, see if I can
fix format of them first

## Explore Categorical variables:

``` r
cleaner_redd_data %>% select_if(is.character) %>% colnames()
```

    ## [1] "reach"                   "pre_redd_substrate_size"
    ## [3] "redd_substrate_size"     "tail_substrate_size"    
    ## [5] "fish_garding"            "redd_measured"          
    ## [7] "why_not_measured"        "flow_meter"             
    ## [9] "comments"

### Variable: `reach`

``` r
table(cleaner_redd_data$reach) 
```

    ## 
    ##  R1  R2  R3  R4  R5  R6  R7 
    ## 325 597 256 280  81  49  17

**NA and Unknown Values**

-   0 % of values in the `reach`column are NA.

### Variable: `pre_redd_substrate_size`

``` r
table(cleaner_redd_data$pre_redd_substrate_size) 
```

    ## 
    ##  .1 to 1      <.1     <0.1      >12    0.1-1 0.1 to 1        1   1 to 2 
    ##       14        1        3        4        5      105       44      283 
    ##   1 to 3   1 to 5   2 to 3   2 to 4   3 to 4   3 to 5   4 to 5   4 to 6 
    ##      293        1       60      111       17       21        4        7

Fix inconsistencies with spelling, capitalization, and abbreviations.

``` r
cleaner_redd_data$pre_redd_substrate_size <- if_else(
  cleaner_redd_data$pre_redd_substrate_size == ".1 to 1" | 
  cleaner_redd_data$pre_redd_substrate_size == "0.1-1", "0.1 to 1", cleaner_redd_data$pre_redd_substrate_size
)

cleaner_redd_data$pre_redd_substrate_size <- if_else(
  cleaner_redd_data$pre_redd_substrate_size == "<.1", "<0.1", cleaner_redd_data$pre_redd_substrate_size
)
table(cleaner_redd_data$pre_redd_substrate_size) 
```

    ## 
    ##     <0.1      >12 0.1 to 1        1   1 to 2   1 to 3   1 to 5   2 to 3 
    ##        4        4      124       44      283      293        1       60 
    ##   2 to 4   3 to 4   3 to 5   4 to 5   4 to 6 
    ##      111       17       21        4        7

**NA and Unknown Values**

-   39.4 % of values in the `pre_redd_substrate_size` column are NA.

### Variable: `redd_substrate_size`

``` r
table(cleaner_redd_data$redd_substrate_size) 
```

    ## 
    ##  .1 to 1      <.1      >12    0.1-1 0.1 to 1        1   1 to 2   1 to 3 
    ##       10        1        9        1       69       36      291      322 
    ##   1 to 5   2 to 3   2 to 4   3 to 4   3 to 5   4 to 5   4 to 6       NA 
    ##        2       83      115       12       15        1        5        1

Fix inconsistencies with spelling, capitalization, and abbreviations.

``` r
cleaner_redd_data$redd_substrate_size <- if_else(
  cleaner_redd_data$redd_substrate_size == ".1 to 1" | 
  cleaner_redd_data$redd_substrate_size == "0.1-1", "0.1 to 1", cleaner_redd_data$redd_substrate_size
)

cleaner_redd_data$redd_substrate_size <- if_else(
  cleaner_redd_data$redd_substrate_size == "<.1", "<0.1", cleaner_redd_data$redd_substrate_size
)

cleaner_redd_data$redd_substrate_size <- ifelse(
  cleaner_redd_data$redd_substrate_size == "NA", NA, cleaner_redd_data$redd_substrate_size
)
table(cleaner_redd_data$redd_substrate_size) 
```

    ## 
    ##     <0.1      >12 0.1 to 1        1   1 to 2   1 to 3   1 to 5   2 to 3 
    ##        1        9       80       36      291      322        2       83 
    ##   2 to 4   3 to 4   3 to 5   4 to 5   4 to 6 
    ##      115       12       15        1        5

**NA and Unknown Values**

-   39.4 % of values in the `redd_substrate_size` column are NA.

### Variable: `tail_substrate_size`

``` r
table(cleaner_redd_data$tail_substrate_size) 
```

    ## 
    ##  .1 to 1    0.1-1 0.1 to 1        1   1 to 2   1 to 3   2 to 3   2 to 4 
    ##        2        2        4        3      344      431       82       94 
    ##   3 to 4   3 to 5       NA 
    ##        7        3        1

Fix inconsistencies with spelling, capitalization, and abbreviations.

``` r
cleaner_redd_data$tail_substrate_size <- if_else(
  cleaner_redd_data$tail_substrate_size == ".1 to 1" | 
  cleaner_redd_data$tail_substrate_size == "0.1-1", "0.1 to 1", cleaner_redd_data$tail_substrate_size
)


cleaner_redd_data$tail_substrate_size <- ifelse(
  cleaner_redd_data$tail_substrate_size == "NA", NA, cleaner_redd_data$tail_substrate_size
)
table(cleaner_redd_data$tail_substrate_size) 
```

    ## 
    ## 0.1 to 1        1   1 to 2   1 to 3   2 to 3   2 to 4   3 to 4   3 to 5 
    ##        8        3      344      431       82       94        7        3

**NA and Unknown Values**

-   39.4 % of values in the `tail_substrate_size` column are NA.

### Variable: `fish_garding`

``` r
table(cleaner_redd_data$fish_garding) 
```

    ## 
    ##  No  NO UNK Yes YES 
    ##  27 989 321   1 266

Fix inconsistencies with spelling, capitalization, and abbreviations.

``` r
cleaner_redd_data$fish_garding <- case_when(
  cleaner_redd_data$fish_garding == "No" | cleaner_redd_data$fish_garding == "NO" ~FALSE, 
  cleaner_redd_data$fish_garding == "Yes" | cleaner_redd_data$fish_garding == "YES" ~TRUE
)

table(cleaner_redd_data$fish_garding) 
```

    ## 
    ## FALSE  TRUE 
    ##  1016   267

**NA and Unknown Values**

-   20.1 % of values in the `fish_garding` column are NA.

### Variable: `redd_measured`

``` r
table(cleaner_redd_data$redd_measured) 
```

    ## 
    ##  NO YES 
    ## 944 661

Fix inconsistencies with spelling, capitalization, and abbreviations.

``` r
cleaner_redd_data$redd_measured <- case_when(
  cleaner_redd_data$redd_measured == "NO"  ~ FALSE, 
  cleaner_redd_data$redd_measured == "YES" ~ TRUE
)

table(cleaner_redd_data$redd_measured) 
```

    ## 
    ## FALSE  TRUE 
    ##   944   661

**NA and Unknown Values**

-   0 % of values in the `redd_measured` column are NA.

### Variable: `why_not_measured`

``` r
table(cleaner_redd_data$why_not_measured) 
```

    ## 
    ## Fish on redd FISH ON REDD   Sub-Sample   SUB-SAMPLE     Too Deep          UNK 
    ##            5            3           80           54            1         1391

Fix inconsistencies with spelling, capitalization, and abbreviations.

``` r
cleaner_redd_data$why_not_measured <- case_when(
  cleaner_redd_data$why_not_measured == "Fish on redd" | 
    cleaner_redd_data$why_not_measured == "FISH ON REDD"  ~ "fish on redd", 
  cleaner_redd_data$why_not_measured == "Sub-Sample" | 
    cleaner_redd_data$why_not_measured == "SUB-SAMPLE"  ~ "sub sample", 
  cleaner_redd_data$why_not_measured == "Too Deep" ~ "too deep", 
)

table(cleaner_redd_data$why_not_measured) 
```

    ## 
    ## fish on redd   sub sample     too deep 
    ##            8          134            1

**NA and Unknown Values**

-   91.1 % of values in the `why_not_measured` column are NA.

### Variable: `flow_meter`

``` r
table(cleaner_redd_data$flow_meter) 
```

    ## 
    ##    Digital  flow bomb  Flow bomb  Flow Bomb Flow Watch      Marsh        Unk 
    ##         17         35          1        515          4          2          2 
    ##        UNK 
    ##          3

Fix inconsistencies with spelling, capitalization, and abbreviations.

``` r
cleaner_redd_data$flow_meter <- case_when(
  cleaner_redd_data$flow_meter %in% c("flow bomb", "Flow Bomb", "Flow bomb")  ~ "flow bomb", 
  cleaner_redd_data$flow_meter == "Digital" ~ "digital",
  cleaner_redd_data$flow_meter == "Flow Watch"  ~ "flow watch", 
  cleaner_redd_data$flow_meter == "Marsh" ~ "marsh", 
)

table(cleaner_redd_data$flow_meter) 
```

    ## 
    ##    digital  flow bomb flow watch      marsh 
    ##         17        551          4          2

**NA and Unknown Values**

-   64.2 % of values in the `flow_meter` column are NA.

### Variable: `comments`

``` r
unique(cleaner_redd_data$comments)[1:10]
```

    ##  [1] "wp 66"                                                       
    ##  [2] "wp 65; unable to associate measurements with individual redd"
    ##  [3] "wp 66; unable to associate measurements with individual redd"
    ##  [4] "wp 11"                                                       
    ##  [5] "wp 12"                                                       
    ##  [6] "wp 13"                                                       
    ##  [7] "wp 14"                                                       
    ##  [8] "wp 17; pebble count #4"                                      
    ##  [9] "wp 18; pebble count #4"                                      
    ## [10] "wp 19; unable to associate measurements with individual redd"

**NA and Unknown Values**

-   43.6 % of values in the `comments` column are NA.

## Summary of identified issues

-   there are a lot of zero values for the physical characteristics of
    redds, I need to figure out if these are not measured values or are
    actually zero

## Save cleaned data back to google cloud

``` r
battle_redd <- cleaner_redd_data %>% glimpse
```

    ## Rows: 1,605
    ## Columns: 25
    ## $ longitude               <dbl> -121.9688, -121.9742, -121.9742, -121.9688, -1~
    ## $ latitude                <dbl> 40.40218, 40.40279, 40.40279, 40.40218, 40.402~
    ## $ date                    <date> 2001-09-18, 2001-10-03, 2001-10-03, 2001-10-0~
    ## $ reach                   <chr> "R3", "R3", "R3", "R3", "R3", "R1", "R1", "R1"~
    ## $ river_mile              <dbl> 2.48, 2.14, 2.14, 2.48, 2.48, 2.94, 2.91, 2.88~
    ## $ pre_redd_substrate_size <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ redd_substrate_size     <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ tail_substrate_size     <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ fish_garding            <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ redd_measured           <lgl> FALSE, TRUE, TRUE, TRUE, TRUE, FALSE, FALSE, F~
    ## $ why_not_measured        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ pre_redd_depth          <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 18, 16, NA~
    ## $ redd_pit_depth          <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 23, 21, NA~
    ## $ redd_tail_depth         <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 11, 10, NA~
    ## $ redd_length_in          <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 77, 166, N~
    ## $ redd_width_in           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, 37, 129, N~
    ## $ flow_meter              <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ flow_fps                <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ start                   <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ end                     <dttm> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ time                    <dttm> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ start_80                <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ end_80                  <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ secs_80                 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ comments                <chr> "wp 66", "wp 65; unable to associate measureme~

``` r
gcs_list_objects()
```

    ##                                                                                                                    name
    ## 1                                                                               adult-holding-redd-and-carcass-surveys/
    ## 2                                                                  adult-holding-redd-and-carcass-surveys/battle-creek/
    ## 3                                                         adult-holding-redd-and-carcass-surveys/battle-creek/data-raw/
    ## 4               adult-holding-redd-and-carcass-surveys/battle-creek/data-raw/battle_creek_adult_spawn_hold_carcass.xlsx
    ## 5                                                             adult-holding-redd-and-carcass-surveys/battle-creek/data/
    ## 6                                                                 adult-holding-redd-and-carcass-surveys/feather-river/
    ## 7      adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2009_Chinook_Redd_Survey_Data_raw.xlsx
    ## 8          adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2010_Chinook_Redd_Survey_Data.xlsx
    ## 9          adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2011_Chinook_Redd_Survey_Data.xlsx
    ## 10     adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2012_Chinook_Redd_Survey_Data_raw.xlsx
    ## 11     adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2013_Chinook_Redd_Survey_Data_raw.xlsx
    ## 12          adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2014_Chinook_Redd_Survey_raw.xlsx
    ## 13     adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2015_Chinook_Redd_Survey_Data_raw.xlsx
    ## 14     adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2016_Chinook_Redd_Survey_Data_raw.xlsx
    ## 15     adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2017_Chinook_Redd_Survey_Data_raw.xlsx
    ## 16     adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2018_Chinook_Redd_Survey_Data_raw.xlsx
    ## 17     adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2019_Chinook_Redd_Survey_Data_raw.xlsx
    ## 18     adult-holding-redd-and-carcass-surveys/feather-river/data-raw/redd_survey/2020_Chinook_Redd_Survey_Data_raw.xlsx
    ## 19                                                           adult-holding-redd-and-carcass-surveys/feather-river/data/
    ## 20                                      adult-holding-redd-and-carcass-surveys/feather-river/data/feather_redd_2009.csv
    ## 21                                      adult-holding-redd-and-carcass-surveys/feather-river/data/feather_redd_2010.csv
    ## 22                                      adult-holding-redd-and-carcass-surveys/feather-river/data/feather_redd_2011.csv
    ## 23                                      adult-holding-redd-and-carcass-surveys/feather-river/data/feather_redd_2012.csv
    ## 24                                      adult-holding-redd-and-carcass-surveys/feather-river/data/feather_redd_2013.csv
    ## 25                                                                                   adult-upstream-passage-monitoring/
    ## 26                                                                      adult-upstream-passage-monitoring/battle-creek/
    ## 27                                                             adult-upstream-passage-monitoring/battle-creek/data-raw/
    ## 28                     adult-upstream-passage-monitoring/battle-creek/data-raw/battle_creek_upstream_passage_datas.xlsx
    ## 29                                                                 adult-upstream-passage-monitoring/battle-creek/data/
    ## 30                                     adult-upstream-passage-monitoring/battle-creek/data/battle_passage_estimates.csv
    ## 31                                          adult-upstream-passage-monitoring/battle-creek/data/battle_passage_trap.csv
    ## 32                                         adult-upstream-passage-monitoring/battle-creek/data/battle_passage_video.csv
    ## 33                                                                       adult-upstream-passage-monitoring/clear-creek/
    ## 34                                                              adult-upstream-passage-monitoring/clear-creek/data-raw/
    ## 35                      adult-upstream-passage-monitoring/clear-creek/data-raw/2019-20 CCVS Video Reading Protocol.docx
    ## 36           adult-upstream-passage-monitoring/clear-creek/data-raw/ClearCreekVideoWeir_AdultRecruitment_2013-2020.xlsx
    ## 37                                                                  adult-upstream-passage-monitoring/clear-creek/data/
    ## 38                                                 adult-upstream-passage-monitoring/clear-creek/data/clear_passage.csv
    ## 39                                                                     adult-upstream-passage-monitoring/feather-river/
    ## 40                                                                 adult-upstream-passage-monitoring/feather-river/CWT/
    ## 41                                                        adult-upstream-passage-monitoring/feather-river/CWT/data-raw/
    ## 42                          adult-upstream-passage-monitoring/feather-river/CWT/data-raw/2021-09-14_FRFH_tblOutput.xlsx
    ## 43                          adult-upstream-passage-monitoring/feather-river/CWT/data-raw/2021-09-15_FRFH_tblOutput.xlsx
    ## 44                          adult-upstream-passage-monitoring/feather-river/CWT/data-raw/2021-09-17_FRFH_tblOutput.xlsx
    ## 45                          adult-upstream-passage-monitoring/feather-river/CWT/data-raw/2021-09-20_FRFH_tblOutput.xlsx
    ## 46                          adult-upstream-passage-monitoring/feather-river/CWT/data-raw/2021-09-21_FRFH_tblOutput.xlsx
    ## 47                          adult-upstream-passage-monitoring/feather-river/CWT/data-raw/2021-09-22_FRFH_tblOutput.xlsx
    ## 48                          adult-upstream-passage-monitoring/feather-river/CWT/data-raw/2021_FRFH_SR-HP_tblOutput.xlsx
    ## 49                                                           adult-upstream-passage-monitoring/feather-river/hallprint/
    ## 50                                                  adult-upstream-passage-monitoring/feather-river/hallprint/data-raw/
    ## 51                     adult-upstream-passage-monitoring/feather-river/hallprint/data-raw/all_hallprints_all_years.xlsx
    ## 52                                          adult-upstream-passage-monitoring/feather-river/hallprint/data-raw/returns/
    ## 53  adult-upstream-passage-monitoring/feather-river/hallprint/data-raw/returns/FRFH HP RUN DATA 2018 as of 9-10-20.xlsx
    ## 54                                                      adult-upstream-passage-monitoring/feather-river/hallprint/data/
    ## 55                                                                                         juvenile-rearing-monitoring/
    ## 56                                                                  juvenile-rearing-monitoring/seine-and-snorkel-data/
    ## 57                                                    juvenile-rearing-monitoring/seine-and-snorkel-data/feather-river/
    ## 58                                           juvenile-rearing-monitoring/seine-and-snorkel-data/feather-river/data-raw/
    ## 59            juvenile-rearing-monitoring/seine-and-snorkel-data/feather-river/data-raw/all_fields_seine_2008-2014.xlsx
    ## 60            juvenile-rearing-monitoring/seine-and-snorkel-data/feather-river/data-raw/all_fields_seine_2014-2021.xlsx
    ## 61                   juvenile-rearing-monitoring/seine-and-snorkel-data/feather-river/data-raw/all_seine_1997-2001.xlsx
    ## 62                                               juvenile-rearing-monitoring/seine-and-snorkel-data/feather-river/data/
    ## 63                                                                                                                 rst/
    ## 64                                                                                                     rst/butte-creek/
    ## 65                                                                                            rst/butte-creek/data-raw/
    ## 66                                                          rst/butte-creek/data-raw/CDFW_Butte_Creek_RST_Captures.xlsx
    ## 67                                                                                                rst/butte-creek/data/
    ## 68                                                                                                   rst/feather-river/
    ## 69                                                                                          rst/feather-river/data-raw/
    ## 70                                 rst/feather-river/data-raw/Feather River RST CalendarReport_TrapVisits_1998-2021.pdf
    ## 71                        rst/feather-river/data-raw/Feather River RST Natural Origin Chinook Catch Data_1998-2021.xlsx
    ## 72                                          rst/feather-river/data-raw/Feather River RST Sampling Effort_1998-2021.xlsx
    ## 73                                                 rst/feather-river/data-raw/Rotary Screw Trap Survey Information.docx
    ## 74                                                                                              rst/feather-river/data/
    ## 75                                                                               rst/feather-river/data/feather_rst.csv
    ## 76                                                                        rst/feather-river/data/feather_rst_effort.csv
    ## 77                                                                                                 rst/lower-sac-river/
    ## 78                                                                                        rst/lower-sac-river/data-raw/
    ## 79                                                                        rst/lower-sac-river/data-raw/knights-landing/
    ## 80                                            rst/lower-sac-river/data-raw/knights-landing/knights_landing_RST_2003.xls
    ## 81                                            rst/lower-sac-river/data-raw/knights-landing/knights_landing_RST_2004.xls
    ## 82                                           rst/lower-sac-river/data-raw/knights-landing/knights_landing_RST_2005.xlsx
    ## 83                                            rst/lower-sac-river/data-raw/knights-landing/knights_landing_RST_2006.xls
    ## 84                                           rst/lower-sac-river/data-raw/knights-landing/knights_landing_RST_2007.xlsx
    ## 85                                            rst/lower-sac-river/data-raw/knights-landing/knights_landing_RST_2008.xls
    ## 86                                            rst/lower-sac-river/data-raw/knights-landing/knights_landing_RST_2009.xls
    ## 87                                            rst/lower-sac-river/data-raw/knights-landing/knights_landing_RST_2010.xls
    ## 88                                            rst/lower-sac-river/data-raw/knights-landing/knights_landing_RST_2011.xls
    ## 89                                            rst/lower-sac-river/data-raw/knights-landing/knights_landing_RST_2012.xls
    ## 90                                            rst/lower-sac-river/data-raw/knights-landing/knights_landing_RST_2013.xls
    ## 91                                           rst/lower-sac-river/data-raw/knights-landing/knights_landing_RST_2014.xlsx
    ## 92                                           rst/lower-sac-river/data-raw/knights-landing/knights_landing_RST_2015.xlsx
    ## 93                                           rst/lower-sac-river/data-raw/knights-landing/knights_landing_RST_2016.xlsx
    ## 94                                            rst/lower-sac-river/data-raw/knights-landing/knights_landing_RST_2019.csv
    ## 95                                            rst/lower-sac-river/data-raw/knights-landing/knights_landing_RST_2020.csv
    ## 96                                            rst/lower-sac-river/data-raw/knights-landing/knights_landing_RST_2021.csv
    ## 97                                                                                            rst/lower-sac-river/data/
    ## 98                                                                            rst/lower-sac-river/data/knights-landing/
    ## 99                                                         rst/lower-sac-river/data/knights-landing/knl_combine_rst.csv
    ## 100                                            rst/lower-sac-river/data/knights-landing/knl_combine_sampling_effort.csv
    ## 101                                                           rst/lower-sac-river/data/knights-landing/knl_rst_2003.csv
    ## 102                                                           rst/lower-sac-river/data/knights-landing/knl_rst_2004.csv
    ## 103                                                           rst/lower-sac-river/data/knights-landing/knl_rst_2005.csv
    ## 104                                                           rst/lower-sac-river/data/knights-landing/knl_rst_2006.csv
    ## 105                                                           rst/lower-sac-river/data/knights-landing/knl_rst_2007.csv
    ## 106                                                           rst/lower-sac-river/data/knights-landing/knl_rst_2008.csv
    ## 107                                                           rst/lower-sac-river/data/knights-landing/knl_rst_2009.csv
    ## 108                                                           rst/lower-sac-river/data/knights-landing/knl_rst_2010.csv
    ## 109                                                           rst/lower-sac-river/data/knights-landing/knl_rst_2011.csv
    ## 110                                                           rst/lower-sac-river/data/knights-landing/knl_rst_2012.csv
    ## 111                                                           rst/lower-sac-river/data/knights-landing/knl_rst_2013.csv
    ## 112                                                           rst/lower-sac-river/data/knights-landing/knl_rst_2014.csv
    ## 113                                                           rst/lower-sac-river/data/knights-landing/knl_rst_2015.csv
    ## 114                                                           rst/lower-sac-river/data/knights-landing/knl_rst_2016.csv
    ## 115                                                           rst/lower-sac-river/data/knights-landing/knl_rst_2019.csv
    ## 116                                                           rst/lower-sac-river/data/knights-landing/knl_rst_2020.csv
    ## 117                                                           rst/lower-sac-river/data/knights-landing/knl_rst_2021.csv
    ## 118                                                                                                     rst/yuba-river/
    ## 119                                                                                            rst/yuba-river/data-raw/
    ## 120                                               rst/yuba-river/data-raw/Draft CAMP screw trap database dictionary.doc
    ## 121                                               rst/yuba-river/data-raw/Rotary Screw Traps Report 2007-2008 (PDF).pdf
    ## 122                                                                    rst/yuba-river/data-raw/yuba-river-rst-data.xlsx
    ## 123                                                                                                rst/yuba-river/data/
    ## 124                                                                                                           survival/
    ##         size             updated
    ## 1    0 bytes 2021-09-27 22:15:47
    ## 2    0 bytes 2021-10-15 21:32:10
    ## 3    0 bytes 2021-10-15 21:32:17
    ## 4   656.3 Kb 2021-10-15 21:32:40
    ## 5    0 bytes 2021-10-15 21:32:22
    ## 6    0 bytes 2021-10-04 21:28:40
    ## 7    67.9 Kb 2021-10-04 21:32:53
    ## 8    55.3 Kb 2021-10-04 21:32:53
    ## 9    57.9 Kb 2021-10-04 21:32:53
    ## 10  134.9 Kb 2021-10-04 21:32:54
    ## 11     56 Kb 2021-10-04 21:32:54
    ## 12  185.8 Kb 2021-10-04 21:32:54
    ## 13  232.9 Kb 2021-10-04 21:32:54
    ## 14  107.5 Kb 2021-10-04 21:32:54
    ## 15  257.9 Kb 2021-10-04 21:32:54
    ## 16  209.3 Kb 2021-10-04 21:32:55
    ## 17    271 Kb 2021-10-04 21:32:55
    ## 18    403 Kb 2021-10-04 21:32:55
    ## 19   0 bytes 2021-10-04 21:33:16
    ## 20   19.8 Kb 2021-10-19 20:58:13
    ## 21   67.1 Kb 2021-10-19 21:28:44
    ## 22   97.2 Kb 2021-10-19 22:04:06
    ## 23  129.8 Kb 2021-10-20 23:33:09
    ## 24   69.4 Kb 2021-10-21 00:25:54
    ## 25   0 bytes 2021-09-27 18:49:42
    ## 26   0 bytes 2021-10-15 21:33:08
    ## 27   0 bytes 2021-10-15 21:33:16
    ## 28  605.1 Kb 2021-10-15 21:33:33
    ## 29   0 bytes 2021-10-15 21:33:21
    ## 30   71.9 Kb 2021-10-21 15:38:06
    ## 31  324.3 Kb 2021-10-21 15:28:30
    ## 32  380.3 Kb 2021-10-21 15:25:08
    ## 33   0 bytes 2021-09-28 16:18:09
    ## 34   0 bytes 2021-09-30 16:38:52
    ## 35     41 Kb 2021-09-30 16:39:14
    ## 36    3.7 Mb 2021-09-30 16:39:24
    ## 37   0 bytes 2021-09-30 16:38:59
    ## 38  708.8 Kb 2021-10-21 16:00:17
    ## 39   0 bytes 2021-09-28 16:20:07
    ## 40   0 bytes 2021-10-01 20:40:34
    ## 41   0 bytes 2021-10-01 20:40:52
    ## 42   12.7 Kb 2021-10-01 20:48:46
    ## 43   21.9 Kb 2021-10-01 20:48:31
    ## 44     23 Kb 2021-10-01 20:48:16
    ## 45   13.5 Kb 2021-10-01 20:47:59
    ## 46   23.2 Kb 2021-10-01 20:47:44
    ## 47   16.5 Kb 2021-10-01 20:47:28
    ## 48     13 Kb 2021-10-01 20:47:16
    ## 49   0 bytes 2021-10-01 20:40:28
    ## 50   0 bytes 2021-10-01 20:40:41
    ## 51    3.1 Mb 2021-10-01 21:16:01
    ## 52   0 bytes 2021-10-01 21:09:50
    ## 53  292.8 Kb 2021-10-01 21:10:44
    ## 54   0 bytes 2021-10-01 21:04:10
    ## 55   0 bytes 2021-10-13 18:44:53
    ## 56   0 bytes 2021-10-13 18:45:09
    ## 57   0 bytes 2021-10-13 18:46:34
    ## 58   0 bytes 2021-10-13 18:48:34
    ## 59  650.6 Kb 2021-10-13 19:57:29
    ## 60    2.1 Mb 2021-10-13 19:57:30
    ## 61  126.6 Kb 2021-10-13 21:03:30
    ## 62   0 bytes 2021-10-13 18:48:37
    ## 63   0 bytes 2021-09-27 22:16:03
    ## 64   0 bytes 2021-10-19 22:14:42
    ## 65   0 bytes 2021-10-19 22:15:57
    ## 66    6.9 Mb 2021-10-19 22:16:07
    ## 67   0 bytes 2021-10-19 22:15:50
    ## 68   0 bytes 2021-10-05 19:47:35
    ## 69   0 bytes 2021-10-05 19:47:45
    ## 70  570.3 Kb 2021-10-05 19:48:01
    ## 71    5.9 Mb 2021-10-05 19:48:11
    ## 72  394.8 Kb 2021-10-06 18:38:16
    ## 73   15.8 Mb 2021-10-05 19:48:54
    ## 74   0 bytes 2021-10-05 19:47:49
    ## 75    7.2 Mb 2021-10-13 16:56:01
    ## 76    1.3 Mb 2021-10-13 16:51:58
    ## 77   0 bytes 2021-10-05 20:45:20
    ## 78   0 bytes 2021-10-05 20:46:05
    ## 79   0 bytes 2021-10-05 20:48:32
    ## 80     68 Kb 2021-10-08 17:31:14
    ## 81   79.5 Kb 2021-10-08 17:31:14
    ## 82   27.3 Kb 2021-10-08 17:31:14
    ## 83   87.5 Kb 2021-10-08 17:31:14
    ## 84   37.3 Kb 2021-10-08 17:31:13
    ## 85     77 Kb 2021-10-08 17:31:13
    ## 86     72 Kb 2021-10-08 17:31:13
    ## 87     71 Kb 2021-10-08 17:31:13
    ## 88     77 Kb 2021-10-08 17:31:12
    ## 89    275 Kb 2021-10-08 17:31:13
    ## 90  245.5 Kb 2021-10-08 17:31:12
    ## 91  103.9 Kb 2021-10-08 17:31:12
    ## 92   61.8 Kb 2021-10-08 17:31:12
    ## 93   69.4 Kb 2021-10-08 17:31:11
    ## 94   38.7 Kb 2021-10-08 17:35:30
    ## 95   36.6 Kb 2021-10-08 17:35:30
    ## 96   34.4 Kb 2021-10-08 17:35:30
    ## 97   0 bytes 2021-10-05 20:46:13
    ## 98   0 bytes 2021-10-15 22:28:10
    ## 99    2.9 Mb 2021-10-19 15:37:42
    ## 100 710.2 Kb 2021-10-19 15:37:39
    ## 101  21.1 Kb 2021-10-15 23:23:32
    ## 102  24.4 Kb 2021-10-18 15:05:09
    ## 103  13.5 Kb 2021-10-18 15:13:56
    ## 104  26.4 Kb 2021-10-18 15:15:47
    ## 105  20.7 Kb 2021-10-18 15:16:04
    ## 106  18.3 Kb 2021-10-18 15:16:20
    ## 107  17.1 Kb 2021-10-18 15:16:31
    ## 108  17.3 Kb 2021-10-18 15:16:43
    ## 109  19.1 Kb 2021-10-18 15:16:55
    ## 110  23.7 Kb 2021-10-18 15:17:10
    ## 111   7.2 Kb 2021-10-18 15:17:22
    ## 112  76.6 Kb 2021-10-18 15:17:36
    ## 113  51.9 Kb 2021-10-18 15:17:47
    ## 114  56.8 Kb 2021-10-18 16:04:19
    ## 115  51.4 Kb 2021-10-18 15:18:25
    ## 116  48.5 Kb 2021-10-18 15:18:43
    ## 117  46.2 Kb 2021-10-18 15:18:57
    ## 118  0 bytes 2021-09-28 16:22:29
    ## 119  0 bytes 2021-09-30 16:40:06
    ## 120   8.7 Mb 2021-09-30 16:40:21
    ## 121 646.7 Kb 2021-09-30 16:40:34
    ## 122  19.6 Mb 2021-10-13 22:14:48
    ## 123  0 bytes 2021-09-30 16:40:11
    ## 124  0 bytes 2021-09-27 22:16:18

``` r
f <- function(input, output) write_csv(input, file = output)

gcs_upload(battle_redd,
           object_function = f,
           type = "csv",
           name = "adult-holding-redd-and-carcass-surveys/battle-creek/data/battle_redd.csv")
```

    ## i 2021-10-21 09:45:35 > File size detected as  223.2 Kb

    ## i 2021-10-21 09:45:36 > Request Status Code:  400

    ## ! API returned: Cannot insert legacy ACL for an object when uniform bucket-level access is enabled. Read more at https://cloud.google.com/storage/docs/uniform-bucket-level-access - Retrying with predefinedAcl='bucketLevel'

    ## i 2021-10-21 09:45:36 > File size detected as  223.2 Kb

    ## ==Google Cloud Storage Object==
    ## Name:                adult-holding-redd-and-carcass-surveys/battle-creek/data/battle_redd.csv 
    ## Type:                csv 
    ## Size:                223.2 Kb 
    ## Media URL:           https://www.googleapis.com/download/storage/v1/b/jpe-dev-bucket/o/adult-holding-redd-and-carcass-surveys%2Fbattle-creek%2Fdata%2Fbattle_redd.csv?generation=1634834737296859&alt=media 
    ## Download URL:        https://storage.cloud.google.com/jpe-dev-bucket/adult-holding-redd-and-carcass-surveys%2Fbattle-creek%2Fdata%2Fbattle_redd.csv 
    ## Public Download URL: https://storage.googleapis.com/jpe-dev-bucket/adult-holding-redd-and-carcass-surveys%2Fbattle-creek%2Fdata%2Fbattle_redd.csv 
    ## Bucket:              jpe-dev-bucket 
    ## ID:                  jpe-dev-bucket/adult-holding-redd-and-carcass-surveys/battle-creek/data/battle_redd.csv/1634834737296859 
    ## MD5 Hash:            uWbCcDbVL5nwE3AAcAZYXA== 
    ## Class:               STANDARD 
    ## Created:             2021-10-21 16:45:37 
    ## Updated:             2021-10-21 16:45:37 
    ## Generation:          1634834737296859 
    ## Meta Generation:     1 
    ## eTag:                CNvrof752/MCEAE= 
    ## crc32c:              9xtTag==
