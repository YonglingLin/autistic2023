setFull <- function(ridge_lab_data, s1GS, s2BT){

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-
# for ridge_lab_data
  
   # 1) transform Male/Female to 1/2, adding subscales for SRP
  ridge_lab_data$Gender <- ifelse(ridge_lab_data$gender== 'Male',1,2)
  ridge_lab_data$SRP_liftstyle <- ridge_lab_data$SRP_total - ridge_lab_data$SRP_interpersonal - ridge_lab_data$SRP_affective - ridge_lab_data$SRP_antisocial
  ridge_lab_data$SRP_affec_interp <- ridge_lab_data$SRP_interpersonal + ridge_lab_data$SRP_affective 
  ridge_lab_data$SRP_lifesty_antis <- ridge_lab_data$SRP_liftstyle + ridge_lab_data$SRP_antisocial
  ridge_lab_data$rtS =  ridge_lab_data$rtS*1000
  ridge_lab_data$rtP =  ridge_lab_data$rtP*1000
  
   # 2) Keep the variable names consistent: 
        # NOTED:have changed ridge_lab_data.csv before import to R
  
  VOI <- c('LA_total', 'RSS_total', 'SRP_total', 'SRP_interpersonal', 'SRP_affective', 'SRP_liftstyle', 'SRP_affec_interp', 'SRP_lifesty_antis',
           'SRP_antisocial',  'QCAE_total', 'QCAE_perspective','QCAE_Simulation', 'QCAE_Emotional_Contagion',
           'QCAE_Peripheral_Response', 'QCAE_Proximal_Response', 'QCAE_Cog_Empathy','QCAE_Emotion_Empathy','AQ_total', 'AQ_Social_Skills',
           'AQ_Att_Switch', 'AQ_Att_Detail', 'AQ_Communication', 'AQ_Imagination',  'AQ_3FM_Social_Skills', 'AQ_3FM_Detail', 'AQ_3FM_Communication',
           'AQ_2FM_Social_Comm', 'Age', 'Gender', 'IQ','GAD_total', 'BDI_total',
           'corS','corP','rtS','rtP','Sglm.c','Sglm.S','Sglm.P','Sglm.Or','Sglm.Oi','Sglm.bonus',
           'Pglm.c','Pglm.S','Pglm.P','Pglm.Or','Pglm.Oi','Pglm.bonus','ver','AQbinary_total','AQbinary_Social_Skills','AQbinary_Att_Switch',
           'AQbinary_Att_Detail','AQbinary_Communication','AQbinary_Imagination','AQbinary_3FM_Social_Skills','AQbinary_3FM_Detail',
           'AQbinary_3FM_Communication','AQbinary_2FM_Social_Comm')
  # 'Stemp.c', 'Stemp.groupdri','Stemp.individri','Stemp.bonus',
  # 'Ptemp.c','Ptemp.groupdri','Ptemp.individri','Ptemp.bonus',
  

variable_to_add <- VOI

# CHECK IF variables exist and add them if they don't in ridge_lab_data
  for (TheName in VOI){
     if (!(TheName %in% names(ridge_lab_data))){
      ridge_lab_data[[TheName]] <- as.numeric(rep('NaN', nrow(ridge_lab_data)))
       }
  }

# CHECK IF variables exist and add them if they don't in s1GS
for (TheName in VOI){
  if (!(TheName %in% names(s1GS))){
    s1GS[[TheName]] <- as.numeric(rep('NaN', nrow(s1GS)))
  }
}

#-#-#-#-# combine all data sets -#-#-#-#-#-#
  a1 <- subset(ridge_lab_data, select = VOI)
  a2 <- subset(s1GS, select = VOI)
  a3 <- subset(s2BT, select = VOI)
  Fulldata <- rbind(a1,a2,a3)
  
  return(Fulldata)
  
}
