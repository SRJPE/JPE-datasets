library(tidyverse)

scores <- readxl::read_excel("analysis/acuracy_scoring.xlsx", 
                             sheet = 1,
                             col_types = c("text", "text", "text", 
                                           "logical", "logical", "logical", 
                                           "logical", "text", "text")) |> glimpse()
lookup <- readxl::read_excel("analysis/acuracy_scoring.xlsx", 
                             sheet = 2,
                             col_types = c("text", "text", "text", 
                                           "logical", "logical")) |> glimpse()

summarized_scores <- lookup |> 
  left_join(scores, by = c("tributary" = "tributary", "submodel" = "submodel")) |> 
  pivot_longer(cols = single_annual_number:delta_timing, names_to = "subobjective", values_to = "needed_for_subobjective") |> glimpse()

View(summarized_scores)
# Score for each approach & subcategory 
# If current score = Low and n > 0 rank low 
approach_name = "All Tributary RST S-R"
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
                                        "Med" %in% future_score ~ "Med", 
                                        "High" %in% future_score ~ "High")) |> glimpse()
  return(left_join(current_score, future_score))
}

# All tribs 
produce_summarized_score("All Tributary RST S-R")
produce_summarized_score("Early Outmigrant Trajectory - All Trib")

# Mainstem
produce_summarized_score("Mainstem RST S-R")
produce_summarized_score("Early Outmigrant Trajectory - Mainstem")

# Dominant Tribs 
produce_summarized_score("Dominant Producing Trib S-R")
produce_summarized_score("Early Outmigrant Trajectory - Dominant Tribs")
