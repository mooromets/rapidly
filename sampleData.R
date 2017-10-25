fileIn <- file("./data/final/en_US/en_US.blogs.txt", "r")
fileOut <- file("./data/sample.txt", "w")

repeat {
  inData <- readLines(fileIn, n = 1000, skipNul = TRUE)
  outData <- sample(inData, 20)
  writeLines(outData, fileOut)
  
  if (length(inData) != 1000) {
    break
  }
}

close(fileIn)
close(fileOut)

