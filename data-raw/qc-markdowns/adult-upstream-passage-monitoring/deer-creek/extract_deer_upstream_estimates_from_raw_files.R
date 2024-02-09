# code to extract adult passage estimates from raw deer creek files
# estimates were manually extracted into `deer_estimates_manual_extract.xlsx`

# code here is only helpful for automating/extracting

# Deer Creek and Mill Creek files were sent individually from Doug Killam and added to the google bucket

# get filenames
get_deer_creek_filenames <- function() {
  gcs_list_objects(bucket = gcs_get_global_bucket(), 
                   detail = "more", 
                   prefix =  "adult-upstream-passage-monitoring/deer-creek/data-raw/DCVS") |> 
    distinct(name) |> 
    pull()
}

get_mill_creek_filenames <- function() {
  gcs_list_objects(bucket = gcs_get_global_bucket(), 
                   detail = "more", 
                   prefix =  "adult-upstream-passage-monitoring/mill-creek/data-raw/MCVS") |> 
    distinct(name) |> 
    pull()
}

read_from_cloud <- function(file_name){
  if(str_detect(file_name, "deer")) {
    output_dir = "data-raw/qc-markdowns/adult-upstream-passage-monitoring/deer-creek/"
  } else if(str_detect(file_name, "mill")) {
    output_dir = "data-raw/qc-markdowns/adult-upstream-passage-monitoring/mill-creek/"
  }
  
  file_title <- basename(file_name) # remove full path
  
  gcs_get_object(object_name = file_name,
                 bucket = gcs_get_global_bucket(),
                 saveToDisk = paste0(output_dir, file_title),
                 overwrite = TRUE)
}

# pull from cloud
purrr::map(get_deer_creek_filenames(), read_from_cloud)
purrr::map(get_mill_creek_filenames(), read_from_cloud)




## 2013-2014

deer_creek_files <- basename(get_deer_creek_filenames())
deer_2014_raw <- readxl::read_xls(here("data-raw", "qc-markdowns", "adult-upstream-passage-monitoring", "deer-creek", paste0(deer_creek_files[1]))) 

deer_2014 <- deer_2013_raw |>
  select(main_col = `Deer Creek Video Station Final Counts February 20, 2014 through June 30, 2014.`) |> 
  filter(!is.na(main_col)) |> 
  mutate(ladder = case_when(str_detect(main_col, "South") ~ "south",
                            str_detect(main_col, "North") ~ "north",
                            TRUE ~ NA),
         is_estimate = ifelse(str_detect(main_col, "Estimat"), TRUE, FALSE),
         is_count = ifelse(str_detect(main_col, "Count"), TRUE, FALSE),
         is_confidence_interval = ifelse(str_detect(main_col, "Confidence"), TRUE, FALSE),
         species = case_when(str_detect(main_col, "Chinook") ~ "chinook",
                             str_detect(main_col, "Steelhead") ~ "steelhead", 
                             TRUE ~ NA)) |> 
  filter(is_estimate | is_count | is_confidence_interval) |> 
  mutate(abundance_estimate = ifelse(is_estimate, readr::parse_number(main_col), NA),
         count = ifelse(is_count, readr::parse_number(main_col), NA),
         cls_raw = str_remove(main_col, "90 %"),
         cls = gsub("[^0-9.-]", "", cls_raw)) |> 
  separate(cls, into = c("lcl", "ucl"), sep = "-") |> 
  fill(species) |> 
  fill(ladder) |> 
  mutate(lcl = as.numeric(lcl),
         ucl = as.numeric(ucl)) |> 
  filter(species == "chinook") |> 
  select(abundance_estimate, lcl, ucl, ladder) |> 
  fill(abundance_estimate) |> 
  filter(!is.na(ucl)) |> 
  mutate(year = 2014,
         stream = "deer creek",
         confidence_interval = "90") |> 
  select(year, stream, ladder, abundance_estimate, lcl, ucl, confidence_interval)


## 2016-2017


process_deer_files <- function(raw_table) {
  first_col <- names(raw_table)[1]
  clean_data <- raw_table |> 
    rename(description = all_of(first_col),
           value = X2) |> 
    mutate(value = ifelse(value == "N/A", NA, value),
           data_type = case_when(str_detect(description, "Estimate") ~ "abundance_estimate",
                                 str_detect(description,"lower confidence") ~ "lcl",
                                 str_detect(description,"upper confidence") ~ "ucl",
                                 TRUE ~ NA)) |> 
    filter(!is.na(data_type)) |> 
    select(data_type, value) |> 
    distinct(value, .keep_all = TRUE) |> 
    pivot_wider(values_from = value, names_from = data_type) |> 
    mutate(ladder = "both",
           stream = "deer creek",
           year = 2017,
           confidence_interval = "90")
  clean_data
}

deer_2017_raw <- openxlsx::read.xlsx(here("data-raw", "qc-markdowns", "adult-upstream-passage-monitoring", "deer-creek", paste0(deer_creek_files[3])),
                                     rows = 1:9,
                                     fillMergedCells = TRUE,
                                     sheet = "SUMMARY") 

deer_2017 <- process_deer_files(deer_2017_raw)


# 2017-2018

deer_2018_raw <- openxlsx::read.xlsx(here("data-raw", "qc-markdowns", "adult-upstream-passage-monitoring", "deer-creek", paste0(deer_creek_files[4])),
                                     rows = 1:9,
                                     fillMergedCells = TRUE,
                                     sheet = "SUMMARY") 

deer_2018 <- process_deer_files(deer_2018_raw) |> 
  mutate(ucl = ifelse(ucl == "N/A", NA, ucl))


# 2018-2019

deer_2019_raw <- openxlsx::read.xlsx(here("data-raw", "qc-markdowns", "adult-upstream-passage-monitoring", "deer-creek", paste0(deer_creek_files[5])),
                                     rows = 1:9,
                                     fillMergedCells = TRUE,
                                     sheet = "SUMMARY") 

deer_2019 <- process_deer_files(deer_2019_raw)


# 2019-2020

deer_2020_raw <- openxlsx::read.xlsx(here("data-raw", "qc-markdowns", "adult-upstream-passage-monitoring", "deer-creek", paste0(deer_creek_files[6])),
                                     rows = 1:9,
                                     fillMergedCells = TRUE,
                                     sheet = "SUMMARY") 

deer_2020 <- process_deer_files(deer_2020_raw)
