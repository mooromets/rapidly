library(Matrix)
library(parallel)

source("src/cleanFiles.R")
source("src/extractTerms.R")
source("src/termPredictionMatrix.R")
source("src/textCleaner.R")
source("src/censure.R")
source("src/customTDM.R")


inpath <- "data/final/en_US/"
outpath <- "data/chunks/"
print(Sys.time())

# split into small chunks and clean (on the way) the input data
trainFiles <- splitFiles(inpath, outpath)
print(Sys.time())

#clean files
cluster <- makeCluster(detectCores())
clusterExport(cluster, c("textCleaner", "perlSplitPattern", 
                         "censuredWords", "cleanPatterns"))
trainFiles <- sample(trainFiles, length(trainFiles)) #shuffle to ease workload
                                                    #TODO sort by filesize
times <- parLapply(cluster, trainFiles, cleanFile)
stopCluster(cluster)
print(Sys.time())

#getting all ngrams
cluster <- makeCluster(min(3, detectCores()))#, type = "FORK")
clusterExport(cluster, c("extractTerms", "sparseTPM", "writeMMTPM", "VCorpus",
                         "customTDMn", "DirSource", "termsInDF", "ctrlList",
                         "TermDocumentMatrix", "NGramTokenizer", "Weka_control",
                         "customDelimiters", "full_join", "splitTerm"))
res <- parLapply(cluster, 2:4, 
          function(n) {
            grams <- extractTerms(n, paste0(outpath, "train/"))
            write.csv(grams, 
                      file = paste0("data/", as.character(n),"gram.csv"), 
                      row.names = FALSE)
            spMtx <- sparseTPM(grams)
            writeMMTPM(spMtx, file = paste0("data/sparse", as.character(n),"gram"))
          })
stopCluster(cluster)

#bi <- read.csv("2gram.csv", stringsAsFactors = FALSE)
#tri <- read.csv("3gram.csv", stringsAsFactors = FALSE)
#four <- read.csv("4gram.csv", stringsAsFactors = FALSE)