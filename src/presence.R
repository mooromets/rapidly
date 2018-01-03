source("src/common.R")

presenceList <- function(word, ...) {
  wdb = WordsDB()
  wdb$wordPresence(word, ...)
}