# Purpose: Downloads and saves the data from Kaggle 
# Author: Liam Wall
# Date: 7 December 2024
# Contact: liam.wall@mail.utoronto.ca
# Pre-requisites: Have `tidyverse` package installed

#### Workspace setup ####
library(tidyverse)

#### Download data ####
training_data <- read_csv("data/raw_data/train.csv")
test_data <- read_csv("data/raw_data/test.csv")

### Save data ###
# The data is too large to save and push to Github
# If data is ever needed, reference the above code