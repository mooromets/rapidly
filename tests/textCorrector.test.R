setwd("..")
source("textCorrector.R")
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
  expect_equal(gsub(correctPatterns[2, 1], 
                    correctPatterns[2, 2], 
                    "They re but we re not re-arranged"), 
               "They're but we're not re-arranged")
  expect_equal(gsub(correctPatterns[2, 1], 
                    correctPatterns[2, 2], 
                    "I m don t won t can t not to be"), 
               "I'm don't won't can't not to be")
  expect_equal(gsub(correctPatterns[2, 1], 
                    correctPatterns[2, 2], 
                    "it s yes it should not"), 
               "it's yes it should not")
  
})

test_that("textCorrector test", {
  expect_equal(textCorrector ("i ill i will i"), "I ill I will I")
})