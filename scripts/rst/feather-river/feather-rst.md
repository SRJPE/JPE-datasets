Feather River RST QC
================
Erin Cain
9/29/2021

# Feather River RST Data

## Description of Monitoring Data

Background: The traps are typically operated for approximately seven
months (December through June). Two trap locations are necessary because
flow is strictly regulated above the Thermalito Outlet and therefore
emigration cues and species composition may be different for the two
reaches.

**Timeframe:** Dec 1997 - May 2021

**Trapping Season:** Typically December - June, looks like it varies
quite a bit.

**Completeness of Record throughout timeframe:**

**Sampling Location:** Two RST locations are generally used, one at the
lower end of each of the two study reaches. Typically, one RST is
stationed at the bottom of Eye Side Channel, RM 60.2 (approximately one
mile above the Thermalito Afterbay Outlet) and one stationed in the HFC
below Herringer riffle, at RM 45.7.

TODO if time add map with sites here

**Data Contact:** [Kassie Hickey](mailto:KHickey@psmfc.org)

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
gcs_get_object(object_name = "rst/feather-river/data-raw/Feather River RST Natural Origin Chinook Catch Data_1998-2021.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "raw_feather_rst_data.xlsx",
               overwrite = TRUE)

gcs_get_object(object_name = "rst/feather-river/data-raw/Feather River RST Sampling Effort_1998-2021.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "raw_feather_rst_sampling_effort_data.xlsx",
               overwrite = TRUE)
```

Read in data from google cloud, glimpse raw data and domain description
sheet:

``` r
# read in data to clean
# RST Data
rst_data_sheets <- readxl::excel_sheets("raw_feather_rst_data.xlsx")
survey_year_details  <- readxl::read_excel("raw_feather_rst_data.xlsx", 
                                           sheet = "Survey Year Details") 
survey_year_details
```

    ## # A tibble: 55 x 5
    ##    Site       Location          `Survery Start`     `Survey End`        Notes   
    ##    <chr>      <chr>             <dttm>              <dttm>              <chr>   
    ##  1 Eye Riffle Low Flow Channel  1997-12-22 00:00:00 1998-07-01 00:00:00 <NA>    
    ##  2 Live Oak   High Flow Channel 1997-12-22 00:00:00 1998-07-01 00:00:00 <NA>    
    ##  3 Eye Riffle Low Flow Channel  1998-12-10 00:00:00 1999-08-31 00:00:00 Fished ~
    ##  4 Live Oak   High Flow Channel 1998-12-16 00:00:00 1999-09-09 00:00:00 Fished ~
    ##  5 Eye Riffle Low Flow Channel  1999-09-20 00:00:00 2000-08-31 00:00:00 <NA>    
    ##  6 Live Oak   High Flow Channel 1999-09-20 00:00:00 2000-08-31 00:00:00 <NA>    
    ##  7 Eye Riffle Low Flow Channel  2000-11-27 00:00:00 2001-06-21 00:00:00 <NA>    
    ##  8 Live Oak   High Flow Channel 2000-11-27 00:00:00 2001-06-21 00:00:00 <NA>    
    ##  9 Eye Riffle Low Flow Channel  2001-11-26 00:00:00 2002-06-14 00:00:00 <NA>    
    ## 10 Live Oak   High Flow Channel 2001-11-26 00:00:00 2002-01-14 00:00:00 <NA>    
    ## # ... with 45 more rows

``` r
# create function to read in all sheets of a 
read_sheets <- function(sheet){
  data <- read_excel("raw_feather_rst_data.xlsx", sheet = sheet)
}

raw_catch <- purrr::map(rst_data_sheets[-1], read_sheets) %>%
    reduce(bind_rows)

raw_catch %>% glimpse()
```

    ## Rows: 180,871
    ## Columns: 7
    ## $ Date             <dttm> 1997-12-23, 1997-12-23, 1997-12-23, 1997-12-23, 1997~
    ## $ siteName         <chr> "Eye Riffle", "Eye Riffle", "Eye Riffle", "Eye Riffle~
    ## $ commonName       <chr> "Chinook salmon", "Chinook salmon", "Chinook salmon",~
    ## $ `At Capture Run` <chr> "Fall", "Fall", "Fall", "Fall", "Fall", "Fall", "Fall~
    ## $ lifeStage        <chr> "Not recorded", "Parr", "Parr", "Parr", "Parr", "Parr~
    ## $ FL               <dbl> NA, 30, 32, 33, 34, 35, 38, 29, 37, 36, 31, 34, 33, 3~
    ## $ n                <dbl> 65, 2, 6, 8, 16, 10, 1, 1, 2, 2, 2, 19, 10, 2, 9, 7, ~

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
