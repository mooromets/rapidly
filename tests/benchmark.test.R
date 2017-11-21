require(testthat)
setwd("..")
source("src/benchmark.R")

context("test benchmark")

test_that("line2TermsDF", {
  expect_equal(nrow(line2TermsDF("")), 0)
  expect_equal(nrow(line2TermsDF(" ")), 0)
  expect_equal(nrow(line2TermsDF("a ")), 0)
  expect_equal(nrow(line2TermsDF("word ")), 0)
  expect_equal(nrow(line2TermsDF("words come ")), 1)

  tmp <- line2TermsDF("words come here")
  expect_equal(nrow(tmp), 2)
  expect_equivalent(tmp[1, ], c("words", "come"))
  expect_equivalent(tmp[2, ], c("words come", "here"))

  tmp <- line2TermsDF("a b c d e f g")
  expect_equal(nrow(tmp), 6)
  expect_equivalent(tmp[1, ], c("a", "b"))
  expect_equivalent(tmp[2, ], c("a b", "c"))
  expect_equivalent(tmp[3, ], c("a b c", "d"))
  expect_equivalent(tmp[4, ], c("a b c d", "e"))
  expect_equivalent(tmp[5, ], c("a b c d e", "f"))
  expect_equivalent(tmp[6, ], c("a b c d e f", "g"))
  
  tmp <- line2TermsDF("w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13")
  expect_equal(nrow(tmp), 12)
  expect_equivalent(tmp[1, ], c("w1", "w2"))
  expect_equivalent(tmp[2, ], c("w1 w2", "w3"))
  expect_equivalent(tmp[3, ], c("w1 w2 w3", "w4"))
  expect_equivalent(tmp[4, ], c("w1 w2 w3 w4", "w5"))
  expect_equivalent(tmp[5, ], c("w1 w2 w3 w4 w5", "w6"))
  expect_equivalent(tmp[6, ], c("w1 w2 w3 w4 w5 w6", "w7"))
  expect_equivalent(tmp[7, ], c("w1 w2 w3 w4 w5 w6 w7", "w8"))
  expect_equivalent(tmp[8, ], c("w1 w2 w3 w4 w5 w6 w7 w8", "w9"))
  expect_equivalent(tmp[9, ], c("w1 w2 w3 w4 w5 w6 w7 w8 w9", "w10"))
  expect_equivalent(tmp[10, ], c("w1 w2 w3 w4 w5 w6 w7 w8 w9 w10", "w11"))
  expect_equivalent(tmp[11, ], c("w2 w3 w4 w5 w6 w7 w8 w9 w10 w11", "w12"))
  expect_equivalent(tmp[12, ], c("w3 w4 w5 w6 w7 w8 w9 w10 w11 w12", "w13"))
})


test_that("benchmark tests", {
  mock_fun <- function(x) c("a", "the", "looks")
  text <- c("term1 a", "term2 looks", "term3 miss", "term4 a", "term5 a", "term6 the", "term7 no", 
            "term8 looks", "term9 the", "term10 miss")
  res <- benchmark(text, FUN = mock_fun)
  expect_equal(res$score, .5)
  expect_equal(res$OverallTop1, .3)
  expect_equal(res$OverallPre, .7)
  expect_equal(res$Number, 10)
})