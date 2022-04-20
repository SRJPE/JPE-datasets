Mill Creek Adult Upstream Passage Estimate QC
================
Inigo Peng
10/19/2021

# Mill Creek Adult Upstream Passage Estimate Data 2012 to 2020

**Description of Monitoring Data**

Adult spring run daily passage estimate is based on data recorded at
Ward Dam via video monitoring.

**Timeframe:**

2012 to 2020

**Completeness of Record throughout timeframe:**

-   Few missing values for passage\_estimate
-   10 - 15 % missing values for physical variables

**Sampling Location:**

-   Ward Dam

**Data Contact:** [Matt Johnson](mailto:Matt.Johnson@wildlife.ca.gov)

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
gcs_get_object(object_name = "adult-upstream-passage-monitoring/mill-creek/data-raw/Mill Creek SRCS Daily Video Passage Estimates 2012-2020.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "mill_creek_passage_estimate_raw.xlsx")
```

Data for each year is in a separate sheet

``` r
sheets <- readxl::excel_sheets('mill_creek_passage_estimate_raw.xlsx')
list_all <- lapply(sheets, function(x) readxl::read_excel(path = "mill_creek_passage_estimate_raw.xlsx", sheet = x, col_types = c("text", "numeric", "numeric", "numeric", "text")))
```

Bind the sheets into one file

``` r
raw_data <- dplyr::bind_rows(list_all) %>% 
  glimpse()
```

    ## Rows: 1,320
    ## Columns: 5
    ## $ Date                                <chr> "40959", "40960", "40961", "40962"~
    ## $ `Adult Spring-Run Passing Ward Dam` <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0~
    ## $ `AVG Daily Flow Below Ward Dam`     <dbl> 112.0938, 110.0208, 109.9479, 113.~
    ## $ `AVG Daily H2O Temp Below Ward Dam` <dbl> 45.60833, 46.89688, 50.28125, 49.9~
    ## $ ...5                                <chr> "Spring Run video monitoring thru ~

## Data Transformations

``` r
cleaner_data <- raw_data %>% 
  set_names(tolower(colnames(raw_data))) %>% 
  select(-"...5") %>% #comments describe dates
  rename("passage_estimate" =  'adult spring-run passing ward dam',
         "flow" = "avg daily flow below ward dam",
         "temperature"= "avg daily h2o temp below ward dam") %>% 
  filter(date != "Totals:", date != "Total:") %>%
  mutate(date = case_when(
    str_length(date) == 5 ~ as.Date(as.numeric(date), origin="1899-12-30"),
    str_detect(date, '[/]') ~ as.Date(date, "%m/%d/%Y"))
    # TRUE ~ as.Date(date))
  ) %>% 
  glimpse()
```

    ## Rows: 1,316
    ## Columns: 4
    ## $ date             <date> 2012-02-20, 2012-02-21, 2012-02-22, 2012-02-23, 2012~
    ## $ passage_estimate <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0,~
    ## $ flow             <dbl> 112.0938, 110.0208, 109.9479, 113.1042, 112.8021, 114~
    ## $ temperature      <dbl> 45.60833, 46.89688, 50.28125, 49.93229, 49.24583, 48.~

## Data Dictionary

The following table describes the variables included in this dataset and
the percent that do not include data.

``` r
percent_na <- cleaner_data %>%
  summarise_all(list(name = ~sum(is.na(.))/length(.))) %>%
  pivot_longer(cols = everything())
  
data_dictionary <- tibble(variables = colnames(cleaner_data),
                          description = c("Date of sampling",
                                          "Passage estimate of Spring Run Chinook, TODO get methodlogy for generating passage estimates",
                                          "Flow in CFS",
                                          "Temperature (F) we convert to C"),
                          
                          percent_na = round(percent_na$value*100)
                          
)
knitr::kable(data_dictionary)
```

| variables         | description                                                                                  | percent\_na |
|:------------------|:---------------------------------------------------------------------------------------------|------------:|
| date              | Date of sampling                                                                             |           0 |
| passage\_estimate | Passage estimate of Spring Run Chinook, TODO get methodlogy for generating passage estimates |           3 |
| flow              | Flow in CFS                                                                                  |          17 |
| temperature       | Temperature (F) we convert to C                                                              |          12 |

## Explore `date`

Check for outlier and NA values

``` r
summary(cleaner_data$date)
```

    ##         Min.      1st Qu.       Median         Mean      3rd Qu.         Max. 
    ## "2012-02-20" "2014-03-31" "2016-06-14" "2016-06-03" "2018-06-20" "2020-06-22" 
    ##         NA's 
    ##          "2"

**NA and Unknown Values**

-   0.2 % of values in the `date` column are NA.

## Explore Numerical Values

### Variable:`passage_estimate`

``` r
cleaner_data %>%
  filter(date != is.na(date)) %>%
  mutate(year = as.factor(year(date))) %>% 
  # glimpse()
  ggplot(aes(x=date, y = passage_estimate))+
  geom_line()+
  facet_wrap(~year, scales = "free")+
  theme_minimal()+
  labs(title = "Daily Passage Estimate From 2012 - 2020")
```

![](mill-creek-upstream-passage-monitoring-qc-checklist_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

``` r
cleaner_data %>% 
  filter(date != is.na(date)) %>%
  mutate(year = as.factor(year(date))) %>%
  # glimpse()
  group_by(year) %>% 
  summarise(total = sum(passage_estimate, na.rm  = TRUE)) %>%
  # glimpse()
  ggplot(aes(x = year, y = total, group = 1))+
  geom_line()+
  geom_point(aes(x=year, y = total))+
  theme_minimal()+
  labs(title = "Total Annual Passage Estimate from 2012 - 2020",
       y = "Total passage_estimate")
```

![](mill-creek-upstream-passage-monitoring-qc-checklist_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

**Numeric Summary of passage\_estimate From 2012 to 2020**

``` r
summary(cleaner_data$passage_estimate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  -1.000   0.000   0.000   1.806   2.000  38.765      38

Note: there is a negative estimate in one of the days - need to remove
that

**NA and Unknown Values**

-   2.9 % of values in the `passage_estimate` column are NA.

### Variable:`flow`

Flow in cfs

``` r
cleaner_data %>% 
  filter(date != is.na(date)) %>%
  group_by(date) %>%
  mutate(avg_flow = mean(flow, na.rm = T)) %>%
  ungroup() %>% 
  mutate(year = as.factor(year(date)),
         fake_year = 1900,
         fake_date = as.Date(paste0(fake_year,"-", month(date), "-", day(date)))) %>% 
  ggplot(aes(x = fake_date, y = avg_flow, color = year)) + 
  scale_color_brewer(palette = "Dark2")+
  geom_point(alpha = .25) + 
  scale_x_date(labels = date_format("%b"), date_breaks = "1 month") + 
  theme_minimal() + 
  theme(text = element_text(size = 15),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + 
  labs(title = "Daily Water Flow (colored by year)",
       y = "Average Daily Flow", 
       x = "Date")  
```

![](mill-creek-upstream-passage-monitoring-qc-checklist_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

``` r
cleaner_data %>% 
  mutate(year = as.factor(year(date))) %>% 
  ggplot(aes(x=flow, fill = year))+
  scale_fill_brewer(palette = "Dark2")+
  geom_histogram()+
  theme_minimal()+
  labs(title = "Distribution of Flow")
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](mill-creek-upstream-passage-monitoring-qc-checklist_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

**Numeric Summary of flow From 2012 to 2020**

``` r
summary(cleaner_data$flow)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##    0.00   92.04  190.77  223.19  313.00 2559.00     219

**NA and Unknown Values**

-   16.6 % of values in the `flow` column are NA.

### Variable:`temperature`

Temperature in F, convert to C below

``` r
cleaner_data %>% 
  filter(date != is.na(date)) %>%
  group_by(date) %>%
  mutate(avg_temp = mean(temperature, na.rm = T)) %>%
  ungroup() %>% 
  mutate(year = as.factor(year(date)),
         fake_year = 1900,
         fake_date = as.Date(paste0(fake_year,"-", month(date), "-", day(date)))) %>% 
  ggplot(aes(x = fake_date, y = avg_temp, color = year)) + 
  scale_color_brewer(palette = "Dark2")+
  geom_point(alpha = .25) + 
  scale_x_date(labels = date_format("%b"), date_breaks = "1 month") + 
  theme_minimal() + 
  theme(text = element_text(size = 15),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + 
  labs(title = "Daily Water Temperature (colored by year)",
       y = "Average Daily Temperature", 
       x = "Date")  
```

![](mill-creek-upstream-passage-monitoring-qc-checklist_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->

``` r
cleaner_data %>% 
  filter(date != is.na(date)) %>%
  mutate(year = as.factor(year(date))) %>% 
  ggplot(aes(x=temperature, fill = year))+
  scale_fill_brewer(palette = "Dark2")+
  geom_histogram(bins = 10)+
  theme_minimal()+
  labs(title = "Distribution of Temperature")
```

![](mill-creek-upstream-passage-monitoring-qc-checklist_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

**Numeric Summary of temperature From 2012 to 2020**

``` r
summary(cleaner_data$temperature)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   40.01   50.97   58.18   59.17   66.76   83.00     156

**NA and Unknown Values**

-   11.9 % of values in the `temperature` column are NA.

### Notes and Issues

-   passage\_estimate drops significantly after 2014
-   Only have passage estimates may want to purse raw data
-   Temperature in F, convert to C below

``` r
cleaner_data <- cleaner_data %>%
  mutate(temperature = (temperature - 32) * (5/9))
```

## Next steps

-   See if we need raw data from this video monitoring

### Add cleaned data back onto google cloud

``` r
mill_upstream_estimate <- cleaner_data %>% glimpse()
```

    ## Rows: 1,316
    ## Columns: 4
    ## $ date             <date> 2012-02-20, 2012-02-21, 2012-02-22, 2012-02-23, 2012~
    ## $ passage_estimate <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0,~
    ## $ flow             <dbl> 112.0938, 110.0208, 109.9479, 113.1042, 112.8021, 114~
    ## $ temperature      <dbl> 7.560185, 8.276042, 10.156250, 9.962384, 9.581019, 9.~

``` r
f <- function(input, output) write_csv(input, file = output)
gcs_upload(mill_upstream_estimate,
           object_function = f,
           type = "csv",
           name = "adult-upstream-passage-monitoring/mill-creek/data/mill_upstream_passage_estimate.csv")
```

    ## i 2021-12-01 15:18:11 > File size detected as  50.1 Kb

    ## i 2021-12-01 15:18:12 > Request Status Code:  400

    ## ! API returned: Cannot insert legacy ACL for an object when uniform bucket-level access is enabled. Read more at https://cloud.google.com/storage/docs/uniform-bucket-level-access - Retrying with predefinedAcl='bucketLevel'

    ## i 2021-12-01 15:18:12 > File size detected as  50.1 Kb

    ## ==Google Cloud Storage Object==
    ## Name:                adult-upstream-passage-monitoring/mill-creek/data/mill_upstream_passage_estimate.csv 
    ## Type:                csv 
    ## Size:                50.1 Kb 
    ## Media URL:           https://www.googleapis.com/download/storage/v1/b/jpe-dev-bucket/o/adult-upstream-passage-monitoring%2Fmill-creek%2Fdata%2Fmill_upstream_passage_estimate.csv?generation=1638400692629230&alt=media 
    ## Download URL:        https://storage.cloud.google.com/jpe-dev-bucket/adult-upstream-passage-monitoring%2Fmill-creek%2Fdata%2Fmill_upstream_passage_estimate.csv 
    ## Public Download URL: https://storage.googleapis.com/jpe-dev-bucket/adult-upstream-passage-monitoring%2Fmill-creek%2Fdata%2Fmill_upstream_passage_estimate.csv 
    ## Bucket:              jpe-dev-bucket 
    ## ID:                  jpe-dev-bucket/adult-upstream-passage-monitoring/mill-creek/data/mill_upstream_passage_estimate.csv/1638400692629230 
    ## MD5 Hash:            5dKqRsD/O+9dz96+mb0yrw== 
    ## Class:               STANDARD 
    ## Created:             2021-12-01 23:18:12 
    ## Updated:             2021-12-01 23:18:12 
    ## Generation:          1638400692629230 
    ## Meta Generation:     1 
    ## eTag:                CO7doprew/QCEAE= 
    ## crc32c:              RhjdyQ==
