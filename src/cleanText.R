#functions for cleaning text

library(tm)

removeStandaloneLetters <- function(x) {
  gsub(pattern = "([^[:alpha:]']|^)([b-hj-z])([^[:alpha:]']|$)", 
       replacement = "\\1", 
       x)
}

recoverApostrophe <- function(x) {
  gsub(pattern = "([[:alpha:]]) (d|ll|ve|s|re|m|t)([[:space:]]|$)", 
       replacement = "\\1'\\2\\3", 
       x)
}

removePuctLeaveApost <- function(x) {
  gsub(pattern = "[^[:alnum:]'[:space:]]", 
       replacement = "", 
       x)
}

removeConseqApost <- function(x) {
  gsub(pattern = "'{2,}", 
       replacement = "'", 
       x)
}


sentenceSplit <- function(x) {
  unlist(strsplit(x, 
                  split = "(?<!\\w\\.\\w.)(?<![A-Z][a-z]\\.)(?<=\\.|\\?)\\s", 
                  perl = TRUE))
}

cleanText <- function(x) {
  x <- tolower(x)
  x <- removeNumbers(x)
  x <- sentenceSplit(x)
  x <- recoverApostrophe(x)
  x <- removePuctLeaveApost(x)
  x <- removeConseqApost(x)
  x <- removeStandaloneLetters(x)
  x <- stripWhitespace(x)
}