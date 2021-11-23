butte-2014-2016-individual-qc-checklist
================
Inigo Peng
10/21/2021

------------------------------------------------------------------------

# Butte Creek Individual Survey Data

## Description of Monitoring Data

**Timeframe:** 2014-2016

**Completeness of Record throughout timeframe:**

**Sampling Location:** Various sampling locations on Butte Creek.

**Data Contact:** [Jessica
Nichols](mailto::Jessica.Nichols@Wildlife.ca.gov)

**Additional Info:**

-   The carcass data came in 12 documents for each year. We identified
    the ‘SurveyChops’ and ‘SurveyIndividuals’ datasets as the documents
    with the most complete information and joined them for all of the
    years.

-   The SurveyIndividual QC files are split into different files to
    preserve the column types. This file runs 2014-2016 QC

## Access Cloud Data

``` r
# Run Sys.setenv() to specify GCS_AUTH_FILE and GCS_DEFAULT_BUCKET before running
# Open object from google cloud storage
# Set your authentication using gcs_auth
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
# Set global bucket 
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))
gcs_list_objects()

# git data and save as xlsx
read_from_cloud <- function(year){
  gcs_get_object(object_name = paste0("adult-holding-redd-and-carcass-surveys/butte-creek/data-raw/", year, "_SurveyIndividuals.xlsx"),
               bucket = gcs_get_global_bucket(),
               saveToDisk = paste0(year,"_raw_surveyindividuals.xlsx"),
               overwrite = TRUE)
  # data <- readxl::read_excel(paste0(year,"_raw_surveyindividuals.xlsx")) %>% 
  #   glimpse()
}

open_files <- function(year){
  data <- readxl::read_excel(paste0(year, "_raw_surveyindividuals.xlsx"),
                   col_types = c("numeric","text","numeric","numeric","date","text","text","text","text","numeric","text","numeric","numeric",
                                 "text","text","text","text","numeric","text","text","text","text","text","text","text","text"))
  return (data)
}

#Have to read files separately to keep the column types for each file
#2019 file is different from all others

earlier_years <- c(2014, 2015, 2016)
purrr::map(earlier_years, read_from_cloud)
raw_earlier_data <- purrr::map(earlier_years, open_files) %>%
  reduce(bind_rows) %>% glimpse
write_csv(raw_earlier_data, "raw_2014_to_2016_individuals_data.csv")
```

Read in data from google cloud, glimpse raw data and domain description
sheet:

``` r
# read in data to clean
raw_individuals_data <- read_csv("raw_2014_to_2016_individuals_data.csv")%>% glimpse()
```

    ## Rows: 1153 Columns: 26

    ## -- Column specification --------------------------------------------------------
    ## Delimiter: ","
    ## chr  (11): LocationCD, SectionCD, WayPt, SpeciesCode, Disposition, Sex, Cond...
    ## dbl   (7): Survey, Year, Week, DiscTagApplied, FLmm, FLcm, ScaleNu
    ## lgl   (7): HeadNu, DNAnu, Comments, OtherMarks, CWTStatusID, CWTStatus, CWTcd
    ## dttm  (1): Date

    ## 
    ## i Use `spec()` to retrieve the full column specification for this data.
    ## i Specify the column types or set `show_col_types = FALSE` to quiet this message.

    ## Rows: 1,153
    ## Columns: 26
    ## $ Survey         <dbl> 110013, 110013, 110013, 110013, 110013, 110013, 110013,~
    ## $ LocationCD     <chr> "Upper survey", "Upper survey", "Upper survey", "Upper ~
    ## $ Year           <dbl> 2014, 2014, 2014, 2014, 2014, 2014, 2014, 2014, 2014, 2~
    ## $ Week           <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1~
    ## $ Date           <dttm> 2014-09-23, 2014-09-23, 2014-09-23, 2014-09-23, 2014-0~
    ## $ SectionCD      <chr> "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", ~
    ## $ WayPt          <chr> "A1", "A1", "A2", "A2", "A2", "A2", "A3", "A3", "A3", "~
    ## $ SpeciesCode    <chr> "CHN-Spring", "CHN-Spring", "CHN-Spring", "CHN-Spring",~
    ## $ Disposition    <chr> "Tagged", "Tagged", "Tagged", "Tagged", "Tagged", "Tagg~
    ## $ DiscTagApplied <dbl> 240, 239, 226, 235, 241, 210, 209, 103, 116, 216, 208, ~
    ## $ Sex            <chr> "F", "F", "F", "F", "F", "F", "F", "F", "F", "F", "M", ~
    ## $ FLmm           <dbl> 675, 764, 650, 779, 869, 810, 686, 730, 638, 712, 733, ~
    ## $ FLcm           <dbl> 67.5, 76.4, 65.0, 77.9, 86.9, 81.0, 68.6, 73.0, 63.8, 7~
    ## $ ConditionCD    <chr> "F", "F", "F", "F", "F", "F", "F", "F", "F", "F", "F", ~
    ## $ SpawnedCD      <chr> "Y", "P", "Y", "N", "Y", "P", "N", "Y", "Y", "Y", "P", ~
    ## $ AdFinClipCD    <chr> "N", "N", "N", "N", "N", "N", "N", "N", "N", "N", "N", ~
    ## $ HeadNu         <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ ScaleNu        <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ TissueNu       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ OtolithNu      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ DNAnu          <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ Comments       <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ OtherMarks     <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ CWTStatusID    <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ CWTStatus      <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ CWTcd          <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~

``` r
# raw_later_individuals_data <- read_csv("raw_2017_to_2020_individuals_data.csv")%>% glimpse()
```

## Data Transformations

``` r
cleaner_data<- raw_individuals_data %>%
  janitor::clean_names() %>%
  rename('location' = 'location_cd',
         'fork_length_mm' = 'f_lmm',
         'condition' = 'condition_cd',
         'spawning_status' = 'spawned_cd') %>% 
  select(-c('week', 'year', 'f_lcm','location', 'species_code',
         'other_marks', 'cwt_status_id', 'cw_tcd', 'dn_anu', 'head_nu')) %>% #all location the same,all spring run chinook, all tagged, all no ad fin clip, no data for the rest of the dropped columns
  mutate(date = as.Date(date),
         scale_nu = as.character(scale_nu),
         survey = as.character(survey)) %>% #scale_nu is identifier
  glimpse()
```

    ## Rows: 1,153
    ## Columns: 16
    ## $ survey           <chr> "110013", "110013", "110013", "110013", "110013", "11~
    ## $ date             <date> 2014-09-23, 2014-09-23, 2014-09-23, 2014-09-23, 2014~
    ## $ section_cd       <chr> "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"~
    ## $ way_pt           <chr> "A1", "A1", "A2", "A2", "A2", "A2", "A3", "A3", "A3",~
    ## $ disposition      <chr> "Tagged", "Tagged", "Tagged", "Tagged", "Tagged", "Ta~
    ## $ disc_tag_applied <dbl> 240, 239, 226, 235, 241, 210, 209, 103, 116, 216, 208~
    ## $ sex              <chr> "F", "F", "F", "F", "F", "F", "F", "F", "F", "F", "M"~
    ## $ fork_length_mm   <dbl> 675, 764, 650, 779, 869, 810, 686, 730, 638, 712, 733~
    ## $ condition        <chr> "F", "F", "F", "F", "F", "F", "F", "F", "F", "F", "F"~
    ## $ spawning_status  <chr> "Y", "P", "Y", "N", "Y", "P", "N", "Y", "Y", "Y", "P"~
    ## $ ad_fin_clip_cd   <chr> "N", "N", "N", "N", "N", "N", "N", "N", "N", "N", "N"~
    ## $ scale_nu         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ tissue_nu        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ otolith_nu       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ comments         <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ cwt_status       <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~

## Explore `date`

``` r
summary(cleaner_data$date)
```

    ##         Min.      1st Qu.       Median         Mean      3rd Qu.         Max. 
    ## "2014-09-23" "2014-10-07" "2015-10-13" "2015-11-06" "2016-10-06" "2016-10-20"

**NA and Unknown Values**

-   0 % of values in the `date` column are NA.

## Explore Categorical Variables

``` r
cleaner_data %>% 
  select_if(is.character) %>% colnames()
```

    ##  [1] "survey"          "section_cd"      "way_pt"          "disposition"    
    ##  [5] "sex"             "condition"       "spawning_status" "ad_fin_clip_cd" 
    ##  [9] "scale_nu"        "tissue_nu"       "otolith_nu"

### Variable: `survey`

There are 3 unique individual survey numbers.

**NA and Unknown Values**

-   0 % of values in the `survey` column are NA.

### Variable:`section_cd`

\*\* Create look up rda for section encoding:\*\*

``` r
butte_section_code <- c('A','B','C','COV-OKIE','D', 'E')
names(butte_section_code) <-c(
  "Quartz Bowl Pool downstream to Whiskey Flat",
  "Whiskey Flat downstream to Helltown Bridge",
  "Helltown Bridge downstream to Quail Run Bridge",
  "Centerville Covered Brdige to Okie Dam",
  "Quail Run Bridge downstream to Cable Bridge",
  "Cable Bridge downstream ot Centerville; sdf Cable Bridge downstream to Centerville Covered Bridge"
)

tibble(code = butte_section_code,
       definition = names(butte_section_code))
```

    ## # A tibble: 6 x 2
    ##   code     definition                                                           
    ##   <chr>    <chr>                                                                
    ## 1 A        Quartz Bowl Pool downstream to Whiskey Flat                          
    ## 2 B        Whiskey Flat downstream to Helltown Bridge                           
    ## 3 C        Helltown Bridge downstream to Quail Run Bridge                       
    ## 4 COV-OKIE Centerville Covered Brdige to Okie Dam                               
    ## 5 D        Quail Run Bridge downstream to Cable Bridge                          
    ## 6 E        Cable Bridge downstream ot Centerville; sdf Cable Bridge downstream ~

**NA and Unknown Values**

-   0 % of values in the `section_cd` column are NA.

### Variable:`way_pt`

``` r
table(cleaner_data$way_pt)
```

    ## 
    ##       A1       A2       A3       A4       A5      B-P       B1       B2 
    ##       36       47       37       30       29       13       21       24 
    ##       B3       B4       B5       B6       B7       B8  BCK-PWL      C-B 
    ##       14       10       23      108       83       34        1        5 
    ##       C1      C10      C11      C12       C2       C3       C4       C5 
    ##       62       17       30       28       54       13       58       53 
    ##       C6       C7       C8       C9  COV-BCK  COV-BLK       D1       D2 
    ##       26       26       14       34        2        2       15       61 
    ##       D3       D4       D5       D6       D7       D8       E1       E2 
    ##       33       16        5        8       19        8       10        7 
    ##       E3       E4       E5       E6       E7      P-O PWL-OKIE 
    ##       16        7        4        1        7        1        1

**NA and Unknown Values**

-   0 % of values in the `way_pt` column are NA.

### Variable: `disposition`

``` r
cleaner_data$disposition <- tolower(cleaner_data$disposition)
table(cleaner_data$disposition)
```

    ## 
    ## tagged 
    ##   1153

**NA and Unknown Values**

-   0 % of values in the `disposition` column are NA.

### Variable:`sex`

``` r
cleaner_data<- cleaner_data %>% 
  mutate(sex = tolower(sex),
         sex = case_when(
           sex == "f" ~ "female",
           sex == "m"~ "male"
         ))
table(cleaner_data$sex)
```

    ## 
    ## female   male 
    ##    680    473

**NA and Unknown Values**

-   0 % of values in the `sex` column are NA.

### Variable:`condition`

TODO: need description for condition

``` r
cleaner_data <- cleaner_data %>% 
  mutate(condition = set_names(tolower(condition)),
         condition = case_when(
           condition == "n/r" ~ 'not recorded',
           TRUE ~ as.character(condition)
         ))
table(cleaner_data$condition)
```

    ## 
    ##            d            f not recorded 
    ##          221          515          417

**NA and Unknown Values**

-   0 % of values in the `condition` column are NA.

### Variable:`spawning_status`

Categorizing ‘not recorded’ and and ‘unknown’ into NA.

``` r
cleaner_data <- cleaner_data %>% 
  mutate(spawning_status = set_names(tolower(spawning_status)),
         spawning_status = 
           case_when(spawning_status == "n" ~ "no",
                     spawning_status == "y" ~ "yes",
                     spawning_status == "n/r" ~ NA_character_,
                     spawning_status == "unk" ~ NA_character_,
                     TRUE ~ as.character(spawning_status)
  ))

table(cleaner_data$spawning_status)
```

    ## 
    ##  no   p yes 
    ##  28  56 299

**NA and Unknown Values**

-   66.8 % of values in the `spawning_status` column are NA.

### Variable: `ad_fin_clip_cd`

``` r
cleaner_data <- cleaner_data %>% 
  mutate(ad_fin_clip_cd =
           case_when(ad_fin_clip_cd == "N" ~ FALSE))
table(cleaner_data$ad_fin_clip_cd)
```

    ## 
    ## FALSE 
    ##  1153

**NA and Unknown Values**

-   0 % of values in the `ad_fin_clip_cd` column are NA.

### Variable: `scale_nu`

``` r
unique(cleaner_data$scale_nu)[1:5]
```

    ## [1] NA      "33737" "33713" "33738" "33794"

There are 126 unique individual scale numbers.

**NA and Unknown Values**

-   89.2 % of values in the `scale_nu` column are NA.

### Variable:`tissue_nu`

``` r
unique(cleaner_data$tissue_nu)[1:5]
```

    ## [1] NA        "S15-039" "S15-040" "S15-041" "S15-042"

There are 32 unique individual tissue numbers.

**NA and Unknown Values**

-   97.3 % of values in the `tissue_nu` column are NA.

### Variable:`otolith_nu`

``` r
unique(cleaner_data$otolith_nu)[1:5]
```

    ## [1] NA         "09221501" "09221502" "09221503" "09241501"

There are 14 unique individual otolith numbers.

**NA and Unknown Values**

-   98.9 % of values in the `otolith_nu` column are NA.

### Variable:`comments`

``` r
unique(cleaner_data$comments)[1:5]
```

    ## [1] NA NA NA NA NA

No coomments marked in data from 2014 - 2016.

**NA and Unknown Values**

-   100 % of values in the `comments` column are NA.

## Explore Numerical Variables

``` r
cleaner_data %>% 
  select_if(is.numeric) %>% colnames()
```

    ## [1] "disc_tag_applied" "fork_length_mm"

### Variable:`disc_tag_applied`

``` r
cleaner_data %>% 
  ggplot(aes(x = disc_tag_applied))+
  geom_histogram()+
  labs(title = "Distribution of Disc Tag Applied")+
  theme_minimal()
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](butte-2014-2016-individual-qc-checklist_files/figure-gfm/unnamed-chunk-19-1.png)<!-- -->
Disc-tag seems to be separated into 0-1000 and 2000-3000.

``` r
summary(cleaner_data$disc_tag_applied)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##       2     449     849    1293    2406    2900       4

**NA and Unknown Values**

-   0.3 % of values in the `disc_tag_applied` column are NA.

### Variable:`fork_length_mm`

``` r
cleaner_data %>% 
  # mutate(years = as.factor(year(date))) %>%
  filter(fork_length_mm < 2000) %>%  #filter out one large value for better view of distribution
  ggplot(aes(x = fork_length_mm))+
  geom_histogram(bin = 10)+
  labs(title = "Distribution of Fork Length")+
  theme_minimal()
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](butte-2014-2016-individual-qc-checklist_files/figure-gfm/unnamed-chunk-21-1.png)<!-- -->

``` r
summary(cleaner_data$fork_length_mm)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   370.0   665.0   712.0   725.7   779.0  2380.0

**NA and Unknown Values**

-   0 % of values in the `fork_length_mm` column are NA.

## Issues Identified

-   Need description and look up table for the majority of the data
-   Lot of incomplete data
-   Are these the most important variables for carcass data?

## Add cleaned data back to google cloud

``` r
butte_individual_survey_2014_2016 <- cleaner_data %>% glimpse()
```

    ## Rows: 1,153
    ## Columns: 16
    ## $ survey           <chr> "110013", "110013", "110013", "110013", "110013", "11~
    ## $ date             <date> 2014-09-23, 2014-09-23, 2014-09-23, 2014-09-23, 2014~
    ## $ section_cd       <chr> "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"~
    ## $ way_pt           <chr> "A1", "A1", "A2", "A2", "A2", "A2", "A3", "A3", "A3",~
    ## $ disposition      <chr> "tagged", "tagged", "tagged", "tagged", "tagged", "ta~
    ## $ disc_tag_applied <dbl> 240, 239, 226, 235, 241, 210, 209, 103, 116, 216, 208~
    ## $ sex              <chr> "female", "female", "female", "female", "female", "fe~
    ## $ fork_length_mm   <dbl> 675, 764, 650, 779, 869, 810, 686, 730, 638, 712, 733~
    ## $ condition        <chr> "f", "f", "f", "f", "f", "f", "f", "f", "f", "f", "f"~
    ## $ spawning_status  <chr> "yes", "p", "yes", "no", "yes", "p", "no", "yes", "ye~
    ## $ ad_fin_clip_cd   <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALS~
    ## $ scale_nu         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ tissue_nu        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ otolith_nu       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ comments         <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ cwt_status       <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~

``` r
write_csv(butte_individual_survey_2014_2016, "butte_carcass_2014-2016.csv")
```

``` r
f <- function(input, output) write_csv(input, file = output)
gcs_upload(butte_individual_survey_2014_2016,
           object_function = f,
           type = "csv",
           name = "adult-holding-redd-and-carcass-surveys/butte-creek/data/butte_carcass_2014-2016.csv")
```
