library(shiny)
library(DT)

source("src/models.R")
source("src/search.R")

shinyServer(function(input, output, session) {
  observeEvent(input$intext, {
    if (length(grep(" $", input$intext)) > 0 ) {
      res <- lookDB(input$intext, bestWithMask)
      output$otext1 <- renderText(res[1])
      output$otext2 <- renderText(res[2])
      output$otext3 <- renderText(res[3])
    }
  })
  
  monitor <- eventReactive(input$submit, {
    res <- lookDB(input$textexplore, bestWithMask, monitor = TRUE)
    (MonitorData)
  })

  output$statement <- renderText(paste("Statement:", monitor()$inputStatement))
  output$cleaned <- renderText(paste("Cleaned:", monitor()$cleanStatement))
  output$idcleaned <- renderTable(monitor()$cleanStatementIDs, colnames = FALSE)
  output$allscores <- renderTable(monitor()$allScores, colnames = FALSE)
  output$finalscore <- renderTable(monitor()$finalScore, colnames = FALSE)

  tfc = function(m, output, id){
    output[[id]] <- renderTable(m[["nextdf"]], colnames = FALSE)
    tags$div(
      p(paste(m[["words"]], collapse = " ")),
      tableOutput(id))
  }
  
  output$answlist <- renderUI({
    lapply(seq_along(monitor()$answersList), 
           function(idx){
             tfc(monitor()$answersList[[idx]], 
                 output, 
                 paste0("tabl", as.character(idx)))
           })
  })

})