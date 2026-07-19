# Credit Risk Modelling: Probability of Default Prediction

## 🔍 Overview

MSc Quantitative Finance project comparing supervised learning methods for predicting credit card default probability using the Taiwanese Credit Card Default dataset.

## ⚙️ Models

Implemented and evaluated:

- Logistic regression
- SVM with linear kernel
- SVM with RBF kernel

Feature scaling and hyperparameter tuning were applied for SVM models.

## 📊 Results

| Model | Accuracy | Runtime (s) |
|---|---|---|
| Logistic Regression | ~81% | 0.35 |
| Linear SVM | ~80% | 68 |
| RBF SVM | ~82% | 120 |

The RBF SVM achieved the best classification performance, improving default detection by capturing non-linear patterns. However, this came with a significant increase in computational cost compared with logistic regression.

## 🛠️ Technologies

- R
- Logistic regression
- Support Vector Machines
- Statistical modelling
- Classification analysis
