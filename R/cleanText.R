#functions for cleaning text

library(tm)

source("R/common.R")


#' removeStandaloneLetters
#' 
#' @param x a character vector
#' 
#' @return a cleaned character vector
removeStandaloneLetters <- function(x) {
  removeWords(x, c("b", "c", "e", "f", "g", "h", "j", "k", "l",
                   "p", "q", "r", "u", "v", "w", "x", "y", "z"))  
}


#' recoverApostrophe
#' 
#' recover a missed apostrohe in words
#' 
#' @param x a character vector
#' 
#' @return a cleaned character vector
recoverApostrophe <- function(x) {
  gsub(pattern = "([[:alpha:]]) (d|ll|ve|s|re|m|t)([[:space:]]|$)", 
       replacement = "\\1'\\2\\3", 
       x)
}


#' removePuctLeaveApost
#' 
#' remove all punctation marks except apostrophe
#' 
#' @param x a character vector
#' 
#' @return a cleaned character vector
removePuctLeaveApost <- function(x) {
  gsub(pattern = "[^[:alnum:]'[:space:]]", 
       replacement = " ", 
       x)
}


#' removeConseqApost
#' 
#' remove consequetive apostrophes
#' 
#' @param x a character vector
#' 
#' @return a cleaned character vector
removeConseqApost <- function(x) {
  gsub(pattern = "'{2,}", 
       replacement = "", 
       x)
}


#' sentenceSplit
#' 
#' split every line into lines containing one sentence each
#' 
#' @param x a character vector
#' 
#' @return a cleaned character vector
sentenceSplit <- function(x) {
  unlist(strsplit(x, 
                  split = "(?<!\\w\\.\\w.)(?<![A-Z][a-z]\\.)(?<=\\.|\\?)\\s", 
                  perl = TRUE))
}


#' censuredWords
#' 
#' @return a character vector of censured words
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


#' cleanText
#' 
#' @param x a character vector
#' 
#' @return a cleaned character vector
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


#' cleanInput
#' 
#' performs a text cleaning on a text inputted in UI
#' 
#' @param x a character vector
#' 
#' @return a cleaned character vector
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