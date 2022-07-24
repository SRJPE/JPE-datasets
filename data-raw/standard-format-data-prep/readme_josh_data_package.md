---
title: "README"
output: html_document
date: '2022-07-07'
---

This directory contains the following data files:

- standard_catch_rst.csv (created on July 6 2022)

Historical RST data was acquired from spring run tributaries for use in the
SR JPE. FlowWest performed QC and data processing to combine datasets into a 
standard usable format.

**Data dictionary**

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
