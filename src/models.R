#different models

maxFUN <- function(row, dictVec) {
  max <-order(row, decreasing = TRUE)[1:5]
  return(c(unlist(sapply(max, function(x) dictVec[x] ))))
}

gatherFUN <- function (x) x

fiveMostProb <- function(row, dictVec) {
  row <- row / sum(row)
  max5 <- order(row, decreasing = TRUE)[1:5]
  result <- row[max5]
  names(result) <- c(unlist(sapply(max5, function(x) dictVec[x] )))
  result
}

choose3top <- function(probList) {
  #concatenate all results
  all <- c()
  for (i in seq_along(probList)) {
    all <- c(all, probList[[i]])
  }
  res <- c()
  for (i in seq_len(3)) {
    maxIdx <- which.max(all)
    # add this max to result
    res <- c(res, names(all)[maxIdx])
    # remove all apearance of this word from all 
    all <- all[names(all) != names(all)[maxIdx]]
  }
  return(res)
}

stupidBackoff <- function(probList, lambda = 0.5) {
  if (length(probList) == 0) return(c("the", "on", "a"))
  #concatenate all results
  all <- c()
  for (i in seq(length(probList), 1)) {
    all <- c(all, probList[[i]] * lambda^(length(probList) - i))
  }
  res <- c()
  for (i in seq_len(3)) {
    maxIdx <- which.max(all)
    # add this max to result
    res <- c(res, names(all)[maxIdx])
    # remove all apearance of this word from all 
    all <- all[names(all) != names(all)[maxIdx]]
  }
  return(res)
}