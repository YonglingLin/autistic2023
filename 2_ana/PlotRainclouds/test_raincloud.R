setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source("R_rainclouds.R")
source("summarySE.R")
source("simulateData.R")
library(cowplot)
library(readr)

# width and height variables for saved plots
w = 6
h = 3

head(summary_simdat)
##    group   N score_mean score_median       sd       se       ci
## 1 Group1 250   49.45877     42.74587 25.27975 1.598832 3.148958
## 2 Group2 250   51.94353     52.69956 25.06328 1.585141 3.121994


#Barplot
p1 <- ggplot(summary_simdat, aes(x = group, y = score_mean, fill = group))+
  geom_bar(stat = "identity", width = .8)+
  geom_errorbar(aes(ymin = score_mean - sem, ymax = score_mean+sem), width = .2)+
  ylim(0, 80)+
  ylab('Score')+xlab('Group')+theme_cowplot()+
  ggtitle("Figure R1: Barplot +/- SEM")
ggsave('1Barplot.png', width = w, height = h)

p1 


#Basic plot
p2 <- ggplot(simdat,aes(x=group,y=score))+
  geom_flat_violin(position = position_nudge(x = .2, y = 0),adjust =2)+
  geom_point(position = position_jitter(width = .15), size = .25)+
  ylab('Score')+xlab('Group')+theme_cowplot()+
  ggtitle('Figure R2: Basic Rainclouds or Little Prince Plot')

p2

#Plot with colours and coordinate flip
p3 <- ggplot(simdat,aes(x=group,y=score, fill = group))+
  geom_flat_violin(position = position_nudge(x = .2, y = 0),adjust = 2)+
  geom_point(position = position_jitter(width = .15), size = .25)+
  
  ylab('Score')+xlab('Group')+coord_flip()+theme_cowplot()+guides(fill = FALSE)+
  ggtitle('Figure R3: The Basic Raincloud with Colour')
 

p3

#Rainclouds with boxplots
p6 <- ggplot(simdat,aes(x=group,y=score, fill = group, colour = group))+
  geom_flat_violin(position = position_nudge(x = .25, y = 0),adjust =2, trim = FALSE)+
  geom_point(position = position_jitter(width = .15), size = .25)+
  geom_boxplot(aes(x = as.numeric(group)+0.25, y = score),outlier.shape = NA, alpha = 0.3, width = .1, colour = "BLACK") +
  
  ylab('Score')+xlab('Group')+coord_flip()+theme_cowplot()+guides(fill = FALSE, colour = FALSE) +
  scale_colour_brewer(palette = "Dark2")+
  scale_fill_brewer(palette = "Dark2")+
  ggtitle("Figure R6: Change in Colour Palette")
ggsave('6boxplots.png', width = w, height = h)

p6


#Plot with colours and coordinate flip

Fulldata$ver  <- factor (Fulldata$ver, levels = c('S1G1','S1G0','S2G1', 'S0G1'))

p4 <- ggplot(Fulldata,aes(x=ver,y=AQ_total, fill = ver, color = ver))+
  geom_flat_violin(position = position_nudge(x = .2, y = 0),adjust = 2)+
  geom_point(position = position_jitter(width = .15), size = 2.5, alpha = 0.5)+
  geom_boxplot(aes(x = as.numeric(ver)+0.25, y = AQ_total),outlier.shape = NA, alpha = 0.3, width = .1, colour = "BLACK") +

  ylab('Score')+xlab('')+coord_flip()+theme_cowplot()+guides(fill = FALSE,colour = FALSE)+
  scale_fill_manual(values = c("lightblue","#CCEBC5",'#BEAED4', "#FDC086")) +
  scale_color_manual(values = c("lightblue", "#CCEBC5", '#BEAED4', "#FDC086")) + # Add this line
  ggtitle('Distributions of autistic trait across studies') + 
  theme_pubr(base_size=25) 


p4


#Questionnaire distribution

Yvar =c('QCAE_Cog_Empathy','QCAE_Emotion_Empathy');
Xvar = c('AQ_total')

Fig <- Fulldata %>% pivot_longer(col=Yvar, names_to="type", values_to="scores") 

S1G1 = subset(Fulldata, ver == 'S1G1')
Fig <- S1G1 %>% pivot_longer(col=Yvar, names_to="type", values_to="scores")   
stepleng <- max(Fig$scores)/20
      
label_y <- c(max(Fig$scores) + seq(stepleng, stepleng*length(Yvar), length.out = length(Yvar)))
      
Fig %>% 
    ggscatter(x=Xvar, y="scores", add = "reg.line",add.params=list(size=4, fill='lightgray'), 
              conf.int = T, shape = "type", color = c("type"), size=5) +stat_cor(aes(color=type), size=10, label.y = label_y) +
      theme_pubr(base_size=25) + 

# Add raincloud plot
  geom_flat_violin(aes(y = scores, fill = type, color = type), position = position_nudge(x = 70, y = 0), alpha = 0.5, adjust = 2)  +
   scale_color_manual(values = c("QCAE_Cog_Empathy" = "lightblue", "QCAE_Emotion_Empathy" = "#00A9E0")) +
  scale_fill_manual(values = c("QCAE_Cog_Empathy" = "lightblue", "QCAE_Emotion_Empathy" = "#00A9E0")) 
  
#+
  #geom_half_violin(aes(y = scores, fill = type), position = position_nudge(x = -.2, y = 0), adjust = 2) +
  #geom_point(aes(y = scores, color = type), position = position_jitter(width = .15), size = 1) 
  
