# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library(tidyverse)
library(reshape2)


# Define functions --------------------------------------------------------
source(file = "./scripts/99_proj_func.R")


# Load data ---------------------------------------------------------------

family_bin <- read.table("./data/02_family_bin.tsv", sep = '\t', header = TRUE)
bifido_bin <- read.table("./data/02_bifido_bin.tsv", sep = '\t', header = TRUE)
family_vaginal_bin <- read.table("./data/02_family_vaginal_bin.tsv", sep = '\t', header = TRUE)
family_Csection_bin <- read.table("./data/02_family_Csection_bin.tsv", sep = '\t', header = TRUE)

bifido_vaginal_bin <- read.table("./data/02_bifido_vaginal_bin.tsv", sep = '\t', header = TRUE)
bifido_Csection_bin <- read.table("./data/02_bifido_Csection_bin.tsv", sep = '\t', header = TRUE)

bifido_heatmap <- read.table("./data/02_bifido_heatmap.tsv", sep = '\t', header = TRUE)

# Wrangle data ------------------------------------------------------------
family_percent <- group_percent(family_bin)
bifido_percent <- group_percent(bifido_bin)

family_vaginal_percent <- group_percent(family_vaginal_bin)
family_Csection_percent <- group_percent(family_Csection_bin)

bifido_vaginal_percent <- group_percent(bifido_vaginal_bin)
bifido_Csection_percent <- group_percent(bifido_Csection_bin)

family_bacteria_mean2 <- getMean2percent(family_percent)
bifido_bacteria_mean2 <- getMean2percent(bifido_percent)

family_prepared <- prepareDataFig(data = family_percent, bacteria_mean2 = family_bacteria_mean2)
bifido_prepared <- prepareDataFig(data = bifido_percent, bacteria_mean2 = bifido_bacteria_mean2)

family_vaginal_prep <- prepareDataFig(data = family_vaginal_percent, bacteria_mean2 = family_bacteria_mean2)
family_Csection_prep <- prepareDataFig(data = family_Csection_percent, bacteria_mean2 = family_bacteria_mean2)

bifido_vaginal_prep <- prepareDataFig(data = bifido_vaginal_percent, bacteria_mean2 = bifido_bacteria_mean2)
bifido_Csection_prep <- prepareDataFig(data = bifido_Csection_percent, bacteria_mean2 = bifido_bacteria_mean2)

#calculate percentage. g__Bifidobacterium contains the relative abundance for all bifido species. Replace generated NAs with 0. Group by weeks and baby id
bifido_heatmap_prep <- bifido_heatmap %>% mutate(across(-c(weeks, baby_id), .fns = ~./g__Bifidobacterium*100)) %>% select(-g__Bifidobacterium) %>%
  replace(is.na(.),0) 

# Write data --------------------------------------------------------------
write_tsv(x = family_prepared,
          file = "./data/03_family_prep.tsv")

write_tsv(x = family_vaginal_prep,
          file = "./data/03_family_vaginal_prep.tsv")

write_tsv(x = family_Csection_prep,
          file = "./data/03_family_Csection_prep.tsv")

write_tsv(x = bifido_prepared,
          file = "./data/03_bifido_prep.tsv")

write_tsv(x = bifido_vaginal_prep,
          file = "./data/03_bifido_vaginal_prep.tsv")

write_tsv(x = bifido_Csection_prep,
          file = "./data/03_bifido_Csection_prep.tsv")

write_tsv(x = bifido_heatmap_prep,
          file = "./data/03_bifido_heatmap_prep.tsv")