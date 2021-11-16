
# This code will calculate the daily passage for UCC, LCC and UBC
# Use the Passage Daily query to obtain the needed catch data sets.
# Clear Creek Trap not fished data can be found at:
# S:\CC BC\Clear Creek\Multi-Year Data and Summaries\CC Juvenile Summaries\Trap Effort CC BY03-20.xlsx
# Battle Creek Trap not fished data can be found at:
# S:\CC BC\Battle Creek\Multi-Year Data and Summaries\BC Juvenile Summaries\Trap Effort BC BY99-20.xlsx
# Created: Mike Schraml 10/29/2021


# Load needed Packages
if (!require("readxl")) {            # for importing data sets
  install.packages("readxl")
  library(readxl)
}

if (!require("tidyverse")) {            # Data management
  install.packages("tidyverse")
  library(tidyverse)
}

if (!require("openxlsx")) {         # for writing xlsx files to the desktop
  install.packages("openxlsx")
  library(openxlsx)
}

if (!require("padr")) {         # for for inserting missing dates
  install.packages("padr")
  library(padr)
}

if (!require("lubridate")) {         # for for dealing with dates
  install.packages("lubridate")
  library(lubridate)
}

# Load data sets
ucc <- read_excel("Passage Daily UCC.xlsx", 
                     col_types = c("text", "text", "date", 
                                   "text", "text", "numeric", "numeric"))

uccnf <- read_excel("UCCNF.xlsx", col_types = c("date", 
                                                "numeric", "text"))

lcc <- read_excel("Passage Daily LCC.xlsx", 
                  col_types = c("text", "text", "date", 
                                "text", "text", "numeric", "numeric"))

lccnf <- read_excel("LCCNF.xlsx", col_types = c("date", 
                                                "numeric", "text"))

ubc <- read_excel("Passage Daily UBC.xlsx", 
                  col_types = c("text", "text", "date", 
                                "text", "text", "numeric", "numeric"))

ubcnf <- read_excel("UBCNF.xlsx", col_types = c("date", 
                                                "numeric", "text"))

# Calculate and round daily passage
ucc <- mutate(ucc, passage = SumOfRCatch/BaileysEff) %>%
  mutate(passage = round(passage, 0))

lcc <- mutate(lcc, passage = SumOfRCatch/BaileysEff) %>%
  mutate(passage = round(passage, 0))

ubc <- mutate(ubc, passage = SumOfRCatch/BaileysEff) %>%
  mutate(passage = round(passage, 0))


# Insert missing dates and set new dates RCatch to zero
ucc <- pad(ucc, interval = "day",
           start_val = lubridate::ymd("2003-10-01"),
           end_val = lubridate::ymd("2021-06-30")) 

lcc <- pad(lcc, interval = "day",
           start_val = lubridate::ymd("2003-10-01"),
           end_val = lubridate::ymd("2021-06-30"))

ubc <- pad(ubc, interval = "day",
           start_val = lubridate::ymd("2003-10-01"),
           end_val = lubridate::ymd("2021-06-30"))


# Add not fished data
ucc <- merge(ucc, uccnf)
lcc <- merge(lcc, lccnf)
ubc <- merge(ubc, lccnf)


# Select the data needed
ucc <- select(ucc, SampleDate, SumOfRCatch, BaileysEff, passage, NotFished)
lcc <- select(lcc, SampleDate, SumOfRCatch, BaileysEff, passage, NotFished)
ubc <- select(ubc, SampleDate, SumOfRCatch, BaileysEff, passage, NotFished)


# Fill in passage and catch for when the trap was fished but there was zero catch, with zeros
# UCC passage
i <- 1

l <- length(ucc$passage)

for (i in 1:l){
  if(ucc$NotFished[i] == 'Fished' & is.na(ucc$passage[i] == TRUE)){
    ucc$passage[i] <- 0
  }else{
    ucc$passage[i] <- ucc$passage[i]
  }
}

# UCC catch
i <- 1

l <- length(ucc$passage)

for (i in 1:l){
  if(ucc$NotFished[i] == 'Fished' & is.na(ucc$SumOfRCatch[i] == TRUE)){
    ucc$SumOfRCatch[i] <- 0
  }else{
    ucc$SumOfRCatch[i] <- ucc$SumOfRCatch[i]
  }
}

# LCC passage
i <- 1

l <- length(lcc$passage)

for (i in 1:l){
  if(lcc$NotFished[i] == 'Fished' & is.na(lcc$passage[i] == TRUE)){
    lcc$passage[i] <- 0
  }else{
    lcc$passage[i] <- lcc$passage[i]
  }
}

# LCC catch
i <- 1

l <- length(lcc$passage)

for (i in 1:l){
  if(lcc$NotFished[i] == 'Fished' & is.na(lcc$SumOfRCatch[i] == TRUE)){
    lcc$SumOfRCatch[i] <- 0
  }else{
    lcc$SumOfRCatch[i] <- lcc$SumOfRCatch[i]
  }
}

# UBC passage
i <- 1

l <- length(ubc$passage)

for (i in 1:l){
  if(ubc$NotFished[i] == 'Fished' & is.na(ubc$passage[i] == TRUE)){
    ubc$passage[i] <- 0
  }else{
    ubc$passage[i] <- ubc$passage[i]
  }
}

# UBC catch
i <- 1

l <- length(ubc$passage)

for (i in 1:l){
  if(ubc$NotFished[i] == 'Fished' & is.na(ubc$SumOfRCatch[i] == TRUE)){
    ubc$SumOfRCatch[i] <- 0
  }else{
    ubc$SumOfRCatch[i] <- ubc$SumOfRCatch[i]
  }
}


# Rename the columns
# The function to change names
ChangeNames <- function(x) {
  names(x) <- c("Date", "Daily catch", "Trap efficiency", "Passage", "Trap fished" )
  return(x)
}

# Change names
ucc <- ChangeNames(ucc)
lcc <- ChangeNames(lcc)
ubc <- ChangeNames(ubc)


# Strip time from the Date
ubc$Date <- format(ubc$Date, format = "%m/%d/%Y")
ucc$Date <- format(ucc$Date, format = "%m/%d/%Y")
lcc$Date <- format(lcc$Date, format = "%m/%d/%Y")


# First create list of the data frames and the worksheet names to be written to desk top
daily.passage <- list("UCC Passage" = ucc, "LCC Passage" = lcc, "UBC Passage" = ubc)

# Run this Code to output the Excel file
write.xlsx(daily.passage, "C:/Users/mschraml/Desktop/ROutput/Daily Passage.xlsx")

