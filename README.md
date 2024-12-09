# Developing a LASSO Multinomial Model for Cancer Type Classification

## Overview

The objective of this study is to classify cancer patients into three distinct subtypes using gene expression data, with a dataset containing 12,000 gene expression variables for 880 cancer patients. We used a Multinomial Logistic Regression implemented through the `cv.glmnet` function, a method well-suited for high-dimensional datasets where the number of parameters features far exceeds the number of samples. This method is advantageous in this context of genetic data, where the vast majority of features may be irrelevant or redundant. The LASSO approach, which penalizes the absolute value of coefficients, is particularly effective for feature selection, as it encourages sparsity by shrinking the coefficients of irrelevant features to zero.

## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from Kaggle.
-   `data/analysis_data` contains the cleaned dataset that was constructed.
-   `data/prediction_data` contains our cancer type predictions for our Kaggle competition submission.
-   `model` contains the fitted model. 
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to download, clean, and test the data as well as the code to produce the model.