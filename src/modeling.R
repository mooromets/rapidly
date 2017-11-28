outPathBase = "data/full1119/"

#source("src/modelData.R")
source("src/models.R")
#source("src/termMatrixOps.R")
source("src/search.R")
source("src/benchmark.R")
source("src/common.R")

getNextWord <- function(term, ...) {
  lookDB(term, bestWithMask, monitor = TRUE, ...)
}

#benchmark(benchmarkText(), etime = 5, getNextWord)

print(getNextWord("let it go dog"))
