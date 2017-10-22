
# prints a number of lines in the file
num_lines <- function(filename){
  fileIn <- file(filename, "r")
  nl <- 0.0
  repeat {
    inData <- readLines(fileIn, n = 1000, skipNul = TRUE)
    nl <- nl + length(inData)
    if (length(inData) != 1000) {
      break
    }
  }
  close(fileIn)
  print(filename)
  print(nl)
}

# print longest line's length in a file
max_len <- function(filename){
  fileIn <- file(filename, "r")
  len <- 0
  repeat {
    inData <- readLines(fileIn, n = 1000, skipNul = TRUE)
    len <- max(c(len, nchar(inData)))
    if (length(inData) != 1000) {
      break
    }
  }
  close(fileIn)
  print(filename)
  print(len)
}

# print love/hate rate in a file
hate_rate <- function(filename){
  fileIn <- file(filename, "r")
  love <- 0
  hate <- 0
  repeat {
    inData <- readLines(fileIn, n = 1000, skipNul = TRUE)
    love <- love + sum(grepl ("love", inData))
    hate <- hate + sum(grepl ("hate", inData))
    if (length(inData) != 1000) {
      break
    }
  }
  close(fileIn)
  print(filename)
  print(love / hate)
}

# print "biostats" line
biostats <- function(filename){
  fileIn <- file(filename, "r")
  print(filename)
  repeat {
    inData <- readLines(fileIn, n = 1000, skipNul = TRUE)
    x <- inData[grepl ("biostats", inData)]
    if (length(x) > 0)
      print(x)
    if (length(inData) != 1000) {
      break
    }
  }
  close(fileIn)
}


system.time(
lapply(c("./data/final/en_US/en_US.twitter.txt", 
         "./data/final/en_US/en_US.news.txt",
         "./data/final/en_US/en_US.blogs.txt"), 
       max_len)
)
