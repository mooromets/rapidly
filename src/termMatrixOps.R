# functions to perform different operations on term matrices

require(tm)
require(RWeka)
source("src/common.R")
source("src/cleanText.R")

# ngramTdm - create Term Document Matrix for the specific ngram
ngramTdm <- function (corpus, ngram = 1, minTermLen = 1, minBound = 1, delims = ' \r\n\t.,;:"()?!') {
  nGramTok <- function(x) NGramTokenizer(x, Weka_control(min = ngram, max = ngram, delimiters = delims))
  ctrlList <- list(wordLengths = c(minTermLen, Inf),
                   tokenize = nGramTok,
                   tolower = FALSE,
                   bounds = list(local = c(minBound, Inf)))
  TermDocumentMatrix(corpus, ctrlList)
}