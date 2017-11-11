library(tm)
options(java.parameters = "-Xmx4096m")
library(RWeka)
source("src/cleanFiles.R")

# sample data
inPath <- "data/final/en_US/"
outPath <- "data/corpora/"
#makeSamples(inPath, outPath)

# process every file
dirsList <- dir(paste0(outPath, "train/"))
N <- 3
for (idir in dirsList) {
  gc()
  # read
  print(Sys.time())
  corp <- VCorpus(DirSource(paste0(outPath, "train/", idir)))
  # clean
  Sys.time()
  corp <- tm_map(corp, content_transformer(tolower))
  corp <- tm_map(corp, content_transformer(removeNumbers))
  corp <- tm_map(corp, content_transformer(removePunctuation))
  # dictionary
  print(Sys.time())
  nGramTok <- function(x) NGramTokenizer(x, Weka_control(min = N, max = N))
  tdm <- TermDocumentMatrix(corp, control =  list (tokenize = nGramTok))
  print(Sys.time())
  write.csv(as.data.frame(as.matrix(tdm)), paste0("data/", idir, as.character(N), ".csv" ))
}

#3. read data
#inputDir <- "./data/final/en_US2/"
#corp <- VCorpus(DirSource(inputDir))

#4 clean data
#corp <- tm_map(corp, content_transformer(tolower))
#corp <- tm_map(corp, content_transformer(removeNumbers))
#corp <- tm_map(corp, content_transformer(removePunctuation))

#5 create dictionary
#allTerms <- as.matrix(TermDocumentMatrix(corp)) #  ctrlList <- list(wordLengths = c(1,Inf), tolower = FALSE, stopwords = FALSE)

#listTerms <- as.list(allTerms)
#names(listTerms) <- rownames(allTerms)
#hash <- list2env(listTerms, hash = TRUE)
#clear memory

#rm(allTerms)
#rm(listTerms)
gc()


