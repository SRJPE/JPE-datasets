# Data Preparation for JPE Model

The [prep_data_for_model.R]() script prepares data for the JPE model. These scripts
are currently working drafts and will be continued to be refined. Below we summarize the
key datasets shared for the JPE model.

## Description of data provided

### Rotary screw trap data

#### Daily catch unmarked

**daily catch unmarked** is the standard catch data table except it is
filtered to only included unmarked chinook salmon. Recaptured fish that were part
of an efficiency trial are NOT included.

| **Variable Name** | **Variable Collected By** | **Description**                                                                            | **Encoding**                                                                                                                                                                                                 |
|-------------------|---------------------------|--------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| date              | All                       | Date trap checked                                                                          | \-                                                                                                                                                                                                           |
| run               | B, Bu, C, F, KL, T, Y     | Designated run of fish using method in run_method. Some locations did not designate a run in which case run was assigned using the River Model Length At Date. | late fall, spring, fall, winter, unknown, NA                                                                                                                                                   |
| fork_length       | All                       | Fork length of fish in millimeters.                                                        | \-                                                                                                                                                                                                           |
| lifestage         | B, Bu, C, F, KL, T, Y     | Life stage of fish.                                                                        | smolt, fry, yolk sac fry, not recorded, parr, silvery parr, adult, unknown, yearling, NA                                                                                                                     |
| dead              | B, Bu, C, T               | Describes if fish were dead when observed                                                  | TRUE/FALSE                                                                                                                                                                                                   |
| interpolated      | B, C                      | Describes if data were interpolated                                                        | TRUE/FALSE                                                                                                                                                                                                   |
| count             | All                       | Number of fish caught in trap                                                              | \-                                                                                                                                                                                                           |
| stream            | All                       | Mainstem/tributary location of trap                                                        | battle creek, butte creek, clear creek, deer creek, feather river, mill creek, yuba river, sacramento river                                                                                                  |
| site              | All                       | Site of trap within stream location.                                                       | ubc, okie dam, adams dam, lcc, ucc, deer creek, lower feather river, upper feather lfc, upper feather hfc, mill creek, yuba river, hallwood, knights landing, tisdale |
| subsite       | B, Bu, C, F, Y, KL, T          | Trap name. If there are multiple traps at one site the traps are either: (a) being run simultaneously (e.g. 8.3 and 8.4 at Knights Landing) and can be summed together to represent daily catch; or (b) there are multiple trap locations that are rotated through time depending on conditions, but all trap locations represent the same site location (e.g. subsites on Upper Feather River). | See site description                               |
| adipose_clipped   |                           | Describes if adipose fin is clipped                                                        | TRUE/FALSE                                                                                                                                                                                                   |
| run_method        | Bu                        | Method used to designate run                                                               | NA if count is 0. not recorded, length-at-date criteria, appearance, hatchery attribute                                                                                                                      |
| weight            | Bu, D, Y, KL, T           | Weight in grams                                                                            | \-                                                                                                                                                                                                           |
#### Weekly catch unmarked

**weekly catch unmarked** is daily catch summarized by week/year and stream/site/subsite. If catch needs to be summarized at the site level, catch can be summed across subsites.

| **Variable Name**   | **Variable Collected By** | **Description**  | **Encoding** |
|:-----------------|:-------------------|:---------------------------------|:--------|
| week | available for all | julian week | NA |
| year | available for all | calendar year | NA |
| stream            | All                       | Mainstem/tributary location of trap                                                        | battle creek, butte creek, clear creek, deer creek, feather river, mill creek, yuba river, sacramento river                                                                                                  |
| site              | All                       | Site of trap within stream location.                                                       | ubc, okie dam, adams dam, lcc, ucc, deer creek, lower feather river, upper feather lfc, upper feather hfc, mill creek, yuba river, hallwood, knights landing, tisdale |
| subsite       | All          | Trap name. If there are multiple traps at one site the traps are either: (a) being run simultaneously (e.g. 8.3 and 8.4 at Knights Landing) and can be summed together to represent daily catch; or (b) there are multiple trap locations that are rotated through time depending on conditions, but all trap locations represent the same site location (e.g. subsites on Upper Feather River). | See site description                               |
| run               | B, Bu, C, F, KL, T, Y     | Designated run of fish using method in run_method. Some locations did not designate a run in which case run was assigned using the River Model Length At Date. | late fall, spring, fall, winter, unknown, NA                                                                                                                                                   |
| lifestage         | B, Bu, C, F, KL, T, Y     | Life stage of fish.                                                                        | smolt, fry, yolk sac fry, not recorded, parr, silvery parr, adult, unknown, yearling, NA                                                                                                                     |
| adipose_clipped   |                           | Describes if adipose fin is clipped                                                        | TRUE/FALSE                                                  | mean_fork_length       | All                       | Weekly mean fork length of fish in millimeters.                                  | NA |
| mean_weight | Bu, D, Y, KL, T | Weekly mean weight of fish in grams | NA |
| count | All | Weekly count of fish by stream, site, subsite. | NA |

#### Daily effort

**daily effort** is the hours fished per trap visit day

| **Variable Name** | **Variable Collected By** | **Description** |
|:------------------|:--------------------------|:----------------|
| stream            | All                       | stream data is from |
| site              | All                       | site of trap visit |
| subsite           | All                       | name of trap |
| date              | All                       | sample date   |
| hours_fished      | All                       | number of hours fished during sampling period |

#### Weekly effort

**weekly effort** is the hours fished summarized by week/year and stream/site/subsite

| **Variable Name** | **Variable Collected By** | **Description** |
|:------------------|:--------------------------|:----------------|
| stream            | All                       | stream data is from |
| site              | All                       | site of trap visit |
| subsite           | All                       | name of trap |
| week              | All                       | julian week |
| year              | All                       | calendar year |
| hours_fished      | All                       | weekly hours fished. there are some existing QC issues where hours may be greater than 168 |

#### Release summary

**release summary** is the standard release data table

| **Variable Name**                 | **Variable Collected By** | **Description**                                                                                                                   |
|:-------------------|:--------------|:------------------------------------|
| stream                      | B, C, F, KL, T        | stream that the data is from                                                                                                 |
| site                        | F, KL, T              | site on stream where fish are released                                                                                       |
| release_id                  | B, C, F, KL, T        | the unique identifier for each release trial                                                                                 |
| date_released               | B, C, F, KL, T        | date that marked fish are released                                                                                           |
| time_released               | B, C, F, KL        | time that marked fish are released                                                                                           |
| number_released             | B, C, F, KL, T        | count of fish released                                                                                                       |
| median_fork_length_released | B, C, KL           | median fork length of group of fish released                                                                                 |
| night_release               | B, C, T               | TRUE if the release is at night, preassigned in Battle and Clear, refer to release_time column for more complete information |
| days_held_post_mark         | B, C               | number of days marked fish are held before released                                                                          |
| flow_at_release             | B, C               | flow measure at time and stream of release                                                                                   |
| temperature_at_release      | B, C               | temperature measure at time and stream of release                                                                            |
| turbidity_at_release        | B, C               | turbidity measure at time and stream of release                                                                              |
| origin_released                      | B, F, KL, T, F           | fish origin (natural, hatchery, mixed, unknown, not recorded, or NA)                                                         |
| run_released                         | T, KL, F                   | run of fish released
        |
| site_released | T, KL, F | release site location |
| subsite_released | T, KL, F | trap or details about release site location |
| source_released | T, KL, F | source of fish used in release trial |
| lifestage_released | T, KL, F | lifestage of fish released |
| include | T, KL, F | indicates in trial should be included in analysis (indication of quality) |

#### Recapture summary

**recapture summary** is the standard recapture data table

| **Variable Name**   | **Variable Collected By** | **Description**  |
|:-------------------|:--------------|:------------------------------------|
| stream                        | B, C, F, KL, T        | stream that the data is from                                 |
| site | B, C, F, KL, T | site fish recaptured |
| subsite | B, C, F, KL, T | subsite or trap location fish recaptured |
| release_id                    | B, C, F, KL, T        | the unique identifier for each release trial                 |
| date_recaptured               | B, C, F, KL, T        | date that fish were recaptured                               |
| number_recaptured             | B, C, F, KL, T        | count of fish recaptured in RST on a specific recapture date, when NA trap is not fished |
| median_fork_length_recaptured | B, C, F, KL, T        | median fork length of group of fish recaptured               |

#### Efficiency trial summary

**efficiency trial summary** combines the number released from the release summary 
with the number recaptured from the recapture summary

| **Variable Name** | **Variable Collected By** | **Description** |
|:------------------|:--------------------------|:----------------|
| stream            | B, C, F, S                | stream that the data is from |
| site              | B, C, F, S                | site of associated with release and recapture | 
| subsite           | B, C, F, S                | subsite fish was recaptured at |
| release_id        | B, C, F, S                | unique identifier for release trial. |
| number_released   | B, C, F, S                | number of fish released as part of release trial |
| number_recaptured | B, C, F, S                | number of fish from release trial that were recaptured |

#### Daily environmental covariates

**daily environmental covariates** is the standard environmental data table

| **Variable Name**   | **Variable Collected By** | **Description**  |
|:-----------------|:-------------------|:---------------------------------|
| stream      | B, Bu, C, D, F, M, KL, T, Y | Which stream the RST is located on                       |
| site          | B, Bu, C, D, F, M, KL, T, Y | site name                                                |
| subsite       | B, Bu, C, F, Y, KL, T          | subsite information name                                |
| date          | B, Bu, C, D, F, M, KL, T, Y | date that samples are taken                              |
| parameter     | B, Bu, C, D, F, M, KL, T, Y           | type of parameter being measured: velocity (ft/s), turbidity (NTU), weather (text), habitat (text), river depth left (m), river depth center (m), river depth right (m), temperature (degrees C), light penetration (secchi disk), discharge (cfs), water depth (m; measured at trap location)                     |
| text          | B, Bu, C, D, F, M, KL, T, Y               | text value for categorical parameters                                             |
| value  | B, Bu, C, D, F, M, KL, T, Y      | numeric value for numeric parameters                   |

#### Daily trap operations

**daily trap operations** is the standard trap data table. Effort information is
calculated separately and this table is likely not needed for modeling but is 
included for completeness.

| **Variable Name** | **Variable Collected By** | **Description** |                                   
|:-----------------|:-------------------|:---------------------------------|
| trap_visit_id      | B, C, F, KL, T | This primary key is used to link with the catch table. Monitoring programs using CAMP have trap_visit_id as well as Battle and Clear.                      |
| stream      | B, Bu, C, D, F, M, KL, T, Y | Which stream the RST is located on                       |
| site          | B, Bu, C, D, F, M, KL, T, Y | Site name                                                |
| subsite       | B, Bu, C, F, Y, KL, T          | Name of trap                                |
| trap_visit_date          | B, Bu, C, D, F, M, KL, T, Y | Date that trap was visited. This field is included because in some cases a visit will not have a start/stop time (e.g. if trap was cleaned/serviced or just checked)                             |
| trap_visit_time     | B, Bu, C, D, F, M, KL, T, Y           | Time that trap was visited. |
| trap_start_date          | B, Bu, C, D, F, M, KL, T, Y               | Date that trap was started prior to being sampled. trap_start_date and trap_stop_date are meant to describe the sampling period.                                             |
| trap_start_time  | B, Bu, C, D, F, M, KL, T, Y      | Time that trap was started prior to being sampled.                  |
| trap_stop_date | | Date that trap was sampled. trap_start_date and trap_stop_date are meant to describe the sampling period. If fish were not processed there will not be a trap_stop_date. |
| trap_stop_time | | Time that trap was sampled. |
| visit_type | Bu, F, KL, T, Y | Describes the trap visit type. Categories: start trapping, continue trapping, unplanned restart, end trapping, service trap, drive by. If visit_type is not used, "not recorded" is entered. |
| trap_functioning | B, C, D, F, M, KL, T | Describes how well trap is functioning. Categories: trap functioning normally, trap stopped functioning, trap not in service, trap functioning but not normally. If trap_functioning not used, "not recorded" is entered. |
| fish_processed | F, KL, T | Describes if fish were processed. Categories: processed fish; no fish caught; no catch data, fish released; no catch data, fish left in live box. If fish_processed not used, "not recorded" is entered. |
| gear_type | Bu, Y | Describes the type of gear used. For most locations, a rotary screw trap is used 100% of the time. For Butte and Yuba, a diversion trap may be used some of the time. This field can be used to find sample periods when a diversion trap is being used. For clarity, "rotary screw trap" was filled in for all other locations. |
| in_thalweg | B, C, F, KL, T | Boolean to describe if trap fished in thalweg. If not recorded, then assumed to be TRUE. |
| partial_sample | B, C, KL | Boolean to describe if partial sample (e.g. half of traps fished or half of sampling period. If not recorded, then assumed to be FALSE. |
| is_half_cone_configuration | B, C, F, KL, T | Boolean to describe if trap fished in half cone configuration. If not recorded, then assumed to be FALSE. |
| depth_adjust | B, C | Depth of the bottom of the cone of trap (centimeter). If not recorded, then NA. |
| debris_volume | B, C | Volume of debris emptied from trap (gallons). If not recorded, then NA. |
| debris_level | F, KL, T, Y | Describes the level of debris emptied from trap. Categories: none, light, medium, heavy, very heavy. If not used, "not recorded" is entered. |
| rpms_start | B, Bu, C, D, F, M, KL, T, Y | Revolutions per minute at the start of the trap visit before trap is cleaned. If not recorded, then NA. | 
| rpms_end | Bu, F, KL, T, Y | Revolutions per minute at the end of the trap visit after trap is cleaned. If not recorded, then NA. |
| counter_start | F, KL, T | Revolutions on counter at start of trap visit. If not recorded, then NA. |
| counter_end | F, KL, T | Revolution on counter at end of trap visit. If not recorded, then NA. |
| sample_period_revolutions | B, Bu, C, KL, Y | Revolutions during sample period. If not recorded, then NA. |
| include | F, KL, T | Boolean to describe if sample should be included in data for analysis. If false then data or visit is determined to be of poor quality by data steward and should not be included in analysis. If not recorded, then assumed to be TRUE. |
| comments | B, C, F, KL, T, Y | Qualitative comments about trap visit. |

### Adult data

#### Upstream passage

**upstream passage** is the standard adult upstream passage data table

| column name        | tributary collects | definition                                                                                             |
|:-------------------|:-------------------|:-------------------------------------------------------------------------------------------------------|
| stream             | **B, C, D, M, Y**  | stream data is from                                                                                    |
| date               | **B, C, D, M, Y**  | date of video footage                                                                                  |
| time               | **B, C, Y**        | time of video footage                                                                                  |
| count              | **B, C, D, M, Y**  | number of fish observed                                                                                |
| adipose_clipped    | **B, C, Y**        | if adipose fin is clipped (TRUE/FALSE)                                                                 |
| run                | **B, C, D, M**     | run designation                                                                                        |
| passage_direction  | **B, C, Y**        | direction of fish passage                                                                              |
| sex                | **C**              | sex of fish observed                                                                                   |
| viewing_condition  | **C**              | condition of video footage (normal, readable, not readable, weir is flooded)                           |
| spawning_condition | **C**              | description of spawning status based on coloration (none, energetic, spawning colors, fungus, unknown) |
| jack_size          | **C**              | if the fish is jack sized or not (TRUE/FALSE)                                                          |
| ladder             | **Y**              | describes which ladder the fish was seen traveling up                                                  |
| hours              | **Y**              | number of hours viewed by day                                                                          |
| flow               | **D, M**           | flow at the weir (unit = cubic feet per second)                                                        |
| temperature        | **D, M**           | water temperature at the weir (unit = decrees Celsius)                                                 |

#### Holding

**holding** is the standard adult holding data table

| column name        | tributary collects | definition                                                                                             |
|:-------------------|:-------------------|:-------------------------------------------------------------------------------------------------------|
| stream             | **B, Bu, C, D**    | stream data is from                                                                                    |
| date               | **B, Bu, C**       | date of survey                                                                                  |
| year               | **B, Bu, C, D**    | year of survey (Deer only includes year)                                                                                  |
| reach              | **B, Bu, C, D**    | Reach number within stream                                                                           |
| river_mile         | **B, C**           | River mile number                                                            |
| latitude           | **B, C**           | Latitude measurement                                                                                         |
| longitude          | **B, C**           | Longitude measurement                                                                              |
| picket_weir_location_rm | **C**         | Location (river mile) of picket weir. Only applies to Clear Creek. Categories: 7.4, 8.2                                                                                  |
| picket_weir_relate | **C**              | Fish observed above or below the picket weir                        |
| survey_intent      | **C**              | Intent of survey. Categories: august index, spawning |
| count              | **B, Bu, C, D**    | Number of fish observed: Butte Creek data has multiple observations from different personnels per day - to prevent double counting, the average of each day at each reach is used as the daily fish count |
| jacks              | **B, C**           | Number of jacks observed                                                  |









