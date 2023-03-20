# Analysis

The analysis folder contains ad-hoc analysis scripts created by FlowWest in response to data questions or QC issues.

-   [qc-checks](https://github.com/FlowWest/JPE-datasets/tree/main/analysis/qc-checks) contains scripts focused on ad-hoc QC checks for datasets.

-   [salmonid_habitat_extents](https://github.com/FlowWest/JPE-datasets/tree/main/analysis/salmonid_habitat_extents) contains data files needed to map salmon habitat

-   [figures](https://github.com/FlowWest/JPE-datasets/tree/main/analysis/figures) contains graphics produced from analysis and used in some JPE deliverable

## Highlights

-   [fish_needed_efficiency.Rmd](https://github.com/FlowWest/JPE-datasets/blob/main/analysis/fish_needed_efficiency.Rmd) generates estimates of the number of fish (hatchery and wild) needed for efficiency trials based on historic data. This script was helpful in providing rough estimates of the number of hatchery fish to request from hatcheries for efficiency trials.

-   [day_vs_nights_release_analysis.R](https://github.com/FlowWest/JPE-datasets/blob/main/analysis/day_vs_night_release_analysis.R) compares trap efficiency estimates for day and night releases. Based on this analysis, there is no significant difference between day and night releases. This script was helpful in providing information to guide decisions about day or night releases.

-   [rst_standard_length_at_date.Rmd](https://github.com/FlowWest/JPE-datasets/blob/main/analysis/rst_standard_length_at_date.Rmd) compares recorded run and run calculated by the length-at-date river model. The output of this `.Rmd` is a data file that contains a column for run calculated by the length-at-date river model.
