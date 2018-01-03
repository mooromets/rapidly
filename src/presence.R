source("src/wordsDB.R")

WordsDB <- getRefClass("WordsDB")

presenceList <- function(word, ...) {
  wdb = WordsDB()
  wdb$wordPresence(word, ...)
}