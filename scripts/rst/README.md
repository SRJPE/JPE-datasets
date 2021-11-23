
# Rotary Screw Trap Data Summary 

This directory contains markdown documents exploring RST datasets for 8 tributaries. 

There are 3 main datatypes:

* RST Raw Catch - raw catch data describing fish caught in RST 
* RST Efficiency - efficiency measures describing trap conditions 
* RST Passage Estimates - calculated passage estimates based on trap efficiency and raw catch 

For some tributaries these datatables are organized in separate datatables; others combine RST catch and RST efficiency into one datatable.

In the Level of Effort column we categorize the amount of effort involved to provide passage estimates.


### Data Available

| Tributary | Monitoring Timeframe | Data Contact | RST Raw Catch Data | RST Efficiency Data | RST Passage Estimates | Passage Estimate Methodology | Passage Estimate Resolution | Level of Effort | Notes |
| :--------- | :------------ | :------------ | :----------- | :-----------| :----------- | :----------- | :--------- | :-------------------- | :-------------------- |
| Battle Creek | 2003 - 2021 | [Mike Schraml](mailto:mike_schraml@fws.gov)  | TRUE | TRUE | Data Provided | [R script](https://github.com/FlowWest/JPE-datasets/blob/main/scripts/rst/battle-creek/Daily%20Passage.R) | daily | Low | |
| Butte Creek | 1995 - 2015 | [Jessica Nichols](Jessica.Nichols@Wildlife.ca.gov) | TRUE | TRUE | FALSE | NA | NA | NA | |
| Clear Creek | 2003 - 2021 | [Mike Schraml](mailto:mike_schraml@fws.gov)  | TRUE | TRUE | Data Provided | [R script](https://github.com/FlowWest/JPE-datasets/blob/main/scripts/rst/battle-creek/Daily%20Passage.R) | daily | Low | |
| Deer Creek | 1992 - 2010 | [Matt Johnson](mailto:Matt.Johnson@wildlife.ca.gov) | TRUE | TRUE | FALSE | NA | NA | NA | Not enough information to generate passage estimates |
| Feather River | 1997 - 2001 | [Kassie Hickey](mailto:KHickey@psmfc.org) | TRUE | TRUE | FALSE | NA | NA | NA | |
| Sac - Kinghts Landing | 2002 - 2021 | [Jeanine Philips](mailto:Jeanine.Phillips@wildlife.ca.gov) | TRUE | TRUE | PDF available | Efficiency correction | Annual | Medium | [Annual Reports](https://www.calfish.org/ProgramsData/ConservationandManagement/CentralValleyMonitoring/SacramentoValleyTributaryMonitoring/MiddleSacramentoRiverSalmonandSteelheadMonitoring.aspx) with passage estimates, gives 95% CI |
| Sac - Tisdale | 2010 - 2020 | [Drew Huneycutt](mailto:andrew.huneycutt@wildlife.ca.gov) | TRUE | TRUE | Data available | Efficiency correction | Annual | Medium | Efficiency corrections are available but have not been provided |
| Mill Creek | 1995 - 2010 | [Matt Johnson](mailto:Matt.Johnson@wildlife.ca.gov) | TRUE | TRUE | FALSE | NA | NA | NA | Not enough information to generate passage estimates |
| Yuba River | 2000 - 2009 | [Robyn Bilski](mailto:Robyn.Bilski@Wildlife.ca.gov) | TRUE | TRUE | PDF available | GAM | Annual (daily is likely calculated) | High | [Reports](https://www.yubawater.org/Archive.aspx?AMID=45) describing 2 years of RST operation on the Yuba |


### Next Steps 

- For cases where R scripts are provided: Simplify the existing data and use it to generate passage estimates where possible. 
- For efficiency correction estimates: Acquire efficiency corrections for all years and create table to join to catch data
