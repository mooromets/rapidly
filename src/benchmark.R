# benchmark functions

source("src/cleanText.R")
source("src/modeling.R")

#open file
textFile <- file(paste0(outPathBase, "corpora/test/testChunk.txt"), "rt")
text <- readLines(textFile)
close(textFile)

text <- cleanText(text)
text <- sample(text, length(text))

allTerms <- function (line, ngrams) {
  terms <- c()
  outcome <- c()
  for (len in ngrams) {
    lineVec <- unlist(strsplit(line, " "))
    lineVec <- lineVec[nchar(lineVec) > 0]
    if (length(lineVec) < len) next
    for (i in seq(1, length(lineVec) - len + 1)) { #for all terms of this length in a line
      terms <- c(terms, paste0(lineVec[i : (i + len - 2)], collapse = " "))
      outcome <- c(outcome, lineVec[i + len - 1])
    }
  }
  data.frame(terms = terms, outcome = outcome, 
             stringsAsFactors = FALSE)
}

benchmark <- function(text, ngrams, etime = Inf, FUN, lambda) {
  score <- 0
  maxScore <- 0
  hitCountTop3 <- 0
  hitCountTop1 <- 0
  totalCount <- 0
  totalTime <- 0
  for (line in text) { # for each line in a text
    #print(line)
    df <- allTerms(line, ngrams)
    if (nrow(df) == 0) next
    maxScore <- maxScore + nrow(df) * 3
    totalCount <- totalCount + nrow(df)
    time <- system.time(
      rank <- sapply(seq_len(nrow(df)), 
                   function(i) {
                     min(which(FUN(df[i, 1], lambda) == df[i, 2]), 4)
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
}

# call
sapply(c(.2, .3, .4, .5, .6, .8, 1.1, 1.5, 2),
       function(lam) {
         benchmark (text, 2:5, etime = 200, getNextWord, lambda = lam)
       })