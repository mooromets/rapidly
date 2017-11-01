
# split big 'final' files into small fast-processible chunks
# also split data into three subsets: training, testing, validating

source("textCleaner.R")
source("censure.R")

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
  
  chunkNum <- 0
  cleaningElapsed <- c()
  for (f in filesList) {
    fileIn <- file(f, "r")
    repeat {
      # create a new file and write lines
      chunkNum <- chunkNum + 1
      #separate dir for every file in train subset
      newDir <- paste0(trainDataDir, as.character(chunkNum), "/")
      dir.create(newDir) 
      fileOut <- file(paste0(newDir, "chunk", as.character(chunkNum), ".txt"), "wt")
      inData <- readLines(fileIn, n = linesInChunk, skipNul = TRUE)
      # indexes for 3 subsets
      trainIndex <- 1:length(inData)
      testIndex <- sample(trainIndex, max(50, length(trainIndex) * .01))
      trainIndex <- setdiff(trainIndex, testIndex)
      validateIndex <- sample(testIndex, max(10, length(testIndex) * .1))
      testIndex <- setdiff(testIndex, validateIndex)
      # making subsets
      st <- system.time( {
        trainData <- textCleaner(inData[trainIndex], 
                                 censured = censuredWords())
        testData <- textCleaner(inData[testIndex], 
                                censured = censuredWords())
        validateData <- textCleaner(inData[validateIndex], 
                                    censured = censuredWords())
      })
      cleaningElapsed <- c(cleaningElapsed, st[3])
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
  
  print(paste("Cleaning elapsed time:", as.character(sum(cleaningElapsed))))
  print(cleaningElapsed)
}