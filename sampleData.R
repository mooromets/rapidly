dirPath <- "data/final/en_US/"
filesList <- paste0(dirPath, dir(dirPath))
fileOut <- file("./data/small_sample.txt", "w")

for (f in filesList) {
  fileIn <- file(f, "r")
  repeat {
    inData <- readLines(fileIn, n = 1000, skipNul = TRUE)
    outData <- sample(inData, 20)
    writeLines(outData, fileOut)
    
    if (length(inData) != 1000) {
      break
    }
  }
  close(fileIn)
}  

close(fileOut)
