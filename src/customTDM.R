# functions to create customed TDM

require(tm)
library(RWeka)

# common contol list
ctrlList <- list(wordLengths = c(1,Inf),
                 tolower = FALSE,
                 stopwords = FALSE)
customDelimiters <- ' \r\n\t,;:"()?!' # without ['-.]

# nGram TDM
customTDMn <- function (corpus, nGramMin = 1, nGramMax = nGramMin) {
  nGramTok <- function(x) NGramTokenizer(x, Weka_control(min = nGramMin, 
                                                         max = nGramMax, 
                                              delimiters = customDelimiters))
  ctrlList$tokenize = nGramTok
  TermDocumentMatrix(corpus, ctrlList)
}

# get most frequent terms in data.frame
# uses only the first document from TDM
freqTermsInDF <- function(tdm, lowerBound = 3) {
  df <- data.frame(as.matrix(tdm), stringsAsFactors = FALSE)
  index <- df[, 1] >= lowerBound
  data.frame(term = rownames(df)[index], 
             freq =  df[index, 1],
             stringsAsFactors = FALSE)
}

# get terms in data.frame
# uses only the first document from TDM
termsInDF <- function(tdm) {
  df <- data.frame(as.matrix(tdm), stringsAsFactors = FALSE)
  data.frame(term = rownames(df), 
             freq =  df[, 1],
             stringsAsFactors = FALSE)
}

