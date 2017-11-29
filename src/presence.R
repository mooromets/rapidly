source("src/data.R")
source("src/cleanText.R")
source("src/common.R")

findWordsPresenceQueryList <- function(wordId, limit = 20) {
  tabname <- c("bigrams", "trigrams", "fourgrams", "fivegrams")

  out <- list()
  for(itab in seq_along(tabname)) {
    nWords <- itab + 1
    selectFromStr <- paste("SELECT d.word,", 
                           paste(paste0("d", 
                                         as.character(seq_len(itab)),
                                         ".word"), 
                                  collapse = ", "),
                           "FROM",
                           tabname[itab],
                           "b")
    joinStr <- paste("JOIN dict d ON b.idnext == d.id",
                     paste0("JOIN dict d", 
                            as.character(seq_len(itab)),
                            " ON b.idword",
                            as.character(seq_len(itab)),
                            " = d",
                            as.character(seq_len(itab)),
                            ".id",
                            collapse = " "))
    whereStr <- paste("WHERE b.idnext =", 
                      as.character(wordId),
                      "OR",
                      paste0("b.idword", 
                             as.character(seq_len(itab)),
                             " = ",
                             as.character(wordId),
                             collapse = " OR ")
                      )
    wholeQue <- paste(selectFromStr, joinStr, whereStr,
                      "ORDER BY b.freq",
                      "LIMIT", limit)
    out[[itab]] <- wholeQue
  }
  out
}

presenceList <- function(word, ...) {
  word <- cleanInput(word)
  if(length(word) == 0)
    rerutn(list())
  
  wordId <- getWordID(word, dataDB())
  if (is.na(wordId))
    return(list())

  lapply(findWordsPresenceQueryList(wordId), 
                function(que) dbGetQuery(dataDB(), que))
}