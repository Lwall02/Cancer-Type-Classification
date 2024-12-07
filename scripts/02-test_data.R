# Purpose: Tests the clean training and test data for analysis
# Author: Liam Wall
# Date: 7 December 2024
# Contact: liam.wall@mail.utoronto.ca
# Pre-requisites: 
# - Have `testthat` package installed - for tests
# - Have 'arrow' package installed - to read in parquet files
# - Reference 00-download_data.R

#### Workspace setup ####
library(tidyverse)
library(testthat)

#### Read in clean data ####
clean_training_data <- read_parquet("data/analysis_data/clean_training_data.parquet")
clean_test_data <- read_csv("data/analysis_data/clean_test_data.csv")

#### Test data ####
# Perform checks on the training data
run_training_data_tests <- function(training_data) {
  
  test_that("Training data structure is valid", {
    # Test if the cancer column exists
    expect_true("cancer" %in% colnames(training_data), 
                info = "The 'cancer' column is missing.")
    
    # Test if the cancer column is a factor
    if ("cancer" %in% colnames(training_data)) {
      expect_true(is.factor(training_data$cancer), 
                  info = "The 'cancer' column is not a factor.")
      
      # Test if the cancer column has only levels 1, 2, and 3
      expect_true(all(levels(training_data$cancer) %in% c("1", "2", "3")), 
                  info = "The 'cancer' column contains invalid levels.")
    }
    
    # Test if there are missing values
    expect_false(any(is.na(training_data)), 
                 info = "The dataset contains missing values (NAs).")
    
    # Test if there are duplicate column names
    expect_false(any(duplicated(names(training_data))), 
                 info = "The dataset contains duplicate column names.")
    
    # Test if there are duplicate rows
    expect_false(any(duplicated(training_data)), 
                 info = "The dataset contains duplicate rows.")
    
    # Test if the id column exists
    expect_true("id" %in% colnames(training_data), 
                info = "The 'id' column is missing.")
    
    # Test if the id column contains values from 1 to 886
    if ("id" %in% colnames(training_data)) {
      expect_true(all(training_data$id == 1:886), 
                  info = "The 'id' column does not contain values from 1 to 886.")
    }
    
    # Test if there are 12044 columns
    expect_equal(ncol(training_data), 12044, 
                 info = "The dataset does not have 12044 columns.")
    
    # Test if all gene expression columns are numeric
    gene_columns <- setdiff(colnames(training_data), c("id", "cancer"))
    non_numeric_genes <- gene_columns[!sapply(training_data[gene_columns], is.numeric)]
    expect_equal(length(non_numeric_genes), 0, 
                 info = paste("The following gene expression columns are not numeric:", 
                              paste(non_numeric_genes, collapse = ", ")))
    
    # Test if there are no constant value columns
    constant_columns <- names(training_data)[sapply(training_data, function(col) length(unique(col)) == 1)]
    expect_equal(length(constant_columns), 0, 
                 info = paste("The following columns have constant values:", 
                              paste(constant_columns, collapse = ", ")))
  })
  
  message("All training data tests completed. Check output for any errors.")
}

run_test_data_tests <- function(test_data) {
  
  test_that("test_data is valid", {
    
    # Check if there are no missing values in test_data
    expect_false(any(is.na(test_data)), 
                 "There are NA values in the test_data.")

    # Check if the column names are unique
    expect_true(all(!duplicated(colnames(test_data))), 
                "Column names are duplicated in test_data.")
    
    # Ensure that the number of rows is 379
    expect_equal(nrow(test_data), 379, 
                 info = "Number of rows in test_data is not 379.")
    
    # Ensure that the number of columns is 12043
    expect_equal(ncol(test_data), 12043, 
                 info = "Number of columns in test_data is not 12043.")
    
    # Ensure that the id column is numeric and spans from 1 to 379
    expect_true(is.numeric(test_data$id), 
                "id column is not numeric.")
    expect_equal(min(test_data$id), 887, 
                 info = "The id column does not start from 887.")
    expect_equal(max(test_data$id), 1265, 
                 info = "The id column does not end at 1265.")
    
    # Check if all gene expression columns are numeric
    gene_columns <- setdiff(colnames(test_data), "id")
    expect_true(all(sapply(test_data[, gene_columns], is.numeric)), "Not all gene expression columns are numeric.")
    
  })
  message("All test data tests completed. Check output for any errors.")
}

# Assuming the training data is stored in a variable called `clean_training_data`
run_training_data_tests(clean_training_data)
run_test_data_tests(clean_test_data)
