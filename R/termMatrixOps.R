# functions to perform different operations on term matrices

require(tm)
require(RWeka)

source("R/common.R")
source("R/cleanText.R")

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


extractTdmFromDir <- function(NGram, inPath, outPath, dirName, dictHash) {
  print(paste(dirName, as.character(NGram)))
  print(Sys.time()); print("read and clean Corpus");
  corp <- VCorpus(DirSource(paste0(inPath, dirName)))
  corp <- tm_map(corp, content_transformer(cleanText))
  print(Sys.time()); print("create TDM");
  mtx <- as.matrix(ngramTdm(corp, ngram = NGram))
  # convert words into IDs    
  # remove phrases with a low frequency
  idxFreq <- as.vector(mtx[, 1] > 1)
  tmpDF <- data.frame(term = rownames(mtx)[idxFreq], 
                      freq = mtx[idxFreq, 1], 
                      stringsAsFactors = FALSE,
                      row.names = NULL)
  rm(mtx)
  tmpDF <- as.data.frame(t(apply(tmpDF, 1, function(row) {
    matrix(data = c(as.vector(sapply(unlist(strsplit(row[1], " ")), 
                                     function(x) as.numeric(dictHash[[x]])),
                              mode = "numeric"
    ), 
    as.numeric(row[2])),    
    nrow = 1)
  })))
  # remove lines with words absent in the dictionary
  tmpDF[complete.cases(tmpDF), ]
}