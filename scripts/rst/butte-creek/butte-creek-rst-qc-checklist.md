butte-creek-rst-qc-checklist
================
Inigo Peng
10/19/2021

# Butte Creek RST Data

**Description of Monitoring Data**

This dataset contains data for all Chinook salmon that were captured in
the Butte Creek rotary screw trap (RSTR) or diversion fyke trap (DSTR)
between the 1995-96 and 2014-15 trapping seasons.

**Timeframe:**

1995 - 2015

**Completeness of Record throughout timeframe:**

-   Life stage information lacks after 2005
-   Inconsistent completeness of physical data after 2008

**Sampling Location:**

3 locations on Butte Creek

**Data Contact:** [Jessica
Nichols](mailto:Jessica.Nichols@Wildlife.ca.gov)

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
gcs_get_object(object_name = "rst/butte-creek/data-raw/CDFW_Butte_Creek_RST_Captures.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "butte_creek_rst_raw.xlsx",
               Overwrite = TRUE)
```

``` r
raw_data = readxl::read_excel('butte_creek_rst_raw.xlsx',
                              col_types = c("date","text","text","text","text","text","numeric","numeric","numeric","text",
                                            "text","date","text","text","numeric","numeric","numeric","numeric","text","text",
                                            "numeric","numeric","text","numeric","numeric","text"
                                            ))
glimpse(raw_data)
```

    ## Rows: 63,418
    ## Columns: 26
    ## $ SampleDate       <dttm> 1995-11-29, 1995-11-29, 1995-11-29, 1995-11-29, 1995~
    ## $ StationCode      <chr> "BCOKIE-1", "BCOKIE-1", "BCOKIE-1", "BCOKIE-1", "BCOK~
    ## $ MethodCode       <chr> "DSTR", "DSTR", "DSTR", "DSTR", "DSTR", "DSTR", "DSTR~
    ## $ TrapStatus       <chr> "Check", "Check", "Check", "Check", "Check", "Check",~
    ## $ OrganismCode     <chr> "CHN", "CHN", "CHN", "CHN", "CHN", "CHN", "CHN", "CHN~
    ## $ Dead             <chr> "No", "No", "No", "Yes", "Yes", "Yes", "Yes", "Yes", ~
    ## $ Count            <dbl> 1, 2, 1, 8, 1, 5, 4, 1, 1, 1, 3, 3, 5, 3, 4, 1, 2, 1,~
    ## $ ForkLength       <dbl> 38, 37, 39, 35, 33, 34, 36, 37, 36, 34, 33, 34, 35, 3~
    ## $ Weight           <dbl> 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00,~
    ## $ MarkCode         <chr> "n/p", "n/p", "n/p", "n/p", "n/p", "n/p", "n/p", "n/p~
    ## $ StageCode        <chr> "n/p", "n/p", "n/p", "n/p", "n/p", "n/p", "n/p", "n/p~
    ## $ SampleTime       <dttm> 1899-12-31 09:30:00, 1899-12-31 09:30:00, 1899-12-31~
    ## $ GearID           <chr> "DSTR1", "DSTR1", "DSTR1", "DSTR1", "DSTR1", "DSTR1",~
    ## $ WeatherCode      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, "CLD", "CLD",~
    ## $ WaterTemperature <dbl> 8.333333, 8.333333, 8.333333, 8.333333, 8.333333, 8.3~
    ## $ Turbidity        <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ Secchi           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ WaterVelocity    <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ NorthBrush       <chr> "FALSE", "FALSE", "FALSE", "FALSE", "FALSE", "FALSE",~
    ## $ SouthBrush       <chr> "FALSE", "FALSE", "FALSE", "FALSE", "FALSE", "FALSE",~
    ## $ StaffGauge       <dbl> 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, NA, NA, NA, N~
    ## $ TrapRevolutions  <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ Debris           <chr> "Medium", "Medium", "Medium", "Medium", "Medium", "Me~
    ## $ RPMsStart        <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ RPMsEnd          <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ Comments         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~

## Data Transformations

``` r
cleaner_data <- raw_data %>% 
  set_names(tolower(colnames(raw_data))) %>%
  select(-c('dead','weathercode','markcode', 'southbrush', 'northbrush', 'secchi','comments')) %>% 
  rename('date'= sampledate,
         'station' = stationcode,
         'method'= methodcode,
         'trap_status' = trapstatus,
         'species'= organismcode,
         'fork_length' = forklength,
         'lifestage' = stagecode,
         'time' = sampletime,
         'gear_id' = gearid,
         'temperature' = watertemperature,
         'velocity' = watervelocity,
         'staff_gauge' = staffgauge,
         'trap_revolutions' = traprevolutions,
         'rpms_start' = rpmsstart,
         'rpms_end'= rpmsend) %>% 
  mutate(time = hms::as_hms(time)) %>%
  filter(species =='CHN', rm.na = TRUE) %>%
  glimpse()
```

    ## Rows: 63,418
    ## Columns: 19
    ## $ date             <dttm> 1995-11-29, 1995-11-29, 1995-11-29, 1995-11-29, 1995~
    ## $ station          <chr> "BCOKIE-1", "BCOKIE-1", "BCOKIE-1", "BCOKIE-1", "BCOK~
    ## $ method           <chr> "DSTR", "DSTR", "DSTR", "DSTR", "DSTR", "DSTR", "DSTR~
    ## $ trap_status      <chr> "Check", "Check", "Check", "Check", "Check", "Check",~
    ## $ species          <chr> "CHN", "CHN", "CHN", "CHN", "CHN", "CHN", "CHN", "CHN~
    ## $ count            <dbl> 1, 2, 1, 8, 1, 5, 4, 1, 1, 1, 3, 3, 5, 3, 4, 1, 2, 1,~
    ## $ fork_length      <dbl> 38, 37, 39, 35, 33, 34, 36, 37, 36, 34, 33, 34, 35, 3~
    ## $ weight           <dbl> 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00,~
    ## $ lifestage        <chr> "n/p", "n/p", "n/p", "n/p", "n/p", "n/p", "n/p", "n/p~
    ## $ time             <time> 09:30:00, 09:30:00, 09:30:00, 09:30:00, 09:30:00, 09~
    ## $ gear_id          <chr> "DSTR1", "DSTR1", "DSTR1", "DSTR1", "DSTR1", "DSTR1",~
    ## $ temperature      <dbl> 8.333333, 8.333333, 8.333333, 8.333333, 8.333333, 8.3~
    ## $ turbidity        <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ velocity         <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ staff_gauge      <dbl> 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, NA, NA, NA, N~
    ## $ trap_revolutions <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ debris           <chr> "Medium", "Medium", "Medium", "Medium", "Medium", "Me~
    ## $ rpms_start       <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ rpms_end         <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~

## Explore `date`

``` r
cleaner_data %>%
  ggplot(aes(x = date)) +
  geom_histogram(position = 'stack', color = "black") +
  labs(title = "Value Counts For Survey Season Dates")+
  theme(legend.text = element_text(size = 8))
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](butte-creek-rst-qc-checklist_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

``` r
summary(cleaner_data$date)
```

    ##                  Min.               1st Qu.                Median 
    ## "1995-11-29 00:00:00" "2000-05-11 00:00:00" "2003-05-08 00:00:00" 
    ##                  Mean               3rd Qu.                  Max. 
    ## "2004-06-15 02:18:49" "2007-02-05 00:00:00" "2015-06-03 00:00:00"

**NA and Unknown Values**

-   0 % of values in the `date` column are NA.

## Explore Categorical Variables

``` r
cleaner_data %>% select_if(is.character) %>% colnames()
```

    ## [1] "station"     "method"      "trap_status" "species"     "lifestage"  
    ## [6] "gear_id"     "debris"

### Variable `station`

**Description:** trap location

-   BCADAMS - Adams Dam

-   BCOKIE-1 - Okie Dam 1

-   BCOKIE-2 - Okie Dam 2

``` r
cleaner_data <- cleaner_data %>% 
  mutate(station = case_when(
    station == 'BCADAMS' ~ 'Adams Dam',
    station == 'BCOKIE-1'~ 'Okie Dam 1',
    station == 'BCOKIE-2' ~ 'Okie Dam 2',
    TRUE ~ as.character(station)
  ))

table(cleaner_data$station)
```

    ## 
    ##  Adams Dam Okie Dam 1 Okie Dam 2 
    ##        701      61991        726

**NA and Unknown Values**

-   0 % of values in the `station` column are NA.

### Variable `method`

**Description:** method of capture

-   DSTR - Diversion fyke trap

-   RSTR - Rotary screw trap

``` r
cleaner_data <- cleaner_data %>% 
  mutate(method = set_names(tolower(method))) %>% 
  mutate(method = case_when(
          method =='dstr'~ 'diversion fyke trap',
          method =='rstr'~ 'rotary screw trap'
  )
)
table(cleaner_data$method)
```

    ## 
    ## diversion fyke trap   rotary screw trap 
    ##               32066               31352

**NA and Unknown Values**

-   0 % of values in the `method` column are NA.

### Variable `trap_status`

**Description:**

-   Check - trap was checked normally , continued fishing

-   Pull - trap was pulled after trap check

-   Set - trap was set upon arrival

``` r
cleaner_data <- cleaner_data %>% 
  mutate(trap_status = set_names(tolower(trap_status)))

table(cleaner_data$trap_status)
```

    ## 
    ## check  pull   set 
    ## 63130   130    15

**NA and Unknown Values**

-   0.2 % of values in the `trap_status` column are NA.

### Variable `species`

**Description:** we are interested in Chinooks only

**NA and Unknown Values**

-   0 % of values in the `species` column are NA.

### Variable `lifestage`

**Description:** Renaming to `lifestage`

-   1 - Fry with visible yolk sac
-   2 - Fry with no visible yolk sac
-   3 - Parr
-   4 - Fingerling
-   5 - Smolt
-   AD - Adult
-   n/p - not provided
-   UNK - unknown

``` r
table(cleaner_data$lifestage)
```

    ## 
    ##     1     2     3     4     5    AD   n/p   UNK 
    ##    51  5364  3558  1067    26    96 53255     1

``` r
cleaner_data <- cleaner_data %>% 
  mutate(method = set_names(tolower(method))) %>% 
  mutate(method = case_when(
          method =='dstr'~ 'diversion fyke trap',
          method =='rstr'~ 'rotary screw trap'
  )
)
# cleaner_data$lifestage <- ifelse(cleaner_data$lifestage == 'n/p', NA, cleaner_data$lifestage)
cleaner_data <- cleaner_data %>% 
  mutate(lifestage = case_when(
    lifestage == 1~ 'yolk sac fry',
    lifestage == 2~ 'fry',
    lifestage == 3~ 'parr',
    lifestage == 4~ 'fingerling',
    lifestage == 5~ 'smolt',
    lifestage == 'AD'~ 'adult',
    lifestage == 'UNK'~ 'unknown'
  ))
table(cleaner_data$lifestage)
```

    ## 
    ##        adult   fingerling          fry         parr        smolt      unknown 
    ##           96         1067         5364         3558           26            1 
    ## yolk sac fry 
    ##           51

**NA and Unknown Values**

-   84 % of values in the `lifestage` column are NA.

### Variable `gear_id`

**Description:**

-   DSTR1 - Diversion Fyke Trap 1

-   RSTR1 - Rotary Screw Trap 1

-   RSTR2 - Rotary Screw Trap 2

``` r
cleaner_data <- cleaner_data %>% 
  mutate(gear_id = case_when(
    gear_id == 'DSTR1' ~ 'diversion fyke trap 1',
    gear_id == 'RSTR1' ~ 'rotary screw trap 1',
    gear_id == 'RSTR2' ~ 'rotary screw trap 2'
  ))

table(cleaner_data$gear_id)
```

    ## 
    ## diversion fyke trap 1   rotary screw trap 1   rotary screw trap 2 
    ##                 28882                    35                 29270

**NA and Unknown Values**

-   8.2 % of values in the `gear_id` column are NA.

### Variable `debris`

**Description:** visual assessment of debris in trap

``` r
cleaner_data <- cleaner_data %>% 
  mutate(debris = set_names(tolower(debris)))
table(cleaner_data$debris)
```

    ## 
    ##      heavy      light     medium       none very heavy 
    ##       7321      38342      16532         31        341

**NA and Unknown Values**

-   1.3 % of values in the `debris` column are NA.

## Explore Numerical Variables

``` r
cleaner_data %>% select_if(is.numeric) %>% colnames()
```

    ##  [1] "count"            "fork_length"      "weight"           "temperature"     
    ##  [5] "turbidity"        "velocity"         "staff_gauge"      "trap_revolutions"
    ##  [9] "rpms_start"       "rpms_end"

### Variable `count`

``` r
cleaner_data %>% 
  mutate(water_year = ifelse(month(date) %in% 10:12, year(date) + 1, year(date))) %>% 
  mutate(year = as.factor(year(date)),
         fake_year = if_else(month(date) %in% 10:12, 1900, 1901),
         fake_date = as.Date(paste0(fake_year,"-", month(date), "-", day(date)))) %>%
  group_by(date) %>% 
  mutate(total_daily_catch = sum(count)) %>% 
  ungroup() %>% 
  ggplot(aes(x = fake_date, y = total_daily_catch)) +
  geom_col()+
  # scale_x_date(labels = date_format("%b"), limits = c(as.Date("1995-10-01"), as.Date("2016-06-01")), date_breaks = "1 month")+
  scale_x_date(labels = date_format("%b"), limits = c(as.Date("1900-10-01"), as.Date("1901-06-01")), date_breaks = "1 month") + 
  theme_minimal()+
  theme(text = element_text(size = 10),
        axis.text.x = element_text(angle = 90))+
  labs(title = "Total Daily Raw Passage 1995 - 2015",
       y = "Total daily catch",
       x = "Date")+ 
  facet_wrap(~water_year, scales = "free")
```

![](butte-creek-rst-qc-checklist_files/figure-gfm/unnamed-chunk-15-1.png)<!-- -->

``` r
cleaner_data %>% 
  mutate(year = as.factor(year(date))) %>% 
  ggplot(aes(x = year, y = count))+
  geom_col()+
  theme_minimal()+
  labs(title = "Total Fish Count By Year")+
  theme(text = element_text(size = 10),
        axis.text.x = element_text(angle = 90,  vjust = 0.5, hjust=1))
```

![](butte-creek-rst-qc-checklist_files/figure-gfm/unnamed-chunk-16-1.png)<!-- -->

``` r
summary(cleaner_data$count)
```

    ##      Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
    ##      0.00      1.00      1.00     75.02      4.00 220000.00

**NA and Unknown Values**

-   0 % of values in the `count` column are NA.

### Variable `fork_length`

**Description:** fork length in millimeters (mm)

``` r
cleaner_data %>% 
  filter(fork_length < 250) %>% #filtered out 52 points to see more clear distribution
  ggplot(aes(x = fork_length))+
  geom_histogram(binwidth = 2)+
  theme_minimal()+
  scale_x_continuous(breaks = seq(0, 250, by=25))+
  labs(title = "Fork Length Distribution")+
  theme(text = element_text(size=15),
        axis.text.x = element_text(vjust =0.5, hjust = 1))
```

![](butte-creek-rst-qc-checklist_files/figure-gfm/unnamed-chunk-18-1.png)<!-- -->

``` r
cleaner_data %>% 
  ggplot(aes(x = fork_length, y = lifestage))+
  geom_boxplot()+
  theme_minimal()+
  labs(title = 'Fork length summarized by life stage')+
  theme(text = element_text(size = 12))
```

![](butte-creek-rst-qc-checklist_files/figure-gfm/unnamed-chunk-19-1.png)<!-- -->

``` r
summary(cleaner_data$fork_length)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00   35.00   44.00   50.75   65.00 1035.00    3272

**NA and Unknown Values**

-   5.2 % of values in the `fork_length` column are NA.

### Variable `weight`

**Description:** wet weight in grams(g)

``` r
cleaner_data %>% 
  filter(weight< 30) %>%  #filtered out 26 data points to see more clear distribution
  ggplot(aes(x = weight))+
  geom_histogram(binwidth = 1)+
  scale_x_continuous(breaks = seq(0, 30, by=2))+
  theme_minimal()+
  labs(title = "Weight Distribution")
```

![](butte-creek-rst-qc-checklist_files/figure-gfm/unnamed-chunk-21-1.png)<!-- -->

``` r
cleaner_data %>% 
  filter(weight < 50) %>% 
  ggplot(aes(x = weight, y= lifestage))+
  geom_boxplot()+
  labs(title = 'Weight summarized by life stage')+
  theme(text = element_text(size = 12))+
  theme_minimal()
```

![](butte-creek-rst-qc-checklist_files/figure-gfm/unnamed-chunk-22-1.png)<!-- -->

``` r
summary(cleaner_data$weight)
```

    ##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max.     NA's 
    ##    0.000    0.000    0.290    1.617    2.275 3046.000    25299

**NA and Unknown Values**

-   39.9 % of values in the `weight` column are NA.

### Variable `temperature`

**Description:** temperature of water in degrees Celsius

``` r
cleaner_data %>%
  filter(temperature < 100) %>% #filter out 36 points with water temperature > 100 degrees
  ggplot(aes(x= temperature, y = station))+
  geom_boxplot()+
  theme_minimal()+
  labs(title = "Water Temperature by Station")
```

![](butte-creek-rst-qc-checklist_files/figure-gfm/unnamed-chunk-24-1.png)<!-- -->

``` r
cleaner_data %>% 
  filter(temperature < 100) %>%  #filter out 36 points with water temperature > 100 degrees (entry error?)
  group_by(date) %>% 
  mutate(daily_avg_temp = mean(temperature)) %>% 
  ungroup() %>% 
  mutate(year = as.factor(year(date)),
         fake_year = if_else(month(date) %in% 10:12, 1900,1901),
         fake_date = as.Date(paste0(fake_year, "-", month(date), "-", day(date)))) %>% 
  ggplot(aes(x = fake_date, y = daily_avg_temp, color = year))+
  geom_point()+
  scale_x_date(labels = date_format("%b"), date_breaks = "1 month")+
  theme_minimal()+
  theme(text = element_text(size = 12),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
        legend.position = "none")+
  labs(title = "Daily Water Temperature (colored by year)",
       x = 'Date',
       y = 'Average Daily Temp')
```

![](butte-creek-rst-qc-checklist_files/figure-gfm/unnamed-chunk-25-1.png)<!-- -->

``` r
cleaner_data %>% 
  filter(temperature < 100) %>% 
  mutate(year = as.factor(year(date))) %>% 
  ggplot(aes(x = temperature, y = year))+
  geom_boxplot()+
  theme_minimal()+
  labs(title = "Water Temperature summarized by year")+
  theme(text = element_text(size = 15),
        axis.text.x = element_text(vjust =0.5, hjust = 1))
```

![](butte-creek-rst-qc-checklist_files/figure-gfm/unnamed-chunk-26-1.png)<!-- -->

``` r
summary(cleaner_data$temperature)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   -1.00    7.00    9.00    9.96   12.00  805.00    3917

**NA and Unknown Values**

-   6.2 % of values in the `temperature` column are NA.

### Variable `turbidity`

**Description:** Turbidity of water in NTU

``` r
cleaner_data %>% 
  group_by(date) %>% 
  mutate(daily_avg_turb = mean(turbidity)) %>% 
  ungroup() %>% 
  mutate(year = as.factor(year(date)),
         fake_year = if_else(month(date) %in% 10:12, 1900,1901),
         fake_date = as.Date(paste0(fake_year, "-", month(date), "-", day(date)))) %>% 
  ggplot(aes(x = fake_date, y = daily_avg_turb, color = year))+
  geom_point()+
  scale_x_date(labels = date_format("%b"), date_breaks = "1 month")+
  theme_minimal()+
  theme(text = element_text(size = 12),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
        legend.position = "none")+
  labs(title = "Daily Turbidity (colored by year)",
       x = 'Date',
       y = 'Average Daily Turbidity')
```

![](butte-creek-rst-qc-checklist_files/figure-gfm/unnamed-chunk-28-1.png)<!-- -->

``` r
cleaner_data %>% 
  mutate(year = as.factor(year(date))) %>% 
  ggplot(aes(x = turbidity, y = year))+
  geom_boxplot()+
  theme_minimal()+
  labs(title = "Turbidity summarized by year")+
  theme(text = element_text(size = 15),
        axis.text.x = element_text(vjust =0.5, hjust = 1))
```

![](butte-creek-rst-qc-checklist_files/figure-gfm/unnamed-chunk-29-1.png)<!-- -->

``` r
summary(cleaner_data$turbidity)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.200   1.870   2.770   5.359   4.700 189.000   21066

**NA and Unknown Values**

-   33.2 % of values in the `turbidity` column are NA.

### Variable `velocity`

**Description:** water velocity measured in ft/s

Data Transformation

``` r
#Convert water velocity from ft/s to m/s
cleaner_data <- cleaner_data %>% 
  mutate(velocity = velocity/3.281)
```

``` r
cleaner_data %>%
  filter(velocity < 8) %>% #filtered out 8 data points to show a more clear graph
  ggplot(aes(x= velocity, y = station))+
  geom_boxplot()+
  theme_minimal()+
  labs(title = "Water Velocity by Station")
```

![](butte-creek-rst-qc-checklist_files/figure-gfm/unnamed-chunk-32-1.png)<!-- -->

``` r
cleaner_data %>% 
  filter(velocity < 5) %>% #filtered out one point to show a more clear graph
  group_by(date) %>% 
  mutate(daily_avg_velocity = mean(velocity)) %>% 
  ungroup() %>% 
  mutate(year = as.factor(year(date)),
         fake_year = if_else(month(date) %in% 10:12, 1900,1901),
         fake_date = as.Date(paste0(fake_year, "-", month(date), "-", day(date)))) %>% 
  ggplot(aes(x = fake_date, y = daily_avg_velocity, color = year))+
  geom_point()+
  scale_x_date(labels = date_format("%b"), date_breaks = "1 month")+
  theme_minimal()+
  theme(text = element_text(size = 12),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
        legend.position = "none")+
  labs(title = "Daily Water Velocity (colored by year)",
       x = 'Date',
       y = 'Average Daily Velocity')
```

![](butte-creek-rst-qc-checklist_files/figure-gfm/unnamed-chunk-33-1.png)<!-- -->

``` r
cleaner_data %>% 
  filter(velocity<6) %>% 
  mutate(year = as.factor(year(date))) %>% 
  ggplot(aes(x = velocity, y = year))+
  geom_boxplot()+
  theme_minimal()+
  labs(title = "Water Velocity summarized by year")+
  theme(text = element_text(size = 15),
        axis.text.x = element_text(vjust =0.5, hjust = 1))
```

![](butte-creek-rst-qc-checklist_files/figure-gfm/unnamed-chunk-34-1.png)<!-- -->

# Numeric summary of `velocity` from 1995-2015

``` r
summary(cleaner_data$velocity)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00    0.20    0.27    0.34    0.37  104.24   38937

**NA and Unknown Values**

-   61.4 % of values in the `velocity` column are NA.

### Variable `trap_revolutions`

**Description:** Number of revolutions the RST cone had made since last
being checked

``` r
cleaner_data %>% 
  ggplot(aes(x = trap_revolutions))+
  geom_histogram(binwidth = 500)+
  labs(title = "Distribution of Trap Revolutions")+
  theme_minimal()+
  theme(text = element_text(size = 12))
```

![](butte-creek-rst-qc-checklist_files/figure-gfm/unnamed-chunk-36-1.png)<!-- -->

``` r
cleaner_data %>% 
  filter(station != "Adams Dam") %>% 
  ggplot(aes(y= station, x = trap_revolutions))+
  geom_boxplot()+
  labs(title = "Trap Revolutions Summarized by Location")+
  theme_minimal()+
  theme(text = element_text(size = 12))
```

![](butte-creek-rst-qc-checklist_files/figure-gfm/unnamed-chunk-37-1.png)<!-- -->

# Numeric summary of `trap_revolutions` from 1995-2015

``` r
summary(cleaner_data$trap_revolutions)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##       0    2741    4000    4118    5439   11795   41363

**NA and Unknown Values**

-   65.2 % of values in the `trap_revolutions` column are NA.

### Variable `rpms_start`

**Description:** rotations per minute of RST cone at start of trapping
window

``` r
cleaner_data %>% 
  filter(rpms_start < 10) %>% #filtered out 28 data points to show more clear distribution
  ggplot(aes(x = rpms_start))+
  geom_histogram(binwidth = 1)+
  labs(title = "Distribution of RPMs Start")+
  theme_minimal()+
  theme(text = element_text(size = 12))
```

![](butte-creek-rst-qc-checklist_files/figure-gfm/unnamed-chunk-39-1.png)<!-- -->

``` r
cleaner_data %>% 
  filter(rpms_start < 10) %>% 
  ggplot(aes(y= station, x = rpms_start))+
  geom_boxplot()+
  labs(title = "RPMs Start Summarized by Location")+
  theme_minimal()+
  theme(text = element_text(size = 12))
```

![](butte-creek-rst-qc-checklist_files/figure-gfm/unnamed-chunk-40-1.png)<!-- -->

# Numeric summary of `rpms_start` from 1995-2015

``` r
summary(cleaner_data$rpms_start)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00    2.10    3.00    4.92    4.00 3698.00   34932

**NA and Unknown Values**

-   55.1 % of values in the \`rpms\_start\`\` column are NA.

### Variable `rpms_end`

**Description:** rotations per minute of RST cone at end of trapping
window

``` r
cleaner_data %>% 
  filter(rpms_end < 10) %>% #filtered out 28 data points to show more clear distribution
  ggplot(aes(x = rpms_end))+
  geom_histogram(binwidth = 1)+
  labs(title = "Distribution of RPMs End")+
  theme_minimal()+
  theme(text = element_text(size = 12))
```

![](butte-creek-rst-qc-checklist_files/figure-gfm/unnamed-chunk-42-1.png)<!-- -->

``` r
cleaner_data %>% 
  filter(rpms_end < 10) %>% 
  ggplot(aes(y= station, x = rpms_end))+
  geom_boxplot()+
  labs(title = "RPMs End Summarized by Location")+
  theme_minimal()+
  theme(text = element_text(size = 12))
```

![](butte-creek-rst-qc-checklist_files/figure-gfm/unnamed-chunk-43-1.png)<!-- -->

**NA and Unknown Values**

-   58.9 % of values in the `rpms_end` column are NA.

### Issues Identified

-   50 points in water temperature reaches over 50 degrees celsius

-   Turbidity data lacks in some years

### Add cleaned data back into google cloud

``` r
butte_creek_rst <- cleaner_data %>% glimpse()
```

    ## Rows: 63,418
    ## Columns: 19
    ## $ date             <dttm> 1995-11-29, 1995-11-29, 1995-11-29, 1995-11-29, 1995~
    ## $ station          <chr> "Okie Dam 1", "Okie Dam 1", "Okie Dam 1", "Okie Dam 1~
    ## $ method           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ trap_status      <chr> "check", "check", "check", "check", "check", "check",~
    ## $ species          <chr> "CHN", "CHN", "CHN", "CHN", "CHN", "CHN", "CHN", "CHN~
    ## $ count            <dbl> 1, 2, 1, 8, 1, 5, 4, 1, 1, 1, 3, 3, 5, 3, 4, 1, 2, 1,~
    ## $ fork_length      <dbl> 38, 37, 39, 35, 33, 34, 36, 37, 36, 34, 33, 34, 35, 3~
    ## $ weight           <dbl> 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00,~
    ## $ lifestage        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ time             <time> 09:30:00, 09:30:00, 09:30:00, 09:30:00, 09:30:00, 09~
    ## $ gear_id          <chr> "diversion fyke trap 1", "diversion fyke trap 1", "di~
    ## $ temperature      <dbl> 8.333333, 8.333333, 8.333333, 8.333333, 8.333333, 8.3~
    ## $ turbidity        <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ velocity         <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ staff_gauge      <dbl> 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, NA, NA, NA, N~
    ## $ trap_revolutions <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ debris           <chr> "medium", "medium", "medium", "medium", "medium", "me~
    ## $ rpms_start       <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ rpms_end         <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~

``` r
write_csv(butte_creek_rst, "butte_rst.csv")
```

``` r
f <- function(input, output) write_csv(input, file = output)

gcs_upload(butte_creek_rst,
           object_function = f,
           type = "csv",
           name = "rst/butte-creek/data/butte-creek-rst.csv")
```
