library(shiny)
library(rsconnect)

deployPath = "deploy/rapidly/"
srcDeployPath = paste0(deployPath, "R/")
dataPath = paste0(deployPath, "data/")
wwwPath = paste0(deployPath, "www/")

#create or clean directories
for (path in list(deployPath, srcDeployPath, dataPath, wwwPath)) {
  if (! dir.exists(path)) {
    dir.create(path)
  } else {
    sapply(list.files(path, full.names = TRUE, include.dirs = FALSE), 
           function(f) if (! file.info(f)$isdir) file.remove(f))
  }
}

#copy source files
file.copy("R/app.R", deployPath)
file.copy("R/ui.R", srcDeployPath)
file.copy("R/server.R", srcDeployPath)
file.copy("R/models.R", srcDeployPath)
file.copy("R/search.R", srcDeployPath)
file.copy("R/common.R", srcDeployPath)
file.copy("R/cleanText.R", srcDeployPath)
file.copy("R/monitor.R", srcDeployPath)
file.copy("R/presence.R", srcDeployPath)
file.copy("R/wordsDB.R", srcDeployPath)

file.copy("www/custom.css", wwwPath)

#copy database
file.copy("data/words.db", dataPath)

setwd(deployPath)
deployApp()
setwd("../..")
