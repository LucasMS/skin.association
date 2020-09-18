# Split into train and test function -----
factorizer <- function(df){
  # Transform characters to factors
  df.ch <- sapply(df, class) %>%
    data.frame(class = .) %>%
    rownames_to_column("varname") %>%
    filter(class == "character")
  for (z in df.ch$varname){
    df[,z] <- as.factor(df[,z])
  }
  
  return(df)
}

# Do evaluation with Random forest -----
do.evaluation.rf <- function(x){
  require(MLmetrics)
  require(caret)
  require(ranger)
  require(pROC)
  require(mltools)
  # Make model
  f <- paste(x, collapse = " + ")
  f <- as.formula(paste(y, "~", f))
  
  # Create dummy variable for one variables cases
  if(length(x) == 1){
    f <- paste(x, collapse = " + ")
    f <- as.formula(paste(y, "~", "dummy +", f))
    
    train$dummy = 1
    test$dummy = 1
  }
  
  # Train with parameter tunning
  rf.fit <- train(f,
                  data = train,
                  method = "rf")
  
  # Predict
  pred <- predict(rf.fit, dplyr::select(test, -!!y)) %>% as.character()
  pred.prob <- predict(rf.fit, dplyr::select(test, -!!y), type = "prob")
  prediction <- data.frame(response = test$response, pred = pred, pred.prob)
  #
  
  #Calulate metrics for factors
  
  if(train$response %>% levels %>% length() == 2){
    
    
    metric.1 <- roc(response = prediction$response,
                    predictor = prediction %>% select(-response, -pred) %>% .[,1])$auc
  }else{
    
    metric.1 <- multiclass.roc(response = prediction$response,
                               predictor = prediction %>% select(-response, -pred))$auc
  }
  metric.2 <- mcc(preds = pred, actuals = test$response)
  metric.4 <- Accuracy(y_true = test$response, y_pred = pred)
  metrics <- c("AUC", 
               "MCC", 
               "Accuracy")
  
  # Save results
  
  d <- data.frame(metric.1 = metric.1,
                  metric.2 =metric.2,
                  metric.4 = metric.4,
                  number.of.variables = length(x),
                  eval.method = "RF",
                  metrics = paste(metrics, collapse = "|"),
                  stringsAsFactors = F )
  
  list(df = d, prediction = prediction)   %>% 
    return()
}





