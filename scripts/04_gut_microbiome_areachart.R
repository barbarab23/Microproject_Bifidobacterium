# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library(tidyverse)
library(reshape2)
library(viridis)
library(cowplot)


# Define functions --------------------------------------------------------
source(file = "./scripts/99_proj_func.R")


# Load data ---------------------------------------------------------------
family_prep <- read.table("./data/03_family_prep.tsv", sep = '\t', header = TRUE)
bifido_prep <- read.table("./data/03_bifido_prep.tsv", sep = '\t', header = TRUE)

family_vaginal_prep <- read.table("./data/03_family_vaginal_prep.tsv", sep = '\t', header = TRUE)
family_Csection_prep <- read.table("./data/03_family_Csection_prep.tsv", sep = '\t', header = TRUE)

bifido_vaginal_prep <- read.table("./data/03_bifido_vaginal_prep.tsv", sep = '\t', header = TRUE)
bifido_Csection_prep <- read.table("./data/03_bifido_Csection_prep.tsv", sep = '\t', header = TRUE)
# Visualize data ----------------------------------------------------------


family_fig <- figGutMicrobiome(data = family_prep, title = "Infant gut microbiome composition (family level)")
bifido_fig <- figGutMicrobiome(data = bifido_prep, title = "Infant gut microbiome composition (Bifido level)")

family_sub_fig <- figSubGutMicrobiome(data_1 = family_vaginal_prep, data_2 = family_Csection_prep, main_title = "Infant gut microbiome composition (family level)")

bifido_sub_fig <- figSubGutMicrobiome(data_1 = bifido_vaginal_prep, data_2 = bifido_Csection_prep, main_title = "Infant gut microbiome composition (Bifido level)")


# Write data --------------------------------------------------------------
dir.create('./results', showWarnings = F)

#list of figure names
save_list <- c('family_fig', 'bifido_fig', 'family_sub_fig', 'bifido_sub_fig')

#loop through figure list and output figures
for (i in 1:length(save_list)){
  
  fig_save <- paste0('./results/04_', save_list[i],'.png') 
  
  ggsave(filename =  fig_save,
         plot = get(save_list[i]),
         device = 'png',
         width= 6000,
         height = 3000,
         units = 'px',
         bg='white')
  
  writeLines(paste('Generated plot:', fig_save))
}
