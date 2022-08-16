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

## Redd Survey

``` r
battle_redd <- readRDS("../../data/battle_redd_data_dictionary.rds") %>% 
  mutate(location = "Battle Creek") %>% glimpse
```

    ## Rows: 25
    ## Columns: 4
    ## $ variables   <chr> "longitude", "latitude", "date", "reach", "river_mile", "p~
    ## $ description <chr> "GPS X point", "GPS Y point", "Date of sample", "Reach num~
    ## $ percent_na  <dbl> 0, 0, 0, 0, 0, 39, 39, 39, 0, 0, 4, 62, 62, 62, 55, 55, 64~
    ## $ location    <chr> "Battle Creek", "Battle Creek", "Battle Creek", "Battle Cr~

``` r
clear_redd <- readRDS("../../data/clear_redd_data_dictionary.rds") %>% 
  mutate(location = "Clear Creek") %>% glimpse
```

    ## Rows: 43
    ## Columns: 4
    ## $ variables   <chr> "method", "longitude", "latitude", "survey", "river_mile",~
    ## $ description <chr> "Survey method", "GPS X point", "GPS Y point", "Survey Num~
    ## $ percent_na  <dbl> 0, 0, 0, 10, 0, 14, 0, 0, 0, 0, 0, 11, 31, 37, 0, 4, 50, 5~
    ## $ location    <chr> "Clear Creek", "Clear Creek", "Clear Creek", "Clear Creek"~

``` r
feather_redd <- readRDS("../../data/feather_redd_data_dictionary.rds") %>% 
  mutate(location = "Feather River") %>% glimpse
```

    ## Rows: 17
    ## Columns: 4
    ## $ variables   <chr> "date", "location", "type", "redd_count", "salmon_count", ~
    ## $ description <chr> "Sample date", "Nominal description of location", "Type of~
    ## $ percent_na  <dbl> 0, 0, 0, 0, 0, 85, 86, 88, 86, 86, 86, 86, 86, 85, 86, 67,~
    ## $ location    <chr> "Feather River", "Feather River", "Feather River", "Feathe~

``` r
mill_redd <- readRDS("../../data/mill_redd_data_dictionary.rds") %>% 
  mutate(location = "Mill Creek") %>% glimpse
```

    ## Rows: 4
    ## Columns: 4
    ## $ variables   <chr> "location", "starting_elevation_ft", "year", "redd_count"
    ## $ description <chr> "Nominal description of sampling location", "Elevation at ~
    ## $ percent_na  <dbl> 0, 53, 0, 11
    ## $ location    <chr> "Mill Creek", "Mill Creek", "Mill Creek", "Mill Creek"

``` r
redd_survey_variables <- bind_rows(battle_redd, clear_redd, feather_redd, mill_redd) %>%
  group_by(variables) %>% 
  tally() %>% 
  glimpse()
```

    ## Rows: 71
    ## Columns: 2
    ## $ variables <chr> "age", "bomb_vel60", "bomb_vel80", "comments", "date", "date~
    ## $ n         <int> 1, 1, 1, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, ~

``` r
View(redd_survey_variables)
```

``` r
set.seed(3746)
wordcloud2(redd_survey_variables, size = .45)
```

<div id="htmlwidget-aa25686da78f2cedcf85" style="width:672px;height:480px;" class="wordcloud2 html-widget"></div>
<script type="application/json" data-for="htmlwidget-aa25686da78f2cedcf85">{"x":{"word":["age","bomb_vel60","bomb_vel80","comments","date","date_measured","depth_m","end_60","end_80","end_number_flow_meter","end_number_flow_meter_80","fish_guarding","fish_on_redd","flow_fps","flow_meter","flow_meter_time","flow_meter_time_80","gravel","inj_site","latitude","location","longitude","measured","method","observation_age","observation_date","observation_reach","percent_boulder","percent_fine_substrate","percent_large_substrate","percent_medium_substrate","percent_small_substrate","picket_weir_location","picket_weir_relation","pot_depth_m","pre_redd_depth","pre_redd_substrate_size","reach","redd_count","redd_id","redd_length","redd_length_in","redd_length_m","redd_loc","redd_measured","redd_pit_depth","redd_substrate_size","redd_tail_depth","redd_width","redd_width_in","redd_width_m","river_mile","run","salmon_count","sec_60","secs_80","start_60","start_80","start_number_flow_meter","start_number_flow_meter_80","starting_elevation_ft","survey","survey_observed","surveyed_reach","tail_substrate_size","type","ucc_relate","velocity","why_not_measured","x1000ftbreak","year"],"freq":[1,1,1,2,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,2,3,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,1,2,1,1,1,1,1,1,2,2,2,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,2,1,1,2,2,1,1],"fontFamily":"Segoe UI","fontWeight":"bold","color":"random-dark","minSize":0,"weightFactor":27,"backgroundColor":"white","gridSize":0,"minRotation":-0.785398163397448,"maxRotation":0.785398163397448,"shuffle":true,"rotateRatio":0.4,"shape":"circle","ellipticity":0.65,"figBase64":null,"hover":null},"evals":[],"jsHooks":{"render":[{"code":"function(el,x){\n                        console.log(123);\n                        if(!iii){\n                          window.location.reload();\n                          iii = False;\n\n                        }\n  }","data":null}]}}</script>

## Holding Survey

``` r
battle_holding <- readRDS("../../data/battle_holding_data_dictionary.rds") %>% 
  mutate(location = "Battle Creek") %>% glimpse
```

    ## Rows: 8
    ## Columns: 4
    ## $ variables   <chr> "longitude", "latitude", "date", "reach", "river_mile", "c~
    ## $ description <chr> "GPS X point", "GPS Y point", "Date of sample", "Reach num~
    ## $ percent_na  <dbl> 0, 0, 0, 0, 0, 0, 65, 40
    ## $ location    <chr> "Battle Creek", "Battle Creek", "Battle Creek", "Battle Cr~

``` r
clear_holding <- readRDS("../../data/clear_holding_data_dictionary.rds") %>% 
  mutate(location = "Clear Creek") %>% glimpse
```

    ## Rows: 11
    ## Columns: 4
    ## $ variables   <chr> "river_mile", "longitude", "latitude", "date", "reach", "c~
    ## $ description <chr> "River mile number", "GPS X point", "GPS Y point", "Date o~
    ## $ percent_na  <dbl> 0, 0, 0, 0, 0, 0, 0, 88, 9, 0, 0
    ## $ location    <chr> "Clear Creek", "Clear Creek", "Clear Creek", "Clear Creek"~

``` r
deer_holding <- readRDS("../../data/deer_holding_data_dictionary.rds") %>% 
  mutate(location = "Deer River") %>% glimpse
```

    ## Rows: 3
    ## Columns: 4
    ## $ variables   <chr> "location", "year", "count"
    ## $ description <chr> "Sample year", "Description of location sampled", "Number ~
    ## $ percent_na  <dbl> 0, 0, 6
    ## $ location    <chr> "Deer River", "Deer River", "Deer River"

``` r
holding_survey_variables <- bind_rows(battle_holding, clear_holding, deer_holding) %>%
  group_by(variables) %>% 
  tally() %>% 
  glimpse()
```

    ## Rows: 15
    ## Columns: 2
    ## $ variables <chr> "comments", "count", "date", "jack_count", "jacks", "latitud~
    ## $ n         <int> 1, 3, 2, 1, 1, 2, 1, 2, 1, 1, 1, 2, 2, 1, 1

``` r
set.seed(3746)
wordcloud2(holding_survey_variables, size = .45)
```

<div id="htmlwidget-520876c7ac7c855d8176" style="width:672px;height:480px;" class="wordcloud2 html-widget"></div>
<script type="application/json" data-for="htmlwidget-520876c7ac7c855d8176">{"x":{"word":["comments","count","date","jack_count","jacks","latitude","location","longitude","notes","picket_weir_location_rm","picket_weir_relate","reach","river_mile","survey_intent","year"],"freq":[1,3,2,1,1,2,1,2,1,1,1,2,2,1,1],"fontFamily":"Segoe UI","fontWeight":"bold","color":"random-dark","minSize":0,"weightFactor":27,"backgroundColor":"white","gridSize":0,"minRotation":-0.785398163397448,"maxRotation":0.785398163397448,"shuffle":true,"rotateRatio":0.4,"shape":"circle","ellipticity":0.65,"figBase64":null,"hover":null},"evals":[],"jsHooks":{"render":[{"code":"function(el,x){\n                        console.log(123);\n                        if(!iii){\n                          window.location.reload();\n                          iii = False;\n\n                        }\n  }","data":null}]}}</script>

## RST Variables

``` r
battle_rst <- readRDS("../../data/battle_rst_data_dictionary.rds") %>%
  mutate(location = "Battle Creek") %>% glimpse
```

    ## Rows: 8
    ## Columns: 4
    ## $ variables   <chr> "date", "sample_id", "run", "fork_length", "lifestage", "c~
    ## $ description <chr> "Sample date - end date of approximately 24 hour sampling ~
    ## $ percent_na  <dbl> 0, 0, 0, 0, 0, 0, 0, 0
    ## $ location    <chr> "Battle Creek", "Battle Creek", "Battle Creek", "Battle Cr~

``` r
butte_rst <- readRDS("../../data/butte_rst_data_dictionary.rds") %>% 
  mutate(location = "Butte Creek") %>% glimpse
```

    ## Rows: 23
    ## Columns: 4
    ## $ variables   <chr> "date", "station", "trap_status", "dead", "count", "fork_l~
    ## $ description <chr> "Date of sampling", "RST Station, BCOKIE-1, BCADAMS, BCOKI~
    ## $ percent_na  <dbl> 0, 0, 0, 0, 0, 5, 40, 0, 0, 0, 8, 4, 6, 33, 98, 61, 0, 0, ~
    ## $ location    <chr> "Butte Creek", "Butte Creek", "Butte Creek", "Butte Creek"~

``` r
clear_rst <- readRDS("../../data/clear_rst_data_dictionary.rds") %>% 
  mutate(location = "Clear Creek") %>% glimpse
```

    ## Rows: 9
    ## Columns: 4
    ## $ variables   <chr> "station_code", "date", "sample_id", "run", "fork_length",~
    ## $ description <chr> "The station code, two stations Lower Clear Creek (LCC) an~
    ## $ percent_na  <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0
    ## $ location    <chr> "Clear Creek", "Clear Creek", "Clear Creek", "Clear Creek"~

``` r
deer_rst <- readRDS("../../data/deer_rst_data_dictionary.rds") %>% 
  mutate(location = "Deer Creek") %>% glimpse
```

    ## Rows: 13
    ## Columns: 4
    ## $ variables   <chr> "date", "location", "count", "fork_length", "weight", "flo~
    ## $ description <chr> "Date", "Sampling location", "Count", "Forklength of the f~
    ## $ percent_na  <dbl> 0, 0, 0, 2, 65, 28, 27, 28, 18, 36, 12, 54, 12
    ## $ location    <chr> "Deer Creek", "Deer Creek", "Deer Creek", "Deer Creek", "D~

``` r
#TODO feather river RST
feather_rst <- readRDS("../../data/feather_rst_data_dictionary.rds") %>% 
  mutate(location = "Feather River") %>% glimpse()
```

    ## Rows: 6
    ## Columns: 4
    ## $ variables   <chr> "date", "site_name", "run", "lifestage", "fork_length", "c~
    ## $ description <chr> "Date", "Site", "Run of the fish", "Lifestage of the fish"~
    ## $ percent_na  <dbl> 0, 0, 0, 0, 5, 0
    ## $ location    <chr> "Feather River", "Feather River", "Feather River", "Feathe~

``` r
mill_rst <- readRDS("../../data/mill_rst_data_dictionary.rds") %>% 
  mutate(location = "Mill Creek") %>% glimpse
```

    ## Rows: 13
    ## Columns: 4
    ## $ variables   <chr> "date", "location", "count", "fork_length", "weight", "flo~
    ## $ description <chr> "Date of sample", "Location of sample", "Number of fish ca~
    ## $ percent_na  <dbl> 0, 0, 0, 2, 67, 24, 29, 32, 23, 24, 48, 9, 63
    ## $ location    <chr> "Mill Creek", "Mill Creek", "Mill Creek", "Mill Creek", "M~

``` r
yuba_rst <- readRDS("../../data/yuba_rst_data_dictionary.rds") %>% 
  mutate(location = "Yuba River") %>% glimpse
```

    ## Rows: 19
    ## Columns: 4
    ## $ variables   <chr> "date", "time", "method", "water_temperature", "turbidity"~
    ## $ description <chr> "Date of sample", "Time of sample", "Method of sampling. C~
    ## $ percent_na  <dbl> 0, 0, 0, 1, 8, 13, 1, 11, 68, 3, 6, 30, 63, 0, 0, 0, 0, 0,~
    ## $ location    <chr> "Yuba River", "Yuba River", "Yuba River", "Yuba River", "Y~

``` r
knights_rst <- readRDS("../../data/lower_sac_knights_rst_data_dictionary.rds") %>% 
  mutate(location = "Sac River - Knights") %>% glimpse
```

    ## Rows: 12
    ## Columns: 4
    ## $ variables   <chr> "date", "start_date", "stop_date", "location", "fork_lengt~
    ## $ description <chr> "Date of sampling. In more recent years, start and stop da~
    ## $ percent_na  <dbl> 0, 66, 66, 37, 20, 22, 0, 0, 16, 97, 3, 27
    ## $ location    <chr> "Sac River - Knights", "Sac River - Knights", "Sac River -~

``` r
tisdale_rst <- readRDS("../../data/lower_sac_tisdale_rst_data_dictionary.rds") %>% 
  mutate(location = "Sac River - Tisdale") %>% glimpse
```

    ## Rows: 21
    ## Columns: 4
    ## $ variables   <chr> "date", "trap_position", "fish_processed", "species", "for~
    ## $ description <chr> "Date of sampling", "Position of trap. Options are river l~
    ## $ percent_na  <dbl> 0, 0, 0, 0, 23, 64, 0, 0, 39, 0, 0, 0, 0, 0, 0, 0, 0, 90, ~
    ## $ location    <chr> "Sac River - Tisdale", "Sac River - Tisdale", "Sac River -~

``` r
rst_catch_variables <- bind_rows(battle_rst, butte_rst, clear_rst, deer_rst, feather_rst, mill_rst, yuba_rst, knights_rst, tisdale_rst) %>%
  group_by(variables) %>% 
  tally() %>% 
  glimpse()
```

    ## Rows: 63
    ## Columns: 2
    ## $ variables <chr> "analyses", "at_capture_run", "catch_comment", "comments", "~
    ## $ n         <int> 1, 2, 1, 4, 9, 1, 9, 3, 2, 1, 1, 2, 7, 1, 1, 1, 1, 2, 1, 6, ~

``` r
View(rst_catch_variables)
```

``` r
set.seed(3746)
wordcloud2(rst_catch_variables, size = .6)
```

<div id="htmlwidget-d1c2f30280d62f282cce" style="width:672px;height:480px;" class="wordcloud2 html-widget"></div>
<script type="application/json" data-for="htmlwidget-d1c2f30280d62f282cce">{"x":{"word":["analyses","at_capture_run","catch_comment","comments","count","cpue","date","dead","debris","final_run","fish_processed","flow","fork_length","fork_length_max_mm","fork_length_min_mm","fork_length_mm","gear_id","interpolated","life_stage","lifestage","location","mark_code","mark_color","mark_position","mark_type","marked","method","mortality","north_brush","organism_code","random","rearing","release_id","rpms_after","rpms_before","rpms_end","rpms_start","run","sample_id","secchi","site_name","south_brush","species","start_date","station","station_code","stop_date","temperature","time","time_for_10_revolutions","trap_condition_code","trap_position","trap_revolutions","trap_revolutions2","trap_status","trap_visit_comment","tubs_of_debris","turbidity","velocity","water_temperature","water_temperature_celsius","weather","weight"],"freq":[1,2,1,4,9,1,9,3,2,1,1,2,7,1,1,1,1,2,1,6,5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,2,1,1,1,2,1,1,1,1,1,2,2,2,1,2,1,2,1,2,4,2,2,1,3,5],"fontFamily":"Segoe UI","fontWeight":"bold","color":"random-dark","minSize":0,"weightFactor":12,"backgroundColor":"white","gridSize":0,"minRotation":-0.785398163397448,"maxRotation":0.785398163397448,"shuffle":true,"rotateRatio":0.4,"shape":"circle","ellipticity":0.65,"figBase64":null,"hover":null},"evals":[],"jsHooks":{"render":[{"code":"function(el,x){\n                        console.log(123);\n                        if(!iii){\n                          window.location.reload();\n                          iii = False;\n\n                        }\n  }","data":null}]}}</script>

##### RST effort & efficency

``` r
battle_rst_operations <- readRDS("../../data/battle_rst_environmental_data_dictionary.rds") %>%
  mutate(location = "Battle Creek") %>% glimpse
```

    ## Rows: 35
    ## Columns: 4
    ## $ variables   <chr> "sample_id", "trap_start_date", "trap_start_time", "sample~
    ## $ description <chr> "The calendar year Julian date and year code for that ~24-~
    ## $ percent_na  <dbl> 0, 1, 1, 0, 0, 2, 3, 3, 3, 3, 3, 1, 1, 1, 32, 32, 32, 1, 1~
    ## $ location    <chr> "Battle Creek", "Battle Creek", "Battle Creek", "Battle Cr~

``` r
# Butte all in one table 

clear_rst_operations <- readRDS("../../data/clear_rst_environmental_data_dictionary.rds") %>% 
  mutate(location = "Clear Creek") %>% glimpse
```

    ## Rows: 35
    ## Columns: 4
    ## $ variables   <chr> "station_code", "sample_id", "trap_start_date", "trap_star~
    ## $ description <chr> "The station code, two stations Lower Clear Creek (LCC) an~
    ## $ percent_na  <dbl> 0, 0, 2, 2, 0, 0, 4, 4, 4, 4, 3, 2, 2, 2, 36, 36, 36, 2, 2~
    ## $ location    <chr> "Clear Creek", "Clear Creek", "Clear Creek", "Clear Creek"~

``` r
# Deer all in one table 

feather_rst_operations <- readRDS("../../data/feather_rst_effort_data_dictionary.rds") %>% 
  mutate(location = "Feather River") %>% glimpse()
```

    ## Rows: 7
    ## Columns: 4
    ## $ variables   <chr> "sub_site_name", "visit_time", "visit_type", "trap_functio~
    ## $ description <chr> "Site name", "Visit time", "Visit type", "Trap functioning~
    ## $ percent_na  <dbl> 0, 0, 0, 0, 0, 12, 23
    ## $ location    <chr> "Feather River", "Feather River", "Feather River", "Feathe~

``` r
# Mill all in one table

# Yuba all in one table 

knights_rst_operations <- readRDS("../../data/lower_sac_knights_rst_effort_data_dictionary.rds") %>% 
  mutate(location = "Sac River - Knights") %>% glimpse
```

    ## Rows: 19
    ## Columns: 4
    ## $ variables   <chr> "date", "start_date", "stop_date", "location", "gear", "nu~
    ## $ description <chr> "Date of sampling. In more recent years, start and stop da~
    ## $ percent_na  <dbl> 0, 51, 51, 44, 44, 55, 0, 45, 1, 40, 0, 93, 77, 86, 4, 0, ~
    ## $ location    <chr> "Sac River - Knights", "Sac River - Knights", "Sac River -~

``` r
# Tisdale all in one table 

rst_operations_variables <- bind_rows(battle_rst_operations, clear_rst_operations, knights_rst_operations) %>%
  group_by(variables) %>% 
  tally() %>% 
  glimpse()
```

    ## Rows: 55
    ## Columns: 2
    ## $ variables <chr> "avg_time_per_rev", "baileys_eff", "comments", "cone", "cone~
    ## $ n         <int> 2, 2, 1, 2, 1, 1, 1, 2, 1, 2, 2, 2, 2, 2, 1, 2, 2, 2, 1, 2, ~

``` r
View(rst_operations_variables)
```

``` r
set.seed(3746)
wordcloud2(rst_operations_variables, size = .25)
```

<div id="htmlwidget-201107a3ecff5d24fbe1" style="width:672px;height:480px;" class="wordcloud2 html-widget"></div>
<script type="application/json" data-for="htmlwidget-201107a3ecff5d24fbe1">{"x":{"word":["avg_time_per_rev","baileys_eff","comments","cone","cone_id","cone_rpm","cone_sampling_effort","counter","date","debris_tubs","debris_type","depth_adjust","diel","fish_properly","flow_cfs","flow_end_meter","flow_set_time","flow_start_meter","gear","gear_condition_code","habitat","hrs_fished","klci","location","lunar_phase","num_released","number_traps","partial_sample","report_baileys_eff","river_center_depth","river_left_depth","river_right_depth","sample_date","sample_id","sample_time","sampling_period_hrs","secchi_ft","start_counter","start_date","station_code","stop_date","sub_week","thalweg","total_cone_rev","trap_comments","trap_fishing","trap_sample_type","trap_start_date","trap_start_time","turbidity","turbidity_units","velocity","velocity_ft_per_s","water_t_f","weather_code"],"freq":[2,2,1,2,1,1,1,2,1,2,2,2,2,2,1,2,2,2,1,2,2,1,1,1,2,2,1,2,1,2,2,2,2,2,2,1,1,2,1,1,1,2,2,1,2,2,2,2,2,3,1,1,1,1,2],"fontFamily":"Segoe UI","fontWeight":"bold","color":"random-dark","minSize":0,"weightFactor":15,"backgroundColor":"white","gridSize":0,"minRotation":-0.785398163397448,"maxRotation":0.785398163397448,"shuffle":true,"rotateRatio":0.4,"shape":"circle","ellipticity":0.65,"figBase64":null,"hover":null},"evals":[],"jsHooks":{"render":[{"code":"function(el,x){\n                        console.log(123);\n                        if(!iii){\n                          window.location.reload();\n                          iii = False;\n\n                        }\n  }","data":null}]}}</script>
