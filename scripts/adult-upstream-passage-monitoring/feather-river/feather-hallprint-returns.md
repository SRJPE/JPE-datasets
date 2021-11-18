Feather River Hallprint Data QC
================
Erin Cain
9/29/2021

# Feather River hallprint adult broodstock selection and enumeration data (Return/Carcass Data)

## Description of Monitoring Data

We currently only have one file describing fish returns. We can likely
acquire more but the return data is currently very messy and not stored
in a consistent format across years.

The excel workbook that we have has 15 sheets. Most sheets are summaries
of hallprint tagging data. This markdown is focused on the
`Carcass Recoveries` tab of the workbook.

It looks like there is additional information on Hallprint returns/tag
numbers in the feather river carcass suvey.

**Timeframe:** 2018

**Season:** Carcass Recoveries appear to be found from September -
December

**Completeness of Record throughout timeframe:** Most records are from
weeks 4 - 10 however we have records from week 2 - 10 and weeks 12 - 14.

**Sampling Location:** Locations described by Section, will need more
information to map each section to a specific location

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
  rename("individual_id" = individualid, 
         "survey_id" = surveyid, 
         "distinct_tag_applied" = disctagapplied, 
         "spawn_status" = spawnstatus, 
         "fork_length" = flmm, 
         "adipose_fin_clip" = adfinclip, 
         "head_number" = headnumber, 
         "scale_number" = scalenumber, 
         "otolith_number" = otolithnumber) %>% 
  mutate(date = as.Date(date),
         survey_id = as.character(survey_id),
         individual_id = as.character(individual_id),
         otolith_number = as.numeric(otolith_number)) %>%
  filter(species == "CHN") %>%
  select(-flcm, -species, -tissuenumber, -colortagapplied, -othermarks) %>% # we already have flcm, tissuenumber and colortagapplied are all NA, species are all chinook 
  glimpse()
```

    ## Rows: 208
    ## Columns: 17
    ## $ week                 <dbl> 3, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5~
    ## $ date                 <date> 2018-09-18, 2018-09-24, 2018-09-24, 2018-10-01, ~
    ## $ section              <chr> "4", "11", "15", "1", "6", "2", "9", "9", "10", "~
    ## $ survey_id            <chr> "83", "128", "132", "158", "163", "156", "165", "~
    ## $ individual_id        <chr> "4", "7", "8", "11", "21", "9", "24", "25", "33",~
    ## $ run                  <chr> "Spring", "Spring", "Spring", "Spring", "Spring",~
    ## $ disposition          <chr> "Tagged", "Tagged", "Chopped", "Tagged", "Tagged"~
    ## $ distinct_tag_applied <chr> "5550", "260", NA, "5561", "5558", "5850", "5553"~
    ## $ sex                  <chr> "F", "F", "Unk", "F", "F", "F", "F", "F", "F", "F~
    ## $ spawn_status         <chr> "Y", "Y", "Unk", "Y", "Y", "Y", "Y", "Y", "Y", "Y~
    ## $ fork_length          <dbl> 600, 700, NA, 790, 760, 820, 600, 600, 800, 770, ~
    ## $ condition            <chr> "F", "F", "n/r", "F", "F", "F", "F", "F", "F", "F~
    ## $ adipose_fin_clip     <chr> "Yes", "Yes", "Unknown", "Yes", "Yes", "Yes", "Ye~
    ## $ head_number          <chr> NA, "71101", NA, "71114", "71111", "71115", "7110~
    ## $ scale_number         <chr> "26051", "26052", NA, "26065", "26062", "26066", ~
    ## $ otolith_number       <dbl> 72, 57, NA, 91, 79, 71, 68, 67, 59, 52, 38, 32, 1~
    ## $ comments             <chr> "SPRING GREEN", "SPRING GREEN", "SPRING GREEN", "~

## Explore Numeric Variables:

``` r
# Filter clean data to show only numeric variables 
cleaner_carcass_data %>% select_if(is.numeric) %>% colnames()
```

    ## [1] "week"           "fork_length"    "otolith_number"

### Variable: `week`

``` r
cleaner_carcass_data %>%
  ggplot(aes(x = week)) + 
  geom_histogram(breaks=seq(0, 15, by=1)) + 
  scale_x_continuous(breaks=seq(0, 15, by=1)) +
  theme_minimal() +
  labs(title = "Week Distribution") + 
  theme(text = element_text(size = 18)) 
```

![](feather-hallprint-returns_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

Numeric Summary:

``` r
summary(cleaner_carcass_data$week)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   3.000   6.000   7.000   7.188   8.000  14.000

**NA and Unknown Values**

-   0 % of values in the `week` column are NA.

### Variable: `fork_length`

Length of fish in mm

**Plotting fork\_length**

``` r
cleaner_carcass_data %>%
  ggplot(aes(x = fork_length)) + 
  geom_histogram() + 
  # scale_x_continuous(breaks=seq(50, 100, by = 5)) +
  theme_minimal() +
  labs(title = "fork length distribution") + 
  theme(text = element_text(size = 18),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) 
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](feather-hallprint-returns_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

**Numeric Summary of fork\_length over Period of Record**

``` r
# Table with summary statistics
summary(cleaner_carcass_data$fork_length)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   530.0   710.0   750.0   750.7   800.0   940.0     150

**NA and Unknown Values**

-   72.1 % of values in the `fork_length` column are NA.

### Variable: `otolith_number`

``` r
cleaner_carcass_data %>%
  ggplot(aes(x = otolith_number)) + 
  geom_histogram(breaks=seq(0, 225, by=5)) + 
  scale_x_continuous(breaks=seq(0, 225, by=25)) +
  theme_minimal() +
  labs(title = "Otolith Number Distribution") + 
  theme(text = element_text(size = 18)) 
```

![](feather-hallprint-returns_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

Numeric Summary:

``` r
summary(cleaner_carcass_data$otolith_number)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    10.0    45.0    67.0    66.6    86.0   208.0     163

**NA and Unknown Values**

-   78.4 % of values in the `otolith_number` column are NA.

## Explore Categorical variables:

``` r
# Filter clean data to show only categorical variables
cleaner_carcass_data %>% select_if(is.character) %>% colnames()
```

    ##  [1] "section"              "survey_id"            "individual_id"       
    ##  [4] "run"                  "disposition"          "distinct_tag_applied"
    ##  [7] "sex"                  "spawn_status"         "condition"           
    ## [10] "adipose_fin_clip"     "head_number"          "scale_number"        
    ## [13] "comments"

### Variable: `section`

Each section number describes a different portion of the river

``` r
table(cleaner_carcass_data$section)
```

    ## 
    ##  1 10 11 12 13 14 15 16 17 18 19  2 20 21 24  3 33  4  5  6  7  8  9 
    ## 11 20 10 17  3  1  5  4 12  2  1 10  2  1  1  7  1 11  8 27  3 41 10

**NA and Unknown Values**

-   0 % of values in the `section` column are NA.

### Variable: `survey_id`

Each survey id is a unique id for each survey day

There are 102 unique individual ids.

**NA and Unknown Values**

-   0 % of values in the `survey_id` column are NA.

### Variable: `individual_id`

Each section number describes a different portion of the river

There are 208 unique individual ids.

**NA and Unknown Values**

-   0 % of values in the `individual_id` column are NA.

### Variable: `run`

``` r
table(cleaner_carcass_data$run)
```

    ## 
    ## Spring 
    ##    208

All values are spring run.

``` r
cleaner_carcass_data$run <- tolower(cleaner_carcass_data$run)
```

**NA and Unknown Values**

-   0 % of values in the `run` column are NA.

### Variable: `disposition`

``` r
table(cleaner_carcass_data$disposition)
```

    ## 
    ## Chopped  Tagged 
    ##     152      56

``` r
cleaner_carcass_data$disposition <- tolower(cleaner_carcass_data$disposition)
```

**NA and Unknown Values**

-   0 % of values in the `disposition` column are NA.

### Variable: `distinct_tag_applied`

A number describing the distinct tag applied to fish

There are 57 distinct tag numbers.

**NA and Unknown Values**

-   73.1 % of values in the `distinct_tag_applied` column are NA.

### Variable: `sex`

``` r
table(cleaner_carcass_data$sex)
```

    ## 
    ##   F   M N/R Unk 
    ##  44  14 138  12

All unknown and not recorded (N/R) become NA.

``` r
cleaner_carcass_data$sex <- case_when(cleaner_carcass_data$sex == "F" ~ "female",
                                      cleaner_carcass_data$sex == "M" ~ "male")

table(cleaner_carcass_data$sex)
```

    ## 
    ## female   male 
    ##     44     14

**NA and Unknown Values**

-   72.1 % of values in the `sex` column are NA.

### Variable: `spawn_status`

``` r
table(cleaner_carcass_data$spawn_status)
```

    ## 
    ## n/r Unk   Y 
    ## 131  20  46

Change spawn status to TRUE if spawned (Y) and NA for everything else.

``` r
cleaner_carcass_data$spawn_status <- ifelse(cleaner_carcass_data$spawn_status == "Y", TRUE, NA)
```

**NA and Unknown Values**

-   77.9 % of values in the `spawn_status` column are NA.

### Variable: `condition`

TODO figure out what these condition values mean, most are NA

``` r
table(cleaner_carcass_data$condition)
```

    ## 
    ##   D   F n/r   S Unk 
    ##   3  64 138   1   2

``` r
cleaner_carcass_data$condition <- tolower(cleaner_carcass_data$condition)
```

**NA and Unknown Values**

-   0 % of values in the `condition` column are NA.

### Variable: `adipose_fin_clip`

``` r
table(cleaner_carcass_data$adipose_fin_clip)
```

    ## 
    ##           No Not recorded      Partial      Unknown          Yes 
    ##           11          139            1            9           48

``` r
cleaner_carcass_data$adipose_fin_clip <- tolower(ifelse(cleaner_carcass_data$adipose_fin_clip %in% c("Not Recorded", "Unknown"), NA,
                                          cleaner_carcass_data$adipose_fin_clip))

table(cleaner_carcass_data$adipose_fin_clip)
```

    ## 
    ##           no not recorded      partial          yes 
    ##           11          139            1           48

**NA and Unknown Values**

-   4.3 % of values in the `adipose_fin_clip` column are NA.

### Variable: `head_number`

There are 47 unique head numbers corresponding to head tags.

**NA and Unknown Values**

-   77.9 % of values in the `head_number` column are NA.

### Variable: `scale_number`

There are 46 unique head numbers corresponding to head tags.

**NA and Unknown Values**

-   78.4 % of values in the `scale_number` column are NA.  

### Variable: `comments`

``` r
unique(cleaner_carcass_data$comments)
```

    ## [1] "SPRING GREEN"

All comments just describe if a fish is spring green or not. Change to
spring green TRUE, FALSE variable

``` r
cleaner_carcass_data$spring_green <- ifelse(cleaner_carcass_data$comments == "SPRING GREEN", TRUE, FALSE)
```

**NA and Unknown Values**

-   0 % of values in the `comments` column are NA.

**Summary of identified issues:**

-   Need to figure out what the condition codes mean (TODO contact
    byron)
-   Only one year of data, the rest we did not receive because they are
    all in varying formats. This one is also a many sheets non tidy
    excel table. I choose to look at this sheet because it seemed the
    most useful but I am not sure it is the best information.

### Save cleaned data back to google cloud

``` r
feather_hallprint_returns <- cleaner_carcass_data %>% select(-comments) %>% glimpse()
```

    ## Rows: 208
    ## Columns: 17
    ## $ week                 <dbl> 3, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5~
    ## $ date                 <date> 2018-09-18, 2018-09-24, 2018-09-24, 2018-10-01, ~
    ## $ section              <chr> "4", "11", "15", "1", "6", "2", "9", "9", "10", "~
    ## $ survey_id            <chr> "83", "128", "132", "158", "163", "156", "165", "~
    ## $ individual_id        <chr> "4", "7", "8", "11", "21", "9", "24", "25", "33",~
    ## $ run                  <chr> "spring", "spring", "spring", "spring", "spring",~
    ## $ disposition          <chr> "tagged", "tagged", "chopped", "tagged", "tagged"~
    ## $ distinct_tag_applied <chr> "5550", "260", NA, "5561", "5558", "5850", "5553"~
    ## $ sex                  <chr> "female", "female", NA, "female", "female", "fema~
    ## $ spawn_status         <lgl> TRUE, TRUE, NA, TRUE, TRUE, TRUE, TRUE, TRUE, TRU~
    ## $ fork_length          <dbl> 600, 700, NA, 790, 760, 820, 600, 600, 800, 770, ~
    ## $ condition            <chr> "f", "f", "n/r", "f", "f", "f", "f", "f", "f", "f~
    ## $ adipose_fin_clip     <chr> "yes", "yes", NA, "yes", "yes", "yes", "yes", "ye~
    ## $ head_number          <chr> NA, "71101", NA, "71114", "71111", "71115", "7110~
    ## $ scale_number         <chr> "26051", "26052", NA, "26065", "26062", "26066", ~
    ## $ otolith_number       <dbl> 72, 57, NA, 91, 79, 71, 68, 67, 59, 52, 38, 32, 1~
    ## $ spring_green         <lgl> TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, T~

``` r
f <- function(input, output) write_csv(input, file = output)

gcs_upload(feather_hallprint_returns,
           object_function = f,
           type = "csv",
           name = "adult-upstream-passage-monitoring/feather-river/data/feather_hallprint_returns.csv")
```
