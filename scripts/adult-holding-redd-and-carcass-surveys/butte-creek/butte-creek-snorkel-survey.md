Butte Creek Snorkel Survey QC
================
Erin Cain
9/29/2021

# Butte Creek Adult Snorkel Survey: Holding Data

## Description of Monitoring Data

Butte Creek snorkel holding data was shared by Claire Bryant. This data
was shared in multi tab spreadsheets.

**Timeframe:** 2001 - 2019

**Snorkel Season:** Snorkel Survey is conducted in July or August

**Completeness of Record throughout timeframe:**

**Sampling Location:** Butte Creek

**Data Contact:**

Claire Bryant

## Access Cloud Data

``` r
# Run Sys.setenv() to specify GCS_AUTH_FILE and GCS_DEFAULT_BUCKET before running 
getwd() #to see how to specify paths 
# Open object from google cloud storage
# Set your authentication using gcs_auth
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
# Set global bucket 
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

gcs_list_objects()
# git data and save as xlsx
gcs_get_object(object_name = "adult-holding-redd-and-carcass-surveys/butte-creek/data-raw/Butte 2001 Snorkel Modified.xls",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "ButteSnorkel2021.xls",
               overwrite = TRUE)
```

Read in data from google cloud, glimpse raw data and domain description
sheet:

``` r
butte_snorkel <- readxl::read_excel("ButteSnorkel2021.xls") %>% glimpse()
```

    ## New names:
    ## * `` -> ...1
    ## * `` -> ...2
    ## * `` -> ...3
    ## * `` -> ...4
    ## * `` -> ...6
    ## * ...

    ## Rows: 64
    ## Columns: 9
    ## $ ...1                  <chr> NA, NA, "Section", "Date", "Temp", NA, NA, NA, N~
    ## $ ...2                  <chr> NA, NA, "Quartz Bowl to Whiskey Flat", "37117", ~
    ## $ ...3                  <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, "Curtis"~
    ## $ ...4                  <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, "Mike", ~
    ## $ `Butte Creek Snorkel` <chr> "37104", NA, NA, NA, NA, NA, NA, NA, NA, NA, "Ad~
    ## $ ...6                  <chr> NA, NA, "NGC= Not a GOOD COUNT", "DNS= DID NOT S~
    ## $ ...7                  <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, "Low", "~
    ## $ ...8                  <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, "High", ~
    ## $ ...9                  <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, "Comment~

## Data transformations

``` r
# For different excel sheets for each year read in and combine years here
```

``` r
# Snake case, 
# Columns are appropriate types
# Remove redundant columns
```

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
