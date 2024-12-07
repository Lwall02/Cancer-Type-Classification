# Purpose: Create a random forest model using feature selection
# Author: Liam Wall
# Date: 7 December 2024
# Contact: liam.wall@mail.utoronto.ca
# Pre-requisites: 
# - Have `randomForest` package installed - for tests
# - Have 'arrow' package installed - to read in parquet files


#### Workspace setup ####
library(randomForest)
library(arrow)


#### Read in clean data ####
clean_training_data <- read_parquet("data/analysis_data/clean_training_data.parquet")
clean_test_data <- read_csv("data/analysis_data/clean_test_data.csv")


#### Feature Selection ####
set.seed(9)

# Calculate variance for each column except id and cancer column
variances <- apply(clean_training_data[, -(1:2)], 2, var)

# Select top 500 genes with highest variance
metadata <- clean_training_data[, 1:2]
top_genes_col_number <- order(variances, decreasing = TRUE)[1:500]
data_reduced <- clean_training_data[, top_genes_col_number]
data_reduced <- cbind(metadata, data_reduced)

#### Random forest ####
# Get train/test data from clean_training_data
# test_data is not usable for finding error rates
train <- sample(nrow(data_reduced), nrow(data_reduced)/2)
cancer.test <- data_reduced$cancer[-train]

# Number of trees to test (let's use the same range as in the plot from lecture)
num_trees <- seq(1, 500, by = 2)  # Adjust this range if needed

# Initialize an empty vector to store the error rates for each number of trees
test_errors <- numeric(length(num_trees))

# Loop through the number of trees and calculate the error for each
# First random forest is by default mtry = sqrt(p) = sqrt(500) ~ 22
for (i in 1:length(num_trees)) {
  # Fit a Random Forest model with the current number of trees
  rf_model <- randomForest(cancer ~ . -id, 
                           data = data_reduced, 
                           subset = train, 
                           mtry = 22,
                           ntree = num_trees[i], 
                           importance = TRUE)
  
  # Predict on the test data
  test_predictions <- predict(rf_model, newdata = data_reduced[-train, ])
  
  # Calculate the classification error on the test data
  test_errors[i] <- mean(test_predictions != cancer.test)  # Mean of misclassified instances
}

# Plot the error rate against the number of trees
plot(num_trees, test_errors, type = "b", pch = 19, col = "blue",
     xlab = "Number of Trees", ylab = "Test Error Rate",
     main = "Test Error Rate vs. Number of Trees")
lines(num_trees, test_errors, col = "red", lwd = 2)

# Find the index of the minimum test error
best_num_trees_index <- which.min(test_errors)

# Find the number of trees corresponding to the lowest test error
best_num_trees <- num_trees[best_num_trees_index]
# best number fo trees is 11

# We can see the first random forest with 0 test error has 11 trees
# For safety we will choose the random forest with 50 trees because
# depending on the set seed, 0 test error occurs latest at around 40 trees

test_model_50 <- randomForest(cancer ~ . -id, 
                              data = data_reduced, 
                              subset = train, 
                              mtry = 22,
                              ntree = 50, 
                              importance = TRUE)


#### Test model with actual test data ####
# Now use actual test data since we know the testingresult.csv is 100% correct
test_pred <- predict(test_model_50, newdata = clean_test_data)

# These we know are correct from Kaggle
lasso_results <- read_csv("data/prediction_data/testingresult.csv")

predicted_dataset <- data.frame(id = clean_test_data$id, predicted_cancer = test_pred)

sum <- 0
for (i in 1:379) {
  sum <- sum + ifelse(lasso_results$cancer[i] == predicted_dataset$predicted_cancer[i],
                      0, 1)
}
sum
# The random forest has 0 test error 


#### Look at model feature importance ####
importance(test_model_50)
varImpPlot(test_model_50)


#### Save random forest ####
saveRDS(
  test_model_50,
  file = "models/random_forest_model.rds"
)
