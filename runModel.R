library(Matrix)

source("src/termPredictionMatrix.R")
source("src/dictionary.R")

dictHash <- loadDictionaryHash()

#load TDMs
bigramTDM <- read.csv("data/tdmparts2.csv")
bigramTDM <- cbind(as.numeric(rownames(bigramTDM)), bigramTDM)
trigramTDM <- read.csv("data/tdmparts3.csv")
bigramTDM <- cbind(as.numeric(rownames(trigramTDM)), trigramTDM)
fourgramTDM <- read.csv("data/tdmparts4.csv")
bigramTDM <- cbind(as.numeric(rownames(fourgramTDM)), fourgramTDM)

#term-prediction matrices
biSparseTPM <- loadSparseTPM(bigramTDM)
triSparseTPM <- loadSparseTPM(trigramTDM)
fourSparseTPM <- loadSparseTPM(fourgramTDM)

findNgram(query, tpm, sparseTpm) {
  matchCols <- colnames(tmp)[2 : (ncol(tmp) - 1)]
  queryIDs <- sapply(query, function(x) dictHash[[x]])
  require(dplyr)
  fCond <- paste(sapply(seq_along(matchCols), 
                     function(i) paste(matchCols[i], " == ", queryIDs[i])), 
              collapse = " & ")
  res <- filter_(tpm, fCond)
  dictHash[[colnames(ngrams)[which.max(sparseTpm[res[2], ])]]]
}

lookUp <- function(query) {
  query <- strsplit(query, " ")
  if (length(query) == 0) return ("")
  query <- query[(max(length(query) - 3, 1) ) : length(query)]
  answer <- ""
  answer <- switch(length(query),
         2 = findNgram(query, bigramTDM, biSparseTPM),
         3 = findNgram(query, trigramTDM, triSparseTPM),
         4 = findNgram(query, fourgramTDM, fourSparseTPM))
  answer
}
