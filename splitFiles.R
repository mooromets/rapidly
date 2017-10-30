# split big 'final' files into small fast-processible chunks

source("textCleaner.R")
source("censure.R")

dirPath <- "data/final/en_US/"
dirOut <- "data/chunks/"
LPF <- 50000 # lines per a chunk file

# prepare output directiry
if (!dir.exists(dirOut)) 
  dir.create(dirOut)
remFiles <- dir(dirOut)
if (length(remFiles) > 0)
  remFiles <- paste0(dirOut, remFiles)
file.remove(remFiles)

# list input files
filesList <- paste0(dirPath, dir(dirPath))

chunkNum <- 0
for (f in filesList) {
  fileIn <- file(f, "r")
  repeat {
    # create a new file and write lines
    chunkNum <- chunkNum + 1
    fileOut <- file(paste0(dirOut, "chunk", as.character(chunkNum), ".txt"), "w")
    inData <- readLines(fileIn, n = LPF, skipNul = TRUE)
    linesRead <- length(inData)
    inData <- textCleaner(inData, censured = censuredWords())
    writeLines(inData, fileOut)
    close(fileOut)  
    
    if (linesRead < LPF) {# last chunk from input data
      break
    }
  }
  close(fileIn)
}

# place every chunk to a separate folder 
filesList <- dir(dirOut)
for (i in 1:length(filesList)) {
  newDirName <- as.character(i)
  dir.create(paste0(dirOut, newDirName))
  file.rename(from = paste0(dirOut, filesList[i]),
              to = paste0(dirOut, newDirName, "/" , filesList[i]))
}