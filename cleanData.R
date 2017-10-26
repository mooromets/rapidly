library(tm)

system.time({
  corp <- SimpleCorpus(DirSource("./data/chunks/"))
})