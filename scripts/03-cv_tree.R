# Load the tree package
library(tree)

# Fit the initial decision tree model
set.seed(42)
tree_model <- tree(cancer ~ . -id, data = training_data)

# Perform 10-fold cross-validation to evaluate the tree
cv_results <- cv.tree(tree_model, FUN = prune.misclass)

# Print the results of cross-validation
print(cv_results)

# Plot the cross-validation results (tree size vs. deviance)
plot(cv_results$size, cv_results$dev, type = "b", 
     xlab = "Tree Size", ylab = "Deviance", 
     main = "Cross-Validation for Decision Tree")

# Prune the tree based on the optimal size
optimal_size <- cv_results$size[which.min(cv_results$dev)]  # Find the optimal tree size
pruned_tree <- prune.tree(tree_model, best = optimal_size)

# Print the pruned tree
print(pruned_tree)
plot(pruned_tree)
text(pruned_tree)

# Evaluate the performance of the pruned tree
train_pred <- predict(pruned_tree, training_data, type = "class")
table(train_pred, training_data$cancer)

