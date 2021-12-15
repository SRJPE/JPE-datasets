Explore Variables
================
Erin Cain
12/14/2021

## Adult Upstream Passage

``` r
# VIDEO DATA 
# Battle Creek 
battle_video <- readRDS("../../data/battle_adult_video_passage_data_dictionary.rds") %>% 
  mutate(location = "Battle Creek") %>% glimpse
```

    ## Rows: 7
    ## Columns: 4
    ## $ variables   <chr> "date", "time", "adipose", "comments", "run", "passage_dir~
    ## $ description <chr> "Date", "Time", "Adipose fin present or not", "Comments", ~
    ## $ percent_na  <dbl> 0, 4, 0, 88, 0, 0, 0
    ## $ location    <chr> "Battle Creek", "Battle Creek", "Battle Creek", "Battle Cr~

``` r
# Clear Creek 
clear_video <- readRDS("../../data/clear_adult_passage_data_dictionary.rds")%>% 
  mutate(location = "Clear Creek") %>% glimpse
```

    ## Rows: 11
    ## Columns: 4
    ## $ variables   <chr> "date", "time_block", "viewing_condition", "time_passed", ~
    ## $ description <chr> "Date", "Time block", "Viewing condition", "Time passed", ~
    ## $ percent_na  <dbl> 0, 0, 0, 0, 0, 0, 22, 1, 21, 0, 0
    ## $ location    <chr> "Clear Creek", "Clear Creek", "Clear Creek", "Clear Creek"~

``` r
# Deer Creek 
deer_video <- readRDS("../../data/deer_adult_passage_data_dictionary.rds")%>% 
  mutate(location = "Deer Creek") %>% glimpse
```

    ## Rows: 4
    ## Columns: 4
    ## $ variables   <chr> "date", "passage_estimate", "flow", "temperature"
    ## $ description <chr> "Date of sampling", "Passage estimate of Spring Run Chinoo~
    ## $ percent_na  <dbl> 0, 0, 15, 0
    ## $ location    <chr> "Deer Creek", "Deer Creek", "Deer Creek", "Deer Creek"

``` r
# Yuba River 
yuba_video <- readRDS("../../data/yuba_adult_passage_data_dictionary.rds") %>% 
  mutate(location = "Yuba River") %>% glimpse
```

    ## Rows: 11
    ## Columns: 4
    ## $ variables   <chr> "date", "time", "length_cm", "category", "passage_directio~
    ## $ description <chr> "Date of sampling", "Time of sampling", "Length of fish in~
    ## $ percent_na  <dbl> 0, 0, 0, 0, 0, 0, 24, 24, 17, 0, 0
    ## $ location    <chr> "Yuba River", "Yuba River", "Yuba River", "Yuba River", "Y~

``` r
adult_upstream_video_variables <- 
  bind_rows(battle_video, clear_video, deer_video, yuba_video) %>% 
  group_by(variables) %>%
  tally() %>%
  glimpse()
```

    ## Rows: 23
    ## Columns: 2
    ## $ variables <chr> "adipose", "category", "comments", "count", "date", "depth_m~
    ## $ n         <int> 2, 1, 1, 3, 4, 1, 1, 1, 1, 1, 1, 3, 1, 1, 2, 1, 1, 1, 1, 2, ~

``` r
# View(adult_upstream_video_variables)
```

``` r
set.seed(2)
wordcloud2(adult_upstream_video_variables)
```

<div id="htmlwidget-54cec5059f87105cd0cb" style="width:672px;height:480px;" class="wordcloud2 html-widget"></div>
<script type="application/json" data-for="htmlwidget-54cec5059f87105cd0cb">{"x":{"word":["adipose","category","comments","count","date","depth_m","flow","hours","jack_size","ladder","length_cm","passage_direction","passage_estimate","position_in_frame","run","sex","spawning_condition","speed_m_per_s","temperature","time","time_block","time_passed","viewing_condition"],"freq":[2,1,1,3,4,1,1,1,1,1,1,3,1,1,2,1,1,1,1,2,1,1,1],"fontFamily":"Segoe UI","fontWeight":"bold","color":"random-dark","minSize":0,"weightFactor":45,"backgroundColor":"white","gridSize":0,"minRotation":-0.785398163397448,"maxRotation":0.785398163397448,"shuffle":true,"rotateRatio":0.4,"shape":"circle","ellipticity":0.65,"figBase64":null,"hover":null},"evals":[],"jsHooks":{"render":[{"code":"function(el,x){\n                        console.log(123);\n                        if(!iii){\n                          window.location.reload();\n                          iii = False;\n\n                        }\n  }","data":null}]}}</script>

``` r
# Passage Estimates 
# Battle Creek 
battle_passage_estimates <- readRDS("../../data/battle_adult_passage_estimates_data_dictionary.rds") %>% 
  mutate(location = "Battle Creek") %>% glimpse
```

    ## Rows: 9
    ## Columns: 4
    ## $ variables   <chr> "week", "method", "hours_of_passage", "hours_of_taped_pass~
    ## $ description <chr> "Weeks", "Method of observation", "Hours of passage", "Hou~
    ## $ percent_na  <dbl> 0, 0, 41, 41, 0, 0, 0, 0, 34
    ## $ location    <chr> "Battle Creek", "Battle Creek", "Battle Creek", "Battle Cr~

``` r
# Deer Creek 
deer_passage_estimates <- readRDS("../../data/deer_adult_passage_data_dictionary.rds")%>% 
  mutate(location = "Deer Creek") %>% glimpse
```

    ## Rows: 4
    ## Columns: 4
    ## $ variables   <chr> "date", "passage_estimate", "flow", "temperature"
    ## $ description <chr> "Date of sampling", "Passage estimate of Spring Run Chinoo~
    ## $ percent_na  <dbl> 0, 0, 15, 0
    ## $ location    <chr> "Deer Creek", "Deer Creek", "Deer Creek", "Deer Creek"

``` r
# Mill Creek
mill_passage_estimates <- readRDS("../../data/mill_adult_passage_data_dictionary.rds") %>% 
  mutate(location = "Mill Creek") %>% glimpse
```

    ## Rows: 4
    ## Columns: 4
    ## $ variables   <chr> "date", "passage_estimate", "flow", "temperature"
    ## $ description <chr> "Date of sampling", "Passage estimate of Spring Run Chinoo~
    ## $ percent_na  <dbl> 0, 3, 17, 12
    ## $ location    <chr> "Mill Creek", "Mill Creek", "Mill Creek", "Mill Creek"

``` r
adult_upstream_passage_estimate_variables <- 
  bind_rows(battle_passage_estimates, deer_passage_estimates, mill_passage_estimates) %>% 
  group_by(variables) %>%
  tally() %>%
  glimpse()
```

    ## Rows: 12
    ## Columns: 2
    ## $ variables <chr> "adipose", "date", "end_date", "flow", "hours_of_passage", "~
    ## $ n         <int> 1, 2, 1, 2, 1, 1, 1, 3, 1, 1, 2, 1

``` r
# View(adult_upstream_passage_estimate_variables)
```

``` r
set.seed(2)
wordcloud2(adult_upstream_passage_estimate_variables, size = .75)
```

<div id="htmlwidget-7c28b14ac082f5cfdf31" style="width:672px;height:480px;" class="wordcloud2 html-widget"></div>
<script type="application/json" data-for="htmlwidget-7c28b14ac082f5cfdf31">{"x":{"word":["adipose","date","end_date","flow","hours_of_passage","hours_of_taped_passage","method","passage_estimate","raw_count","start_date","temperature","week"],"freq":[1,2,1,2,1,1,1,3,1,1,2,1],"fontFamily":"Segoe UI","fontWeight":"bold","color":"random-dark","minSize":0,"weightFactor":45,"backgroundColor":"white","gridSize":0,"minRotation":-0.785398163397448,"maxRotation":0.785398163397448,"shuffle":true,"rotateRatio":0.4,"shape":"circle","ellipticity":0.65,"figBase64":null,"hover":null},"evals":[],"jsHooks":{"render":[{"code":"function(el,x){\n                        console.log(123);\n                        if(!iii){\n                          window.location.reload();\n                          iii = False;\n\n                        }\n  }","data":null}]}}</script>

``` r
battle_trap <- readRDS("../../data/battle_adult_trap_data_dictionary.rds") %>% 
  mutate(location = "Battle Creek") %>% glimpse
```

    ## Rows: 16
    ## Columns: 4
    ## $ variables   <chr> "date", "trap_beg", "trap_end", "time", "count", "sex", "c~
    ## $ description <chr> "Date", "Date trapping started", "Date trapping ended", "T~
    ## $ percent_na  <dbl> 0, 0, 7, 11, 0, 0, 53, 1, 0, 1, 2, 0, 0, 13, 91, 70
    ## $ location    <chr> "Battle Creek", "Battle Creek", "Battle Creek", "Battle Cr~

## Carcass Surveys

``` r
battle_carcass <- readRDS("../../data/battle_carcass_data_dictionary.rds") %>% 
  mutate(location = "Battle Creek") %>% glimpse
```

    ## Rows: 16
    ## Columns: 4
    ## $ variables   <chr> "longitude", "latitude", "river_mile", "date", "method", "~
    ## $ description <chr> "GPS X point", "GPS Y point", "River mile number", "Sample~
    ## $ percent_na  <dbl> 81, 81, 81, 0, 0, 9, 0, 0, 15, 0, 0, 0, 0, 96, 98, 69
    ## $ location    <chr> "Battle Creek", "Battle Creek", "Battle Creek", "Battle Cr~

``` r
butte_carcass <- readRDS("../../data/butte_carcass_individuals_2_data_dictionary.rds") %>% 
  mutate(location = "Butte Creek") %>% glimpse
```

    ## Rows: 15
    ## Columns: 4
    ## $ variables   <chr> "survey", "date", "section_cd", "way_pt", "disposition", "~
    ## $ description <chr> "Unique survey ID number", "Date of sampling", "Section co~
    ## $ percent_na  <dbl> 47, 47, 47, 0, 47, 0, 0, 0, 0, 0, 0, 84, 89, 98, 95
    ## $ location    <chr> "Butte Creek", "Butte Creek", "Butte Creek", "Butte Creek"~

``` r
clear_carcass <- readRDS("../../data/clear_carcass_data_dictionary.rds") %>% 
  mutate(location = "Clear Creek") %>% glimpse
```

    ## Rows: 33
    ## Columns: 4
    ## $ variables   <chr> "type", "date", "longitude", "latitude", "reach", "river_m~
    ## $ description <chr> "Survey type", "Date of sampling", "GPS X point", "GPS Y p~
    ## $ percent_na  <dbl> 0, 0, 0, 0, 0, 0, 0, 1, 0, 16, 0, 0, 0, 0, 0, 0, 90, 1, 21~
    ## $ location    <chr> "Clear Creek", "Clear Creek", "Clear Creek", "Clear Creek"~

``` r
carcass_survey_variables <- bind_rows(battle_carcass, butte_carcass, clear_carcass) %>%
  group_by(variables) %>% 
  tally()

# Seems to be more simplified, TODO better understand difference between CHOPS and Survey Individuals
butte_chops <- readRDS("../../data/butte_carcass_chops_data_dictionary.rds") %>% 
  mutate(location = "Butte Creek") %>% glimpse
```

    ## Rows: 7
    ## Columns: 4
    ## $ variables   <chr> "date", "section_cd", "way_pt", "disposition", "chop_count~
    ## $ description <chr> "Date of sampling", "Section code describing area surveyed~
    ## $ percent_na  <dbl> 0, 0, 0, 0, 0, 0, 0
    ## $ location    <chr> "Butte Creek", "Butte Creek", "Butte Creek", "Butte Creek"~

``` r
View(carcass_survey_variables)
```

``` r
set.seed(3746)
wordcloud2(carcass_survey_variables, size = .45)
```

<div id="htmlwidget-72363e87e62035686fe3" style="width:672px;height:480px;" class="wordcloud2 html-widget"></div>
<script type="application/json" data-for="htmlwidget-72363e87e62035686fe3">{"x":{"word":["ad_fin_clip_cd","adipose","age","brood_year","carcass_live_status","comments","condition","cwt_code","date","disc_tag_applied","disposition","fork_length","fork_length_mm","genetic","hatchery","head_retrieved","latitude","location","longitude","mark_rate","method","obs_only","observed_only","other_tag","otolith_nu","otolith_st","photo","reach","release_location","river_mile","run","run_call","sample_id","scale","scale_nu","section_cd","sex","spawn_condition","spawn_status","spawning_status","survey","tag_type","tis_dry","tis_eth","tissue_nu","type","verification_and_cwt_comments","way_pt","why_not_sp","why_sex_unknown"],"freq":[1,2,1,1,1,3,2,2,3,1,1,2,1,1,1,1,2,1,2,1,1,1,1,1,1,1,1,1,1,2,2,1,1,1,1,1,3,1,1,1,1,1,1,1,1,1,1,1,1,1],"fontFamily":"Segoe UI","fontWeight":"bold","color":"random-dark","minSize":0,"weightFactor":27,"backgroundColor":"white","gridSize":0,"minRotation":-0.785398163397448,"maxRotation":0.785398163397448,"shuffle":true,"rotateRatio":0.4,"shape":"circle","ellipticity":0.65,"figBase64":null,"hover":null},"evals":[],"jsHooks":{"render":[{"code":"function(el,x){\n                        console.log(123);\n                        if(!iii){\n                          window.location.reload();\n                          iii = False;\n\n                        }\n  }","data":null}]}}</script>
