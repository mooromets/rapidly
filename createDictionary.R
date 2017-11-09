library(Matrix)
library(tm)

chunksPath <- "data/chunks/train/"

getTermsInMatrix <- function(dirname) {
  ctrlList <- list(wordLengths = c(1,Inf), tolower = FALSE, stopwords = FALSE)
  corp <- VCorpus(DirSource(dirname))
  tdm <- TermDocumentMatrix(corp, ctrlList)
  as.matrix(tdm)
}

dirList <- paste0(chunksPath, dir(chunksPath))
# initialize hash with the first chunk
mtx <- getTermsInMatrix(dirList[1])
listTerms <- as.list(mtx)
names(listTerms) <- rownames(mtx)
hash <- list2env(listTerms, hash = TRUE)
#clear memory
rm(mtx)
rm(listTerms)
gc()
# loop on all other chunks
for(i in 2:length(dirList)) {
  mtx <- getTermsInMatrix(dirList[i])
  print(paste("merge #", as.character(i-1), " Time:"))
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
write.csv(newDF, "data/fullDictionary.csv")
# filter wrong spelled words
index <- newDF[, 1] > 2
write.csv(data.frame(term = rownames(newDF)[index],
                     freq = newDF[index, 1]), 
          "data/cleanDictionary.csv",
          row.names = FALSE)
