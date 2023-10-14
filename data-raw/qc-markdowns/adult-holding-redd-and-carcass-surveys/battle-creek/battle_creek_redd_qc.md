Battle Creek Redd Survey QC
================
Erin Cain
9/29/2021

# Battle Creek Redd Survey

## Description of Monitoring Data

These data were acquired via snorkel and kayak surveys on Battle Creek
from 2001 to 2019. Red location, size, substrate and flow were measured.
Annual monitoring questions and conditions drove the frequency and
detail of individual redd measurements.

**Timeframe:** 2001 - 2019

**Survey Season:** September - October

**Completeness of Record throughout timeframe:** Sampled each year

**Sampling Location:** Battle Creek

**Data Contact:** [Natasha Wingerter](mailto:natasha_wingerter@fws.gov);
[RJ Bottaro](mailto:rj_bottaro@fws.gov)

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
# read in updated table with redd ids (sent 10-12-2023)
gcs_get_object(object_name = "adult-holding-redd-and-carcass-surveys/battle-creek/data-raw/battle_creek_redds_raw.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk = here::here("data-raw", "qc-markdowns","adult-holding-redd-and-carcass-surveys", "battle-creek", "raw_adult_redd.xlsx"),
               overwrite = TRUE)
```

Read in data from google cloud, glimpse sheets and raw data:

``` r
raw_redd_data <-read_excel(here::here("data-raw", "qc-markdowns","adult-holding-redd-and-carcass-surveys", "battle-creek", "raw_adult_redd.xlsx")) |> glimpse()
```

    ## Rows: 1,605
    ## Columns: 57
    ## $ ID                   <dbl> 14598, 14599, 14600, 14601, 14602, 14603, 14604, …
    ## $ OBJECT_ID            <dbl> 35, 36, 37, 38, 39, 40, 41, 42, 141, 142, 143, 14…
    ## $ DATABASE_ID          <chr> "Redd_0035", "Redd_0036", "Redd_0037", "Redd_0038…
    ## $ Date_ReachU_Reach_SU <chr> "37530R2", "37530R2", "37530R2", "37530R2", "3753…
    ## $ Project              <chr> "Snorkel", "Snorkel", "Snorkel", "Snorkel", "Snor…
    ## $ SUR_METHOD           <chr> "Snorkel", "Snorkel", "Snorkel", "Snorkel", "Snor…
    ## $ LONGITUDE            <dbl> -122, -122, -122, -122, -122, -122, -122, -122, -…
    ## $ LATITUDE             <dbl> 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 4…
    ## $ YEAR                 <chr> "2002", "2002", "2002", "2002", "2002", "2002", "…
    ## $ Sample_Date          <chr> "10/1/2002", "10/1/2002", "10/1/2002", "10/1/2002…
    ## $ REACH                <chr> "R2", "R2", "R2", "R2", "R2", "R2", "R3", "R3", "…
    ## $ Reach_SubUnit        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ RIVER_MILE           <dbl> 2, 2, 1, 1, 0, 0, 2, 2, 2, 1, 1, 1, 1, 2, 2, 2, 2…
    ## $ Species_Run          <chr> "SCS", "SCS", "SCS", "SCS", "SCS", "SCS", "SCS", …
    ## $ REDD_ID              <chr> "10102R2#1", "10102R2#2", "10102R2#3", "10102R2#4…
    ## $ FORK                 <chr> "NF", "NF", "NF", "NF", "NF", "NF", "SF", "SF", "…
    ## $ AGE                  <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ REDD_LOC             <chr> "UNK", "UNK", "UNK", "UNK", "UNK", "UNK", "UNK", …
    ## $ PRE_SUB              <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ SIDES_SUB            <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ TAIL_SUB             <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ FOR_                 <chr> "UNK", "UNK", "UNK", "UNK", "UNK", "UNK", "UNK", …
    ## $ MEASURE              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, …
    ## $ WHY_NOT_ME           <chr> "UNK", "UNK", "UNK", "UNK", "UNK", "UNK", "UNK", …
    ## $ DATE_MEASU           <dttm> NA, NA, NA, NA, NA, NA, NA, NA, 2003-10-01, 2003…
    ## $ PRE_DEPTH            <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 10, 15, 15, NA, N…
    ## $ PIT_DEPTH            <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 16, 24, 19, NA, N…
    ## $ TAIL_DEPTH           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 8, 13, 13, NA, NA…
    ## $ LENGTH_IN            <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 182, 66, 80, NA, …
    ## $ WIDTH_IN             <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 72, 43, 42, NA, N…
    ## $ FLOW_METER           <chr> NA, NA, NA, NA, NA, NA, NA, NA, "Flow Bomb", "Flo…
    ## $ FLOW_FPS             <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 2, 2, 2, NA, NA, …
    ## $ START                <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 862000, 877300, 8…
    ## $ END_                 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 864537, 880150, 8…
    ## $ TIME_                <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 100, 100, 100, NA…
    ## $ START_80             <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ END_80               <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ SECS_80_             <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ SERIAL               <chr> NA, NA, NA, NA, NA, NA, NA, NA, "16765", NA, NA, …
    ## $ Comments             <chr> "wp 193", "wp 194", "wp 195", "wp 196", "wp 197",…
    ## $ SURVEY               <chr> "11", "11", "11", "11", "11", "11", "11", "11", "…
    ## $ AGE_B                <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ DATE_B               <dttm> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
    ## $ AGE_C                <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ DATE_C               <dttm> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
    ## $ AGE_D                <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ DATE_D               <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ Corr_Type            <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ Horz_Prec            <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ Corr_Date            <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ FINES_PRES           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ OVERHEAD_V           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ INSTREAM_C           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ COVER_COMM           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ STREAM_FEA           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ TRIBUTARY_           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ TRIB_COMM            <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…

## Data transformations

``` r
cleaner_redd_data <- raw_redd_data |>  
  janitor::clean_names() |> 
  rename("date" = sample_date,
         "fish_guarding" = `for`, 
         "redd_measured" = measure, 
         "why_not_measured" = why_not_me,
         "date_measured" = date_measu, 
         "pre_redd_substrate_size" = pre_sub, 
         "redd_substrate_size" = sides_sub, 
         "tail_substrate_size" = tail_sub,
         "pre_redd_depth" = pre_depth, 
         "redd_pit_depth" = pit_depth, 
         "redd_tail_depth" = tail_depth,
         "redd_length" = length_in, 
         "redd_width" = width_in,
         "start_number_flow_meter" = start, 
         "end_number_flow_meter" = end,
         "flow_meter_time" = time,
         "start_number_flow_meter_80" = start_80, 
         "end_number_flow_meter_80" = end_80,
         "flow_meter_time_80" = secs_80,
         "survey_method" = sur_method,
         "run" = species_run) |> 
  mutate(reach_sub_unit = toupper(reach_sub_unit),
         run = ifelse(run == "SCS", "spring", run),
         redd_loc = ifelse(redd_loc == "NA", NA_character_, redd_loc)) |> 
    select(-c(id, object_id, database_id, date_reach_u_reach_su, 
              project, year, date_measured, 
            corr_type, horz_prec, corr_date, fines_pres,
            overhead_v, instream_c, cover_comm, stream_fea, 
            tributary, trib_comm, serial, comments, fork))  # all are spring run

clean_redd_data_with_age <- cleaner_redd_data |> 
  # clean up dates
  mutate(date_a = as.Date(date, format = "%m/%d/%Y"), # assign date to date_a (for first redd encounter)
         date_b = as.Date(date_b, format = "%m/%d/%Y"), # second redd encounter (if happens)
         date_c = as.Date(date_c, format = "%m/%d/%Y"), # etc.
         date_d = as.Date(date_d, format = "%m/%d/%Y"),
         age_b = ifelse(age_b == "Initial", "2", age_b), # TODO double check what "Initial" is coded as
         age_c = case_when(age_c == "Initial" ~ "2", 
                           age_c == "UNK" ~ NA_character_,
                           TRUE ~ age_c),
         age_d = ifelse(age_d == "NA", NA_character_, age_d),
         age_a = age, # assign age_a the value for age (they record first redd encounter age in "age")
         age_b = as.numeric(age_b),
         age_c = as.numeric(age_c),
         age_d = as.numeric(age_d)) |> 
  select(-c(age)) |> # don't need anymore
  pivot_longer(cols = c(age_a, age_b, age_c, age_d), # pivot all aging instances to age column
               values_to = "new_age",
               names_to = "age_index") |> 
  # for all aging instances, take the date where that aging occurred.
  # check for what aging instance it was and pull that date (if present)
  mutate(new_date = case_when(age_index == "age_b" & !is.na(date_b) ~ date_b,
                          age_index == "age_c" & !is.na(date_c) ~ date_c,
                          age_index == "age_d" & !is.na(date_d) ~ date_d,
                          age_index == "age_a" ~ date_a,
                          TRUE ~ NA),
         age_index = case_when(age_index == "age_a" ~ 1,
                               age_index == "age_b" ~ 2,
                               age_index == "age_c" ~ 3,
                               age_index == "age_d" ~ 4),
         age_index = ifelse(is.na(new_age) & age_index == 1, 0, age_index)) |> 
  filter(!is.na(new_date)) |> 
  select(-c(date, date_a, date_b, date_c, date_d)) |> 
  rename(age = new_age, date = new_date) |> 
  relocate(date, .before = survey_method) |> 
  glimpse()
```

    ## Rows: 2,129
    ## Columns: 32
    ## $ date                       <date> 2002-10-01, 2002-10-01, 2002-10-01, 2002-1…
    ## $ survey_method              <chr> "Snorkel", "Snorkel", "Snorkel", "Snorkel",…
    ## $ longitude                  <dbl> -122, -122, -122, -122, -122, -122, -122, -…
    ## $ latitude                   <dbl> 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40,…
    ## $ reach                      <chr> "R2", "R2", "R2", "R2", "R2", "R2", "R3", "…
    ## $ reach_sub_unit             <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
    ## $ river_mile                 <dbl> 2, 2, 1, 1, 0, 0, 2, 2, 2, 1, 1, 1, 1, 2, 2…
    ## $ run                        <chr> "spring", "spring", "spring", "spring", "sp…
    ## $ redd_id                    <chr> "10102R2#1", "10102R2#2", "10102R2#3", "101…
    ## $ redd_loc                   <chr> "UNK", "UNK", "UNK", "UNK", "UNK", "UNK", "…
    ## $ pre_redd_substrate_size    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
    ## $ redd_substrate_size        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
    ## $ tail_substrate_size        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
    ## $ fish_guarding              <chr> "UNK", "UNK", "UNK", "UNK", "UNK", "UNK", "…
    ## $ redd_measured              <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, F…
    ## $ why_not_measured           <chr> "UNK", "UNK", "UNK", "UNK", "UNK", "UNK", "…
    ## $ pre_redd_depth             <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 10, 15, 15,…
    ## $ redd_pit_depth             <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 16, 24, 19,…
    ## $ redd_tail_depth            <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 8, 13, 13, …
    ## $ redd_length                <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 182, 66, 80…
    ## $ redd_width                 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 72, 43, 42,…
    ## $ flow_meter                 <chr> NA, NA, NA, NA, NA, NA, NA, NA, "Flow Bomb"…
    ## $ flow_fps                   <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 2, 2, 2, NA…
    ## $ start_number_flow_meter    <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 862000, 877…
    ## $ end_number_flow_meter      <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 864537, 880…
    ## $ flow_meter_time            <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 100, 100, 1…
    ## $ start_number_flow_meter_80 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
    ## $ end_number_flow_meter_80   <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
    ## $ flow_meter_time_80         <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
    ## $ survey                     <chr> "11", "11", "11", "11", "11", "11", "11", "…
    ## $ age_index                  <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
    ## $ age                        <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…

``` r
# TODO what is id, fork, serial, corr_type, horz_prec, corr_date, fines_pres, 
# overhead_v, instream_c, cover_comm, stream_fea, tributary, trib_comm, serial
```

## Data Dictionary

The following table describes the variables included in this dataset and
the percent that do not include data.

``` r
percent_na <- clean_redd_data_with_age |>
  summarise_all(list(name = ~sum(is.na(.))/length(.))) |>
  pivot_longer(cols = everything())
  
data_dictionary <- tibble(variables = colnames(clean_redd_data_with_age),
                          description = c("Date of sample",
                                          "Survey method", 
                                          "GPS X point",
                                          "GPS Y point",
                                          "Reach number (1-7)",
                                          "Reach subunit (A-B)",
                                          "River mile number",
                                          "Run designation",
                                          "Unique identifier assigned to redd",
                                          "Redd location (RL, RR, RC)",
                                          "Size of pre-redd substrate. Originally reported in inches; standardized to meters",
                                          "Size of side of redd substrate. Originally reported in inches; standardized to meters",
                                          "Size of gravel in tail of redd. Originally reported in inches; standardized to meters",
                                          "Fish gaurding the redd (T/F)",
                                          "Redd measured (T/F)",
                                          "If the redd was not measured, reason why not (sub sample, too deep, fish on redd)",
                                          "Pre-redd depth. Originally reported in inches; standardized to meters",
                                          "Redd pit depth. Originally reported in inches; standardized to meters",
                                          "Redd tailspill depth. Originally reported in inches; standardized to meters",
                                          "Overall length of disturbed area. Originally reported in inches; standardized to meters",
                                          "Overall width of disturbed area. Originally reported in inches; standardized to meters",
                                          "Flow meter used (digital, flow bomb, flow watch, marsh)",
                                          "Flow immediately upstream of the redd in feet per second.",
                                          "Start number for flow bomb",
                                          "End number for flow bomb",
                                          "Number of seconds elapsed for flow bomb",
                                          "Start number for flow bomb at 80% depth; 80% depth was measured when redd was > 22 ft deep",
                                          "End number for flow bomb at 80% depth; 80% depth was measured when redd was > 22 ft deep",
                                          "Number of seconds elapsed for flow bomb at 80% depth",
                                          "Survey number",
                                          "Redd age assigned",
                                          "Number of times that unique redd has been aged: 0 (no redd aged) - 3 (aged 3x)"),
                          data_type = c("Date", "character", "numeric", "numeric", "character",
                                        "character", "numeric", "character", "character", "character",
                                        "character", "character", "character", "character", "logical",
                                        "character", "numeric", "numeric", "numeric", "numeric",
                                        "numeric","character", "numeric", "numeric", "numeric",
                                        "numeric", "numeric", "numeric", "numeric", "character",
                                        "numeric", "numeric"),
                          percent_na = round(percent_na$value*100)
                          
)
kable(data_dictionary)
```

| variables                  | description                                                                                 | data_type | percent_na |
|:---------------------------|:--------------------------------------------------------------------------------------------|:----------|-----------:|
| date                       | Date of sample                                                                              | Date      |          0 |
| survey_method              | Survey method                                                                               | character |          0 |
| longitude                  | GPS X point                                                                                 | numeric   |          0 |
| latitude                   | GPS Y point                                                                                 | numeric   |          0 |
| reach                      | Reach number (1-7)                                                                          | character |          0 |
| reach_sub_unit             | Reach subunit (A-B)                                                                         | character |         64 |
| river_mile                 | River mile number                                                                           | numeric   |          0 |
| run                        | Run designation                                                                             | character |          0 |
| redd_id                    | Unique identifier assigned to redd                                                          | character |          0 |
| redd_loc                   | Redd location (RL, RR, RC)                                                                  | character |          1 |
| pre_redd_substrate_size    | Size of pre-redd substrate. Originally reported in inches; standardized to meters           | character |         35 |
| redd_substrate_size        | Size of side of redd substrate. Originally reported in inches; standardized to meters       | character |         35 |
| tail_substrate_size        | Size of gravel in tail of redd. Originally reported in inches; standardized to meters       | character |         35 |
| fish_guarding              | Fish gaurding the redd (T/F)                                                                | character |          0 |
| redd_measured              | Redd measured (T/F)                                                                         | logical   |          0 |
| why_not_measured           | If the redd was not measured, reason why not (sub sample, too deep, fish on redd)           | character |          3 |
| pre_redd_depth             | Pre-redd depth. Originally reported in inches; standardized to meters                       | numeric   |         70 |
| redd_pit_depth             | Redd pit depth. Originally reported in inches; standardized to meters                       | numeric   |         70 |
| redd_tail_depth            | Redd tailspill depth. Originally reported in inches; standardized to meters                 | numeric   |         70 |
| redd_length                | Overall length of disturbed area. Originally reported in inches; standardized to meters     | numeric   |         63 |
| redd_width                 | Overall width of disturbed area. Originally reported in inches; standardized to meters      | numeric   |         63 |
| flow_meter                 | Flow meter used (digital, flow bomb, flow watch, marsh)                                     | character |         71 |
| flow_fps                   | Flow immediately upstream of the redd in feet per second.                                   | numeric   |         72 |
| start_number_flow_meter    | Start number for flow bomb                                                                  | numeric   |         73 |
| end_number_flow_meter      | End number for flow bomb                                                                    | numeric   |         73 |
| flow_meter_time            | Number of seconds elapsed for flow bomb                                                     | numeric   |         73 |
| start_number_flow_meter_80 | Start number for flow bomb at 80% depth; 80% depth was measured when redd was \> 22 ft deep | numeric   |         93 |
| end_number_flow_meter_80   | End number for flow bomb at 80% depth; 80% depth was measured when redd was \> 22 ft deep   | numeric   |         93 |
| flow_meter_time_80         | Number of seconds elapsed for flow bomb at 80% depth                                        | numeric   |         93 |
| survey                     | Survey number                                                                               | character |          0 |
| age_index                  | Redd age assigned                                                                           | numeric   |          0 |
| age                        | Number of times that unique redd has been aged: 0 (no redd aged) - 3 (aged 3x)              | numeric   |          3 |

``` r
# saveRDS(data_dictionary, file = "data/battle_redd_data_dictionary.rds")
```

## Explore Numeric Variables:

``` r
clean_redd_data_with_age |> select_if(is.numeric) |> colnames()
```

    ##  [1] "longitude"                  "latitude"                  
    ##  [3] "river_mile"                 "pre_redd_depth"            
    ##  [5] "redd_pit_depth"             "redd_tail_depth"           
    ##  [7] "redd_length"                "redd_width"                
    ##  [9] "flow_fps"                   "start_number_flow_meter"   
    ## [11] "end_number_flow_meter"      "flow_meter_time"           
    ## [13] "start_number_flow_meter_80" "end_number_flow_meter_80"  
    ## [15] "flow_meter_time_80"         "age_index"                 
    ## [17] "age"

### Variable: `longitude`, `latitude`

``` r
summary(clean_redd_data_with_age$latitude)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##      40      40      40      40      40      40

``` r
summary(clean_redd_data_with_age$longitude)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    -122    -122    -122    -122    -122    -122

All values look within an expected range

**NA and Unknown Values**

- 0 % of values in the `latitude` column are NA.
- 0 % of values in the `longitude` column are NA.

### Variable: `river_mile`

**Plotting river mile over Period of Record**

``` r
clean_redd_data_with_age |> 
  ggplot(aes(x = river_mile, y =as.factor(year(date)))) +
  geom_point(size = 1.4, alpha = .5, color = "blue") + 
  labs(x = "River Mile", 
       y = "Date") +
  theme_minimal() + 
  theme(text = element_text(size = 15)) 
```

![](battle_creek_redd_qc_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

It looks like river miles 0 - 4 and 11 - 15 most commonly have redds. In
most recent years almost all the redds are before mile 5.

``` r
clean_redd_data_with_age |> 
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
summary(clean_redd_data_with_age$river_mile)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   0.000   2.000   3.000   4.985   5.000  17.000

**NA and Unknown Values**

- 0 % of values in the `river_mile` column are NA.

### Variable: `pre_redd_depth`

pre redd depth - depth measurement before redd was created (in inches)

Convert to meters to standardize.

``` r
clean_redd_data_with_age$pre_redd_depth <- clean_redd_data_with_age$pre_redd_depth*0.0254
```

**Plotting distribution of pre redd depth**

``` r
clean_redd_data_with_age |>
  ggplot(aes(x = pre_redd_depth)) +
  geom_histogram() +
  labs(x = "Redd Depth", 
       y = "Count") +
  theme_minimal() + 
  theme(text = element_text(size = 15)) 
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](battle_creek_redd_qc_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

**Numeric Summary of pre redd depth over Period of Record**

``` r
summary(clean_redd_data_with_age$pre_redd_depth)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  0.0000  0.2794  0.3810  0.3847  0.5080  1.2700    1493

**NA and Unknown Values**

- 70.1 % of values in the `pre_redd_depth` column are NA.
- There are a lot of 0 values. Could these also be NA?

### Variable: `redd_pit_depth`

Convert to meters to standardize.

``` r
clean_redd_data_with_age$redd_pit_depth <- clean_redd_data_with_age$redd_pit_depth*0.0254
```

**Plotting distribution of redd pit depth**

``` r
clean_redd_data_with_age |> 
  ggplot(aes(x = redd_pit_depth)) +
  geom_histogram() +
  labs(x = "River Pit Depth", 
       y = "Count") +
  theme_minimal() + 
  theme(text = element_text(size = 15)) 
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](battle_creek_redd_qc_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

**Numeric Summary of Redd pit depth over Period of Record**

``` r
summary(clean_redd_data_with_age$redd_pit_depth)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  0.0000  0.4064  0.5334  0.5046  0.6604  1.4224    1495

**NA and Unknown Values**

- 70.2 % of values in the `redd_pit_depth` column are NA.
- There are a lot of 0 values. Could these be NA?

### Variable: `redd_tail_depth`

Convert to meters to standardize.

``` r
clean_redd_data_with_age$redd_tail_depth <- clean_redd_data_with_age$redd_tail_depth*0.0254
```

**Plotting distribution of redd tail depth**

``` r
clean_redd_data_with_age |> 
  ggplot(aes(x = redd_tail_depth)) +
  geom_histogram() +
  labs(x = "Redd tail depth", 
       y = "count") +
  theme_minimal() + 
  theme(text = element_text(size = 15)) 
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](battle_creek_redd_qc_files/figure-gfm/unnamed-chunk-16-1.png)<!-- -->

**Numeric Summary of Redd tail depth over Period of Record**

``` r
summary(clean_redd_data_with_age$redd_tail_depth)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  0.0000  0.1524  0.2286  0.2394  0.3302  0.9398    1496

**NA and Unknown Values**

- 70.3 % of values in the `redd_tail_depth` column are NA.
- There are a lot of 0 values. Could these be NA?

### Variable: `redd_length`

Convert to meters to standardize.

``` r
clean_redd_data_with_age$redd_length <- clean_redd_data_with_age$redd_length*0.0254
```

**Plotting distribution of redd length**

``` r
clean_redd_data_with_age |> 
  ggplot(aes(x = redd_length)) +
  geom_histogram() +
  labs(x = "Redd Length (m)", 
       y = "Count") +
  theme_minimal() + 
  theme(text = element_text(size = 15)) 
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](battle_creek_redd_qc_files/figure-gfm/unnamed-chunk-19-1.png)<!-- -->

**Numeric Summary of Redd length over Period of Record**

``` r
summary(clean_redd_data_with_age$redd_length)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.000   2.515   3.810   3.783   5.131  11.557    1342

**NA and Unknown Values**

- 63 % of values in the `redd_length` column are NA.
- There are a lot of 0 values. Could these be NA?

### Variable: `redd_width`

Convert to meters to standardize.

``` r
clean_redd_data_with_age$redd_width <- clean_redd_data_with_age$redd_width*0.0254
```

**Plotting distribution of redd width**

``` r
clean_redd_data_with_age |> 
  ggplot(aes(x = redd_width)) +
  geom_histogram() +
  labs(x = "Redd Width (m)", 
       y = "Count") +
  theme_minimal() + 
  theme(text = element_text(size = 15)) 
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](battle_creek_redd_qc_files/figure-gfm/unnamed-chunk-22-1.png)<!-- -->

**Numeric Summary of Redd width over Period of Record**

``` r
summary(clean_redd_data_with_age$redd_width)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.000   1.346   1.981   2.071   2.718   6.858    1343

**NA and Unknown Values**

- 63.1 % of values in the `redd_width` column are NA.
- There are a lot of 0 values. Could these be NA?

### Variable: `flow_fps`

**Plotting distribution of flow feet per second**

``` r
clean_redd_data_with_age |> 
  ggplot(aes(x = flow_fps)) +
  geom_histogram() +
  labs(x = "Flow Feet per second", 
       y = "Count") +
  theme_minimal() + 
  theme(text = element_text(size = 15)) 
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](battle_creek_redd_qc_files/figure-gfm/unnamed-chunk-24-1.png)<!-- -->

``` r
clean_redd_data_with_age |> 
  ggplot(aes(x = flow_fps, y = reach)) +
  geom_boxplot() +
  labs(x = "Flow Feet Per Second", 
       y = "Reach") +
  theme_minimal() + 
  theme(text = element_text(size = 15)) 
```

![](battle_creek_redd_qc_files/figure-gfm/unnamed-chunk-25-1.png)<!-- -->
**Numeric Summary of flow over Period of Record**

``` r
summary(clean_redd_data_with_age$flow_fps)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.000   1.000   1.500   1.475   2.000   5.000    1525

**NA and Unknown Values**

- 71.6 % of values in the `flow_fps` column are NA.
- There are a lot of 0 values. Could these be NA?

### Variables: `start_flow_meter`, `start_flow_meter_80`

**Plotting distribution of flow number start per second**

``` r
p1 <- clean_redd_data_with_age |> 
  ggplot(aes(x = start_number_flow_meter)) +
  geom_histogram() +
  labs(x = "Start Number", 
       y = "Count") +
  theme_minimal() + 
  theme(text = element_text(size = 15)) 

p2 <- clean_redd_data_with_age |> 
  ggplot(aes(x = start_number_flow_meter_80)) +
  geom_histogram() +
  labs(x = "Start Number 80%", 
       y = "Count") +
  theme_minimal() + 
  theme(text = element_text(size = 15)) 

gridExtra::grid.arrange(p1, p2)
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](battle_creek_redd_qc_files/figure-gfm/unnamed-chunk-27-1.png)<!-- -->

Very few records of start number at 80% depth. Most of these are 0.

**Numeric Summary of flow over Period of Record**

``` r
summary(clean_redd_data_with_age$start_number_flow_meter)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##       0   99110  336000  389252  645750  998000    1551

``` r
summary(clean_redd_data_with_age$start_number_flow_meter_80)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##       0       0       0    9299       0  496000    1985

**NA and Unknown Values**

- 72.9 % of values in the `start_number_flow_meter` column are NA.
- 93.2 % of values in the `start_number_flow_meter_80` column are NA.
- There are a lot of 0 values. Could these be NA?

### Variables: `end_number_flow_meter`, `end_number_flow_meter_80`

**Plotting distribution of flow meter end number per second**

``` r
p1 <- clean_redd_data_with_age |> 
  ggplot(aes(x = end_number_flow_meter)) +
  geom_histogram() +
  labs(x = "End Number", 
       y = "Count") +
  theme_minimal() + 
  theme(text = element_text(size = 15)) 

p2 <- clean_redd_data_with_age |> 
  ggplot(aes(x = end_number_flow_meter_80)) +
  geom_histogram() +
  labs(x = "End Number 80%", 
       y = "Count") +
  theme_minimal() + 
  theme(text = element_text(size = 15)) 

gridExtra::grid.arrange(p1, p2)
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](battle_creek_redd_qc_files/figure-gfm/unnamed-chunk-29-1.png)<!-- -->

Very few records of end number at 80% depth. Most of these are 0.

**Numeric Summary of flow over Period of Record**

``` r
summary(clean_redd_data_with_age$start_number_flow_meter)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##       0   99110  336000  389252  645750  998000    1551

``` r
summary(clean_redd_data_with_age$end_number_flow_meter_80)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##       0       0       0    9332       0  497472    1985

**NA and Unknown Values**

- 72.9 % of values in the `end_number_flow_meter` column are NA.
- 93.2 % of values in the `end_number_flow_meter_80` column are NA.
- There are a lot of 0 values. Could these be NA?

### Variables: `flow_meter_time`, `flow_meter_time_80`

Start number for flow bomb at 80% depth; 80% depth was measured when the
redd was \>22” deep

**Plotting distribution of flow meter end number per second**

``` r
p1 <- clean_redd_data_with_age |> 
  ggplot(aes(x = flow_meter_time)) +
  geom_histogram() +
  labs(x = "Time Seconds", 
       y = "Count") +
  theme_minimal() + 
  theme(text = element_text(size = 15)) 

p2 <- clean_redd_data_with_age |> 
  ggplot(aes(x = flow_meter_time_80)) +
  geom_histogram() +
  labs(x = "Time Seconds 80%", 
       y = "Count") +
  theme_minimal() + 
  theme(text = element_text(size = 15)) 

gridExtra::grid.arrange(p1, p2)
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](battle_creek_redd_qc_files/figure-gfm/unnamed-chunk-31-1.png)<!-- -->

Most (all for Time 80) of the flow meter times are at 100 seconds.

**Numeric Summary of flow over Period of Record**

``` r
summary(clean_redd_data_with_age$flow_meter_time)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00  100.00  100.00   99.41  100.00  150.00    1551

``` r
summary(clean_redd_data_with_age$flow_meter_time_80)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##     100     100     100     100     100     100    1985

**NA and Unknown Values**

- 72.9 % of values in the `flow_meter_time` column are NA.
- 93.2 % of values in the `flow_meter_time_80` column are NA.

### Variables: `age_index`

Age Index refers to the number of times a unique redd has been surveyed.
If `age_index == 0`, the redd was not aged.

**Plotting distribution of age index**

``` r
clean_redd_data_with_age |> 
  ggplot(aes(x = age_index)) +
  geom_histogram() +
  labs(x = "Number of times sampled", 
       y = "Count") +
  theme_minimal() + 
  theme(text = element_text(size = 15))
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](battle_creek_redd_qc_files/figure-gfm/unnamed-chunk-33-1.png)<!-- -->

Most redds are aged at least once.

**Numeric Summary of age index over Period of Record**

``` r
summary(clean_redd_data_with_age$age_index)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   0.000   1.000   1.000   1.289   1.000   3.000

``` r
summary(clean_redd_data_with_age$age_index)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   0.000   1.000   1.000   1.289   1.000   3.000

**NA and Unknown Values**

- 0 % of values in the `age_index` column are NA.
- 0 % of values in the `age_index` column are NA.

### Variables: `age`

Age refers to the assigned age of a redd.

**Plotting distribution of age**

``` r
clean_redd_data_with_age |> 
  ggplot(aes(x = age)) +
  geom_histogram() +
  labs(x = "Redd age", 
       y = "Count") +
  theme_minimal() + 
  theme(text = element_text(size = 15))
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](battle_creek_redd_qc_files/figure-gfm/unnamed-chunk-35-1.png)<!-- -->

Most redds are age `2` to `3`.

**Numeric Summary of ageover Period of Record**

``` r
summary(clean_redd_data_with_age$age)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.000   2.000   2.000   2.045   2.000   5.000      69

``` r
summary(clean_redd_data_with_age$age)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   0.000   2.000   2.000   2.045   2.000   5.000      69

**NA and Unknown Values**

- 3.2 % of values in the `age` column are NA.
- 3.2 % of values in the `age` column are NA.

## Explore Categorical variables:

``` r
clean_redd_data_with_age |> select_if(is.character) |> colnames()
```

    ##  [1] "survey_method"           "reach"                  
    ##  [3] "reach_sub_unit"          "run"                    
    ##  [5] "redd_id"                 "redd_loc"               
    ##  [7] "pre_redd_substrate_size" "redd_substrate_size"    
    ##  [9] "tail_substrate_size"     "fish_guarding"          
    ## [11] "why_not_measured"        "flow_meter"             
    ## [13] "survey"

### Variable: `survey_method`

``` r
table(clean_redd_data_with_age$survey_method) 
```

    ## 
    ## Snorkel Walking 
    ##    2116      13

**NA and Unknown Values**

- 0 % of values in the `survey_method` column are NA.

### Variable: `reach`

``` r
table(clean_redd_data_with_age$reach) 
```

    ## 
    ##  R1  R2  R3  R4  R5  R6  R7 
    ## 559 674 353 354 112  60  17

**NA and Unknown Values**

- 0 % of values in the `reach`column are NA.

### Variable: `reach_sub_unit`

``` r
table(clean_redd_data_with_age$reach_sub_unit) 
```

    ## 
    ##   A   B 
    ## 470 298

**NA and Unknown Values**

- 63.9 % of values in the `reach_sub_unit`column are NA.

### Variable: `run`

``` r
table(clean_redd_data_with_age$run) 
```

    ## 
    ## spring 
    ##   2129

All records are for spring run fish.

**NA and Unknown Values**

- 0 % of values in the `run`column are NA.

### Variable: `redd_id`

``` r
length(unique(clean_redd_data_with_age$redd_id))
```

    ## [1] 722

**NA and Unknown Values**

- 0 % of values in the `redd_id`column are NA.

### Variable: \`redd_loc\`\`

``` r
table(clean_redd_data_with_age$redd_loc) 
```

    ## 
    ##  RC  RL  RR UNK 
    ## 662 583 663 191

**NA and Unknown Values**

- 1.4 % of values in the `redd_loc`column are NA.

### Variable: `pre_redd_substrate_size`

``` r
table(clean_redd_data_with_age$pre_redd_substrate_size) 
```

    ## 
    ##  .1 to 1      <.1     <0.1      >12 0.1 to 1    0.1-1        1   1 to 2 
    ##       24        1        8        7      171        5       44      405 
    ##   1 to 3   1 to 5   2 to 3   2 to 4   3 to 4   3 to 5   4 to 5   4 to 6 
    ##      428        3       87      147       18       29        5       11

Fix inconsistencies with spelling, capitalization, and abbreviations.

``` r
clean_redd_data_with_age$pre_redd_substrate_size <- if_else(
  clean_redd_data_with_age$pre_redd_substrate_size == ".1 to 1" | 
  clean_redd_data_with_age$pre_redd_substrate_size == "0.1-1", "0.1 to 1", clean_redd_data_with_age$pre_redd_substrate_size
)

clean_redd_data_with_age$pre_redd_substrate_size <- if_else(
  clean_redd_data_with_age$pre_redd_substrate_size == "<.1", "<0.1", clean_redd_data_with_age$pre_redd_substrate_size
)
table(clean_redd_data_with_age$pre_redd_substrate_size) 
```

    ## 
    ##     <0.1      >12 0.1 to 1        1   1 to 2   1 to 3   1 to 5   2 to 3 
    ##        9        7      200       44      405      428        3       87 
    ##   2 to 4   3 to 4   3 to 5   4 to 5   4 to 6 
    ##      147       18       29        5       11

**NA and Unknown Values**

- 34.6 % of values in the `pre_redd_substrate_size` column are NA.

### Variable: `redd_substrate_size`

``` r
table(clean_redd_data_with_age$redd_substrate_size) 
```

    ## 
    ##  .1 to 1      <.1      >12 0.1 to 1    0.1-1        1   1 to 2   1 to 3 
    ##       14        1       16      108        1       36      447      458 
    ##   1 to 5   2 to 3   2 to 4   3 to 4   3 to 5   4 to 5   4 to 6       NA 
    ##        4      116      147       13       24        1        6        1

Fix inconsistencies with spelling, capitalization, and abbreviations.

``` r
clean_redd_data_with_age$redd_substrate_size <- if_else(
  clean_redd_data_with_age$redd_substrate_size == ".1 to 1" | 
  clean_redd_data_with_age$redd_substrate_size == "0.1-1", "0.1 to 1", clean_redd_data_with_age$redd_substrate_size
)

clean_redd_data_with_age$redd_substrate_size <- if_else(
  clean_redd_data_with_age$redd_substrate_size == "<.1", "<0.1", clean_redd_data_with_age$redd_substrate_size
)

clean_redd_data_with_age$redd_substrate_size <- ifelse(
  clean_redd_data_with_age$redd_substrate_size == "NA", NA, clean_redd_data_with_age$redd_substrate_size
)
table(clean_redd_data_with_age$redd_substrate_size) 
```

    ## 
    ##     <0.1      >12 0.1 to 1        1   1 to 2   1 to 3   1 to 5   2 to 3 
    ##        1       16      123       36      447      458        4      116 
    ##   2 to 4   3 to 4   3 to 5   4 to 5   4 to 6 
    ##      147       13       24        1        6

**NA and Unknown Values**

- 34.6 % of values in the `redd_substrate_size` column are NA.

### Variable: `tail_substrate_size`

``` r
table(clean_redd_data_with_age$tail_substrate_size) 
```

    ## 
    ##  .1 to 1 0.1 to 1    0.1-1        1   1 to 2   1 to 3   2 to 3   2 to 4 
    ##        4        5        2        3      548      616       99      102 
    ##   3 to 4   3 to 5       NA 
    ##       10        3        1

Fix inconsistencies with spelling, capitalization, and abbreviations.

``` r
clean_redd_data_with_age$tail_substrate_size <- if_else(
  clean_redd_data_with_age$tail_substrate_size == ".1 to 1" | 
  clean_redd_data_with_age$tail_substrate_size == "0.1-1", "0.1 to 1", clean_redd_data_with_age$tail_substrate_size
)


clean_redd_data_with_age$tail_substrate_size <- ifelse(
  clean_redd_data_with_age$tail_substrate_size == "NA", NA, clean_redd_data_with_age$tail_substrate_size
)
table(clean_redd_data_with_age$tail_substrate_size) 
```

    ## 
    ## 0.1 to 1        1   1 to 2   1 to 3   2 to 3   2 to 4   3 to 4   3 to 5 
    ##       11        3      548      616       99      102       10        3

**NA and Unknown Values**

- 34.6 % of values in the `tail_substrate_size` column are NA.

### Variable: `fish_guarding`

``` r
table(clean_redd_data_with_age$fish_guarding) 
```

    ## 
    ##   No   NO  UNK  Yes  YES 
    ##   27 1370  342    1  388

Fix inconsistencies with spelling, capitalization, and abbreviations.

``` r
clean_redd_data_with_age$fish_guarding <- case_when(
  clean_redd_data_with_age$fish_guarding == "No" | clean_redd_data_with_age$fish_guarding == "NO" ~FALSE, 
  clean_redd_data_with_age$fish_guarding == "Yes" | clean_redd_data_with_age$fish_guarding == "YES" ~TRUE
)

table(clean_redd_data_with_age$fish_guarding) 
```

    ## 
    ## FALSE  TRUE 
    ##  1397   389

**NA and Unknown Values**

- 16.1 % of values in the `fish_guarding` column are NA.

### Variable: `redd_measured`

``` r
table(clean_redd_data_with_age$redd_measured) 
```

    ## 
    ## FALSE  TRUE 
    ##  1402   727

Fix inconsistencies with spelling, capitalization, and abbreviations.

``` r
clean_redd_data_with_age$redd_measured <- case_when(
  clean_redd_data_with_age$redd_measured == "NO"  ~ FALSE, 
  clean_redd_data_with_age$redd_measured == "YES" ~ TRUE
)

table(clean_redd_data_with_age$redd_measured) 
```

    ## < table of extent 0 >

**NA and Unknown Values**

- 100 % of values in the `redd_measured` column are NA.

### Variable: `why_not_measured`

``` r
table(clean_redd_data_with_age$why_not_measured) 
```

    ## 
    ## Fish on redd FISH ON REDD   Sub-Sample   SUB-SAMPLE     Too Deep          UNK 
    ##            5            3           80           54            1         1915

Fix inconsistencies with spelling, capitalization, and abbreviations.

``` r
clean_redd_data_with_age$why_not_measured <- case_when(
  clean_redd_data_with_age$why_not_measured == "Fish on redd" | 
    clean_redd_data_with_age$why_not_measured == "FISH ON REDD"  ~ "fish on redd", 
  clean_redd_data_with_age$why_not_measured == "Sub-Sample" | 
    clean_redd_data_with_age$why_not_measured == "SUB-SAMPLE"  ~ "sub sample", 
  clean_redd_data_with_age$why_not_measured == "Too Deep" ~ "too deep", 
)

table(clean_redd_data_with_age$why_not_measured) 
```

    ## 
    ## fish on redd   sub sample     too deep 
    ##            8          134            1

**NA and Unknown Values**

- 93.3 % of values in the `why_not_measured` column are NA.

### Variable: `flow_meter`

``` r
table(clean_redd_data_with_age$flow_meter) 
```

    ## 
    ##    Digital  flow bomb  Flow bomb  Flow Bomb Flow Watch      Marsh        Unk 
    ##         17         35          1        543          4          2          2 
    ##        UNK 
    ##          3

Fix inconsistencies with spelling, capitalization, and abbreviations.

``` r
clean_redd_data_with_age$flow_meter <- case_when(
  clean_redd_data_with_age$flow_meter %in% c("flow bomb", "Flow Bomb", "Flow bomb")  ~ "flow bomb", 
  clean_redd_data_with_age$flow_meter == "Digital" ~ "digital",
  clean_redd_data_with_age$flow_meter == "Flow Watch"  ~ "flow watch", 
  clean_redd_data_with_age$flow_meter == "Marsh" ~ "marsh", 
)

table(clean_redd_data_with_age$flow_meter) 
```

    ## 
    ##    digital  flow bomb flow watch      marsh 
    ##         17        579          4          2

**NA and Unknown Values**

- 71.7 % of values in the `flow_meter` column are NA.

### Variable: `survey`

``` r
table(clean_redd_data_with_age$survey)
```

    ## 
    ##   0   1  10  11  12  13  14   2   3   4   5   6   7   8   9 
    ## 918 249  57  15  10  38  15 228 164  83 112  44  53  55  88

**NA and Unknown Values**

- 0 % of values in the `survey` column are NA.

## Summary of identified issues

- there are a lot of zero values for the physical characteristics of
  redds, need to figure out if these are not measured values or are
  actually zero

## Next steps

### Columns to remove

- `comments`, `why_not_measured`, `flow_meter`, `flow_fps`,
  `start_number_flow_meter`, `end_number_flow_meter`, `flow_meter_time`,
  `start_number_flow_meter_80`, `end_number_flow_meter_80`,
  `flow_meter_time_80` have little data and may not be needed.
- The most important variables are `longitude`, `latitude`, `date`,
  `redd_measured`, `redd_id`, `age`, and `age_index`

## Save cleaned data back to google cloud

``` r
battle_redd <- clean_redd_data_with_age |> glimpse()
```

    ## Rows: 2,129
    ## Columns: 32
    ## $ date                       <date> 2002-10-01, 2002-10-01, 2002-10-01, 2002-1…
    ## $ survey_method              <chr> "Snorkel", "Snorkel", "Snorkel", "Snorkel",…
    ## $ longitude                  <dbl> -122, -122, -122, -122, -122, -122, -122, -…
    ## $ latitude                   <dbl> 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40,…
    ## $ reach                      <chr> "R2", "R2", "R2", "R2", "R2", "R2", "R3", "…
    ## $ reach_sub_unit             <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
    ## $ river_mile                 <dbl> 2, 2, 1, 1, 0, 0, 2, 2, 2, 1, 1, 1, 1, 2, 2…
    ## $ run                        <chr> "spring", "spring", "spring", "spring", "sp…
    ## $ redd_id                    <chr> "10102R2#1", "10102R2#2", "10102R2#3", "101…
    ## $ redd_loc                   <chr> "UNK", "UNK", "UNK", "UNK", "UNK", "UNK", "…
    ## $ pre_redd_substrate_size    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
    ## $ redd_substrate_size        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
    ## $ tail_substrate_size        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
    ## $ fish_guarding              <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
    ## $ redd_measured              <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
    ## $ why_not_measured           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
    ## $ pre_redd_depth             <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 0.2540, 0.3…
    ## $ redd_pit_depth             <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 0.4064, 0.6…
    ## $ redd_tail_depth            <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 0.2032, 0.3…
    ## $ redd_length                <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 4.6228, 1.6…
    ## $ redd_width                 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 1.8288, 1.0…
    ## $ flow_meter                 <chr> NA, NA, NA, NA, NA, NA, NA, NA, "flow bomb"…
    ## $ flow_fps                   <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 2, 2, 2, NA…
    ## $ start_number_flow_meter    <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 862000, 877…
    ## $ end_number_flow_meter      <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 864537, 880…
    ## $ flow_meter_time            <dbl> NA, NA, NA, NA, NA, NA, NA, NA, 100, 100, 1…
    ## $ start_number_flow_meter_80 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
    ## $ end_number_flow_meter_80   <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
    ## $ flow_meter_time_80         <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
    ## $ survey                     <chr> "11", "11", "11", "11", "11", "11", "11", "…
    ## $ age_index                  <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
    ## $ age                        <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…

``` r
# gcs_list_objects()
f <- function(input, output) write_csv(input, file = output)

gcs_upload(battle_redd,
           object_function = f,
           type = "csv",
           name = "adult-holding-redd-and-carcass-surveys/battle-creek/data/battle_redd.csv")
```
