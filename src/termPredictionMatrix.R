
# split ngram into 2 parts: predictor and outcome
splitTerm <- function (allTerms) {
  require(stringr)
  as.data.frame(str_match(allTerms$term, "(.+) ([^[:space:]]+)$")[, 2:3],
                stringsAsFactors = FALSE)
}

# apply stemming on each word of the nrgam
stemNgram <- function(ngrams) {
  require(SnowballC)
  unlist(lapply(lapply(strsplit(ngrams, " "), wordStem), 
                paste, 
                collapse = " "))
}

mostFreqUnique <- function(TPM) {
  do.call(rbind, lapply(unique(TPM$pred), function(term) {
    allStates <- TPM %>% 
      filter(pred == term) %>%
      mutate(prob = freq / sum(freq)) %>%
      top_n(3, wt = prob)
    data.frame(pred = term,
               outcome1 = allStates$outcome[1],
               prob1 = allStates$prob[1],
               outcome2 = allStates$outcome[2],
               prob2 = allStates$prob[2],
               outcome3 = allStates$outcome[3],
               prob3 = allStates$prob[3],
               stringsAsFactors = FALSE)
    }))
}

mostFreqNotUnique <- function(TPM) {
  do.call(rbind, lapply(unique(TPM$pred), function(term) {
    TPM %>% 
      filter(pred == term) %>%
      mutate(prob = freq / sum(freq))
  }))
}

# Term-prediction matrix
tpm <- function(input) {
  input[, 3:4] <- splitTerm(input) # split terms to predictor and outcome
  #input$V1 <-stemNgram(input$V1) # stemming predictor only
                                  # stemming pros not proved yet
  input$V1 <-tolower(input$V1) # predictor to lower case
  # remove duplicates
  input <- input %>% 
    rename(pred = V1, outcome = V2) %>%
    group_by(pred, outcome) %>%
    summarise(freq = sum(freq.x))
  # calculate probabilities
  mostFreqUnique(input)
}
