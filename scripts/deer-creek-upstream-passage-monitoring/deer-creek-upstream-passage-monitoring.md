deer-creek-adult-upstream-passage-monitoring-qc-checklist
================
Inigo Peng
10/19/2021

# Deer Creek Adult Holding Survey Data 2014 to 2020

**Description of Monitoring Data**

**Timeframe:**

2014 to 2020

**Completeness of Record throughout timeframe:**

Some missing data for variable flow

**Sampling Location:**

-   SVRIC Dam

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
gcs_get_object(object_name = "adult-upstream-passage-monitoring/deer-creek/data-raw/Deer Creek SRCS Daily Video Passage Estimates 2014-2020.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "deer_creek_passage_estimate_raw.xlsx")
```

``` r
sheets <- readxl::excel_sheets('deer_creek_passage_estimate_raw.xlsx')
list_all <- lapply(sheets, function(x) readxl::read_excel(path = "deer_creek_passage_estimate_raw.xlsx", sheet = x, col_types = c("text", "numeric", "numeric", "numeric", "text")))
```

    ## New names:
    ## * `` -> ...5
    ## New names:
    ## * `` -> ...5
    ## New names:
    ## * `` -> ...5
    ## New names:
    ## * `` -> ...5
    ## New names:
    ## * `` -> ...5
    ## New names:
    ## * `` -> ...5
    ## New names:
    ## * `` -> ...5

``` r
raw_data <- dplyr::bind_rows(list_all) %>% 
  glimpse()
```

    ## Rows: 958
    ## Columns: 5
    ## $ Date                                 <chr> "2/20/2014", "2/21/2014", "2/22/2~
    ## $ `Adult Spring-Run Passing SVRIC Dam` <dbl> 0, 0, 0, 0, 0, 0, 0, 3, 16, 2, 0,~
    ## $ `AVG Daily Flow Below SVRIC Dam`     <dbl> 111, 98, 91, 86, 81, 78, 80, 198,~
    ## $ `AVG Daily H2O Temp Below SVRIC Dam` <dbl> 49.35426, 49.84375, 50.09583, 50.~
    ## $ ...5                                 <chr> "Spring-run video monitoring at S~

## Data Transformations

``` r
cleaner_data <- raw_data %>% 
  set_names(tolower(colnames(raw_data))) %>% 
  select(-"...5") %>% #comments describe dates
  rename("count" =  'adult spring-run passing svric dam',
         "flow" = "avg daily flow below svric dam",
         "temperature"= "avg daily h2o temp below svric dam") %>% 
  filter(date != "Totals:", date != "Total:") %>%
  mutate(date = case_when(
    str_length(date) == 5 ~ as.Date(as.numeric(date), origin="1899-12-30"),
    TRUE ~ as.Date(date, "%m/%d/%Y")
  )) %>% 
  glimpse()
```

    ## Rows: 951
    ## Columns: 4
    ## $ date        <date> 2014-02-20, 2014-02-21, 2014-02-22, 2014-02-23, 2014-02-2~
    ## $ count       <dbl> 0, 0, 0, 0, 0, 0, 0, 3, 16, 2, 0, 0, 0, 5, 6, 2, 0, 2, 8, ~
    ## $ flow        <dbl> 111, 98, 91, 86, 81, 78, 80, 198, 297, 429, 274, 327, 857,~
    ## $ temperature <dbl> 49.35426, 49.84375, 50.09583, 50.25729, 51.05313, 51.65208~

## Explore `date`

``` r
cleaner_data%>%
  ggplot(aes(x = date)) +
  geom_histogram(binwidth = 7, position = 'stack', color = "black") +
  labs(title = "Value Counts For Survey Season Dates")+
  theme(legend.text = element_text(size = 8))
```

![](deer-creek-upstream-passage-monitoring_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

``` r
summary(cleaner_data$date)
```

    ##         Min.      1st Qu.       Median         Mean      3rd Qu.         Max. 
    ## "2014-02-20" "2015-06-06" "2017-05-19" "2017-05-19" "2019-03-24" "2020-06-22"

**NA and Unknown Values**

-   0 % of values in the `date` column are NA.

## Explore Numerical Values

### Variable:`count`

``` r
cleaner_data %>% 
  mutate(year = as.factor(year(date))) %>% 
  ggplot(aes(x=date, y = count))+
  geom_line()+
  facet_wrap(~year, scales = "free")+
  theme_minimal()+
  labs(title = "Daily Passage Estimate From 2014 - 2020")
```

![](deer-creek-upstream-passage-monitoring_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

``` r
cleaner_data %>% 
  mutate(year = as.factor(year(date))) %>% 
  group_by(year) %>% 
  summarise(total = sum(count)) %>%
  ggplot(aes(x = year, y = total, group = 1))+
  geom_line()+
  geom_point(aes(x=year, y = total))+
  theme_minimal()+
  labs(title = "Passage Estimate from 2014 - 2020",
       y = "Total Count")
```

![](deer-creek-upstream-passage-monitoring_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

**Numeric Monthly Summary of count From 2014 to 2020**

``` r
cleaner_data %>%
  group_by(month(date)) %>%
  summarise(count = sum(count, na.rm = T)) %>%
  pull(count) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##     0.0    19.5   172.1   401.5   415.7  1599.2

**NA and Unknown Values**

-   0 % of values in the `count` column are NA.

### Variable:`flow`

``` r
cleaner_data %>% 
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

![](deer-creek-upstream-passage-monitoring_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

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

![](deer-creek-upstream-passage-monitoring_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

**Numeric Annual Summary of flow From 2014 to 2020**

``` r
cleaner_data %>%
  group_by(year(date)) %>%
  summarise(flow = mean(flow, na.rm = T)) %>%
  pull(flow) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   73.22  134.62  177.30  208.07  272.87  391.01

**NA and Unknown Values**

-   14.7 % of values in the `flow` column are NA.

### Variable:`temperature`

``` r
cleaner_data %>% 
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

![](deer-creek-upstream-passage-monitoring_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->

``` r
cleaner_data %>% 
  mutate(year = as.factor(year(date))) %>% 
  ggplot(aes(x=temperature, fill = year))+
  scale_fill_brewer(palette = "Dark2")+
  geom_histogram(bins = 5)+
  theme_minimal()+
  labs(title = "Distribution of Temperature")
```

![](deer-creek-upstream-passage-monitoring_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

**Numeric Annual Summary of temperature From 2014 to 2020**

``` r
cleaner_data %>%
  group_by(year(date)) %>%
  summarise(temperature = mean(temperature, na.rm = T)) %>%
  pull(temperature) %>%
  summary()
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   58.07   59.37   61.28   60.82   62.38   62.90

**NA and Unknown Values**

-   0 % of values in the `temperature` column are NA.

### Notes and Issues

-   Temperature in F? Need to double check

-   Units for flow?

### Add cleaned data back onto google cloud

``` r
deer_upstream_estimate <- cleaner_data %>% glimpse()
```

    ## Rows: 951
    ## Columns: 4
    ## $ date        <date> 2014-02-20, 2014-02-21, 2014-02-22, 2014-02-23, 2014-02-2~
    ## $ count       <dbl> 0, 0, 0, 0, 0, 0, 0, 3, 16, 2, 0, 0, 0, 5, 6, 2, 0, 2, 8, ~
    ## $ flow        <dbl> 111, 98, 91, 86, 81, 78, 80, 198, 297, 429, 274, 327, 857,~
    ## $ temperature <dbl> 49.35426, 49.84375, 50.09583, 50.25729, 51.05313, 51.65208~

``` r
f <- function(input, output) write_csv(input, file = output)

gcs_upload(deer_upstream_estimate,
           object_function = f,
           type = "csv",
           name = "adult-upstream-passage-monitoring/deer-creek/data/deer_upstream_estimate.csv")
```

    ## i 2021-11-02 11:14:19 > File size detected as  39.7 Kb

    ## i 2021-11-02 11:14:19 > Request Status Code:  400

    ## ! API returned: Cannot insert legacy ACL for an object when uniform bucket-level access is enabled. Read more at https://cloud.google.com/storage/docs/uniform-bucket-level-access - Retrying with predefinedAcl='bucketLevel'

    ## i 2021-11-02 11:14:19 > File size detected as  39.7 Kb

    ## ==Google Cloud Storage Object==
    ## Name:                adult-upstream-passage-monitoring/deer-creek/data/deer_upstream_estimate.csv 
    ## Type:                csv 
    ## Size:                39.7 Kb 
    ## Media URL:           https://www.googleapis.com/download/storage/v1/b/jpe-dev-bucket/o/adult-upstream-passage-monitoring%2Fdeer-creek%2Fdata%2Fdeer_upstream_estimate.csv?generation=1635876858283709&alt=media 
    ## Download URL:        https://storage.cloud.google.com/jpe-dev-bucket/adult-upstream-passage-monitoring%2Fdeer-creek%2Fdata%2Fdeer_upstream_estimate.csv 
    ## Public Download URL: https://storage.googleapis.com/jpe-dev-bucket/adult-upstream-passage-monitoring%2Fdeer-creek%2Fdata%2Fdeer_upstream_estimate.csv 
    ## Bucket:              jpe-dev-bucket 
    ## ID:                  jpe-dev-bucket/adult-upstream-passage-monitoring/deer-creek/data/deer_upstream_estimate.csv/1635876858283709 
    ## MD5 Hash:            dI/7L2VfXjDaa1EtkStXww== 
    ## Class:               STANDARD 
    ## Created:             2021-11-02 18:14:18 
    ## Updated:             2021-11-02 18:14:18 
    ## Generation:          1635876858283709 
    ## Meta Generation:     1 
    ## eTag:                CL2No5ik+vMCEAE= 
    ## crc32c:              YZr+oA==
