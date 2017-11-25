outPathBase = "data/full1119/"

#source("src/modelData.R")
source("src/models.R")
source("src/termMatrixOps.R")
source("src/benchmark.R")
source("src/common.R")

getNextWord <- function(term, ...) {
#  lookUp(term, stupidBackoff, fiveMostProb, sparseTpmList, ngramTdmList, idsList, dictHash, dictVec, ...)
  lookDB(term, bestWithMask, ...)
}

benchmark(benchmarkText(), etime = 200, getNextWord)

#print(getNextWord("i've"))
