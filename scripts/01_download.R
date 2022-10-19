# Clear workspace ---------------------------------------------------------
rm(list = ls())

dir.create('./raw', showWarnings = F)

family_path <- "./raw/family_meta.tsv"

download.file(url = "https://data.mendeley.com/public-files/datasets/gc4d9h4x67/files/bd5e9c0a-0dbf-4827-bdd4-d0ece13e8c99/file_downloaded",
              destfile = family_path)

writeLines(paste('Downloaded file into:', family_path))


bifido_path <- "./raw/bifido_meta.tsv"

download.file(url = "https://data.mendeley.com/public-files/datasets/gc4d9h4x67/files/882fba90-e685-459e-98d1-1c97fa56941b/file_downloaded",
              destfile = bifido_path)

writeLines(paste('Downloaded file into:', bifido_path))

