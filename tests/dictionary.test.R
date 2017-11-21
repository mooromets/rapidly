require(testthat)
setwd("..")
source("src/dictionary.R")

context("dictionary creation")

inBase <- "data/tests/"
inPath <- paste0(inBase, as.character(round(rnorm(1), 4)), "/")
dir.create(inPath)

text <- c("one two three four five six one two three four five six one two three four five six", 
          "foo foo bar foo bar baz foo bar baz quux foo bar baz quux corge",
          "a b c d i i'm can't do go you we'll he's he'd", 
          "mean with mean with mean")

fin <- file(paste0(inPath, "test.txt"), "wt")
writeLines(text, fin)
close(fin)

test_that("createDictionary() default", {
  createDictionary(inBase, inBase)
  df <- read.csv(paste0(inBase, "cleanDictionary.csv"), stringsAsFactors = FALSE)
  expect_equal(dim(df), c(2, 2))
  expect_equal(df$term, c("foo", "bar"))
  expect_equal(df$freq, c(5, 4))
})

test_that("createDictionary() min freq = 1", {
  createDictionary(inBase, inBase, minFreqThreshold = 1)
  df <- read.csv(paste0(inBase, "cleanDictionary.csv"), stringsAsFactors = FALSE)
  expect_equal(dim(df), c(12, 2))
  expect_equal(df$term, c("one", "five", "with", "mean", "six", "two", "foo", "bar", "three", 
                          "quux", "baz", "four" ))
  expect_equal(df$freq, c(3, 3, 2, 3, 3, 3, 5, 4, 3, 2, 3, 3))
})

test_that("createDictionary() all words + apostroph + reserved words in general environment", {
  createDictionary(inBase, inBase, minFreqThreshold = 0)
  df <- read.csv(paste0(inBase, "cleanDictionary.csv"), stringsAsFactors = FALSE)
  expect_equal(dim(df), c(24, 2))
  expect_equal(df$term, c("do", "one", "five", "i'm", "he's", "with", "mean", "six", "can't", "a",
                          "you", "two", "foo", "we'll", "bar", "i", "three", "he'd", "go", "quux", 
                          "corge", "baz", "four", "'d"))
  expect_equal(df$freq, c(1, 3, 3, 1, 1, 2, 3, 3, 1, 1, 1, 3, 5, 1, 4, 1, 3, 1, 1, 2, 1, 3, 3, 1))
})

terms <- c("i'm", "a", "mean", "be", "with", "foo", "bar")
df <- data.frame(term = terms, freq = c(4, 6, 5, 10, 11, 12, 9))
fname <- "dict.csv"
write.csv(df, paste0(inBase, fname))

test_that("loadDictionaryHash()", {
  dictHash <- loadDictionaryHash(fname, inBase)
  for (i in seq_len(length(terms))) expect_equal(dictHash[[terms[i]]], i)
})

test_that("loadDictionaryVect()", {
  dictVec <- loadDictionaryVect(fname, inBase)
  for (i in seq_len(length(terms))) expect_equal(dictVec[i], terms[i])
})

test_that("loadDictionaryVect() -Hash() compatibility", {
  dictVec <- loadDictionaryVect(fname, inBase)
  dictHash <- loadDictionaryHash(fname, inBase)
  for (i in seq_len(length(dictVec))) expect_equal(dictHash[[ dictVec[i] ]], i)
})

file.remove(paste0(inPath, dir(inPath)))
#file.remove(paste0(inBase, dir(inBase)))
