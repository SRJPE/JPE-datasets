butte-2017-2020-individual-qc-checklist
================
Inigo Peng
10/21/2021

------------------------------------------------------------------------

# Butte Creek Individual Survey Data

## Description of Monitoring Data

**Timeframe:** 2017-2020

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
    preserve the column types. This file runs 2017-2020 QC

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

later_years <- c(2017, 2018, 2020)
purrr::map(later_years, read_from_cloud)
raw_later_data <- purrr::map(later_years, open_files) %>%
  reduce(bind_rows)
write_csv(raw_later_data, "raw_2017_to_2020_individuals_data.csv")

year <- 2019
read_from_cloud(year)
raw_2019_data <- readxl::read_excel("2019_raw_surveyindividuals.xlsx")
write_csv(raw_2019_data, "2019_raw_surveyindividuals.csv")
# combined_data <- bind_rows(raw_earlier_data, raw_later_data)
# write_csv(combined_data, "combined_data.csv")
```

Read in data from google cloud, glimpse raw data and domain description
sheet:

``` r
# read in data to clean

raw_later_individuals_data <- read_csv("raw_2017_to_2020_individuals_data.csv")%>% glimpse()
```

    ## Rows: 565 Columns: 26

    ## -- Column specification --------------------------------------------------------
    ## Delimiter: ","
    ## chr  (12): LocationCD, SectionCD, WayPt, SpeciesCode, Disposition, Sex, Cond...
    ## dbl   (7): Survey, Year, Week, DiscTagApplied, FLmm, FLcm, ScaleNu
    ## lgl   (6): HeadNu, DNAnu, OtherMarks, CWTStatusID, CWTStatus, CWTcd
    ## dttm  (1): Date

    ## 
    ## i Use `spec()` to retrieve the full column specification for this data.
    ## i Specify the column types or set `show_col_types = FALSE` to quiet this message.

    ## Rows: 565
    ## Columns: 26
    ## $ Survey         <dbl> 110002, 110002, 110002, 110002, 110002, 110002, 110002,~
    ## $ LocationCD     <chr> "Upper survey", "Upper survey", "Upper survey", "Upper ~
    ## $ Year           <dbl> 2017, 2017, 2017, 2017, 2017, 2017, 2017, 2017, 2017, 2~
    ## $ Week           <dbl> 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2~
    ## $ Date           <dttm> 2017-09-26, 2017-09-26, 2017-09-26, 2017-10-03, 2017-1~
    ## $ SectionCD      <chr> "A", "A", "A", "A", "A", "A", "A", "B", "B", "C", "C", ~
    ## $ WayPt          <chr> "A1", "A5", "A5", "A2", "A2", "A3", "A5", "B3", "B8", "~
    ## $ SpeciesCode    <chr> "CHN-Spring", "CHN-Spring", "CHN-Spring", "CHN-Spring",~
    ## $ Disposition    <chr> "Tagged", "Tagged", "Tagged", "Tagged", "Tagged", "Tagg~
    ## $ DiscTagApplied <dbl> 2980, 2983, 2977, 2731, 2732, 2733, 2734, 2757, 2758, 2~
    ## $ Sex            <chr> "F", "M", "M", "F", "F", "F", "M", "M", "M", "M", "F", ~
    ## $ FLmm           <dbl> 900, 527, 878, 570, 555, 760, 960, 853, 528, 760, 790, ~
    ## $ FLcm           <dbl> 90.0, 52.7, 87.8, 57.0, 55.5, 76.0, 96.0, 85.3, 52.8, 7~
    ## $ ConditionCD    <chr> "F", "F", "F", "F", "F", "F", "F", "F", "F", "F", "F", ~
    ## $ SpawnedCD      <chr> "N", "n/r", "n/r", "N", "N", "N", "Unk", "Unk", "Unk", ~
    ## $ AdFinClipCD    <chr> "N", "N", "N", "N", "N", "N", "N", "N", "N", "N", "N", ~
    ## $ HeadNu         <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ ScaleNu        <dbl> 20607, 20610, 20609, 20703, 20661, 20660, 20659, 20751,~
    ## $ TissueNu       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, "20614"~
    ## $ OtolithNu      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ DNAnu          <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ Comments       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ OtherMarks     <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ CWTStatusID    <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ CWTStatus      <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ CWTcd          <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~

``` r
raw_2019_individuals_data <- read_csv("2019_raw_surveyindividuals.csv") %>% glimpse()
```

    ## Rows: 506 Columns: 17

    ## -- Column specification --------------------------------------------------------
    ## Delimiter: ","
    ## chr (10): WayPt, Sex, ConditionCD, SpawnedCD, AdFinClipCD, HeadNu, ScaleNu, ...
    ## dbl  (2): DiscTagApplied, FLcm
    ## lgl  (5): DNAnu, OtherMarks, CWTStatusID, CWTStatus, CWTcd

    ## 
    ## i Use `spec()` to retrieve the full column specification for this data.
    ## i Specify the column types or set `show_col_types = FALSE` to quiet this message.

    ## Rows: 506
    ## Columns: 17
    ## $ WayPt          <chr> "B4", "B7", "B7", "B8", "B8", "B8", "C1", "C2", "C2", "~
    ## $ DiscTagApplied <dbl> 2305, 1345, 1371, 2651, 2316, 2606, 1365, 2422, 2208, 2~
    ## $ Sex            <chr> "F", "F", "F", "M", "F", "F", "F", "F", "F", "F", "F", ~
    ## $ FLcm           <dbl> 71.3, 75.0, 70.0, 85.0, 64.3, 68.2, 80.0, 73.7, 72.5, 8~
    ## $ ConditionCD    <chr> "F", "F", "F", "F", "F", "F", "F", "F", "F", "F", "F", ~
    ## $ SpawnedCD      <chr> "N", "N", "N", "n/r", "N", "P", "P", "P", "N", "N", "N"~
    ## $ AdFinClipCD    <chr> "N", "N", "N", "N", "N", "N", "N", "N", "N", "N", "N", ~
    ## $ HeadNu         <chr> "N/A", "N/A", "N/A", "N/A", NA, "N/A", "N/A", NA, NA, N~
    ## $ ScaleNu        <chr> "N/A", "N/A", "N/A", "N/A", NA, "N/A", "N/A", NA, NA, N~
    ## $ TissueNu       <chr> "N/A", "N/A", "N/A", "N/A", NA, "N/A", "N/A", NA, NA, N~
    ## $ OtolithNu      <chr> "N/A", "N/A", "N/A", "N/A", NA, "N/A", "N/A", NA, NA, N~
    ## $ DNAnu          <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ Comments       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ OtherMarks     <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ CWTStatusID    <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ CWTStatus      <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~
    ## $ CWTcd          <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,~

## Data Transformations

``` r
cleaner_data<- raw_later_individuals_data %>%
  janitor::clean_names() %>%
  rename('fork_length_cm' = 'f_lcm',
         'condition' = 'condition_cd',
         'spawning_status' = 'spawned_cd') %>% 
  select(-c('week', 'year', 'f_lmm','location_cd', 'species_code','disposition','other_marks', 'cwt_status_id', 'cwt_status', 'cw_tcd', 'dn_anu', 'head_nu')) %>% #all location the same,all spring run chinook, all tagged, all no ad fin clip, no data for the rest of the dropped columns
  mutate(date = as.Date(date),
         scale_nu = as.character(scale_nu)) %>% #scale_nu is identifier
  glimpse()
```

    ## Rows: 565
    ## Columns: 14
    ## $ survey           <dbl> 110002, 110002, 110002, 110002, 110002, 110002, 11000~
    ## $ date             <date> 2017-09-26, 2017-09-26, 2017-09-26, 2017-10-03, 2017~
    ## $ section_cd       <chr> "A", "A", "A", "A", "A", "A", "A", "B", "B", "C", "C"~
    ## $ way_pt           <chr> "A1", "A5", "A5", "A2", "A2", "A3", "A5", "B3", "B8",~
    ## $ disc_tag_applied <dbl> 2980, 2983, 2977, 2731, 2732, 2733, 2734, 2757, 2758,~
    ## $ sex              <chr> "F", "M", "M", "F", "F", "F", "M", "M", "M", "M", "F"~
    ## $ fork_length_cm   <dbl> 90.0, 52.7, 87.8, 57.0, 55.5, 76.0, 96.0, 85.3, 52.8,~
    ## $ condition        <chr> "F", "F", "F", "F", "F", "F", "F", "F", "F", "F", "F"~
    ## $ spawning_status  <chr> "N", "n/r", "n/r", "N", "N", "N", "Unk", "Unk", "Unk"~
    ## $ ad_fin_clip_cd   <chr> "N", "N", "N", "N", "N", "N", "N", "N", "N", "N", "N"~
    ## $ scale_nu         <chr> "20607", "20610", "20609", "20703", "20661", "20660",~
    ## $ tissue_nu        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, "2061~
    ## $ otolith_nu       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ comments         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~

``` r
cleaner_2019_data<- raw_2019_individuals_data %>%
  janitor::clean_names() %>% 
  select(-c('head_nu','scale_nu','tissue_nu', 'dn_anu', 'otolith_nu','comments', 'other_marks', 'cwt_status_id', 'cwt_status', 'cw_tcd')) %>% 
  glimpse()
```

    ## Rows: 506
    ## Columns: 7
    ## $ way_pt           <chr> "B4", "B7", "B7", "B8", "B8", "B8", "C1", "C2", "C2",~
    ## $ disc_tag_applied <dbl> 2305, 1345, 1371, 2651, 2316, 2606, 1365, 2422, 2208,~
    ## $ sex              <chr> "F", "F", "F", "M", "F", "F", "F", "F", "F", "F", "F"~
    ## $ f_lcm            <dbl> 71.3, 75.0, 70.0, 85.0, 64.3, 68.2, 80.0, 73.7, 72.5,~
    ## $ condition_cd     <chr> "F", "F", "F", "F", "F", "F", "F", "F", "F", "F", "F"~
    ## $ spawned_cd       <chr> "N", "N", "N", "n/r", "N", "P", "P", "P", "N", "N", "~
    ## $ ad_fin_clip_cd   <chr> "N", "N", "N", "N", "N", "N", "N", "N", "N", "N", "N"~

Bind 2019 data to the whole data frame

``` r
cleaner_data <- bind_rows(cleaner_data, cleaner_2019_data)
```

## Explore `date`

``` r
summary(cleaner_data$date)
```

    ##         Min.      1st Qu.       Median         Mean      3rd Qu.         Max. 
    ## "2017-09-26" "2018-10-02" "2018-10-09" "2019-04-17" "2020-10-02" "2020-10-30" 
    ##         NA's 
    ##        "506"

**NA and Unknown Values**

-   47.2 % of values in the `date` column are NA.

## Explore Categorical Variables

``` r
cleaner_data %>% 
  select_if(is.character) %>% colnames()
```

    ##  [1] "section_cd"      "way_pt"          "sex"             "condition"      
    ##  [5] "spawning_status" "ad_fin_clip_cd"  "scale_nu"        "tissue_nu"      
    ##  [9] "otolith_nu"      "comments"        "condition_cd"    "spawned_cd"

### Variable:`section_cd`

-   A - Quartz Bowl Pool downstream to Whiskey Flat
-   B - Whiskey Flat downstream to Helltown Bridge
-   C - Helltown Bridge downstream to Quail Run Bridge
-   ‘COV-OKIE’ - Centerville Covered Brdige to Okie Dam
-   D - Quail Run Bridge downstream to Cable Bridge
-   E - Cable Bridge downstream ot Centerville; sdf Cable Bridge
    downstream to Centerville Covered Bridge

``` r
table(cleaner_data$section_cd)
```

    ## 
    ##        A        B        C COV-OKIE        D        E 
    ##       87      180      197        9       75       17

### Variable:`way_pt`

``` r
cleaner_data <- cleaner_data %>%
  mutate(way_pt = set_names(toupper(way_pt)))
table(cleaner_data$way_pt)
```

    ## 
    ##         A1         A2         A3         A4         A5         B1         B2 
    ##         18         22         24         21         16         13          9 
    ##         B3         B4         B5         B6         B7         B8     BCK-PL 
    ##          7          8         27         49         81         74         17 
    ##    BCK-PWR         C1        C10        C11        C12         C2         C3 
    ##          7         52         10         11         34         45         27 
    ##         C4         C5         C6         C7         C8         C9    COV-BCK 
    ##         38         43         45         36         30         23         20 
    ##   COV-OKIE COVER-OKIE         D1         D2         D3         D4         D5 
    ##         11          1         24         51         35         19          9 
    ##         D6         D7         D8         E1         E2         E3         E4 
    ##         14         14          4         12         13         11          9 
    ##         E5         E6         E7        N/R         NR 
    ##          8          8         10         10          1

**NA and Unknown Values**

-   0 % of values in the `way_pt` column are NA.

### Variable:`sex`

``` r
table(cleaner_data$sex)
```

    ## 
    ##   F   M 
    ## 630 441

**NA and Unknown Values**

-   0 % of values in the `sex` column are NA.

### Variable:`condition`

TODO: need lookup table

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
    ##   d   f 
    ##  66 499

**NA and Unknown Values**

-   47.2 % of values in the `condition` column are NA.

### Variable:`spawning_status`

``` r
cleaner_data <- cleaner_data %>% 
  mutate(spawning_status = set_names(tolower(spawning_status)),
         spawning_status = 
           case_when(spawning_status == "n" ~ "no",
                     spawning_status == "y" ~ "yes",
                     spawning_status == "n/r" ~ 'not recorded',
                     spawning_status == "unk" ~ "unknown",
                     TRUE ~ as.character(spawning_status)
  ))

table(cleaner_data$spawning_status)
```

    ## 
    ##           no not recorded            p      unknown          yes 
    ##           10          246           23            6          280

**NA and Unknown Values**

-   47.2 % of values in the `spawning_status` column are NA.

### Variable: `scale_nu`

``` r
unique(cleaner_data$scale_nu)[1:5]
```

    ## [1] "20607" "20610" "20609" "20703" "20661"

**NA and Unknown Values**

-   83.9 % of values in the `scale_nu` column are NA.

### Variable:`tissue_nu`

``` r
unique(cleaner_data$tissue_nu)[1:5]
```

    ## [1] NA            "20614"       "20608"       "2092420-C-1" "S092920-C-1"

**NA and Unknown Values**

-   89.4 % of values in the `tissue_nu` column are NA.

### Variable:`otolith_nu`

``` r
unique(cleaner_data$otolith_nu)[1:5]
```

    ## [1] NA          "S19034-20" "S19035-20" "S19036-20" "S19037-20"

**NA and Unknown Values**

-   98.4 % of values in the `otolith_nu` column are NA.

### Variable:`comments`

``` r
unique(cleaner_data$comments)[1:5]
```

    ## [1] NA                   "25% EGG RETENTION"  "0% EGG RETENTION"  
    ## [4] "50% EGG RETENTION"  "100% EGG RETENTION"

**NA and Unknown Values**

-   95 % of values in the `comments` column are NA.

## Explore Numerical Variables

``` r
cleaner_data %>% 
  select_if(is.numeric) %>% colnames()
```

    ## [1] "survey"           "disc_tag_applied" "fork_length_cm"   "f_lcm"

### Variable:`disc_tag_applied`

``` r
summary(cleaner_data$disc_tag_applied)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##       9    1037    1326    2431    2269  906653       1

**NA and Unknown Values**

-   0.1 % of values in the `disc_tag_applied` column are NA.

### Variable:`fork_length_cm`

``` r
cleaner_data %>% 
  # mutate(years = as.factor(year(date))) %>%
  filter(fork_length_cm < 200) %>%  #filter out one large value for better view of distribution
  ggplot(aes(x = fork_length_cm))+
  geom_histogram(bin = 10)+
  labs(title = "Distribution of Fork Length")
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](butte-2017-2020-individual-qc-checklist_files/figure-gfm/unnamed-chunk-20-1.png)<!-- -->

``` r
summary(cleaner_data$fork_length_cm)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   42.00   67.50   73.00   73.03   79.50  101.00     506

**NA and Unknown Values**

-   47.2 % of values in the `fork_length_cm` column are NA.

## Issues Identified

-   Need description and look up table for the majority of the data
-   Incomplete data for most of the columns

## Add cleaned data back to google cloud

``` r
butte_individual_survey_2017_2020 <- cleaner_data %>% glimpse()
```

    ## Rows: 1,071
    ## Columns: 17
    ## $ survey           <dbl> 110002, 110002, 110002, 110002, 110002, 110002, 11000~
    ## $ date             <date> 2017-09-26, 2017-09-26, 2017-09-26, 2017-10-03, 2017~
    ## $ section_cd       <chr> "A", "A", "A", "A", "A", "A", "A", "B", "B", "C", "C"~
    ## $ way_pt           <chr> "A1", "A5", "A5", "A2", "A2", "A3", "A5", "B3", "B8",~
    ## $ disc_tag_applied <dbl> 2980, 2983, 2977, 2731, 2732, 2733, 2734, 2757, 2758,~
    ## $ sex              <chr> "F", "M", "M", "F", "F", "F", "M", "M", "M", "M", "F"~
    ## $ fork_length_cm   <dbl> 90.0, 52.7, 87.8, 57.0, 55.5, 76.0, 96.0, 85.3, 52.8,~
    ## $ condition        <chr> "f", "f", "f", "f", "f", "f", "f", "f", "f", "f", "f"~
    ## $ spawning_status  <chr> "no", "not recorded", "not recorded", "no", "no", "no~
    ## $ ad_fin_clip_cd   <chr> "N", "N", "N", "N", "N", "N", "N", "N", "N", "N", "N"~
    ## $ scale_nu         <chr> "20607", "20610", "20609", "20703", "20661", "20660",~
    ## $ tissue_nu        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, "2061~
    ## $ otolith_nu       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ comments         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ f_lcm            <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ condition_cd     <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
    ## $ spawned_cd       <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~

``` r
write_csv(butte_individual_survey_2017_2020, "butte-carcass-individual-survey-2017-2020.csv")
```

``` r
f <- function(input, output) write_csv(input, file = output)
gcs_upload(butte_creek_rst,
           object_function = f,
           type = "csv",
           name = "rst/butte-creek/data/butte-carcass-individual-survey-2017-2020.csv")
```
