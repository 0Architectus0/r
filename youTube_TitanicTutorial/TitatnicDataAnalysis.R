#load raw data
train <- read.csv("Data/train.csv", header = T)
test <- read.csv("Data/test.csv", header = T)

# add a "survived" Variable to the test set to allow for combining data sets
test.survived <- data.frame(survived = rep("None", nrow(test)), test[,])

#Combine data sets
data.combined <- rbind(train, test.survived)