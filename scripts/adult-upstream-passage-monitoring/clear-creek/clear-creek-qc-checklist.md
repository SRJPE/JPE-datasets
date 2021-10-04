Clear Creek Adult Upstream Video Data QC Checklist
================
Erin Cain
9/29/2021

# Clear Creek Adult Upstream Video Data

## Description of Monitoring Data

**Data type** Raw passage counts

**Timeframe:** 2013-2020

**Video Season:** TODO

**Completeness of Record throughout timeframe:** Data are not padded -
missing data indicate a period where footage was not collected by USFWS
(However we are filtering for spring run so it is also possible that
footage was taken but no spring run were found)

-   TODO investigate/talk about outages, is a 0 a real zero or explained
    by other factors

**Sampling Location:** Located at the mouth of clear creek

**Data Contact:** [Sam Provins](mailto:samuel_provins@fws.gov)

Additional information describing this monitoring data is available in
the [Adult Spring Run Chinook Salmon Monitoring in Clear Creek
Report](https://www.fws.gov/redbluff/CC%20BC/Clear%20Creek%20Monitoring%20Final%20Reports/2013-2018%20Clear%20Creek%20Adult%20Spring-run%20Chinook%20Salmon%20Monitoring.pdf)
prepared by USFWS.

## Access Cloud Data

``` r
# Run Sys.setenv() to specify GCS_AUTH_FILE and GCS_DEFAULT_BUCKET before running 
# getwd()
# Open object from google cloud storage
# Set your authentication using gcs_auth
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
# Set global bucket 
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

# git data and save as xlsx
gcs_get_object(object_name = 
                 "adult-upstream-passage-monitoring/clear-creek/data-raw/ClearCreekVideoWeir_AdultRecruitment_2013-2020.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "raw_clear_creek_passage_data.xlsx",
               overwrite = TRUE)
```

Read in data from google cloud, glimpse raw data and domain description
sheet:

``` r
# read in data to clean 
sheets <- readxl::excel_sheets("raw_clear_creek_passage_data.xlsx")
domain_description <- readxl::read_excel("raw_clear_creek_passage_data.xlsx", 
                                         sheet = "Domain Description") 
domain_description %>% head(10)
```

    ## # A tibble: 10 x 2
    ##    Domain            Description                                                
    ##    <chr>             <chr>                                                      
    ##  1 DATE              "XX/XX/XXXX Date of the day watched, (neccessary for when ~
    ##  2 TIME BLOCK START  "Use military time-Top of the hour or half hour through 29~
    ##  3 VIEWING CONDITION "Viewing Conditions: 0=Normal (good visibility, clear wate~
    ##  4 SPECIES           "Choose from drop down list. If nothing passed in the half~
    ##  5 UP                "Total passing up and down of the white plate. Use individ~
    ##  6 DOWN               <NA>                                                      
    ##  7 TIME              "HH:MM:SS. Use specific time for all Salmon, Steelhead/tro~
    ##  8 ADIPOSE           "Salmon and trout only. Partial clipped adipose fins are c~
    ##  9 SEX               "Salmon and trout only."                                   
    ## 10 JACKSIZE          "Salmon only (Fork Length less than 22\"). Total width of ~

``` r
raw_video_data <- readxl::read_excel("raw_clear_creek_passage_data.xlsx", 
                                     sheet = "ClearCreekVideoWeir_AdultRecrui",
                                     col_types = c("numeric", "date", "date", 
                                                   "text", "text", "numeric", 
                                                   "numeric", "date", "text",
                                                   "text", "text", "text", 
                                                   "text", "text")) %>% 
  glimpse()
```

    ## Rows: 99,996
    ## Columns: 14
    ## $ Video_Year         <dbl> 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13,~
    ## $ Date               <dttm> 2012-12-17, 2012-12-17, 2012-12-17, 2012-12-17, 20~
    ## $ Time_Block         <dttm> 1899-12-31 10:30:00, 1899-12-31 11:00:00, 1899-12-~
    ## $ Viewing_Condition  <chr> "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "~
    ## $ Species            <chr> "NONE", "NONE", "NONE", "NONE", "NONE", "NONE", "CH~
    ## $ Up                 <dbl> 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 1, 1, 0, 0, 0, 1, ~
    ## $ Down               <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, ~
    ## $ Time_Passed        <dttm> NA, NA, NA, NA, NA, NA, 1899-12-31 13:46:00, 1899-~
    ## $ Adipose            <chr> NA, NA, NA, NA, NA, NA, "PRESENT", "PRESENT", NA, "~
    ## $ Sex                <chr> NA, NA, NA, NA, NA, NA, "MALE", "UNK", NA, "UNK", N~
    ## $ Spawning_Condition <chr> NA, NA, NA, NA, NA, NA, "3", "3", NA, "3", NA, "3",~
    ## $ Jack_Size          <chr> NA, NA, NA, NA, NA, NA, "NO", "NO", NA, "UNK", NA, ~
    ## $ Run                <chr> NA, NA, NA, NA, NA, NA, "LF", "LF", NA, NA, NA, NA,~
    ## $ STT_Size           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, ">16", NA, ">16~

## Data transformations

We cleaned up the column names, filtered to only show Spring Run Chinook
data, and removed an unneeded and redundant columns.

``` r
cleaner_video_data <- raw_video_data %>% 
  set_names(tolower(colnames(raw_video_data))) %>%
  mutate(date = as.Date(date),
         time_block = hms::as_hms(time_block),
         time_passed = hms::as_hms(time_passed)) %>%
  filter(species == "CHN", run == "SR") %>%
  select(-stt_size, -video_year, -species, -run) %>% 
  glimpse() 
```

    ## Rows: 2,279
    ## Columns: 10
    ## $ date               <date> 2013-03-26, 2013-03-26, 2013-03-31, 2013-03-31, 20~
    ## $ time_block         <time> 04:30:00, 22:30:00, 16:00:00, 21:30:00, 11:30:00, ~
    ## $ viewing_condition  <chr> "0", "0", "0", "0", "0", "1", "1", "1", "1", "0", "~
    ## $ up                 <dbl> 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ~
    ## $ down               <dbl> 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
    ## $ time_passed        <time> 04:47:00, 22:48:00, 16:09:00, 21:34:00, 11:53:00, ~
    ## $ adipose            <chr> "UNK", "UNK", "UNK", "UNK", "UNK", "UNK", "ABSENT",~
    ## $ sex                <chr> "UNK", "UNK", "UNK", "UNK", "UNK", "UNK", "UNK", "U~
    ## $ spawning_condition <chr> "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "~
    ## $ jack_size          <chr> "YES", "NO", "NO", "NO", "NO", "NO", "NO", "YES", "~

## Explore Numeric Variables:

``` r
cleaner_video_data %>% select_if(is.numeric) %>% colnames()
```

    ## [1] "up"   "down"

### Variable: `up`

**Plotting Passage Counts Moving Up over Period of Record**

``` r
cleaner_video_data %>% ggplot(aes(x = date, y = up)) + 
  geom_col() + 
  facet_wrap(~year(date), scales = "free") + 
  scale_x_date(labels = date_format("%b"), date_breaks = "1 month") + 
  theme_minimal() + 
  theme(text = element_text(size = 23),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + 
  labs(title = "Daily Count of Upstream Passage (2013-2020)")  
```

![](clear-creek-qc-checklist_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

``` r
# Boxplots of daily counts by year
cleaner_video_data %>% group_by(date) %>%
  summarise(daily_count_upstream = sum(up)) %>%
  mutate(year = as.factor(year(date))) %>% 
  ggplot(aes(x = year, y = daily_count_upstream)) + 
  geom_boxplot() + 
  theme_minimal() +
  theme(text = element_text(size = 23)) + 
  labs(title = "Daily Count of Upstream Passage (2013-2020) Sumarized by Year")  
```

![](clear-creek-qc-checklist_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

**Numeric Summary of Passage Counts Moving Up over Period of Record**

``` r
# Table with summary statistics
summary(cleaner_video_data$up)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##  0.0000  1.0000  1.0000  0.7824  1.0000  1.0000

``` r
# daily numeric summary 
cleaner_video_data %>% group_by(date) %>%
  summarise(count = sum(up, na.rm = T)) %>%
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   0.000   1.000   2.000   3.123   4.000  40.000

**NA and Unknown Values**

-   0 % of values in the `up` column are NA. However, there are clearly
    gaps in data. More investigation needs to be done to see if 0 is a
    real 0 or if it can be explained by other factors (outages).

### Variable: `down`

**Plotting Passage Counts Moving Down over Period of Record**

``` r
cleaner_video_data %>% ggplot(aes(x = date, y = down)) + 
  geom_col() + 
  facet_wrap(~year(date), scales = "free") + 
  scale_x_date(labels = date_format("%b"), date_breaks = "1 month") + 
  theme_minimal() + 
  theme(text = element_text(size = 23),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + 
  labs(title = "Daily Count of Downstream Passage (2013-2020)")  
```

![](clear-creek-qc-checklist_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

``` r
cleaner_video_data %>% group_by(date) %>%
  summarise(daily_count_downstream = sum(down)) %>%
  mutate(year = as.factor(year(date))) %>% 
  ggplot(aes(x = year, y = daily_count_downstream)) + 
  geom_boxplot() + 
  theme_minimal() +
  labs(title = "Daily Count of Downstream Passage (2013-2020) Sumarized by Year") + 
  theme(text = element_text(size = 23)) 
```

![](clear-creek-qc-checklist_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

**Numeric Summary of Passage Counts Moving Down over Period of Record**

``` r
# Table with summary statistics 
summary(cleaner_video_data$down)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##  0.0000  0.0000  0.0000  0.2172  0.0000  1.0000

``` r
# Daily numeric summary of passage data
cleaner_video_data %>% group_by(date) %>%
  summarise(count = sum(down, na.rm = T)) %>%
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##  0.0000  0.0000  1.0000  0.8669  1.0000  7.0000

**NA and Unknown Values**

-   0 % of values in the `up` column are NA.

## Explore Categorical variables:

``` r
# Filter for coltypes that are characters
cleaner_video_data %>% select_if(is.character) %>% colnames()
```

    ## [1] "viewing_condition"  "adipose"            "sex"               
    ## [4] "spawning_condition" "jack_size"

### Variable: `viewing_condition`

``` r
table(cleaner_video_data$viewing_condition) 
```

    ## 
    ##    0    1    2 
    ## 1596  661   22

**Create lookup rda for viewing condition encoding:**

``` r
# View description of domain for viewing condition 
description <- domain_description[which(domain_description$Domain == "VIEWING CONDITION"), ]$Description
clear_passage_viewing_condition <- 0:3
names(clear_passage_viewing_condition) <- c(
  "Normal (good visability, clear water, all equiptment working, no obstructions)", 
  "Readable (lower confidence due to turbidity or partial loss of video equiptment)", 
  "Not Readable (high turbidity or equiptment failure)",
  "Weir is flooded")

write_rds(clear_passage_viewing_condition, "../../data/clear_passage_viewing_condition.rds")

tibble(code = clear_passage_viewing_condition, 
       definitions = names(clear_passage_viewing_condition))
```

    ## # A tibble: 4 x 2
    ##    code definitions                                                             
    ##   <int> <chr>                                                                   
    ## 1     0 Normal (good visability, clear water, all equiptment working, no obstru~
    ## 2     1 Readable (lower confidence due to turbidity or partial loss of video eq~
    ## 3     2 Not Readable (high turbidity or equiptment failure)                     
    ## 4     3 Weir is flooded

**NA and Unknown Values**

-   0 % of values in the `viewing_condition` column are NA.
-   0.01 % of values in the `viewing_condition` column are considered
    Not Readable because of high turbidity or equipment failure.

### Variable: `adipose`

``` r
table(cleaner_video_data$adipose) 
```

    ## 
    ##  Absent  ABSENT PRESENT     UNK UNKNOWN 
    ##       1     195    1018     845     219

``` r
description <- domain_description[which(domain_description$Domain == "ADIPOSE"), ]$Description
```

Fix inconsistencies with spelling, capitalization, and abbreviations.

``` r
# Fix yes/no/unknown
cleaner_video_data$adipose = tolower(if_else(cleaner_video_data$adipose == "UNK", "unknown", cleaner_video_data$adipose))
```

**NA or Unknown Values**

-   0 % of values in the `adipose` column are NA.
-   0.467 % of values in the `adipose` column are`unknown`.

### Variable: `sex`

``` r
table(cleaner_video_data$sex) 
```

    ## 
    ##  FEMALE    Male    MALE     UNK UNKNOWN 
    ##      59       1     104    1648     464

Fix inconsistencies with spelling, capitalization, and abbreviations.

``` r
# Fix yes/no/unknown
cleaner_video_data$sex = tolower(if_else(cleaner_video_data$sex == "UNK", "unknown", cleaner_video_data$sex))
```

**NA or Unknown Values**

-   0.001 % of values in the `sex` column are NA.
-   0.927 % of values in the `sex` column are`unknown`.

### Variable: `spawning_condition`

Describes fish condition as it relates to spawning.

``` r
table(cleaner_video_data$spawning_condition)
```

    ## 
    ##    1    2    3    4    5 
    ## 1879   73   95   29  144

**Create lookup rda for spawning condition encoding:**

``` r
# View description of domain for viewing condition 
description <- domain_description[which(domain_description$Domain == "SPAWNING CONDITION"), ]$Description
clear_passage_spawning_condition <- c(1:5)
names(clear_passage_spawning_condition) <- c(
  "Energetic; bright or silvery; no spawning coloration or developed secondary sex characteristics.",
  "Energetic, can tell sex from secondary characteristics (kype) silvery or bright coloration but may have some hint of spawning colors.",
  "Spawning colors, defined kype, some tail wear or small amounts of fungus.",
  "Fungus, lethargic, wandering; “ Zombie fish”. Significant tail wear in females to indicate the spawning process has already occurred.",
  "Unable to make distinction.")

write_rds(clear_passage_spawning_condition, "../../data/clear_passage_spawning_condition.rds")

tibble(code = clear_passage_spawning_condition, 
       definitions = names(clear_passage_spawning_condition))
```

    ## # A tibble: 5 x 2
    ##    code definitions                                                             
    ##   <int> <chr>                                                                   
    ## 1     1 Energetic; bright or silvery; no spawning coloration or developed secon~
    ## 2     2 Energetic, can tell sex from secondary characteristics (kype) silvery o~
    ## 3     3 Spawning colors, defined kype, some tail wear or small amounts of fungu~
    ## 4     4 Fungus, lethargic, wandering; “ Zombie fish”. Significant tail wear in ~
    ## 5     5 Unable to make distinction.

**NA or Unknown Values**

-   0.026 % of values in the `spawning_condition` column are NA.

-   0.063 % of values in the `spawning_condition` column are considered
    Unknown.

### Variable: `jack_size`

Whether or not the total width of Jack plate is 22".

``` r
table(cleaner_video_data$jack_size) 
```

    ## 
    ##   NO  UNK  Yes  YES 
    ## 1958   21    1  283

``` r
description <- domain_description[which(domain_description$Domain == "JACKSIZE"), ]$Description
```

Fix inconsistencies with spelling, capitalization, and abbreviations.

``` r
# Fix yes/no/unknown
cleaner_video_data$jack_size = tolower(if_else(cleaner_video_data$jack_size == "UNK", "unknown", cleaner_video_data$jack_size))
```

**NA or Unknown Values**

-   0.007 % of values in the `jack_size` column are NA.
-   0.009 % of values in the `jack_size` column are`unknown`.

``` r
clear_passage <- cleaner_video_data %>% 
  glimpse()
```

    ## Rows: 2,279
    ## Columns: 10
    ## $ date               <date> 2013-03-26, 2013-03-26, 2013-03-31, 2013-03-31, 20~
    ## $ time_block         <time> 04:30:00, 22:30:00, 16:00:00, 21:30:00, 11:30:00, ~
    ## $ viewing_condition  <chr> "0", "0", "0", "0", "0", "1", "1", "1", "1", "0", "~
    ## $ up                 <dbl> 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ~
    ## $ down               <dbl> 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ~
    ## $ time_passed        <time> 04:47:00, 22:48:00, 16:09:00, 21:34:00, 11:53:00, ~
    ## $ adipose            <chr> "unknown", "unknown", "unknown", "unknown", "unknow~
    ## $ sex                <chr> "unknown", "unknown", "unknown", "unknown", "unknow~
    ## $ spawning_condition <chr> "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "~
    ## $ jack_size          <chr> "yes", "no", "no", "no", "no", "no", "no", "yes", "~

### Save cleaned data back to google cloud

``` r
f <- function(input, output) write_csv(input, file = output)

gcs_upload(clear_passage,
           object_function = f,
           type = "csv",
           name = "adult-upstream-passage-monitoring/clear-creek/data/clear_passage.csv")
```
