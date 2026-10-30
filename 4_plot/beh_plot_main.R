# -----------------------------------------------------------------------------
# Main behavior plotting script
# Purpose:
# 1) Load and merge behavioral datasets across experiment versions.
# 2) Compute summary indices (e.g., self-bias and SBF-related metrics).
# 3) Export analysis-ready tables with date-stamped filenames.
# 4) Generate publication figures (Fig3-Fig6) as PDF files.
# -----------------------------------------------------------------------------

# Clear existing objects and set working directory to this script's location.
rm(list=ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Load shared libraries, plotting theme settings, and utility functions.
source('environPrepar.R')

# Input/output folders used throughout the script.
rawdatapath = '../1_data/outfrommat'
datapath='../3_ana_out'
path_figs='../5_figs'
today_tag <- format(Sys.Date(), "%Y%m%d")

# Small helper to keep CSV export naming consistent.
save_dated_csv <- function(data, prefix, out_dir = datapath) {
  out_file <- file.path(out_dir, paste0(prefix, "_", today_tag, ".csv"))
  write.csv(data, file = out_file, row.names = FALSE)
}

# Read experiment-level source tables.
Lab         <- read.csv(file.path(rawdatapath, "Lab_FULLTABLE_29-Jul-2021_ridgeALL.csv"), header=TRUE, sep=",")
Online1_2   <- read.csv(file.path(rawdatapath, 'Online1_Online2_standard_07-Sep-2023_ridgeALL.csv'), header=TRUE, sep=',')
Online3     <- read.csv(file.path(rawdatapath, 'Online3_standard_07-Sep-2023_ridgeALL.csv'), header=TRUE, sep=',')

#-----------------------------------------------------------------------------
# Define four versions: Lab; Online1; Online2; Online3
#-----------------------------------------------------------------------------

Lab$ver <- c('lab')
Online1_2$ver <- ifelse(Online1_2$groupver==0,'online2','online1')
Online3$ver <- c('online3')

#- Create a full dataset;
# Build the full participant-level table and derive analysis variables.
Fulldata <- setFull(Lab, Online1_2, Online3)
Fulldata <- addBehIndex(Fulldata)
Fulldata$mode <- ifelse(Fulldata$ver=='lab','lab','online')
Fulldata$AQcutoff <- ifelse(Fulldata$AQbinary_total>=32,'aboveAQcutoff','belowAQcutoff')

file_name <- paste(datapath,"/Fulldata_", format(Sys.Date(), "%Y%m%d"), ".csv", sep = "")
save_dated_csv(Fulldata, "Fulldata")


#----------------------------------------------------------------------------------------------
# Fig.3: %corr+GLM, Self-bias, SBF use in self and partner decisions for Online experiment 1
#----------------------------------------------------------------------------------------------
online1 <- subset(Fulldata, ver=='online1')
save_dated_csv(online1, "online1")

# 3a: Percent correct (%corr) for self vs partner choices.

VOI <- c('corS','corP') 
X <- online1 %>% pivot_longer(cols = VOI, names_to = 'type', values_to = 'scores') %>% mutate(type = factor(type, levels = VOI))
corplot <- ggplot(X, aes(x = type, y = scores, fill = type)) +
  stat_summary(fun = mean, geom = "bar", width = 0.5, color = "gray", linewidth = 0.5, position = position_dodge(width = 0.5)) +
  geom_jitter(color = "#cccccc", shape = 19, size = 5, width = 0.1, alpha = 0.2) +
  stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.14, linewidth = 0.4, color = "black",
               position = position_dodge(width = 0.5)) + #geom_hline(yintercept = 0) +
  scale_fill_manual(values = color_palette[c(1:2)]) + scale_x_discrete(labels = c("Self", "Partner")) +
  theme_pubr(base_size = 24) + xlab("") + ylab("Percentage of correct \n choice (%corr)")
corplot


# 3b: Self-bias index in online1.
VOI <- c('corSP') 
X <- online1 %>% pivot_longer(cols = VOI, names_to = 'type', values_to = 'scores') 
sbiasplot <- X %>%
  ggbarplot(x="type",y="scores", position=position_dodge(0.8),add=c("mean_se"), width=0.5, fill=c(color_palette[1]), color = c('gray'),
            add.params=list(color=c('black'), alpha=0.4, size=1, width=0.1), ylab=c('Self-bias'), #title= c('Self-bias'),Self-bias
            xlab="") + theme_pubr(base_size=24) + scale_fill_brewer(palette = "Dark2") + theme(plot.title=element_text(hjust=0.5)) +scale_x_discrete(labels = c("")) 
sbiasplot


# 3c: GLM coefficients for self decisions.
VOI <- c('Sglm.S','Sglm.P','Sglm.Or','Sglm.Oi') # 'Sglm.c',,'Sglm.bonus'
X <- online1 %>% pivot_longer(cols = VOI, names_to = 'type', values_to = 'scores') %>%
  mutate(type = factor(type, levels = VOI))

SGLMplot <- ggplot(X, aes(x = type, y = scores, fill = type)) +
  stat_summary(fun = mean, geom = "bar", width = 0.5, color = "gray", linewidth = 0.5, position = position_dodge(width = 0.5)) +
  geom_jitter(color = "#cccccc", shape = 19, size = 5, width = 0.1, alpha = 0.2) +
  stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.18, linewidth = 0.4,
               color = "black", position = position_dodge(width = 0.5)) +geom_hline(yintercept = 0) +
  scale_fill_manual(values = rep(color_palette[1], length(VOI))) + scale_x_discrete(labels = c("S", "P", "Or", "Oi")) +
  theme_pubr(base_size = 24) + xlab("") + ylab("Decision weights") + theme(legend.position = "none")
SGLMplot

# 3d: Social basis function use in self decisions.
VOI <- c('SBF_self')  
X <- online1 %>% pivot_longer(cols = VOI, names_to = 'type', values_to = 'scores') 
Ssomplot <- X %>% ggbarplot(x="type",y="scores", position=position_dodge(0.8),add=c("mean_se"), width=0.5, fill=c(color_palette[1]), color = c('gray'), 
            add.params=list(color=c('black'), alpha=0.4, size=1, width=0.1), ylab = 'Social basis function \n use (SBF)',
            xlab="") + theme_pubr(base_size=24) + scale_fill_brewer(palette = "Dark2") + theme(plot.title=element_text(hjust=0.5)) + scale_x_discrete(labels = c("Self decisions")) 
Ssomplot


# 3e: GLM coefficients for partner decisions.
VOI <- c('Pglm.S','Pglm.P','Pglm.Or','Pglm.Oi') 
X <- online1 %>% pivot_longer(cols = VOI, names_to = 'type', values_to = 'scores') %>% mutate(type = factor(type, levels = VOI))
PGLMplot <- ggplot(X, aes(x = type, y = scores, fill = type)) +
  stat_summary(fun = mean, geom = "bar", width = 0.5, color = "gray", linewidth = 0.5,
               position = position_dodge(width = 0.5)) +
  geom_jitter(color = "#cccccc", shape = 19, size = 5, width = 0.1, alpha = 0.2) +
  stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.18, linewidth = 0.4,
               color = "black", position = position_dodge(width = 0.5)) + geom_hline(yintercept = 0) +
  scale_fill_manual(values = rep(color_palette[2], length(VOI))) +
  scale_x_discrete(labels = c("S", "P", "Or", "Oi")) + theme_pubr(base_size = 24) + xlab("") + ylab("Decision weights") +
  theme(legend.position = "none")
PGLMplot


# 3f: Social basis function use in partner decisions.
VOI <- c('SBF_partner')  
X <- online1 %>% pivot_longer(cols = VOI, names_to = 'type', values_to = 'scores') 
Psomplot <- X %>%
  ggbarplot(x="type",y="scores", position=position_dodge(0.8),add=c("mean_se"), width=0.5, fill=c(color_palette[2]), color = c('gray'),
            add.params=list(color=c('black'), alpha=0.4, size=1, width=0.1), ylab='Social basis function \n use (SBF)',
            xlab="") + theme_pubr(base_size=24) + scale_fill_brewer(palette = "Dark2") + theme(plot.title=element_text(hjust=0.5)) +
  scale_x_discrete(labels = c("Partner decisions")) 
Psomplot

######################################################################################################
#Arrange: fig3: behavioural indices from online experiment 1
#######################################################################################################
# Assemble six panels into the Figure 3 layout and export as PDF.
Main_fig3 = ggarrange(corplot,sbiasplot,SGLMplot,Ssomplot,PGLMplot,Psomplot,ncol=2,nrow=3, heights=c(2,2), widths = c(1.3,1), labels=c('A','B','C','D','E','F'), 
                      vjust=2, hjust=-0.3, align='hv',font.label = list(size = 36, color = "black", face = "bold"))

ggsave(file.path(path_figs, paste0('Fig3ABCDEF_',Sys.Date(),'.pdf')),plot=Main_fig2,dpi = 300, device = "pdf",height=20,width=14) 


#-----------------------------------------------------------------------------
# Fig.4: Compare behavioural markers across experiments
#-----------------------------------------------------------------------------
online2 <- subset(Fulldata, ver=='online2')
save_dated_csv(online2, "online2")

online3 <- subset(Fulldata, ver=='online3')
save_dated_csv(online3, "online3")

lab <- subset(Fulldata, ver=='lab')
save_dated_csv(lab, "lab")


# 4a: %corr between self and partner decisions in all experiments
VOI <- c('corS','corP') 
X <- Fulldata %>% pivot_longer(cols = VOI, names_to = 'input', values_to = 'Values')
X$ver  <- factor (X$ver, levels = c('online1','online2','online3', 'lab'))
X$input <- factor(X$input, levels = VOI)
data2plot_corr = X %>%mutate(group = as.factor(ver))

data2plot_corr$combined_factor <- as.factor(paste(data2plot_corr$group, data2plot_corr$input, sep = "_"))
data2plot_corr$combined_factor  <- factor(data2plot_corr$combined_factor, levels = c('online1_corS','online1_corP','online2_corS', 'online2_corP',
                                                                                     'online3_corS','online3_corP','lab_corS','lab_corP'))

corver4 <- ggplot(data2plot_corr, aes(x = group, y = Values, fill = combined_factor)) +
  stat_summary(fun = mean, geom = "bar", width = 0.7, color = "gray", linewidth = 0.5,
               position = position_dodge(width = 0.7)) +
  geom_jitter(aes(color = input), position = position_jitterdodge(jitter.width = 0.25), alpha = 0.2, size = 4) +
  stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.18, linewidth = 0.4, color = "black",
               position = position_dodge(width = 0.7)) +
  geom_hline(yintercept = 0) +
  scale_color_manual(values = c("#cccccc", "#cccccc")) +
  scale_fill_manual(values = color_palette[c(1:8)]) +
  theme_pubr(base_size = 24) + xlab('') + ylab('%corr') + scale_x_discrete(labels = c("Online1", 'Online2', 'Online3', 'Lab')) +
  theme(legend.position = "top")
corver4

# 4b: Self-bias across all versions.
VOI <- c('corSP') 
Fulldata$ver  <- factor(Fulldata$ver, levels = c('online1','online2','online3', 'lab'))
sbias_ver4 <- Fulldata %>%
  ggbarplot(x="ver",y="corSP", position=position_dodge(0.8),add=c("mean_se"), width=1, fill='ver', color = c('gray'), linewidth = 1,
            add.params=list(color='black', alpha=1, size=1.6, width=0.25), ylab=c('Self-bias'), xlab="") + theme_pubr(base_size=24) + 
            scale_fill_manual(values = color_palette[c(1,3,5,7)])+ scale_x_discrete(labels = c("Online1",'Online2','Online3','lab'))  + theme(legend.position = "none")

# 4c: Self-bias reorganize by %group among online experiments 
Fulldata$ver  <- factor(Fulldata$ver, levels = c('online2','online1','online3', 'lab'))
SelfBias_ver4_summary <- Fulldata %>% group_by(ver) %>%
                         summarise(mean_corSP = mean(corSP, na.rm = TRUE), se_corSP = sd(corSP, na.rm = TRUE) / sqrt(n()),.groups = 'drop')

SelfBias_ver4_bar <- Fulldata %>%
  ggbarplot(x = "ver", y = "corSP", position = position_dodge(0.8), add = c("mean_se"), width = 1,
            fill = 'ver', color = c('gray'), linewidth = 1,
            add.params = list(color = 'black', alpha = 1, size = 1.6, width = 0.25),
            ylab = c('Self-bias'), xlab = "") +
  theme_pubr(base_size = 24) +
  scale_fill_manual(values = color_palette[c(3,1,5,7)]) +
  theme(plot.title = element_text(hjust = 0.5), legend.position = "none") +
  scale_x_discrete(labels = c("Online2\n(0%)",'Online1\n(33%)','Online3\n(50%)','Lab\n(33%)'))


# 4d: "Irrelevant player" GLM weights in self decisions.
VOI <- c('Sglm.P','Sglm.Oi') 
X <- Fulldata %>% pivot_longer(cols = VOI, names_to = 'input', values_to = 'Values')
X$ver  <- factor (X$ver, levels =  c('online1','online2','online3', 'lab'))
X$input <- factor(X$input, levels = VOI)
data2plot_ips = X %>%mutate(group = as.factor(ver))

data2plot_ips$combined_factor <- as.factor(paste(data2plot_ips$group, data2plot_ips$input, sep = "_"))
data2plot_ips$combined_factor  <- factor(data2plot_ips$combined_factor, levels = c('online1_Sglm.P','online1_Sglm.Oi','online2_Sglm.P','online2_Sglm.Oi',
                                                                                   'online3_Sglm.P', 'online3_Sglm.Oi', 'lab_Sglm.P', 'lab_Sglm.Oi'))

SGLM_V4 <- ggplot(data2plot_ips, aes(x = group, y = Values, fill = combined_factor)) +
  stat_summary(fun = mean, geom = "bar", width = 0.7, color = "gray", linewidth = 0.5,
               position = position_dodge(width = 0.7)) +
  geom_jitter(aes(color = combined_factor), position = position_jitterdodge(jitter.width = 0.3), alpha = 0.2, size = 4) +
  stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.18, linewidth = 0.4, color = "black",
               position = position_dodge(width = 0.7)) +
  geom_hline(yintercept = 0) +
  scale_color_manual(values = rep(c("#cccccc"),8)) + scale_fill_manual(values = color_palette[c(1,1,3,3,5,5,7,7)]) + theme(legend.title = element_blank(),legend.justification='right') +
  theme_pubr(base_size=24) + xlab('') + ylab('Decision weight') + scale_x_discrete(labels = c("Online1", "Online2", "Online3", "Lab")) + theme(legend.position = "none")


# 4e: SBF use in self decisions across all versions.
Fulldata$ver  <- factor(Fulldata$ver, levels = c('online1','online2','online3', 'lab'))
Ssom_ver4 <- Fulldata %>%
  ggbarplot(x="ver",y="SBF_self", position=position_dodge(0.8),add=c("mean_se"), width=1, fill='ver', color = c('gray'), linewidth = 1,
            add.params=list(color='black', alpha=1, size=1.6, width=0.25), ylab=c('Social basis function \n use (self decisions)'), 
            xlab="") + theme_pubr(base_size=24) + scale_fill_manual(values = color_palette[c(1,3,5,7)]) + theme(plot.title=element_text(hjust=0.5)) +
  scale_x_discrete(labels = c("Online1",'Online2','Online3','lab')) + theme(legend.position = "none")

# 4f: reorganize SBF use in self decisions
Fulldata$ver  <- factor(Fulldata$ver, levels = c('online2','online1','online3', 'lab'))
Ssom_ver4_summary <- Fulldata %>% group_by(ver) %>% summarise(mean_SBF_self = mean(SBF_self, na.rm = TRUE),
                                                   se_SBF_self = sd(SBF_self, na.rm = TRUE) / sqrt(n()), .groups = 'drop')

Ssom_ver4_bar <- Fulldata %>%
  ggbarplot(x="ver",y="SBF_self", position=position_dodge(0.8),add=c("mean_se"), width=1, fill='ver', color = c('gray'), linewidth = 1,
            add.params=list(color='black', alpha=1, size=1.6, width=0.25), ylab=c('Social basis function \n use (self decisions)'), 
            xlab="") +  theme_pubr(base_size=24) + scale_fill_manual(values = color_palette[c(3,1,5,7)]) + theme(plot.title=element_text(hjust=0.5)) +
  scale_x_discrete(labels = c("Online2\n(0%)",'Online1\n(33%)','Online3\n(50%)','Lab\n(33%)')) + theme(legend.position = "none")

# 4g: "Irrelevant player" GLM weights in partner decisions.
VOI <- c('Pglm.S','Pglm.Oi') 
X <- Fulldata %>% pivot_longer(cols = VOI, names_to = 'input', values_to = 'Values')
X$ver  <- factor (X$ver, levels = c("online1",'online2','online3','lab'))
X$input <- factor(X$input, levels = VOI)
data2plot_ipp = X %>%mutate(group = as.factor(ver))

data2plot_ipp$combined_factor <- as.factor(paste(data2plot_ipp$group, data2plot_ipp$input, sep = "_"))
data2plot_ipp$combined_factor  <- factor(data2plot_ipp$combined_factor, levels = c('online1_Pglm.S','online1_Pglm.Oi','online2_Pglm.S','online2_Pglm.Oi', 
                                                                                   'online3_Pglm.S', 'online3_Pglm.Oi', 'lab_Pglm.S','lab_Pglm.Oi'))

Pglm_ver4 <- ggplot(data2plot_ipp, aes(x = group, y = Values, fill = combined_factor)) +
  stat_summary(fun = mean, geom = "bar", width = 0.7, color = "gray", linewidth = 0.5,
               position = position_dodge(width = 0.7)) +
  geom_jitter(aes(color = combined_factor), position = position_jitterdodge(jitter.width = 0.3), alpha = 0.2, size = 4) +
  stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.18, linewidth = 0.4, color = "black",
               position = position_dodge(width = 0.7)) +
  geom_hline(yintercept = 0) +
  scale_color_manual(values = rep(c("#cccccc"),8)) + 
  scale_fill_manual(values = color_palette[c(2,2,4,4,6,6,8,8)]) + theme(legend.title = element_blank(),legend.justification='right') +
  theme_pubr(base_size=24) + xlab('') + ylab('Decision weight') + scale_x_discrete(labels = c("Online1", "Online2", "Online3", "Lab"))  + theme(legend.position = "none")


# 4h: SBF use in partner decisions across all versions.
Fulldata$ver  <- factor(Fulldata$ver, levels = c("online1",'online2','online3','lab'))
Psom_v4 <- Fulldata %>%
  ggbarplot(x="ver",y="SBF_partner", position=position_dodge(0.8),add=c("mean_se"), width=1, fill='ver', color = c('gray'), linewidth = 1,
            add.params=list(color='black', alpha=1, size=1.6, width=0.25), ylab=c('Social basis function \n use (partner decisions)'), 
            xlab="") + theme_pubr(base_size=24) + scale_fill_manual(values = color_palette[c(2,4,6,8)]) +  theme(plot.title=element_text(hjust=0.5)) +
  scale_x_discrete(labels = c("Online1",'Online2','Online3','lab')) + theme(legend.position = "none")


# 4i: SBF use in partner decisions for online subsets only.
Fulldata$ver  <- factor(Fulldata$ver, levels = c('online2',"online1",'online3','lab'))
Psom_ver4_summary <- Fulldata %>%
  group_by(ver) %>%
  summarise(mean_SBF_partner = mean(SBF_partner, na.rm = TRUE),
            se_SBF_partner = sd(SBF_partner, na.rm = TRUE) / sqrt(n()),
            .groups = 'drop')

Psom_ver4_bar <- Fulldata %>%
  ggbarplot(x="ver",y="SBF_partner", position=position_dodge(0.8),add=c("mean_se"), width=1, fill='ver', color = c('gray'), linewidth = 1,
            add.params=list(color='black', alpha=1, size=1.6, width=0.25), ylab=c('Social basis function \n use (partner decisions)'), 
            xlab="") + 
  theme_pubr(base_size=24) + scale_fill_manual(values = color_palette[c(4,2,6,8)]) + theme(plot.title=element_text(hjust=0.5)) +
  scale_x_discrete(labels = c("Online2\n(0%)",'Online1\n(33%)','Online3\n(50%)','Lab\n(33%)')) + theme(legend.position = "none")

######################################################################################################
#Arrange: fig4: Assemble the 3x3 panel matrix for Figure 3 and export.
#######################################################################################################
Main_fig4 = ggarrange(corver4,sbias_ver4,SelfBias_ver4_bar, SGLM_V4,Ssom_ver4,Ssom_ver4_bar, Pglm_ver4,Psom_v4, Psom_ver4_bar, ncol=3,nrow=3, heights=c(2,2), widths = c(1.5,1.25,1.25), 
                      labels=c('A','B','C','D','E','F','G','H','I'), vjust=2, hjust=0, align='h',font.label = list(size = 36, color = "black", face = "bold")) 
ggsave(file.path(path_figs, paste0('Fig4_A-I_',Sys.Date(),'.pdf')),plot=Main_fig4,dpi = 300, device = "pdf",height=20,width=21) 


#------------------------------------------------------------------------------------
# [Fig.5] Null results: self-other integration markers vs autistic trait scores
#-------------------------------------------------------------------------------------
Xvar <- c('AQ_total') 
fig5_outcomes <- c('corSP', 'SBF_self', 'SBF_partner')
fig5_y_limits <- setNames(lapply(fig5_outcomes, function(outcome) {
  outcome_range <- range(Fulldata[[outcome]], finite = TRUE)
  outcome_range + c(-0.05, 0.05) * diff(outcome_range)
}), fig5_outcomes)

# Helper to standardize scatter+regression plots used in Fig.5.
# Use shared axes so experiment panels are comparable within each outcome row.
doCorPlot <- function(data, Xvar, Yvar, colx, curylab, xlim_range = c(60, 200)) {
  d <- data %>% pivot_longer(cols=Yvar, names_to='type', values_to = 'scores')
  d$type  <- factor(d$type, levels= Yvar) 
  
  p <- d %>%
    ggscatter( x = Xvar, y="scores", add = "reg.line",add.params=list(size=3, color="grey", fill='lightgray', alpha=0.5), palette = 'jco',
               conf.int = T,  alpha = 1,  shape = 21, fill = "type", size=3.8, color = 'black', stroke = 0.4, xlab='Autistic trait scores',ylab=curylab) + 
    theme_pubr(base_size=24) + #stat_cor(aes(color=type),size=11) + #method = 'kendall'
    scale_fill_manual(values = colx) + theme(legend.position = "none") +
    coord_cartesian(xlim = xlim_range, ylim = fig5_y_limits[[Yvar]])
  
  return(p)
  
}

online1_corSP <- doCorPlot(online1, Xvar, c('corSP'), extBlue[5], 'Self-bias', xlim_range = c(60, 200))
online1_Ssom  <- doCorPlot(online1, Xvar, c('SBF_self'), color_palette[c(1)], 'SBF use in self decisions', xlim_range = c(60, 200))
online1_Psom  <- doCorPlot(online1, Xvar, c('SBF_partner'), color_palette[c(2)], 'SBF use in partner decisions', xlim_range = c(60, 200))

online2_corSP <- doCorPlot(online2, Xvar, c('corSP'), extGreen[5], 'Self-bias', xlim_range = c(60, 200))
online2_Ssom  <- doCorPlot(online2, Xvar, c('SBF_self'), color_palette[c(3)], 'SBF use in self decisions', xlim_range = c(60, 200))
online2_Psom  <- doCorPlot(online2, Xvar, c('SBF_partner'), color_palette[c(4)], 'SBF use in partner decisions', xlim_range = c(60, 200))

online3_corSP <- doCorPlot(online3, Xvar, c('corSP'), extPuRd[5], 'Self-bias', xlim_range = c(60, 200))
online3_Ssom  <- doCorPlot(online3, Xvar, c('SBF_self'), color_palette[c(5)], 'SBF use in self decisions', xlim_range = c(60, 200))
online3_Psom  <- doCorPlot(online3, Xvar, c('SBF_partner'), color_palette[c(6)], 'SBF use in partner decisions', xlim_range = c(60, 200))

# Keep lab plots with auto x-axis scaling
lab_corSP <- doCorPlot(lab, Xvar, c('corSP'), '#FF7F00' , 'Self-bias')
lab_Ssom  <- doCorPlot(lab, Xvar, c('SBF_self'), color_palette[c(7)], 'SBF use in self decisions')
lab_Psom  <- doCorPlot(lab, Xvar, c('SBF_partner'), color_palette[c(8)], 'SBF use in partner decisions')


######################################################################################################
#Arrange: fig5
#######################################################################################################
# Assemble Figure 5 (12 panels) and export.
Main_fig5 = ggarrange(online1_corSP,online2_corSP,online3_corSP,lab_corSP,online1_Ssom,online2_Ssom,online3_Ssom,lab_Ssom,online1_Psom,online2_Psom,online3_Psom,lab_Psom,
                      ncol=4,nrow=3, heights=c(2,2), widths = c(1,1), labels=c('A','B','C','D','E','F','G','H','I','J','K','L'), vjust=2, hjust=0, align='hv',font.label = list(size = 36, color = "black", face = "bold"))
ggsave(file.path(path_figs,paste0('Fig5_A-L_',Sys.Date(),'.pdf')),plot=Main_fig5,dpi = 300, device = "pdf",height=18,width=28)



#-------------------------------------------------------------------------------------------
# Fig.6 subscales and alternative scoring methods on self-other integration markers
#-------------------------------------------------------------------------------------------
VOI <- c('AQ_Social_Skills','AQ_Att_Switch','AQ_Att_Detail','AQ_Communication','AQ_Imagination',
         'AQ_3FM_Social_Skills','AQ_3FM_Detail','AQ_3FM_Communication','AQ_2FM_Social_Comm','corSP','SBF_self','SBF_partner')

subdata= subset(Fulldata, select=VOI)  
names(subdata) <- c('Social skills','Attention switching','Attention to detail', 'Communication','Imagination',
                    'Social skills factor - 3 factor model', 'Detail and pattern factor - 3 factor model', 'Communication and mindreading factor - 3 factor model',
                    'Social interaction factor - 2 factor model','Self-bias','SBF in self','SBF in partner')
Acor = cor(subdata, use = "pairwise.complete.obs")
Acor_subset <- Acor[c(1:9), c(10:12)]

## Fig.6B
#---------------------------------------------------------------------------------------------
VOI <- c('AQbinary_Social_Skills','AQbinary_Att_Switch','AQbinary_Att_Detail','AQbinary_Communication','AQbinary_Imagination', 
         'AQbinary_3FM_Social_Skills','AQbinary_3FM_Detail','AQbinary_3FM_Communication','AQbinary_2FM_Social_Comm','corSP','SBF_self','SBF_partner')

subdata= subset(Fulldata, select=VOI)  
names(subdata) <- c('Social skills','Attention switching','Attention to detail', 'Communication','Imagination',
                    'Social skills factor - 3 factor model', 'Detail and pattern factor - 3 factor model', 'Communication and mindreading factor - 3 factor model',
                    'Social interaction factor - 2 factor model','Self-bias','SBF in self','SBF in partner')
Bcor = cor(subdata, use = "pairwise.complete.obs")
Bcor_subset <- Bcor[c(1:9), c(10:12)]

save_corrplot <- function(filename, mat, width = 8, height = 10, ...) {
  # Ensure no stale graphics devices interfere with PDF output.
  while (!is.null(dev.list())) dev.off()
  pdf(filename, width = width, height = height)
  corrplot(mat,
           method = 'color',
           col = COL2("RdBu", n = 100),
           addCoef.col = 'black',
           number.cex = 1.5,
           number.font = 2,
           tl.col = "black",
           tl.cex = 1.2,
           tl.srt = 90,
           cl.cex = 1.3,
           cl.ratio = 0.35,
           cl.length = 5,
           addgrid.col = 'black')
  dev.off()
}

save_corrplot(file.path(path_figs,paste0('Fig6A_', Sys.Date(),'.pdf')),Acor_subset)
save_corrplot(file.path(path_figs,paste0('Fig6B_', Sys.Date(),'.pdf')),Bcor_subset)


