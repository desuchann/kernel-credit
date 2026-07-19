## Appendix ##

library(e1071)

# https://archive.ics.uci.edu/dataset/350/default+of+credit+card+clients
data = read.csv("default of credit card clients.csv")
data$default.payment.next.month = as.factor(data$default.payment.next.month)

set.seed(1)          # reproducible
n = nrow(data)       # count how many rows of data
pivot = sample(1:n, size = (2/3)*n) # find the index separating 2:1
train = data[pivot,] # 20000 training data points
test = data[-pivot,] # 10000 to make predictions on
n_test = nrow(test)

# 1) Logistic Regression
system.time({
  lr_train = glm(default.payment.next.month ~ .,
                 data = train,
                 family = "binomial")
  lr_pred = predict(lr_train, newdata = test, type = "response") # predict >50% = 1, 0 otherwise
})
res = table(Predicted = ifelse(lr_pred > 0.5, 1, 0), Actual = test$default.payment.next.month)
FF = res[1,1] # FP = TF, FN= FT, TN = FF, TP = TT
FT = res[1,2]
TF = res[2,1]
TT = res[2,2]

print('Non-default prediction accuracy:')
FF / (FF + TF)
print('Default prediction accuracy:')
TT / (TT + FT)
print('Overall accuracy:')
(TT + FF) / n_test

# histogram of predicted probabilities
hist(lr_pred,
     breaks = 30,
     main = "LR Predicted Default Probabilities",
     xlab = "Predicted Probability of Default",
     col='orange'
     )
abline(v = 0.5, col = "red", lwd = 2) # default vs non-default threshold


# 2) SVM
# hyperparameter tuning (linear)
train_cut = train[1:(5000*2),] # chop to save time since we're running 8 times (4 costs x 2 folds)
pick_c = tune(svm,
              default.payment.next.month ~ .,
              data = train_cut,
              kernel = "linear",
              scale = T,
              ranges = list(cost = c(0.01, 0.1, 1, 10)),
              tunecontrol = tune.control(cross = 2)
)
pick_c$performances # see how each cost param performed

# linear kernel
system.time({
  svm_train = svm(default.payment.next.month ~ .,
                  data = train,
                  kernel = "linear",
                  cost = 0.1,
                  scale = T)
  svm_pred = predict(svm_train, test)
})
res=table(Predicted = svm_pred, Actual = test$default.payment.next.month)
FF = res[1,1]
FT = res[1,2]
TF = res[2,1]
TT = res[2,2]

print('Non-default prediction accuracy:')
FF / (FF + TF)
print('Default prediction accuracy:')
TT / (TT + FT)
print('Overall accuracy:')
(TT + FF) / n_test

# rbf kernel
system.time({
  svm_train = svm(default.payment.next.month ~ .,
                  data = train,
                  kernel = "radial",
                  cost = 0.1,
                  scale = T,
                  gamma=(1/23)) # gamma rule of thumb: 1/no. of predictors
  svm_pred = predict(svm_train, test)
})
res=table(Predicted = svm_pred, Actual = test$default.payment.next.month)
FF = res[1,1]
FT = res[1,2]
TF = res[2,1]
TT = res[2,2]

print('Non-default prediction accuracy:')
FF / (FF + TF)
print('Default prediction accuracy:')
TT / (TT + FT)
print('Overall accuracy:')
(TT + FF) / n_test