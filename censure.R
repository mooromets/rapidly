# get (read) censured words as pattern to gsub
censuredWords <- function(filename = "data/censure.txt") {
  censured <- ""
  cens <- file(filename, "r")
  repeat {
    line = readLines(cens, n = 1)
    if ( length(line) == 0 ) {
      censured <- paste0(censured, ")( |$)")
      break
    }
    if (nchar(censured) == 0)
      censured <- paste0("( |^)(", line)
    else
      censured <- paste0(censured, "|", line)
  }
  close(cens)
  censured
}