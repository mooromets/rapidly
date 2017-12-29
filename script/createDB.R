# Creates a new SQLite database from already loaded data

library(RSQLite)

source("src/common.R")

# SQL queries

qCreateBigramTable <- "
CREATE TABLE bigrams (
idword1 INTEGER, 
idnext INTEGER,
freq INTEGER,
PRIMARY KEY(idword1, freq, idnext)
)
"

qCreateTrigramTable <- "
CREATE TABLE trigrams (
idword1 INTEGER,
idword2 INTEGER, 
idnext INTEGER,
freq INTEGER,
PRIMARY KEY(idword1, idword2, freq, idnext)
)
"

qCreateFourgramTable <- "
CREATE TABLE fourgrams (
idword1 INTEGER,
idword2 INTEGER, 
idword3 INTEGER, 
idnext INTEGER,
freq INTEGER,
PRIMARY KEY(idword1, idword2, idword3, freq, idnext)
)
"

qCreateFivegramTable <- "
CREATE TABLE fivegrams (
idword1 INTEGER,
idword2 INTEGER, 
idword3 INTEGER, 
idword4 INTEGER, 
idnext INTEGER,
freq INTEGER,
PRIMARY KEY(idword1, idword2, idword3, idword4, freq, idnext)
)
"

qCreateDictionaryTable <- "
CREATE TABLE dict (
id INTEGER,
word TEXT,
PRIMARY KEY(id)
)
"

qDictIndex <- "CREATE UNIQUE INDEX dictIndex ON dict(word)"
qMaskFour12x <- "CREATE INDEX fourIndex12x ON fourgrams(idword1, idword2, freq)"
qMaskFour1x3 <- "CREATE INDEX fourIndex1x3 ON fourgrams(idword1, idword3, freq)"
qMaskFive123x <- "CREATE INDEX fiveIndex123x ON fivegrams(idword1, idword2, idword3, freq)"
qMaskFive12x4 <- "CREATE INDEX fiveIndex12x4 ON fivegrams(idword1, idword2, idword4, freq)"
qMaskFive1x34 <- "CREATE INDEX fiveIndex1x34 ON fivegrams(idword1, idword3, idword4, freq)"


# 
# script's start point
#
# pre-requisites:
#  - dictionary data loaded in dictVec
#  - TDMs loaded (bigramTDM, trigramTDM, ...)
#


con <- dbConnect(RSQLite::SQLite(), SQLITE_WORDS_DB)

#create 4 tables
res <- dbSendStatement(con, qCreateBigramTable)
res <- dbSendStatement(con, qCreateTrigramTable)
res <- dbSendStatement(con, qCreateFourgramTable)
res <- dbSendStatement(con, qCreateFivegramTable)
#create dictionary
res <- dbSendStatement(con, qCreateDictionaryTable)

#fill tables with data
tmp <- data.frame(
  id = seq_along(dictVec),
  word = dictVec
)
res <- dbWriteTable(con, "dict", tmp, append = TRUE)
tmp <- data.frame(
    idword1 = bigramTDM$V1,
    idnext = bigramTDM$V2,
    freq = bigramTDM$V3.x
)
res <- dbWriteTable(con, "bigrams", tmp, append = TRUE)
tmp <- data.frame(
  idword1 = trigramTDM$V1,
  idword2 = trigramTDM$V2,
  idnext = trigramTDM$V3,
  freq = trigramTDM$V4.x
)
res <- dbWriteTable(con, "trigrams", tmp, append = TRUE)
tmp <- data.frame(
  idword1 = fourgramTDM$V1,
  idword2 = fourgramTDM$V2,
  idword3 = fourgramTDM$V3,
  idnext = fourgramTDM$V4,
  freq = fourgramTDM$V5.x
)
res <- dbWriteTable(con, "fourgrams", tmp, append = TRUE)
tmp <- data.frame(
  idword1 = fivegramTDM$V1,
  idword2 = fivegramTDM$V2,
  idword3 = fivegramTDM$V3,
  idword4 = fivegramTDM$V4,
  idnext = fivegramTDM$V5,
  freq = fivegramTDM$V6.x
)
res <- dbWriteTable(con, "fivegrams", tmp, append = TRUE)

#indecies
dbSendStatement(con, qDictIndex)
dbSendStatement(con, qMaskFour12x)
dbSendStatement(con, qMaskFour1x3)
dbSendStatement(con, qMaskFive123x)
dbSendStatement(con, qMaskFive12x4)
dbSendStatement(con, qMaskFive1x34)

dbClearResult(dbListResults(con)[[1]])
dbDisconnect(con)
