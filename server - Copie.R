#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)


shinyServer(function(input, output) {

    
    # vraies variables a decommenter:
    dateVar <- reactive(input$date)

    output$assolement <- renderText(

        as.character(siteVar)
    )


})

