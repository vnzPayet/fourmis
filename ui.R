#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(png)
library(leaflet)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  titlePanel("DESCInn \n Développement et Etude de Systèmes de Culture Innovants"), # title
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "site", 
                  label = "Sélectionner le site :", 
                  selected = 1,
                  choices = list(`Exploitations innovantes` = list("site_innov"),
                                 `Exploitations référentes` = list("site_ref")
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
      #textOutput(outputId = "assolement"),
      #textOutput(outputId = "sdc"),
      #textOutput(outputId = "travail"),
      #textOutput(outputId = "prod_a")
    ),
    mainPanel(
      navbarPage("DASHBOARD", id="main",
                 tabPanel("Donnees", 
                          textOutput(outputId = "type"),
                          tableOutput(outputId = "cultures"),
                          imageOutput("image"),
                          plotOutput("texture"),
                          plotOutput("fertilite"),
                          tableOutput(outputId = "enjeux")
                          ),
                 tabPanel("Carte", 
                          leafletOutput("map", height=1000)
                          ),
                 tabPanel("Meteo", 
                            fluidRow(
                              tableOutput(outputId = "meteo"),
                              # A column is defined necessarily
                              # with its argument "width"
                              #textOutput(outputId = "altitude"),
                              column(width = 3, "Altitude max (m)", textOutput(outputId = "altitude")
                              ),
                              #textOutput(outputId = "ensoleillement"),
                              column(width = 3, "ensoleillement (h/jour)", textOutput(outputId = "ensoleillement")
                              ),
                              #textOutput(outputId = "gel"),
                              column(width = 3, "gel (j/an)", textOutput(outputId = "gel")
                              ),
                              #textOutput(outputId = "pluie")
                              column(width = 3, "pluie (mm/an)", textOutput(outputId = "pluie"),
                                     #column(width = 3, "site")
                              )
                            )
                 )
      ),
      downloadButton("report", "Generer le recap !")
    )
  )
    
))
