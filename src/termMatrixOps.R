# functions to perform different operations on term matrices

require(tm)
require(RWeka)
source("src/common.R")

#' ngramTdm 
#' 
#' create Term Document Matrix for the specific ngram
#' 
#' @param corpus a text corpora
#' @param ngram a number or words in the ngram
#' @param minTermLen the minimal length of a word
#' @param minBound the minimal number of appearance of a ngram
#' @param delims a set of word delimeters
#' 
#' @return a TermDocumentMatrix object
ngramTdm <- function (corpus, ngram = 1, minTermLen = 1, minBound = 1, delims = ' \r\n\t.,;:"()?!') {
  nGramTok <- function(x) NGramTokenizer(x, Weka_control(min = ngram, max = ngram, delimiters = delims))
  ctrlList <- list(wordLengths = c(minTermLen, Inf),
                   tokenize = nGramTok,
                   tolower = FALSE,
                   bounds = list(local = c(minBound, Inf)))
  TermDocumentMatrix(corpus, ctrlList)
}