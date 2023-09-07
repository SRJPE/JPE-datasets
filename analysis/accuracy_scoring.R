library(tidyverse)
library(googleCloudStorageR)

gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
# # Set global bucket 
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))


# Load datasets ----------------------------------------------------------------
gcs_get_object(object_name = "sdm-resources/accuracy_scoring.xlsx",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "analysis/accuracy_scoring.xlsx",
               overwrite = TRUE)

# Load in scoring sheet 
scores <- readxl::read_excel("analysis/accuracy_scoring.xlsx", 
                             sheet = 1,
                             col_types = c("text", "text", "text", 
                                           "logical", "logical", "logical", 
                                           "logical", "text", "text")) |> glimpse()
#### Warnings triggered by logical cells that are NA 

# Load in lookup sheet that maps submodels and tribs to approaches 
lookup <- readxl::read_excel("analysis/accuracy_scoring.xlsx", 
                             sheet = 2,
                             col_types = c("text", "text", "text", 
                                           "logical", "logical")) |> glimpse()
#### Warnings triggered by logical cells that are NA 

# Summarize and join data ------------------------------------------------------
summarized_scores <- lookup |> 
  left_join(scores, by = c("tributary" = "tributary", "submodel" = "submodel")) |> 
  pivot_longer(cols = single_annual_number:delta_timing, 
               names_to = "subobjective", 
               values_to = "needed_for_subobjective") |> glimpse()

View(summarized_scores) # quick visual inspection to make sure join looks reasonable 

# Score for each approach & subcategory ----------------------------------------
# If any scores = Low all low
approach_name = "All Tributary RST S-R" # For stepping through function 
produce_summarized_score <- function(approach_name){
  current_score <- summarized_scores |> 
    filter(approach == approach_name, 
           needed_for_subobjective,
           current) |> 
    group_by(approach, subobjective) |> 
    summarize(current_score = case_when("Low" %in% current_score ~ "Low", 
                                "Med" %in% current_score ~ "Med", 
                                "High" %in% current_score ~ "High")) |> glimpse()
  
  future_score <- summarized_scores |> 
    filter(approach == approach_name, 
           needed_for_subobjective,
           future) |>
    group_by(approach, subobjective) |> 
    summarize(future_score = case_when("Low" %in% future_score ~ "Low", 
                                        "Medium" %in% future_score ~ "Medium", 
                                        "High" %in% future_score ~ "High")) |> glimpse()
  return(left_join(current_score, future_score))
}

# Produce sumarized scores for each tributary ----------------------------------
# All tribs 
produce_summarized_score("All Tributary RST S-R")
produce_summarized_score("Early Outmigrant Trajectory - All Trib")

# Mainstem
produce_summarized_score("Mainstem RST S-R")
produce_summarized_score("Early Outmigrant Trajectory - Mainstem")

# Dominant Tribs 
produce_summarized_score("Dominant Producing Trib S-R")
produce_summarized_score("Early Outmigrant Trajectory - Dominant Tribs")
