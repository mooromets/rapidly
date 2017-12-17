require(testthat)
setwd("..")
source("src/wordsDB.R")

context("WordsDB tests")

test_that("creation of WordsDB, opening a connection", {
  wdb <- WordsDB()
  expect_true(dbIsValid(wdb$dataConn))
})

test_that("words and IDs getting", {
  wo <- c("home", "crow", "blue")
  ids <- wdb$getWordID(wo)
  expect_equal(length(ids), length(wo))
  getwo <- wdb$getWord(ids)
  expect_equal(getwo, wo)
  #NA
  wo <- c("home", "NAword", "blue")
  ids <- wdb$getWordID(wo)
  expect_equal(length(ids), length(wo))
  expect_equivalent(ids[2], as.numeric(NA))
  getwo <- wdb$getWord(ids)
  expect_equal(length(getwo), length(wo))
  expect_equivalent(getwo[2], ".NA.")
})

test_that("getNextTopN tests", {
  wo <- c("look", "around")
  ids <- wdb$getWordID(wo)
  expect_equal(nrow(wdb$getNextTopN(ids, 5)), 5)
  expect_equal(nrow(wdb$getNextTopN(ids[2], 5)), 5)
  expect_equal(nrow(wdb$getNextTopN(ids, 2)), 2)
})