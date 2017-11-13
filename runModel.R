library(Matrix)

source("src/termPredictionMatrix.R")
source("src/dictionary.R")

#dictHash <- loadDictionaryHash()
#dictVec <- loadDictionaryVect()

#load TDMs
#bigramTDM <- read.csv("data/tdmparts2.csv")
#biIDs <- data.frame(V1 = unique(bigramTDM[, 1]))
#biIDs <- cbind(biIDs, id = seq(1, nrow(biIDs)))
#bigramTDM <- right_join(biIDs, bigramTDM, by = c("V1"))

#trigramTDM <- read.csv("data/tdmparts3.csv")
#triIDs <- unique(trigramTDM[, 1:2])
#triIDs <- cbind(triIDs, id = seq(1, nrow(triIDs)))
#trigramTDM <- right_join(triIDs, trigramTDM, by = c("V1", "V2"))

#fourgramTDM <- read.csv("data/tdmparts4.csv")
#fourIDs <- unique(fourgramTDM[, 1:3])
#fourIDs <- cbind(fourIDs, id = seq(1, nrow(fourIDs)))
#fourgramTDM <- right_join(fourIDs, fourgramTDM, by = c("V1", "V2", "V3"))

#term-prediction matrices
#biSparseTPM <- loadSparseTPM(bigramTDM)
#triSparseTPM <- loadSparseTPM(trigramTDM)
#fourSparseTPM <- loadSparseTPM(fourgramTDM)

findNgram <- function(query, tpm, sparseTpm, ngramIDs) {
  matchCols <- colnames(tpm)[1 : (ncol(tpm) - 3)]
  if(length(query) !=  length(matchCols)) #too short query
    return ("")
  queryIDs <- sapply(query, function(x) dictHash[[x]])
  if(length(unlist(queryIDs)) !=  length(matchCols)) #NULLs introduced
    return ("")
  require(dplyr)
  fCond <- paste(sapply(seq_along(matchCols), 
                     function(i) paste(matchCols[i], " == ", queryIDs[i])), 
              collapse = " & ")
  res <- filter_(ngramIDs, fCond)
  if (nrow(res) > 0)
    return(dictVec[which.max(sparseTpm[as.numeric(res[ncol(res)]), ])])
  else 
    return("")
}

lookUp <- function(query) {
  query <- unlist(strsplit(query, " "))
  if (length(query) == 0) return ("")
  query <- query[(max(length(query) - 3, 1) ) : length(query)]
  answer <- ""
  answer <- findNgram(query, fourgramTDM, fourSparseTPM, fourIDs)
  if (answer == "")
    answer <- findNgram(query, trigramTDM, triSparseTPM, triIDs)
  if (answer == "")
    answer <-findNgram(query, bigramTDM, biSparseTPM, biIDs)
  answer
}

print(lookUp("would mean the"))
