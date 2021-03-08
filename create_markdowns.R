
if (!require('rmarkdown')) {
  install.packages('rmarkdown')
}

files = list.files('docs', pattern = '*.Rmd', full.names = TRUE)

for (file in files) {
  rmarkdown::render(file, rmarkdown::md_document(preserve_yaml = TRUE))
}