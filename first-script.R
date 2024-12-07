library(glmnet)
library(coefplot)
library(dplyr)

# Load the training and testing data
training_data <- read.csv("train.csv")
testing_data <- read.csv("testing.csv")

train_features <- training_data[, -c(1:2)]  # Remove first two columns from training data
test_features <- testing_data[, -c(1:1)]    # Remove first column from testing data

# Step 2: Perform cross-validation to find optimal lambda
# Use training data for cross-validation, predicting the 'cancer' outcome variable
cvfit <- cv.glmnet(as.matrix(train_features), training_data$cancer, family = "multinomial")

# To check the coefficients at the best lambda
cat("Coefficients at the best lambda:\n")
print(cvfit$nzero[which(cvfit$lambda == cvfit$lambda.min)])

coefs_list <- predict(cvfit, type = "coef", s = "lambda.min")

# Loop through each class 
for (i in 1:3) {
  coefs_sparse_matrix <- coefs_list[[i]]
  
  coefs_dense_matrix <- as.matrix(coefs_sparse_matrix)
  
  cat("Number of coefficients for Class", i, ":", nrow(coefs_dense_matrix), "\n")
  
  non_zero_class_coefs <- coefs_dense_matrix[coefs_dense_matrix[, 1] != 0, ]
  
  cat("\nClass", i, "Coefficients:\n")
  print(non_zero_class_coefs)
}


#The best lambda from the cross-validation
cat("Best lambda:", best_lambda, "\n")

# Step 3: Ensure the columns of testing data match the training data
# Reorder testing data columns to match the training data's feature order
test_features <- test_features[, colnames(train_features)]

# Step 4: Predict the class labels using the best lambda for the testing data
predictions_test <- predict(cvfit, newx = as.matrix(test_features), s = "lambda.min", type = "class")

# Check the predictions
head(predictions_test)

# Create the new n x 2 matrix with ID and predicted cancer labels
predicted_result <- data.frame(ID = testing_data$id, Predicted_Cancer = predictions_test)

# Display the result
cat("Predicted Results (ID and Predicted Cancer):\n")
print(predicted_result)

write.csv(predicted_result, "_______", row.names = FALSE)

