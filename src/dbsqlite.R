library(RSQLite)

source("src/sql.R")

con <- dbConnect(RSQLite::SQLite(), "data/words1.db")

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
#dbSendStatement(con, qMaskFour12x)
#dbSendStatement(con, qMaskFour1x3)
#dbSendStatement(con, qMaskFive123x)
#dbSendStatement(con, qMaskFive12x4)
#dbSendStatement(con, qMaskFive1x34)

dbClearResult(dbListResults(con)[[1]])
dbDisconnect(con)
