# This script can be used to prepare historical data for the jpe-model-db
library(googleCloudStorageR)
library(tidyverse)

gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))


# lookup tables -----------------------------------------------------------
battle <- tibble(stream = c("battle creek"),
                 site = c("ubc"),
                 subsite = c("ubc"),
                 site_group = c("battle creek"),
                 description = c("upper battle creek rst site location"))
butte <- tibble(stream = c(rep("butte creek", 5)),
                site = c(rep("okie dam",4), "adams dam"),
                subsite = c("okie dam 1", "okie dam 2", "okie dam fyke trap", NA, "adams dam"),
                site_group = c("butte creek"),
                description = c("rst 1 at okie dam (aka parrott-phalean)", "rst 2 at okie dam (aka parrott-phalean)",
                                "fyke trap at okie dam located in diversion canal", "trap unknown", 
                                "rst at adams dam, only used historically"))
clear <- tibble(stream = c(rep("clear creek",2)),
                site = c("lcc", "ucc"),
                subsite = c("lcc", "ucc"),
                site_group = c("clear creek"),
                description = c("lower clear creek rst site", "upper clear creek rst site"))
deer <- tibble(stream = c("deer creek"),
               site = c("deer creek"),
               subsite = c("deer creek"),
               site_group = c("deer creek"),
               description = c("deer creek rst site location"))
feather <- tibble(stream = c("feather river"),
                  site = c("ubc"),
                  subsite = c("ubc"),
                  site_group = c("battle creek"),
                  description = c("upper battle creek rst site location"))
trap_location <- tibble(id = c(),
                        stream = c(),
                        site = c(),
                        subsite = c(),
                        site_group = c(),
                        description = c())


# catch -------------------------------------------------------------------
gcs_get_object(object_name = "jpe-model-data/daily_catch_unmarked.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/model-data/daily_catch_unmarked.csv",
               overwrite = TRUE)
catch_raw <- read_csv("data/model-data/daily_catch_unmarked.csv")

unique(catch_raw$stream)
