# functions to create customed TDM

require(tm)
library(RWeka)

# common contol list
ctrlList <- list(wordLengths = c(1,Inf),
                 tolower = FALSE,
                 stopwords = FALSE)
customDelimiters <- ' \r\n\t,;:"()?!' # without ['-.]

# single-word TDM
myTDM1 <- function (corpus) {
  TermDocumentMatrix(corpus, ctrlList)
}

# nGram TDM
myTDMn <- function (corpus, nGramMin, nGramMax = nGramMin) {
  nGramTok <- function(x) NGramTokenizer(x, Weka_control(min = nGramMin, 
                                                         max = nGramMax, 
                                              delimiters = customDelimiters))
  ctrlList$tokenize = nGramTok
  TermDocumentMatrix(corpus, ctrlList)
}