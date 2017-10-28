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
  expect_equal(gsub(correctPatterns[3, 1], 
                    correctPatterns[3, 2], 
                    "u and U Lust Uu plus u've u"), 
               "you and you Lust Uu plus you've you")
  expect_equal(gsub(correctPatterns[4, 1], 
                    correctPatterns[4, 2], 
                    "r not R but r you r"), 
               "are not R but are you are")
  expect_equal(gsub(correctPatterns[5, 1], 
                    correctPatterns[5, 2], 
                    "c you but C Make and c-lang not c to c"), 
               "see you but C Make and c-lang not see to see")
  expect_equal(gsub(correctPatterns[6, 1], 
                    correctPatterns[6, 2], 
                    "ur is Ur's not urgent ur"), 
               "your is your's not urgent your")
})

test_that("textCorrector test", {
  input <- c("i small i , i'll till ill i",
            "he's we've hadn't won't be re-arrenged you're",
            "u r C ur R c U Uups U'd u")
  comp <- c("I small I , I'll till ill I",
            "he's we've hadn't won't be re-arrenged you're",
            "you are C your R see you Uups you'd you")
  expect_equal(textCorrector(input), comp)
})

test_that("textCorrector censure test", {
  censured <- ""
  cens <- file("data/censure.txt", "r")
  repeat {
    line = readLines(cens, n = 1)
    if ( length(line) == 0 ) {
      break
    }
    if (nchar(censured) == 0)
      censured <- paste0("(", line, ")")
    else
      censured <- paste0(censured, "|","(", line, ")")
  }
  close(cens)
  expect_equal(textCorrector("suck 1 fuck 2 bitch 3", censured), " 1  2  3")
})