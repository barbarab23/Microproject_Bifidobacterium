# Check library installs  -------------------------------------------------

package_list <- c('tidyverse', 'reshape2', 'viridis', 'cowplot')


for (package in package_list){
  writeLines(paste('Checking for package:',package))
  if (!require(package, character.only = TRUE)) {
    writeLines(paste('Installing package and dependencies'))
    install.packages(package, repos="https://mirrors.dotsrc.org/cran/")
  } else {
    writeLines(paste('Package already installed.'))
  }
}


# Run all scripts ---------------------------------------------------------
source(file = './scripts/01_download.R')
source(file = './scripts/02_clean.R')
source(file = './scripts/03_augment.R')
source(file = './scripts/04_gut_microbiome_areachart.R')
source(file = './scripts/05_bifido_heatmap.R')

