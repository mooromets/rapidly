library(shiny)
shinyUI(
  navbarPage("My App",
             tabPanel("Next word",
                      fluidRow(
                        column(6, offset = 3,
                               align = "center",
                               h3("Type your phrase", style = "font-family: 'Lobster', cursive;
                                                          font-weight: 500; line-height: 1.1; 
                                                          color: #4d3a7d;"),
                               fluidRow(
                                 column(12,
                                        align = "center",
                                        textInput("intext", NULL, "",
                                                  placeholder = "enter text to get the prediction"))),
                               fluidRow(
                                 column(4,
                                        align = "center",
                                        h4(textOutput("otext1"), style = "background-color:#f5f5ff;")),
                                 column(4,
                                        align = "center",
                                        h4(textOutput("otext2"), style = "background-color:#f5f5ff;")), 
                                 column(4,
                                        align = "center",
                                        h4(textOutput("otext3"), style = "background-color:#f5f5ff;")))
                               )
                            )
             ),
             tabPanel("Prediction exploration",
                      fluidRow(
                        column(12,
                               align = "center",
                               h3("Type a phrase to explore how a prediction was built", style = "color: #4d3a7d;"))),
                      fluidRow(
                        column(12,
                               align = "center",
                               textInput("textexplore", NULL, "",
                                        placeholder = "enter a phrase here"),
                               actionButton("submit", "Submit", icon("refresh")),
                               textOutput("statement"),
                               textOutput("cleaned"),
                               tableOutput("idcleaned"),
                               uiOutput("answlist"),
                               tableOutput("allscores"),
                               tableOutput("finalscore"))
                      )
             )
    )  
)