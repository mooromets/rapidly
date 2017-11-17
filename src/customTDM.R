# functions to create custom TDM

require(tm)
require(RWeka)

# ngram TDM
ngramTdm <- function (corpus, ngram = 1, minTermLen = 1, minBound = 1, delims = ' \r\n\t.,;:"()?!') {
  nGramTok <- function(x) NGramTokenizer(x, Weka_control(min = ngram, max = ngram, delimiters = delims))
  ctrlList <- list(wordLengths = c(minTermLen, Inf),
                   tokenize = nGramTok,
                   tolower = FALSE,
                   local = c(minBound, Inf))
  TermDocumentMatrix(corpus, ctrlList)
}