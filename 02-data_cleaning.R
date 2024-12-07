### Workspace Set Up ###
library(tidyverse)
library(janitor)

## Download Data
training_data <- read_csv("train.csv")
test_data <- read_csv("test.csv")

## Clean Data
training_data <- training_data |>
  clean_names()
  
# Convert the response variable to a factor
# Clean feature names to be able to use any functions
training_data$cancer <- factor(training_data$cancer, levels = c(1, 2, 3))

## Test Data 
any(duplicated(names(training_data))) # Any duplicate column names
# FALSE
is.factor(training_data$cancer) # Is the response variable a factor
# TRUE

## Exploratory Data Analysis
nrow(training_data) 
# 886 - number of patients
ncol(training_data) 
# 12044 columns - 12042 genes observed, 1 id column, 1 cancer type column

# Looking closer at the names of the genes
first_three_letters_of_column_names <- substr(names(training_data), 1, 3) |>
  table()
length(first_three_letters_of_column_names)

# Calculate variance for each column except id and cancer column
variances <- apply(training_data[, -(1:2)], 2, var)

# Select top 500 genes with highest variance
metadata <- training_data[, 1:2]
top_genes_col_number <- order(variances, decreasing = TRUE)[1:500]
data_reduced <- training_data[, top_genes_col_number]
data_reduced <- cbind(metadata, data_reduced)
head(data_reduced[, 1:10])

ncol(data_reduced)
nrow(data_reduced)

