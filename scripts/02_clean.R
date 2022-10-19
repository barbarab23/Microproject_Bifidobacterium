# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library(tidyverse)

# Define functions --------------------------------------------------------
source(file = "./scripts/99_proj_func.R")


# Load data ---------------------------------------------------------------
bifido_meta <- read.table("./raw/bifido_meta.tsv", sep = '\t', header = TRUE)
family_meta <- read.table("./raw/family_meta.tsv", sep = '\t', header = TRUE)

# Wrangle data ------------------------------------------------------------
#main family plot
family_bin <- binDataWeeks(data = family_meta, grep_pattern = '^f_', gsub_pattern = 'f__', gsub_replace = '')

#family vaginal
family_vaginal_bin <- filterDelivery(data = family_meta, selection_list = c('Vaginal', 'Vaginal-instrumental'), grep_pattern = '^f_', gsub_pattern = 'f__', gsub_replace = '')
#family C-section
family_Csection_bin <- filterDelivery(data = family_meta, selection_list = c('Planned_C-section', 'Acute_C-section'), grep_pattern = '^f_', gsub_pattern = 'f__', gsub_replace = '')

#main bifido plot
bifido_bin <- binDataWeeks(data = bifido_meta, grep_pattern = '^g_', gsub_pattern = 'g__Bifidobacterium.s__Bifidobacterium_', gsub_replace = 'B_') %>% select(-g__Bifidobacterium)

#bifido vaginal
bifido_vaginal_bin <- filterDelivery(data = bifido_meta, selection_list = c('Vaginal', 'Vaginal-instrumental'), grep_pattern = '^g_', gsub_pattern = 'g__Bifidobacterium.s__Bifidobacterium_', gsub_replace = 'B_')  %>% select(-g__Bifidobacterium)

#bifido C-section
bifido_Csection_bin <- filterDelivery(data = bifido_meta, selection_list = c('Planned_C-section', 'Acute_C-section'), grep_pattern = '^g_', gsub_pattern = 'g__Bifidobacterium.s__Bifidobacterium_', gsub_replace = 'B_') %>% select(-g__Bifidobacterium)


#bifido heatmap
bifido_heatmap <- binDataWeeks(data = bifido_meta, grep_pattern = '^g_', keep = 'baby_id', gsub_pattern = 'g__Bifidobacterium.s__Bifidobacterium_', gsub_replace = 'B_')


# Write data --------------------------------------------------------------
dir.create('./data', showWarnings = F)
write_tsv(x = family_bin,
          file = "./data/02_family_bin.tsv")

write_tsv(x = family_vaginal_bin,
          file = "./data/02_family_vaginal_bin.tsv")

write_tsv(x = family_Csection_bin,
          file = "./data/02_family_Csection_bin.tsv")

write_tsv(x = bifido_bin,
          file = "./data/02_bifido_bin.tsv")

write_tsv(x = bifido_vaginal_bin,
          file = "./data/02_bifido_vaginal_bin.tsv")

write_tsv(x = bifido_Csection_bin,
          file = "./data/02_bifido_Csection_bin.tsv")

write_tsv(x = bifido_heatmap,
          file = "./data/02_bifido_heatmap.tsv")

