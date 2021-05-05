#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  titlePanel("DESCInn \n Développement et Etude de Systèmes de Culture Innovants"), # title
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "exploitation", 
                  label = "Sélectionner l'exploitation :", 
                  selected = 1,
                  choices = list(`Exploitations innovantes` = list("exp_innov"),
                                 `Exploitations référentes` = list("exp_ref")
                                 )
      ),
      dateInput(inputId = "date", 
                label = "Sélectionner la date :", 
                value = Sys.Date(),
                format = "dd/mm/yyyy", 
                startview = "month", 
                weekstart = 1, 
                language = "fr"
      ),
      textOutput(outputId = "assolement"),
      textOutput(outputId = "sdc"),
      textOutput(outputId = "travail"),
      textOutput(outputId = "prod_a")
    ),
    
    mainPanel(
      textOutput(outputId = "type"),
      leafletOutput("map", height=1000),
      tableOutput(outputId = "cultures"),
      imageOutput("image"),
      fluidRow(
        # A column is defined necessarily
        # with its argument "width"
        column(width = 4, "altitude",
               ),
        column(width = 4, "ensoleillement",
               ),
        column(width = 4, "gel",
               ),
        column(width = 4, "pluie",
               )
      ),
      plotOutput("texture"),
      plotOutput("fertilite"),
      tableOutput(outputId = "enjeux"),
      downloadButton("report", "Générer le récap !")
    )
  )
    
))
