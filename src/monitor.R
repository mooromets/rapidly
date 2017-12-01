IS_MONITOR <- TRUE

MonitorData <- list()

monitorReset <- function(){
if (IS_MONITOR)  
  MonitorData <<- list()   
}

monitorCleanStatement <- function(clean) {
  if (IS_MONITOR)
    MonitorData[["cleanStatement"]] <<- clean
}

monitorCleanStatementIDs <- function(df) {
  if (IS_MONITOR)
    MonitorData[["cleanStatementIDs"]] <<- df
}

monitorAnswersList <- function(al) {
  if (IS_MONITOR) {
    li <- lapply(al, 
                function(item) {
                  if (! is.null(item$nextIds)) {
                    return(list(words = getWord(item$words, dataDB()),
                                nextdf = data.frame(nextWords = getWord(item$nextIds, dataDB()),
                                                    nextProb = item$nextProb)))
                  } else {
                    return(list(words = getWord(item$words, dataDB()),
                                nextdf = data.frame(nextWords = c(".NULL."),
                                                    nextProb = c(".NULL."))))
                  }
                    
                })
    MonitorData[["answersList"]] <<- li
  }
}

monitorAllScores <- function(as) {
  if (IS_MONITOR) {
    df <- data.frame(word = getWord(as[, "nextId"], dataDB()),
                     score = as[, "score"])
    MonitorData[["allScores"]] <<- df
  }
}

monitorFinalScore <- function(fs) {
  if (IS_MONITOR) {
    fs <- as.data.frame(fs)
    df <- data.frame(word = getWord(fs[, "nextId"], dataDB()),
                     score = fs[, "score"])
    MonitorData[["finalScore"]] <<- df
  }
}
