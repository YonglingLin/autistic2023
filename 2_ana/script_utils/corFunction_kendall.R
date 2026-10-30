corFunction_spearman <- function(data,Yvar,Xvar,Yfacet=0){
  
  if (Yfacet != 1){
    
    
    if (length(Yvar) >1){
      Fig <- data %>% pivot_longer(col=Yvar, names_to="type", values_to="scores") 
      
      stepleng <- max(Fig$scores)/20
      
      label_y <- c(max(Fig$scores) + seq(stepleng, stepleng*length(Yvar), length.out = length(Yvar)))
      
      Fig %>% 
        ggscatter(x=Xvar, y="scores", add = "reg.line",add.params=list(size=4, fill='lightgray'), palette = 'jco',
                  conf.int = T, shape = "type", color = c("type"), size=5) +stat_cor(aes(color=type), method = 'kendall', 
        size=10, label.y = label_y) +theme_pubr(base_size=25)
      
    } else{
      
      data %>% 
        ggscatter(x= Xvar, y= Yvar, add = "reg.line", add.params=list(size=4, fill='lightgrey'), palette = 'jco',
                  conf.int = T, color="grey", shape=12, size=5, font.label = c(42, "plain")) +
        stat_cor(size=10, method = 'kendall') + theme_pubr(base_size=25)
      
    }
    
  } else if (Yfacet == 1){
    
    Fig <- data %>% pivot_longer(cols=Yvar, names_to="type", values_to="scores")
    
    Fig$type <- factor(Fig$type, levels= Yvar)  # arrange at the specific order ('Yvar' order)
    
    stepleng <- max(Fig$scores)/20
    label_y <- c(max(Fig$scores) + seq(stepleng, stepleng * length(Yvar), length.out = length(Yvar)))
    
    Fig %>%
      ggscatter( x = Xvar, y="scores", add = "reg.line",add.params=list(size=3, color="grey",fill='lightgray'),palette = 'jco',
                 facet.by=c("type"),conf.int = T, shape = "type",  color = c("type"), size=5) +
      stat_cor(aes(color=type), method = 'kendall', size=8, color="black", label.y = label_y) + theme_pubr(base_size=30)    
    
  }
  
}
