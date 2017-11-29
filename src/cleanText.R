#functions for cleaning text

library(tm)

source("src/common.R")

removeStandaloneLetters <- function(x) {
  removeWords(x, c("b", "c", "e", "f", "g", "h", "j", "k", "l",
                   "p", "q", "r", "u", "v", "w", "x", "y", "z"))  
}

recoverApostrophe <- function(x) {
  gsub(pattern = "([[:alpha:]]) (d|ll|ve|s|re|m|t)([[:space:]]|$)", 
       replacement = "\\1'\\2\\3", 
       x)
}

removePuctLeaveApost <- function(x) {
  gsub(pattern = "[^[:alnum:]'[:space:]]", 
       replacement = " ", 
       x)
}

removeConseqApost <- function(x) {
  gsub(pattern = "'{2,}", 
       replacement = "", 
       x)
}

sentenceSplit <- function(x) {
  unlist(strsplit(x, 
                  split = "(?<!\\w\\.\\w.)(?<![A-Z][a-z]\\.)(?<=\\.|\\?)\\s", 
                  perl = TRUE))
}

# get (read) censured words as pattern to gsub
censuredWords <- function(filename = "data/censure.txt") {
  censured <- ""
  cens <- file(filename, "r")
  repeat {
    line = readLines(cens, n = 1)
    if ( length(line) == 0 ) {
      censured <- paste0(censured, ")( |$)")
      break
    }
    if (nchar(censured) == 0)
      censured <- paste0("( |^)(", line)
    else
      censured <- paste0(censured, "|", line)
  }
  close(cens)
  censured
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

cleanInput <- function(x) {
  if (length(x) == 0)
    return (NULL)
  else if (length(x) != 1)
    x <- x[length(x)] #pick only the last line from a vector
  
  #cut input to save some time on cleaning it
  x <- substr(x, max(1, nchar(x) - MAX_TERM_LEN), nchar(x))
  x <- cleanText(x)
  # pick only the last line
  if (length(x) > 1)
    x <- x[length(x)]
  x
}