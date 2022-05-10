Deer Creek Adult Upstream Passage Estimate QC
================
Inigo Peng
10/19/2021

# Deer Creek Adult Upstream Passage Monitoring Data 2014 to 2020

**Description of Monitoring Data**

Adult spring run salmon passage daily estimates based on data collected
at SVRIC Dam on Deer River via video monitoring.

**QC/Raw or Passage Estimate** QC Passage Estimates

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

Data for each year is in a separate sheet

``` r
sheets <- readxl::excel_sheets('deer_creek_passage_estimate_raw.xlsx')
list_all <- lapply(sheets, function(x) readxl::read_excel(path = "deer_creek_passage_estimate_raw.xlsx", 
                                                          sheet = x, 
                                                          col_types = c("text", "numeric", "numeric", "numeric", "text")))
```

Bind the sheets into one file

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
  rename("passage_estimate" =  'adult spring-run passing svric dam',
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
    ## $ date             <date> 2014-02-20, 2014-02-21, 2014-02-22, 2014-02-23, 2014~
    ## $ passage_estimate <dbl> 0, 0, 0, 0, 0, 0, 0, 3, 16, 2, 0, 0, 0, 5, 6, 2, 0, 2~
    ## $ flow             <dbl> 111, 98, 91, 86, 81, 78, 80, 198, 297, 429, 274, 327,~
    ## $ temperature      <dbl> 49.35426, 49.84375, 50.09583, 50.25729, 51.05313, 51.~

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
                                          "Temperature"),
                          
                          percent_na = round(percent_na$value*100)
                          
)
knitr::kable(data_dictionary)
```

| variables         | description                                                                                  | percent\_na |
|:------------------|:---------------------------------------------------------------------------------------------|------------:|
| date              | Date of sampling                                                                             |           0 |
| passage\_estimate | Passage estimate of Spring Run Chinook, TODO get methodlogy for generating passage estimates |           0 |
| flow              | Flow in CFS                                                                                  |          15 |
| temperature       | Temperature                                                                                  |           0 |

## Explore `date`

Check for outlier and NA values

``` r
summary(cleaner_data$date)
```

    ##         Min.      1st Qu.       Median         Mean      3rd Qu.         Max. 
    ## "2014-02-20" "2015-06-06" "2017-05-19" "2017-05-19" "2019-03-24" "2020-06-22"

**NA and Unknown Values**

-   0 % of values in the `date` column are NA.

## Explore Numerical Values

``` r
cleaner_data %>% select_if(is.numeric) %>% colnames()
```

    ## [1] "passage_estimate" "flow"             "temperature"

### Variable:`passage_estimate`

``` r
cleaner_data %>% 
  mutate(year = as.factor(year(date))) %>% 
  ggplot(aes(x=date, y = passage_estimate))+
  geom_line()+
  facet_wrap(~year, scales = "free")+
  theme_minimal()+
  labs(title = "Daily Passage Estimate From 2014 - 2020")
```

![](deer-creek-upstream-passage-monitoring_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

``` r
cleaner_data %>% 
  mutate(year = as.factor(year(date))) %>% 
  group_by(year) %>% 
  summarise(total = sum(passage_estimate)) %>%
  ggplot(aes(x = year, y = total, group = 1))+
  geom_line()+
  geom_point(aes(x=year, y = total))+
  theme_minimal()+
  labs(title = "Passage Estimate from 2014 - 2020",
       y = "Total passage_estimate")
```

![](deer-creek-upstream-passage-monitoring_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

**Numeric Summary of passage\_estimate From 2014 to 2020**

``` r
summary(cleaner_data$passage_estimate)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   0.000   0.000   0.000   2.533   2.000  75.000

**NA and Unknown Values**

-   0 % of values in the `passage_estimate` column are NA.

### Variable:`flow`

Flow in cfs

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

![](deer-creek-upstream-passage-monitoring_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

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

![](deer-creek-upstream-passage-monitoring_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->

**Numeric Summary of flow From 2014 to 2020**

``` r
summary(cleaner_data$flow)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   2.062  67.109 124.250 195.895 290.859 857.000     140

**NA and Unknown Values**

-   14.7 % of values in the `flow` column are NA.

### Variable:`temperature`

Temperature in F, convert below

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

![](deer-creek-upstream-passage-monitoring_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

``` r
cleaner_data %>% 
  mutate(year = as.factor(year(date))) %>% 
  ggplot(aes(x=temperature, fill = year))+
  scale_fill_brewer(palette = "Dark2")+
  geom_histogram(bins = 5)+
  theme_minimal()+
  labs(title = "Distribution of Temperature")
```

![](deer-creek-upstream-passage-monitoring_files/figure-gfm/unnamed-chunk-14-1.png)<!-- -->

**Numeric Summary of temperature From 2014 to 2020**

``` r
summary(cleaner_data$temperature)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   42.28   51.65   59.67   60.74   69.22   81.75

**NA and Unknown Values**

-   0 % of values in the `temperature` column are NA.

### Notes and Issues

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
deer_upstream_estimate <- cleaner_data %>% glimpse()
```

    ## Rows: 951
    ## Columns: 4
    ## $ date             <date> 2014-02-20, 2014-02-21, 2014-02-22, 2014-02-23, 2014~
    ## $ passage_estimate <dbl> 0, 0, 0, 0, 0, 0, 0, 3, 16, 2, 0, 0, 0, 5, 6, 2, 0, 2~
    ## $ flow             <dbl> 111, 98, 91, 86, 81, 78, 80, 198, 297, 429, 274, 327,~
    ## $ temperature      <dbl> 9.641253, 9.913194, 10.053241, 10.142940, 10.585069, ~

``` r
f <- function(input, output) write_csv(input, file = output)

gcs_upload(deer_upstream_estimate,
           object_function = f,
           type = "csv",
           name = "adult-upstream-passage-monitoring/deer-creek/data/deer_upstream_passage_estimate.csv")
```