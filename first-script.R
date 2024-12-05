


# Load necessary libraries
library(glmnet)
library(caret)  # for confusionMatrix

# Load the training and testing data
training_data <- read.csv("train.csv")
testing_data <- read.csv("testing.csv")

# Step 1: Prepare the training and testing data for glmnet (removing non-feature columns)
# Remove first two columns (ID and any other columns) from both training and testing data
train_features <- training_data[, -c(1:2)]  # Remove first two columns from training data
test_features <- testing_data[, -c(1:1)]    # Remove first two columns from testing data

# Step 2: Perform cross-validation to find optimal lambda
# Use training data for cross-validation, predicting the 'cancer' outcome variable
cvfit <- cv.glmnet(as.matrix(train_features), training_data$cancer, family = "multinomial")

# Step 3: Get the best lambda from the cross-validation
best_lambda <- cvfit$lambda.min
cat("Best lambda:", best_lambda, "\n")


# Step 4: Ensure the columns of testing data match the training data
# Reorder testing data columns to match the training data's feature order
test_features <- test_features[, colnames(train_features)]

# Step 5: Predict the class labels using the best lambda for the testing data
predictions_test <- predict(cvfit, newx = as.matrix(test_features), s = "lambda.min", type = "class")

# Check the predictions
head(predictions_test)


# Create the new n x 2 matrix with ID and predicted cancer labels
predicted_result <- data.frame(ID = testing_data$id, Predicted_Cancer = predictions_test)

# Display the result
cat("Predicted Results (ID and Predicted Cancer):\n")
print(predicted_result)

write.csv(predicted_result, "C:/Users/harri/OneDrive/Desktop/Cancer Project/Cancer-Type-Classification/testingresult.csv", row.names = FALSE)

