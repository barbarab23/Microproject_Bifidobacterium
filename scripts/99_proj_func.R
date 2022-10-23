
filterDelivery <- function(data, selection_list, grep_pattern, gsub_pattern, gsub_replace){
  df1 <- data %>% filter(mode_delivery %in% selection_list)
  df1_bin <- binDataWeeks(data = df1, grep_pattern = grep_pattern, gsub_pattern = gsub_pattern, gsub_replace = gsub_replace) 
  return(df1_bin)
}

binDataWeeks <- function(data, keep=NULL, grep_pattern, gsub_pattern, gsub_replace){
  #create bins for 24+1 weeks in days, and inlcude maximum days
  week_bin <- c(seq(0,25*7-1, by = 7),max(data$Days_after_birth))
  #create labels for bins. Should be length(bins)-1
  week_label <- c(seq(1,24), '>24')
  
  #grab all columns of bacteria (they all start with string provided in grep_pattern). grepl creates a TRUE/FALSE, and 
  #which provides indexes for the TRUE values. Use the indices to choose column names which match the grep_pattern
  bacteria_list <- colnames(data)[which(grepl(grep_pattern, colnames(data)))]
  
  #bin data by weeks in days, and label by week
  meta_data <- data %>% drop_na() %>% mutate(weeks = cut(Days_after_birth, breaks = week_bin, labels=week_label, include.lowest=T)) 
  
  #select only weeks and bacteria columns, and remove rows with label >24 in weeks. any_of allows you to use a string
  meta_data <- meta_data %>% select(weeks, any_of(keep),any_of(bacteria_list)) %>% filter(weeks != '>24')
  
  colnames(meta_data) <- gsub(gsub_pattern, gsub_replace, colnames(meta_data))
  return(meta_data)
}

group_percent <- function(data){
  sum_data <- aggregate(. ~weeks, data, sum)
  
  percent_group <- sum_data %>% mutate('Total' = rowSums(select(.,-weeks))) %>% mutate(across(-c(weeks, Total), .fns = ~./Total*100)) %>% select(-Total)
  
  return(percent_group)
}

getMean2percent <- function(data){
  bacteria_group_2 <- data %>% summarise(across(-weeks, mean)) %>% pivot_longer(everything(), names_to = 'Bacteria', values_to = 'Mean') %>% 
    filter(Mean >2) %>% pull(Bacteria) %>% sort() %>% rev()
  
  return(bacteria_group_2)
}

prepareDataFig<- function(data, bacteria_mean2){
  sum_other <- data %>% select(-any_of(bacteria_mean2)) %>% transmute('Other' = rowSums(select(.,-weeks)))
  
  sum_group <- cbind(data %>% select(weeks, any_of(bacteria_mean2)),sum_other)
  
  #pivot to long format for ggplot
  percent_long <- melt(sum_group, id.vars='weeks')
  
  #rename colnames to make more sense
  colnames(percent_long) <- c('weeks', 'family', 'value')
  
  return(percent_long)
}

figGutMicrobiome <- function(data, title=NULL, show_legend=T){
  
  data <- data %>% mutate(family = gsub('_', '. ', family))
  
  #factor the families to determine order in legend
  col_list <- data %>% pull(family) %>% unique()
  bacteria_list <- col_list[col_list != 'Other']
  
  data <- data %>% mutate(family = factor(family, levels=c("Other", bacteria_list)))
  
  fig <- ggplot(data, aes(x=as.numeric(weeks), y=value, fill=family))+geom_area()+
    scale_fill_viridis(discrete = T)+
    ggtitle(title)+
    xlab('Weeks after birth')+
    ylab('Relative abundance (%)')+
    labs(fill='') + 
    scale_x_continuous(expand = c(0, 0), limits = c(1, NA), breaks = seq(1,24, by=1)) + 
    scale_y_continuous(expand = c(0, 0), limits = c(0, NA))+
    theme(plot.title = element_text(hjust = 0.5, size=30, face='bold'), axis.title.x = element_text(hjust = 0.5, size=24), 
          axis.title.y = element_text(hjust = 0.5, size=24), legend.text=element_text(size=24), axis.text.x= element_text(size=18),
          axis.text.y= element_text(size=18))
  
  ##hide legend for subplots
  if (show_legend == F){
    fig <- fig +theme(legend.position="none")
  }
  return(fig)
}

figSubGutMicrobiome <- function(data_1, data_2, main_title = NULL) {
  
  #create figure for vaginal modes of delivery. Provide title, use the bacteria list as for main plot, and hide the legend
  fig_vaginal <-  figGutMicrobiome(data_1, title = paste0(main_title,"\nVaginal birth"), show_legend = F)
  #same as above for C-section
  fig_Csection <-  figGutMicrobiome(data_2, title = "C-section", show_legend = F)
  
  #get legend from vaginal figure to use a shared legend further down using cowplot
  legend <- get_legend(fig_vaginal+theme(legend.position = 'right'))
  
  #use cowplot to create subplots with shared axis. Hide X-axis text for first plot, and add bottom and left margins.Hide y-axis text for both plots.
  fig <- plot_grid(
    fig_vaginal + theme(axis.text.x = element_blank(),
                        axis.ticks.x = element_blank(),
                        axis.title.x = element_blank(),
                        axis.title.y = element_blank(),
                        plot.margin = unit(c(0.5,0,0.5,2), 'cm')
    ),
    fig_Csection + theme(axis.title.y = element_blank(),
                         plot.margin = unit(c(0,0,0.5,2), 'cm')),
    nrow = 2, 
    align = 'v'
  )
  
  #add the legend as a subplot to the above subplots. Add Y-axis text as annotation
  fig <- plot_grid(fig,legend, rel_widths = c(1, .25), ncol=2)+
    draw_label("Relative abundance (%)", x=  0, y=0.5, vjust= 2.5, angle=90, size=24)
  return(fig)
}