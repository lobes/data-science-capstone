#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to output the same text from input box
shinyServer(function(input, output) {

    output$text_output <- renderText({
        input$text_input
    })

})
