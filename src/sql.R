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
#qBIndex <- "CREATE INDEX bindex ON bigrams(idword1, freq)"
#qTrIndex <- "CREATE INDEX trindex ON trigrams(idword1, idword2, freq)"
#qForIndex <- "CREATE INDEX forindex ON fourgrams(idword1, idword2, idword3, freq)"
#qFIndex <- "CREATE INDEX findex ON fivegrams(idword1, idword2, idword3, idword3, freq)"

