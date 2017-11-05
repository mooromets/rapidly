
# split big 'final' files into small fast-processible chunks
# also split data into three subsets: training, testing, validating

source("src/textCleaner.R")
source("src/censure.R")

splitFiles <- function(inPath = "data/final/en_US/",
                       outPath = "data/chunks/",
                       linesInChunk = 50000)
{
  # prepare output directiry
  if (!dir.exists(outPath)) 
    dir.create(outPath)
  remFiles <- dir(outPath)
  if (length(remFiles) > 0)
    remFiles <- paste0(outPath, remFiles)
  file.remove(remFiles, recursive = TRUE)
  
  trainDataDir <- paste0(outPath, "train/")
  dir.create(trainDataDir)
  testDataDir <- paste0(outPath, "test/")
  dir.create(testDataDir)
  validateDataDir <- paste0(outPath, "validate/")
  dir.create(validateDataDir)
  
  # prepare test files
  testFile <- file(paste0(testDataDir, "testChunk.txt"), "wt")
  validateFile <- file(paste0(validateDataDir, "validateChunk.txt"), "wt")
  
  # list input files
  filesList <- paste0(inPath, dir(inPath))
  
  trainingFilesList <- c()
  chunkNum <- 0
  for (f in filesList) {
    fileIn <- file(f, "r")
    repeat {
      chunkNum <- chunkNum + 1
      #separate dir for every file in train subset
      newDir <- paste0(trainDataDir, as.character(chunkNum), "/")
      dir.create(newDir) 
      # create a new file and write lines
      newFilename <- paste0(newDir, "chunk", as.character(chunkNum), ".txt")
      trainingFilesList <- c(trainingFilesList, newFilename)
      fileOut <- file(newFilename, "wt")
      inData <- readLines(fileIn, n = linesInChunk, skipNul = TRUE)
      # indexes for 3 subsets
      trainIndex <- 1:length(inData)
      testIndex <- sample(trainIndex, max(50, length(trainIndex) * .01))
      trainIndex <- setdiff(trainIndex, testIndex)
      validateIndex <- sample(testIndex, max(10, length(testIndex) * .1))
      testIndex <- setdiff(testIndex, validateIndex)
      # making subsets
      trainData <- inData[trainIndex]
      testData <- inData[testIndex]
      validateData <- inData[validateIndex]
      writeLines(testData, testFile)
      writeLines(validateData, validateFile)
      writeLines(trainData, fileOut)
      close(fileOut)  
      if (length(inData) < linesInChunk) {# last chunk from input data
        break
      }
    }
    close(fileIn)
  }
  close(testFile)
  close(validateFile)
  trainingFilesList
}

cleanFile <- function(filename)
{
  fileIn <- file(filename, "r")
  inData <- readLines(fileIn)
  close(fileIn)
  fileOut <- file(filename, "wt")
  st <- system.time(trainData <- 
                      textCleaner(inData, censured = censuredWords()))
  writeLines(trainData, fileOut)
  close(fileOut)  
  st
}