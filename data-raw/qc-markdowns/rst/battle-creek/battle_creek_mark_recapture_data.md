Battle Creek Mark Recapture Data
================
Erin Cain
9/29/2021

# Battle Creek Mark Recapture Data

## Description of Monitoring Data

Mike Schraml provided us with Mark Recapture data for Battle Creek.

**Timeframe:** 2003 - 2021

**Completeness of Record throughout timeframe:**

**Sampling Location:** Battle Creek

**Data Contact:** [Mike Schraml](mailto:mike_schraml@fws.gov)

**Additional description provided by Mike:**

Here are the data you requested. We consider any trial where six or
fewer are recaptured to be an invalid trial. Our season average
efficiencies are calculated only from valid trial data. During some
years we released clipped (upper caudal or lower caudal, or both clip
types) and just dyed fish at nearly the same time. These data were
combined for the efficiency calculation. See 04/12/12 release data at
Vulture Bar (VB) on the Mark-Recap Database MASTER CC DWR Data.xlsx
spreadsheet (and below) as an example.

Released Upper 161 Lower 143 Unclipped 165 Total 469

Recaptured Upper 2 Lower 9 Unclipped 10 Total 21

Bailey’s efficiency = (21+1) / (469+/) = 0.0468

In this case, because the fish were released at nearly the same time we
would use the upper clip data in the efficiency calculation and consider
the trial valid.

I hope this helps you understand these data. If you have more questions
please ask me.

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
gcs_get_object(object_name = "rst/battle-creek/data-raw/Mark-Recap Database MASTER BC DWR Data.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "raw_battle_mark_recapture_data.xlsx",
               overwrite = TRUE)
```

Read in data from google cloud, glimpse raw data: Data is stored in a
multi-tab sheet, we are interested in tab 2, Data Entry. There are
additional non tidy merged cells at the top of the sheet that catagorize
variables that we will skip when reading in.

``` r
# read in data to clean 
raw_mark_recapture <- readxl::read_excel("raw_battle_mark_recapture_data.xlsx", sheet = 2, skip  = 2) %>% glimpse()
```

    ## New names:
    ## • `` -> `...12`
    ## • `` -> `...19`
    ## • `` -> `...44`

    ## Rows: 285
    ## Columns: 57
    ## $ `Valid for Corr. Analysis?(Y/N)`      <chr> "N", "Y", "Y", "N", "Y", "Y", "Y…
    ## $ `Valid For Prod. Est?  (Y/N)`         <chr> "N", "Y", "Y", "N", "Y", "Y", "Y…
    ## $ `Release Date`                        <chr> "37643", "37649", "37652", "3765…
    ## $ `(D)ay or (N)ight    Release`         <chr> "N", "N", "N", "N", "N", "N", "N…
    ## $ `Release Time`                        <dttm> 1899-12-31 19:35:00, 1899-12-31…
    ## $ `No. Marked`                          <dbl> 179, 404, 215, 127, 300, 297, 50…
    ## $ `No. Released`                        <dbl> 168, 400, 212, 125, 292, 289, 49…
    ## $ Recaps                                <dbl> 0, 33, 14, 0, 23, 20, 33, 2, 20,…
    ## $ Mortality                             <dbl> NA, NA, NA, NA, NA, NA, NA, NA, …
    ## $ `Bailey's Trap Efficiency`            <dbl> 0.5917160, 8.4788030, 7.0422535,…
    ## $ `Peterson Trap Efficiency`            <dbl> 0.0000000, 8.2500000, 6.6037736,…
    ## $ ...12                                 <lgl> NA, NA, NA, NA, NA, NA, NA, NA, …
    ## $ `Mark Med Fork Length(mm)`            <dbl> 36, 36, 36, 35, 36, 36, 36, 37, …
    ## $ `Recap Med Fork Length(mm)`           <dbl> NA, 36, 35, NA, 35, 36, 37, 37, …
    ## $ `Origin (H/N)`                        <chr> "N", "N", "N", "N", "N", "N", "N…
    ## $ Clip                                  <chr> NA, NA, NA, NA, NA, NA, NA, NA, …
    ## $ `Days Held Post-mark`                 <dbl> 0, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    ## $ `Max Days Held Pre-Mark`              <dbl> 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0,…
    ## $ ...19                                 <lgl> NA, NA, NA, NA, NA, NA, NA, NA, …
    ## $ `Release Temp`                        <chr> "49.9", "49.6", "51.3", "47.4", …
    ## $ `Flow @ Release`                      <dbl> 1710, 817, 636, 614, 523, 481, 7…
    ## $ `Barom. Pressure`                     <dbl> 30.22, 30.15, 30.20, 30.19, 30.1…
    ## $ `∆B.P. after`                         <dbl> 0.07, 0.13, -0.17, -0.01, 0.02, …
    ## $ `∆B.P. before`                        <dbl> 0.03, 0.03, -0.13, -0.05, 0.01, …
    ## $ `Release Turbidity`                   <dbl> NA, NA, NA, NA, NA, NA, NA, NA, …
    ## $ `Peak Wind Speed @ Release`           <dbl> 7, 9, 6, 15, 25, 9, 6, 6, 14, 14…
    ## $ `Hourly Average Wind Speed @ Release` <dbl> 0, 5, 4, 8, 14, 3, 2, 3, 6, 5, 1…
    ## $ `% Sky Cover @ Rel`                   <dbl> 8, 0, 3, 0, 0, 0, 8, 0, 0, 0, 5,…
    ## $ `Weather/Sky Condition`               <chr> "hvy rain, fog", "overcast", "fo…
    ## $ `Event (day of release)`              <chr> "Rain", "0", "Fog", "0", "0", "0…
    ## $ `Event (day after release)`           <chr> "Fog", "0", "Fog-Rain", "0", "0"…
    ## $ `Rain (Y/N)`                          <chr> "Y", "N", "Y", "N", "N", "N", "Y…
    ## $ `Rain @ Release (in)`                 <dbl> 1.30, 0.00, 0.01, 0.00, 0.00, 0.…
    ## $ `Light from moon`                     <chr> NA, NA, NA, NA, NA, NA, NA, NA, …
    ## $ `Nightly Moon Fraction`               <dbl> 0.72, 0.11, 0.00, 0.09, 0.31, 0.…
    ## $ `Adjusted Moon Fraction`              <dbl> 0.072, 0.022, 0.000, 0.090, 0.31…
    ## $ `Date of 1st Recap`                   <dttm> NA, NA, NA, NA, NA, NA, NA, NA,…
    ## $ `Time of 1st Recap`                   <dttm> NA, 1899-12-31 13:20:00, 1899-1…
    ## $ `Turbidity @ Recap`                   <dbl> 4.0, 2.8, 2.3, 2.5, 4.0, 2.3, 3.…
    ## $ `Flow @ 1st Recap`                    <dbl> NA, 717, 662, NA, 513, 485, 598,…
    ## $ `Cone Velocity`                       <dbl> 3.12, 3.37, 2.74, 2.29, 2.56, 2.…
    ## $ `Sec/ Rotation`                       <dbl> 6.33, 8.00, 9.33, 7.33, 10.33, 1…
    ## $ `Cone Status (H/F)`                   <chr> "F", "F", "F", "F", "F", "F", "F…
    ## $ ...44                                 <lgl> NA, NA, NA, NA, NA, NA, NA, NA, …
    ## $ `Mean Temp Day of Rel`                <dbl> 49.0, 49.1, 50.6, 46.3, 44.8, 45…
    ## $ `Mean Temp Day 1+ 2`                  <dbl> 48.75, 48.95, 50.55, 46.05, 44.6…
    ## $ `Mean Flow    Day 1 to Day 5.`        <dbl> 1161, 714, 650, 563, 506, 521, 8…
    ## $ `Mean Flow Day of Rel`                <dbl> 1190, 849, 638, 627, 542, 483, 5…
    ## $ `Mean Flow Day 1+ 2`                  <dbl> 1100.0, 788.5, 665.0, 606.0, 528…
    ## $ `Caught Day 1`                        <dbl> NA, 33, 12, 0, 23, 20, 32, 2, 18…
    ## $ `Caught Day 2`                        <dbl> 0, 0, 2, 0, 0, 0, 1, 0, 2, 1, 0,…
    ## $ `Caught Day 3`                        <dbl> 0, 0, 0, 0, 0, 0, NA, 0, 0, 0, 0…
    ## $ `Caught Day 4`                        <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
    ## $ `Caught Day 5`                        <dbl> 0, 0, 0, 0, 0, 0, 0, 0, NA, 0, 0…
    ## $ `Days past Dec 31`                    <dbl> 22, 28, 31, 34, 37, 41, 44, 48, …
    ## $ `Trap Year`                           <dbl> 2003, 2003, 2003, 2003, 2003, 20…
    ## $ `Bailey's E (Full Cone Equivalence)`  <dbl> 0.5917160, 8.4788030, 7.0422535,…

## Data transformations

``` r
# For different excel sheets for each year read in and combine years here
mark_recapture_data <- raw_mark_recapture %>% 
  janitor::clean_names() %>% 
  filter(release_date != "No Mark/Recap Studies for 2014-2015 Season") %>%
  mutate(release_date = janitor::excel_numeric_to_date(as.numeric(as.character(release_date)), date_system = "modern")) %>%
  glimpse
```

    ## Rows: 275
    ## Columns: 57
    ## $ valid_for_corr_analysis_y_n       <chr> "N", "Y", "Y", "N", "Y", "Y", "Y", "…
    ## $ valid_for_prod_est_y_n            <chr> "N", "Y", "Y", "N", "Y", "Y", "Y", "…
    ## $ release_date                      <date> 2003-01-22, 2003-01-28, 2003-01-31,…
    ## $ d_ay_or_n_ight_release            <chr> "N", "N", "N", "N", "N", "N", "N", "…
    ## $ release_time                      <dttm> 1899-12-31 19:35:00, 1899-12-31 18:…
    ## $ no_marked                         <dbl> 179, 404, 215, 127, 300, 297, 500, 2…
    ## $ no_released                       <dbl> 168, 400, 212, 125, 292, 289, 491, 2…
    ## $ recaps                            <dbl> 0, 33, 14, 0, 23, 20, 33, 2, 20, 37,…
    ## $ mortality                         <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, …
    ## $ baileys_trap_efficiency           <dbl> 0.5917160, 8.4788030, 7.0422535, 0.7…
    ## $ peterson_trap_efficiency          <dbl> 0.0000000, 8.2500000, 6.6037736, 0.0…
    ## $ x12                               <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, …
    ## $ mark_med_fork_length_mm           <dbl> 36, 36, 36, 35, 36, 36, 36, 37, 37, …
    ## $ recap_med_fork_length_mm          <dbl> NA, 36, 35, NA, 35, 36, 37, 37, 36, …
    ## $ origin_h_n                        <chr> "N", "N", "N", "N", "N", "N", "N", "…
    ## $ clip                              <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, …
    ## $ days_held_post_mark               <dbl> 0, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
    ## $ max_days_held_pre_mark            <dbl> 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, …
    ## $ x19                               <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, …
    ## $ release_temp                      <chr> "49.9", "49.6", "51.3", "47.4", "46"…
    ## $ flow_release                      <dbl> 1710, 817, 636, 614, 523, 481, 711, …
    ## $ barom_pressure                    <dbl> 30.22, 30.15, 30.20, 30.19, 30.12, 3…
    ## $ b_p_after                         <dbl> 0.07, 0.13, -0.17, -0.01, 0.02, -0.1…
    ## $ b_p_before                        <dbl> 0.03, 0.03, -0.13, -0.05, 0.01, -0.1…
    ## $ release_turbidity                 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, …
    ## $ peak_wind_speed_release           <dbl> 7, 9, 6, 15, 25, 9, 6, 6, 14, 14, 18…
    ## $ hourly_average_wind_speed_release <dbl> 0, 5, 4, 8, 14, 3, 2, 3, 6, 5, 1, 2,…
    ## $ percent_sky_cover_rel             <dbl> 8, 0, 3, 0, 0, 0, 8, 0, 0, 0, 5, 0, …
    ## $ weather_sky_condition             <chr> "hvy rain, fog", "overcast", "fog", …
    ## $ event_day_of_release              <chr> "Rain", "0", "Fog", "0", "0", "0", "…
    ## $ event_day_after_release           <chr> "Fog", "0", "Fog-Rain", "0", "0", "0…
    ## $ rain_y_n                          <chr> "Y", "N", "Y", "N", "N", "N", "Y", "…
    ## $ rain_release_in                   <dbl> 1.30, 0.00, 0.01, 0.00, 0.00, 0.00, …
    ## $ light_from_moon                   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, …
    ## $ nightly_moon_fraction             <dbl> 0.72, 0.11, 0.00, 0.09, 0.31, 0.68, …
    ## $ adjusted_moon_fraction            <dbl> 0.072, 0.022, 0.000, 0.090, 0.310, 0…
    ## $ date_of_1st_recap                 <dttm> NA, NA, NA, NA, NA, NA, NA, NA, NA,…
    ## $ time_of_1st_recap                 <dttm> NA, 1899-12-31 13:20:00, 1899-12-31…
    ## $ turbidity_recap                   <dbl> 4.0, 2.8, 2.3, 2.5, 4.0, 2.3, 3.3, 3…
    ## $ flow_1st_recap                    <dbl> NA, 717, 662, NA, 513, 485, 598, 620…
    ## $ cone_velocity                     <dbl> 3.12, 3.37, 2.74, 2.29, 2.56, 2.36, …
    ## $ sec_rotation                      <dbl> 6.33, 8.00, 9.33, 7.33, 10.33, 10.66…
    ## $ cone_status_h_f                   <chr> "F", "F", "F", "F", "F", "F", "F", "…
    ## $ x44                               <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, …
    ## $ mean_temp_day_of_rel              <dbl> 49.0, 49.1, 50.6, 46.3, 44.8, 45.5, …
    ## $ mean_temp_day_1_2                 <dbl> 48.75, 48.95, 50.55, 46.05, 44.65, 4…
    ## $ mean_flow_day_1_to_day_5          <dbl> 1161, 714, 650, 563, 506, 521, 837, …
    ## $ mean_flow_day_of_rel              <dbl> 1190, 849, 638, 627, 542, 483, 583, …
    ## $ mean_flow_day_1_2                 <dbl> 1100.0, 788.5, 665.0, 606.0, 528.0, …
    ## $ caught_day_1                      <dbl> NA, 33, 12, 0, 23, 20, 32, 2, 18, 36…
    ## $ caught_day_2                      <dbl> 0, 0, 2, 0, 0, 0, 1, 0, 2, 1, 0, 1, …
    ## $ caught_day_3                      <dbl> 0, 0, 0, 0, 0, 0, NA, 0, 0, 0, 0, 1,…
    ## $ caught_day_4                      <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, …
    ## $ caught_day_5                      <dbl> 0, 0, 0, 0, 0, 0, 0, 0, NA, 0, 0, 0,…
    ## $ days_past_dec_31                  <dbl> 22, 28, 31, 34, 37, 41, 44, 48, 51, …
    ## $ trap_year                         <dbl> 2003, 2003, 2003, 2003, 2003, 2003, …
    ## $ baileys_e_full_cone_equivalence   <dbl> 0.5917160, 8.4788030, 7.0422535, 0.7…

``` r
View(raw_mark_recapture)
```

Currently efficiency is just a function of number of number recaptured /
number released. (with a x2 adjustment if the trap is fished at 1/2
cone)

## Exploratory Analysis:

Analysis to explore other variables that may be correlated with trap
efficiency:

``` r
mark_recapture_data %>% 
  group_by(release_date) %>%
  summarise(daily_flow = mean(flow_release),
            mean_efficency = mean(baileys_trap_efficiency)) %>%
  ggplot() +
  geom_point(aes(x = daily_flow, y = mean_efficency)) + 
  theme_minimal()
```

![](battle_creek_mark_recapture_data_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

## Explore Numeric Variables:

``` r
mark_recapture_data %>% select_if(is.numeric) %>% colnames 
```

    ##  [1] "no_marked"                         "no_released"                      
    ##  [3] "recaps"                            "mortality"                        
    ##  [5] "baileys_trap_efficiency"           "peterson_trap_efficiency"         
    ##  [7] "mark_med_fork_length_mm"           "recap_med_fork_length_mm"         
    ##  [9] "days_held_post_mark"               "max_days_held_pre_mark"           
    ## [11] "flow_release"                      "barom_pressure"                   
    ## [13] "b_p_after"                         "b_p_before"                       
    ## [15] "release_turbidity"                 "peak_wind_speed_release"          
    ## [17] "hourly_average_wind_speed_release" "percent_sky_cover_rel"            
    ## [19] "rain_release_in"                   "nightly_moon_fraction"            
    ## [21] "adjusted_moon_fraction"            "turbidity_recap"                  
    ## [23] "flow_1st_recap"                    "cone_velocity"                    
    ## [25] "sec_rotation"                      "mean_temp_day_of_rel"             
    ## [27] "mean_temp_day_1_2"                 "mean_flow_day_1_to_day_5"         
    ## [29] "mean_flow_day_of_rel"              "mean_flow_day_1_2"                
    ## [31] "caught_day_1"                      "caught_day_2"                     
    ## [33] "caught_day_3"                      "caught_day_4"                     
    ## [35] "caught_day_5"                      "days_past_dec_31"                 
    ## [37] "trap_year"                         "baileys_e_full_cone_equivalence"

The most relevant columns of this dataset are `no_released`, `recaps`,
and `baileys_trap_efficiency`

### Variable: `no_released`

**Plotting no_released over Period of Record**

``` r
mark_recapture_data %>% ggplot() +
  geom_point(aes(x = release_date, y = no_released))
```

![](battle_creek_mark_recapture_data_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

**Numeric Summary of no_released over Period of Record**

``` r
# Table with summary statistics
summary(mark_recapture_data$no_released)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    65.0   281.0   322.5   364.4   499.0  1143.0       1

Looks like there are anywhere from 65 - 1143 fish released.

### Variable: `recaps`

**Plotting recaps over Period of Record**

``` r
mark_recapture_data %>% ggplot() +
  geom_point(aes(x = release_date, y = recaps))
```

![](battle_creek_mark_recapture_data_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

**Numeric Summary of recaps over Period of Record**

``` r
# Table with summary statistics
summary(mark_recapture_data$recaps)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00   10.00   16.00   19.32   26.00   64.00       1

Looks like there are anywhere from 0 - 64 fish recaptured

### Variable: `baileys_trap_efficiency`

**Plotting baileys_trap_efficiency over Period of Record**

``` r
mark_recapture_data %>% ggplot() +
  geom_point(aes(x = release_date, y = baileys_trap_efficiency))
```

![](battle_creek_mark_recapture_data_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

**Numeric Summary of baileys_trap_efficiency over Period of Record**

``` r
# Table with summary statistics
summary(mark_recapture_data$baileys_trap_efficiency)
```

    ##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
    ##   0.2222   3.3114   4.7525   6.0316   8.0790 100.0000

Looks like baileys efficiency is anywhere from .22 - 100.

## Summary of identified issues

- What are all other variables doing in dataset if not being used to
  calculate trap efficiency?
- Does not look like consistent amount of mark recapture trials each
  year

## Select relevent data, & save cleaned data to cloud

``` r
# identified a typo where release_date == "2018-02-14": caught_day_1 should be 11 not 1180 because totaly of 11 recaps and 299 released so 1180 does not make sensing.
# Fixing typo here: 10/27/2023
battle_mark_reacpture <- mark_recapture_data %>% 
  select(release_date, day_or_night_release = d_ay_or_n_ight_release, release_time, no_marked,
         no_released, recaps, mortality, mark_med_fork_length_mm, recap_med_fork_length_mm, 
         origin_h_n, days_held_post_mark, release_temp, flow_release, release_turbidity, cone_status_h_f, 
         mean_temp_day_of_rel, mean_flow_day_of_rel, caught_day_1, caught_day_2, 
         caught_day_3, caught_day_4, caught_day_5) %>% 
  mutate(release_time = hms::as_hms(release_time),
         day_or_night_release = case_when(day_or_night_release == "?" ~ "unknown", 
                                          day_or_night_release == "D" ~ "day",
                                          day_or_night_release == "N" ~ "night"),
         origin = case_when(origin_h_n == "H" ~ "hatchery", 
                                origin_h_n == "N" ~ "natural"),
         release_temp = as.numeric(release_temp),
         cone_status = case_when(cone_status_h_f == "H" ~ "half", 
                                 cone_status_h_f == "F" ~ "full"),
         # FIX TYPO
         caught_day_1 = ifelse(release_date == "2018-02-14",11,caught_day_1)) %>% 
  select(-origin_h_n, -cone_status_h_f)
# check to make sure typo fixed
filter(battle_mark_reacpture, release_date == "2018-02-14") |> select(caught_day_1)
```

    ## # A tibble: 1 × 1
    ##   caught_day_1
    ##          <dbl>
    ## 1           11

``` r
f <- function(input, output) write_csv(input, file = output)

gcs_upload(battle_mark_reacpture,
           object_function = f,
           type = "csv",
           name = "rst/battle-creek/data/battle_mark_reacpture.csv")
```

    ## ℹ 2023-10-27 13:30:37 > File size detected as  26 Kb

    ## ℹ 2023-10-27 13:30:37 > Request Status Code:  400

    ## ! http_400 Cannot insert legacy ACL for an object when uniform bucket-level access is enabled. Read more at https://cloud.google.com/storage/docs/uniform-bucket-level-access - Retrying with predefinedAcl='bucketLevel'

    ## ℹ 2023-10-27 13:30:37 > File size detected as  26 Kb

    ## ==Google Cloud Storage Object==
    ## Name:                rst/battle-creek/data/battle_mark_reacpture.csv 
    ## Type:                csv 
    ## Size:                26 Kb 
    ## Media URL:           https://www.googleapis.com/download/storage/v1/b/jpe-dev-bucket/o/rst%2Fbattle-creek%2Fdata%2Fbattle_mark_reacpture.csv?generation=1698438637912081&alt=media 
    ## Download URL:        https://storage.cloud.google.com/jpe-dev-bucket/rst%2Fbattle-creek%2Fdata%2Fbattle_mark_reacpture.csv 
    ## Public Download URL: https://storage.googleapis.com/jpe-dev-bucket/rst%2Fbattle-creek%2Fdata%2Fbattle_mark_reacpture.csv 
    ## Bucket:              jpe-dev-bucket 
    ## ID:                  jpe-dev-bucket/rst/battle-creek/data/battle_mark_reacpture.csv/1698438637912081 
    ## MD5 Hash:            FOon/qiX1gCoVtAtYu4bAA== 
    ## Class:               STANDARD 
    ## Created:             2023-10-27 20:30:37 
    ## Updated:             2023-10-27 20:30:37 
    ## Generation:          1698438637912081 
    ## Meta Generation:     1 
    ## eTag:                CJGAvv2Il4IDEAE= 
    ## crc32c:              GUtVBA==
