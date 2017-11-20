# benchmark functions

source("src/cleanText.R")
source("src/modeling.R")

#open file
textFile <- file(paste0(outPathBase, "corpora/test/testChunk.txt"), "rt")
text <- readLines(textFile, n = 5000)
close(textFile)

text <- cleanText(text)

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

benchmark <- function(text, ngrams, FUN, ...) {
  score <- 0
  maxScore <- 0
  hitCountTop3 <- 0
  hitCountTop1 <- 0
  totalCount <- 0
  check <- 1
  time <- system.time({
    for (line in text) { # for each line in a text
      #print(line)
      df <- allTerms(line, ngrams)
      if (nrow(df) == 0) next
      maxScore <- maxScore + nrow(df) * 3
      totalCount <- totalCount + nrow(df)
      rank <- sapply(seq_len(nrow(df)), 
                     function(i) {
                       min(which(FUN(df[1, i], ...) == df[2, i]), 4)
                     })
      score <- score + sum(4 - rank)
      hitCountTop3 <- hitCountTop3 + sum(rank < 4)
      hitCountTop1 <- hitCountTop1 + sum(rank == 1)
      if (round(log(totalCount)) > check) {
        check <- round(log(totalCount))
        print(totalCount)
        print(Sys.time())
      }
      if (totalCount > 5000) break
    }
  })
  print(time)
  scorePercent <- score / maxScore
  top1Percent <- hitCountTop1 / totalCount
  top3Percent <- hitCountTop3 / totalCount
  
  cat(sprintf(paste0('Overall score:           %.4f \n',
                     'Overall top-1 precision: %.4f \n',
                     'Overall precision:       %.4f \n',
                     'Number of predictions:   %d \n'),
              score / maxScore,
              hitCountTop1 / totalCount,
              hitCountTop3 / totalCount,
              totalCount
  ))
}

# call
benchmark (text, 5, getNextWord)