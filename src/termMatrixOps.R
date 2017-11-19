# functions to perform different operations on term matrices

require(tm)
require(RWeka)

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