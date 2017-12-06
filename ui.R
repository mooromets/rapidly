library(shiny)
library(shinythemes)
shinyUI(
  navbarPage(span(p("R", class = "displ-inline rapidly color-orange"), 
                  p("a", class = "displ-inline rapidly color-yellow"), 
                  p("p", class = "displ-inline rapidly color-green"), 
                  p("i", class = "displ-inline rapidly color-orange"), 
                  p("d", class = "displ-inline rapidly color-red"), 
                  p("l", class = "displ-inline rapidly color-green"), 
                  p("y", class = "displ-inline rapidly color-yellow")),
             theme = shinytheme("flatly"),
             tabPanel("Next word suggestions",
             tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")),
                      fluidRow(column(12, align = "center",
                               h3("Start typing..."),
                               textInput("intext", NULL, "",
                                         placeholder = "your text here"),
                               h6(style = "color: #b4bcc2", textOutput("nextwordtime")))),
                      fluidRow(
                         column(4, offset = 4,
                                align = "center",
                                fluidRow(
                                  column(4, align = "center", h4(textOutput("otext1"))),
                                  column(4, align = "center", h4(textOutput("otext2"))), 
                                  column(4, align = "center", h4(textOutput("otext3")))
                                )
                            )
                      )
             ),
             tabPanel("Prediction exploration",
                      fluidRow(
                        column(12,
                               align = "center",
                               h3("Type a phrase to explore how a prediction was built"))),
                      fluidRow(
                        column(12,
                               align = "center",
                               textInput("textexplore", NULL, "",
                                            placeholder = "enter a phrase here"),
                               actionButton("submit", "Submit", class = "btn btn-primary"))),
                      fluidRow(
                        column(4, offset = 4,
                               align = "center",
                               fluidRow(
                                 column(4, align = "center", h3(textOutput("pred1"))),
                                 column(4, align = "center", h3(textOutput("pred2"))), 
                                 column(4, align = "center", h3(textOutput("pred3")))
                               )
                        )
                      ),                      
                      fluidRow(
                        tags$div(class = "jumbotron",
                                 fluidRow(
                                          column(4,
                                                 h4("Cleaned input phrase"),
                                                 h5(textOutput("cleaned"))),
                                          column(4,
                                                 h4("Words found in the dictionary"),
                                                 h6("(only the last 4 are taken for the prediction)"),
                                                 tableOutput("idcleaned"))
                                 )
                        )),
                      fluidRow(
                        tags$div(class = "jumbotron",
                                 fluidRow(column(4,
                                                 h4("Top results in each query"),
                                                 uiOutput("answlist")),
                                          column(4, 
                                                 h4("Coefficients applied to each candidate"),
                                                 tags$div(tableOutput("allscores"))
                                                 ),
                                          column(4,
                                                 h4("Ordered summary table"),
                                                 tags$div(tableOutput("finalscore")))
                                                 )
                        )
                      )

             ),
             tabPanel("Word presence exploration",
                      fluidRow(
                        column(12,
                               align = "center",
                               h3("Type a word to find out the most frequent phrases with it"))),
                      fluidRow(
                        column(12,
                               align = "center",
                               textInput("wordexplore", NULL, "",
                                         placeholder = "enter a word here"),
                               actionButton("submitword", "Submit", class = "btn btn-primary"),
                               p("(this may take a few seconds)"))
                      ),
                      fluidRow(
                        column(12,
                               uiOutput("phralist"))
                      )
             )
    )  
)