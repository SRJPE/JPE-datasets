# Standard Format Dataset Overview

Within the standard format dataset directory FlowWest combines datasets from all SR JPE streams into "standard" format datasets for all monitoring types:

| **Juvenile**                                                                                                                                     | Adult                                                                                                                                                |
|--------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| [RST catch](https://github.com/FlowWest/JPE-datasets/blob/main/data-raw/standard-format-data-prep/rst_catch_standard_format.Rmd)                 | [Upstream passage](https://github.com/FlowWest/JPE-datasets/blob/main/data-raw/standard-format-data-prep/adult_upstream_passage_standard_format.Rmd) |
| [RST trap operations](https://github.com/FlowWest/JPE-datasets/blob/main/data-raw/standard-format-data-prep/rst_trap_standard_format.Rmd)        | [Holding](https://github.com/FlowWest/JPE-datasets/blob/main/data-raw/standard-format-data-prep/holding_standard_format.Rmd)                         |
| [RST efficiency trial](https://github.com/FlowWest/JPE-datasets/blob/main/data-raw/standard-format-data-prep/mark_recapture_standard_format.Rmd) | Redd (in progress)                                                                                                                                   |
| [Flow at RST sites](https://github.com/FlowWest/JPE-datasets/blob/main/data-raw/standard-format-data-prep/flow_standard_format.Rmd)              | Carcass (in progress)                                                                                                                                |

FlowWest standardized encodings and column types to enable joining of datasets across streams. The code for these transformations along with additional QC and exploratory analysis of the combined data is in Rmd documents located within this directory. Markdown documents containing original QC or raw datasets for individual streams can be found in [`data-raw/QC-markdowns`](https://github.com/FlowWest/JPE-datasets/tree/documentation/data-raw/qc-markdowns).

This directory contains the following Rmd documents:

-   [`rst_catch_standard_format.Rmd`](https://github.com/FlowWest/JPE-datasets/blob/documentation/data-raw/standard-format-data-prep/rst_catch_standard_format.Rmd) contains the code used to generate `standard_catch.csv`
-   [`rst_trap_standard_format.Rmd`](https://github.com/FlowWest/JPE-datasets/blob/documentation/data-raw/standard-format-data-prep/rst_trap_standard_format.Rmd) contains the code used to generate `standard_trap.csv`
-   [`rst_effort_standard_format.Rmd`](https://github.com/FlowWest/JPE-datasets/blob/documentation/data-raw/standard-format-data-prep/rst_effort_standard_format.Rmd) contains the code used to calculate the number of hours fished based on date and times available in the RST data and generate `standard_effort.csv`
-   [`mark_recapture_standard_format.Rmd`](https://github.com/FlowWest/JPE-datasets/blob/documentation/data-raw/standard-format-data-prep/mark_recapture_standard_format.Rmd) contains the code used to generate `standard_recaptures.csv` & `standard_release.csv`
-   [`rst_environmental_standard_format.Rmd`](https://github.com/FlowWest/JPE-datasets/blob/documentation/data-raw/standard-format-data-prep/rst_environmental_standard_format.Rmd) contains the code used to generate `standard_environmental.csv` which contains environmental covariate measurements taken during trap visits.
-   [`flow_standard_format.Rmd`](https://github.com/FlowWest/JPE-datasets/blob/documentation/data-raw/standard-format-data-prep/flow_standard_format.Rmd) contains the code used to generate `standard_flow.csv` which compiles flow data from publically available streamgages.
-   [`adult_upstream_passage_standard_format.Rmd`](https://github.com/FlowWest/JPE-datasets/blob/documentation/data-raw/standard-format-data-prep/adult_upstream_passage_standard_format.Rmd) contains the code used to generate `standard_adult_upstream_passage.csv`
-   [`holding_standard_format.Rmd`] (https://github.com/FlowWest/JPE-datasets/blob/documentation/data-raw/standard-format-data-prep/holding_standard_format.Rmd) contains the code used to generate `standard_holding.csv`
-   In Progress: adult redd, carcass, temperature

Data descriptions are included within each Rmd. Each standard dataset is described in more detail below.

## RST Datasets

Historical RST data was acquired from spring run tributaries for use in the SR JPE. FlowWest performed QC and data processing to combine datasets into a standard usable format. We collected data from the 8 streams that have historical or ongoing RST monitoring programs:

-   battle creek (B)

-   butte creek (Bu)

-   clear creek (C)

-   deer creek (D)

-   feather river (F)

-   mill creek (M)

-   yuba river (Y)

-   sacramento river (T and KL)

Datasets for 2 sites on the Sacramento River, Tisdale and Knights Landing, are managed separately so Tisdale (T) and Knights Landing (KL) are marked separately in the "Variable Collected By" columns in the data dictionaries below. For all other streams, data has historically been managed by one monitoring program per stream and the variables collected are consistent throughout the sites on that stream.

### Description of RST Sites

RST sites are described in a hierarchical structure: stream, site, and subsite. The stream describes the river or creek that the RST site is located. In some cases, data from sites on the same stream may be managed separately (e.g., Knights Landing and Tisdale on the Sacramento River; Upper Feather River and Lower Feather River). The site represents a monitoring location with one or more traps. If there are multiple traps at one site the traps are either: (a) being run simultaneously (e.g. 8.3 and 8.4 at Knights Landing) and can be summed together to represent daily catch; or (b) there are multiple trap locations that are rotated through time depending on conditions, but all trap locations represent the same site location (e.g. subsites on Upper Feather River).

| stream | site | subsite | description |
|--------|------|---------|-------------|
| battle creek | ubc | ubc | there is only one site at battle creek and one trap at ubc |
| butte creek | adams dam, okie dam | adams dam, okie dam 1, okie dam 2 | there are two sites at butte creek; one trap at adams dam; 2 traps at okie dam. Note that in some cases a diversion fyke is used at this location. |
| clear creek | lcc, ucc | lcc, ucc | there are two sites at clear creek and one trap at each site |
| deer creek | deer creek | deer creek | there is one site and one trap at deer creek |
| feather river | upper feather lfc, upper feather hfc, lower feather | eye riffle_north, eye riffle_side channel, gateway main 400' up river, gateway_main1, gateway_rootball, gateway_rootball_river_left, #steep riffle_rst, steep riffle_10' ext, steep side channel, herringer_east, herringer_upper_west, herringer_west, live oak, shawns_east, shawns_west, sunset east bank, sunset west bank, rr, rl | there are three sites on the feather river; there are 9 traps at the upper feather lfc; there are 8 traps at the upper feather hfc; there are 2 traps at the lower feather |
| mill creek | mill creek | mill creek | there is one site and one trap at mill creek |
| sacramento river | tisdale, knights landing | rr, rl, 8.3, 8.4 | there are two sites on the sacramento river and two traps at each site |
| yuba river | hallwood, yuba river | hal, hal2, hal3, yub | there are two sites on the yuba river; there are three traps at hallwood; there is one trap at the yuba river site |

### Entity Relationship Diagram:

Below is an entity relationship diagram (ERD) of the standard format RST datasets. This diagram describes how the standard RST datasets relate to each other. Arrows indicate if the relationships are one to one (one record in one table corresponds to one record in another table) or one to many (one record in one table can correspond to many records in another table).

-   Standard flow and standard catch can be joined on date, stream, and site (see \[Joining catch and flow\]).

-   Standard trap and standard catch can be joined on date/trap_stop_date, stream, and site (see \[Joining catch and trap operations\]).

-   Standard release and standard recapture can be joined by stream and release_id (see \[Joining releases and recaptures\]).

Standard release and standard recaptures can also be joined to the standard catch, standard trap, or standard flow though standard catch should first be summarized by week (see weekly summary section below).

![](images/ERD%20standard%20format%20datasets%20-%20Page%203%20(1)-01.png)

### Joins:

To combine datasets together use left joins on the columns listed within the `by` argument. A left join keeps all of table A and the parts of table B that intersect with table A (visualized in the diagram below).

<img src="https://upload.wikimedia.org/wikipedia/commons/f/f2/Left_JOIN.png" width="410"/>

#### **Joining catch and trap operations**

Standard catch can be joined to standard trap on date, stream, and site. Note that there are a few cases where catch data is interpolated and there is no trap data associated with those dates (e.g. Battle Creek and Clear Creek).

```{r}
catch_and_trap <- dplyr::left_join(standard_catch, 
                                   standard_trap, 
                                   by = c("date" = "trap_stop_date", 
                                          "site" = "site", 
                                          "stream" = "stream"))
```

#### **Joining catch and flow**

Standard catch can be joined to standard flow or standard temp (dataset in progress) by date, stream, site.

```{r}
catch_and_flow <- dplyr::left_join(standard_catch, 
                                   standard_flow, 
                                   by = c("date" = "date",
                                          "site" = "site", 
                                          "stream" = "stream"))
```

#### **Joining releases and recaptures**

Standard releases and standard recaptures can be joined together on stream and release id

```{r}
releases_and_recaptures <- dplyr::left_join(standard_release, 
                                            standard_recaptures, 
                            by = c("release_id" = "release_id", 
                                   "stream" = "stream"))
```

### Weekly Summary

The code below is an example of how standard datasets can be summarized by week and joined.

Load required packages:

```{r}
library(dplyr)
library(lubridate)
```

Summarize the standard catch dataset to find weekly catch by year, stream, site, run, and adipose clip. Water year or run year can also be used instead of year for analyses:

```{r}
catch_week <- standard_catch %>% 
  # create week and water year 
  mutate(week = week(date),
         year = year(date)) %>% 
  # calculate weekly counts
  group_by(week, year, stream, site, adipose_clipped, run) %>% 
  summarize(count = sum(count))
```

Summarize the standard release and standard recaptures to find the weekly number of releases and recaptures by year, stream, and site:

```{r}
release_recapture_week <- standard_release %>% 
  left_join(standard_recaptures %>% 
              group_by(stream, release_id) %>% 
              summarize(number_recaptured = sum(number_recaptured)),
               by = c("stream", "release_id")) %>% 
  # create week and water year 
  mutate(week = week(release_date),
         year = year(release_date)) %>% 
  # calculate weekly number released and recaptured
  group_by(stream, site, week, year) %>% 
  summarize(number_released = sum(number_released),
            number_recaptured = sum(number_recaptured))
```

Join the weekly catch summary with the weekly release and recaptures summary:

```{r}
weekly_summary <- left_join(catch_week, release_recapture_week,
                            by = c("week",
                                   "year",
                                   "stream",
                                   "site"))
```

### Unknown or NA value handling:

Throughout the RST datasets NA, not recorded and unknown values are used to describe areas where there are data gaps. These all have a unique meaning:

-   **NA** means that the variable does not apply (e.g. run designation is NA if catch is 0)

-   **not recorded** means that the information is not collected (e.g. some streams do not collect lifestage)

-   **unknown** means that information is collected but there is uncertainty in the field so no designation is made (e.g. in some cases run may be recorded as unknown if a determination cannot be made)

### **Data dictionaries**

#### *Standard Catch*

The following table describes all the variables contained within the standard catch dataset. All data was shared by stream teams and compiled into a standard format by FlowWest. Any date that a trap was operating will be included in the catch dataset even if no salmon were caught. This dataset is the most complete catch dataset that we have access to. We will continue outreach and communication with stream teams to ensure we have all the data collected to-date.

This dataset can be joined to trap operations, flow, temperature, releases, or recaptures data by date, stream and site.

| **Variable Name** | **Variable Collected By** | **Description**                                                                            | **Encoding**                                                                                                                                                                                                 |
|-------------------|---------------------------|--------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| date              | All                       | Date trap checked                                                                          | \-                                                                                                                                                                                                           |
| run               | B, Bu, C, F, KL, T, Y     | Designated run of fish using method in run_method. Some locations did not designate a run. | late fall, spring, fall, winter, not recorded, unknown, NA                                                                                                                                                   |
| fork_length       | All                       | Fork length of fish in millimeters.                                                        | \-                                                                                                                                                                                                           |
| lifestage         | B, Bu, C, F, KL, T, Y     | Life stage of fish.                                                                        | smolt, fry, yolk sac fry, not recorded, parr, silvery parr, adult, unknown, yearling, NA                                                                                                                     |
| dead              | B, Bu, C, T               | Describes if fish were dead when observed                                                  | TRUE/FALSE                                                                                                                                                                                                   |
| interpolated      | B, C                      | Describes if data were interpolated                                                        | TRUE/FALSE                                                                                                                                                                                                   |
| count             | All                       | Number of fish caught in trap                                                              | \-                                                                                                                                                                                                           |
| stream            | All                       | Mainstem/tributary location of trap                                                        | battle creek, butte creek, clear creek, deer creek, feather river, mill creek, yuba river, sacramento river                                                                                                  |
| site              | All                       | Site of trap within stream location.                                                       | ubc, okie dam, adams dam, lcc, ucc, deer creek, eye riffle, live oak, herringer riffle, steep riffle, sunset pumps, shawns beach, gateway riffle, mill creek, yuba river, hallwood, knights landing, tisdale |
| adipose_clipped   |                           | Describes if adipose fin is clipped                                                        | TRUE/FALSE                                                                                                                                                                                                   |
| run_method        | Bu                        | Method used to designate run                                                               | NA if count is 0. not recorded, length-at-date criteria, appearance, hatchery attribute                                                                                                                      |
| weight            | Bu, D, Y, KL, T           | Weight in grams                                                                            | \-                                                                                                                                                                                                           |
| species           | All                       | Species of fish. All were filtered to chinook salmon                                       | chinook salmon                                                                                                                                                                                               |

#### *Standard Trap*

The following table describes all of the variables contained within the standard trap operations dataset. This data was shared by stream teams and compiled into a standard format. Trap operations data should be collected at every trap visit for each RST sampling. In some cases, there are multiple traps at one site. Traps at a given site are referred to as subsites. There should be a row for each subsite contained within this dataset.

| **Variable Name** | **Variable Collected By** | **Description** | **Encoding** |
|-------------------|---------------------------|-----------------|--------------|
| trap_visit_id      | B, C, F, KL, T | This primary key is used to link with the catch table. Monitoring programs using CAMP have trap_visit_id as well as Battle and Clear. | |
| stream      | B, Bu, C, D, F, M, KL, T, Y | Which stream the RST is located on | battle creek, butte creek, clear creek, deer creek, feather river, mill creek, sacramento river, yuba river |
| site          | B, Bu, C, D, F, M, KL, T, Y | The site represents a monitoring location with one or more traps. | See site description |
| subsite       | B, Bu, C, F, Y, KL, T          | Trap name. If there are multiple traps at one site the traps are either: (a) being run simultaneously (e.g. 8.3 and 8.4 at Knights Landing) and can be summed together to represent daily catch; or (b) there are multiple trap locations that are rotated through time depending on conditions, but all trap locations represent the same site location (e.g. subsites on Upper Feather River). | See site description                               |
| trap_visit_date          | B, Bu, C, D, F, M, KL, T, Y | Date that trap was visited. This field is included because in some cases a visit will not have a start/stop time (e.g. if trap was cleaned/serviced or just checked)                             | |
| trap_visit_time     | B, Bu, C, D, F, M, KL, T, Y           | Time that trap was visited. | |
| trap_start_date          | B, Bu, C, D, F, M, KL, T, Y               | Date that trap was started prior to being sampled. trap_start_date and trap_stop_date are meant to describe the sampling period.                                             | |
| trap_start_time  | B, Bu, C, D, F, M, KL, T, Y      | Time that trap was started prior to being sampled.                  | |
| trap_stop_date | B, C, F, KL, T, Y | Date that trap was sampled. trap_start_date and trap_stop_date are meant to describe the sampling period. If fish were not processed there will not be a trap_stop_date. | |
| trap_stop_time | B, C, F, KL, T, Y | Time that trap was sampled. | |
| visit_type | Bu, F, KL, T, Y | Describes the trap visit type. | start trapping, continue trapping, unplanned restart, end trapping, service trap, drive by. If visit_type is not used, "not recorded" is entered. |
| trap_functioning | B, C, D, F, M, KL, T | Describes how well trap is functioning. | trap functioning normally, trap stopped functioning, trap not in service, trap functioning but not normally. If trap_functioning not used, "not recorded" is entered. |
| fish_processed | F, KL, T | Describes if fish were processed.  | processed fish; no fish caught; no catch data, fish released; no catch data, fish left in live box. If fish_processed not used, "not recorded" is entered. |
| gear_type | Bu, Y | Describes the type of gear used. For most locations, a rotary screw trap is used 100% of the time. For Butte and Yuba, a diversion trap may be used some of the time. This field can be used to find sample periods when a diversion trap is being used. For clarity, "rotary screw trap" was filled in for all other locations. | rotary screw trap, rotary screw trap 1, rotary screw trap 2, diversion fyke trap 1, fish screen diversion trap |
| in_thalweg | B, C, F, KL, T | Boolean to describe if trap fished in thalweg. If not recorded, then assumed to be TRUE. | T/F |
| partial_sample | B, C, KL | Boolean to describe if partial sample (e.g. half of traps fished or half of sampling period. If not recorded, then assumed to be FALSE. | T/F |
| is_half_cone_configuration | B, C, F, KL, T | Boolean to describe if trap fished in half cone configuration. If not recorded, then assumed to be FALSE. | T/F |
| depth_adjust | B, C | Depth of the bottom of the cone of trap (centimeter). If not recorded, then NA. | T/F ?
| debris_volume | B, C | Volume of debris emptied from trap (gallons). If not recorded, then NA. | |
| debris_level | F, KL, T, Y | Describes the level of debris emptied from trap.  |  none, light, medium, heavy, very heavy. If not used, "not recorded" is entered. |
| rpms_start | B, Bu, C, D, F, M, KL, T, Y | Revolutions per minute at the start of the trap visit before trap is cleaned. If not recorded, then NA. |  |
| rpms_end | Bu, F, KL, T, Y | Revolutions per minute at the end of the trap visit after trap is cleaned. If not recorded, then NA. | |
| counter_start | F, KL, T | Revolutions on counter at start of trap visit. If not recorded, then NA. | |
| counter_end | F, KL, T | Revolution on counter at end of trap visit. If not recorded, then NA. | |
| sample_period_revolutions | B, Bu, C, KL, Y | Revolutions during sample period. If not recorded, then NA. | |
| include | F, KL, T | Boolean to describe if sample should be included in data for analysis. If false then data or visit is determined to be of poor quality by data steward and should not be included in analysis. If not recorded, then assumed to be TRUE. | T/F |
| comments | B, C, F, KL, T, Y | Qualitative comments about trap visit. | |


#### *Standard Release*

The following release table provides details on all the marked fish used in release trials. Median fork length is given instead of mean fork length because Battle Creek and Clear Creek only provided aggregated data giving median fork length for each efficiency trial. This table can be joined to standard recapture using the release ID and stream. All fish in this table are Chinook salmon. The only streams with historical mark recapture data are Battle, Clear, Feather, and Knights Landing.

| **Variable Name**           | **Variable Collected By** | **Description**                                                                                                                                                       |
|-----------------------------|---------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| stream                      | B, C, F, KL               | stream that the data is from                                                                                                                                          |
| release_id                  | B, C, F, KL               | the unique identifier for each release trial                                                                                                                          |
| date_released               | B, C, F, KL               | date that marked fish are released                                                                                                                                    |
| time_released               | B, C, F, KL               | time that marked fish are released                                                                                                                                    |
| site                        | F, KL                     | site on stream where fish are released                                                                                                                                |
| number_released             | B, C, F, KL               | count of fish released                                                                                                                                                |
| median_fork_length_released | B, C, KL                  | median fork length of group of fish released (unit = millimeters)                                                                                                     |
| night_release               | B, C, F, KL               | TRUE if the release is at night                                                                                                                                       |
| days_held_post_mark         | B, C                      | number of days marked fish are held before released                                                                                                                   |
| flow_at_release             | B, C                      | flow measure at time and location of release (unit = cubic feet per second)                                                                                           |
| temperature_at_release      | B, C                      | temperature measure at time and location of release (units = degrees Celsius)                                                                                         |
| turbidity_at_release        | B, C                      | turbidity measure at time and location of release (units = NTU)                                                                                                       |
| origin                      | B, F, KL                  | fish origin (natural, hatchery, mixed, unknown, not recorded, or NA). Origin comes directly from \# of fish acquired from a hatchery and not from adipose fin status. |

#### *Standard Recapture*

The following recapture table provides details on all the recaptured fish used in release trials. Median fork length is given instead of mean fork length because Battle Creek and Clear Creek only provided aggregated data giving median fork length for each efficiency trial. This table can be joined to standard release using the release ID and stream. All fish in this table are Chinook salmon. The only streams with historical mark recapture data are Battle, Clear, Feather, and Knights Landing.

| **Variable Name**             | **Variable Collected By** | **Description**                                                     |
|-------------------------------|---------------------------|---------------------------------------------------------------------|
| stream                        | B, C, F, KL               | stream that the data is from                                        |
| release_id                    | B, C, F, KL               | the unique identifier for each release trial                        |
| date_recaptured               | B, C, F, KL               | date that fish were recaptured                                      |
| number_recaptured             | B, C, F, KL               | count of fish recaptured in RST on a specific recapture date        |
| median_fork_length_recaptured | B, C, F, KL               | median fork length of group of fish recaptured (unit = millimeters) |
| cone_status                   | B, C                      | if RST cone is fishing half or full                                 |

#### *Standard Environmental*

The following table describes environmental variables measured during trap visits. This data was shared by stream teams and compiled into a standard format. 

| **Variable Name**   | **Variable Collected By** | **Description**  |
|:-----------------|:-------------------|:---------------------------------|
| stream      | B, Bu, C, D, F, M, KL, T, Y | Which stream the RST is located on                       |
| site          | B, Bu, C, D, F, M, KL, T, Y | site name                                                |
| subsite       | B, Bu, C, F, Y, KL, T          | subsite information name                                |
| date          | B, Bu, C, D, F, M, KL, T, Y | date that samples are taken                              |
| parameter     | B, Bu, C, D, F, M, KL, T, Y           | type of parameter being measured: velocity (ft/s), turbidity (NTU), weather (text), habitat (text), river depth left (m), river depth center (m), river depth right (m), temperature (degrees C), light penetration (secchi disk), discharge (cfs), water depth (m; measured at trap location)                     |
| text          | B, Bu, C, D, F, M, KL, T, Y               | text value for categorical parameters                                             |
| value  | B, Bu, C, D, F, M, KL, T, Y      | numeric value for numeric parameters                   |

#### *Standard Flow*

Flow data was pulled from [CDEC](https://cdec.water.ca.gov/webgis/?appid=cdecstation) and [USGS](https://maps.waterdata.usgs.gov/mapper/index.html) gages for consistency.

| **Variable Name** | **Description**                                                         |
|-------------------|-------------------------------------------------------------------------|
| date              | date of flow measurement                                                |
| flow_cfs          | mean daily flow in cubic feet per second (unit = cubic feet per second) |
| site              | site associated with flow measurement                                   |
| stream            | stream location associated with flow measurement                        |
| source            | source of flow data (CDEC or USGS)                                      |

## Adult Upstream Passage

Historical weir data was acquired from spring run tributaries for use in the SR JPE. FlowWest performed QC and data processing to combine datasets into a standard usable format. We collected data from the 5 streams that have historical or ongoing weir monitoring programs:

-   battle creek (B)

-   clear creek (C)

-   deer creek (D)

-   mill creek (M)

-   yuba river (Y)

### Data Dictionary

#### *Standard Upstream Passage Data*

The following weir passage dataset contains data describing fish migrating upstream through the video weir. Weir footage should capture 100% of the upstream migration period but there can be outages in equipment or limitations in viewing footage that cause data gaps. Yuba is the only stream that provides the number of hours viewed by day to describe the percent of time captured in data.

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

## Adult Holding

Adult holding data is available for Battle Creek, Butte Creek, Clear Creek, and Deer Creek. Currently Deer provides counts by year. Surveys for each location cover various stream reaches and extents and may be conducted once or multiple times per year.

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


## Adult Redd

In Progress

## Adult Carcass

In Progress
