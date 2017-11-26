# functions to perform different operations on term matrices

require(tm)
require(RWeka)
source("src/common.R")
source("src/cleanText.R")
source("src/data.R")

# ngramTdm - create Term Document Matrix for the specific ngram
ngramTdm <- function (corpus, ngram = 1, minTermLen = 1, minBound = 1, delims = ' \r\n\t.,;:"()?!') {
  nGramTok <- function(x) NGramTokenizer(x, Weka_control(min = ngram, max = ngram, delimiters = delims))
  ctrlList <- list(wordLengths = c(minTermLen, Inf),
                   tokenize = nGramTok,
                   tolower = FALSE,
                   bounds = list(local = c(minBound, Inf)))
  TermDocumentMatrix(corpus, ctrlList)
}

# write a sparse Term-Prediction Matrix into a file
writeMMTPM <- function(matrix, filenameWOExtension) {
  writeMM(matrix, paste0(filenameWOExtension, ".mtx"))
  write(colnames(matrix), paste0(filenameWOExtension, "cols.csv"), sep="\n")
  write(rownames(matrix), paste0(filenameWOExtension, "rows.csv"), sep="\n")
}

# read a sparse Term-Prediction Matrix from a file
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

# create a sparse Term-Prediction Matrix from a TPM data.frame
loadSparseTPM <- function(tpmDF) {
  sparseMatrix(tpmDF[, ncol(tpmDF) - 2],
               tpmDF[, ncol(tpmDF) - 1],
               x = tpmDF[, ncol(tpmDF)])
}

#'
#' @param query
#' @param rowFUN Returns vector of most probable next words in a specific ngram-matrix
#' @param tpm
#' @param sparseTpm
#' @param ngramIDs
#' @param dictHash
#' @param dictVec
#'
findNgram <- function(queryIDs, rowFUN, tpm, sparseTpm, ngramIDs, dictVec) {
  matchCols <- colnames(tpm)[1 : (ncol(tpm) - 3)]
  if(length(queryIDs) !=  length(matchCols)) #too short query
    return (NULL)
  require(dplyr)
  fCond <- paste(sapply(seq_along(matchCols), 
                        function(i) paste(matchCols[i], " == ", queryIDs[i])), 
                 collapse = " & ")
  res <- filter_(ngramIDs, fCond)
  if (nrow(res) > 0) {
    return (rowFUN(sparseTpm[as.numeric(res[ncol(res)]), ], dictVec))
  }
  else 
    return(NULL)
}


#' Get a prediction of the next word
#' 
#' @param query An input phrase
#' @param resFUN Compells the result from the list of results obtained from single calls to each ngram-matrix
#' @param rowFUN Returns vector of most probable next words in a specific ngram-matrix
#' @param sparseTpmList
#' @param ngramTdmList
#' @param idsList
#' @param dictHash 
#' @param dictVec
#' @return A vector of three most probable next words
lookUp <- function(query, resFUN, rowFUN, sparseTpmList, ngramTdmList, idsList, 
                   dictHash, dictVec, ...) {
  if (length(sparseTpmList) == 0) 
    return (NULL)
  query <- unlist(strsplit(as.character(query), " "))
  if (length(query) == 0) 
    return (NULL)
  query <- query[nchar(query) > 0]
  queryIDs <- unlist(sapply(query, function(x) dictHash[[x]]))
  answerList <- list()
  for (i in seq_along(sparseTpmList)) {
    if (i > length(queryIDs)) 
      break
    subQuery <- queryIDs[((length(queryIDs) - i) + 1) : length(queryIDs)]
    topRes <- findNgram(subQuery, rowFUN, ngramTdmList[[i]], 
              sparseTpmList[[i]], idsList[[i]], dictVec)
    answerList[[i]] <- topRes
  }
  resFUN(answerList)
}


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


lookDB <- function(query, resFUN, TopNPerReq = 5, conn = dataDB(), ...) {
  # check input
  if (length(query) == 0)
    return(DEFAULT_PREDICTION)
  else if (length(query) != 1)
    query <- query[length(query)]

  #cut input to save some time on cleaning it
  query <- substr(query, max(1, nchar(query) - MAX_TERM_LEN), nchar(query))
  query <- cleanText(query)
  # pick only the last line
  if (length(query) != 1)
    query <- query[length(query)]

  #extract (maximum) four last words
  predWordMaxCount <- 4
  query <- unlist(strsplit(as.character(query), " "))
  if (length(query) == 0) 
    return (DEFAULT_PREDICTION)
  #query <- query[nchar(query) > 0] --- cleanText() did this job
  query <- query[max(1, length(query) - predWordMaxCount + 1) : length(query)]

  #main job starts here
  queryIDs <- getWordID(query, conn)
  allReqs <-  generateAllQueries(queryIDs, predWordMaxCount)
  answerList <- lapply(allReqs, 
                       function(rqst) {
                         nxt <- getNextTopN(rqst, conn, TopNPerReq)
                         list(words = rqst,
                              nextIds = nxt$idnext,
                              nextProb = nxt$freq)
                       })
  best3id <- resFUN(answerList)
  words <- c(getWord(best3id, conn), DEFAULT_PREDICTION) #add default if there's not enoght predictions
  return(words[1:3])
}

#lookDB("have you any", sum)