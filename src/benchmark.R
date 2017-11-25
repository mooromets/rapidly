# benchmark functions

source("src/cleanText.R")
source("src/common.R")

#' 
#' reads, cleans and shiffles text from test file
#' 
#' @param seed to be used for shuffling
#' @param filname filename
#' @return text as character vector
#' 
benchmarkText <- function(seed = 23456, filename = "") {
  fname <- ifelse(nchar(filename) == 0, 
                  paste0(outPathBase, "corpora/test/testChunk.txt"),
                  filename)
  textFile <- file(fname, "rt")
  text <- readLines(textFile)
  close(textFile)
  text <- cleanText(text)
  set.seed(seed)
  # shuffle text because benchmark is stopped by timer, therefore
  # different parts of text could be processed
  sample(text, length(text))
}

#'
#' creates data.frame that contains phrases from line with their corresponding prediction 
#'
#' @param line character input
#' @return data.frame with 2 columns: predictor - prediction
#' 
line2TermsDF <- function (line) {
  maxWC <- 10 # maximum words count in a single predictor
  terms <- c()
  outcome <- c()
  lineVec <- unlist(strsplit(line, " "))
  lineVec <- lineVec[nchar(lineVec) > 0]
  if (length(lineVec) > 1) {
    for (i in seq(1, length(lineVec) - 1)) {
      terms <- c(terms, paste0(lineVec[max(1, i - maxWC + 1) : i], collapse = " "))
      outcome <- c(outcome, lineVec[i + 1])
    }
  }
  data.frame(terms = terms, 
             outcome = outcome, 
             stringsAsFactors = FALSE)
}

#' 
#' performs benchmarking
#' 
#' @param text input character or character vector
#' @param etime timelimit for benchmarking process
#' @param FUN function to predict next word
#' @param ... passed to FUN
#' @return list with the results that is also printed
#' 
benchmark <- function(text, etime = Inf, FUN, ...) {
  score <- 0
  maxScore <- 0
  hitCountTop3 <- 0
  hitCountTop1 <- 0
  totalCount <- 0
  totalTime <- 0
  for (line in text) {
    print(line)
    df <- line2TermsDF(line)
    if (nrow(df) == 0) next
    maxScore <- maxScore + nrow(df) * 3
    totalCount <- totalCount + nrow(df)
    time <- system.time(
      rank <- sapply(seq_len(nrow(df)), 
                   function(i) {
                     min(which(FUN(df[i, 1], ...) == df[i, 2]), 4)
                   })
    )
    totalTime <- totalTime + time[3]
    score <- score + sum(4 - rank)
    hitCountTop3 <- hitCountTop3 + sum(rank < 4)
    hitCountTop1 <- hitCountTop1 + sum(rank == 1)
    if (!is.infinite(etime) & totalTime > etime)
      break
  }
  scorePercent <- score / maxScore
  top1Percent <- hitCountTop1 / totalCount
  top3Percent <- hitCountTop3 / totalCount
  
  cat(sprintf(paste0('Overall score:           %.4f \n',
                     'Overall top-1 precision: %.4f \n',
                     'Overall precision:       %.4f \n',
                     'Number of predictions:   %d \n',
                     'Sec(avg.) per request:   %.4f \n'),
              score / maxScore,
              hitCountTop1 / totalCount,
              hitCountTop3 / totalCount,
              totalCount,
              totalTime / totalCount 
  ))
  list(score = score / maxScore,
       OverallTop1 = hitCountTop1 / totalCount,
       OverallPre = hitCountTop3 / totalCount,
       Number = totalCount,
       time = totalTime / totalCount)
}