#' WordsDB is a class to access the word data stored in a database

source("src/common.R")
require(RSQLite)

WordsDB <- setRefClass("WordsDB",
                       fields = list(dbname = "character", 
                                     dataConn  = "SQLiteConnection"))


#' initialize 
#' 
#' opens a connection to the database
WordsDB$methods(initialize = function(name = SQLITE_WORDS_DB) {
  dbname <<- name
  dataConn <<- dbConnect(RSQLite::SQLite(), dbname)
})


#' finalize
#' 
#' closes the connection to the database
WordsDB$methods(finalize = function() dbDisconnect(dataConn))


#' getWordID
#' 
#' get from the dictionary a word's ID 
#' 
#' @param x a character vector of words
#' 
#' @return a vector of IDs of the same length as input. If a word isn't present
#' in a dictionary, returns NA instead.
WordsDB$methods(getWordID = function(x) {
  out <- vector(mode = "numeric", length = length(x))
  for (i in seq_along(x)) {
    word <- gsub("'", "''", x[i])
    q <- paste0("select id from dict where word == '", word, "'")
    res <- dbGetQuery(dataConn, q)
    out[i] <- ifelse(nrow(res) == 1, res[1, 1], NA)
  }
  out
})


#' getWord
#' 
#' obtain a word by its ID
#' 
#' @param x a numeric vector of IDs
WordsDB$methods(getWord = function(x) {
  if (is.null(x)) return(NULL)
  out <- vector(mode = "character", length = length(x))

  #remember positions of NAs and remove them from input
  idx <- !is.na(x)
  x <- x[idx]
  
  for (i in seq_along(x)) {
    q <- paste0("select word from dict where id == ", x[i])
    res <- dbGetQuery(dataConn, q)
    out[i] <- ifelse(nrow(res) == 1, res[1, 1], NA)
  }
  #insert NAs signatures back
  tmp <- rep(".NA.", length(idx))
  tmp[idx] <- out
  (tmp)
})


#' getNextTopN
#'
#' obtains next word predictions from the database. Candidates are sorted by
#' frequency
#' 
#' @param x a numeric vector id word IDs
#' @param nLimit a number of top candidates to return
#' 
#' @return a dataframe with predictions in rows, and a column frequency 
#' representing the probability of appearance of this 'next word'
WordsDB$methods(getNextTopN = function(x, nLimit = 5) {
  if (length(x) < 1 | length(x) > 4 | #incorrect input
      length(x) < 3 & sum(is.na(x)) > 0 | #NA's in short terms
      is.na(x[1])) #first mustn't be an NA
    return (data.frame())
  
  tabname <- c("bigrams", "trigrams", "fourgrams", "fivegrams")[length(x)]
  
  #compose an SQL query
  where <- c()
  groupBy <- c()
  for(i in seq_along(x)) {
    if (!is.na(x[i])) {
      where <- c(where, paste0("idword", as.character(i), " == ", x[i]))
      groupBy <- c(groupBy, paste0("idword", as.character(i)))
    }
  }
  where <- paste(where, collapse = " and ")
  groupBy <- paste(c(groupBy, "idnext"), collapse = ",")
  #get summary frequency for this term
  q <- paste("select sum(freq) from", tabname, 
             "where", where)
  res <- dbGetQuery(dataConn, q)
  sumFreq <- res[1, 1]
  if (is.na(sumFreq) | sumFreq < 1)
    return (data.frame())
  
  if (sum(is.na(x)) > 0) {
    selectFrom <- "select idnext, sum(freq) as freq from"
    groupBy <- paste("group by", paste(c(groupBy, "idnext"), collapse = ","))
    odrerBy <- "order by sum(freq) desc"
  } else {
    selectFrom <- "select idnext, freq from"
    groupBy <- ""
    odrerBy <- "order by freq desc"
  }
  q <- paste(selectFrom, tabname, 
             "where", where,
             groupBy,
             odrerBy,
             "limit", nLimit)
  
  #get top terms
  df <- dbGetQuery(dataConn, q)
  df$freq <- df$freq / sumFreq
  df
})


#' makeQueryListWordPresence
#'
#' creates a list of queries to find all appearances of a word
#' 
#' @param wordId a word's id
#' @param limit a limit of lines to return from database
#' 
#' @return a list of characters, containing SQL queries 
WordsDB$methods(makeQueryListWordPresence = function(wordId, limit = 20) {
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
                      "ORDER BY b.freq desc",
                      "LIMIT", limit)
    out[[itab]] <- wholeQue
  }
  out
})


#' wordPresence
#' 
#' find the word's presence in all phrases in database
#' 
#' @param word a character word
#' @param ... passed to makeQueryListWordPresence function
#' 
#' @return a list of lists with pfrases
WordsDB$methods(wordPresence = function(word, ...) {
  word <- cleanInput(word)
  if(length(word) == 0)
    return(list())
  
  wordId <- getWordID(word)
  if (is.na(wordId))
    return(list())
  
  lapply(makeQueryListWordPresence(wordId, ...), 
         function(que) dbGetQuery(dataConn, que))
})