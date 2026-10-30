LabelAQlevel <- function (Online_data){
  
  
  nr_highAQ <- sum(Online_data$AQbinary_total>=32)
  Online_data$AQgroups <- ifelse(Online_data$AQbinary_total>=32, 'HighAQ','InterestAQ')
  
  sorted_data <- Online_data[order(Online_data$AQbinary_total), ]
  lowest_rows <- as.numeric(rownames(sorted_data[1:nr_highAQ,]))
  Online_data$AQgroups[lowest_rows] <- 'LowAQ'
  
  return(Online_data)
  
}