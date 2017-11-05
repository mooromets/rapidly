library(Matrix)
source("src/termPredictionMatrix.R")
source("src/models.R")

bigrams <- readMMTPM("data/sparse2gram")
trigrams <- readMMTPM("data/sparse3gram")
fourgrams <- readMMTPM("data/sparse4gram")

insanelySimpleModel("look at the", bigrams, trigrams, fourgrams) 
