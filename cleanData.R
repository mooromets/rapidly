library(tm)
library(RWeka)

corpV <- VCorpus(DirSource("./data/chunks/"))

nGramTok <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2, 
                                          delimiters = ' \r\n\t,;:"()?!'))
system.time(
tdm2 <- TermDocumentMatrix(corpV, list(tokenize = nGramTok, 
                                       wordLengths=c(1,Inf),
                                       tolower = FALSE))
)