source("R/models.R")
source("R/search.R")
source("R/benchmark.R")

getNextWord <- function(term, ...) {
  lookDB(term, bestWithMask, ...)
}

benchmark(benchmarkText(), etime = 300, getNextWord)