visualGLM_online3 <- function(ongoingDATA, ttl, cols) {  
  
  #Linear regressions for
  #-----------------------------------------------------------
  corSP     <- batchGLM_online3('corSP', ongoingDATA)
  SBF_self    <- batchGLM_online3('SBF_self', ongoingDATA)
  SBF_partner <- batchGLM_online3('SBF_partner', ongoingDATA)
 

  # set and label dataframe to plot
  #------------------------------------------------------------
  corSP$Type<-rownames(corSP)
  corSP$Label<- 'Self-bias'
  
  SBF_self$Type<-rownames(SBF_self)
  SBF_self$Label<- 'SBF in self decisions'
    
  SBF_partner$Type<-rownames(SBF_partner)
  SBF_partner$Label<- 'SBF in partner decisions'
  
  # construct figure function
  #---------------------------------------------------------------------------------------
  plotGLM_coefficients <- function(plot_data, cols) {
    ggplot(data = plot_data, aes(x = Type, y = Estimate, group = Label)) +
      geom_col(aes(fill = Label), color = "black", linewidth = 1.2, position = "dodge", width = 0.6) +
      geom_errorbar(aes(ymin = Estimate - Std..Error, ymax = Estimate + Std..Error),colour = "black", width = 0.3, linewidth = 1.2, 
                    position = position_dodge(0.6)) +
      labs(title = " ", x = " ", y = "Regression Coefficient") +geom_hline(yintercept = 0, linewidth = 1) + theme_classic() +
      theme( axis.title.y = element_text(size = rel(2.5), margin = margin(0, 20, 0, 0)),
             axis.title.x = element_text(size = rel(3), margin = margin(20, 0, 0, 0)),
             axis.text = element_text(size = 25),axis.line = element_line(             color = "black", linewidth = 1.2),
                          axis.ticks = element_line(linewidth = 1.5), axis.ticks.length = unit(0.4, "cm"),
             legend.text = element_text(size = 20),legend.title = element_blank(),
             legend.position = "right") + 
      scale_fill_manual(values = cols) + ylim(-0.1, 0.1)
  }  
  
  # a) subFig_self-bias
  # -------------------------------------------------------------------------------------
  RegFig_selfbias <-rbind(corSP)
  RegFig_selfbias$Label<-factor(RegFig_selfbias$Label, levels=c("Self-bias"))
  RegFig_selfbias$Type<-factor(RegFig_selfbias$Type, levels=c("AQ",'AQsquare')) 
  
  Fig_selfbias <- plotGLM_coefficients(RegFig_selfbias, cols[1])
  
  
  # b) subFig_social basis function
  # -------------------------------------------------------------------------------------
  RegFig_SBF <-rbind(SBF_self,SBF_partner)
  RegFig_SBF$Label<-factor(RegFig_SBF$Label, levels=c('SBF in self decisions','SBF in partner decisions'))
  RegFig_SBF$Type<-factor(RegFig_SBF$Type, levels=c("AQ",'AQsquare'))   

  Fig_SBF <- plotGLM_coefficients(RegFig_SBF, cols)

  
  # c) stack both panels: self-bias (upper), SBF (lower)
  # -------------------------------------------------------------------------------------
  ggpubr::ggarrange(Fig_selfbias, Fig_SBF, ncol = 1, nrow = 2, labels = c('B', 'C'),
                    align = 'hv', font.label = list(size = 36, color = "black", face = "bold"))
}






