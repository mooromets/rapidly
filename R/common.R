
source("R/monitor.R")

Monitor <- getRefClass("Monitor")


#outPathBase <- "data/full1119/"

MAX_TERM_LEN <- 100 #queries of a longer size will be cut
#  line <- substr(line, max(1, nchar(line) - MAX_TERM_LEN), nchar(line)) #cut too long line

NGRAM_RANGE <- 2:5

DEFAULT_PREDICTION <- c("the", "on", "a")

SQLITE_WORDS_DB <- "data/words.db"

MONITOR <- Monitor()