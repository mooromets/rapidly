library(Matrix)
source("src/termPredictionMatrix.R")

bigrams <- readMMTPM("data/bigrams")
trigrams <- readMMTPM("data/trigrams")
fourgrams <- readMMTPM("data/fourgrams")