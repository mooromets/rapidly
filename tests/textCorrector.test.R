source("../textCorrector.R")
require(testthat)

test_that("correct1Pat regexp", {
  expect_equal(gsub(correctPatterns[1, 1], 
                    correctPatterns[1, 2], 
                    "i've i'll be i ill till i'd i"), 
               "I've I'll be I ill till I'd I")
  expect_equal(gsub(correctPatterns[2, 1], 
                    correctPatterns[2, 2], 
                    "I d you ll he d she s"), 
               "I'd you'll he'd she's")
})

test_that("textCorrector test", {
  expect_equal(textCorrector ("i ill i will i"), "I ill I will I")
})