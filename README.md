# JPE-datasets

Repository for cleaning all SR JPE monitoring data. This repository contains 3 folders:

-   [**analysis**](https://github.com/FlowWest/JPE-datasets/tree/main/analysis)- ad-hoc analysis and QC in response to data questions or QC issues

-   [**data**](https://github.com/FlowWest/JPE-datasets/tree/main/data) - script for pulling standard format data from Google Cloud

-   [**data-raw**](https://github.com/FlowWest/JPE-datasets/tree/main/data-raw) - data cleaning and formatting scripts

The contents of this repository are described in more detail below. Click on links to navigate directly to a directory or script. Additional README documents within each directory give more in depth details on the contents of that directory.   

## [analysis](https://github.com/FlowWest/JPE-datasets/tree/main/analysis)

Ad-hoc analysis and QC in response to data questions or QC issues

### highlights

-   [qc-checks](https://github.com/FlowWest/JPE-datasets/tree/main/analysis/qc-checks) contains scripts focused on ad-hoc QC checks for datasets.

-   [fish_needed_efficiency.Rmd](https://github.com/FlowWest/JPE-datasets/blob/main/analysis/fish_needed_efficiency.Rmd) generates estimates of the number of fish (hatchery and wild) needed for efficiency trials based on historic data.

-   [day_vs_nights_release_analysis.R](https://github.com/FlowWest/JPE-datasets/blob/main/analysis/day_vs_night_release_analysis.R) compares trap efficiency estimates for day and night releases.

-   [rst_standard_length_at_date.Rmd](https://github.com/FlowWest/JPE-datasets/blob/main/analysis/rst_standard_length_at_date.Rmd) compares recorded run and run calculated by the length-at-date river model.

## [data](https://github.com/FlowWest/JPE-datasets/tree/main/data)

### [standard-format-data](https://github.com/FlowWest/JPE-datasets/tree/main/data/standard-format-data)

Contains script to pull standard format data from Google Cloud.

*Google Cloud is currently used in internal workflows - all SR JPE data is stored in a Google cloud bucket*

## [data-raw](https://github.com/FlowWest/JPE-datasets/tree/main/data-raw)

### [qc-markdowns](https://github.com/FlowWest/JPE-datasets/tree/main/data-raw/qc-markdowns)

QC was conducted on monitoring data acquired from each Stream Team following a standard process where data were explored numerically and visually. The primary changes implemented during this process included making variable names readable and standard (snake case), and transforming encodings to be more readable. Data quality issues were flagged for follow up with Stream Teams and addressed in the standard-format-data-prep process.

QC scripts are organized by monitoring type and stream. `.md` files can be viewed on GitHub. `.Rmd` files can be run and generated into an `html` file.

QC files for each monitoring type can be accessed using the links below:

-   [adult holding, redd, and carcass](https://github.com/FlowWest/JPE-datasets/tree/main/data-raw/qc-markdowns/adult-holding-redd-and-carcass-surveys)

-   [adult upstream passage](https://github.com/FlowWest/JPE-datasets/tree/main/data-raw/qc-markdowns/adult-upstream-passage-monitoring)

-   [juvenile rotary screw trap](https://github.com/FlowWest/JPE-datasets/tree/main/data-raw/qc-markdowns/rst)

-   juvenile seine and snorkel (currently not fully processed or used)

### [standard-format-data-prep](https://github.com/FlowWest/JPE-datasets/tree/main/data-raw/standard-format-data-prep)

Historical monitoring data across Stream Teams varies in terms of protocols and data format. Based on feedback from iterative meetings with the SR JPE Data Management Team and Stream Teams, data across Stream Teams was combined according to a standard format. These datasets are referred to as standard format data and were generated using RMarkdown for full transparency. Standard format data are stored on Google Cloud and can be downloaded using the [`pull_data.R`](https://github.com/FlowWest/JPE-datasets/blob/main/data/standard-format-data/pull_data.R) script. Currently Google Cloud bucket access is private. Standard format data will be moved in the near future to the [Environmental Data Initiative (EDI)](https://portal.edirepository.org/nis/home.jsp) repository for ongoing access and transparency.

TODO insert link after merge.

The [README.md file](https://github.com/FlowWest/JPE-datasets/blob/main/data-raw/standard-format-data-prep/README.md) contains detailed descriptions of the standard format data.

-   juvenile rotary screw trap standard format files

    -   [catch](https://github.com/FlowWest/JPE-datasets/blob/main/data-raw/standard-format-data-prep/rst_catch_standard_format.Rmd)

    -   [trap](https://github.com/FlowWest/JPE-datasets/blob/main/data-raw/standard-format-data-prep/rst_trap_standard_format.Rmd)

    -   [mark-recapture](https://github.com/FlowWest/JPE-datasets/blob/main/data-raw/standard-format-data-prep/mark_recapture_standard_format.Rmd)

    -   [environmental](https://github.com/FlowWest/JPE-datasets/blob/main/data-raw/standard-format-data-prep/rst_environmental_standard_format.Rmd)

-   [adult upstream passage](https://github.com/FlowWest/JPE-datasets/blob/main/data-raw/standard-format-data-prep/adult_upstream_passage_standard_format.Rmd)

-   [adult holding](https://github.com/FlowWest/JPE-datasets/blob/main/data-raw/standard-format-data-prep/holding_standard_format.Rmd)

-   adult redd (in development)

-   adult carcass (in development)

-   standard environmental data

    -   [flow](https://github.com/FlowWest/JPE-datasets/blob/main/data-raw/standard-format-data-prep/flow_standard_format.Rmd)

    -   water temperature (in development)
