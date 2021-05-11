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
                 choices = list(`Exploitations innovantes` = list("03N_CHAMIGNON",
                                                                   "03S_DEVILLE",
                                                                   "43E_BONNEVIALLE",
                                                                   "43O_LARGER",
                                                                   "63E_DUCROS",
                                                                   "63N_CHAMBON",
                                                                   "63S_MANLHIOT"),
                                 `Exploitations référentes` = list("03S_BAYOT", 
                                                                   "43E_BONNEVIALLE", 
                                                                   "43O_CHOUVIER",
                                                                   "63N_CROZET",
                                                                   "63S_TOURETTE")
                  )
      ),
      sliderInput(inputId = "date",
                  label = "selectionner une date",
                  min = 2017,
                  max = 2025,
                  value = 2020,
                  step = 1
                  ),
#      dateInput(inputId = "date", 
#                label = "Sélectionner la date :", 
#                value = Sys.Date(),
#                format = "dd/mm/yyyy", 
#                startview = "month", 
#                weekstart = 1, 
#                language = "fr"
#      ),
      textOutput(outputId = "assolement"),
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
                              # A column is defined necessarily
                              # with its argument "width"
                              column(width = 3, "Site", textOutput(outputId = "SITE")
                              ),
                              column(width = 3, "Altitude max (m)", textOutput(outputId = "altitude")
                              ),
                              column(width = 3, "ensoleillement (h/jour)", textOutput(outputId = "ensoleillement")
                              ),
                              column(width = 3, "gel (j/an)", textOutput(outputId = "gel")
                              ),
                              column(width = 3, "pluie (mm/an)", textOutput(outputId = "pluie"),
                              tableOutput(outputId = "meteo")
                              )
                            )
                 )
      ),
      downloadButton("report", "Generer le recap !")
    )
  )
    
))
