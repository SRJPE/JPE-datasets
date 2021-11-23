
# Rotary Screw Trap Data Summary 

This directory contains markdown documents exploring RST datasets for 8 tributaries. 

There are 3 main datatypes associated with RST data:

* RST Raw Catch - raw catch data describing fish caught in RST 
* RST Sampling Effort - describes sampling effort and trap conditions
* RST Passage Estimates - calculated passage estimates based on raw catch and seasonal efficiency corrections


### Data Available

| Tributary | Monitoring Timeframe | Data Contact | Metadata Quality | Data Lag | Provisional Data Available | Notes | 
| :--------- | :------------ | :------------ | :----------- | :-----------| :----------- | :--------------------- | 
| Battle Creek | 2003 - ongoing | [Mike Schraml](mailto:mike_schraml@fws.gov)  | Good | 6 months | TRUE | Provisional data may be available but will not be easy to get | 
| Butte Creek | 1995 - 2015 | [Jessica Nichols](Jessica.Nichols@Wildlife.ca.gov) | Poor | One week | TRUE | Field crew uploads to CAMP daily, QC on a weekly basis, need to wait until end of season for escapement values |
| Clear Creek | 2003 - ongoing | [Mike Schraml](mailto:mike_schraml@fws.gov)  | Good | 3 months | TRUE | Provisional data may be available but will not be easy to get |
| Deer Creek | 1992 - 2010; proposed | [Matt Johnson](mailto:Matt.Johnson@wildlife.ca.gov) | Poor | NA | NA | Currently only historical data; proposed program that will be similar to Clear and Battle |
| Feather River | 1997 - ongoing | [Kassie Hickey](mailto:KHickey@psmfc.org) | Fair | 3 months | TRUE | |
| Sac - Kinghts Landing | 2002 - ongoing | [Jeanine Philips](mailto:Jeanine.Phillips@wildlife.ca.gov) | Fair | One week | TRUE | Field crew uploads to CAMP daily, QC on a weekly basis, need to wait until end of season for escapement values |
| Sac - Tisdale | 2010 - ongoing | [Drew Huneycutt](mailto:andrew.huneycutt@wildlife.ca.gov) | Fair | One week | TRUE | Field crew uploads to CAMP daily, QC on a weekly basis, need to wait until end of season for escapement values |
| Mill Creek | 1995 - 2010; proposed | [Matt Johnson](mailto:Matt.Johnson@wildlife.ca.gov) | Poor | NA | NA | Currently only historical data; proposed program that will be similar to Clear and Battle |
| Yuba River | 2000 - 2009 | [Robyn Bilski](mailto:Robyn.Bilski@Wildlife.ca.gov) | Good | NA | NA | Only historical data |

Timeframe: End in ongoing if monitoring is ongoing, list proposed studies as well 
Metadata Quality = poor, fair, good

#### Summary of passage estimate data

| Tributary | RST Passage Estimates | Passage Estimate Methodology | Passage Estimate Resolution | Passage Estimate Uncertainty | Notes |
| :--------- | :------------ | :------------ | :----------- | :-----------| :----------- |
| Battle Creek | Tabular Data | [Modeled](https://github.com/FlowWest/JPE-datasets/blob/main/scripts/rst/battle-creek/Daily%20Passage.R) | Daily | Unknown | |
| Butte Creek | Unknown | Unknown | Unknown | Unknown | |
| Clear Creek | Tabular data | [Modeled](https://github.com/FlowWest/JPE-datasets/blob/main/scripts/rst/battle-creek/Daily%20Passage.R) | Daily | Unknown | |
| Deer Creek | Unknown | Unknown | Unknown | Unknown | |
| Feather River | Unknown | Unknown | Unknown | Unknown | |
| Sac - Kinghts Landing | [PDF Report](https://www.calfish.org/ProgramsData/ConservationandManagement/CentralValleyMonitoring/SacramentoValleyTributaryMonitoring/MiddleSacramentoRiverSalmonandSteelheadMonitoring.aspx) | Efficiency Correction | Annual | 95% CI | | 
| Sac - Tisdale | Available | Efficiency Correction | Annual | Unknown | |
| Mill Creek | Unknown | Unknown | Unknown | Unknown | |
| Yuba River | [PDF Report](https://www.yubawater.org/Archive.aspx?AMID=45) | Modeled | Annual | Unknown | Daily estimates are calculated using the GAM model but are not reported

Upstream Passage Estimates = Tabular Data, PDF Report (linked), Available, Not Available, Unknown 
Passage Estimate Methodology = Efficiency Correction, Model (linked), Unknown 
Passage Estimate Resolution = Annual, Monthly, Weekly, Daily, Unknown
Passage Estimate Uncertainty = Unknown, CI


### Next Steps 

- For cases where R scripts are provided: Simplify the existing data and use it to generate passage estimates where possible. 
- For efficiency correction estimates: Acquire efficiency corrections for all years and create table to join to catch data