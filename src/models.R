# different models for picking the next word predictions

library(dplyr)
source("src/monitor.R")


#' bestWithMask
#' 
#' chooses top 3 results from a list of top 5 results from each query,
#' including queries with mask (absent words)
#'  
#' @param items a list of dataframes, one dataframe per query
#' @param alpha a coefficient to decrease the score of shorter queries
#' @param maskedPow a coefficient for masked queries
#' 
#' @return a vector of top 3 prediction IDs in the order of their score, descending
bestWithMask <- function(items, alpha = 0.5, maskedPow = 1.7) {
  if (length(items) == 0) 
    return(vector())
  
  #form all scores dataframe
  allPred <- do.call(rbind, lapply(items,
                #each dataframe from a list
                function(item){
                  if (length(item$nextIds) == 0)
                    return(data.frame())
                  #define alpha, depending on the number of words in a query
                  a <- alpha ^ (4 - length(item$words))
                  if (sum(is.na(item$words))> 0)
                    a <- a * alpha ^ maskedPow
                  #create and return a DF
                  data.frame(nextId = item$nextIds, 
                             score = item$nextProb * a)
                }))
  
  MONITOR$storeAllScores(allPred)
  
  if (nrow(allPred) == 0)
    return(vector())

  #calculate final scores
  allPred <- as.data.frame(allPred %>% 
    group_by(nextId) %>%
    summarise(score =  sum(score)) %>%
    arrange(desc(score)))
  
  MONITOR$storeFinalScore(allPred)
  
  # return top 3
  allPred <- top_n(allPred, n = 3, score)
  as.vector(allPred$nextId)
}