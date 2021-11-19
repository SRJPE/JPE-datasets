clear\_carcass\_survey\_qc
================
Inigo Peng
11/4/2021

# Clear Creek Adult Carcass Survey

## Description of Monitoring Data

These data were collected by the U.S. Fish and Wildlife Service’s, Red
Bluff Fish and Wildlife Office’s, Clear Creek Monitoring Program.This
data encompass spring-run Chinook Salmon carcasses retrieved on redd and
escapement index surveys from 2008 to 2019 on Clear Creek. Data were
collected on lower Clear Creek from Whiskeytown Dam located at river
mile 18.1, (40.597786N latitude, -122.538791W longitude \[decimal
degrees\]) to the Clear Creek Video Station located at river mile 0.0
(40.504836N latitude, -122.369693W longitude \[decimal degrees\]) near
the confluence with the Sacramento River.

**Timeframe:** 2008 - 2019

**Completeness of Record throughout timeframe:**

**Sampling Location:** Clear Creek

**Data Contact:** [Ryan Schaefer](mailto:ryan_a_schaefer@fws.gov)

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
gcs_get_object(object_name = "adult-holding-redd-and-carcass-surveys/clear-creek/data-raw/FlowWest SCS JPE Data Request_Clear Creek.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "raw_redd_holding_carcass_data.xlsx")
               # Overwrite = TRUE)
```

Read in data from google cloud, glimpse raw data sheet:

``` r
raw_carcass_data <-readxl::read_excel("raw_redd_holding_carcass_data.xlsx", sheet = "Carcass") %>% glimpse()
```

    ## Rows: 601
    ## Columns: 40
    ## $ `QC Date`                       <dttm> 2019-02-08, 2019-02-08, 2019-02-08, 2~
    ## $ `QC Type`                       <chr> "Shapefile/Annual Excel", "Shapefile/A~
    ## $ Inspector                       <chr> "RS", "RS", "RS", "RS", "RS", "RS", "R~
    ## $ Year                            <dbl> 2008, 2008, 2008, 2008, 2008, 2008, 20~
    ## $ Survey                          <chr> "snorkel", "snorkel", "snorkel", "snor~
    ## $ Type                            <chr> "snorkel", "snorkel", "snorkel", "snor~
    ## $ DATE                            <dttm> 2008-09-10, 2008-09-23, 2008-09-23, 2~
    ## $ POINT_X                         <dbl> -122.5247, -122.5339, -121.7493, -122.~
    ## $ POINT_Y                         <dbl> 40.51367, 40.57413, 40.71537, 40.56912~
    ## $ REACH                           <chr> "R3", "R2", "R2", "R2", "R2", "R4", "R~
    ## $ River_Mile                      <dbl> 10.968258, 15.600476, 14.922846, 15.22~
    ## $ OBS_ONLY                        <chr> "NO", "NO", "NO", "YES", "YES", "NO", ~
    ## $ YEAR_ID                         <chr> "08", "08", "08", "08", "08", "08", "0~
    ## $ SAMPLE_ID                       <dbl> 60024, 60008, 60009, 69000, 69001, 600~
    ## $ SPECIES                         <chr> "Chinook", "Chinook", "Chinook", "Chin~
    ## $ ADIPOSE                         <chr> "PRESENT", "PRESENT", "PRESENT", "PRES~
    ## $ FORK_LEN__                      <chr> NA, "825", "665", NA, NA, "689", "770"~
    ## $ CONDIT                          <chr> "UNKNOWN", "NON-FRESH", "NON-FRESH", "~
    ## $ TIS_ETH                         <chr> "FIN", "FIN", "FIN", "NO SAMPLE", "NO ~
    ## $ TIS_DRY                         <chr> "FIN", "FIN", "FIN", "NO SAMPLE", "NO ~
    ## $ SCALE                           <chr> "YES", "YES", "YES", "NO", "NO", "YES"~
    ## $ OTOLITH_ST                      <chr> "NO", "YES", "YES", "NO", "NO", "YES",~
    ## $ GENDER                          <chr> "UNKNOWN", "MALE", "FEMALE", "UNKNOWN"~
    ## $ WHY_GENDER                      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ SPAWN_ST                        <chr> "UNKNOWN", "UNKNOWN", "PARTIAL", "UNKN~
    ## $ WHY_NOT_SP                      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ HEAD_TAK                        <chr> "NO", "NO", "NO", "NO", "NO", "NO", "N~
    ## $ TAG_TYPE                        <chr> "NONE", "NONE", "NONE", "NONE", "NONE"~
    ## $ Photo                           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ COMMENTS                        <chr> "old placer bridge", NA, "Many undevel~
    ## $ `CWT Code`                      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ Run                             <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ BY                              <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ `Release Location`              <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ Hatchery                        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ AGE                             <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ `Mark Rate`                     <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ `Verification and CWT comments` <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ `Run Call`                      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~
    ## $ Genetic                         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA~

``` r
cleaner_data <- raw_carcass_data %>% 
  janitor::clean_names() %>% 
  select(-c('survey','qc_type','qc_date','inspector','year', 'year_id')) %>% 
  rename('longitude' = 'point_x',
         'latitude' = 'point_y',
         'brood_year' = 'by') %>% 
  mutate(date = as.Date(date)) %>% 
  glimpse()
```

    ## Rows: 601
    ## Columns: 34
    ## $ type                          <chr> "snorkel", "snorkel", "snorkel", "snorke~
    ## $ date                          <date> 2008-09-10, 2008-09-23, 2008-09-23, 200~
    ## $ longitude                     <dbl> -122.5247, -122.5339, -121.7493, -122.53~
    ## $ latitude                      <dbl> 40.51367, 40.57413, 40.71537, 40.56912, ~
    ## $ reach                         <chr> "R3", "R2", "R2", "R2", "R2", "R4", "R4"~
    ## $ river_mile                    <dbl> 10.968258, 15.600476, 14.922846, 15.2230~
    ## $ obs_only                      <chr> "NO", "NO", "NO", "YES", "YES", "NO", "N~
    ## $ sample_id                     <dbl> 60024, 60008, 60009, 69000, 69001, 60010~
    ## $ species                       <chr> "Chinook", "Chinook", "Chinook", "Chinoo~
    ## $ adipose                       <chr> "PRESENT", "PRESENT", "PRESENT", "PRESEN~
    ## $ fork_len                      <chr> NA, "825", "665", NA, NA, "689", "770", ~
    ## $ condit                        <chr> "UNKNOWN", "NON-FRESH", "NON-FRESH", "NO~
    ## $ tis_eth                       <chr> "FIN", "FIN", "FIN", "NO SAMPLE", "NO SA~
    ## $ tis_dry                       <chr> "FIN", "FIN", "FIN", "NO SAMPLE", "NO SA~
    ## $ scale                         <chr> "YES", "YES", "YES", "NO", "NO", "YES", ~
    ## $ otolith_st                    <chr> "NO", "YES", "YES", "NO", "NO", "YES", "~
    ## $ gender                        <chr> "UNKNOWN", "MALE", "FEMALE", "UNKNOWN", ~
    ## $ why_gender                    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ spawn_st                      <chr> "UNKNOWN", "UNKNOWN", "PARTIAL", "UNKNOW~
    ## $ why_not_sp                    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ head_tak                      <chr> "NO", "NO", "NO", "NO", "NO", "NO", "NO"~
    ## $ tag_type                      <chr> "NONE", "NONE", "NONE", "NONE", "NONE", ~
    ## $ photo                         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ comments                      <chr> "old placer bridge", NA, "Many undevelop~
    ## $ cwt_code                      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ run                           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ brood_year                    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ release_location              <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ hatchery                      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ age                           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ mark_rate                     <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ verification_and_cwt_comments <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ run_call                      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ genetic                       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~

## Explore date

``` r
summary(cleaner_data$date)
```

    ##         Min.      1st Qu.       Median         Mean      3rd Qu.         Max. 
    ## "2008-08-18" "2009-10-21" "2012-10-01" "2012-07-15" "2014-10-09" "2019-10-08"

**NA and Unknown Values**

-   0 % of values in the `date` column are NA.

## Explore Categorical Data

``` r
cleaner_data %>% select_if(is.character) %>% colnames()
```

    ##  [1] "type"                          "reach"                        
    ##  [3] "obs_only"                      "species"                      
    ##  [5] "adipose"                       "fork_len"                     
    ##  [7] "condit"                        "tis_eth"                      
    ##  [9] "tis_dry"                       "scale"                        
    ## [11] "otolith_st"                    "gender"                       
    ## [13] "why_gender"                    "spawn_st"                     
    ## [15] "why_not_sp"                    "head_tak"                     
    ## [17] "tag_type"                      "photo"                        
    ## [19] "comments"                      "cwt_code"                     
    ## [21] "run"                           "brood_year"                   
    ## [23] "release_location"              "hatchery"                     
    ## [25] "age"                           "verification_and_cwt_comments"
    ## [27] "run_call"                      "genetic"

### Variable: `type`

**Description:** Survey Type (Kayak, Rotary Screw Trap, CCVS, Etc.)

Note: what is psam and ccvs?

``` r
cleaner_data$type <- tolower(cleaner_data$type)
table(cleaner_data$type)
```

    ## 
    ##    ccvs    psam      pw snorkel 
    ##       7       1     249     344

**NA and Unknown Values**

-   0 % of values in the `survey` column are NA.

### Variable: `reach`

**Description:** Reach surveyed on each survey day

``` r
table(cleaner_data$reach)
```

    ## 
    ##  R1  R2  R3  R4  R5 R5A R5B R5C  R6 R6A  R7 
    ##  47  60  21  54   3 212 153  23  15   1  12

**NA and Unknown Values**

-   0 % of values in the \`reach\`\` column are NA.
