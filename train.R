library(tm)
options(java.parameters = "-Xmx6000m")
library(RWeka)
library(dplyr)
source("src/cleanText.R")
source("src/dictionary.R")
source("makeSamples.R")

# sample data
inPath <- "data/final/en_US/"
outPathBase <- "data/full1115/"
outPathCorp <- paste0(outPathBase, "corpora/")
if (dir.exists(outPathBase)) {
  file.remove(paste0(outPathBase, dir(outPathBase)))
} else { 
  dir.create(outPathBase)
}
makeSamples(inPath, outPathCorp)

trainPath <- paste0(outPathCorp, "train/")

#create and load dictionary
createDictionary(trainPath, outPath = outPathBase)
dictHash <- loadDictionaryHash(basePath = outPathBase)
print(paste("Dictionary size: ", as.character(length(dictHash))))

# prepare dirs
dirsList <- dir(trainPath)
nGramsRange <- 2:4
listOfTDMs <- vector("list", length(nGramsRange))
# get and save all nGrams
for (idir in dirsList) {
  for (N in nGramsRange) {
    print(paste(idir, as.character(N)))
    print(Sys.time()); print("read and clean Corpus");
    corp <- VCorpus(DirSource(paste0(trainPath, idir)))
    corp <- tm_map(corp, content_transformer(cleanText))
    print(Sys.time()); print("create TDM");
    nGramTok <- function(x) NGramTokenizer(x, Weka_control(min = N, max = N))
    tdm <- TermDocumentMatrix(corp, 
                              control = list(tokenize = nGramTok, 
                                             stopwords = TRUE, 
                                             wordLengths = c(1, Inf)))
    print(Sys.time()); print("get and save IDs");
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
    # remove lines with words absent in the dictionary
    tmpDF <- tmpDF[complete.cases(tmpDF), ]
    tdmFileNAme <- paste0(outPathBase, idir, as.character(N), ".csv" )
    write.csv(tmpDF, tdmFileNAme, row.names = FALSE)
    listOfTDMs[[which(nGramsRange == N)]] <- c(listOfTDMs[[which(nGramsRange == N)]], tdmFileNAme)
    print(Sys.time())
  }
}

# create full TDMs
fullTdmFiles <- c()
for (vecFiles in listOfTDMs) {
  leftTDM <- read.csv(vecFiles[1])
  if(length(vecFiles) > 1){
    for (i in 2 : length(vecFiles)){
      rightTDM <- read.csv(vecFiles[i])
      freqColIndex <- ncol(leftTDM)
      joinBy <- colnames(rightTDM)[1 : (freqColIndex - 1)]
      leftTDM <- full_join(leftTDM, rightTDM, by = joinBy)
      leftTDM[, freqColIndex] <- apply(leftTDM[, freqColIndex : (freqColIndex + 1)], 
                                       1, sum, na.rm = TRUE)
      leftTDM <- leftTDM[-(freqColIndex + 1)]
    }
  }
  outFileName <- paste0(gsub(pattern = "[.]", replacement = "FULL.", vecFiles[1]))
  fullTdmFiles <- c(fullTdmFiles, outFileName)
  write.csv(leftTDM, outFileName, row.names = FALSE)
}
