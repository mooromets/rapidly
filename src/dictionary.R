library(Matrix)
library(tm)
options(java.parameters = "-Xmx4096m")
library(RWeka)
source("src/cleanText.R")
source("src/termMatrixOps.R")

fullDictFile <- "fullDictionary.csv"
cleanDictFile <- "cleanDictionary.csv"

getTermsInMatrix <- function(dirname) {
  corp <- VCorpus(DirSource(dirname))
  corp <- tm_map(corp, content_transformer(cleanText))
  as.matrix(ngramTdm(corp))
}

createDictionary <- function(dirPath, outPath, minFreqThreshold = 3) {
  hash <- new.env(hash = TRUE)
  for(idir in paste0(dirPath, dir(dirPath))) {
    if (!file.info(idir)$isdir) next # not a directory
    if (length(dir(idir)) == 0) next # empty directory
    mtx <- getTermsInMatrix(idir)
    print(paste(idir, " Time:"))
    print(system.time({
      for (j in seq_len(nrow(mtx))) {
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