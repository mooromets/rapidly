source("src/splitFiles.R")
source("src/extractTerms.R")
source("src/termPredictionMatrix.R")

inpath <- "data/sample/"
outpath <- "data/samplechunks/"

splitFiles(inpath, outpath)

#x <- do.call (rbind, lapply(2:4, extractTerms,"data/samplechunks/train/"))

bi <- extractTerms(2, "data/chunks/train/")
print(dim(bi))
write.csv(bi, file = "bi.csv")
tri <- extractTerms(3, "data/chunks/train/")
print(dim(tri))
write.csv(tri, file = "tri.csv")
four <- extractTerms(4, "data/chunks/train/")
print(dim(four))
write.csv(four, file = "four.csv")

mbi <- sparseTPM(bi)
print(dim(mbi))
writeMM(mbi, file = "bi-tpm.csv")
mtri <- sparseTPM(tri)
print(dim(mtri))
writeMM(mtri, file = "tri-tpm.csv")
mfour <- sparseTPM(four)
print(dim(mfour))
writeMM(mfour, file = "four-tpm.csv")