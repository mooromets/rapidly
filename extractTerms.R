library(tm)
library(RWeka)
source("customTDM.R")

# get list of directories
textDir <- "data/chunks/"
filesList <- paste0(textDir, dir(textDir))

# read first file
corpV <- VCorpus(DirSource(filesList[1]))

# single-word term-document-matrix
leftTDM1 <- myTDM1(corpV)

# bigram tdm
leftTDM2 <- myTDMn(corpV, 2)

leftTDM3 <- myTDMn(corpV, 3)

leftTDM4 <- myTDMn(corpV, 4)