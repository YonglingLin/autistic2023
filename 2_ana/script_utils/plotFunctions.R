
#----------------------
#1. plotHistogram
#-----------------------
plotHistogram <- function(data,xlabel,nbreak, n){
  hist(data, xlab=xlabel, col='grey', breaks = nbreak,
       main = paste(xlabel, '_', n,'participants')) #nrow(data),
  
}


overlayHistogram <- function(data_list,xlabel,col_vector){
  for (i in 1:length(data_list)) {
    if (i==1) {
      hist(data_list[[1]],xlab=xlabel, col=col_vector[1], #ylim=c(0,nrow(df_total)), 
           main = paste('Histogram of', xlabel)) 
    }
    else{
      browser()
      hist(data_list[[i]], col=alpha(col_vector[i], alpha= 0.1), add=TRUE)
    }
  }
}

# already forget what is that...:(
overlayHistogram1 <- function(data_list,nx,titl){
  
  # Initialize an empty data frame
  test <- data.frame(var=character(0), scores = numeric(0))
  
  # Loop through data_list and nx
   
  for (i in seq_along(data_list)){
    test <- rbind(test, data.frame(var = rep(nx[i],length(data_list[[i]])), scores = data_list[[i]]))
  }

  ggplot(test, aes(x = scores, fill=var),palette = 'jco') +  
    geom_histogram(color='black', alpha=0.2, position='identity',bins=10, size=1.5) + 
      labs(title=titl) + theme(plot.title = element_text(size = 30)) +  theme_pubr(base_size=25)

}



#-------------------------------------------------
# 2. corFunctions(param1, param2, param3, param4)
#-------------------------------------------------

#param1: data;
#param2: y-axis data;
#param3: x-axis data;
#param4: 1: facet_by, !=1 plot in a figure.;


corFunctions <- function(data,Yvar,Xvar,Yfacet=0){
  
  if (Yfacet != 1){
    

    if (length(Yvar) >1){
     Fig <- data %>% pivot_longer(col=Yvar, names_to="type", values_to="scores") 
     
     stepleng <- max(Fig$scores)/20
     
     label_y <- c(max(Fig$scores) + seq(stepleng, stepleng*length(Yvar), length.out = length(Yvar)))
     
     Fig %>% 
       ggscatter(x=Xvar, y="scores", add = "reg.line",add.params=list(size=4,  fill = 'lightgrey'), palette = 'jco', #
                 conf.int = T, shape = "type", alpha = 0.5, color = c('type'), size=5) +stat_cor(aes(color=type), size=10, label.y = label_y) +
                   theme_pubr(base_size=25) +
       scale_fill_manual(values = c('lightblue', 'darkblue'))+ scale_color_manual(values = c("#1F78B4","#A6CEE3"))

    } else{
    
      data %>% 
        ggscatter(x= Xvar, y= Yvar, add = "reg.line", add.params=list(size=4, fill='lightgrey'), palette = 'jco',
                  conf.int = T, color="grey", shape=12, size=5, font.label = c(42, "plain")) +
      stat_cor(size=10) + theme_pubr(base_size=25)
    
     }
    
  } else if (Yfacet == 1){
    
    Fig <- data %>% pivot_longer(cols=Yvar, names_to="type", values_to="scores")
    
    Fig$type <- factor(Fig$type, levels= Yvar)  # arrange at the specific order ('Yvar' order)
    
    stepleng <- max(Fig$scores)/20
    label_y <- c(max(Fig$scores) + seq(stepleng, stepleng * length(Yvar), length.out = length(Yvar)))
    
    Fig %>%
      ggscatter( x = Xvar, y="scores", add = "reg.line",add.params=list(size=3, color="grey",fill='lightgray'),palette = 'jco',
                facet.by=c("type"),conf.int = T, shape = "type",  color = c("type"), size=5) +
      stat_cor(aes(color=type),size=8, color="black", label.y = label_y) + theme_pubr(base_size=30)    
    
  }
 
}



#barFunctions(param1, param2, param3)#
#param1: data;
#param2: all variables of interest;
#param3: title;


barFunctions <- function(data, vars, title, color){
  
    X <- data %>% pivot_longer(cols = vars, names_to = 'type', values_to = 'scores') 
  
    X %>%
      ggbarplot(x="type",y="scores", position=position_dodge(0.8),add=c("mean_se"), width=0.5, fill=color, color = c('black'), size = 2,#,"blue"
                add.params=list(color=c('black'), alpha=0.4, size=1, width=0),title=title, ylab=title,
                xlab="") + geom_jitter(colour= c("black"),shape=19 , size=5, width = 0.05, alpha=0.3, aes())+
      theme_pubr(base_size=30) + scale_fill_brewer(palette = "Dark2") + theme(plot.title=element_text(hjust=0.5)) #+
      #stat_compare_means(method = "t.test", paired= TRUE, size=8)

}



####corMatrixFunctions(param1, param2)####
#param1: sub-data;
#param2: default: plot the R coffcient; type != 1: plot the p value;


corMatrixFunctions <- function(subdata, title, type=1){
  
  Acor = cor(subdata, use = "pairwise.complete.obs")
  
  if(type != 1){
    
    testRes1. = cor.mtest(subdata, conf.level = 0.95)
    corrplot(Acor, p.mat = testRes1.$p, sig.level = c(0.001, 0.01, 0.05), method="color", col =  COL2("RdBu",n=20),
             insig = 'label_sig', pch.col = 'red', pch.cex = 2, tl.col="black",  cex.main = 1.5, title=title, 
             tl.cex=1.5, cl.length = 5, order = 'original', addrect = 2) 
  
    } else{  # default plot
     
      corrplot(Acor, method = 'color', col =  COL2("RdBu",n=20),cl.length = 5, order = 'original',title = title,
               addCoef.col = 'black', tl.col="black", number.cex= 1) #+ title(main= title, line=1, cex.main=1.5) 
    
  }
  
}


####ggpairFunctions(param1, param2)####

ggpairFunctions <- function(data, vars, title, ylab){ 
  X <- data  %>% pivot_longer(cols = vars[2:length(vars)], names_to = 'type', values_to = 'scores')
    
  ggpaired(X, x="type",y="scores",id=vars[1], fill = 'type', color= "gray", width=0.8, add = 'jitter', point.size=4, title = title, #palette=c("red",'blue'),
             ylab=ylab, line.color="grey",line.size=0.8, short.panel.labs = FALSE)  + 
    theme_pubr(base_size=20)+ scale_fill_brewer(palette = 'Accent')   
  
}
#param: vars which needs to include ids.
#param2: vars which needs to include ids (ids must be the first variable).


