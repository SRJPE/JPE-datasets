Butte Creek Snorkel Survey 2004 QC
================
Erin Cain
9/29/2021

# Butte Creek Adult Snorkel Survey: 2004 Holding Data

## Description of Monitoring Data

Butte Creek snorkel holding data was shared by Claire Bryant. This data
was shared in multi tab spreadsheets.

**Timeframe:** 2004

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
gcs_get_object(object_name = "adult-holding-redd-and-carcass-surveys/butte-creek/data-raw/Butte 2004 Snorkel FNL Modified.xls",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "ButteSnorkel2004.xls",
               overwrite = TRUE)
```

Read in data from google cloud, glimpse raw data:

Butte creek data needs to be transformed before it can be easy reviewed
and used. Currently each sheet describes snorkeling for a different
site.

``` r
butte_snorkel <- readxl::read_excel("ButteSnorkel2004.xls") %>% View()
```

    ## New names:
    ## * `` -> ...1
    ## * `` -> ...2

## Create function that transforms each sheet

``` r
file_names = c("ButteSnorkel2004.xls", "ButteSnorkel2004.xls", "ButteSnorkel2004.xls")
sheet_names = c(3, 4, 5)
tidy_up_snorkel_data <- function(file_name, sheet_name){
  metadata <- readxl::read_excel(file_name, sheet = sheet_name, range = "A3:J7")
  date_surveyed <- janitor::excel_numeric_to_date(as.numeric(metadata[2,2]))
  if (sheet_name == 2){
  raw_data <- readxl::read_excel(file_name, sheet = sheet_name, range = "A14:K70", 
                                 col_names = c("Reach", "Clint Number", "Clint Condition",
                                               "Mike Number", "Mike Condition",
                                               "Curtis Number", "Curtis Condition",
                                               "Avg", "Low", "High", "Comments"))
  } else {
   raw_data <- readxl::read_excel(file_name, sheet = sheet_name, range = "A13:K70", 
                                 col_names = c("Reach", "Clint Number", "Clint Condition",
                                               "Mike Number", "Mike Condition",
                                               "Curtis Number", "Curtis Condition",
                                               "Avg", "Low", "High", "Comments")) 
  }
  combined_data <- tibble()
  names <- c("Clint", "Curtis", "Mike")
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
    filter(reach != "TOTAL", reach != "TOTALS", reach != "RANGE", reach != "Range") %>%
    mutate(why_fish_count_na = case_when(why_fish_count_na == "NGC" ~ "not a good count",
                                why_fish_count_na == "DNS" ~ "did not see", 
                                why_fish_count_na == "DNSw"| why_fish_count_na == "DNSW" ~ "did not swim",
                                why_fish_count_na == "DNC" ~ "did not count", 
                                why_fish_count_na == "FRAB" ~ "from above"),
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
    ## [1] "Curtis"
    ## [1] 3
    ## [1] "Mike"

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
    ## [1] "Curtis"
    ## [1] 3
    ## [1] "Mike"

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
    ## [1] "Curtis"
    ## [1] 3
    ## [1] "Mike"
    ## Rows: 375
    ## Columns: 5
    ## $ date              <date> 2004-07-12, 2004-07-12, 2004-07-12, 2004-07-12, 200~
    ## $ reach             <chr> "Reach", "Quartz", "Quartz 2", "Quartz 3", "A1", "A1~
    ## $ personnel         <chr> "Clint", "Clint", "Clint", "Clint", "Clint", "Clint"~
    ## $ fish_count        <dbl> NA, 180, 300, 250, 85, 16, 2, 130, 15, 6, 2, 1, 1, 5~
    ## $ why_fish_count_na <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~

## Explore Date

Survey completed in 3 days in August.

``` r
unique(cleaner_data$date)
```

    ## [1] "2004-07-12" "2004-07-13" "2004-07-14"

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

![](butte-creek-snorkel-survey-2004_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

**Numeric Summary of fish\_count over Period of Record**

``` r
summary(cleaner_data$fish_count)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##     1.0     8.5    40.0   150.1   130.0  3059.0     116

**NA and Unknown Values**

-   30.9 % of values in the `fish_count` column are NA.

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
    ##        6       27       18       36       18       15       18       12 
    ##       B4       B5       B6       B7       B8       C1      C10      C11 
    ##       27        9       12        9        9        6        3        3 
    ##      C12       C2       C3       C5       C6       C7       C8       C9 
    ##       12       12        3        6        9       12       12       12 
    ##       D1       D2       D3       D4       D5       D6       D7       D8 
    ##        3        6        9        6        3        3        6        3 
    ##       E1       E7   Quartz Quartz 2 Quartz 3    Reach    total    Total 
    ##        6        3        3        3        3        3        3        6

They do not appear to do the same number of snorkels in each reach.

**NA and Unknown Values**

-   0 % of values in the `reach` column are NA.

### Variable: `personnel`

``` r
table(cleaner_data$personnel)
```

    ## 
    ##  Clint Curtis   Mike 
    ##    125    125    125

**NA and Unknown Values**

-   0 % of values in the `personnel` column are NA.

### Variable: `why_fish_count_na`

``` r
table(cleaner_data$why_fish_count_na)
```

    ## 
    ##  did not see did not swim 
    ##           39           13

**NA and Unknown Values**

-   86.1 % of values in the `why_fish_count_na` column are NA.

## Summary of identified issues

-   Each year is different formatted. Need to create a new markdown for
    wrangling.
-   Lots of data points where there was not a good count of fish

## Save cleaned data back to google cloud

``` r
butte_holding_2004 <- cleaner_data %>% glimpse
```

    ## Rows: 375
    ## Columns: 5
    ## $ date              <date> 2004-07-12, 2004-07-12, 2004-07-12, 2004-07-12, 200~
    ## $ reach             <chr> "Reach", "Quartz", "Quartz 2", "Quartz 3", "A1", "A1~
    ## $ personnel         <chr> "Clint", "Clint", "Clint", "Clint", "Clint", "Clint"~
    ## $ fish_count        <dbl> NA, 180, 300, 250, 85, 16, 2, 130, 15, 6, 2, 1, 1, 5~
    ## $ why_fish_count_na <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ~

``` r
f <- function(input, output) write_csv(input, file = output)
gcs_upload(butte_holding_2004,
           object_function = f,
           type = "csv",
           name = "adult-holding-redd-and-carcass-surveys/butte-creek/data/butte_holding_2004.csv")
```
