library(Matrix)

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

mostFreqUnique2 <- function(TPM, portionSize = 100) {
  idxL <- 0
  outData <- data.frame()
  repeat {
    idxH <- min(idxL + portionSize, nrow(TPM))
    while (idxH < nrow(TPM) && TPM[idxH, "pred"] == TPM[idxH + 1, "pred"]) {
      idxH <- idxH + 1
    }
    outData <- rbind(outData, mostFreqUnique(TPM[idxL:idxH, ]))
    if (idxH == nrow(TPM)) {
      break
    }
    idxL <- idxH
  }
  outData
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
   mostFreqUnique2(input)
  #input
}

# Term-prediction matrix
tpm2 <- function(input) {
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
  require(Matrix)
  is <- unique(input$pred)
  js <- unique(input$outcome)
  sparseMatrix( as.factor(input$pred),
                as.factor(input$outcome),
                x = income$freq)
  #input
}

# Term-prediction matrix
sparseTPM <- function(input) {
  require(dplyr)
  print(system.time({
  input[, 3:4] <- splitTerm(input) # split terms to predictor and outcome
  #input$V1 <-stemNgram(input$V1) # stemming predictor only
  # stemming pros not proved yet
  input$V1 <-tolower(input$V1) # predictor to lower case
  # remove duplicates
  input <- input %>% 
    rename(pred = V1, outcome = V2) %>%
    group_by(pred, outcome) %>%
    summarise(freq = sum(freq.x))
  require(Matrix)
  is <- as.factor(input$pred)
  js <- as.factor(input$outcome)
  spa <- sparseMatrix( as.integer(is),
                       as.integer(js),
                       x = input$freq)
  colnames(spa) = levels(js)
  rownames(spa) = levels(is)
  }))
  spa
}

writeMMTPM <- function(matrix, filenameWOExtension) {
  writeMM(matrix, paste0(filenameWOExtension, ".mtx"))
  write(colnames(matrix), paste0(filenameWOExtension, "cols.csv"), sep="\n")
  write(rownames(matrix), paste0(filenameWOExtension, "rows.csv"), sep="\n")
}

readMMTPM <- function(filenameWOExtension) {
  matrix <- as(readMM(paste0(filenameWOExtension, ".mtx")), "CsparseMatrix")
  cols <- read.csv(paste0(filenameWOExtension, "cols.csv"), 
                   stringsAsFactors = FALSE,
                   header = FALSE)
  rows <- read.csv(paste0(filenameWOExtension, "rows.csv"), 
                   stringsAsFactors = FALSE,
                   header = FALSE)
  colnames(matrix) <- cols[, 1]
  rownames(matrix) <- rows[, 1]
  matrix
}

loadSparseTPM <- function(tpmDF) {
  sparseMatrix(tpmDF[, ncol(tpmDF) - 2],
               tpmDF[, ncol(tpmDF) - 1],
               x = tpmDF[, ncol(tpmDF)])
}
