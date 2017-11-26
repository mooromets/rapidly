#different models
library(dplyr)

maxFUN <- function(row, dictVec) {
  max <-order(row, decreasing = TRUE)[1:5]
  return(c(unlist(sapply(max, function(x) dictVec[x] ))))
}

gatherFUN <- function (x) x

#'
#' get 5 values from row with the highest probability
#' @param row a input vector with frequencies of words
#' @param dictVec dictionary with words
#' @return a numeric vector of 5 probabilities with their words as names 
#'
fiveMostProb <- function(row, dictVec) {
  if (sum(row) <= 0) return (NULL)
  row <- row / sum(row)
  max5 <- order(row, decreasing = TRUE)[1:5]
  result <- row[max5]
  names(result) <- c(unlist(sapply(max5, function(x) dictVec[x])))
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

bestWithMask <- function(items, alpha = 0.5, maskedPow = 1.7) {
  if (length(items) == 0) 
    return(vector())
  
  allPred <- do.call(rbind, lapply(items, 
                function(item){
                  if (length(item$nextIds) == 0)
                    return(data.frame())
                  a <- alpha ^ (4 - length(item$words))
                  if (sum(is.na(item$words))> 0)
                    a <- a * alpha ^ maskedPow
                  data.frame(nextId = item$nextIds, 
                             score = item$nextProb * a)
                }))
  if (nrow(allPred) == 0)
    return(vector())

  allPred <- allPred %>% 
    group_by(nextId) %>%
    summarise(score =  sum(score)) %>%
    arrange(desc(score)) %>%
    top_n(n = 3, score)
  
  as.vector(allPred$nextId)
}