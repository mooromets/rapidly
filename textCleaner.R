cleanPatterns <- data.frame(
  pattern = c(
    "[[:punct:]]{2,}", # remove 2+ puctuation marks in a row
    "[^[:alnum:].'-]", # remove symbols non-existant in words
    " ([-'.] )+", # remove hanging non-alnum symbols
    "([[:space:]]+$)|(^[[:space:]]+)", # remove leading and ending spaces
    "([[:alnum:]])[.](( +([A-Z]))|$)",  # remove dots, that are most likely 
                                        # are at the end of a sentence
    "[[:space:]]{2,}" # remove 2+ spaces in a row
  ),
  replacement = c(
    rep(" ", 3), 
    "", 
    "\\1 \\4", 
    " ")
)

# function cleans text as preparation for a tokenization
# INPUT
#   x - a character vector
# OUTPUT
#   a character vertor

textCleaner <- function (x, patterns = cleanPatterns) {
  for (i in 1:nrow(patterns)) {
    x <- gsub(x, 
              pattern = patterns[i, "pattern"], 
              replacement = patterns[i, "replacement"])
  }
  x
}
