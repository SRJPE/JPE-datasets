butte-creek-carcass-chopcount-qc-checklist
================
Inigo Peng
10/21/2021

------------------------------------------------------------------------

# BUtte Creek Carcass Survey Data

## Description of Monitoring Data

**Timeframe:** 2014-2020

**Completeness of Record throughout timeframe:**

**Sampling Location:** Various sampling locations on Butte Creek.

TODO: Upper survey?

**Data Contact:** [Jessica
Nichols](mailto::Jessica.Nichols@Wildlife.ca.gov)

Additional Info:  
The carcass data came in 12 documents for each year. We identified the
‘SurveyChops’ and ‘SurveyIndividuals’ datasets as the documents with the
most complete information and joined them for all of the years.

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
  gcs_get_object(object_name = paste0("adult-holding-redd-and-carcass-surveys/butte-creek/data-raw/", year, "_SurveyChops.xlsx"),
               bucket = gcs_get_global_bucket(),
               saveToDisk = paste0(year,"_raw_surveychops.xlsx"),
               overwrite = TRUE)
  data <- readxl::read_excel(paste0(year,"_raw_surveychops.xlsx")) %>% 
    glimpse()
}

open_files <- function(year){
  data <- readxl::read_excel(paste0(year, "_raw_surveychops.xlsx"))
  return (data)
}
years <- c(2014, 2015, 2016, 2017, 2018, 2019, 2020)
# year <- 2020
raw_data <- purrr::map(years, read_from_cloud) %>%
  reduce(bind_rows)
raw_data <- purrr::map(years, open_files) %>% 
  reduce(bind_rows)
write_csv(raw_data, "raw_chops_data.csv")
```

Read in data from google cloud, glimpse raw data and domain description
sheet:

``` r
# read in data to clean 
raw_chops_data <- read_csv("raw_chops_data.csv") %>% glimpse
```

    ## Rows: 917 Columns: 14

    ## -- Column specification --------------------------------------------------------
    ## Delimiter: ","
    ## chr  (9): LocationCD, SectionCD, WayPt, SpeciesCode, Disposition, AdFinClip,...
    ## dbl  (4): Survey, Year, Week, ChopCount
    ## dttm (1): Date

    ## 
    ## i Use `spec()` to retrieve the full column specification for this data.
    ## i Specify the column types or set `show_col_types = FALSE` to quiet this message.

    ## Rows: 917
    ## Columns: 14
    ## $ Survey      <dbl> 110013, 110013, 110013, 110013, 110013, 110013, 110013, 11~
    ## $ LocationCD  <chr> "Upper survey", "Upper survey", "Upper survey", "Upper sur~
    ## $ Year        <dbl> 2014, 2014, 2014, 2014, 2014, 2014, 2014, 2014, 2014, 2014~
    ## $ Week        <dbl> 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2~
    ## $ Date        <dttm> 2014-09-23, 2014-09-23, 2014-09-23, 2014-09-23, 2014-09-2~
    ## $ SectionCD   <chr> "A", "A", "A", "A", "B", "B", "B", "A", "A", "A", "A", "A"~
    ## $ WayPt       <chr> "A2", "A3", "A4", "A1", "B1", "B2", "B7", "A5", "A1", "A2"~
    ## $ SpeciesCode <chr> "CHN-Spring", "CHN-Spring", "CHN-Spring", "CHN-Spring", "C~
    ## $ Disposition <chr> "Chopped", "Chopped", "Chopped", "Chopped", "Chopped", "Ch~
    ## $ ChopCount   <dbl> 2, 0, 2, 4, 1, 1, 1, 3, 7, 8, 5, 4, 19, 32, 19, 5, 6, 3, 4~
    ## $ AdFinClip   <chr> "Unknown", "Unknown", "Unknown", "Unknown", "Unknown", "Un~
    ## $ Condition   <chr> "Decayed", "Decayed", "Decayed", "Decayed", "Decayed", "De~
    ## $ Sex         <chr> "Unknown", "Unknown", "Unknown", "Unknown", "Unknown", "Un~
    ## $ SizeClass   <chr> "Not recorded", "Not recorded", "Not recorded", "Not recor~

## Data Transformations

``` r
cleaner_data<- raw_chops_data %>%
  janitor::clean_names() %>%
  select(-'week', -'year', -'location_cd', -'disposition', -'condition', -'size_class',
         -'sex', - 'species_code', - 'survey') %>% #could extract week and year from date;all location is the same (upper_cd); all disposition is chopped', all condition decayed, all size class not recorded, all sex is not recorded or unknown, all species_code is spring run chinook
  mutate(date = as.Date(date)) %>% 
  glimpse()
```

    ## Rows: 917
    ## Columns: 5
    ## $ date        <date> 2014-09-23, 2014-09-23, 2014-09-23, 2014-09-23, 2014-09-2~
    ## $ section_cd  <chr> "A", "A", "A", "A", "B", "B", "B", "A", "A", "A", "A", "A"~
    ## $ way_pt      <chr> "A2", "A3", "A4", "A1", "B1", "B2", "B7", "A5", "A1", "A2"~
    ## $ chop_count  <dbl> 2, 0, 2, 4, 1, 1, 1, 3, 7, 8, 5, 4, 19, 32, 19, 5, 6, 3, 4~
    ## $ ad_fin_clip <chr> "Unknown", "Unknown", "Unknown", "Unknown", "Unknown", "Un~

## Explore `date`

``` r
summary(cleaner_data$date)
```

    ##         Min.      1st Qu.       Median         Mean      3rd Qu.         Max. 
    ## "2014-09-23" "2016-09-29" "2017-11-02" "2017-11-29" "2019-10-10" "2020-10-30"

**NA and Unknown Values**

-   0 % of values in the `date` column are NA.

## Explore Categorical Variables

``` r
cleaner_data %>% 
  select_if(is.character) %>% colnames()
```

    ## [1] "section_cd"  "way_pt"      "ad_fin_clip"

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
    ##      130      176      303       31      166      111

**Create lookup rda for section\_cd encoding:**

**NA and Unknown Values**

-   0 % of values in the `section_cd` column are NA.

### Variable:`way_pt`

``` r
table(cleaner_data$way_pt)
```

    ## 
    ##        A1        A2        A3        A4        A5       B-P        B1        B2 
    ##        28        29        22        26        21         4        22        21 
    ##        B3        B4        B5        B6        B7        B8   bck-pwr   Bck-Pwr 
    ##        18        14        25        26        26        24         1         1 
    ##   BCK-PWR    BLK-PL       C-B        C1       C10       C11       C12        C2 
    ##         2         1         4        27        21        25        26        28 
    ##        C3        C4        C5        C6        c7        C7        C8        C9 
    ##        23        21        25        28         1        27        25        26 
    ##       CO1   Cov-Bck   Cov-BCK   COV-BCK   COV-BLK  COV-Okie  COV-OKIE cover-ptr 
    ##         1         1         1         1         1         1         1         1 
    ##        D1        D2        D3        D4        D5        D6        D7        D8 
    ##        20        26        28        26        18        17        17        14 
    ##        E1        E2        E3        E4        E5        E6        E7       N/A 
    ##        18        15        18        16        13        16        15         1 
    ##       N/R       P-O    ph-pwl  pwl-okie  PWL-OKIE   PWR-OKI 
    ##         1         4         1         1         1         1

``` r
cleaner_data <- cleaner_data %>%
  mutate(way_pt = set_names(toupper(way_pt))) %>% 
  mutate(way_pt = case_when(
    way_pt == 'N/A' ~ NA_character_,
    way_pt == 'N/R' ~ NA_character_, 
    TRUE ~ as.character(way_pt)
    
  ))
table(cleaner_data$way_pt)
```

    ## 
    ##        A1        A2        A3        A4        A5       B-P        B1        B2 
    ##        28        29        22        26        21         4        22        21 
    ##        B3        B4        B5        B6        B7        B8   BCK-PWR    BLK-PL 
    ##        18        14        25        26        26        24         4         1 
    ##       C-B        C1       C10       C11       C12        C2        C3        C4 
    ##         4        27        21        25        26        28        23        21 
    ##        C5        C6        C7        C8        C9       CO1   COV-BCK   COV-BLK 
    ##        25        28        28        25        26         1         3         1 
    ##  COV-OKIE COVER-PTR        D1        D2        D3        D4        D5        D6 
    ##         2         1        20        26        28        26        18        17 
    ##        D7        D8        E1        E2        E3        E4        E5        E6 
    ##        17        14        18        15        18        16        13        16 
    ##        E7       P-O    PH-PWL  PWL-OKIE   PWR-OKI 
    ##        15         4         1         2         1

**NA and Unknown Values**

-   0.7 % of values in the `way_pt` column are NA.

### Variable:`ad_fin_clip`

``` r
table(cleaner_data$ad_fin_clip)
```

    ## 
    ##      No Unknown     Yes 
    ##     406     510       1

``` r
cleaner_data <- cleaner_data %>% 
  mutate(ad_fin_clip = set_names(tolower(ad_fin_clip)))
```

## Explore Numerical Variables

``` r
cleaner_data %>% 
  select_if(is.numeric) %>% colnames()
```

    ## [1] "chop_count"

### Variable:`chop_count`

``` r
cleaner_data %>% 
  group_by(date) %>% 
  mutate(total_daily_count = sum(chop_count)) %>% 
  ungroup() %>% 
  mutate(water_year = if_else(month(date)%in% 10:12, year(date)+1, year(date))) %>% 
  glimpse() %>% 
  mutate(years = as.factor(year(date)),
         fake_year= if_else(month(date) %in% 10:12, 1900, 1901),
         fake_date = as.Date(paste0(fake_year, "-", month(date), "-", day(date)))) %>% 
  ggplot(aes(x = fake_date, y = chop_count, color = years))+
  theme_minimal()+
  scale_x_date(labels = date_format("%b"), limits = c(as.Date("1900-10-01"), as.Date("1900-11-01")), date_breaks = "1 month")+
  theme(text = element_text(size = 10),
        axis.text.x = element_text(angle = 90))+
  # facet_wrap(~water_year, scales = "free")+
  geom_point()+
  labs(title = "Total Daily Chops Count 2014 - 2021",
       x = 'Date',
       y = 'Total Chop Count')
```

    ## Rows: 917
    ## Columns: 7
    ## $ date              <date> 2014-09-23, 2014-09-23, 2014-09-23, 2014-09-23, 201~
    ## $ section_cd        <chr> "A", "A", "A", "A", "B", "B", "B", "A", "A", "A", "A~
    ## $ way_pt            <chr> "A2", "A3", "A4", "A1", "B1", "B2", "B7", "A5", "A1"~
    ## $ chop_count        <dbl> 2, 0, 2, 4, 1, 1, 1, 3, 7, 8, 5, 4, 19, 32, 19, 5, 6~
    ## $ ad_fin_clip       <chr> "unknown", "unknown", "unknown", "unknown", "unknown~
    ## $ total_daily_count <dbl> 11, 11, 11, 11, 11, 11, 11, 115, 115, 115, 115, 115,~
    ## $ water_year        <dbl> 2014, 2014, 2014, 2014, 2014, 2014, 2014, 2014, 2014~

![](butte-creek-chops-count-qc-checklist_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

``` r
summary(cleaner_data$chop_count)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    0.00    1.00    4.00   11.29   11.00  254.00

**NA and Unknown Values**

-   0 % of values in the `chop_count` column are NA.
