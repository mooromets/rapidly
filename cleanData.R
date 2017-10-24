library(tm)
corp <- SimpleCorpus(DirSource("./data/"))

corp <- tm_map(corp, stripWhitespace)
corp <- tm_map(corp, content_transformer(tolower))
