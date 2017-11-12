library(tm)

cleanCorpus <- function(corp) {
  corp <- tm_map(corp, content_transformer(tolower))
  corp <- tm_map(corp, content_transformer(removeNumbers))
  tm_map(corp, content_transformer(removePunctuation))
}