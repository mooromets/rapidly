library(Matrix)
library(tm)
library(dplyr)

source("src/customTDM.R")

print(Sys.time())

chunksPath <- "data/chunks/train/"

# load dictionary
df <- read.csv("data/cleanDictionary.csv")
tmpList <- as.list(rownames(df))
names(tmpList) <- df$term
term2ID <- list2env(tmpList, hash = TRUE)
ID2Term <- as.vector(df$term)
rm(df)
rm(tmpList)
gc()

dirList <- paste0(chunksPath, dir(chunksPath))

getTermsIds <- function(dirname) {
  corp <- VCorpus(DirSource(dirname))
  mtx <- as.matrix(customTDMn(corp, 2))
  rm(corp)
  ids <- do.call(rbind, lapply(seq_along(mtx), function(idx) {
    matrix(data = c(as.vector(
                      sapply(unlist(strsplit(rownames(mtx)[idx], " ")), 
                             function(x) as.numeric(term2ID[[x]])),
                      mode = "numeric"
                    ), 
                    mtx[idx, 1]),    
          nrow = 1)
  }))
  rm(mtx)
  gc()
  # remove phrases with words out of dictionary
  as.data.frame(ids[complete.cases(ids), ])
}

print(Sys.time())

idsLeft <- getTermsIds(dirList[1])
gc()

for (idir in 2:7) { #length(dirList)) {
  idsRight <- getTermsIds(dirList[idir])

  idsLeft <- full_join(idsLeft, idsRight, by = c("V1","V2"))
  idsLeft[, 3] <- apply(idsLeft[, -1:-2], 1, sum, na.rm = TRUE)
  idsLeft <- idsLeft[, 1:3]
  print(object.size(idsLeft))
  print(Sys.time())
  gc()  
}