
source("src/monitor.R")

#outPathBase <- "data/full1119/"

MAX_TERM_LEN <- 100 #queries of a longer size will be cut
#  line <- substr(line, max(1, nchar(line) - MAX_TERM_LEN), nchar(line)) #cut too long line

DEFAULT_PREDICTION <- c("the", "on", "a")

SQLITE_WORDS_DB <- "data/words.db"

MONITOR <- Monitor()

require(RSQLite)
dataConn <- dbConnect(RSQLite::SQLite(), SQLITE_WORDS_DB)
dataDB <- function(dbname = SQLITE_WORDS_DB) {
  if(!dbIsValid(dataConn))
    dataConn <<- dbConnect(RSQLite::SQLite(), dbname)
  dataConn
} 
