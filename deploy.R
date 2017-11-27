library(shiny)

deployPath = "deploy/"
srcDeployPath = paste0(deployPath, "src/")
dataPath = paste0(deployPath, "data/")

#create or clean directories
for (path in list(deployPath, srcDeployPath, dataPath)) {
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


#copy database
file.copy("data/words.db", dataPath)

setwd(deployPath)
runApp() #deployApp()
setwd("..")
