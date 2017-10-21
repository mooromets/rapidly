fileIn <- file("./data/final/en_US/en_US.blogs.txt", "r")
fileOut <- file("./data/sample.txt", "w")

repeat {
  inData <- readLines(fileIn, n = 1000, skipNul = TRUE)
  outData <- sample(inData, 50)
  writeLines(outData, fileOut)
  
  if (nchar(inData[1000]) == 0) {
    break
  }
}

close(fileIn)
close(fileOut)

