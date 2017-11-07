# cleaning text 

cleanPatterns <- data.frame(
  pattern = c(
    "[[:punct:]]{2,}", # remove 2+ puctuation marks in a row
    "[^[:alnum:].'-]", # remove symbols non-existant in words
    " ([-'.] )+", # remove hanging non-alnum symbols
    "([[:space:]]+$)|(^[[:space:]]+)", # remove leading and ending spaces
    "([[:alnum:]])[.](( +([A-Z]))|$)",  # remove dots, that are most likely 
                                        # are at the end of a sentence
    "[[:space:]]{2,}", # remove 2+ spaces in a row
    ## grammar
    "( |^)i([ ']|$)", # small "i" to uppercase
    "([[:alpha:]]) (d|ll|ve|s|re|m|t)( |$)", # missed '
    "( |^)[uU]([ ']|$)", # u = you
    "( |^)r( |$)", # r = are
    "( |^)c( |$)", # c = see
    "( |^)[Uu]r([ ']|$)" # ur = your
    
  ),
  replacement = c(
    rep(" ", 3), 
    "", 
    "\\1 \\4", 
    " ",
    ## grammar
    "\\1I\\2",
    "\\1'\\2\\3",
    "\\1you\\2",
    "\\1are\\2",
    "\\1see\\2",
    "\\1your\\2"
  )
)

perlSplitPattern <- "(?<!\\w\\.\\w.)(?<![A-Z][a-z]\\.)(?<=\\.|\\?)\\s"

# function cleans text as preparation for a tokenization
# INPUT
#   x - a character vector
# OUTPUT
#   a character vertor

textCleaner <- function (x, patterns = cleanPatterns, censured = "") {
  x <- unlist(strsplit(x, split =  perlSplitPattern, perl = TRUE))
  for (i in 1:nrow(patterns)) {
    x <- gsub(x, 
              pattern = patterns[i, "pattern"], 
              replacement = patterns[i, "replacement"])
  }
  if (nchar(censured) > 0) {
    x <- gsub(x, pattern = censured, replacement = " ", ignore.case = TRUE)
  }
  #skip too short sentences
  minSize <- 4 # min size for a sensible sentence 
  x <- x[nchar(x) >= minSize]
    # TODO refactor
    require(tm)
    x <- tolower(x)
    x <- removeNumbers(x)
}