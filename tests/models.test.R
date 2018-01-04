require(testthat)
setwd("..")
source("R/models.R")

context("models tests")

test_that("fiveMostProb", {
  res <- fiveMostProb(
    c(  2,   3,   4,   5,   0,  10,  20,  1,  0),
    c("a", "b", "c", "d", "e", "f", "g", "h", "i")
  )
  smpl <- c(g = 0.44, f = 0.22, d = 0.11, c = 0.09, b = 0.07)
  expect_equal(round(res, 2), smpl)
  
  expect_equal(fiveMostProb(c(0), c("d")), NULL)
  expect_equal(fiveMostProb(c(), c()), NULL)
})
