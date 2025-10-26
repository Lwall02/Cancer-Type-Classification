# 🧬 Cancer Type Classification Using LASSO Regularization

This project applies multinomial logistic regression with LASSO regularization to classify cancer patients into three distinct subtypes using gene expression data. The work is based on our submission to a public Kaggle Cancer Type Classification Competition, where our model achieved a perfect score of 1.000 (3rd place out of 26 competeing models).

## 🎯 Research Objective

To accurately classify patients into one of three cancer subtypes using high-dimensional gene expression data:

- **Glioblastoma Multiforme (GBM)**
- **Lung Squamous Cell Carcinoma (LUSC)**
- **Ovarian Cancer (OV)**

Accurate subtype classification can improve early detection, inform treatment plans, and enhance our understanding of cancer genetics.

## 📊 Model Description

The model framework employs Multinomial Logistic Regression with LASSO regularization, implemented via the R package `glmnet`. This combination allows both multi-class prediction and automatic feature selection among 12,000+ gene expression variables.

- **Data Dimensions:**
   - 12,043 features (gene expression levels)
   - 886 training patients (GBM = 376, LUSC = 90, OV = 420)
   - 379 testing patients

We can represent the probability that observation $i$ belongs to cancer type $c \in \\{1,2,3\\}$:

![equation](https://latex.codecogs.com/svg.image?P(Y_i=c|x_i)=\frac{e^{\beta_{0c}+\beta_{1c}x_{i1}+...+\beta_{pc}x_{ip}}}{\sum_{j=1}^3e^{\beta_{0j}+\beta_{1j}x_{i1}+...+\beta_{pj}x_{ip}}})

where each $x_i = (x_{i1}, x_{i2}, \..., x_{ip})$ represents the gene expression vector for patient $i$ with $p = 12,043$ genes.

Then, the LASSO-regularized loss function minimized by the `glmnet` algorithm is:

![equation](https://latex.codecogs.com/svg.image?\hat{\beta}=\arg\min_{\beta}\{-\ell(\beta)+\lambda\sum_{c=1}^3\sum_{j=1}^p|\beta_{jc}|\})

where:
- $l(\beta)$ is the multinomial log-likelihood,
- $\lambda$ is the regularization parameter, controlling sparsity, and
- The LASSO penalty $\sum | \beta_{jc} |$ forces small or irrelevant coefficients toward zero.

This formulation allows the model to isolate a sparse, interpretable subset of genes that most strongly differentiate the three cancer subtypes, enhancing both accuracy and biological insight

### ⚙️ Data Processing

- **Source:** The Cancer Genome Atlas (TCGA) via Kaggle
- **Platform:** Affymetrix HT Human Genome U133a microarray
- **Transformation:** All gene expression values were log-transformed prior to modeling for variance stabilization.
- **Cleaning:** Ensured valid feature names, removed inconsistencies, and encoded cancer types as categorical factors.

### 🧠 Model Training & Validation

Cross-validation was used to tune the regularization parameter λ, balancing bias and variance:

- **Optimization:** 10-fold cross-validation on training data
- **Best λ:** ≈ 0.00487
- **Packages Used:** `glmnet`, `tidyverse`, `janitor`, `arrow`, `coefplot`
- **Evaluation Metric:** Misclassification error

All model training was conducted in R 4.3 using reproducible scripts included in the `scripts/` directory.

## 🔍 Key Takeaways

- LASSO effectively reduced over 12,000 features to a smaller interpretable subset of genes.
- Perfect test accuracy demonstrates strong discriminative power between GBM, LUSC, and OV subtypes.
- The workflow demonstrates the power of regularized regression for high-dimensional biomedical data.
- This approach may inform future research into gene-level biomarkers for early cancer detection.

## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from Kaggle.
-   `data/analysis_data` contains the cleaned dataset that was constructed.
-   `data/prediction_data` contains our cancer type predictions for our Kaggle competition submission.
-   `model` contains the fitted model. 
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to download, clean, and test the data as well as the code to produce the model.
