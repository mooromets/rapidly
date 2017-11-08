library(parallel)

source("src/cleanFiles.R")
source("src/textCleaner.R")
source("src/censure.R")

inpath <- "data/final/en_US/"
outpath <- "data/chunks/"

# split into small chunks and clean (on the way) the input data
trainFiles <- splitFiles(inpath, outpath)

#clean files
cluster <- makeCluster(detectCores())
clusterExport(cluster, c("textCleaner", "perlSplitPattern", 
                         "censuredWords", "cleanPatterns"))
trainFiles <- sample(trainFiles, length(trainFiles)) #shuffle to ease workload
                                                    #TODO sort by filesize
times <- parLapply(cluster, trainFiles, cleanFile)
stopCluster(cluster)