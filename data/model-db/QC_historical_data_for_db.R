# Script to QC db data generation
source("data/model-db/generate_historical_data.R")
# catch -------------------------------------------------------------------
gcs_get_object(object_name = "model-db/catch.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/model-db/catch.csv",
               overwrite = TRUE)
catch <- read_csv("data/model-db/catch.csv")
# TODO ADD CHECKS
# check that stream, site, subsite in trap_location
# check run, lifestage match lookup
# one time check - compare to last table provided josh with

try(if(any((unique(catch$trap_location_id) %in% trap_location$id) == F)) 
  stop("Missing Trap Location ID! Please fix!"))
try(if(any((unique(catch$run_id) %in% run$id) == F))
  stop("Missing Run ID! Please fix!"))
try(if(any((unique(catch$lifestage_id) %in% lifestage$id) == F))
  stop("Missing Lifestage ID! Please fix!"))

# load in table we sent to josh
# we are using daily_catch_unmarked which is the table we give to Josh so don't
# need to do any checks here

# trap --------------------------------------------------------------------
gcs_get_object(object_name = "model-db/trap.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/model-db/trap.csv",
               overwrite = TRUE)
trap <- read_csv("data/model-db/trap.csv")
# TODO ADD CHECKS
# trap location id
# visit type id
# trap functioning id
# fish processed id
# debris level id

# check that there are no missing dates
# one time check - compare to last table provided josh with


# environmental_gage ------------------------------------------------------
gcs_get_object(object_name = "model-db/environmental_gage.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/model-db/environmental_gage.csv",
               overwrite = TRUE)
environmental_gage <- read_csv("data/model-db/environmental_gage.csv")

# TODO ADD CHECKS
# parameter
# trap location
# check that there are no missing dates
# one time check - compare to last table provided josh with


# release_summary ---------------------------------------------------------
gcs_get_object(object_name = "model-db/release_summary.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/model-db/release_summary.csv",
               overwrite = TRUE)
release_summary <- read_csv("data/model-db/release_summary.csv")

# TODO ADD CHECKS
# Need to determine if want to keep this table or make it just a release table
# trap location, origin, run, lifestage
# check that there are no missing dates
# one time check - compare to last table provided josh with
# check number recaptured and number released make sense


# recaptured_fish ---------------------------------------------------------
gcs_get_object(object_name = "model-db/recaptured_fish.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/model-db/recaptured_fish.csv",
               overwrite = TRUE)
recaptured_fish <- read_csv("data/model-db/recaptured_fish.csv")

# TODO ADD CHECKS
# Need to determine if want to keep this table or make it just a release table
# trap location, run, lifestage
# check that there are no missing dates
# one time check - compare to last table provided josh with
# check number recaptured and number released make sense


# hatchery_release --------------------------------------------------------
gcs_get_object(object_name = "model-db/hatchery_release.csv",
               bucket = gcs_get_global_bucket(),
               saveToDisk = "data/model-db/hatchery_release.csv",
               overwrite = TRUE)
hatchery_release <- read_csv("data/model-db/hatchery_release.csv")

# TODO ADD CHECKS


