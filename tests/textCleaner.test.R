setwd("..")
source("textCleaner.R")
require(testthat)

test_that("cleanPatterns regexp", {
  expect_equal(gsub(cleanPatterns[1,1], cleanPatterns[1,2], 
                    "! ..0-0???a!.,?s."), 
               "!  0-0 a s.")
  expect_equal(gsub(cleanPatterns[2,1], cleanPatterns[2,2], 
                    "as$0~ {ff} &yeah ? :ha"), 
               "as 0   ff   yeah    ha")
  expect_equal(gsub(cleanPatterns[3,1], cleanPatterns[3,2], 
                    "won't ' . i.e. . - -time cost-effective Torres'"), 
               "won't i.e. -time cost-effective Torres'")
  expect_equal(gsub(cleanPatterns[4,1], cleanPatterns[4,2], " -foo . bar "), 
               "-foo . bar")
  expect_equal(gsub(cleanPatterns[4,1], cleanPatterns[4,2], ". foo b   a  r"), 
               ". foo b   a  r")
  expect_equal(gsub(cleanPatterns[5,1], cleanPatterns[5,2], "end. Yes."), "end Yes ")
  expect_equal(gsub(cleanPatterns[5,1], cleanPatterns[5,2], "end. no .50 t.j."), 
               "end. no .50 t.j ")
  expect_equal(gsub(cleanPatterns[5,1], cleanPatterns[5,2], 
                    "i.e. no remove but i.e. Remove"), 
               "i.e. no remove but i.e Remove")
  expect_equal(gsub(cleanPatterns[6,1], cleanPatterns[6,2], "foo  bar   .dot     yes"), 
               "foo bar .dot yes")
})

test_that("textCleaner", {
  expect_equal(textCleaner("!.:Too many '' punctuation :-) marks... yeah))"),
               "Too many punctuation marks yeah")
  expect_equal(textCleaner("normal $symbols## only? I'll accept:"),
               "normal symbols only I'll accept")
  expect_equal(textCleaner(" . ' - you shall not pass "), "you shall not pass")
  expect_equal(textCleaner("sentence. Vs. useful dots i.e. .5 end."), 
               "sentence Vs. useful dots i.e. .5 end ")
})