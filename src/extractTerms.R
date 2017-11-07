library(tm)
library(RWeka)
library(dplyr)

source("src/customTDM.R")

extractTerms <- function (ngram = 1, chunksDir = "data/chunks/train/"){
  tmpDir <- paste0("data/ngramchunks/", as.character(ngram), "/")
  if (!dir.exists(tmpDir)) 
    dir.create(tmpDir)
  
  dirList <- paste0(chunksDir, dir(chunksDir))
  require(parallel)
  cluster <- makeCluster(detectCores()-1)
  clusterExport(cluster, c("VCorpus", "DirSource", "termsInDF", "Weka_control",
                           "customTDMn", "ctrlList", "customDelimiters",
                           "NGramTokenizer", "TermDocumentMatrix"))
  clusterExport(cluster, c("ngram", "tmpDir"), envir = environment())
  
  dirList <- sample(dirList, length(dirList)) #shuffle to ease workload
                                                    #TODO sort by filesize
  times <- parLapply(cluster, dirList, function (dirname) {
    corpV <- VCorpus(DirSource(dirname))
    termNGram <- termsInDF(customTDMn(corpV, ngram))
    write.csv(termNGram, row.names = FALSE, 
              file = paste0(tmpDir, gsub("/", "", dirname), ".csv"))
    })
  stopCluster(cluster)
  
  filesList <- paste0(tmpDir, dir(tmpDir))
  leftTerms <- read.csv(filesList[1], stringsAsFactors = FALSE)
  for(i in 2:length(filesList)) {
    rightTerms <- read.csv(filesList[i], stringsAsFactors = FALSE)
    leftTerms <- full_join(leftTerms, rightTerms, by = "term")
    # merge frequencies columns
    leftTerms[, 2] <- apply(leftTerms[, -1], 1, sum, na.rm = TRUE)
    leftTerms <- leftTerms[, 1:2]
  }
  leftTerms
}