Feather River CWT - Broodstock QC
================
Erin Cain
9/29/2021

# Feather River CWT - Broodstock Data

## Description of Monitoring Data

This dataset includes the CWT data collected so far at the Feather River
Hatchery for the 2021 season.

**Timeframe:** 2021 (partial)

**Data Contact:** [Lea Koerber](mailto:Lea.Koerber@wildlife.ca.gov)

**Metadata Shared by Lea**

| Sex         | RMIS Run      | Condition              |
|-------------|---------------|------------------------|
| 1 = Male    | 1 = Spring    | 1 = Killed NOT Spawned |
| 2 = Female  | 3 = Fall      | 2 = Dead in Pond       |
| 9 = Unknown | 7 = Late-fall | 3 = Spawned            |

*Additional Note*: Following up with OSP people regarding data for full
period of record.

## Access Cloud Data

``` r
# Run Sys.setenv() to specify GCS_AUTH_FILE and GCS_DEFAULT_BUCKET before running 
# getwd() to see how to specify paths 
# Open object from google cloud storage
# Set your authentication using gcs_auth
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
# Set global bucket 
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

gcs_list_objects()
# git data and save as xlsx
read_from_cloud <- function(year){
  gcs_get_object(object_name = paste0("adult-upstream-passage-monitoring/feather-river/CWT/data-raw/2021-09-", year, "_FRFH_tblOutput.xlsx"),
               bucket = gcs_get_global_bucket(),
               saveToDisk = paste0("raw_feather_cwt_", year, ".xlsx"),
               overwrite = TRUE)
  data <- read_excel(paste0("raw_feather_cwt_", year, ".xlsx"))
}
years <- c(14, 15, 17, 20, 21, 22)
raw_data <- purrr::map(years, read_from_cloud) %>%
  reduce(bind_rows)

write_csv(raw_data, "raw_cwt_data.csv")
```

Read in data from google cloud, glimpse raw data and domain description
sheet:

``` r
# read in data to clean 
raw_cwt_data <- read_csv("raw_cwt_data.csv") %>% glimpse
```

    ## 
    ## -- Column specification --------------------------------------------------------
    ## cols(
    ##   .default = col_double(),
    ##   Lab = col_character(),
    ##   RecoveryLocCode = col_character(),
    ##   RecoveryLoc = col_character(),
    ##   RecoveryLocName = col_character(),
    ##   SMPLR_SPP = col_character(),
    ##   SAMPLR_RUN = col_character(),
    ##   SAMPLR_RUNAM = col_character(),
    ##   RECDATE = col_datetime(format = ""),
    ##   RECOVERY = col_character(),
    ##   CWT = col_character(),
    ##   Remarks = col_logical(),
    ##   tag_code_or_release_id = col_character(),
    ##   RMIS = col_character(),
    ##   ZoneDE = col_character(),
    ##   RMIS_Spp = col_character(),
    ##   hatchery_location_name = col_character(),
    ##   release_location_name = col_character(),
    ##   RMIS_Comments = col_character(),
    ##   reporting_agency = col_character(),
    ##   THIRD_READ = col_character()
    ##   # ... with 5 more columns
    ## )
    ## i Use `spec()` for the full column specifications.

    ## Rows: 190
    ## Columns: 50
    ## $ Lab                    <chr> "CADFG", "CADFG", "CADFG", "CADFG", "CADFG", "C~
    ## $ HEADTAG                <dbl> 88000, 88001, 88002, 88003, 88004, 88005, 88006~
    ## $ RecoveryLocCode        <chr> "6FCSAFEA FRFH", "6FCSAFEA FRFH", "6FCSAFEA FRF~
    ## $ RecoveryLoc            <chr> "FRFH", "FRFH", "FRFH", "FRFH", "FRFH", "FRFH",~
    ## $ RecoveryLocName        <chr> "Feather River Fish Hatchery", "Feather River F~
    ## $ FISHERY                <dbl> 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50,~
    ## $ SMPLR_SPP              <chr> "K", "K", "K", "K", "K", "K", "K", "K", "K", "K~
    ## $ FL_CM                  <dbl> 66.1, 67.5, 75.4, 71.6, 61.0, 83.1, 82.4, 84.3,~
    ## $ FLmm1                  <dbl> 661, 675, 754, 716, 610, 831, 824, 843, 781, 80~
    ## $ SAMPLR_RUN             <chr> "F", "F", "F", "F", "F", "F", "F", "F", "F", "F~
    ## $ SAMPLR_RUNAM           <chr> "Fall", "Fall", "Fall", "Fall", "Fall", "Fall",~
    ## $ Sex1                   <dbl> 1, 1, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,~
    ## $ RECDATE                <dttm> 2021-09-14, 2021-09-14, 2021-09-14, 2021-09-14~
    ## $ RECOVERY               <chr> "HAT", "HAT", "HAT", "HAT", "HAT", "HAT", "HAT"~
    ## $ CWT                    <chr> "061974", "061973", "061975", "061973", "061974~
    ## $ Remarks                <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ tag_code_or_release_id <chr> "061974", "061973", "061975", "061973", "061974~
    ## $ RMIS                   <chr> "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y~
    ## $ ZoneDE                 <chr> "F", "F", "E", "F", "F", "E", "F", "U", "F", "F~
    ## $ PROJECT                <dbl> 1264, 1264, 1264, 1264, 1264, 1264, 1264, 1264,~
    ## $ RMIS_Run               <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, NA, 1, 1, 1~
    ## $ brood_year             <dbl> 2018, 2018, 2018, 2018, 2018, 2018, 2018, 2018,~
    ## $ AGE                    <dbl> 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 3, 3, NA, 3, 3, 3~
    ## $ RMIS_SppId             <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, NA, 1, 1, 1~
    ## $ RMIS_Spp               <chr> "King (chinook) salmon", "King (chinook) salmon~
    ## $ hatchery_location_name <chr> "FEATHER R HATCHERY", "FEATHER R HATCHERY", "FE~
    ## $ release_location_name  <chr> "FEATHER AT GRIDLEY", "FEATHER BOYDS PUMP RAMP"~
    ## $ first_release_date     <dbl> 20190405, 20190313, 20190405, 20190313, 2019040~
    ## $ last_release_date      <dbl> 20190405, 20190313, 20190405, 20190313, 2019040~
    ## $ CATCHYY                <dbl> 2021, 2021, 2021, 2021, 2021, 2021, 2021, 2021,~
    ## $ RMIS_Comments          <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, "Night ~
    ## $ reporting_agency       <chr> "CDFW", "CDFW", "CDFW", "CDFW", "CDFW", "CDFW",~
    ## $ THIRD_READ             <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, "Y", NA~
    ## $ OutputTime             <dttm> 2021-09-16 15:01:35, 2021-09-16 15:01:35, 2021~
    ## $ T1                     <dbl> 331194, 326562, 331129, 326562, 331194, 331129,~
    ## $ T2                     <dbl> 1497, 719, 365, 719, 1497, 365, 365, 25, 25, 0,~
    ## $ NT1                    <dbl> 0, 5756, 0, 5756, 0, 0, 0, 25, 25, 3905, 623, 2~
    ## $ NT2                    <dbl> 0, 2518, 0, 2518, 0, 0, 0, 0, 0, 1775, 0, 0, NA~
    ## $ T                      <dbl> 332691, 327281, 331494, 327281, 332691, 331494,~
    ## $ NT                     <dbl> 0, 8274, 0, 8274, 0, 0, 0, 25, 25, 5680, 623, 2~
    ## $ TotRel                 <dbl> 332691, 335555, 331494, 335555, 332691, 331494,~
    ## $ ProdFct                <dbl> 1.0000000, 0.9753423, 1.0000000, 0.9753423, 1.0~
    ## $ Cond1                  <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,~
    ## $ Hallprint11            <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ Hallprint12            <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ JT1                    <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ OtherId                <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ Partial1               <dbl> NA, NA, NA, NA, NA, NA, 1, NA, NA, NA, NA, NA, ~
    ## $ Beaked1                <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ Comment1               <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~

## Data transformations

``` r
# Snake case, 
# Columns are appropriate types
# Remove redundant columns
```

## Explore Numeric Variables:

``` r
# Filter clean data to show only numeric variables (this way we know we do not miss any)
```

### Variable: `[name]`

**Plotting \[Variable\] over Period of Record**

``` r
# Make whatever plot is appropriate 
# maybe 2 plots is appropriate
```

**Numeric Summary of \[Variable\] over Period of Record**

``` r
# Table with summary statistics
```

**NA and Unknown Values**

Provide a stat on NA or unknown values

## Explore Categorical variables:

General notes: If there is an opertunity to turn yes no into boolean do
so, but not if you loose value

``` r
# Filter clean data to show only categorical variables (this way we know we do not miss any)
```

### Variable: `[name]`

``` r
# table() 
```

Fix inconsistencies with spelling, capitalization, and abbreviations.

``` r
# Fix any inconsistancies with catagorical variables
```

**Create lookup rda for \[variable\] encoding:**

``` r
# Create named lookup vector
# Name rda [watershed]_[data type]_[variable_name].rda
# save rda to data/ 
```

**NA and Unknown Values**

Provide a stat on NA or unknown values

### Save cleaned data back to google cloud

``` r
# Write to google cloud 
# Name file [watershed]_[data type].csv
```
