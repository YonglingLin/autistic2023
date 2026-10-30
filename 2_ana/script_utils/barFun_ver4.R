
barFun_ver4 <- function (inputdata, VOI){
  
  X <- inputdata %>% pivot_longer(cols = VOI, names_to = 'input', values_to = 'Values')
  
  X$input <- factor(X$input, levels = VOI)
  #X$ver4  <- factor(X$ver4, levels = c('Online1','Online2','Online3', 'Lab1'))
  #X$ver4  <- factor(X$sched_name, levels = c('s2BT_w5w7','s2BT_w5w8','s2BT_w6w7', 's2BT_w6w8'))
  
  X.summary <- X %>%
    group_by(ver4, input) %>%
    summarise (
      sd = sd(Values),
      Mean = mean(Values),
      SEM = sd(Values)/sqrt(n())
    ) 
  
  ggplot(X.summary, aes(input, Mean)) +
    geom_col(aes(fill = ver4), position = position_dodge(0.8), width = 0.8, size=3)+
    geom_errorbar(aes(ymin = Mean-SEM, ymax = Mean+SEM , group = ver4), 
                  width = 0.3, position = position_dodge(0.8))+
    scale_fill_manual(
      values = c("lightblue","#CCEBC5",'#BEAED4', "#cccccc"), #c("darkblue", "#006D2C", "#800080",'#100C10')
      labels = c('Online1','Online2','Online3','Lab1')) + 
      theme_pubr(base_size=20)+
       scale_x_discrete(labels = c("S", "P", "Or", "Oi",'bonus')) + labs(x = '', y='')
  
  # ggplot(X.summary, aes(ver4, Mean)) +
  #   geom_col(aes(fill = input), position = position_dodge(0.8), width = 0.8, size=3)+
  #   geom_errorbar(aes(ymin = Mean-SEM, ymax = Mean+SEM , group = input), 
  #                 width = 0.3, position = position_dodge(0.8))+
  #   scale_fill_manual(values = c("#FDC086", "lightblue")) +  #, "darkblue", "#FDC086", "orange"
  #   theme_pubr(base_size=20) #+labs(title = mytitle)



  
}
  


