Feather River RST Catch Data QC
================
Erin Cain
9/29/2021

# Feather River RST Catch Data

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
# Snake case, 
# Columns are appropriate types
# Remove redundant columns
cleaner_catch_data <- raw_catch %>%
  rename("date" = Date, "site_name" = siteName, 
         "at_capture_run" = `At Capture Run`, 
         "lifestage" = lifeStage, 
         "fork_length" = FL, "count" = n) %>%
  mutate(date = as.Date(date)) %>%
  filter(commonName == "Chinook salmon") %>%
  select(-commonName)

cleaner_catch_data %>% glimpse()
```

    ## Rows: 180,871
    ## Columns: 6
    ## $ date           <date> 1997-12-23, 1997-12-23, 1997-12-23, 1997-12-23, 1997-1~
    ## $ site_name      <chr> "Eye Riffle", "Eye Riffle", "Eye Riffle", "Eye Riffle",~
    ## $ at_capture_run <chr> "Fall", "Fall", "Fall", "Fall", "Fall", "Fall", "Fall",~
    ## $ lifestage      <chr> "Not recorded", "Parr", "Parr", "Parr", "Parr", "Parr",~
    ## $ fork_length    <dbl> NA, 30, 32, 33, 34, 35, 38, 29, 37, 36, 31, 34, 33, 31,~
    ## $ count          <dbl> 65, 2, 6, 8, 16, 10, 1, 1, 2, 2, 2, 19, 10, 2, 9, 7, 1,~

## Explore Numeric Variables:

``` r
# Filter clean data to show only numeric variables 
cleaner_catch_data %>% select_if(is.numeric) %>% colnames()
```

    ## [1] "fork_length" "count"

### Variable: `fork_length`

**Plotting fork\_length at RST sites**

``` r
# Make whatever plot is appropriate 
# maybe 2 plots is appropriate
cleaner_catch_data %>% 
  ggplot(aes(x = fork_length, y = site_name)) + 
  geom_boxplot() + 
  theme_minimal() +
  labs(title = "Fork length summarized by site") + 
  theme(text = element_text(size = 15),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) 
```

![](feather-rst_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

**Numeric Summary of fork\_length over Period of Record**

``` r
# Table with summary statistics
summary(cleaner_catch_data$fork_length)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    3.00   35.00   37.00   44.17   49.00  940.00    9216

**NA and Unknown Values**

-   5.1 % of values in the `fork_length` column are NA.

### Variable: `count`

**Plotting passage counts over period of reccord**

``` r
cleaner_catch_data %>% 
  mutate(year = as.factor(year(date)),
         fake_date = as.Date(paste0("1900-", month(date), "-", day(date)))) %>%
  ggplot(aes(x = fake_date, y = count, color = year)) + 
  geom_line() + 
  # facet_wrap(~year(date), scales = "free") + 
  scale_x_date(labels = date_format("%b"), date_breaks = "1 month") + 
  theme_minimal() + 
  theme(text = element_text(size = 15),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
        legend.position = "bottom") + 
  labs(title = "Daily Count of Fish Passage (1997-2021)")  
```

![](feather-rst_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

``` r
# Make whatever plot is appropriate 
# maybe 2 plots is appropriate
cleaner_catch_data %>% 
  mutate(year = as.factor(year(date))) %>%
  ggplot(aes(x = count, y = year)) + 
  geom_boxplot() + 
  theme_minimal() +
  labs(title = "Passage count summarized by year") + 
  theme(text = element_text(size = 15),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) 
```

![](feather-rst_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

**Numeric Summary of count over Period of Record**

``` r
# Table with summary statistics
summary(cleaner_catch_data$count)
```

    ##      Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
    ##      1.00      1.00      1.00     78.63      1.00 123556.00

**NA and Unknown Values**

-   0 % of values in the `count` column are NA.

## Explore Categorical variables:

General notes: If there is an opportunity to turn yes no into boolean do
so, but not if you loose value

``` r
# Filter clean data to show only categorical variables (this way we know we do not miss any)
cleaner_catch_data %>% select_if(is.character) %>% colnames()
```

    ## [1] "site_name"      "at_capture_run" "lifestage"

### Variable: `site_name`

``` r
table(cleaner_catch_data$site_name) 
```

    ## 
    ##       Eye Riffle   Gateway Riffle Herringer Riffle         Live Oak 
    ##            35969            19010            77310             8020 
    ##    Shawn's Beach     Steep Riffle     Sunset Pumps 
    ##               45            24642            15875

**Create location lookup rda for site\_name:** TODO

``` r
# Create named lookup vector
# Name rda [watershed]_[data type]_[variable_name].rda
# save rda to data/ 
```

**NA and Unknown Values**

-   0 % of values in the `site_name` column are NA.

### Variable: `at_capture_run`

``` r
table(cleaner_catch_data$at_capture_run) 
```

    ## 
    ##         Fall    Late fall Not recorded       Spring       Winter 
    ##       167243         3091          127        10407            3

``` r
cleaner_catch_data$at_capture_run <- ifelse(cleaner_catch_data$at_capture_run == "Not recorded", NA, tolower(cleaner_catch_data$at_capture_run))
```

**NA and Unknown Values**

-   0.1 % of values in the `at_capture_run` column are NA.

### Variable: `lifestage`

``` r
table(cleaner_catch_data$lifestage) 
```

    ## 
    ##                   Adult                     Fry                Juvenile 
    ##                      42                   26917                       1 
    ##            Not recorded                    Parr               Pre-smolt 
    ##                    9484                  116135                    1097 
    ##            Silvery parr                   Smolt   Yolk sac fry (alevin) 
    ##                   24053                    1478                    1663 
    ## YOY (young of the year) 
    ##                       1

``` r
cleaner_catch_data$lifestage <- ifelse(cleaner_catch_data$lifestage == "Not recorded", NA, tolower(cleaner_catch_data$lifestage))
```

**NA and Unknown Values**

-   5.2 % of values in the `lifestage` column are NA.

``` r
feather_rst <- cleaner_catch_data %>% glimpse()
```

    ## Rows: 180,871
    ## Columns: 6
    ## $ date           <date> 1997-12-23, 1997-12-23, 1997-12-23, 1997-12-23, 1997-1~
    ## $ site_name      <chr> "Eye Riffle", "Eye Riffle", "Eye Riffle", "Eye Riffle",~
    ## $ at_capture_run <chr> "fall", "fall", "fall", "fall", "fall", "fall", "fall",~
    ## $ lifestage      <chr> NA, "parr", "parr", "parr", "parr", "parr", "parr", "pa~
    ## $ fork_length    <dbl> NA, 30, 32, 33, 34, 35, 38, 29, 37, 36, 31, 34, 33, 31,~
    ## $ count          <dbl> 65, 2, 6, 8, 16, 10, 1, 1, 2, 2, 2, 19, 10, 2, 9, 7, 1,~

### Save cleaned data back to google cloud

``` r
# Write to google cloud 
# Name file [watershed]_[data type].csv
f <- function(input, output) write_csv(input, file = output)

gcs_upload(feather_rst,
           object_function = f,
           type = "csv",
           name = "rst/feather-river/data/feather_rst.csv")
```
