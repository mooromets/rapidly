library(shiny)
shinyServer(function(input, output, session) {
  newVals = reactive({
    mydata = input$intext
    mydata
  })
  
  observe({
    if (length(grep(" $", input$intext)) > 0 ) {
      output$otext1 <- renderText("the")
      output$otext2 <- renderText("the2")
      output$otext3 <- renderText("the3")
    }
  })
})