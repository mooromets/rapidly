source("R/server.R")
source("R/ui.R")

require(shiny)

shinyApp(ui = uiRapidly, server = serverRapidly)
