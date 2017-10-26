# function cleans text as preparation for a tokenization
# INPUT
#   x - a character vector
# OUTPUT
#   a character vertor

textCleaner <- function (x) {
  #remove 2+ puctuation marks in a row
  x <- gsub(x,
            pattern = "[[:punct:]]{2,}",
            replacement = " ")
  # leave only letters, numbers and three more puctuation marks that are
  # the parts of a language (cost-effective, that's, e.g.)
  x <- gsub(x,
            pattern = "[^[:alnum:].'-]", 
            replacement = " ")
  # remove hanging punctuation marks
  x <- gsub(x,
            pattern = " [-'.] ", 
            replacement = "")
  # remove dots, that are most likely an end of a sentence 
  x <- gsub(x,
            pattern = "[A-Za-z0-9][.]( +[A-Z]|$)", 
            replacement = " ")
  # remove dots, that are most likely an end of a sentence 
  x <- gsub(x,
            pattern = "[[:space:]]{2,}", 
            replacement = " ")
  x
}