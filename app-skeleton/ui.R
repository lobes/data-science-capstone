#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that reads side bar panel and outputs to main panel
shinyUI(fluidPage(

    # Application title
    titlePanel("Shiny App Skeleton"),

    # Sidebar with a textbox input
    sidebarLayout(
        sidebarPanel(
            textInput("text_input", "Write some text here:")),

        # Show what the user input in the sidebar
        mainPanel(
            textOutput("text_output")
        )
    )
))
