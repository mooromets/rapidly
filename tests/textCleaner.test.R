setwd("..")
source("textCleaner.R")
require(testthat)

test_that("cleanPatterns regexp", {
  expect_equal(gsub(cleanPatterns[1, 1], cleanPatterns[1, 2], 
                    "! ..0-0???a!.,?s."), 
               "!  0-0 a s.")
  expect_equal(gsub(cleanPatterns[2, 1], cleanPatterns[2, 2], 
                    "as$0~ {ff} &yeah ? :ha"), 
               "as 0   ff   yeah    ha")
  expect_equal(gsub(cleanPatterns[3, 1], cleanPatterns[3, 2], 
                    "won't ' . i.e. . - -time cost-effective Torres'"), 
               "won't i.e. -time cost-effective Torres'")
  expect_equal(gsub(cleanPatterns[4, 1], cleanPatterns[4, 2], " -foo . bar "), 
               "-foo . bar")
  expect_equal(gsub(cleanPatterns[4, 1], cleanPatterns[4, 2], ". foo b   a  r"), 
               ". foo b   a  r")
  expect_equal(gsub(cleanPatterns[5, 1], cleanPatterns[5, 2], "end. Yes."), "end Yes ")
  expect_equal(gsub(cleanPatterns[5, 1], cleanPatterns[5, 2], "end. no .50 t.j."), 
               "end. no .50 t.j ")
  expect_equal(gsub(cleanPatterns[5, 1], cleanPatterns[5, 2], 
                    "i.e. no remove but i.e. Remove"), 
               "i.e. no remove but i.e Remove")
  expect_equal(gsub(cleanPatterns[6, 1], cleanPatterns[6, 2], "foo  bar   .dot     yes"), 
               "foo bar .dot yes")
})

test_that("grammar regexp", {
  expect_equal(gsub(cleanPatterns[7, 1], 
                    cleanPatterns[7, 2], 
                    "i've i'll be i ill till i'd i"), 
               "I've I'll be I ill till I'd I")
  expect_equal(gsub(cleanPatterns[8, 1], 
                    cleanPatterns[8, 2], 
                    "I d you ll he d she s"), 
               "I'd you'll he'd she's")
  expect_equal(gsub(cleanPatterns[8, 1], 
                    cleanPatterns[8, 2], 
                    "They re but we re not re-arranged"), 
               "They're but we're not re-arranged")
  expect_equal(gsub(cleanPatterns[8, 1], 
                    cleanPatterns[8, 2], 
                    "I m don t won t can t not to be"), 
               "I'm don't won't can't not to be")
  expect_equal(gsub(cleanPatterns[8, 1], 
                    cleanPatterns[8, 2], 
                    "it s yes it should not"), 
               "it's yes it should not")
  expect_equal(gsub(cleanPatterns[9, 1], 
                    cleanPatterns[9, 2], 
                    "u and U Lust Uu plus u've u"), 
               "you and you Lust Uu plus you've you")
  expect_equal(gsub(cleanPatterns[10, 1], 
                    cleanPatterns[10, 2], 
                    "r not R but r you r"), 
               "are not R but are you are")
  expect_equal(gsub(cleanPatterns[11, 1], 
                    cleanPatterns[11, 2], 
                    "c you but C Make and c-lang not c to c"), 
               "see you but C Make and c-lang not see to see")
  expect_equal(gsub(cleanPatterns[12, 1], 
                    cleanPatterns[12, 2], 
                    "ur is Ur's not urgent ur"), 
               "your is your's not urgent your")
})

test_that("grammar test", {
  input <- c("i small i'll till ill i",
             "he's we've hadn't won't be re-arrenged you're",
             "u r C ur R c U Uups U'd u")
  comp <- c("I small I'll till ill I",
            "he's we've hadn't won't be re-arrenged you're",
            "you are C your R see you Uups you'd you")
  expect_equal(textCleaner(input), comp)
})

test_that("textCorrector censure test", {
  # read censured words
  censured <- ""
  cens <- file("data/censure.txt", "r")
  repeat {
    line = readLines(cens, n = 1)
    if ( length(line) == 0 ) {
      censured <- paste0(censured, ")( |$)")
      break
    }
    if (nchar(censured) == 0)
      censured <- paste0("( |^)(", line)
    else
      censured <- paste0(censured, "|", line)
  }
  close(cens)
  
  expect_equal(textCorrector("suck 1 fuck 2 bitch 3", censured), " 1 2 3")
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