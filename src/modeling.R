outPathBase = "data/full1115/"

source("src/modelData.R")
source("src/models.R")
source("src/termMatrixOps.R")

print(lookUp("take a look", choose3top, fiveMostProb, sparseTpmList, ngramTdmList, 
             idsList, dictHash, dictVec))
