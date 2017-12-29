library(shiny)

source("src/models.R")
source("src/search.R")
source("src/presence.R")

shinyServer(function(input, output, session) {
  observeEvent(input$intext, {
    if (nchar(input$intext) > 0 ) {
      t <- system.time({
        res <- lookDB(input$intext, bestWithMask)
      })  
      timeStr <- paste0("(", as.character(round(t[3], 3)) ," seconds)")
    } else {
      res <- rep("", 3)
      timeStr <- ""
    }
    output$otext1 <- renderText(res[1])
    output$otext2 <- renderText(res[2])
    output$otext3 <- renderText(res[3])
    output$nextwordtime <- renderText(timeStr)
  })
  
  monitor <- eventReactive(input$submit, {
    res <- lookDB(input$textexplore, bestWithMask, monitor = TRUE)
    output$pred1 <- renderText(res[1])
    output$pred2 <- renderText(res[2])
    output$pred3 <- renderText(res[3])
    (MONITOR$m_data)
  })

  output$cleaned <- renderText(monitor()$cleanStatement)
  output$idcleaned <- renderTable(monitor()$cleanStatementIDs, colnames = FALSE, digits = 3)
  output$allscores <- renderTable(monitor()$allScores, colnames = FALSE, digits = 3)
  output$finalscore <- renderTable(monitor()$finalScore, colnames = FALSE, digits = 3)

  tfc = function(m, output, id, card, color){
    output[[id]] <- renderTable(m[["nextdf"]], colnames = FALSE, digits = 3)
    tags$div(class = card,
      h4(paste(m[["words"]], collapse = " "), class = color, style = "margin:15px"),
      tableOutput(id))
  }
  
  output$answlist <- renderUI({
    cards <- c("tab-panes border-green",
              "tab-panes border-orange",
              "tab-panes border-red",
              "tab-panes border-indigo")
    colors <- c("color-green",
               "color-orange",
               "color-red",
               "color-indigo")
    lapply(seq_along(monitor()$answersList), 
           function(idx){
             tfc(monitor()$answersList[[idx]], 
                 output, 
                 paste0("tabl", as.character(idx)),
                 cards[idx],
                 colors[idx])
           })
  })
  
  phrs <- eventReactive(input$submitword, {
    presenceList(input$wordexplore)
  })

  output$phralist <- renderUI({
    fluidRow(
      lapply(seq_along(phrs()), 
             function(idx){
               column( 3,
                 tags$div(class = "tab-panes border-gray",
                   apply(phrs()[[idx]], 1, 
                         function(item) {
                           item[item == input$wordexplore] <- paste("<strong>", input$wordexplore, "</strong>")
                           tags$div(HTML(paste(item, collapse = " ")))
                          })
                 )
               )
             })
    )
  })
  
  onStop(function() {
    dbDisconnect(dataDB())
  })
})