require(testthat)


test_that("removeStandaloneLetters()", {
  expect_equal(removeStandaloneLetters("a b c d e h i j"), "a   d   i ")
  expect_equal(removeStandaloneLetters(" a i "), " a i ")
  expect_equal(removeStandaloneLetters("i a a x i i a"), "i a a  i i a")
  expect_equal(removeStandaloneLetters("is be as-a to-b don't i'm c'mon"), 
               "is be as-a to- don't i'm 'mon")
})

test_that("recoverApostrophe()", {
  expect_equal(recoverApostrophe("I d you ll he d she s"), "I'd you'll he'd she's")
  expect_equal(recoverApostrophe("They re but we re not re-arranged"), 
               "They're but we're not re-arranged")
  expect_equal(recoverApostrophe("I m don t won t can t not to be"), 
               "I'm don't won't can't not to be")
  expect_equal(recoverApostrophe("it s yes it should not"), "it's yes it should not")
})

test_that("removePuctLeaveApost()", {
  expect_equal(removePuctLeaveApost(".?!';:,"), "'")
  expect_equal(removePuctLeaveApost("$#@#$#"), "")
  expect_equal(removePuctLeaveApost("$#@#$#"), "")
  expect_equal(removePuctLeaveApost("word. Words words? %^&*()"), "word Words words ")
}) 


test_that("removeConseqApost()", {
  expect_equal(removeConseqApost("word'n'word ''"), "word'n'word ")
  expect_equal(removeConseqApost("'' 'n'case'"), " 'n'case'")
  expect_equal(removeConseqApost("'a ''do'''Delete ''''all"), "'a doDelete all")
}) 

sentenceSplit
test_that("sentenceSplit()", {
  expect_equal(sentenceSplit("line1. Line2"), c("line1.", "Line2"))
  expect_equal(sentenceSplit("b.  C! d? E"), c("b.", " C! d?", "E"))
}) 