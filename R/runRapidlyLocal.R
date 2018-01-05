source("R/server.R")
source("R/ui.R")

runRapidlyLocal <- function () {
  require(shiny)
  
  runApp(list(ui = uiRapidly,
              server = serverRapidly))
}