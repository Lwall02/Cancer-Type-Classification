# Load the required library
library(randomForest)
library(tree)

# Assuming `data_reduced` is downloaded and loaded into the environment
# The first column should be patients id
# The second column is 'cancer', which is the target variable
# The rest are the 500 gene with the highest varaince

train <- sample(nrow(data_reduced), nrow(data_reduced)/2)

# First random forest is m = sqrt(p) = sqrt(500) ~ 22
rf.gene <- randomForest(cancer ~ . -id, data=data_reduced, mtry=22, 
                        importance=TRUE)
rf.gene
yhat.rf <- predict(rf.gene,newdata=training_data)
mean(yhat.rf != training_data$cancer)
plot(rf.gene)
importance(rf.gene)
varImpPlot(rf.gene)

train <- sample(1:nrow(data_reduced), nrow(data_reduced)/2)
cancer.test <- data_reduced$cancer[-train]

# Fit the Random Forest model on the training data
rf.gene <- randomForest(cancer ~ . - id, data = data_reduced, subset = train, importance = TRUE)

# Number of trees to test (let's use the same range as in the default plot)
num_trees <- seq(1, 500, by = 2)  # Adjust this range if needed

# Initialize an empty vector to store the error rates for each number of trees
test_errors <- numeric(length(num_trees))

# Loop through the number of trees and calculate the error for each
for (i in 1:length(num_trees)) {
  # Fit a Random Forest model with the current number of trees
  rf_model <- randomForest(cancer ~ . -id, data = data_reduced, subset = train, ntree = num_trees[i], importance = TRUE)
  
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

# As is usual we will go with mtry = sqrt(p) and num_trees = 50

test_model_50 <- randomForest(cancer ~ . -id, data = data_reduced, subset = train, ntree = 50, importance = TRUE)

# Now use actual test data since we know the testingresult.csv is 100% correct
test_data <- read_csv("test.csv")
test_data <- test_data |>
  clean_names()

test_pred <- predict(test_model_50, newdata = test_data)

lasso_results <- read_csv("testingresult.csv") # These we know are correct from Kaggle

predicted_dataset <- data.frame(id = test_data$id, predicted_cancer = test_pred)

sum <- 0
for (i in 1:379) {
  sum <- sum + ifelse(lasso_results$cancer[i] == predicted_dataset$predicted_cancer[i],
                      0, 1)
}
sum
importance(test_model_50)
varImpPlot(test_model_50)
