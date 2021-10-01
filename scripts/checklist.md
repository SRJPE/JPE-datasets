# Dataset QC Checklist:

- [ ] Get everything into tidy format - so we can do data mapping 
- [ ] Transform into tidy format, check that:
  - [ ] Each variable has its own column 
  - [ ] Each observation has its own row 
  - [ ] Each value has its own cell
- [ ] Update column names to snake case/remove any funky spacing
  - [ ] Preferences for naming, keep as descriptive as possible (ex: do not abbreviate group_name to grp_nm) 
- [ ] Check for missing values, convert -9999 or other placeholder into NA 
  - [ ] Summarize quantity of missing values to determine quality and completeness of data
- [ ] Check column types to ensure all data is stored as desired:
  - [ ] Numerical data - `<dbl>` or `<int>` 
  - [ ] Character data - `<str>` or `<chr>`
  - [ ] Date - `<datetime>` or `<date>` or `<time>`
- [ ] Within a categorical column check that capitalization is consistent (ex: if a column describes methodology and has “Snorkel” and “snorkel” listed as options fix to make all into snake case “snorkel”)
- [ ] Within a categorical column check that values are consistent, no typos
- [ ] Check for location information for every station (latitude and longitude for every sampling location) 
- [ ] Remove any redundant columns
- [ ] Check for outliers (Work on generating a range of reasonable values so that we can identify anything out of the ordinary) 
  - [ ] Visualize data to quickly determine if it looks reasonable - plot numerical columns, table on categorical columns 
- [ ] Check for misspellings 

## Metadata checklist:
At a minimum have the descriptions that we need to use the data:

- [ ] Definitions of all variables
- [ ] Units of all variables
- [ ] Provisional/Or QC
- [ ] How are NA values encoded 

If we can put together good to have: 

- [ ] Short dataset description
- [ ] Timeframe of study 
- [ ] Complete or Ongoing 
- [ ] Funding? 
- [ ] Definitions of all variables
- [ ] Units of all variables
- [ ] Methods (and description of consistency of methods over data collection periods) 
  - [ ] Equipment used
- [ ] Description of potential sampling abnormalities or difficulties (ex: RST catch is not accurate after _ cfs) 
- [ ] Contact person for data questions
- [ ] Provisional/Or QC
- [ ] How are NA values encoded 
