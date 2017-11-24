qCreateBigramTable <- "
  CREATE TABLE bigrams (
  idword1 INTEGER, 
  idnext INTEGER,
  freq INTEGER,
  PRIMARY KEY(idword1, idnext)
  )
  "

qCreateTrigramTable <- "
  CREATE TABLE trigrams (
  idword1 INTEGER,
  idword2 INTEGER, 
  idnext INTEGER,
  freq INTEGER,
  PRIMARY KEY(idword1, idword2, idnext)
  )
  "

qCreateFourgramTable <- "
  CREATE TABLE fourgrams (
  idword1 INTEGER,
  idword2 INTEGER, 
  idword3 INTEGER, 
  idnext INTEGER,
  freq INTEGER,
  PRIMARY KEY(idword1, idword2, idword3, idnext)
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
  PRIMARY KEY(idword1, idword2, idword3, idword4, idnext)
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
qMaskFour12x <- "CREATE INDEX fourIndex12x ON fourgrams(idword1, idword2)"
qMaskFour1x3 <- "CREATE INDEX fourIndex1x3 ON fourgrams(idword1, idword3)"
qMaskFive123x <- "CREATE INDEX fiveIndex123x ON fivegrams(idword1, idword2, idword3)"
qMaskFive12x4 <- "CREATE INDEX fiveIndex12x4 ON fivegrams(idword1, idword2, idword4)"
qMaskFive1x34 <- "CREATE INDEX fiveIndex1x34 ON fivegrams(idword1, idword3, idword4)"
qBIndex <- "CREATE INDEX bindex ON bigrams(idword1, freq)"
qTrIndex <- "CREATE INDEX trindex ON trigrams(idword1, idword2, freq)"
qForIndex <- "CREATE INDEX forindex ON fourgrams(idword1, idword2, idword3, freq)"
qFIndex <- "CREATE INDEX findex ON fivegrams(idword1, idword2, idword3, idword3, freq)"

