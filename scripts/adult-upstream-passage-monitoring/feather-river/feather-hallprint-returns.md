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
                               range = "A1:V209") %>% # additonal columns are summaries
  glimpse()
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
cleaner_carcass_data <- raw_carcass_data %>% 
  set_names(tolower(colnames(raw_carcass_data))) %>% 
  rename("individual_id" = individualid, "other_marks" = othermarks,
         "distinct_tag_applied" = disctagapplied, 
         "color_tag_applied" = colortagapplied, 
         "spawn_status" = spawnstatus, 
         "fl_cm" = flcm, 
         "adipose_fin_clip" = adfinclip, 
         "head_number" = headnumber, 
         "scale_number" = scalenumber, 
         "tissue_number" = tissuenumber,
         "otolith_number" = otolithnumber) %>% 
  mutate(date = as.Date(date)) %>%
  select(-flmm) %>% # we already have flcm
  glimpse()
```

    ## Rows: 208
    ## Columns: 21
    ## $ week                 <dbl> 3, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5~
    ## $ date                 <date> 2018-09-18, 2018-09-24, 2018-09-24, 2018-10-01, ~
    ## $ section              <chr> "4", "11", "15", "1", "6", "2", "9", "9", "10", "~
    ## $ surveyid             <dbl> 83, 128, 132, 158, 163, 156, 165, 165, 172, 157, ~
    ## $ individual_id        <dbl> 4, 7, 8, 11, 21, 9, 24, 25, 33, 10, 30, 17, 13, 1~
    ## $ other_marks          <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ species              <chr> "CHN", "CHN", "CHN", "CHN", "CHN", "CHN", "CHN", ~
    ## $ run                  <chr> "Spring", "Spring", "Spring", "Spring", "Spring",~
    ## $ disposition          <chr> "Tagged", "Tagged", "Chopped", "Tagged", "Tagged"~
    ## $ distinct_tag_applied <chr> "5550", "260", NA, "5561", "5558", "5850", "5553"~
    ## $ color_tag_applied    <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ sex                  <chr> "F", "F", "Unk", "F", "F", "F", "F", "F", "F", "F~
    ## $ spawn_status         <chr> "Y", "Y", "Unk", "Y", "Y", "Y", "Y", "Y", "Y", "Y~
    ## $ fl_cm                <dbl> 60, 70, NA, 79, 76, 82, 60, 60, 80, 77, 79, 73, 8~
    ## $ condition            <chr> "F", "F", "n/r", "F", "F", "F", "F", "F", "F", "F~
    ## $ adipose_fin_clip     <chr> "Yes", "Yes", "Unknown", "Yes", "Yes", "Yes", "Ye~
    ## $ head_number          <chr> NA, "71101", NA, "71114", "71111", "71115", "7110~
    ## $ scale_number         <chr> "26051", "26052", NA, "26065", "26062", "26066", ~
    ## $ tissue_number        <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ otolith_number       <chr> "72", "57", NA, "91", "79", "71", "68", "67", "59~
    ## $ comments             <chr> "SPRING GREEN", "SPRING GREEN", "SPRING GREEN", "~

## Explore Numeric Variables:

``` r
# Filter clean data to show only numeric variables 
cleaner_carcass_data %>% select_if(is.numeric) %>% colnames()
```

    ## [1] "week"          "surveyid"      "individual_id" "fl_cm"

## Explore Categorical variables:

``` r
# Filter clean data to show only categorical variables
cleaner_carcass_data %>% select_if(is.character) %>% colnames()
```

    ##  [1] "section"              "species"              "run"                 
    ##  [4] "disposition"          "distinct_tag_applied" "sex"                 
    ##  [7] "spawn_status"         "condition"            "adipose_fin_clip"    
    ## [10] "head_number"          "scale_number"         "otolith_number"      
    ## [13] "comments"

### Variable: \`\`

**NA and Unknown Values**

There are no NA values in \`\`.
