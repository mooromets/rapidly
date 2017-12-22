#freqThres <- 7

#load all TDM tables
bigramTDM <- read.csv(paste0(outPathBase, "en_USblogstxt2FULL.csv"))
trigramTDM <- read.csv(paste0(outPathBase, "en_USblogstxt3FULL.csv"))
fourgramTDM <- read.csv(paste0(outPathBase, "en_USblogstxt4FULL.csv"))
fivegramTDM <- read.csv(paste0(outPathBase, "en_USblogstxt5FULL.csv"))

ngramTdmList <- list(get("bigramTDM"), get("trigramTDM"), get("fourgramTDM"), 
                     get("fivegramTDM"))

#filter rare terms
for (i in seq_len(ngramTdmList))
  if (!is.null(freqThres)) 
    ngramTdmList[i] <- ngramTdmList[i][ngramTdmList[i][, ncol(ngramTdmList[i])] > freqThres, ]
