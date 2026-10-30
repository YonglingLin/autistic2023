zscoreVars <- function (dataset, Varnames){
 
  
  columnIndices <- which(names(dataset) %in% Varnames) # get vars indices
  
  scaled_data <- as.data.frame(scale(dataset[, columnIndices])) # z-score variables
  scaled_data <- cbind(dataset[,-columnIndices], scaled_data)
  
  return(scaled_data)
  
}