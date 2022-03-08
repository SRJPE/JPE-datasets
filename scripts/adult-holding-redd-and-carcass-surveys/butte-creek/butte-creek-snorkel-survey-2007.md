Butte Creek Snorkel Survey 2007 QC
================
Erin Cain
9/29/2021

# Butte Creek Adult Snorkel Survey: 2007 Holding Data

## Description of Monitoring Data

Butte Creek snorkel holding data was shared by Claire Bryant. This data
was shared in multi tab spreadsheets.

**Timeframe:** 2007

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
gcs_get_object(object_name = "adult-holding-redd-and-carcass-surveys/butte-creek/data-raw/Butte 2007 Snorkel_after_Criteria.xls",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "ButteSnorkel2007.xls",
               overwrite = TRUE)
```

Read in data from google cloud, glimpse raw data:

Butte creek data needs to be transformed before it can be easy reviewed
and used. Currently each sheet describes snorkeling for a different
site.

``` r
butte_snorkel <- readxl::read_excel("ButteSnorkel2007.xls") 
```

    ## New names:
    ## * `` -> ...3
    ## * `` -> ...4
    ## * `` -> ...5
    ## * `` -> ...6
    ## * `` -> ...7
    ## * ...

## Create function that transforms each sheet

``` r
file_names = c("ButteSnorkel2007.xls", "ButteSnorkel2007.xls", "ButteSnorkel2007.xls")
sheet_names = c(1, 2, 3)
tidy_up_snorkel_data <- function(file_name, sheet_name){
  metadata <- readxl::read_excel(file_name, sheet = sheet_name, range = "A3:J7")
  date_surveyed <- janitor::excel_numeric_to_date(as.numeric(metadata[2,2]))
  if (sheet_name == 1){
  raw_data <- readxl::read_excel(file_name, sheet = sheet_name, range = "A14:M70", 
                                 col_names = c("Reach", "Clint Number", "Clint Condition",
                                               "Sam Number", "Sam Condition",
                                               "Jeremy Number", "Jeremy Condition",
                                               "Craig Number", "Craig Condition", 
                                               "Avg", "Low", "High", "Comments"))
  } else {
   raw_data <- readxl::read_excel(file_name, sheet = sheet_name, range = "A13:M70", 
                                 col_names = c("Reach", "Clint Number", "Clint Condition",
                                               "Sam Number", "Sam Condition",
                                               "Jeremy Number", "Jeremy Condition",
                                               "Craig Number", "Craig Condition", 
                                               "Avg", "Low", "High", "Comments"))
  }
  combined_data <- tibble()
  names <- c("Clint", "Sam", "Jeremy", "Craig")
  for (i in 1:length(names)) {
    print(i)
    print(names[i])
    cols <- colnames(raw_data)[stringr::str_detect(colnames(raw_data), names[i])]
    i_dat <- raw_data %>% 
      select("reach" = Reach, "fish_count" = cols[1], "why_fish_count_na" = cols[2]) %>%
      mutate(personnel = names[i],
             fish_count = as.numeric(fish_count))
    combined_data <- bind_rows(combined_data, i_dat)
  }
  
  transformed_data <- combined_data %>%
    filter(reach != "TOTAL", reach != "TOTALS", reach != "Total", reach != "total", reach != "RANGE", reach != "Range") %>%
    mutate(why_fish_count_na = case_when(why_fish_count_na == "NGC" ~ "not a good count",
                                why_fish_count_na == "DNS" ~ "did not see", 
                                why_fish_count_na == "DNSw"| why_fish_count_na == "DNSW" ~ "did not swim",
                                why_fish_count_na == "DNC" ~ "did not count", 
                                why_fish_count_na == "FRAB" | why_fish_count_na == "FR AB" ~ "from above",
                                why_fish_count_na == "LAST"  ~ "last one through"),
           date = date_surveyed,
           fish_count = as.numeric(fish_count)) %>%
    select(date, reach, personnel, fish_count, why_fish_count_na)
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

    ## [1] 1
    ## [1] "Clint"
    ## [1] 2
    ## [1] "Sam"
    ## [1] 3
    ## [1] "Jeremy"
    ## [1] 4
    ## [1] "Craig"

    ## New names:
    ## * `` -> ...1
    ## * `` -> ...2
    ## * `` -> ...3
    ## * `` -> ...4
    ## * `` -> ...5
    ## * ...

    ## [1] 1
    ## [1] "Clint"
    ## [1] 2
    ## [1] "Sam"
    ## [1] 3
    ## [1] "Jeremy"
    ## [1] 4
    ## [1] "Craig"

    ## New names:
    ## * `` -> ...1
    ## * `` -> ...2
    ## * `` -> ...3
    ## * `` -> ...4
    ## * `` -> ...5
    ## * ...

    ## [1] 1
    ## [1] "Clint"
    ## [1] 2
    ## [1] "Sam"
    ## [1] 3
    ## [1] "Jeremy"
    ## [1] 4
    ## [1] "Craig"
    ## Rows: 440
    ## Columns: 5
    ## $ date              <date> 2007-07-09, 2007-07-09, 2007-07-09, 2007-07-09, 200~
    ## $ reach             <chr> "Quartz", "Quartz 2", "Quartz 3", "A1", "A1", "A1", ~
    ## $ personnel         <chr> "Clint", "Clint", "Clint", "Clint", "Clint", "Clint"~
    ## $ fish_count        <dbl> 95, 220, NA, 65, NA, NA, 13, 30, NA, NA, NA, NA, NA,~
    ## $ why_fish_count_na <chr> NA, "from above", "not a good count", NA, NA, "did n~

## Explore Date

Survey completed in 3 days in August.

``` r
unique(cleaner_data$date)
```

    ## [1] "2007-07-09" "2007-07-10" "2007-07-11"

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
  geom_point(size = 3, alpha = .5) + 
  theme_minimal() + 
  labs(x = "Reach", y = "Fish Counts", title = "Fish Counts Per Reach") +
  theme(axis.text.x=element_text(angle=90, hjust=1))
```

![](butte-creek-snorkel-survey-2007_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

**Numeric Summary of fish\_count over Period of Record**

``` r
summary(cleaner_data$fish_count)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    1.00    4.00   35.00   61.55   95.00  600.00     219

**NA and Unknown Values**

-   49.8 % of values in the `fish_count` column are NA.

## Explore Categorical variables:

General notes: If there is an opportunity to turn yes no into boolean do
so, but not if you loose value

``` r
cleaner_data %>% 
  select_if(is.character) %>% colnames()
```

    ## [1] "reach"             "personnel"         "why_fish_count_na"

### Variable: `reach`

``` r
table(cleaner_data$reach)
```

    ## 
    ##       A1       A2       A3       A4       A5       B1       B2       B3 
    ##       20       24       32       24       28       12       12       20 
    ##       B4       B5       B6       B7       B8       C1      C10      C11 
    ##       20       24       20        8        8       12        4        4 
    ##      C12       C2       C3       C5      C5b       C6       C7       C8 
    ##       12       16        4        4        4        8       20       16 
    ##       C9       D1       D2       D3       D4       D5       D6       D7 
    ##        4        8        8        4        8        4        4        4 
    ##       D8       E1       E4       E5   Quartz Quartz 2 Quartz 3 
    ##        4        4        8       12        4        4        4

They do not appear to do the same number of snorkels in each reach.

**NA and Unknown Values**

-   0 % of values in the `reach` column are NA.

### Variable: `personnel`

``` r
table(cleaner_data$personnel)
```

    ## 
    ##  Clint  Craig Jeremy    Sam 
    ##    110    110    110    110

**NA and Unknown Values**

-   0 % of values in the `personnel` column are NA.

### Variable: `why_fish_count_na`

``` r
table(cleaner_data$why_fish_count_na)
```

    ## 
    ##      did not see     did not swim       from above not a good count 
    ##               11               19               18               22

**NA and Unknown Values**

-   84.1 % of values in the `why_fish_count_na` column are NA.

## Summary of identified issues

-   Each year is different formatted. Need to create a new markdown for
    wrangling.
-   Lots of data points where there was not a good count of fish

## Save cleaned data back to google cloud

``` r
butte_holding_2007 <- cleaner_data %>% glimpse
```

    ## Rows: 440
    ## Columns: 5
    ## $ date              <date> 2007-07-09, 2007-07-09, 2007-07-09, 2007-07-09, 200~
    ## $ reach             <chr> "Quartz", "Quartz 2", "Quartz 3", "A1", "A1", "A1", ~
    ## $ personnel         <chr> "Clint", "Clint", "Clint", "Clint", "Clint", "Clint"~
    ## $ fish_count        <dbl> 95, 220, NA, 65, NA, NA, 13, 30, NA, NA, NA, NA, NA,~
    ## $ why_fish_count_na <chr> NA, "from above", "not a good count", NA, NA, "did n~

``` r
f <- function(input, output) write_csv(input, file = output)
gcs_upload(butte_holding_2007,
           object_function = f,
           type = "csv",
           name = "adult-holding-redd-and-carcass-surveys/butte-creek/data/butte_holding_2007.csv")
```
