library(shiny)
library(shinythemes)
shinyUI(
  navbarPage(span(h3("R", style = "color:orange", class = "displ-inline"), 
                  h3("a", style = "color:yellow", class = "displ-inline"), 
                  h3("p", style = "color:green", class = "displ-inline"), 
                  h3("i", style = "color:orange", class = "displ-inline"), 
                  h3("d", style = "color:red", class = "displ-inline"), 
                  h3("l", style = "color:green", class = "displ-inline"), 
                  h3("y", style = "color:yellow", class = "displ-inline")),
             theme = shinytheme("flatly"),
             tabPanel("Next word",
             tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")),
                      fluidRow(column(12, align = "center",
                               h3("Type your phrase"),
                               textInput("intext", NULL, "",
                                         placeholder = "enter text to get the prediction"))),
                      fluidRow(
                         column(4, offset = 4,
                                align = "center",
                                fluidRow(
                                  column(4, align = "center", p(textOutput("otext1"))),
                                  column(4, align = "center", p(textOutput("otext2"))), 
                                  column(4, align = "center", p(textOutput("otext3")))
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
                               actionButton("submit", "Submit", icon("refresh")),
                               textOutput("cleaned"),
                               tableOutput("idcleaned"),
                               uiOutput("answlist"),
                               tableOutput("allscores"),
                               tableOutput("finalscore"))
                      )
             ),
             tabPanel("Explore a word's presence",
                      fluidRow(
                        column(12,
                               align = "center",
                               h3("Type a word to find out the most frequent phrases with it"))),
                      fluidRow(
                        column(12,
                               align = "center",
                               textInput("wordexplore", NULL, "",
                                         placeholder = "enter a word here"),
                               actionButton("submitword", "Submit", icon("refresh")),
                               p("(this may take up to a few seconds)"),
                               uiOutput("phralist"))
                      )
             )
    )  
)