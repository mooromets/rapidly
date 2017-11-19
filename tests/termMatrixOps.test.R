require(testthat)
setwd("..")
source("src/termMatrixOps.R")

context("Term-Document Matrix creation")

test_that("ngramTdm() general tests", {
  mtx <- as.matrix(ngramTdm(VCorpus(VectorSource("a b c d a b a"))))
  expect_equal(as.vector(mtx[, 1]), c(3, 2, 1, 1))
  mtx <- as.matrix(ngramTdm(VCorpus(VectorSource("a an the four black"))))
  expect_equal(as.vector(mtx[, 1]), c(1, 1, 1, 1, 1))
})

test_that("ngramTdm() ngram = 1..5", {
  mtx <- as.matrix(ngramTdm(VCorpus(VectorSource("a b c d a b a"))))
  expect_equal(mtx[, 1], c("a" = 3, "b" = 2, "c" = 1, "d" = 1))
  mtx <- as.matrix(ngramTdm(VCorpus(VectorSource(c("phrase one phrase two phrase one phrase one"))), 
                            ngram = 2))
  expect_equal(mtx[, 1], c("one phrase" = 2, "phrase one" = 3, "phrase two" = 1, "two phrase" = 1))
  mtx <- as.matrix(ngramTdm(VCorpus(VectorSource(c("foo bar baz qux foo bar baz bar baz qux foo bar baz"))), 
                            ngram = 3))
  expect_equal(mtx[, 1], c("bar baz bar" = 1, "bar baz qux" = 2, "baz bar baz" = 1, "baz qux foo" = 2,
                           "foo bar baz" = 3, "qux foo bar" = 2))
  mtx <- as.matrix(ngramTdm(VCorpus(VectorSource(c("foo bar baz qux foo bar baz bar baz qux foo bar baz qux foo bar"))), 
                            ngram = 4))
  expect_equal(mtx[, 1], c("bar baz bar baz" = 1, "bar baz qux foo" = 3, "baz bar baz qux" = 1, 
                           "baz qux foo bar" = 3, "foo bar baz bar" = 1, "foo bar baz qux" = 2,
                           "qux foo bar baz" = 2))
  mtx <- as.matrix(ngramTdm(VCorpus(VectorSource(c("foo bar baz qux quuz foobar foo bar baz qux quuz foobar foo bar baz qux quuz foo"))), 
                            ngram = 5))
  expect_equal(mtx[, 1], c("bar baz qux quuz foo" = 1, "bar baz qux quuz foobar" = 2, "baz qux quuz foobar foo" = 2,
                           "foo bar baz qux quuz" = 3, "foobar foo bar baz qux" = 2, "quuz foobar foo bar baz" = 2,
                           "qux quuz foobar foo bar" = 2))  
})

test_that("ngramTdm() minTermLen", {
  mtx <- as.matrix(ngramTdm(VCorpus(VectorSource("a be c dat a boot an")),
                            minTermLen = 2))
  expect_equal(as.vector(mtx[, 1]), c(1, 1, 1, 1))
  mtx <- as.matrix(ngramTdm(VCorpus(VectorSource("a be c dat a boot an cut dat")),
                            minTermLen = 3))
  expect_equal(as.vector(mtx[, 1]), c(1, 1, 2))
  mtx <- as.matrix(ngramTdm(VCorpus(VectorSource("a be c date a boot an cut date crude")),
                            minTermLen = 4))
  expect_equal(as.vector(mtx[, 1]), c(1, 1, 2))
  mtx <- as.matrix(ngramTdm(VCorpus(VectorSource("a be c date a boot an cut date crude")),
                            minTermLen = 5,
                            ngram = 2))
  expect_equal(mtx[, 1], c("a boot" = 1, "an cut" = 1, "boot an" = 1, "c date" = 1, 
                           "cut date" = 1, "date a" = 1, "date crude" = 1))
})

test_that("ngramTdm() minBound", {
  mtx <- as.matrix(ngramTdm(VCorpus(VectorSource("a b c d a b a")),
                            minBound = 2))
  expect_equal(mtx[, 1], c("a" = 3, "b" = 2))
  mtx <- as.matrix(ngramTdm(VCorpus(VectorSource("a b c d a b a a b c d a b a a b c d a b a d")),
                            minBound = 4))
  expect_equal(mtx[, 1], c("a" = 9, "b" = 6, "d" = 4))
})

test_that("ngramTdm() delims", {
  mtx <- as.matrix(ngramTdm(VCorpus(VectorSource("a'b. a,c'd a'b! a,a'b"))))
  expect_equal(mtx[, 1], c("a" = 2, "a'b" = 3, "c'd" = 1))
  mtx <- as.matrix(ngramTdm(VCorpus(VectorSource("a'b a c'd a'b a a'b")),
                            delims = " '"))
  expect_equal(mtx[, 1], c("a" = 5, "b" = 3, "c" = 1, "d" = 1))
})
