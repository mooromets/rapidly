#different models

maxFUN <- function(row) {
  max <-order(row, decreasing = TRUE)[1:5]
  return(c(unlist(sapply(max, function(x) dictVec[x] ))))
}

gatherFUN <- function (x) x