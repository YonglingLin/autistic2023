# Adding new behavioural indexes

addBehIndex <- function(Datset){
  
  # 1) self-bias in %corr
  Datset$corSP <- Datset$corS - Datset$corP
  Datset$corchoice <- (Datset$corS + Datset$corP)/2
  
  # 2) self-bias in rt
  Datset$rtSP <- Datset$rtP - Datset$rtS
 
  # 3) Social basis function (SBF) use
  Datset$SBF_self    <- Datset$Sglm.P - Datset$Sglm.Oi
  Datset$SBF_partner <- Datset$Pglm.S - Datset$Pglm.Oi
  Datset$meanSBF     <- (Datset$SBF_self +Datset$SBF_partner)/2
  
  
  return(Datset)
 
}
