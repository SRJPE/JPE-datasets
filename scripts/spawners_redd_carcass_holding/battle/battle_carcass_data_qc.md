Battle Creek Carcass Survey QC
================
Erin Cain
9/29/2021

# Battle Creek Carcass Survey QC

## Description of Monitoring Data

These data were aquired via snorkel and kayak surveys on Battle Creek
from 1996 to 2019 and describe spring-run and unknown run Chinook Salmon
carcasses found within and along Battle Creek.

**Timeframe:** 1996 - 2019

**Survey Season:**

**Completeness of Record throughout timeframe:**

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
raw_carcass_data <- read_excel("raw_adult_spawn_hold_carcass.xlsx", sheet = "Carcass") %>% glimpse()
```

    ## Rows: 1,625
    ## Columns: 18
    ## $ LONGITUDE           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ LATITUDE            <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ RIVERMILE           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ SPAWN_YEAR          <dbl> 1996, 1996, 1996, 1997, 1997, 1997, 1997, 1997, 19~
    ## $ DATE                <chr> "10/1/1996", "10/1/1996", "10/9/1996", "35500", "3~
    ## $ METHOD              <chr> "Snorkel Survey", "Snorkel Survey", "Snorkel Surve~
    ## $ LOCATION            <chr> NA, NA, NA, "CNFH", "CNFH", "CNFH", "CNFH", "CNFH"~
    ## $ SPECIES             <chr> "Chinook", "Chinook", "Chinook", "Chinook", "Chino~
    ## $ SEX                 <chr> "Unknown", "Male", "Unknown", "Female", "Female", ~
    ## $ OBSERVED_ONLY       <chr> "N", "N", "N", "N", "N", "N", "N", "N", "N", "N", ~
    ## $ FORK_LENGTH         <dbl> NA, NA, NA, 716, 843, 865, 510, 730, 642, 810, 814~
    ## $ ADIPOSE             <chr> "Present", "Present", "Present", "Absent", "Absent~
    ## $ CARCASS_LIVE_STATUS <chr> "Unknown", "Unknown", "Unknown", "Unknown", "Unkno~
    ## $ SPAWN_CONDITION     <chr> "Unknown", "Unknown", "Unknown", "Unknown", "Unkno~
    ## $ FWS_RUN_CALL        <chr> "SCS", "SCS", "SCS", "Unknown", "Unknown", "Unknow~
    ## $ CWT_CODE            <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ OTHER_TAG           <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ Comments            <chr> NA, NA, NA, "Couldn't locate samples 6/2014", "Cou~

## Data transformations

``` r
cleaner_carcass_data <- raw_carcass_data %>%
  janitor::clean_names() %>% glimpse()
```

    ## Rows: 1,625
    ## Columns: 18
    ## $ longitude           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ latitude            <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ rivermile           <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ spawn_year          <dbl> 1996, 1996, 1996, 1997, 1997, 1997, 1997, 1997, 19~
    ## $ date                <chr> "10/1/1996", "10/1/1996", "10/9/1996", "35500", "3~
    ## $ method              <chr> "Snorkel Survey", "Snorkel Survey", "Snorkel Surve~
    ## $ location            <chr> NA, NA, NA, "CNFH", "CNFH", "CNFH", "CNFH", "CNFH"~
    ## $ species             <chr> "Chinook", "Chinook", "Chinook", "Chinook", "Chino~
    ## $ sex                 <chr> "Unknown", "Male", "Unknown", "Female", "Female", ~
    ## $ observed_only       <chr> "N", "N", "N", "N", "N", "N", "N", "N", "N", "N", ~
    ## $ fork_length         <dbl> NA, NA, NA, 716, 843, 865, 510, 730, 642, 810, 814~
    ## $ adipose             <chr> "Present", "Present", "Present", "Absent", "Absent~
    ## $ carcass_live_status <chr> "Unknown", "Unknown", "Unknown", "Unknown", "Unkno~
    ## $ spawn_condition     <chr> "Unknown", "Unknown", "Unknown", "Unknown", "Unkno~
    ## $ fws_run_call        <chr> "SCS", "SCS", "SCS", "Unknown", "Unknown", "Unknow~
    ## $ cwt_code            <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ other_tag           <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ comments            <chr> NA, NA, NA, "Couldn't locate samples 6/2014", "Cou~

## Explore Numeric Variables:

``` r
# Filter clean data to show only numeric variables 
```

### Variable: `[name]`

**Plotting \[Variable\] over Period of Record**

``` r
# Make whatever plot is appropriate 
# maybe 2+ plots are appropriate
```

**Numeric Summary of \[Variable\] over Period of Record**

``` r
# Table with summary statistics
```

**NA and Unknown Values**

Provide a stat on NA or unknown values

## Explore Categorical variables:

General notes: If there is an opportunity to turn yes no into boolean do
so, but not if you loose value

``` r
# Filter clean data to show only categorical variables
```

### Variable: `[name]`

``` r
#table() 
```

Fix inconsistencies with spelling, capitalization, and abbreviations.

``` r
# Fix any inconsistencies with categorical variables
```

**Create lookup rda for \[variable\] encoding:**

``` r
# Create named lookup vector
# Name rda [watershed]_[data type]_[variable_name].rda
# save rda to data/ 
```

**NA and Unknown Values**

Provide a stat on NA or unknown values

## Summary of identified issues

-   List things that are funcky/bothering us but that we don’t feel like
    should be changed without more investigation

## Save cleaned data back to google cloud

``` r
# Write to google cloud 
# Name file [watershed]_[data type].csv
```
