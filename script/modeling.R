source("src/models.R")
source("src/search.R")
source("src/benchmark.R")
source("src/common.R")

getNextWord <- function(term, ...) {
  lookDB(term, bestWithMask, ...)
}

benchmark(benchmarkText(), etime = 300, getNextWord)