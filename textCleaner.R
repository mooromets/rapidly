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
  # remove leading and hanging spaces in each line
  x <- gsub(x,
       pattern = "([[:space:]]+$)|(^[[:space:]]+)", 
       replacement = "")
  # remove dots, that are most likely are at the end of a sentence 
  x <- gsub(x,
            pattern = "([[:alnum:]])[.](( +([A-Z]))|$)", 
            replacement = "\\1 \\4")
  # remove dots, that are most likely an end of a sentence 
  x <- gsub(x,
            pattern = "[[:space:]]{2,}", 
            replacement = " ")
  x
}
