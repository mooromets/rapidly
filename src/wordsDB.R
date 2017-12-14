source("src/common.R")
require(RSQLite)

WordsDB <- setRefClass("WordsDB",
                       fields = list(dbname = "character", 
                                     dataConn  = "SQLiteConnection"))

WordsDB$methods(initialize  = function() {
  .self$dbname <- SQLITE_WORDS_DB
  .self$dataConn <- dbConnect(RSQLite::SQLite(), .self$dbname)
})

# destructor 
# ?reg.finalizer