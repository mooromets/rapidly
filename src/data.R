
getWordID <- function(x, conn) {
  #q <- paste0("select id from dict where word IN ('", paste(x, collapse = "', '"), "')")
  #TODO refactor
  #SELECT * FROM dict where word IN ('be', 'a', 'that') 
  #ORDER BY   
  #CASE word
  #WHEN 'be' THEN 0
  #WHEN 'a' THEN 1
  #WHEN 'that' THEN 2
  #END
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
  if (is.null(x)) return(NULL)
  #remember position of NAs and remove them
  
  idx <- !is.na(x)
  x <- x[idx]
#  q <- paste0("select word from dict where id IN (", paste(x, collapse = ", "), ")")
  ret <- vector(mode = "character", length = length(x))
  for (i in seq_along(x)) {
    q <- paste0("select word from dict where id == ", x[i])
    res <- dbGetQuery(conn, q)
    ret[i] <- ifelse(nrow(res) == 1, res[1, 1], NA)
  }
  tmp <- rep(".NA.", length(idx))
  tmp[idx] <- ret
  (tmp)
}


getNextTopN <- function(x, conn, nLimit) {
  if (length(x) < 1 | length(x) > 4 | #incorrect input
      length(x) < 3 & sum(is.na(x)) > 0 | #NA's in short terms
      is.na(x[1])) #first mustn't be an NA
    return (data.frame())
  
  tabname <- c("bigrams", "trigrams", "fourgrams", "fivegrams")[length(x)]
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
  res <- dbGetQuery(conn, q)
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
  
  #get top terms term
  q <- paste(selectFrom, tabname, 
             "where", where,
             groupBy,
             odrerBy,
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

