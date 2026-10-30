batchGLM_fulldata_v4 <- function(DV, df) {
  # Loop over each symptom score variable in separate lm models, store symptom score coefficients
  
  plot1 <- matrix(NA,2,4)
  modelString = paste(DV, "~ AQ_total+Gender+Age+SRP_total+ver")
  mod1 <- lm(modelString, df)
  plot1[1,] <- summary(mod1)$coefficients[2,1:4]
  
  modelString = paste(DV, "~ AQ_square+Gender+Age+SRP_total+AQ_total+ver")
  mod1 <- lm(modelString, df)
  plot1[2,] <- summary(mod1)$coefficients[2,1:4]
  
  plot1 <- data.frame(plot1)
  names(plot1) <- c("Estimate", "Std..Error", "t value", "P value")
  row.names(plot1) <- c("AQ" ,"AQsquare")

  return(plot1)
}
