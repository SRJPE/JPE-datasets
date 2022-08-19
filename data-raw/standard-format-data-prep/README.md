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
-   [`mark_recapture_standard_format.Rmd`](https://github.com/FlowWest/JPE-datasets/blob/documentation/data-raw/standard-format-data-prep/mark_recapture_standard_format.Rmd) contains the code used to generate `standard_recaptures.csv` & `standard_release.csv`
-   [`flow_standard_format.Rmd`](https://github.com/FlowWest/JPE-datasets/blob/documentation/data-raw/standard-format-data-prep/flow_standard_format.Rmd) contains the code used to generate `standard_flow.csv`
-   [`adult_upstream_passage_standard_format.Rmd`](https://github.com/FlowWest/JPE-datasets/blob/documentation/data-raw/standard-format-data-prep/adult_upstream_passage_standard_format.Rmd) contains the code used to generate `standard_adult_upstream_passage.csv`
-   In Progress: adult holding, redd, carcass

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

| **Variable Name**          | **Variable Collected By** | **Description**                                                                                          | **Encoding**                                                                                                                                                                                                                                                                                                                                                                                                                          |
|----------------------------|---------------------------|----------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| trap_visit_id              | B, C                      | Key for linking trap operations to catch data. Currently, not all locations use this key.                | \-                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| trap_start_date            | B, C, KL                  | Date when trap was started or restarted. The start date is typically the end date from the previous day. | \-                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| trap_start_time            | B, C, KL                  | Time when trap was started or restarted. The start time is typically the end time from the previous day. | \-                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| trap_stop_date             | B, Bu, C, D, M, F, KL, Y  | Date when trap was checked and catch counted.                                                            | \-                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| trap_stop_time             | B, Bu, C, F, KL, Y        | Time when trap was checked and catch counted.                                                            | \-                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| sample_period_revolutions  | B, Bu, C, KL, Y           | Number of cone revolutions during sampling period.                                                       | \-                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| is_half_cone_configuration | B, C                      | Describes if cone was at full or half cone.                                                              | TRUE/FALSE                                                                                                                                                                                                                                                                                                                                                                                                                            |
| river_left_depth           | B, C                      | River depth from inside of the river left (units = meters)                                               | \-                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| river_center_depth         | B, C                      | River depth from directly in the center of cone (units = meters)                                         | \-                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| river_right_depth          | B, C                      | River depth from inside of the river right (units = meters)                                              | \-                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| thalweg                    | B, C                      | Was trap fishing in the thalweg?                                                                         | TRUE/FALSE                                                                                                                                                                                                                                                                                                                                                                                                                            |
| depth_adjust               | B, C                      | The depth of the bottom of the cone (units = centimeters)                                                | \-                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| avg_time_per_rev           | B, C, D, M                | Cone rate measurement - average time for one revolution (units = seconds).                               | \-                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| fish_properly              | B, C                      | Was there a problem with the trap?                                                                       | TRUE/FALSE                                                                                                                                                                                                                                                                                                                                                                                                                            |
| comments                   | B, C Y, KL                | Qualitative comments about sampling event.                                                               | \-                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| gear_condition             | B, C, D, F M              | Categorical description of the condition of the trap                                                     | trap not in service, trap stopped functioning, trap functioning but not normally, trap functioning normally                                                                                                                                                                                                                                                                                                                           |
| stream                     | All                       | Location of monitoring program (e.g. stream or river)                                                    | battle creek, butte creek, clear creek, deer creek, feather river, mill creek, yuba river, sacramento river                                                                                                                                                                                                                                                                                                                           |
| site                       | All                       | Site within the location                                                                                 | ubc, okie dam, adams dam, lcc, ucc, deer creek, eye riffle, live oak, herringer riffle, steep riffle, sunset pumps, shawns beach, gateway riffle, mill creek, yuba river, hallwood, knights landing, tisdale                                                                                                                                                                                                                          |
| subsite                    | All                       | Subsite or specific trap location within each site and location. Names are specific to location.         | ubc, okie dam 1, adams dam, okie dam 2, ucc, lcc, deer creek, eye riffle morth, live oak, herringer west, herringer east, steep riffle rst, eye riffle side channel, sunset east bank, sunset west bank, shawns east, shawns west, gateway main1, herringer upper west, steep riffle 10 ext, gateway main 400 up river, gateway rootball, steep side channel, gateway rootball river left, mill creek, hal, hal2, hal3, yub, 8.3, 8.4 |
| debris_volume              | B, C                      | Volume of debris measured in trap (gallons).                                                             | \-                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| trap_status                | Bu, F, Y                  | Categorical description of status of trap during visit                                                   | drive by, end trapping, start trapping, continue trapping, unplanned restart, service trap                                                                                                                                                                                                                                                                                                                                            |
| rpms_start                 | Bu                        | Cone rate measurement - revolutions per minute at the start of trap visit                                | \-                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| rpms_end                   | Bu                        | Cone rate measurement - revolutions per minute at the end of the trap visit                              | \-                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| fish_processed             | F                         | Categorical description of whether fish were processed.                                                  | processed fish, no fish caught, no catch data fish released, no catch data fish left in live box                                                                                                                                                                                                                                                                                                                                      |
| method                     | Y                         | Method of sampling.                                                                                      | Categories: fish screen diversion trap, rotary screw trap fish screen diversion trap, rotary screw trap                                                                                                                                                                                                                                                                                                                               |
| debris_level               | Y                         | Categorical level of debris in trap (based on visual assessment).                                        | light, medium, heavy, very heavy                                                                                                                                                                                                                                                                                                                                                                                                      |
| cone_rpm                   | KL                        | Cone rate measurement - revolutions per minute                                                           | \-                                                                                                                                                                                                                                                                                                                                                                                                                                    |

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

In Progress

## Adult Redd

In Progress

## Adult Carcass

In Progress
