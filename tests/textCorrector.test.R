source("../textCorrector.R")
require(testthat)

test_that("correct1Pat regexp", {
  expect_equal(gsub(correct1Pat[1], correct1Rep[1], "i ill i will i"), " I  ill I will  I ")
})

test_that("textCorrector test", {
  expect_equal(textCorrector ("i ill i will i"), " I  ill I will  I ")
})