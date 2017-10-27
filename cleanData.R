library(tm)
library(RWeka)

system.time(
corpV <- VCorpus(DirSource("./data/chunks/"))
)

tdm1 <- TermDocumentMatrix(corpV)

nGramTok <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))

system.time(
tdm2 <- TermDocumentMatrix(corpV, list(tokenize = nGramTok, wordLengths=c(1,Inf)))
)

head(findFreqTerms(tdm2, 5000), 40)
