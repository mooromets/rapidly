source("src/common.R")
source("src/cleanText.R")
source("src/data.R")

generateAllQueries <- function(queryIDs, predWordMaxCount = 4) {
  allReqs <- list()
  for (i in seq_len(predWordMaxCount)) {
    #reqular terms
    vec <- queryIDs[max(1, length(queryIDs) - i + 1) : length(queryIDs)]
    while (is.na(vec[1]) & length(vec) > 0) vec <- vec[-1] # when NA was in the middle
    #NAs in short requests are not allowed
    if (length(vec) <= 2 & sum(is.na(vec)) > 0 | length(vec) == 0 | sum(is.na(vec)) > 1)
      next
    allReqs <- c(allReqs, list(q = vec))
    #    #masked terms
    #    if (i > 2 & length(queryIDs) > 2) {
    #      for(j in (2 : i)){
    #        #same as regular
    #        vec <- queryIDs[max(1, length(queryIDs) - i + 1) : length(queryIDs)]
    #        #add mask
    #        vec[j] <- NA
    #        if (sum(is.na(vec)) == 1)
    #          allReqs <- c(allReqs, list(q = vec))
    #      }
    #    }
    if (i == length(queryIDs)) break
  }
  unique(allReqs)
}

lookDB <- function(query, resFUN, TopNPerReq = 5, conn = dataDB(), monitor = FALSE, ...) {
  IS_MONITOR <<- monitor
  
  query <- cleanInput(query)
  monitorCleanStatement(query)  
  if (length(query) == 0)
    return(DEFAULT_PREDICTION)

  #extract (maximum) four last words
  predWordMaxCount <- 4
  query <- unlist(strsplit(as.character(query), " "))
  if (length(query) == 0) 
    return (DEFAULT_PREDICTION)
  #query <- query[nchar(query) > 0] --- cleanText() did this job
  query <- query[max(1, length(query) - predWordMaxCount + 1) : length(query)]
  
  #main job starts here
  queryIDs <- getWordID(query, conn)
  monitorCleanStatementIDs(data.frame(word = query, id = as.integer(queryIDs)))
  allReqs <-  generateAllQueries(queryIDs, predWordMaxCount)
  answerList <- lapply(allReqs, 
                       function(rqst) {
                         nxt <- getNextTopN(rqst, conn, TopNPerReq)
                         list(words = rqst,
                              nextIds = nxt$idnext,
                              nextProb = nxt$freq)
                       })
  monitorAnswersList(answerList)
  best3id <- resFUN(answerList)
  words <- c(getWord(best3id, conn), DEFAULT_PREDICTION) #add default if there's not enoght predictions
  return(words[1:3])
}