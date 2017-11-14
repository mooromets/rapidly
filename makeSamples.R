#make train, test, validate samples

makeSamples <- function(inPath = "data/final/en_US/", 
                        outPath = "data/corpora/") 
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
  
  linesInChunk <- 50000
  
  for (ifile in dir(inPath)) {
    fin <- file(paste0(inPath, ifile), "rt")
    newDir <- paste0(trainDataDir, gsub("[.]", "", ifile), "/")
    dir.create(newDir)
    fout <- file(paste0(newDir, ifile), "wt")
    repeat {
      inData <- readLines(fin, n = linesInChunk, skipNul = TRUE)
      # indexes for 3 subsets
      trainIndex <- 1:length(inData)
      testIndex <- sample(trainIndex, max(50, length(trainIndex) * .01))
      trainIndex <- setdiff(trainIndex, testIndex)
      validateIndex <- sample(testIndex, max(10, length(testIndex) * .1))
      testIndex <- setdiff(testIndex, validateIndex)
      
      # make subsets
      trainData <- iconv(inData[trainIndex], "latin1", "ASCII", sub="")
      testData <- iconv(inData[testIndex], "latin1", "ASCII", sub="")
      validateData <- iconv(inData[validateIndex], "latin1", "ASCII", sub="")
      
      writeLines(testData, testFile)
      writeLines(validateData, validateFile)
      writeLines(trainData, fout)
      if (length(inData) < linesInChunk) {# last chunk from input data
        break
      }
    }
    close(fout)  
    close(fin)
  }
  close(validateFile)
  close(testFile)
}

inPath <- "data/final/en_US/"
outPath <- "data/corpora/"

makeSamples(inPath, outPath)
