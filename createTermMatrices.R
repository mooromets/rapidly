library(Matrix)

source("src/splitFiles.R")
source("src/extractTerms.R")
source("src/termPredictionMatrix.R")

# split into small chunks and clean (on the way) the input data
inpath <- "data/final/en_US/"
outpath <- "data/chunks/"
splitFiles(inpath, outpath)

# get all ngrams from data
bi <- extractTerms(2, "data/chunks/train/")
print(dim(bi))
tri <- extractTerms(3, "data/chunks/train/")
print(dim(tri))
four <- extractTerms(4, "data/chunks/train/")
print(dim(four))

#save temporal tabels to avoid expansive extracting every time
write.csv(bi, file = "data/bi.csv")
write.csv(tri, file = "data/tri.csv")
write.csv(four, file = "data/four.csv")

#creating sparse matrices
mbi <- sparseTPM(bi)
print(dim(mbi))
writeMM(mbi, file = "data/bigrams.mtx")
mtri <- sparseTPM(tri)
print(dim(mtri))
writeMM(mtri, file = "data/trigrams.mtx")
mfour <- sparseTPM(four)
print(dim(mfour))
writeMM(mfour, file = "data/fourgrams.mtx")