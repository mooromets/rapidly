source("src/splitFiles.R")
source("src/extractTerms.R")
source("src/termPredictionMatrix.R")

inpath <- "data/sample/"
outpath <- "data/samplechunks/"

splitFiles(inpath, outpath)

#x <- do.call (rbind, lapply(2:4, extractTerms,"data/samplechunks/train/"))

x2 <- tpm(extractTerms(2, "data/samplechunks/train/"))
x3 <- tpm(extractTerms(3, "data/samplechunks/train/"))
x4 <- tpm(extractTerms(4, "data/samplechunks/train/"))

write.csv(x2, file = "x2.csv")
write.csv(x3, file = "x3.csv")
write.csv(x4, file = "x4.csv")