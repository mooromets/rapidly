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
write.csv(bi, file = "data/bi.csv", row.names = FALSE)
write.csv(tri, file = "data/tri.csv", row.names = FALSE)
write.csv(four, file = "data/four.csv", row.names = FALSE)

#create sparse matrices
mbi <- sparseTPM(bi)
print(dim(mbi))
mtri <- sparseTPM(tri)
print(dim(mtri))
mfour <- sparseTPM(four)
print(dim(mfour))

#save sparse matrices
writeMMTPM(mbi, file = "data/bigrams")
writeMMTPM(mtri, file = "data/trigrams")
writeMMTPM(mfour, file = "data/fourgrams")
