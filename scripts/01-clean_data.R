# Purpose: Cleans the training/testing data for analysis
# Author: Liam Wall
# Date: 7 December 2024
# Contact: liam.wall@mail.utoronto.ca
# Pre-requisites: 
# - Reference 00-download_data.R
# - Install `janitor` package
# - Install `arrow` package

#### Workspace setup ####
library(tidyverse)
library(janitor)
library(arrow)

#### Read in data ####
training_data <- read_csv("data/raw_data/train.csv")
test_data <- read_csv("data/raw_data/test.csv")

#### Clean data ####
# Clean column names
clean_training_data <- training_data |>
  clean_names()
clean_test_data <- test_data |>
  clean_names()

# Convert the response variable to a factor
clean_training_data$cancer <- factor(clean_training_data$cancer, levels = c(1, 2, 3))

#### Save data ####
write_parquet(clean_training_data, "data/analysis_data/clean_training_data.parquet")
write_parquet(clean_test_data, "data/analysis_data/clean_test_data.parquet")
