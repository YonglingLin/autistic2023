#clear existing data and graphics and set current wd
rm(list=ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#--------------------------------------------------------------------------------
# 0.load dataset, run Bayesian regression accounting for potential confounds.
#--------------------------------------------------------------------------------

source('environPrepar.R')

rawdata = '../1_data/outfrommat'
datapath='../3_ana_out'
path_figs='../5_figs'

Fulldata <- read.csv(file.path(datapath,'Fulldata_20261020.csv'), header =TRUE,sep=',')
online3 <- read.csv(file.path(datapath,'online3_20261020.csv'), header =TRUE,sep=',')


#--------------------------------------------------------------------------------
# 1. run Bayesian regression accounting for study version
#--------------------------------------------------------------------------------

VOI <- c('SBF_self','SBF_partnre','corSP', 'AQ_total','Age','Gender','SRP_total','LA_total','RSS_total')
S0G1 <- zscoreVars(S0G1, VOI)
S0G1$AQ_square <- S0G1$AQ_total^2

cols    <- c(color_palette[c(1)])
S0sbias <- visualGLM_S0_selfbias(S0G1,'',cols)
cols  <- c(color_palette[c(1,2)])
S0som <- visualGLM_S0_som(S0G1,'',cols)


set.seed(123)
bfnull_study_corSP <- lmBF(corSP ~ ver, data = Fulldata, progress = F)
bfAQ_study_corSP <- lmBF(corSP ~ ver + AQ_total, data = Fulldata, progress = F)
bfnull_study_corSP/bfAQ_study_corSP

set.seed(123)
bfnull_study_SBF_self <- lmBF(SBF_self ~ ver, data = Fulldata, progress = F)
bfAQ_study_SBF_self <- lmBF(SBF_self ~ ver + AQ_total, data = Fulldata, progress = F)
bfnull_study_SBF_self/bfAQ_study_SBF_self

set.seed(123)
bfnull_study_SBF_partner <- lmBF(SBF_partner ~ ver, data = Fulldata, progress = F)
bfAQ_study_SBF_partner <- lmBF(SBF_partner ~ ver + AQ_total, data = Fulldata, progress = F)
bfnull_study_SBF_partner/bfAQ_study_SBF_partner


#--------------------------------------------------------------------------------
# 2. run Bayesian regression accounting for potential confounds.
#--------------------------------------------------------------------------------

#################################################################################
## Model specific on Online Experiment 3 (N> 800): supplement Fig.S11BC
#################################################################################

online3_bin <- online3[online3$Gender !=0, ]
online3_bin$Gender <- factor(online3_bin$Gender,levels = c(1,2),labels = c('Male','Female'))
VOI <- c('SBF_self','SBF_partner','corSP', 'AQ_total','Age','SRP_total','LA_total','RSS_total','BDI_total','GAD_total','IQ')
online3_z <- zscoreVars(online3_bin, VOI)
online3_z$AQ_square <- online3_z$AQ_total^2


# Bayesian null hypothesis test - self-bias
set.seed(350)
bfnull_online3     <- lmBF(corSP ~ Age + Gender + SRP_total + LA_total + RSS_total + BDI_total + GAD_total + IQ, data = online3_z, progress = F)
bfnull_online3 <- recompute(bfnull_online3, iterations = 500000)

bfAQ_online3       <- lmBF(corSP ~ Age + Gender + SRP_total + LA_total + RSS_total + BDI_total + GAD_total + IQ + AQ_total, data = online3_z, progress = F)
bfAQ_online3 <- recompute(bfAQ_online3, iterations = 500000)

bfAQsquare_online3 <- lmBF(corSP ~ Age + Gender + SRP_total + LA_total + RSS_total + BDI_total + GAD_total + IQ + AQ_total + AQ_square, data = online3_z, progress = F)
bfAQsquare_online3 <- recompute(bfAQsquare_online3, iterations = 500000)

bfnull_online3 /bfAQ_online3      # null vs. AQ
bfAQ_online3/bfAQsquare_online3   # AQ vs. AQ_square

# Bayesian null hypothesis test - SBF use in self decisions
set.seed(350)
bfnull_online3     <- lmBF(SBF_self ~ Age + Gender + SRP_total + LA_total + RSS_total + BDI_total + GAD_total + IQ, data = online3_z, progress = F)
bfnull_online3 <- recompute(bfnull_online3, iterations = 500000)

bfAQ_online3       <- lmBF(SBF_self ~ Age + Gender + SRP_total + LA_total + RSS_total + BDI_total + GAD_total + IQ + AQ_total, data = online3_z, progress = F)
bfAQ_online3 <- recompute(bfAQ_online3, iterations = 500000)

bfAQsquare_online3 <- lmBF(SBF_self ~ Age + Gender + SRP_total + LA_total + RSS_total + BDI_total + GAD_total + IQ + AQ_total + AQ_square, data = online3_z, progress = F)
bfAQsquare_online3 <- recompute(bfAQsquare_online3, iterations = 500000)

bfnull_online3 /bfAQ_online3      # null vs. AQ
bfAQ_online3/bfAQsquare_online3   # AQ vs. AQ_square

# Bayesian null hypothesis test - SBF use in partner decisions
set.seed(350)
bfnull_online3     <- lmBF(SBF_partner ~ Age + Gender + SRP_total + LA_total + RSS_total + BDI_total + GAD_total + IQ, data = online3_z, progress = F)
bfnull_online3 <- recompute(bfnull_online3, iterations = 500000)

bfAQ_online3       <- lmBF(SBF_partner ~ Age + Gender + SRP_total + LA_total + RSS_total + BDI_total + GAD_total + IQ + AQ_total, data = online3_z, progress = F)
bfAQ_online3 <- recompute(bfAQ_online3, iterations = 500000)

bfAQsquare_online3 <- lmBF(SBF_partner ~ Age + Gender + SRP_total + LA_total + RSS_total + BDI_total + GAD_total + IQ + AQ_total + AQ_square, data = online3_z, progress = F)
bfAQsquare_online3 <- recompute(bfAQsquare_online3, iterations = 500000)

bfnull_online3 /bfAQ_online3      # null vs. AQ
bfAQ_online3/bfAQsquare_online3   # AQ vs. AQ_square


#################################################################################
## Model specific on full dataset (N = 1,621): supplement Fig.S11DE
#################################################################################
#-----------------------------------------------------------------------------------
Fulldata_bin <- Fulldata[Fulldata$Gender !=0,]
Fulldata_bin$Gender <- factor(Fulldata_bin$Gender,levels = c(1,2),labels = c('Male','Female'))
VOI <- c('SBF_self','SBF_partner','corSP', 'AQ_total','Age','SRP_total')
Fulldata_z <- zscoreVars(Fulldata_bin,VOI)
Fulldata_z$AQ_square <- Fulldata_z$AQ_total^2

# Bayesian null hypothesis test - self-bias
set.seed(350)
bfnull <- lmBF(corSP ~ Age + Gender + SRP_total + ver, data = Fulldata_z, progress = F)
bfnull <- recompute(bfnull, iterations = 500000)

bfAQ <- lmBF(corSP ~ Age + Gender + SRP_total +  AQ_total + ver, data = Fulldata_z, progress = F)
bfAQ <- recompute(bfAQ,iterations = 500000)

bfAQsquare <- lmBF(corSP ~ Age + Gender + SRP_total + AQ_total + AQ_square + ver, data =  Fulldata_z, progress = F)
bfAQsquare <- recompute(bfAQsquare,iterations = 500000)

bfnull/bfAQ
bfAQ/bfAQsquare

# Bayesian null hypothesis test - SBF use in self decisions
set.seed(350)
bfnull <- lmBF(SBF_self ~ Age + Gender + SRP_total + ver, data = Fulldata_z, progress = F)
bfnull <- recompute(bfnull, iterations = 500000)

bfAQ <- lmBF(SBF_self ~ Age + Gender + SRP_total +  AQ_total + ver, data = Fulldata_z, progress = F)
bfAQ <- recompute(bfAQ,iterations = 500000)

bfAQsquare <- lmBF(SBF_self ~ Age + Gender + SRP_total + AQ_total + AQ_square + ver, data = Fulldata_z, progress = F)
bfAQsquare <- recompute(bfAQsquare,iterations = 500000)

bfnull/bfAQ
bfAQ/bfAQsquare

# Bayesian null hypothesis test - SBF use in partner decisions
set.seed(350)
bfnull <- lmBF(SBF_partner~ Age + Gender + SRP_total +ver, data = Fulldata_z, progress = F)
bfnull <- recompute(bfnull, iterations = 500000)

bfAQ <- lmBF(SBF_partner ~ Age + Gender + SRP_total +  AQ_total +ver, data = Fulldata_z, progress = F)
bfAQ <- recompute(bfAQ,iterations = 500000)

bfAQsquare <- lmBF(SBF_partner ~ Age + Gender + SRP_total + AQ_total + AQ_square + ver, data = Fulldata_z, progress = F)
bfAQsquare <- recompute(bfAQsquare,iterations = 500000)

bfnull/bfAQ
bfAQ/bfAQsquare