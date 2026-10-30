#clear existing data and graphics and set current wd
rm(list=ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

source('environPrepar.R')

rawdata = '../1_data/outfrommat'
datapath='../3_ana_out'
path_figs='../5_figs'
today_tag <- format(Sys.Date(), "%Y%m%d")
############################################################################################
# Get the data from 3_ana_out folder
############################################################################################
Fulldata <- read.csv(file.path(datapath,'Fulldata_20261020.csv'), header =TRUE,sep=',')
online1 <- read.csv(file.path(datapath,'online1_20261020.csv'), header =TRUE,sep=',')
online2 <- read.csv(file.path(datapath,'online2_20261020.csv'), header =TRUE,sep=',')
online3 <- read.csv(file.path(datapath,'online3_20261020.csv'), header =TRUE,sep=',')
lab     <- read.csv(file.path(datapath,'lab_20261020.csv'), header =TRUE,sep=',') 


#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-
# Supplementary Figure S1
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-

# Fig.S1A: plot Reaction Time in four versions with data points 

VOI <- c('rtS','rtP')
X <- Fulldata %>% pivot_longer(cols = VOI, names_to = 'input', values_to = 'Values')
X$ver  <- factor (X$ver, levels = c('online1','online2','online3', 'lab'))
X$input <- factor(X$input, levels = VOI)
data2plot_rt = X %>%mutate(group = as.factor(ver))

data2plot_rt$combined_factor <- as.factor(paste(data2plot_rt$group, data2plot_rt$input, sep = "_"))
data2plot_rt$combined_factor  <- factor(data2plot_rt$combined_factor, levels = c('online1_rtS','online1_rtP','online2_rtS', 'online2_rtP',
                                                                                 'online3_rtS','online3_rtP','lab_rtS','lab_rtP'))
figS1A <- ggbarplot(data2plot_rt,'group','Values',add='mean_se',title='',fill = 'combined_factor', width=0.7, color = c('gray'), linewidth = 1,
          position= position_dodge(0.7),xlab='',ylab = 'Median reaction time (ms)')  + 
  geom_jitter(aes(color=input),position=position_jitterdodge(jitter.width = 0.3),alpha=0.3,size=3) + 
  scale_color_manual(values = c("#cccccc", "#cccccc")) + coord_cartesian(ylim = c(0, 4000)) + 
  scale_fill_manual(values = color_palette[c(1:8)]) + theme_pubr(base_size=24) +  theme(legend.position = 'none') +
  scale_x_discrete(labels = c("Online1",'Online2','Online3','Lab'))

# Fig.S1B: plot self-bias using Reaction Time across four experiments

VOI <- c('rtSP') 
Fulldata$ver  <- factor(Fulldata$ver, levels = c('online1','online2','online3', 'lab'))
figS1B <- Fulldata %>%
  ggbarplot(x="ver",y="rtSP", position=position_dodge(0.8),add=c("mean_se"), width=1, fill='ver', color = c('gray'), linewidth = 1,
            add.params=list(color=c('black'), alpha=0.4, size=1, width=0.3), ylab=c('Self-bias (RT)'), xlab="") + theme_pubr(base_size=24) + 
          scale_fill_manual(values = color_palette[c(1,3,5,7)])+ scale_x_discrete(labels = c("Online1",'Online2','Online3','lab'))  + theme(legend.position = "none")

# Fig.S1C: plot Bayes factors supporting the null in the correlation between autistic traits and self-bias in RT

bayf01  <- read.csv(file.path(datapath,'bayerFactor_supple.csv'), header=TRUE, sep=',')

figS1C <- ggbarplot(bayf01,'ExpVer','BF01_rtSP',fill = 'ExpVer', ylab = 'Evidence for null (BF01): \n autistic scores ~ self-bias in RT') +
  scale_fill_manual(values = color_palette_paired[c(1,2,3,4)]) + 
  geom_hline(yintercept=1,linetype='dashed', linewidth = 1)  + theme_pubr(base_size = 24)


supple_fig1 = ggarrange(figS1A,figS1B, figS1C, ncol=3,nrow=1, heights=c(2,2), widths = c(1.2,1,1), labels=c('A','B','C'), 
                        vjust=2, hjust=-0.3, align='hv',font.label = list(size = 36, color = "black", face = "bold"))

ggsave(file.path(path_figs, paste0('SFig1ABC_',Sys.Date(),'.pdf')),plot=supple_fig1,dpi = 300, device = "pdf",height=10,width=24) 


#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-
# Supplementary Figure S2: Full behavioural GLM results in self and partner decisions 
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-

# S2A. plot GLM in self decisions across four experiments
VOI <- c('Sglm.S','Sglm.P','Sglm.Or','Sglm.Oi','Sglm.bonus') # Self Decisions 
X <- Fulldata %>% pivot_longer(cols = VOI, names_to = 'input', values_to = 'Values')
X$input <- factor(X$input, levels = VOI)

X.summary <- X %>% group_by(ver, input) %>% summarise (sd = sd(Values), Mean = mean(Values),
                  SEM = sd(Values)/sqrt(n())) 

fig.S2A <- ggplot(X.summary, aes(input, Mean)) + 
    geom_col(aes(fill = ver), position = position_dodge(0.8), width = 0.8, linewidth=3)+
    geom_errorbar(aes(ymin = Mean-SEM, ymax = Mean+SEM , group = ver), 
                width = 0.3, position = position_dodge(0.8))+
    scale_fill_manual(values = color_palette[c(1,3,5,7)],labels = c('Online1','Online2','Online3','Lab')) + 
    theme_pubr(base_size=24) + scale_x_discrete(labels = c("S", "P", "Or", "Oi",'bonus')) + labs(x = '', y='')


# S2B. plot GLM in partner decisions across four experiments
VOI <- c('Pglm.S','Pglm.P','Pglm.Or','Pglm.Oi','Pglm.bonus') # Partner Decisions 
X <- Fulldata %>% pivot_longer(cols = VOI, names_to = 'input', values_to = 'Values')
X$input <- factor(X$input, levels = VOI)

X.summary <- X %>% group_by(ver, input) %>% summarise (sd = sd(Values), Mean = mean(Values),
                                                       SEM = sd(Values)/sqrt(n())) 

fig.S2B <- ggplot(X.summary, aes(input, Mean)) +
  geom_col(aes(fill = ver), position = position_dodge(0.8), width = 0.8, linewidth=3)+
  geom_errorbar(aes(ymin = Mean-SEM, ymax = Mean+SEM , group = ver), 
                width = 0.3, position = position_dodge(0.8))+
  scale_fill_manual(values = color_palette[c(2,4,6,8)], labels = c('Online1','Online2','Online3','Lab')) + 
  theme_pubr(base_size=24)+scale_x_discrete(labels = c("S", "P", "Or", "Oi",'bonus')) + labs(x = '', y='')


supple_fig2 = ggarrange(fig.S2A,fig.S2B,ncol=2,nrow=1, heights=c(2,2), widths = c(1,1), labels=c('A','B'), 
                      vjust=2, hjust=-0.3, align='hv',font.label = list(size = 36, color = "black", face = "bold"))

ggsave(file.path(path_figs, paste0('SFig2AB_',Sys.Date(),'.pdf')),plot=supple_fig2,dpi = 300, device = "pdf",height=10,width=24) 


#----------------------------------------------------------------------------------------------------------------------------------
# supplementary Figure S3: prim-sec basis function use with autistic trait scores
#----------------------------------------------------------------------------------------------------------------------------------
lab_prim_sec       <- read.csv(file.path(rawdata, "Lab_prim_sec_splitRT_20-Apr-2026_ridgeALL.csv"), header=TRUE, sep=",")
names(lab_prim_sec)[1] <- as.character('subject_id')

online1_2_prim_sec <- read.csv(file.path(rawdata,'Online1_Online2_prim_sec_splitRT_20-Apr-2026_ridgeALL.csv'), header=TRUE, sep=',')
online3_prim_sec   <- read.csv(file.path(rawdata,'Online3_prim_sec_splitRT_20-Apr-2026_ridgeALL.csv'), header = TRUE,sep = ',')

online1_raw  = subset(online1_2_prim_sec, groupver == 1)
online1_prim_sec <- online1_raw[,c('subject_id','AQ_total','fast.Sglm.pcodexF','fast.Sglm.scodexF','slow.Sglm.pcodexF','slow.Sglm.scodexF',
                          'fast.Pglm.pcodexF','fast.Pglm.scodexF','slow.Pglm.pcodexF','slow.Pglm.scodexF')]

online2_raw  = subset(online1_2_prim_sec, groupver == 0)
online2_prim_sec <- online2_raw[,c('subject_id','AQ_total','fast.Sglm.pcodexF','fast.Sglm.scodexF','slow.Sglm.pcodexF','slow.Sglm.scodexF',
                          'fast.Pglm.pcodexF','fast.Pglm.scodexF','slow.Pglm.pcodexF','slow.Pglm.scodexF')]

online3_prim_sec <- online3_prim_sec[,c('subject_id','AQ_total','fast.Sglm.pcodexF','fast.Sglm.scodexF','slow.Sglm.pcodexF','slow.Sglm.scodexF',
                       'fast.Pglm.pcodexF','fast.Pglm.scodexF','slow.Pglm.pcodexF','slow.Pglm.scodexF')]


lab_prim_sec     <- lab_prim_sec     %>% mutate(subject_id = as.character(subject_id))
online1_prim_sec <- online1_prim_sec %>% mutate(subject_id = as.character(subject_id))
online2_prim_sec <- online2_prim_sec %>% mutate(subject_id = as.character(subject_id))
online3_prim_sec <- online3_prim_sec %>% mutate(subject_id = as.character(subject_id))


plot_boxplot <- function(data, ttype_filter, title_label, 
                         col_primary, col_secondary) {
    data %>%
    pivot_longer(cols = -c(subject_id, AQ_total), names_to  = c('rt', 'ttype', 'bfs'),
    names_pattern = '(fast|slow)\\.(S|P)glm\\.(pcodexF|scodexF)', values_to = 'y' ) %>%
    filter(ttype == ttype_filter) %>%ggplot(aes(x = rt, y = y, fill = bfs)) + geom_boxplot(notch = TRUE) +
    scale_fill_manual(values = c('pcodexF' = col_primary,'scodexF' = col_secondary),labels = c('pcodexF' = 'Primary', 'scodexF' = 'Secondary')
    ) + labs(y = 'Beta(effect size)', x = '', title = title_label) + theme_classic() + theme_pubr(base_size = 20) +
    theme(strip.background = element_blank(),legend.position  = c(0.6, 1.08),legend.title     = element_blank(), plot.title = element_text(hjust = 0.5, vjust = 1.5)
    )
}

online1_temp_S <- plot_boxplot(online1_prim_sec,ttype_filter = 'S', title_label = '', col_primary = extBlue[4], col_secondary = extBlue[2])
online1_temp_P <- plot_boxplot(online1_prim_sec,ttype_filter = 'P', title_label = '', col_primary = extBlue[8], col_secondary = extBlue[6])
online2_temp_S <- plot_boxplot(online2_prim_sec,ttype_filter = 'S', title_label = '', col_primary = extGreen[4], col_secondary = extGreen[2])
online2_temp_P <- plot_boxplot(online2_prim_sec,ttype_filter = 'P', title_label = '',  col_primary = extGreen[8], col_secondary = extGreen[6])
online3_temp_S <- plot_boxplot(online3_prim_sec,ttype_filter = 'S', title_label = '', col_primary = extPuRd[4], col_secondary = extPuRd[2])
online3_temp_P <- plot_boxplot(online3_prim_sec,ttype_filter = 'P', title_label = '', col_primary = extPuRd[8], col_secondary = extPuRd[6])
lab_temp_S     <- plot_boxplot(lab_prim_sec,ttype_filter = 'S', title_label = '', col_primary = extOrg[4], col_secondary = extOrg[2])
lab_temp_P     <- plot_boxplot(lab_prim_sec,ttype_filter = 'P', title_label = '', col_primary = extOrg[8], col_secondary = extOrg[6])


bayf01  <- read.csv(file.path(datapath,'bayerFactor_supple.csv'), header=TRUE, sep=',')
bf_diffps_s <- ggbarplot(bayf01,'ExpVer','BF01_diff_pcodexF_scodexF_fast_S',fill = 'ExpVer', ylab = 'Evidence for null (BF01): \n autistic scores ~ SBF effect') + 
  scale_fill_manual(values = color_palette_paired[c(1,2,3,4)]) + xlab('') + ggtitle('Self decisions') + 
  geom_hline(yintercept=1,linetype='dashed', linewidth = 1)  + theme_pubr(base_size = 20) + theme(legend.position  = 'none')

bf_diffps_p <- ggbarplot(bayf01,'ExpVer','BF01_diff_pcodexF_scodexF_fast_P',fill = 'ExpVer', ylab = 'Evidence for null (BF01): \n autistic scores ~ SBF effect') + 
  scale_fill_manual(values = color_palette_paired[c(5,6,7,8)]) + xlab('') +  ggtitle('Self decisions') +
  geom_hline(yintercept=1,linetype='dashed', linewidth = 1)  + theme_pubr(base_size = 20) + theme(legend.position ='none')


suppleF3 = ggarrange(online1_temp_S,online2_temp_S,online3_temp_S,lab_temp_S,bf_diffps_s,online1_temp_P,online2_temp_P,online3_temp_P,lab_temp_P,bf_diffps_p,
                    ncol=5,nrow=2, heights=c(2,2), widths = c(1,1,1,1,1.5), labels=c('A','B','C','D','E','F','G','H','I','J'), vjust=2, hjust=0, align='h',font.label = list(size = 36, color = "black", face = "bold"))
ggsave(file.path(path_figs,paste0('SFig3_A-H_',Sys.Date(),'.pdf')),plot=suppleF3,dpi = 300, device = "pdf",height=12,width=22)


##############################################################################################
# supplementary Figure S4: Social structure learning increases with age
##############################################################################################

meanSBF_age_data <- Fulldata %>% dplyr::filter(is.finite(Age), is.finite(meanSBF), !is.na(ver))
meanSBF_age_model <- lm(meanSBF ~ Age, data = meanSBF_age_data)
meanSBF_age_correlation <- stats::cor.test(meanSBF_age_data$Age, meanSBF_age_data$meanSBF)

cat("\nPooled mean SOM by age (all experiment conditions)\n")
cat("N =", stats::nobs(meanSBF_age_model), "\n")
print(summary(meanSBF_age_model))
cat("95% confidence interval for the Age coefficient:\n")
print(stats::confint(meanSBF_age_model, "Age"))
print(meanSBF_age_correlation)

meanSBF_age_plot <- ggplot(meanSBF_age_data, aes(x = Age, y = meanSBF)) + geom_point(color = color_palette[2], alpha = 0.3, size = 5) +
  geom_smooth(aes(x = Age, y = meanSBF, group = 1), inherit.aes = FALSE, method = "lm", se = TRUE, color = "black", fill = "gray70", linewidth = 1.2) +
  ggpubr::stat_cor(data = meanSBF_age_data, mapping = aes(x = Age, y = meanSBF), inherit.aes = FALSE,
  method = "pearson", label.x.npc = "left", label.y.npc = "top", r.accuracy = 0.001, p.accuracy = 0.001, size = 8, color = "black") +
  labs(title = "", x = "Age (years)", y = "Overall social basis function \n (SBF) use") +
  theme_pubr(base_size = 24) +theme(plot.title = element_text(face = "bold"))
print(meanSBF_age_plot)

ggsave(file.path(path_figs,paste0('SFig4_',Sys.Date(),'.pdf')),plot=meanSBF_age_plot,dpi = 300, device = "pdf",height=10,width=10)


##########################################################################################################
# Supplementary Figure S5: Kendall's rank correlations between autistic traits and self-other integration
# Similar plot with main figure.5 only stats are different.
##########################################################################################################
Xvar <- c('AQ_total') 
Sfig5_outcomes <- c('corSP', 'SBF_self', 'SBF_partner')
Sfig5_y_limits <- setNames(lapply(Sfig5_outcomes, function(outcome) {
  outcome_range <- range(Fulldata[[outcome]], finite = TRUE)
  outcome_range + c(-0.05, 0.05) * diff(outcome_range)
}), Sfig5_outcomes)

# Helper to standardize scatter+regression plots used in Fig.5.
# Use shared axes so experiment panels are comparable within each outcome row.
doCorPlot <- function(data, Xvar, Yvar, colx, curylab, xlim_range = c(60, 200)) {
  d <- data %>% pivot_longer(cols=Yvar, names_to='type', values_to = 'scores')
  d$type  <- factor(d$type, levels= Yvar) 
  
  p <- d %>%
    ggscatter( x = Xvar, y="scores", add = "reg.line",add.params=list(size=3, color="grey", fill='lightgray', alpha=0.5), palette = 'jco',
               conf.int = T,  alpha = 1,  shape = 21, fill = "type", size=3.8, color = 'black', stroke = 0.4, xlab='Autistic trait scores',ylab=curylab) + 
    theme_pubr(base_size=24) + stat_cor(method = 'kendall', aes(color='black'),size=11,r.accuracy = 0.001, p.accuracy = 0.001) +
    scale_fill_manual(values = colx) + theme(legend.position = "none") + coord_cartesian(xlim = xlim_range, ylim = Sfig5_y_limits[[Yvar]])
  
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


#Arrange: Sfig5; Assemble SFigure 5 (12 panels) and export.
supple_Sfig5 = ggarrange(online1_corSP,online2_corSP,online3_corSP,lab_corSP,online1_Ssom,online2_Ssom,online3_Ssom,lab_Ssom,online1_Psom,online2_Psom,online3_Psom,lab_Psom,
                      ncol=4,nrow=3, heights=c(2,2), widths = c(1,1), labels=c('A','B','C','D','E','F','G','H','I','J','K','L'), vjust=2, hjust=0, align='hv',font.label = list(size = 36, color = "black", face = "bold"))
ggsave(file.path(path_figs,paste0('SFig5_A-L_',Sys.Date(),'.pdf')),plot=supple_Sfig5,dpi = 300, device = "pdf",height=18,width=28)


################################################################################################################
#supple_figS6: Autistic trait questionnaire profile and construct comparison between lab and online settings. 
#################################################################################################################

# Fig.S6A: autistic trait distribution
Fulldata$ver  <- factor(Fulldata$ver, levels = c('lab','online3','online2','online1')) 
figS6A <- ggplot(Fulldata,aes(x=ver,y=AQ_total, fill = ver, color = ver))+
  geom_flat_violin(position = position_nudge(x = .2, y = 0),adjust = 2, color='black',size=2)+
  geom_point(position = position_jitter(width = .15), size = 5, alpha = 0.5)+
  geom_boxplot(aes(x = as.numeric(ver)+0.25, y = AQ_total),outlier.shape = NA, alpha = 0.4, width = .1, size = 1, colour = "BLACK") +
  
  ylab('Autisitc trait scores')+xlab('')+coord_flip()+theme_cowplot()+
  scale_fill_manual(values = color_palette[c(7,5,3,1)]) + scale_color_manual(values = color_palette[c(7,5,3,1)]) +
  theme_pubr(base_size=25) + theme(legend.position = "none") 

ggsave(file.path(path_figs,paste0('Sfig6A_',Sys.Date(),'.pdf')),plot=figS6A,dpi = 300, device = "pdf",height=12,width=12) 


# Fig.S6B: The similarity of AQ profiles between the online samples and lab samples
AQ_subscales <- c(
  "AQ_Social_Skills", "AQ_Att_Switch", "AQ_Att_Detail", "AQ_Communication", "AQ_Imagination",
  "AQ_3FM_Social_Skills", "AQ_3FM_Detail", "AQ_3FM_Communication", "AQ_2FM_Social_Comm"
)

AQ_labels <- c(
  AQ_total             = "AQ total",
  AQ_Social_Skills     = "Social skills",
  AQ_Att_Switch        = "Attention switching",
  AQ_Att_Detail        = "Attention to detail",
  AQ_Communication     = "Communication",
  AQ_Imagination       = "Imagination",
  AQ_3FM_Social_Skills = "Social skills factor (3F)",
  AQ_3FM_Detail        = "Detail and pattern factor (3F)",
  AQ_3FM_Communication = "Communication and mindreading factor (3F)",
  AQ_2FM_Social_Comm   = "Social interaction factor (2F)"
)

AQ_scores <- list(
  Continuous = c(AQ_subscales, "AQ_total"),
  Binary     = c(sub("^AQ_", "AQbinary_", AQ_subscales), "AQbinary_total")
)

AQ_modes <- list(
  Lab    = dplyr::filter(Fulldata, mode == "lab"),
  Online = dplyr::filter(Fulldata, mode != "lab")
)

make_aq_cor <- function(data, variables) {
  # Fix: split the finite-value assignment from the validity check (previously a syntax error)
  has_variation <- function(var) {
    values <- data[[var]][is.finite(data[[var]])]
    length(values) > 1 && length(unique(values)) > 1
  }
  variables <- Filter(has_variation, variables)

  x <- data[, variables, drop = FALSE]
  r <- stats::cor(x, use = "pairwise.complete.obs")
  n <- crossprod(!is.na(x))
  t_stat <- r * sqrt((n - 2) / (1 - r^2))
  p <- 2 * stats::pt(-abs(t_stat), df = n - 2)
  p[n < 3] <- NA_real_
  diag(p) <- NA_real_

  labels <- unname(AQ_labels[sub("^AQbinary_", "AQ_", variables)])
  dimnames(r) <- dimnames(p) <- dimnames(n) <- list(labels, labels)
  list(r = r, p = p, n = n)
}

AQ_correlations <- list()
for (mode in names(AQ_modes)) {
  for (score in names(AQ_scores)) {
    key <- paste(mode, score, sep = "_")
    AQ_correlations[[key]] <- make_aq_cor(AQ_modes[[mode]], AQ_scores[[score]])
  }
}

AQ_palette <- grDevices::colorRampPalette(c("#F3E5F5", "#CE93D8", "#4A148C"))(200)
AQ_limits <- range(unlist(lapply(AQ_correlations, function(x) x$r[upper.tri(x$r)])), finite = TRUE)

aq_heatmap_data <- function(result, mode) {
  labels <- rownames(result$r)
  cells <- expand.grid(Row = labels, Column = labels, stringsAsFactors = FALSE)
  cells$r <- as.vector(result$r)
  cells$p <- as.vector(result$p)
  cells$row_index    <- match(cells$Row, labels)
  cells$column_index <- match(cells$Column, labels)
  cells <- dplyr::filter(cells, row_index >= column_index)
  cells$diagonal <- cells$row_index == cells$column_index

  cells$stars <- ifelse(cells$p < 0.001, "***",
                 ifelse(cells$p < 0.01,  "**",
                 ifelse(cells$p < 0.05,  "*", "")))
  cells$label  <- ifelse(cells$diagonal | is.na(cells$r), "",
                         sprintf("%.2f%s", cells$r, cells$stars))
  cells$fill_r <- ifelse(cells$diagonal, NA_real_, cells$r)
  cells$Row    <- factor(cells$Row, levels = rev(labels))
  cells$Column <- factor(cells$Column, levels = labels)
  cells$Mode   <- if (mode == "Lab") "Lab (N = 56)" else "Online (N = 1565)"
  cells
}

plot_aq_pair <- function(score) {
  data <- dplyr::bind_rows(lapply(names(AQ_modes), function(mode) {
    aq_heatmap_data(AQ_correlations[[paste(mode, score, sep = "_")]], mode)
  }))

  plot <- ggplot(data, aes(Column, Row, fill = fill_r)) + geom_tile(color = "white", linewidth = 0.25) +
    geom_text(aes(label = label), size = 4.6, fontface = "bold") + facet_wrap(~Mode, nrow = 1) + coord_equal() +
    scale_fill_gradientn(colors = AQ_palette, limits = AQ_limits,na.value = "white", name = "Pearson r") +
    labs(title = paste(score, "AQ correlations"), x = NULL, y = NULL) +
    theme_minimal(base_size = 14) + theme(panel.grid   = element_blank(),
                axis.text.x  = element_text(angle = 45, hjust = 1),
                strip.text   = element_text(face = "bold", size = 16),
                plot.title   = element_text(face = "bold", size = 20, hjust = 0),
                plot.margin  = margin(1, 2, 1, 2),
                legend.position = "right" )
  plot
}

AQ_continuous_plot <- plot_aq_pair("Continuous")
AQ_binary_plot     <- plot_aq_pair("Binary")

AQ_continuous_combined <- AQ_continuous_plot + labs(title = NULL) +
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(), plot.margin = margin(0, 2, 0, 2))
AQ_binary_combined <- AQ_binary_plot + labs(title = NULL) + theme(plot.margin = margin(0, 2, 0, 2))

aq_row_label <- function(label) {ggplot() +
    annotate("text", x = 0.5, y = 0.5, label = label, angle = 90, size = 5, fontface = "bold") +
    xlim(0, 1) + ylim(0, 1) + theme_void() + theme(plot.margin = margin(0, 1, 0, 1))
}

AQ_combined_plot <- patchwork::wrap_plots(
  aq_row_label("Continuous AQ correlations"), AQ_continuous_combined,
  aq_row_label("Binary AQ correlations"),     AQ_binary_combined,
  ncol = 2, byrow = TRUE, widths = c(0.1, 0.9), guides = "collect"
) & theme(legend.position = "right")


ggsave(file.path(path_figs,paste0('Sfig6BC_',Sys.Date(),'.pdf')),plot=AQ_combined_plot,dpi = 300, device = "pdf",height=20,width=20) 


## Sfig.6BC: then calculate the cosine similarity between lab and online in two different scoring method.
cosine <- function(a, b) {
  labels <- intersect(rownames(a), rownames(b))
  a <- a[labels, labels]
  b <- b[labels, labels]
  a <- a[upper.tri(a)]
  b <- b[upper.tri(b)]
  ok <- is.finite(a) & is.finite(b)
  sum(a[ok] * b[ok]) / sqrt(sum(a[ok]^2) * sum(b[ok]^2))
}

AQ_cosine <- lapply(names(AQ_scores), function(score) {
  sim <- cosine(AQ_correlations[[paste("Lab", score, sep = "_")]]$r,
                AQ_correlations[[paste("Online", score, sep = "_")]]$r)
  matrix(c(1, sim, sim, 1), 2,
         dimnames = list(c("Lab", "Online"), c("Lab", "Online")))
})
names(AQ_cosine) <- names(AQ_scores)
print(AQ_cosine)

#################################################################################################################
#supple_FigS7: Expected patterns of correlation between autistic trait scores (AQ total), empathy, 
#             and self-reported psychopathic measures (SRP). 
#################################################################################################################

axis_labels <- c(AQ_total = "AQ total", SRP_total = "SRP total", QCAE_Cog_Empathy = "Cognitive empathy", QCAE_Emotion_Empathy = "Affective empathy",
                 BDI_total = "BDI total", GAD_total = "GAD total", LA_total = "LA total", RSS_total = "RSS total")
doCorPlot <- function(data, x, y, experiment, y_limits) {
  data <- data[is.finite(data[[x]]) & is.finite(data[[y]]), ]
  y_range <- diff(range(data[[y]], na.rm = TRUE))
  correlation_label_y <- max(data[[y]], na.rm = TRUE) + 0.08 * y_range
  data$experiment <- factor(experiment, levels = names(experiment_colors))
  ggplot(data, aes(x = .data[[x]], y = .data[[y]])) +
    ggplot2::geom_point(aes(fill = experiment), shape = 21, color = experiment_colors[[experiment]], alpha = 0.7, size = 4) +
    geom_smooth(aes(group = 1), method = "lm", se = TRUE, color = experiment_colors2[[experiment]], fill = "lightgray", linewidth = 1) +
    ggpubr::stat_cor(mapping = aes(x = .data[[x]], y = .data[[y]]), inherit.aes = FALSE,
                     method = "pearson", r.accuracy = 0.001, p.accuracy = 0.001,label.x.npc = "left", label.y = correlation_label_y, size = 8) +
    scale_fill_manual(values = experiment_colors, limits = names(experiment_colors), drop = FALSE) +
    coord_cartesian(ylim = y_limits) + labs(x = axis_labels[[x]], y = axis_labels[[y]], fill = "Experiment") +
    theme_pubr(base_size = 24) +theme(legend.position = "top")
}

experiments <- list("Online 1" = online1, "Online 2" = online2, "Online 3" = online3, "Lab" = lab)
experiment_colors <- setNames(color_palette[c(1, 3, 5, 7)], names(experiments))

experiment_colors2 <- setNames(color_palette[c(2, 4, 6, 8)], names(experiments))
plot_specs <- data.frame( x = c("AQ_total", "AQ_total", "SRP_total", "SRP_total"),
                          y = c("QCAE_Cog_Empathy", "QCAE_Emotion_Empathy", "QCAE_Cog_Empathy", "QCAE_Emotion_Empathy"))
outcome_y_limits <- lapply(unique(plot_specs$y), function(y) {
  values <- unlist(lapply(experiments, function(data) data[[y]]))
  limits <- range(values[is.finite(values)])
  for (i in which(plot_specs$y == y)) {
    x <- plot_specs$x[i]
    for (data in experiments) {
      complete_data <- data[is.finite(data[[x]]) & is.finite(data[[y]]), ]
      if (nrow(complete_data) < 3 || length(unique(complete_data[[x]])) < 2) next
      x_values <- seq(min(complete_data[[x]]), max(complete_data[[x]]), length.out = 100)
      new_data <- setNames(data.frame(x_values), x)
      fit <- lm(stats::reformulate(x, response = y), data = complete_data)
      confidence <- predict(fit, newdata = new_data, interval = "confidence")
      limits <- range(limits, confidence[, c("lwr", "upr")], finite = TRUE)
    }
  }
  limits + c(-0.02, 0.1) * diff(limits)
})
names(outcome_y_limits) <- unique(plot_specs$y)

correlation_plots <- unlist(lapply(seq_along(experiments), function(row) {
  experiment <- names(experiments)[row]
  lapply(seq_len(nrow(plot_specs)), function(column) {
    doCorPlot(experiments[[experiment]], plot_specs$x[column], plot_specs$y[column],
              experiment, outcome_y_limits[[plot_specs$y[column]]])
  })
}), recursive = FALSE)

doCombinedRegressionPlot <- function(x, y) {
  plot_data <- dplyr::bind_rows(lapply(names(experiments), function(experiment) {
    data <- experiments[[experiment]]
    data$experiment <- experiment
    data
  }))
  plot_data <- plot_data[is.finite(plot_data[[x]]) & is.finite(plot_data[[y]]), ]
  plot_data$experiment <- factor(plot_data$experiment, levels = names(experiments))
  
  ggplot(plot_data, aes(x = .data[[x]], y = .data[[y]], color = experiment,
                        fill = experiment, group = experiment)) +
    geom_smooth(method = "lm", se = TRUE, alpha = 0.3, linewidth = 2.3) +
    scale_color_manual(values = experiment_colors, limits = names(experiments), drop = FALSE) +
    scale_fill_manual(values = experiment_colors, limits = names(experiments), drop = FALSE) +
    guides(fill = "none") +
    coord_cartesian(ylim = outcome_y_limits[[y]]) +
    labs(x = axis_labels[[x]], y = axis_labels[[y]]) +
    theme_pubr(base_size = 24) + theme(legend.position = "none")
}

regression_plots <- lapply(seq_len(nrow(plot_specs)), function(i) {
  doCombinedRegressionPlot(plot_specs$x[i], plot_specs$y[i])
})
all_correlation_plots <- c(correlation_plots, regression_plots)

Sfig_empathy_correlations <- ggarrange(plotlist = all_correlation_plots, ncol = 4, nrow = 5,
                                       heights = c(1, 1, 1, 1, 1.3), common.legend = TRUE, legend = "top", labels = LETTERS[seq_along(all_correlation_plots)], align = "hv",
                                       font.label = list(size = 24, color = "black", face = "bold"))
print(Sfig_empathy_correlations)

ggsave(file.path(path_figs, paste0("SFig7_A-T_", Sys.Date(), ".pdf")), plot = Sfig_empathy_correlations, dpi = 300, device = "pdf", width = 25, height = 26)


# stats-fig.S7: Compare cognitive- and affective-empathy correlations within each experiment.
for (experiment in names(experiments)) {
  for (predictor in c("AQ_total", "SRP_total")) {
    vars <- c(predictor, "QCAE_Cog_Empathy", "QCAE_Emotion_Empathy")
    data <- experiments[[experiment]]
    complete_data <- data[stats::complete.cases(data[, vars]), vars, drop = FALSE]
    correlations <- stats::cor(complete_data)
    
    cat("\n", experiment, " | ", predictor, " | N = ", nrow(complete_data), "\n", sep = "")
    cat(sprintf("r with cognitive empathy = %.3f\n", correlations[predictor, "QCAE_Cog_Empathy"]))
    cat(sprintf("r with affective empathy = %.3f\n", correlations[predictor, "QCAE_Emotion_Empathy"]))
    
    print(cocor::cocor.dep.groups.overlap(
      r.jk = correlations[predictor, "QCAE_Cog_Empathy"],
      r.jh = correlations[predictor, "QCAE_Emotion_Empathy"],
      r.kh = correlations["QCAE_Cog_Empathy", "QCAE_Emotion_Empathy"],
      n = nrow(complete_data), test = "pearson1898"
    ))
  }
}


#################################################################################################################
#supple_FigS8: Expected patterns of correlation between autistic trait scores and mental health measures. 
#################################################################################################################

online3_BDI <- doCorPlot(online3, 'AQ_total', 'BDI_total', 'Online 3', NULL)
online3_LA  <- doCorPlot(online3, 'AQ_total', 'LA_total', 'Online 3', NULL)
lab_LA      <- doCorPlot(lab, 'AQ_total', 'LA_total', 'Lab', NULL)

online3_GAD <- doCorPlot(online3, 'AQ_total', 'GAD_total', 'Online 3', NULL)
online3_RSS <- doCorPlot(online3, 'AQ_total', 'RSS_total', 'Online 3', NULL)
lab_RSS <- doCorPlot(lab, 'AQ_total', 'RSS_total', 'Lab', NULL)


supple_FigS8 = ggarrange(online3_BDI,online3_LA,lab_LA,online3_GAD,online3_RSS,lab_RSS,ncol=3,nrow=2, heights=c(2,2), widths = c(1,1), labels=c('A','B','C','D','E','F'), vjust=2, hjust=0, align='hv',
                    font.label = list(size = 36, color = "black", face = "bold")) 
ggsave(file.path(path_figs, paste0('SFig8_A-F_',Sys.Date(),'.pdf')),plot=supple_FigS8,dpi = 300, device = "pdf",height=12,width=21)


#-----------------------------------------------------------------------------------------------------------------------
# Supplementary Figure S9: Correlation profile of behavioural self-other integration indices 
#with AQ total score, subscales, and factors within the lab sample.
#-----------------------------------------------------------------------------------------------------------------------
AQ_behavior_vars <- c("corSP", "SBF_self", "SBF_partner")
AQ_behavior_labels <- c(corSP = "Self-bias", SBF_self = "SBF in self", SBF_partner = "SBF in partner")
AQ_lab_data <- dplyr::filter(Fulldata, mode == "lab")

correlate_aq_behavior <- function(scoring, behavior) {
  variables <- AQ_scores[[scoring]]
  dplyr::bind_rows(lapply(seq_along(variables), function(i) {
    x <- AQ_lab_data[[variables[i]]]
    y <- AQ_lab_data[[behavior]]
    complete <- is.finite(x) & is.finite(y)
    n <- sum(complete)
    valid <- n >= 3 && stats::sd(x[complete]) > 0 && stats::sd(y[complete]) > 0
    r <- if (valid) stats::cor(x[complete], y[complete]) else NA_real_
    p <- if (valid) stats::cor.test(x[complete], y[complete])$p.value else NA_real_
    data.frame(scoring = scoring, behavior = unname(AQ_behavior_labels[behavior]),
      aq_score = unname(AQ_labels[sub("^AQbinary_", "AQ_", variables[i])]),
      score_order = i, r = r, p = p, n = n
    )
  }))
}

AQ_behavior_correlations <- dplyr::bind_rows(lapply(names(AQ_scores), function(scoring) {
  dplyr::bind_rows(lapply(AQ_behavior_vars, function(behavior) {
    correlate_aq_behavior(scoring, behavior)}))
}))
AQ_behavior_correlations$behavior <- factor(
  AQ_behavior_correlations$behavior,
  levels = unname(AQ_behavior_labels[AQ_behavior_vars])
)

# Order and dashed reference line come from the continuous AQ scores, so both panels share them.
continuous_self <- AQ_behavior_correlations[
  AQ_behavior_correlations$scoring == "Continuous" & AQ_behavior_correlations$behavior == "SBF in self", ]
reference_r <- continuous_self$r[continuous_self$aq_score == "AQ total"]
subscale_self <- continuous_self[continuous_self$aq_score != "AQ total", ]
ordered_scores <- c("AQ total", subscale_self$aq_score[order(subscale_self$r)])

plot_lab_aq_behavior <- function(scoring) {
  plot_data <- AQ_behavior_correlations[AQ_behavior_correlations$scoring == scoring, ]
  plot_data$score_order <- match(plot_data$aq_score, ordered_scores)
  plot_data$significance <- ifelse(plot_data$p < 0.001, "***",
                                   ifelse(plot_data$p < 0.01, "**", ifelse(plot_data$p < 0.05, "*", "")))
  
  plot <- ggplot(plot_data, aes(x = score_order, y = r, color = behavior, group = behavior)) +
    geom_hline(yintercept = 0, color = "black", linewidth = 1) +
    geom_line(linewidth = 1.2) + geom_point(size = 4) +
    geom_text(aes(label = significance), vjust = -0.8, show.legend = FALSE, size = 8, fontface = "bold") +
    scale_x_continuous(breaks = seq_along(ordered_scores), labels = ordered_scores, expand = expansion(mult = c(0.02, 0.04))) +
    scale_y_reverse(limits = c(1, -1), breaks = seq(1, -1.0, by = -0.2)) +
    scale_color_manual(values = c("Self-bias" = extOrg[9], "SBF in self" = color_palette[7], "SBF in partner" = color_palette[8])) +
    labs( title = paste(if (scoring == "Continuous") "Continuous AQ" else "AQ-binary", "correlations (Lab, N = 56)"),
      x = "", y = "Correlation (r)", color = "Behavioral index") +
    theme_pubr(base_size = 20) +  theme(axis.text.x = element_text(angle = 45, hjust = 1),
          plot.title = element_text(face = "bold", hjust = 0))
  plot <- plot + geom_hline(yintercept = reference_r, linetype = "dashed", color = "black", linewidth = 0.5)
  plot
}

AQ_lab_continuous_plot <- plot_lab_aq_behavior("Continuous")
AQ_lab_binary_plot <- plot_lab_aq_behavior("Binary")
AQ_lab_behavior_plot <- patchwork::wrap_plots( AQ_lab_continuous_plot, AQ_lab_binary_plot, ncol = 2, guides = "collect") &theme(legend.position = "right")
print(AQ_lab_behavior_plot)
ggsave(file.path(path_figs, paste0('SFig9_AB_',Sys.Date(),'.pdf')),plot=AQ_lab_behavior_plot,dpi = 300, device = "pdf",height=12,width=22)

# Strongest |r| and smallest p per behavior and scoring method (Lab only).
AQ_extreme_correlations <- AQ_behavior_correlations %>%
  dplyr::filter(behavior %in% c("Self-bias", "SBF in partner")) %>%
  dplyr::group_by(behavior, scoring) %>%
  dplyr::summarise(max_abs_r_score = aq_score[which.max(abs(r))], max_abs_r = r[which.max(abs(r))],
    min_p_score = aq_score[which.min(p)], min_p = min(p, na.rm = TRUE),
    .groups = "drop")

#-----------------------------------------------------------------------------------------------------------------------
# Supplementary Figure S10: the markers of self-other integration unaffected in people scoring above the common AQ cutoff
#-----------------------------------------------------------------------------------------------------------------------
Sbias.plot <- ggbarplot(Fulldata, "AQcutoff","corSP", position=position_dodge(0.8),add=c("mean_se"), 
                     fill='AQcutoff', width=0.5, color = 'gray', linewidth = 1,
                     add.params=list(color='black', alpha=0.4, size=1, width=0.1),title= c(''), 
                     ylab=c('self-bias'), xlab="") + scale_fill_manual(values = color_palette[c(1:2)]) + 
  theme_pubr(base_size=24) + theme(legend.position = "none")

Smer.plot <- ggbarplot(Fulldata, "AQcutoff","SBF_self", position=position_dodge(0.8),add=c("mean_se"), 
                     fill='AQcutoff', width=0.5, color = 'gray', linewidth = 1,
                     add.params=list(color='black', alpha=0.4, size=1, width=0.1),title= c(''), 
                     ylab=c('Social basis function \n use in (self decisions)'), xlab="") + scale_fill_manual(values = color_palette[c(3:4)]) + 
  theme_pubr(base_size=24) + theme(legend.position = "none")


Pmer.plot <- ggbarplot(Fulldata, "AQcutoff","SBF_partner", position=position_dodge(0.8),add=c("mean_se"), 
                      fill='AQcutoff', width=0.5, color = 'gray', linewidth = 1,
                      add.params=list(color='black', alpha=0.4, size=1, width=0.1),title= c(''), 
                      ylab=c('Social basis function \n use in (partner decisions)'), xlab="") + scale_fill_manual(values = color_palette[c(5:6)]) + 
  theme_pubr(base_size=24) + theme(legend.position = "none")

#calculate how many participants above AQ cutoff for each experiment
summary_data <- Fulldata %>%
  group_by(ver) %>% summarise(total = n(), above_count = sum(AQcutoff == 'aboveAQcutoff'),
                              percentage = round(100 * above_count / total, 1))

## Fig.10D-F: behavioural marker, split by AQ cutoff in lab experiment
#-----------------------------------------------------------------------------------------------------------------------
lab_raincloud_data <- lab %>% dplyr::select(AQcutoff, SBF_self, SBF_partner, corSP) %>%
  tidyr::pivot_longer( cols = c(SBF_self, SBF_partner, corSP),
                   names_to = "outcome",
                  values_to = "score") %>%
  dplyr::mutate(AQcutoff = factor(AQcutoff, levels = c("belowAQcutoff", "aboveAQcutoff")),
    AQcutoff_x = as.numeric(AQcutoff),
    outcome = factor(outcome, levels = c("corSP", 'SBF_self','SBF_partner')))

make_lab_AQ_raincloud <- function(outcome_name) {
  plot_data <- dplyr::filter(lab_raincloud_data, outcome == outcome_name)
  below_data <- dplyr::filter(plot_data, AQcutoff == "belowAQcutoff")
  
  plot <- ggplot(plot_data,aes(x = AQcutoff_x, y = score, fill = AQcutoff, color = AQcutoff, group = AQcutoff)) +
    geom_flat_violin(data = below_data,position = position_nudge(x = 0.2), adjust = 1.5, trim = FALSE, alpha = 0.45) + 
    geom_boxplot(data = below_data,aes(x = AQcutoff_x + 0.2), width = 0.09, outlier.shape = NA, alpha = 0.55, linewidth = 0.5) +
    geom_point(position = position_jitter(width = 0.12), size = 5, alpha = 0.5) +
    scale_x_continuous(breaks = c(1, 2),labels = c("Below AQ cutoff", "Above AQ cutoff"),
                       expand = expansion(mult = c(0.12, 0.35))) +
    scale_fill_manual(values = c(belowAQcutoff = color_palette[7], aboveAQcutoff = extOrg[8])) +
    scale_color_manual(values = c(belowAQcutoff = color_palette[7], aboveAQcutoff = extOrg[8])) +
    labs( title ='', x = "", y = outcome_name, fill = "AQ cutoff",  color = "AQ cutoff"  ) +
    theme_pubr(base_size = 20) +
    theme(legend.position = "none")
  plot
}
lab_selfbias <- make_lab_AQ_raincloud("corSP")
lab_SBF_self <- make_lab_AQ_raincloud("SBF_self")
lab_SBF_partner <- make_lab_AQ_raincloud("SBF_partner")


Sfig10 <- ggarrange(Sbias.plot, Smer.plot, Pmer.plot,lab_selfbias,lab_SBF_self,lab_SBF_partner, ncol=3,nrow=2, heights=c(2,2), widths = c(1,1), 
          labels=c('A','B','C','D','E','F'), vjust=2, hjust=0, align='hv',font.label = list(size = 36, color = "black", face = "bold"))

ggsave(file.path(path_figs, paste0('Sfig10_A_F_',Sys.Date(),'.pdf')),plot=Sfig10,dpi = 300, device = "pdf",height=16,width=21)


#----------------------------------------------------------------------------------------------------------
# Supplementary Figure S11_B_E the relationship is not masked by other maerkers of individual differences
#----------------------------------------------------------------------------------------------------------
source('environPrepar.R')

### supplement Fig.S11BC: model specific on Online Experiment 3 (N> 800)
#-----------------------------------------------------------------------------------
online3_bin <- online3[online3$Gender !=0, ]
online3_bin$Gender <- factor(online3_bin$Gender,levels = c(1,2),labels = c('Male','Female'))
VOI <- c('SBF_self','SBF_partner','corSP', 'AQ_total','Age','SRP_total','LA_total','RSS_total','BDI_total','GAD_total','IQ')
online3_z <- zscoreVars(online3_bin, VOI)
online3_z$AQ_square <- online3_z$AQ_total^2

# Run the model and plot the GLM regression coefficient
#-----------------------------------------------------------------
cols    <- c(color_palette[c(5,6)])
online3_reg_plot <- visualGLM_online3(online3_z,'',cols)


### supplement Fig.S11DE: model specific on whole dataset (N =1621)
#-----------------------------------------------------------------------------------
Fulldata_bin <- Fulldata[Fulldata$Gender !=0,]
Fulldata_bin$Gender <- factor(Fulldata_bin$Gender,levels = c(1,2),labels = c('Male','Female'))
VOI <- c('SBF_self','SBF_partner','corSP', 'AQ_total','Age','SRP_total')
Fulldata_z <- zscoreVars(Fulldata_bin,VOI)
Fulldata_z$AQ_square <- Fulldata_z$AQ_total^2

# Run the model and plot the GLM regression coefficient
#-----------------------------------------------------------------
cols   <- c(extGy[c(6,8)])
fulldata_reg_plot <- visualGLM_fulldata_v4(Fulldata_z,'',cols)


###Plot supplementary Fig.S11
#----------------------------------------------------------------------------
supple_FigS11 = ggarrange(online3_reg_plot,fulldata_reg_plot,ncol=2,nrow=1, heights=c(2,2), widths = c(1,1), 
                      vjust=2, hjust=0, align='hv',font.label = list(size = 36, color = "black", face = "bold"))
ggsave(file.path(path_figs, paste0('SFig11BCDE_',Sys.Date(),'.pdf')),plot=supple_FigS11,dpi = 300, device = "pdf",height=12,width=16)

