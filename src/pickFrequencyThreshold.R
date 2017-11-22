outPathBase <- "data/full1119/"
source("src/benchmark.R")

for (thres in 1:15) {
  cat(sprintf("--- thres = %d ---", thres))
  print(Sys.time())
  commandArgs <- function(...) thres
  source("src/modelData.R")
  print(sum(sapply(sparseTpmList, function(m) object.size(m) / 1024 ^ 2)))
  print(Sys.time())
  source("src/modeling.R")
  print(Sys.time())
}