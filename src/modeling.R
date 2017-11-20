outPathBase = "data/full1115/"

source("src/modelData.R")
source("src/models.R")
source("src/termMatrixOps.R")

getNextWord <- function(term) {
  lookUp(term, choose3top, fiveMostProb, sparseTpmList, ngramTdmList, 
             idsList, dictHash, dictVec)
}