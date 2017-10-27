source("../textCleaner.R")
require(testthat)

test_that("cleanStep1 regexp", {
  expect_equal(gsub(cleanStep1[1], " ", "! ..0-0???a!.,?s."), "!  0-0 a s.")
  expect_equal(gsub(cleanStep1[2], " ", "as$0~ {ff} &yeah ? :ha"), 
               "as 0   ff   yeah    ha")
  expect_equal(gsub(cleanStep1[3], " ", 
                    "won't ' . i.e. . - -time cost-effective Torres'"), 
               "won't i.e. -time cost-effective Torres'")
})

test_that("cleanStep2 regexp", {
  expect_equal(gsub(cleanStep2[1], cleanStep2Repl[1], " -foo . bar "), 
               "-foo . bar")
  expect_equal(gsub(cleanStep2[1], cleanStep2Repl[1], ". foo b   a  r"), 
               ". foo b   a  r")
  expect_equal(gsub(cleanStep2[2], cleanStep2Repl[2], "end. Yes."), "end Yes ")
  expect_equal(gsub(cleanStep2[2], cleanStep2Repl[2], "end. no .50 t.j."), 
               "end. no .50 t.j ")
  expect_equal(gsub(cleanStep2[2], cleanStep2Repl[2], 
                    "i.e. no remove but i.e. Remove"), 
               "i.e. no remove but i.e Remove")
  expect_equal(gsub(cleanStep2[3], cleanStep2Repl[3], "foo  bar   .dot     yes"), 
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