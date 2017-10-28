source("textCleaner.R")

correctPatterns <- data.frame(
  pattern = c(
    "( |^)i([ ']|$)", # small "i" to uppercase
    "([[:alpha:]]) (d|ll|ve|s|re|m|t)( |$)", # missed '
    "( |^)[uU]([ ']|$)", # u = you
    "( |^)r( |$)", # r = are
    "( |^)c( |$)", # c = see
    "( |^)[Uu]r([ ']|$)" # ur = your
  ),
  replacement = c(
    "\\1I\\2",
    "\\1'\\2\\3",
    "\\1you\\2",
    "\\1are\\2",
    "\\1see\\2",
    "\\1your\\2"
  )
)

textCorrector <- function(x, censured = "") {
  x <- textCleaner(x, correctPatterns)
  if (nchar(censured) > 0)
    x <- gsub(x, pattern = censured, replacement = "", ignore.case = TRUE)
  x
}