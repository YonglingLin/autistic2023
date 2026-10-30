
#-----------------------------
# 0.read necessary packages
#-----------------------------
want = c("tidyverse", "rstatix", "readxl", "ggpubr", 
         "bruceR", "corrplot",'cocor','RColorBrewer',
         'ppcor','mediation','patchwork', 'cowplot','readr','BayesFactor','lmtest')

#patchwork just used for ggplot2

have = want %in% rownames(installed.packages())

if ( any(!have) ) { install.packages( want[!have] ) }

lapply(want, require, character.only = TRUE) # Now load them all


#----------------------------------------------
# 1.prepare all functions we need
#----------------------------------------------
script_files <- list.files(path= 'script_utils', full.names = TRUE) 
                                              # get a list of all script files in the folder
lapply(script_files, source)                  # Source each script file

source('PlotRainclouds/R_rainclouds.R')



#---------------------------------------
# 2.set up the remaining of envioronment
#---------------------------------------

n <- 60  # select 60 different colors
qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))

#new: using RColorBrewer palette -> Qualitative -> Paired
display.brewer.all()
color_palette <- brewer.pal(12,'Paired')
color_palette <- color_palette[c(1,2,3,4,9,10,7,8)]
color_palette_paired <- color_palette[c(1, 3, 5, 7, 2, 4, 6, 8)]

extBlue <- brewer.pal(9,'Blues')
extGreen <- brewer.pal(9,'Greens')
extPuRd <- brewer.pal(9,'PuRd')
extOrg <- brewer.pal(9,'Oranges')
extGy <- brewer.pal(9,'RdGy') # 6,7,9