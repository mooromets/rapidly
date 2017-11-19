library(Matrix)
library(dplyr)

#source("src/termMatrixOps.R")
source("src/dictionary.R")

dictHash <- loadDictionaryHash(basePath = outPathBase)
dictVec <- loadDictionaryVect(basePath = outPathBase)

#load TDMs
bigramTDM <- read.csv(paste0(outPathBase, "en_USblogstxt2FULL.csv"))
biIDs <- data.frame(V1 = unique(bigramTDM[, 1]))
biIDs <- cbind(biIDs, id = seq(1, nrow(biIDs)))
bigramTDM <- right_join(biIDs, bigramTDM, by = c("V1"))

trigramTDM <- read.csv(paste0(outPathBase, "en_USblogstxt3FULL.csv"))
triIDs <- unique(trigramTDM[, 1:2])
triIDs <- cbind(triIDs, id = seq(1, nrow(triIDs)))
trigramTDM <- right_join(triIDs, trigramTDM, by = c("V1", "V2"))

fourgramTDM <- read.csv(paste0(outPathBase, "en_USblogstxt4FULL.csv"))
fourIDs <- unique(fourgramTDM[, 1:3])
fourIDs <- cbind(fourIDs, id = seq(1, nrow(fourIDs)))
fourgramTDM <- right_join(fourIDs, fourgramTDM, by = c("V1", "V2", "V3"))

#term-prediction matrices
biSparseTPM <- loadSparseTPM(bigramTDM)
triSparseTPM <- loadSparseTPM(trigramTDM)
fourSparseTPM <- loadSparseTPM(fourgramTDM)

sparseTpmList <- list(get("biSparseTPM"), get("triSparseTPM"), get("fourSparseTPM"))
ngramTdmList <- list(get("bigramTDM"), get("trigramTDM"), get("fourgramTDM"))
idsList <- list(get("biIDs"), get("triIDs"), get("fourIDs"))