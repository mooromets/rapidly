library(shiny)

source("src/models.R")
source("src/termMatrixOps.R")

shinyServer(function(input, output, session) {
  newVals = reactive({
    mydata = input$intext
    mydata
  })
  
  observe({
    if (length(grep(" $", input$intext)) > 0 ) {
      res <- lookDB(input$intext, bestWithMask)
      output$otext1 <- renderText(res[1])
      output$otext2 <- renderText(res[2])
      output$otext3 <- renderText(res[3])
    }
  })
})