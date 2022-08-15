# JPE-datasets

Repository for cleaning all SR JPE monitoring data

TODO add Table of Contents

## analysis

Collection analyses and QC.

TODO insert more description after folder is cleaned.

## data

### [standard-format-data](https://github.com/FlowWest/JPE-datasets/tree/main/data/standard-format-data)

Contains script to pull standard format data from Google Cloud.

TODO remove archive folder when moved away from original versions of model data

## data-raw

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

The `README.md` file contains descriptions of the standard format data.

TODO include links after renaming.

-   juvenile rotary screw trap standard format files

    -   catch

    -   trap

    -   mark-recapture

    -   environmental

-   adult upstream passage

-   adult holding

-   adult redd

-   adult carcass

-   standard environmental data

    -   flow

    -   water temperature

TODO remove archive folder after moved away from original versions of data for model
