# Using Google Cloud Bucket in R

This repository uses a Google Cloud Bucket (GCB) to store and download data because some data files are very large and would take up space in the repository. We use the package `googleCloudStorageR` to upload and download data from the GCB in R.

-   The GCB is currently private and requires permissions to access. [Ashley Vizek](mailto:avizek@flowwest.com) or [Erin Cain](mailto:ecain@flowwest.com) can provide the config.json needed to use the API.

## Saving the config file

-   Do not make any edits to the config.json file and save at the root directory level (`/JPE-datasets/`).
-   The gitignore for this repository is already set to ignore the config.json file. Make sure to never push the config.json file to the remote repository.

## Set up your .Renviron

-   Edit your .Renviron by typing the following code in your console: `usethis::edit_r_environ()`
-   Define `GCS_AUTH_FILE` as the filepath of your config.json. `GCS_AUTH_FILE = "/Users/ashleyvizek/code/JPE-datasets/config.json"`
-   Define `GCS_DEFAULT_BUCKET` as the GCB. `GCS_DEFAULT_BUCKET = "jpe-dev-bucket"`

## Set up your Rmarkdown settings

- Go to `Global Options`, `R Markdown`. Make sure `Evaluate chunks in directory` is set to `Project`.

## Set up an Rmarkdown file

- When creating a new Rmarkdown that uses `googleCloudStorageR` set up using the template.