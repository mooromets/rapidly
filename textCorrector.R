source("textCleaner.R")

correctPatterns <- data.frame(
  pattern = c(
    "( |^)i([ ']|$)", # small "i" to uppercase
    "([[:alpha:]]) (d|ll|ve|s|re|m|t)( |$)" # missed '
  ),
  replacement = c(
    "\\1I\\2",
    "\\1'\\2\\3"
  )
)

textCorrector <- function(x) {
  textCleaner(x, correctPatterns)
}