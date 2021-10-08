Feather River Hallprint Data QC
================
Erin Cain
9/29/2021

# Feather River hallprint adult broodstock selection and enumeration data

## Description of Monitoring Data

We currently only have one file describing fish returns. We can likely
acquire more but the return data is currently very messy and not stored
in a consistent format across years.

The excel workbook that we have has 15 sheets. Most sheets are summaries
of hallprint tagging data. This markdown is focused on the
`Carcass Recoveries` tab of the workbook.

**Timeframe:** 2018

**Season:** Carcass Recoveries appear to be found from September -
December

**Completeness of Record throughout timeframe:**

**Sampling Location:**

**Data Contact:** [Byron Mache](mailto:Byron.Mache@water.ca.gov)

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
gcs_get_object(object_name = 
                 "adult-upstream-passage-monitoring/feather-river/hallprint/data-raw/returns/FRFH HP RUN DATA 2018 as of 9-10-20.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "raw_feather_hallprint_returns_data.xlsx",
               overwrite = TRUE)
```

Read in data from google cloud, glimpse raw data and domain description
sheet:

``` r
# read in data to clean 
sheets <- excel_sheets("raw_feather_hallprint_returns_data.xlsx")
sheets # many sheets, most do not seem useful 
```

    ##  [1] "All Tags "                 "Single Tags"              
    ##  [3] "Recaps"                    "Tags not used"            
    ##  [5] "Wilds"                     "Morts "                   
    ##  [7] "Acoustic "                 "Summary"                  
    ##  [9] "Analysis"                  "Head Fish"                
    ## [11] "Comments"                  "Hatchery Recoveries "     
    ## [13] "Hatchery Rec OSP,CWT,FRFH" "Carcass Recoveries"       
    ## [15] "Fate of Recoveris"

``` r
raw_carcass_data <- read_excel("raw_feather_hallprint_returns_data.xlsx", 
                               sheet = "Carcass Recoveries",
                               range = "A1:V209") %>% glimpse()
```

    ## Rows: 208
    ## Columns: 22
    ## $ Week            <dbl> 3, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, ~
    ## $ Date            <dttm> 2018-09-18, 2018-09-24, 2018-09-24, 2018-10-01, 2018-~
    ## $ Section         <chr> "4", "11", "15", "1", "6", "2", "9", "9", "10", "3", "~
    ## $ SurveyID        <dbl> 83, 128, 132, 158, 163, 156, 165, 165, 172, 157, 169, ~
    ## $ IndividualID    <dbl> 4, 7, 8, 11, 21, 9, 24, 25, 33, 10, 30, 17, 13, 14, 26~
    ## $ OtherMarks      <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ Species         <chr> "CHN", "CHN", "CHN", "CHN", "CHN", "CHN", "CHN", "CHN"~
    ## $ Run             <chr> "Spring", "Spring", "Spring", "Spring", "Spring", "Spr~
    ## $ Disposition     <chr> "Tagged", "Tagged", "Chopped", "Tagged", "Tagged", "Ta~
    ## $ DiscTagApplied  <chr> "5550", "260", NA, "5561", "5558", "5850", "5553", "55~
    ## $ ColorTagApplied <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ Sex             <chr> "F", "F", "Unk", "F", "F", "F", "F", "F", "F", "F", "F~
    ## $ SpawnStatus     <chr> "Y", "Y", "Unk", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y~
    ## $ FLcm            <dbl> 60, 70, NA, 79, 76, 82, 60, 60, 80, 77, 79, 73, 80, 75~
    ## $ FLmm            <dbl> 600, 700, NA, 790, 760, 820, 600, 600, 800, 770, 790, ~
    ## $ Condition       <chr> "F", "F", "n/r", "F", "F", "F", "F", "F", "F", "F", "F~
    ## $ AdFinClip       <chr> "Yes", "Yes", "Unknown", "Yes", "Yes", "Yes", "Yes", "~
    ## $ HeadNumber      <chr> NA, "71101", NA, "71114", "71111", "71115", "71106", "~
    ## $ ScaleNumber     <chr> "26051", "26052", NA, "26065", "26062", "26066", "2605~
    ## $ TissueNumber    <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ OtolithNumber   <chr> "72", "57", NA, "91", "79", "71", "68", "67", "59", "5~
    ## $ Comments        <chr> "SPRING GREEN", "SPRING GREEN", "SPRING GREEN", "SPRIN~

## Data transformations

``` r
# For different excel sheets for each year read in and combine years here
cleaner_carcass_data <- raw_carcass_data
```

## Explore Numeric Variables:

``` r
# Filter clean data to show only numeric variables 
cleaner_carcass_data %>% select_if(is.numeric) %>% colnames()
```

    ## [1] "Week"         "SurveyID"     "IndividualID" "FLcm"         "FLmm"

## Explore Categorical variables:

``` r
# Filter clean data to show only categorical variables
cleaner_carcass_data %>% select_if(is.character) %>% colnames()
```

    ##  [1] "Section"        "Species"        "Run"            "Disposition"   
    ##  [5] "DiscTagApplied" "Sex"            "SpawnStatus"    "Condition"     
    ##  [9] "AdFinClip"      "HeadNumber"     "ScaleNumber"    "OtolithNumber" 
    ## [13] "Comments"

### Variable: \`\`

**NA and Unknown Values**

There are no NA values in \`\`.
