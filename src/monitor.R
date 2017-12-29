#' Monitor is a singleton class that keeps track on how a prediction was made

source("src/wordsDB.R")

Monitor <- setRefClass("Monitor",
                       fields = list(is_enabled = "logical",
                                     m_data = "list"))

#' initialize 
#' 
Monitor$methods(initialize = function(enabled = FALSE) {
  .self$is_enabled <- enabled
  .self$m_data <- list()
})


#' reset
#' 
Monitor$methods(reset = function(){
  if (is_enabled)  
    .self$m_data <- list()   
})


#' storeCleanStatement
#' 
#' store the clean statement data
#' 
#' @param clean a string, containing the clean statement
Monitor$methods(storeCleanStatement = function(clean) {
  if (is_enabled)
    .self$m_data[["cleanStatement"]] <- clean
})


#' storeCleanStatementIDs
#'
#' store words IDs of a clean sentence  
#'
#' @param ids a vector of IDs  
Monitor$methods(storeCleanStatementIDs = function(ids) {
  if (is_enabled)
    .self$m_data[["cleanStatementIDs"]] <- ids
})


#' storeAnswersList
#'
#' store all answers obtained
#' 
#' @param al a character list of possible next word candidates    
Monitor$methods(storeAnswersList = function(al) {
  if (is_enabled) {
    wdb <- WordsDB()
    li <- lapply(al, 
                function(item) {
                  if (! is.null(item$nextIds)) {
                    return(list(words = wdb$getWord(item$words),
                                nextdf = data.frame(nextWords = wdb$getWord(item$nextIds),
                                                    nextProb = item$nextProb)))
                  } else {
                    return(list(words = wdb$getWord(item$words),
                                nextdf = data.frame(nextWords = c(".NULL."),
                                                    nextProb = c(".NULL."))))
                  }
                    
                })
    .self$m_data[["answersList"]] <- li
  }
})


#' storeAllScores
#' 
#' store the scores every answer got
#' 
#' @param as a dataframe, containing predicted answers
Monitor$methods(storeAllScores = function(as) {
  if (is_enabled) {
    wdb <- WordsDB()
    df <- data.frame(word = wdb$getWord(as[, "nextId"]),
                     score = as[, "score"])
    .self$m_data[["allScores"]] <- df
  }
})


#' storeFinalScore
#' 
#' store the final cumulative score for every prediction
#' 
#' @param fs a dataframe with scores
Monitor$methods(storeFinalScore = function(fs) {
  if (is_enabled) {
    wdb <- WordsDB()
    fs <- as.data.frame(fs)
    df <- data.frame(word = wdb$getWord(fs[, "nextId"]),
                     score = fs[, "score"])
    .self$m_data[["finalScore"]] <- df
  }
})