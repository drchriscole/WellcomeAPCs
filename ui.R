library(shiny)

# Define UI for miles per gallon application
shinyUI(pageWithSidebar(
 
 # Application title
 headerPanel("Wellcome Trust APCs 2012/2013"),
 
 # Sidebar with controls to select the variable to plot against mpg
 # and to specify whether outliers should be included
 sidebarPanel(
  selectInput("type", "Plot data by:",
              list("Journal" = "jrnl",
                   "Publisher" = "pub")),
  
  selectInput("costCalc", "Cost calculation:",
              list("Mean" = "mean",
                   "Total" = "total")),
  
  selectInput("number", "Number:",
              list("10"= 10,
                   "20"= 20,
                   "30"= 30)),
  
  checkboxInput("decreasing","Show most expensive",TRUE)
  
 ),
 
 # Show the caption and plot of the requested variable against mpg
 mainPanel(
  #h3(textOutput("blah")),
  
  plotOutput("pubPlot")
 )
))
