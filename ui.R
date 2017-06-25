#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
shinyUI(fluidPage(
        titlePanel("Predict USMLE SCORE from ScienceGPA"),
        sidebarLayout(
                sidebarPanel(
                        sliderInput("sliderGPA", "What is the Science GPA?", 0, 5, value = 4),
                        checkboxInput("showModel1", "Show/Hide Model 1", value = TRUE),
                        checkboxInput("showModel2", "Show/Hide Model 2", value = TRUE)
                ),
                mainPanel(
                        plotOutput("plot1"),
                        h3("Predicted USMLE Score from Model 1:"),
                        textOutput("pred1"),
                        h3("Predicted USMLE Score from Model 2:"),
                        textOutput("pred2")
                )
        )
))
