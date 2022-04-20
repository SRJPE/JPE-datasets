Butte Creek Snorkel Survey 2001 QC
================
Erin Cain
9/29/2021

# Butte Creek Adult Snorkel Survey: 2001 Holding Data

## Description of Monitoring Data

Butte Creek snorkel holding data was shared by Claire Bryant. This data
was shared in multi tab spreadsheets.

**Timeframe:** 2001

**Snorkel Season:** Snorkel Survey is conducted in July or August

**Completeness of Record throughout timeframe:**

**Sampling Location:** Butte Creek

**Data Contact:**

Claire Bryant

## Access Cloud Data

``` r
# Run Sys.setenv() to specify GCS_AUTH_FILE and GCS_DEFAULT_BUCKET before running 
getwd() #to see how to specify paths 
# Open object from google cloud storage
# Set your authentication using gcs_auth
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
# Set global bucket 
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

gcs_list_objects()
# git data and save as xlsx
gcs_get_object(object_name = "adult-holding-redd-and-carcass-surveys/butte-creek/data-raw/Butte 2001 Snorkel Modified.xls",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "ButteSnorkel2001.xls",
               overwrite = TRUE)
```

Read in data from google cloud, glimpse raw data:

Butte creek data needs to be transformed before it can be easy reviewed
and used. Currently each sheet describes snorkeling for a different
site.

``` r
butte_snorkel <- readxl::read_excel("ButteSnorkel2001.xls") %>% glimpse()
```

    ## New names:
    ## * `` -> ...1
    ## * `` -> ...2
    ## * `` -> ...3
    ## * `` -> ...4
    ## * `` -> ...6
    ## * ...

    ## Rows: 64
    ## Columns: 9
    ## $ ...1                  <chr> NA, NA, "Section", "Date", "Temp", NA, NA, NA, N~
    ## $ ...2                  <chr> NA, NA, "Quartz Bowl to Whiskey Flat", "37117", ~
    ## $ ...3                  <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, "Curtis"~
    ## $ ...4                  <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, "Mike", ~
    ## $ `Butte Creek Snorkel` <chr> "37104", NA, NA, NA, NA, NA, NA, NA, NA, NA, "Ad~
    ## $ ...6                  <chr> NA, NA, "NGC= Not a GOOD COUNT", "DNS= DID NOT S~
    ## $ ...7                  <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, "Low", "~
    ## $ ...8                  <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, "High", ~
    ## $ ...9                  <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, "Comment~

## Create function that transforms each sheet

``` r
file_names = c("ButteSnorkel2001.xls", "ButteSnorkel2001.xls", "ButteSnorkel2001.xls")
sheet_names = c(1, 2, 3)
tidy_up_snorkel_data <- function(file_name, sheet_name){
  metadata <- readxl::read_excel(file_name, sheet = sheet_name, range = "A3:F7")
  date_surveyed <- janitor::excel_numeric_to_date(as.numeric(metadata[2,2]))
  raw_data <- readxl::read_excel(file_name, sheet = sheet_name, range = "A12:I70")
  transformed_data <- raw_data %>% select(1:4, Comments) %>% 
    pivot_longer(2:4, names_to = "personnel", values_to = "fish_count") %>%
    filter(Reach != "TOTAL", Reach != "TOTALS", Reach != "RANGE", Reach != "Range") %>%
    mutate(why_fish_count_na = case_when(fish_count == "NGC" ~ "not a good count",
                                fish_count == "DNS" ~ "did not see", 
                                fish_count == "DNSw" ~ "did not swim", 
                                fish_count == "FR AB" ~ "from above"),
            fish_count = case_when(fish_count == "NGC" ~ NA_real_,
                                   fish_count == "DNS" ~ 0, 
                                   fish_count == "DNSw" ~ NA_real_, 
                                   fish_count == "FR AB" ~ NA_real_,
                                   TRUE ~ as.numeric(fish_count)),
           date = date_surveyed) %>% 
    select(date, reach = Reach, personnel, fish_count, why_fish_count_na, comments = Comments)
  return(transformed_data)
}
cleaner_data <- bind_rows(purrr::map2(file_names, sheet_names, tidy_up_snorkel_data)) %>% glimpse
```

    ## New names:
    ## * `` -> ...1
    ## * `` -> ...2
    ## * `` -> ...3
    ## * `` -> ...4
    ## * `` -> ...5
    ## * ...
    ## New names:
    ## * `` -> ...1
    ## * `` -> ...2
    ## * `` -> ...3
    ## * `` -> ...4
    ## * `` -> ...5
    ## * ...
    ## New names:
    ## * `` -> ...1
    ## * `` -> ...2
    ## * `` -> ...3
    ## * `` -> ...4
    ## * `` -> ...5
    ## * ...

    ## Rows: 351
    ## Columns: 6
    ## $ date              <date> 2001-08-14, 2001-08-14, 2001-08-14, 2001-08-14, 200~
    ## $ reach             <chr> "Quartz", "Quartz", "Quartz", "A1", "A1", "A1", "A1"~
    ## $ personnel         <chr> "Clint", "Curtis", "Mike", "Clint", "Curtis", "Mike"~
    ## $ fish_count        <dbl> 1400, 1200, 1500, 210, 240, 260, 250, 210, 260, 95, ~
    ## $ why_fish_count_na <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ comments          <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~

## Explore Date

Survey completed in 3 days in August.

``` r
unique(cleaner_data$date)
```

    ## [1] "2001-08-14" "2001-08-15" "2001-08-16"

## Explore Numeric Variables:

``` r
cleaner_data %>% 
  select_if(is.numeric) %>% colnames()
```

    ## [1] "fish_count"

### Variable: `fish_count`

**Plotting fish\_count by reach**

``` r
cleaner_data %>% 
  ggplot(aes(x = reach, y = fish_count, color = personnel)) + 
  geom_point(size = 3) + 
  theme_minimal() + 
  labs(x = "Reach", y = "Fish Counts", title = "Fish Counts Per Reach") +
  theme(axis.text.x=element_text(angle=90, hjust=1))
```

![](butte-creek-snorkel-survey-2001_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

**Numeric Summary of fish\_count over Period of Record**

``` r
summary(cleaner_data$fish_count)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00    6.00   32.50   76.07   98.75 1500.00      17

**NA and Unknown Values**

-   4.8 % of values in the `fish_count` column are NA.

## Explore Categorical variables:

General notes: If there is an opportunity to turn yes no into boolean do
so, but not if you loose value

``` r
cleaner_data %>% 
  select_if(is.character) %>% colnames()
```

    ## [1] "reach"             "personnel"         "why_fish_count_na"
    ## [4] "comments"

### Variable: `reach`

``` r
table(cleaner_data$reach)
```

    ## 
    ##      A1      A2      A3      A4      A5      B1      B2      B3      B4      B5 
    ##      36      42      36      12      18       6       6      15      12      12 
    ##      B6      B7      B8      C1     C10     C11     C12      C2      C4      C5 
    ##       9       9       6       3       3       6      12       3       3       6 
    ##      C6      C7      C8      C9 Chimney      D1      D3      D4      D5      D7 
    ##       6      18       9       6       3       3       6       6       3       3 
    ##      E1      E2      E4      E5      E6  Quartz 
    ##      12       6       3       6       3       3

They do not appear to do the same number of snorkels in each reach.

**NA and Unknown Values**

-   0 % of values in the `reach` column are NA.

### Variable: `personnel`

``` r
table(cleaner_data$personnel)
```

    ## 
    ##  Clint Curtis   Mike 
    ##    117    117    117

**NA and Unknown Values**

-   0 % of values in the `personnel` column are NA.

### Variable: `why_fish_count_na`

``` r
table(cleaner_data$why_fish_count_na)
```

    ## 
    ##      did not see     did not swim not a good count 
    ##               50                8                5

**NA and Unknown Values**

-   82.1 % of values in the `why_fish_count_na` column are NA.

### Variable: `comments`

``` r
unique(cleaner_data$comments)
```

    ##  [1] NA                           "25 juveniles;1jack"        
    ##  [3] "* split in creek,snorkeled" "different channel"         
    ##  [5] "split in creek,snorkeled"   "20 juveniles"              
    ##  [7] "1 jack"                     "270,150 cts. were NGC"     
    ##  [9] "15 juveniles"               "55 count was NGC"          
    ## [11] "100ct. Seen FR AB"          "Estimate taken FR AB"      
    ## [13] "100ct seen FR AB"           "11,9 counts were NGC"      
    ## [15] "6 ct. seen from above"      "20,23 counts were NGC"     
    ## [17] "90 count was NGC"           "5 count NGC;100 juveniles" 
    ## [19] "70 count NGC"               "15 count  NGC"             
    ## [21] "20 count NGC"               "6 count NGC"               
    ## [23] "22 count NGC"               "PG&E pool 4"               
    ## [25] "55 count NGC"               "4 count NGC"               
    ## [27] "Helltown bridge Hole"       "*50 fish added for fish"   
    ## [29] "in outfall of Powerhouse"   "2 jacks"                   
    ## [31] "400 count FR AB"            "450 juveniles"             
    ## [33] "3 count NGC"                "1 count NGC"               
    ## [35] "130 count NGC"              "under Cable Bridge"

**NA and Unknown Values**

-   60.7 % of values in the `comments` column are NA.

## Summary of identified issues

-   Each year is different formatted. Need to create a new markdown for
    wrangling.
-   Lots of data points where there was not a good count of fish

## Save cleaned data back to google cloud

``` r
butte_holding_2001 <- cleaner_data %>% glimpse
```

    ## Rows: 351
    ## Columns: 6
    ## $ date              <date> 2001-08-14, 2001-08-14, 2001-08-14, 2001-08-14, 200~
    ## $ reach             <chr> "Quartz", "Quartz", "Quartz", "A1", "A1", "A1", "A1"~
    ## $ personnel         <chr> "Clint", "Curtis", "Mike", "Clint", "Curtis", "Mike"~
    ## $ fish_count        <dbl> 1400, 1200, 1500, 210, 240, 260, 250, 210, 260, 95, ~
    ## $ why_fish_count_na <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~
    ## $ comments          <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~

``` r
f <- function(input, output) write_csv(input, file = output)
gcs_upload(butte_holding_2001,
           object_function = f,
           type = "csv",
           name = "adult-holding-redd-and-carcass-surveys/butte-creek/data/butte_holding_2001.csv")
```
