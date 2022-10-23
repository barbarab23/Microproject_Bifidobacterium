# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library(tidyverse)
library(reshape2)
library(viridis)


# Define functions --------------------------------------------------------
source(file = "./scripts/99_proj_func.R")


# Load data ---------------------------------------------------------------
bifido_heat <-  read.table("./data/03_bifido_heatmap_prep.tsv", sep = '\t', header = TRUE) %>% group_by(weeks, baby_id)

#convert baby_id to character so it is not treated as an integer by ggplot
bifido_heat <- bifido_heat %>% mutate(baby_id = as.factor(baby_id))


# Visualize data and write data -------------------------------------------
#get list of bifido species, ergo removing weeks [1] and baby_id [2]
bifido_list <- colnames(bifido_heat)[-1:-2]

#skip first two columns(weeks and baby id) and loop through the rest, generating a figure for each bifido species
for (i in 1:length(bifido_list)){
  #retrive column name to be able to generate file names and select column
  col_name <- bifido_list[i]
  fig_save <- paste0('./results/05_Heatmap_',col_name, '.png')
  fig_title <- gsub('B_', 'B. ', col_name)
  
  #select data to plot. Any_of selects column using string.
  df2 <- bifido_heat %>% select(weeks, baby_id, any_of(col_name))
  
  #setting same limits on color scale for all graphs by setting the low, mid and high colors using viridis color scheme, 
  #setting a fixed break, and limits going from 0-100%
  fig <- ggplot(df2, aes_string(x = 'weeks', y='baby_id', fill=col_name))+
    geom_tile()+
    scale_fill_gradient2(low = viridis(3)[1], mid= viridis(3)[2], high =viridis(3)[3], 
                         midpoint=50, breaks=seq(0,100,25), limits=c(0,100))+
    ggtitle(fig_title)+
    xlab('Weeks after birth')+
    ylab('Baby ID')+
    labs(fill='Abundance\n(%)') + 
    scale_y_discrete(guide = guide_axis(n.dodge = 2))+
    theme(plot.title = element_text(hjust = 0.5, size=30, face='bold'), 
          axis.title.x = element_text(hjust = 0.5, size=24), 
          axis.title.y = element_text(hjust = 0.5, size=24), 
          legend.text=element_text(size=14),
          legend.title = element_text(size = 14, face='bold'),
          axis.text.x= element_text(size=18),
          axis.text.y= element_text(size=7))
  
  ggsave(filename =  fig_save,
         plot = fig,
         device = 'png',
         width= 3500,
         height = 3000,
         units = 'px')
  writeLines(paste('Generated plot:', fig_save))
  
}
