#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)


# Define UI with input text box 
shinyUI(
  
  fluidPage(
    # Copy the line below to make a text input box
    textInput("text", label = h3("Write a few words here:"), value = "I want to"),
    "(The prediction might take up to 10 seconds)",
    hr(),
    plotOutput("plot")
    
  )
  
)



