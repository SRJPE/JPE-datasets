---
title: "README"
output: html_document
date: '2022-07-07'
---

This directory contains the following data files:

- standard_catch_rst.csv (created on July 6 2022)
- standard_trap_rst.csv (added on July 24 2022)
- standard_recapture.csv (added on July 24 2022)
- standard_release.csv (added on July 24 2022)
- standard_flow.csv (added on July 24 2022)

Historical RST data was acquired from spring run tributaries for use in the
SR JPE. FlowWest performed QC and data processing to combine datasets into a 
standard usable format.

**Data dictionaries**

*Catch*

| variable_name |	description	| encoding | collected | 
| ----------- | ----------- | ----------- | ----------- |
| date | Date trap checked | NA | All
| run |	Designated run of fish using method in run_method. Some locations did not designated a run. NA when count is 0.	| late fall, spring, fall, winter, not recorded, unknown	| All but Deer, Mill
| fork_length |	Fork length of fish in mm.	| NA	| All
| lifestage	| Life stage of fish. NA when count is 0.	| smolt, fry, yolk sac fry, not recorded, parr, silvery parr, adult, unknown, yearling	| All but Deer, Mill
| dead	| Describes if fish were dead when observed (T/F).	| TRUE, FALSE	| Battle, Butte, Clear, Tisdale
| interpolated	| Describes if data were interpolated (T/F).	| TRUE, FALSE	| Battle, Clear
| count	| Number of fish caught.	| NA	| All
| stream	| Mainstem/tributary location of trap.	| battle creek, butte creek, clear creek, deer creek, feather river, mill creek, yuba river, sacramento river | 	All
| site	| Site of trap within location. Some locations do not have multiples sites in which stream = site. Site names are specific to the tributary.	| battle creek, okie dam, adams dam, lcc, ucc, deer creek, eye riffle, live oak, herringer riffle, steep riffle, sunset pumps, shawns beach, gateway riffle, mill creek, yuba river, hallwood, knights landing, tisdale	| All
| adipose_clipped	| Describes if adipose fin is clipped (T/F). | This is used to determine if the fish is natural or hatchery origin. In some cases this information may be unknown.	| TRUE, FALSE	| Butte, Feather, Knights, Tisdale
| run_method	| Method used to designate run. | NA if count is 0.	not recorded, length-at-date criteria, appearance, hatchery attribute	| Butte
| weight	| Weight in grams.	| NA	| Butte, Deer, Yuba, Knights, Tisdale
| species	| Species of fish. | All were filtered to chinook.	| chinook salmon	| Knights

*Trap*

variable_name | description |	encoding | collected
| ----------- | ----------- | ----------- | ----------- |
trap_visit_id |	Key variable that links trap operations to catch data and environmental data. Currently not all locations use this key.| NA |	Battle, Clear
trap_start_date |	Date when trap was started or restarted. | NA |	Battle, Clear
trap_start_time |	Time when trap was started or restarted. | NA |	Battle, Clear
trap_sample_date | Date when trap was checked and catch counted. | The start date is typically the end date from the previous day. |	NA	| Battle, Butte, Clear, Deer, Feather, Mill, Yuba, Knights
trap_sample_time | Time when trap was checked and catch counted. | The start time is typically the end time from the previous day. |	NA | Battle, Butte, Clear, Feather, Yuba, Knights
sample_period_revolutions | Number of cone revolutions during sampling period. | NA |	Battle, Butte, Clear, Yuba, Knights
cone_setting | Describes if cone was at full or half cone. | 1 = full cone, 0.5 = half cone |	Battle, Clear
river_left_depth | River depth from inside of the river left (units = m) | NA |	Battle, Clear
river_center_depth | River depth from directly in the center of cone (units = m) | NA |	Battle, Clear
river_right_depth |	River depth from inside of the river right (units = m) | NA |	Battle, Clear
thalweg |	Was trap fishing in the thalweg (T/F) |	T/F |	Battle, Clear
depth_adjust | The depth of the bottom of the cone (units = cm) |	NA | Battle, Clear
avg_time_per_rev | Cone rate measurement - average time for one revolution (units = seconds). |	NA	Battle, Clear, Deer, Mill
fish_properly |	Was there a problem with the trap (T/F) |	T/F |	Battle, Clear
comments | Qualitative comments about sampling event. | NA | Battle, Clear, Yuba, Knights
gear_condition | A code for the condition of the trap |	trap not in service, trap stopped functioning, trap functioning but not normally, trap functioning normally | Battle, Clear, Deer, Feather Mill
trap_fishing | Did the trap fish (T/F) | T/F | Battle, Clear
partial_sample | Did the trap fish for the entire sample day (T/F) | T/F | Battle, Clear
stream | Location of monitoring program (e.g. stream or river) | battle creek, butte creek, clear creek, deer creek, feather river, mill creek, yuba river, sacramento river | NA
site | Site within the location |  | NA
subsite | Subsite or specific trap location within each site and location. Names are specific to location.	| |	NA
debris_volume | Volume of debris measured in trap (gallons). | NA |	Battle, Clear
trap_status |	Status of trap during visit |	drive by, end trapping, start trapping, continue trapping, unplanned restart, service trap |	Butte, Feather, Yuba
rpms_start | Cone rate measurement - revolutions per mintue at the start of trap visit | NA | Butte, Yuba
rpms_end | Cone rate measurement - revolutions per minute at the end of the trap visit | NA | Butte, Yuba
fish_processed | Description of whether fish were processed. | processed fish, no fish caught, no catch data fish released, no catch data fish left in live box | Feather
method | Method of sampling. | Categories: fish screen diversion trap, rotary screw trap	fish screen diversion trap, rotary screw trap | Yuba
debris_level | Categorical level of debris in trap (visual assessment). | light, medium, heavy, very heavy | Yuba
number_traps | Number of traps operating | NA | Knights
cone_rpm | Cone rate measurement - revolutions per minute | NA | Knights

*Recapture*

| column name | tributary collects | definition | 
| :------------------------------------ | :------------ |  :---------------------------------------------------------------- | 
| stream | B, C, F, KL | stream that the data is from |
| release_id | B, C, F, KL | the unique identifier for each release trial | 
| date_recaptured | B, C, F, KL | date that fish were recaptured |
| number_recaptured | B, C, F, KL | count of fish recaptured in RST on a specific recapture date |
| median_fork_length_recaptured | B, C, F, KL | median fork length of group of fish recaptured |
| cone_status | B, C | if RST cone is fishing half or full |

All released and recaptured fish are chinook salmon. 

*Release*

| column name | tributary collects | definition | 
| :------------------------------------ | :------------ |  :---------------------------------------------------------------- | 
| stream | B, C, F, KL | stream that the data is from |
| release_id | B, C, F, KL | the unique identifier for each release trial | 
| date_released | B, C, F, KL | date that marked fish are released |
| time_released | B, C | time that marked fish are released |
| site | F, KL | site on stream where fish are released |
| number_released | B, C, F, KL | count of fish released |
| median_fork_length_released | B, C, KL | median fork length of group of fish released |
| night_release |B, C, F, KL | TRUE if the release is at night|
| days_held_post_mark | B, C | number of days marked fish are held before released |
| flow_at_release | B, C | flow measure at time and stream of release |
| temperature_at_release | B, C | temperature measure at time and stream of release |
| turbidity_at_release | B, C | turbidity measure at time and stream of release |
| adipose_clipped | B | TRUE is adipose fin clipped |

*Flow*

| variable_name |	description	| 
| ----------- | ----------- | 
| date | date of flow measurement |
| flow_cfs | mean daily flow in cubic feet per second (cfs) |
| site | site associated with flow measurement |
| stream | stream location associated with flow measurement |
| source | source of flow data |

*Temperature*

To be added week of July 24 2022
