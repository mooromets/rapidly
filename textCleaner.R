cleanStep1 <- c("[[:punct:]]{2,}", # remove 2+ puctuation marks in a row
                "[^[:alnum:].'-]", # remove symbols non-existant in words
                " ([-'.] )+" # remove hanging non-alnum symbols
                )

cleanStep2 <- c("([[:space:]]+$)|(^[[:space:]]+)", # remove leading and ending spaces
                "([[:alnum:]])[.](( +([A-Z]))|$)",  # remove dots, that are most likely 
                                                    # are at the end of a sentence
                "[[:space:]]{2,}" # remove 2+ spaces in a row
                )

cleanStep2Repl <- c("", "\\1 \\4", " ")

# function cleans text as preparation for a tokenization
# INPUT
#   x - a character vector
# OUTPUT
#   a character vertor

textCleaner <- function (x) {
  x <- gsub(x, pattern = cleanStep1[1], replacement = " ")
  x <- gsub(x, pattern = cleanStep1[2], replacement = " ")
  x <- gsub(x, pattern = cleanStep1[3], replacement = " ")
  
  x <- gsub(x, pattern = cleanStep2[1], replacement = cleanStep2Repl[1])
  x <- gsub(x, pattern = cleanStep2[2], replacement = cleanStep2Repl[2])
  x <- gsub(x, pattern = cleanStep2[3], replacement = cleanStep2Repl[3])
  x
}
