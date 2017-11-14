library(Matrix)
library(tm)
options(java.parameters = "-Xmx4096m")
library(RWeka)
source("src/cleanText.R")

fullDictFile <- "fullDictionary.csv"
cleanDictFile <- "cleanDictionary.csv"

getTermsInMatrix <- function(dirname, control = list()) {
  print("corp read"); print(Sys.time())
  corp <- VCorpus(DirSource(dirname))
  print("corp clean"); print(Sys.time())
  corp <- tm_map(corp, content_transformer(cleanText))
  control$tokenize <- WordTokenizer
  print("TMD construct"); print(Sys.time())
  tdm <- TermDocumentMatrix(corp, control)
  as.matrix(tdm)
}

createDictionary <- function(dirPath, outPath, minFreqThreshold = 3) {
  dirList <- paste0(dirPath, dir(dirPath))
  hash <- new.env(hash = TRUE)
  for(idir in dirList) {
    mtx <- getTermsInMatrix(idir, list(wordLengths=c(1,Inf)))
    print(paste(idir, " Time:"))
    print(system.time({
      for (j in 1:nrow(mtx)) {
        val <- rownames(mtx)[j]
        if (exists(val, envir = hash, inherits = FALSE)) {
          hash[[val]] <- hash[[val]] + mtx[j, 1]
        } else {
          hash[[val]] <- mtx[j, 1]
        }
      }
      rm(mtx) 
    }))
  }
  newDF <- do.call(rbind.data.frame, as.list(hash))
  write.csv(newDF, paste0(outPath, fullDictFile))
  # filter wrong spelled words
  index <- newDF[, 1] > minFreqThreshold
  write.csv(data.frame(term = rownames(newDF)[index],
                       freq = newDF[index, 1]), 
            paste0(outPath, cleanDictFile),
            row.names = FALSE)
}

loadDictionaryHash <- function(filePath = cleanDictFile, basePath = "data/") {
  df <- read.csv(paste0(basePath, filePath))
  tmpList <- as.list(as.numeric(rownames(df)))
  names(tmpList) <- df$term
  list2env(tmpList, hash = TRUE)
}

loadDictionaryVect <- function(filePath = cleanDictFile, basePath = "data/") {
  df <- read.csv(paste0(basePath, filePath))
  as.vector(df$term)
}