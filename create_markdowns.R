
if (!require('rmarkdown') || !require('tidyverse')) {
  install.packages(c('rmarkdown', 'tidyverse'))
}

files = list.files('docs', pattern = '*.Rmd', full.names = TRUE)

for (file in files) {
  rmarkdown::render(file, rmarkdown::md_document(preserve_yaml = TRUE))
}