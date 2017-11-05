library(Matrix)
source("src/termPredictionMatrix.R")
source("src/models.R")

bigrams <- readMMTPM("data/bigrams")
trigrams <- readMMTPM("data/trigrams")
fourgrams <- readMMTPM("data/fourgrams")

insanelySimpleModel("look at the", bigrams, trigrams, fourgrams) 
