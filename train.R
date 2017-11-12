library(tm)
options(java.parameters = "-Xmx4096m")
library(RWeka)
library(dplyr)
source("src/cleanFiles.R")
source("src/dictionary.R")
source("src/cleanCorpus.R")

# sample data
inPath <- "data/final/en_US/"
outPath <- "data/corpora/"
makeSamples(inPath, outPath)

trainPath <- paste0(outPath, "train/")

#create and load dictionary
createDictionary(trainPath)
dictHash <- loadDictionaryHash()

# get and save all nGrams
gc()
dirsList <- dir(paste0(outPath, "train/"))
minWordLength <- 3
for (idir in dirsList) {
  for (N in 2:4) {
    print(paste(idir, as.character(N)))
    print(Sys.time()); print("get TDM");
    corp <- VCorpus(DirSource(paste0(outPath, "train/", idir)))
    corp <- cleanCorpus(corp)
    nGramTok <- function(x) NGramTokenizer(x, Weka_control(min = N, max = N))
    minTermLength <- minWordLength * N + N-1
    tdm <- TermDocumentMatrix(corp, 
                              control = list(tokenize = nGramTok, 
                                             stopwords = TRUE, 
                                             wordLengths = c(minTermLength,Inf)))
    print(Sys.time()); print("get IDs");
    # convert words into IDs
    mtx <- as.matrix(tdm)
    rm(tdm)
    # remove phrases with a low frequency
    idxFreq <- as.vector(mtx[, 1] > 1)
    tmpDF <- data.frame(term = rownames(mtx)[idxFreq], 
                        freq = mtx[idxFreq, 1], 
                        stringsAsFactors = FALSE,
                        row.names = NULL)
    rm(mtx)
    tmpDF <- as.data.frame(t(apply(tmpDF, 1, function(row) {
      matrix(data = c(as.vector(sapply(unlist(strsplit(row[1], " ")), 
                                         function(x) as.numeric(dictHash[[x]])),
                                  mode = "numeric"
                                ), 
                      as.numeric(row[2])),    
              nrow = 1)
    })))
    print(Sys.time()); print("save IDs");
    # remove lines with words absent in the dictionary
    tmpDF <- tmpDF[complete.cases(tmpDF), ] 
    write.csv(tmpDF, paste0("data/", idir, as.character(N), ".csv" ),
              row.names = FALSE)
  }
}

# create full TDMs

tdmDir <- "data/TDMs/"

fullTdmFiles <- c()

for (idir in dir(tdmDir)) {
  partsDirs <- paste0(tdmDir, idir, "/")
  files <- paste0(partsDirs, dir(partsDirs))
  leftTDM <- read.csv(files[1])
  for (i in 2 : length(files)){
    rightTDM <- read.csv(files[i])
    freqColIndex <- ncol(leftTDM)
    joinBy <- colnames(rightTDM)[1 : (freqColIndex - 1)]
    leftTDM <- full_join(leftTDM, rightTDM, by = joinBy)
    leftTDM[, freqColIndex] <- apply(leftTDM[, freqColIndex : (freqColIndex + 1)], 
                                     1, sum, na.rm = TRUE)
    leftTDM <- leftTDM[-(freqColIndex + 1)]
  }
  outFileName <- paste0("data/tdm", idir, ".csv")
  fullTdmFiles <- c(fullTdmFiles, outFileName)
  write.csv(leftTDM, paste0(outFileName, row.names = FALSE))
}