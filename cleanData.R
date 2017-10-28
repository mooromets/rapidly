library(tm)
library(RWeka)

system.time(
corpV <- VCorpus(DirSource("./data/chunks/"))
)

tdm1 <- TermDocumentMatrix(corpV, list(tolower = FALSE))

nGramTok <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2, 
                                          delimiters = ' \r\n\t,;:"()?!'))
system.time(
tdm2 <- TermDocumentMatrix(corpV, list(tokenize = nGramTok, 
                                       wordLengths=c(1,Inf),
                                       tolower = FALSE))
)

#head(findFreqTerms(tdm2, 10000), 20)
