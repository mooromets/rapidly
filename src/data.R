
getWordID <- function(x, conn) {
  #q <- paste0("select id from dict where word IN ('", paste(x, collapse = "', '"), "')")
  ret <- vector(mode = "numeric", length = length(x))
  for (i in seq_along(x)) {
    word <- gsub("'", "''", x[i])
    q <- paste0("select id from dict where word == '", word, "'")
    res <- dbGetQuery(conn, q)
    ret[i] <- ifelse(nrow(res) == 1, res[1, 1], NA)
  }
  ret
}

getWord <- function(x, conn) {
#  q <- paste0("select word from dict where id IN (", paste(x, collapse = ", "), ")")
  ret <- vector(mode = "character", length = length(x))
  for (i in seq_along(x)) {
    q <- paste0("select word from dict where id == ", x[i])
    res <- dbGetQuery(conn, q)
    ret[i] <- ifelse(nrow(res) == 1, res[1, 1], NA)
  }
  ret
}


getNextTopN <- function(x, conn, nLimit) {
  if (length(x) < 1 | length(x) > 4 | #incorrect input
      sum(is.na(x)) > 0)
#      length(x) < 3 & sum(is.na(x)) > 0 | #NA's in short terms
#      is.na(x[1])) #first mustn't be an NA
    return (data.frame())
  
  tabname <- c("bigrams", "trigrams", "fourgrams", "fivegrams")[length(x)]
  where <- c()
  for(i in seq_along(x)) {
#    if (!is.na(x[i]))
      where <- c(where, paste0("idword", as.character(i), " == ", x[i]))
  }
  where <- paste(where, collapse = " and ")
  #get summary frequency for this term
  q <- paste("select sum(freq) from", tabname, 
             "where", where)
  res <- dbGetQuery(conn, q)
  sumFreq <- res[1, 1]
  if (is.na(sumFreq) | sumFreq < 1)
    return (data.frame())
  #get top terms term
  q <- paste("select idnext, freq from", tabname, 
             "where", where,
             "order by freq desc",
             "limit", nLimit)
  df <- dbGetQuery(conn, q)
  df$freq <- df$freq / sumFreq
  df
}

#conn <- dbConnect(RSQLite::SQLite(), "data/words0.db")
#print(getWordID(c("take", "dsafads", "look", "a"), conn))
#print(getWord(c(1000000, 810, 160189, 54), conn))
#print(getNextTopN(c(810, NA, 160189), conn, 5))
#dbDisconnect(conn)

