library(Matrix)
library(dplyr)

source("src/termMatrixOps.R")
source("src/dictionary.R")

#args = commandArgs(trailingOnly=TRUE)
#freqThres <- ifelse(length(args) == 1, as.integer((args[1])), NULL)
freqThres <- 8
mostFreqLimit <- 5

dictHash <- loadDictionaryHash(basePath = outPathBase)
dictVec <- loadDictionaryVect(basePath = outPathBase)

#load TDMs
bigramTDM <- read.csv(paste0(outPathBase, "en_USblogstxt2FULL.csv"))
if (!is.null(freqThres)) 
  bigramTDM <- bigramTDM[bigramTDM[, ncol(bigramTDM)] > freqThres, ]
bigramTDM <- bigramTDM %>%
  group_by(V1) %>%
  top_n(n = mostFreqLimit, V3.x)
biIDs <- data.frame(V1 = unique(bigramTDM[, 1]))
biIDs <- cbind(biIDs, id = seq(1, nrow(biIDs)))
bigramTDM <- right_join(biIDs, bigramTDM, by = c("V1"))

trigramTDM <- read.csv(paste0(outPathBase, "en_USblogstxt3FULL.csv"))
if (!is.null(freqThres)) 
  trigramTDM <- trigramTDM[trigramTDM[, ncol(trigramTDM)] > freqThres, ]
trigramTDM <- trigramTDM %>%
  group_by(V1, V2) %>%
  top_n(n = mostFreqLimit, V4.x)
triIDs <- unique(trigramTDM[, 1:2])
triIDs <- cbind(triIDs, data.frame(id = seq_len(nrow(triIDs))))
trigramTDM <- right_join(triIDs, trigramTDM, by = c("V1", "V2"))

fourgramTDM <- read.csv(paste0(outPathBase, "en_USblogstxt4FULL.csv"))
if (!is.null(freqThres)) 
  fourgramTDM <- fourgramTDM[fourgramTDM[, ncol(fourgramTDM)] > freqThres, ]
fourgramTDM <- fourgramTDM %>%
  group_by(V1, V2, V3) %>%
  top_n(n = mostFreqLimit, V5.x)
fourIDs <- unique(fourgramTDM[, 1:3])
fourIDs <- cbind(fourIDs, data.frame(id = seq_len(nrow(fourIDs))))
fourgramTDM <- right_join(fourIDs, fourgramTDM, by = c("V1", "V2", "V3"))

fivegramTDM <- read.csv(paste0(outPathBase, "en_USblogstxt5FULL.csv"))
if (!is.null(freqThres)) 
  fivegramTDM <- fivegramTDM[fivegramTDM[, ncol(fivegramTDM)] > freqThres, ]
fivegramTDM <- fivegramTDM %>%
  group_by(V1, V2, V3, V4) %>%
  top_n(n = mostFreqLimit, V6.x)
fiveIDs <- unique(fivegramTDM[, 1:4])
fiveIDs <- cbind(fiveIDs, data.frame(id = seq_len(nrow(fiveIDs))))
fivegramTDM <- right_join(fiveIDs, fivegramTDM, by = c("V1", "V2", "V3", "V4"))

#term-prediction matrices
biSparseTPM <- loadSparseTPM(bigramTDM)
triSparseTPM <- loadSparseTPM(trigramTDM)
fourSparseTPM <- loadSparseTPM(fourgramTDM)
fiveSparseTPM <- loadSparseTPM(fivegramTDM)

sparseTpmList <- list(get("biSparseTPM"), get("triSparseTPM"), get("fourSparseTPM"),
                      get("fiveSparseTPM"))
ngramTdmList <- list(get("bigramTDM"), get("trigramTDM"), get("fourgramTDM"), 
                     get("fivegramTDM"))
idsList <- list(get("biIDs"), get("triIDs"), get("fourIDs"), get("fiveIDs"))