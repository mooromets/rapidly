# all models

# insanelySimpleModel just looks in the longer ngrams first
insanelySimpleModel <- function(phrase, bigrams, trigrams, fourgrams) {
  answer <- ""
  ngramFind <- function(phrase, ngrams) colnames(ngrams)[which.max(ngrams[phrase, ])]
  tryCatch(answer <- ngramFind(phrase, fourgrams),
           error = function(e) answer <- "")
  if (nchar(answer) == 0) {
    tryCatch(answer <- ngramFind(phrase, trigrams),
             error = function(e) answer <- "")
  }
  if (nchar(answer) == 0) {
    tryCatch(answer <- ngramFind(phrase, bigrams),
             error = function(e) answer <- "")
  }
  answer
}
