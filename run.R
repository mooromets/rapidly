source("src/splitFiles.R")
source("src/extractTerms.R")

inpath <- "data/sample/"
outpath <- "data/samplechunks/"

splitFiles(inpath, outpath)

x <- do.call (rbind, lapply(2:4, extractTerms,"data/samplechunks/train/"))