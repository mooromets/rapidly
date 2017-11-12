library(Matrix)
library(tm)
options(java.parameters = "-Xmx4096m")
library(RWeka)
source("src/cleanCorpus.R")

fullDictFile <- "data/fullDictionary.csv"
cleanDictFile <- "data/cleanDictionary.csv"

getTermsInMatrix <- function(dirname, control = list()) {
  print("corp read"); print(Sys.time())
  corp <- VCorpus(DirSource(dirname))
  print("corp clean"); print(Sys.time())
  corp <- cleanCorpus(corp)
  control$tokenize <- WordTokenizer
  print("TMD construct"); print(Sys.time())
  tdm <- TermDocumentMatrix(corp, control)
  as.matrix(tdm)
}

createDictionary <- function(dirPath, minFreqThreshold = 3) {
  dirList <- paste0(dirPath, dir(dirPath))
  hash <- new.env(hash = TRUE)
  for(idir in dirList) {
    mtx <- getTermsInMatrix(idir)
    print(paste(idir, " Time:"))
    print(system.time({
      for (j in 1:nrow(mtx)) {
        val <- rownames(mtx)[j]
        if (exists(val, envir = hash)) {
          hash[[val]] <- hash[[val]] + mtx[j, 1]
        } else {
          hash[[val]] <- mtx[j, 1]
        }
      }
      rm(mtx) 
    }))
  }
  newDF <- do.call(rbind.data.frame, as.list(hash))
  write.csv(newDF, fullDictFile)
  # filter wrong spelled words
  index <- newDF[, 1] > minFreqThreshold
  write.csv(data.frame(term = rownames(newDF)[index],
                       freq = newDF[index, 1]), 
            cleanDictFile,
            row.names = FALSE)
}

loadDictionaryHash <- function(filePath = cleanDictFile) {
  df <- read.csv(filePath)
  tmpList <- as.list(as.numeric(rownames(df)))
  names(tmpList) <- df$term
  list2env(tmpList, hash = TRUE)
}

loadDictionaryVect <- function(filePath = cleanDictFile) {
  df <- read.csv(filePath)
  as.vector(df$term)
}