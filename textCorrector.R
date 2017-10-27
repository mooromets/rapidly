correct1Pat <- c("( i )|(i$)|(^i)")
correct1Rep <- c(" I ")

textCorrector <- function(x) {
  x <- gsub(x, pattern = correct1Pat[1], replacement = correct1Rep[1])
  x
} 
