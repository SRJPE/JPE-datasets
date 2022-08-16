# Standard Format Dataset Overview

Within the standard format dataset directory we combine preliminary QCd datasets from all streams in the SR JPE into "standard" format datasets. We update encodings and column types to match across streams. We join the data, reformat the data, and conduct additional QC and exploratory analysis of the combined data in Rmd documents located within this directory. Markdown documents containing original QC can be found in `data-raw/QC-markdowns`.

This directory contains the following Rmd documents:

-   `rst_catch_standard_format.Rmd` contains the code used to generate `standard_catch.csv`
-   `rst_trap_standard_format.Rmd` contains the code used to generate `standard_trap.csv`
-   `standardize_mark_recapture.Rmd` contains the code used to generate `standard_recaptures.csv` & `standard_release.csv`
-   `flow_data_prep.Rmd` contains the code used to generate `standard_flow.csv`
-   `standard_adult_upstream_passage.Rmd` contains the code used to generate `standard_adult_upstream_passage.csv`
-   In Progress: adult holding, redd, carcass

## RST Datasets:

Historical RST data was acquired from spring run tributaries for use in the SR JPE. FlowWest performed QC and data processing to combine datasets into a standard usable format. We collected data from the 8 streams that have historical or ongoing RST monitoring programs:

-   battle creek (B)

-   butte creek (Bu)

-   clear creek (C)

-   deer creek (D)

-   feather river (F)

-   mill creek (M)

-   yuba river (Y)

-   Sacramento river.

Datasets for 2 sites on the Sacramento river, Tisdale and knights landing, are managed separately so Tisdale (T) and knights landing (KL) are marked separately in the "Variable Collected By" columns in the data dictionaries below. For all other streams, data has historically been managed by one monitoring program per stream and the variables collected are consistent throughout the sites on that stream.

### Joins:

To combine datasets together use the following joins:

Standard catch can be joined to standard trap on date, stream, and site

```{r}
catch_and_trap <- dplyr::full_join(standard_catch, 
                                   standard_trap, 
                                   by = c("date" = "trap_stop_date", 
                                          "site" = "site", 
                                          "stream" = "stream"))
```

Standard catch can be joined to standard flow or standard temp by date, stream, site

```{r}
catch_and_flow <- dplyr::left_join(standard_catch, 
                                   standard_flow, 
                                   by = c("date" = "date",
                                          "site" = "site", 
                                          "stream" = "stream"))
```

Standard releases and standard recaptures can be joined together on stream and release id

```{r}
releases_and_recaptures <- dplyr::left_join(standard_release, 
                                            standard_recaptures, 
                            by = c("release_id" = "release_id", 
                                   "stream" = "stream"))
```

### Unknown or NA value handling:

Throughout the RST datasets we use NA, not recorded and unknown values to describe areas where data there are data gaps. These all have a unique meaning:

-   **NA** means that the variable does not apply (ex run designation if catch is 0)

-   **not recorded** means that the information is not collected

-   **unknown** means that information is collected but there is uncertainty in the field so no designation is made

### **Data dictionaries**

#### *Standard Catch*

The following table describes all of the variables contained within the standard catch dataset. All data was shared by stream teams and compiled into a standard format by FlowWest. Any date that a trap was operating will be included in the catch dataset even if no salmon were caught. This dataset is the most complete catch dataset that we have access to. We will continue outreach and communication with stream teams to ensure we have all the data. This dataset can be joined to trap operations, flow,  temperature, releases, or recaptures data by date, stream and site.

| **Variable Name** | **Variable Collected By** | **Description**                                                                                                    | **Encoding**                                                                                                                                                                                                 |
|---------------|---------------|---------------|----------------------------|
| date              | All                       | Date trap checked                                                                                                  | \-                                                                                                                                                                                                           |
| run               | B, Bu, C, F, KL, T, Y     | Designated run of fish using method in run_method. Some locations did not designated a run. NA when count is 0.    | late fall, spring, fall, winter, not recorded, unknown, NA                                                                                                                                                   |
| fork_length       | All                       | Fork length of fish in millimeters.                                                                                | \-                                                                                                                                                                                                           |
| lifestage         | B, Bu, C, F, KL, T, Y     | Life stage of fish. NA when fish count is 0.                                                                       | smolt, fry, yolk sac fry, not recorded, parr, silvery parr, adult, unknown, yearling, NA                                                                                                                     |
| dead              | B, Bu, C, T               | Describes if fish were dead when observed                                                                          | TRUE/FALSE                                                                                                                                                                                                   |
| interpolated      | B, C                      | Describes if data were interpolated                                                                                | TRUE/FALSE                                                                                                                                                                                                   |
| count             | All                       | Number of fish caught.                                                                                             | \-                                                                                                                                                                                                           |
| stream            | All                       | Mainstem/tributary location of trap.                                                                               | battle creek, butte creek, clear creek, deer creek, feather river, mill creek, yuba river, sacramento river                                                                                                  |
| site              | All                       | Site of trap within location. Some locations do not have multiple sites in a stream In these cases stream = site.  | ubc, okie dam, adams dam, lcc, ucc, deer creek, eye riffle, live oak, herringer riffle, steep riffle, sunset pumps, shawns beach, gateway riffle, mill creek, yuba river, hallwood, knights landing, tisdale |
| adipose_clipped   |                           | Describes if adipose fin is clipped                                                                                | TRUE/FALSE                                                                                                                                                                                                   |
| run_method        | Bu                        | Method used to designate run.                                                                                      | NA if count is 0. not recorded, length-at-date criteria, appearance, hatchery attribute                                                                                                                      |
| weight            | Bu, D, Y, KL, T           | Weight in grams.                                                                                                   | \-                                                                                                                                                                                                           |
| species           | All                       | Species of fish. All were filtered to chinook.                                                                     | Chinook salmon                                                                                                                                                                                               |

#### Standard Trap (Trap Operations Dataset)

The following table describes all of the variables contained within the standard trap operations dataset. This data was shared by stream teams and compiled into a standard format. Trap operations data should be collected at every trap visit for each RST sampling. There should be a row for each subsite contained within this dataset.

<table>
<thead>
<tr class="header">
<th><p><strong>Variable Name</strong></p></th>
<th><p><strong>Variable Collected By</strong></p></th>
<th><p><strong>Description</strong></p></th>
<th><p><strong>Encoding</strong></p></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>trap_visit_id</p></td>
<td><p>B, C</p></td>
<td><p>Key for linking trap operations to catch data. Currently, not all locations use this key.</p></td>
<td><p>-</p></td>
</tr>
<tr class="even">
<td><p>trap_start_date</p></td>
<td><p>B, C, KL</p></td>
<td><p>Date when trap was started or restarted. The start date is typically the end date from the previous day.</p></td>
<td><p>-</p></td>
</tr>
<tr class="odd">
<td><p>trap_start_time</p></td>
<td><p>B, C,  KL</p></td>
<td><p>Time when trap was started or restarted. The start time is typically the end time from the previous day.</p></td>
<td><p>-</p></td>
</tr>
<tr class="even">
<td><p>trap_stop_date</p></td>
<td><p>B, Bu, C, D, M, F, KL, Y  </p></td>
<td><p>Date when trap was checked and catch counted.</p></td>
<td><p>-</p></td>
</tr>
<tr class="odd">
<td><p>trap_stop_time</p></td>
<td><p>B, Bu, C, F, KL, Y </p></td>
<td><p>Time when trap was checked and catch counted.</p></td>
<td><p>-</p></td>
</tr>
<tr class="even">
<td><p>sample_period_revolutions</p></td>
<td><p>B, Bu, C, KL, Y</p></td>
<td><p>Number of cone revolutions during sampling period.</p></td>
<td><p>-</p></td>
</tr>
<tr class="odd">
<td><p>is_half_cone_configuration</p></td>
<td><p>B, C</p></td>
<td><p>Describes if cone was at full or half cone.</p></td>
<td><p>TRUE/FALSE</p></td>
</tr>
<tr class="even">
<td><p>river_left_depth</p></td>
<td><p>B, C</p></td>
<td><p>River depth from inside of the river left (units = meters)</p></td>
<td><p>-</p></td>
</tr>
<tr class="odd">
<td><p>river_center_depth</p></td>
<td><p>B, C</p></td>
<td><p>River depth from directly in the center of cone (units = meters)</p></td>
<td><p>-</p></td>
</tr>
<tr class="even">
<td><p>river_right_depth</p></td>
<td><p>B, C</p></td>
<td><p>River depth from inside of the river right (units = meters)</p></td>
<td><p>-</p></td>
</tr>
<tr class="odd">
<td><p>thalweg</p></td>
<td><p>B, C</p></td>
<td><p>Was trap fishing in the thalweg</p></td>
<td><p>TRUE/FALSE</p></td>
</tr>
<tr class="even">
<td><p>depth_adjust</p></td>
<td><p>B, C</p></td>
<td><p>The depth of the bottom of the cone (units = centimeters)</p></td>
<td><p>-</p></td>
</tr>
<tr class="odd">
<td><p>avg_time_per_rev</p></td>
<td><p>B, C, D, M</p></td>
<td><p>Cone rate measurement - average time for one revolution (units = seconds).</p></td>
<td><p>-</p></td>
</tr>
<tr class="even">
<td><p>fish_properly</p></td>
<td><p>B, C</p></td>
<td><p>Was there a problem with the trap</p></td>
<td><p>TRUE/FALSE</p></td>
</tr>
<tr class="odd">
<td><p>comments</p></td>
<td><p>B, C Y,  Kl</p></td>
<td><p>Qualitative comments about sampling event.</p></td>
<td><p>-</p></td>
</tr>
<tr class="even">
<td><p>gear_condition</p></td>
<td><p>B, C, D, F M</p></td>
<td><p>A code for the condition of the trap</p></td>
<td><p>trap not in service, trap stopped functioning, trap functioning but not normally, trap functioning normally</p></td>
</tr>
<tr class="odd">
<td><p>stream</p></td>
<td><p>All </p></td>
<td><p>Location of monitoring program (e.g. stream or river)</p></td>
<td><p>battle creek, butte creek, clear creek, deer creek, feather river, mill creek, yuba river, sacramento river</p></td>
</tr>
<tr class="even">
<td><p>site</p></td>
<td><p>All </p></td>
<td><p>Site within the location</p></td>
<td><p>ubc, okie dam, adams dam, lcc, ucc, deer creek, eye riffle, live oak, herringer riffle, steep riffle, sunset pumps, shawns beach, gateway riffle, mill creek, yuba river, hallwood, knights landing, tisdale</p></td>
</tr>
<tr class="odd">
<td><p>subsite</p></td>
<td><p>All</p></td>
<td><p>Subsite or specific trap location within each site and location. Names are specific to location.</p></td>
<td><p><br />
</p></td>
</tr>
<tr class="even">
<td><p>debris_volume</p></td>
<td><p>B, C</p></td>
<td><p>Volume of debris measured in trap (gallons).</p></td>
<td><p>-</p></td>
</tr>
<tr class="odd">
<td><p>trap_status</p></td>
<td><p>Bu, F, Y</p></td>
<td><p>Status of trap during visit</p></td>
<td><p>drive by, end trapping, start trapping, continue trapping, unplanned restart, service trap</p></td>
</tr>
<tr class="even">
<td><p>rpms_start</p></td>
<td><p>Bu</p></td>
<td><p>Cone rate measurement - revolutions per mintue at the start of trap visit</p></td>
<td><p>-</p></td>
</tr>
<tr class="odd">
<td><p>rpms_end</p></td>
<td><p>Bu</p></td>
<td><p>Cone rate measurement - revolutions per minute at the end of the trap visit</p></td>
<td><p>-</p></td>
</tr>
<tr class="even">
<td><p>fish_processed</p></td>
<td><p>F</p></td>
<td><p>Description of whether fish were processed.</p></td>
<td><p>processed fish, no fish caught, no catch data fish released, no catch data fish left in live box</p></td>
</tr>
<tr class="odd">
<td><p>method</p></td>
<td><p>Y</p></td>
<td><p>Method of sampling.</p></td>
<td><p>Categories: fish screen diversion trap, rotary screw trap fish screen diversion trap, rotary screw trap</p></td>
</tr>
<tr class="even">
<td><p>debris_level</p></td>
<td><p>Y</p></td>
<td><p>Categorical level of debris in trap (visual assessment).</p></td>
<td><p>light, medium, heavy, very heavy</p></td>
</tr>
<tr class="odd">
<td><p>cone_rpm</p></td>
<td><p>KL</p></td>
<td><p>Cone rate measurement - revolutions per minute</p></td>
<td><p>-</p></td>
</tr>
</tbody>
</table>

#### Release

The following release table provides details on all the marked fish used in release trials. Median fork length is given instead of mean fork length because Battle and Clear creek only provided aggregated data giving median fork length for each efficiency trial. This table can be joined to standard recapture using the release ID and stream. All fish in this table are chinook salmon. The only streams that we have historical mark recapture data for are Battle, Clear, Feather, and Knights Landing.

| **Variable Name**           | **Variable Collected By** | **Description**                                                                                                                                                       |
|---------------|---------------|------------------------------------------|
| stream                      | B, C, F, KL               | stream that the data is from                                                                                                                                          |
| release_id                  | B, C, F, KL               | the unique identifier for each release trial                                                                                                                          |
| date_released               | B, C, F, KL               | date that marked fish are released                                                                                                                                    |
| time_released               | B, C, F, KL               | time that marked fish are released                                                                                                                                    |
| site                        | F, KL                     | site on stream where fish are released                                                                                                                                |
| number_released             | B, C, F, KL               | count of fish released                                                                                                                                                |
| median_fork_length_released | B, C, KL                  | median fork length of group of fish released                                                                                                                          |
| night_release               | B, C, F, KL               | TRUE if the release is at night                                                                                                                                       |
| days_held_post_mark         | B, C                      | number of days marked fish are held before released                                                                                                                   |
| flow_at_release             | B, C                      | flow measure at time and stream of release (cubic feet per second)                                                                                                    |
| temperature_at_release      | B, C                      | temperature measure at time and stream of release (degrees Celsius)                                                                                                   |
| turbidity_at_release        | B, C                      | turbidity measure at time and stream of release (NTU)                                                                                                                 |
| origin                      | B, F, KL                  | fish origin (natural, hatchery, mixed, unknown, not recorded, or NA). Origin comes directly from \# of fish acquired from a hatchery and not from adipose fin status. |

#### Recapture

The following recapture table provides details on all the recaptured fish used in release trials. Median fork length is given instread of mean fork length because Battle and Clear creek only provided aggregated data giving median fork length for each efficiency trial. This table can be joined to standard release using the release ID and stream. All fish in this table are chinook salmon. The only streams that we have historical mark-recapture data for are Battle, Clear, Feather, and Knights Landing. 

| **Variable Name**             | **Variable Collected By** | **Description**                                              |
|------------------|------------------|-----------------------------------|
| stream                        | B, C, F, KL               | stream that the data is from                                 |
| release_id                    | B, C, F, KL               | the unique identifier for each release trial                 |
| date_recaptured               | B, C, F, KL               | date that fish were recaptured                               |
| number_recaptured             | B, C, F, KL               | count of fish recaptured in RST on a specific recapture date |
| median_fork_length_recaptured | B, C, F, KL               | median fork length of group of fish recaptured               |
| cone_status                   | B, C                      | if RST cone is fishing half or full                          |

#### Flow

Flow data was pulled from CDEC and USGS gages. 

| **Variable Name** | **Description**                                  |
|-------------------|--------------------------------------------------|
| date              | date of flow measurement                         |
| flow_cfs          | mean daily flow in cubic feet per second (cfs)   |
| site              | site associated with flow measurement            |
| stream            | stream location associated with flow measurement |
| source            | source of flow data                              |

## Adult Upstream Passage:

Historical Weir data was acquired from spring run tributaries for use in the SR JPE. FlowWest performed QC and data processing to combine datasets into a standard usable format. We collected data from the 5 streams that have historical or ongoing weir monitoring programs:

-   battle creek (B)

-   clear creek (C)

-   deer creek (D)

-   mill creek (M)

-   yuba river (Y)

### Data Dictionary:

#### Standard Upstream Passage Data

The following weir passage dataset contains data describing fish migrating upstream through the video weir. Weir footage should capture 100% of the upstream migration period but there can be outages in equipment or limitations in viewing footage that cause data gaps. Yuba is the only stream that provides an hours viewed by day to describe the % of time that we have data for.

| column name        | tributary collects | definition                                                                                             |
|:--------------|:--------------|:-----------------------------------------|
| stream             | **B, C, D, M, Y**  | which Spring Run JPE stream is the data from                                                           |
| date               | **B, C, D, M, Y**  | date of video footage                                                                                  |
| time               | **B, C, Y**        | time of video footage                                                                                  |
| count              | **B, C, D, M, Y**  | number of fish observed                                                                                |
| adipose_clipped    | **B, C, Y**        | if adipose fin is clipped (TRUE/FALSE)                                                                 |
| run                | **B, C, D, M**     | run designation                                                                                        |
| passage_direction  | **B, C, Y**        | direction of fish passage                                                                              |
| sex                | **C**              | sex of fish observed                                                                                   |
| viewing_condition  | **C**              | direction of fish observed (normal, readable, not readable, weir is flooded)                           |
| spawning_condition | **C**              | description of spawning status based on coloration (none, energetic, spawning colors, fungus, unknown) |
| jack_size          | **C**              | If the fish is jack sized or not                                                                       |
| ladder             | **Y**              | describes which ladder the fish was seen traveling up                                                  |
| hours              | **Y**              | number of hours viewed by day                                                                          |
| flow               | **D, M**           | flow in cubic feet per seccond at the weir                                                             |
| temperature        | **D, M**           | temperature in Celsius at the weir                                                                     |

## Adult Holding:

In Progress

## Adult Redd:

In Progress

## Adult Carcass:

In Progress
