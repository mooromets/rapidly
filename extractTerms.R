library(tm)
library(RWeka)
library(dplyr)

source("src/customTDM.R")

# get list of directories
textDir <- "data/chunks/"
filesList <- paste0(textDir, dir(textDir))

print(system.time({

# read first file
corpV <- VCorpus(DirSource(filesList[1]))

# single-word term-document-matrix
leftTerms1 <- freqTermsInDF(customTDM1(corpV))

# bigram tdm
leftTerms2 <- freqTermsInDF(customTDMn(corpV, 2))

leftTerms3 <- freqTermsInDF(customTDMn(corpV, 3))

leftTerms4 <- freqTermsInDF(customTDMn(corpV, 4))

}))

for(i in 2:length(filesList)) {
  print(system.time({
  # read next file
  corpV <- VCorpus(DirSource(filesList[i]))
  # single-word term-document-matrix
  rightTerms1 <- freqTermsInDF(customTDM1(corpV))
  # bigram tdm
  rightTerms2 <- freqTermsInDF(customTDMn(corpV, 2))
  rightTerms3 <- freqTermsInDF(customTDMn(corpV, 3))
  rightTerms4 <- freqTermsInDF(customTDMn(corpV, 4))
  
  leftTerms1 <- full_join(leftTerms1, rightTerms1, by = "term")
  leftTerms2 <- full_join(leftTerms2, rightTerms2, by = "term")
  leftTerms3 <- full_join(leftTerms3, rightTerms3, by = "term")
  leftTerms4 <- full_join(leftTerms4, rightTerms4, by = "term")
  }))
}