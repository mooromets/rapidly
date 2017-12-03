library(shiny)

deployPath = "deploy/rapidly/"
srcDeployPath = paste0(deployPath, "src/")
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
file.copy("ui.R", deployPath)
file.copy("server.R", deployPath)
file.copy("src/models.R", srcDeployPath)
file.copy("src/data.R", srcDeployPath)
file.copy("src/search.R", srcDeployPath)
file.copy("src/common.R", srcDeployPath)
file.copy("src/cleanText.R", srcDeployPath)
file.copy("src/monitor.R", srcDeployPath)
file.copy("src/presence.R", srcDeployPath)

file.copy("www/custom.css", wwwPath)

#copy database
file.copy("data/words.db", dataPath)

setwd(deployPath)
deployApp()
setwd("../..")
