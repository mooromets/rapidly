library(Matrix)
library(tm)
library(dplyr)

source("src/customTDM.R")

#print(Sys.time())

chunksPath <- "data/chunks/train/"

# load dictionary
df <- read.csv("data/cleanDictionary.csv")
tmpList <- as.list(rownames(df))
names(tmpList) <- df$term
term2ID <- list2env(tmpList, hash = TRUE)
ID2Term <- as.vector(df$term)
rm(df)
rm(tmpList)
#gc()

# doJob function makes all work regarding one nGram (bigram/trigram/etc.) 
#TODO refactor this monsterous function
doJob <- function(N) {
  
  dirList <- paste0(chunksPath, dir(chunksPath))

  # getTermsIds function returns a data.frame containing all terms from the 
  # corpus from input directory
  getTermsIds <- function(dirname) {
    corp <- VCorpus(DirSource(dirname))
    mtx <- as.matrix(customTDMn(corp, N))
    rm(corp)
    # replace all words in matrix with their IDs from dictionary
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
    #gc()
    # words absent in dictionary == NA, remove those lines
    as.data.frame(ids[complete.cases(ids), ]) 
  }
  #print(Sys.time())
  idsLeft <- getTermsIds(dirList[1])
  termColumns <- c(1:N) # collumns in data frame, that are words and not frequency
  freqColumn <- N+1 # column(s) containing frequency
  #gc()
  for (idir in 2:5) { #length(dirList)) {
    idsRight <- getTermsIds(dirList[idir])
    idsLeft <- full_join(idsLeft, 
                         idsRight, 
                         by = paste0("V", as.character(termColumns)))
    idsLeft[, freqColumn] <- apply(idsLeft[, -termColumns], 1, sum, na.rm = TRUE)
    idsLeft <- idsLeft[, c(termColumns, freqColumn)]
    print(object.size(idsLeft))
    print(Sys.time())
    #gc()  
  }
  
  outFileName <- paste0("NGramms", as.character(N))
  
  write.csv(idsLeft, paste0("data/full", outFileName, ".csv"), row.names = FALSE)
  # filter wrong spelled words
  idsLeft <- idsLeft[idsLeft[, freqColumn] > 2, ]
  write.csv(idsLeft, paste0("data/clean", outFileName, ".csv"), row.names = FALSE)
  
  #here sparse matrix code
}

doJob(3)