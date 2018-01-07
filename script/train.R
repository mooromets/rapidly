library(tm)
options(java.parameters = "-Xmx6000m")
library(RWeka)
library(dplyr)
source("R/common.R")
source("R/cleanText.R")
source("R/dictionary.R")
source("R/makeSamples.R")
source("R/termMatrixOps.R")

# sample data
inPath <- "data/final/en_US/"
outPathBase <- "data/full1119/"
leaveApost <- ' \r\n\t.,;:"()?!'
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

listOfTDMs <- vector("list", length(NGRAM_RANGE))
# get and save all nGrams
for (idir in dirsList) {
  for (N in NGRAM_RANGE) {
    tdmInDF <- extractTdmFromDir(N, trainPath, outPathBase, idir, dictHash)
    
    tdmFileName <- paste0(outPathBase, idir, as.character(N), ".csv" )
    write.csv(tdmInDF, tdmFileName, row.names = FALSE)
    listOfTDMs[[which(NGRAM_RANGE == N)]] <- c(listOfTDMs[[which(NGRAM_RANGE == N)]], tdmFileName)
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
  #save
  outFileName <- paste0(gsub(pattern = "[.]", replacement = "FULL.", vecFiles[1]))
  fullTdmFiles <- c(fullTdmFiles, outFileName)
  write.csv(leftTDM, outFileName, row.names = FALSE)
}
