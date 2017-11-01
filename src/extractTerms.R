library(tm)
library(RWeka)
library(dplyr)

source("src/customTDM.R")

extractTerms <- function (ngram = 1, chunksDir = "data/chunks/train/"){
  filesList <- paste0(chunksDir, dir(chunksDir))

  print(system.time({
  # read first file
  corpV <- VCorpus(DirSource(filesList[1]))
  # all terms
  leftTerms <- freqTermsInDF(customTDMn(corpV, ngram))
  }))
  
  for(i in 2:length(filesList)) {
    print(system.time({
    # read next file
    corpV <- VCorpus(DirSource(filesList[i]))
    # another al terms
    rightTerms <- freqTermsInDF(customTDMn(corpV, ngram))
    leftTerms <- full_join(leftTerms, rightTerms, by = "term")
    }))
  }
  leftTerms
}