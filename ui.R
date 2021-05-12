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
                  choices = list(`Exploitations innovantes` = list("03N_inn_CHAMIGNON",
                                                                   "03S_inn_DEVILLE",
                                                                   "43E_inn_BONNEVIALLE",
                                                                   "43O_inn_LARGER",
                                                                   "63E_inn_DUCROS",
                                                                   "63N_inn_CHAMBON",
                                                                   "63S_inn_MANLHIOT"),
                                 `Exploitations référentes` = list("03S_ref_BAYOT", 
                                                                   "43E_ref_BONNEVIALLE", 
                                                                   "43O_ref_CHOUVIER",
                                                                   "63N_ref_CROZET",
                                                                   "63S_ref_TOURETTE")
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
      #textOutput(outputId = "assolement"),
      #textOutput(outputId = "sdc"),
      #textOutput(outputId = "travail"),
      #textOutput(outputId = "prod_a")
    ),
    mainPanel(
      navbarPage("DASHBOARD", id="main",
                 tabPanel("Donnees",
                          "Type de l'exploitation :",
                          textOutput(outputId = "type"),
                          "Liste des cultures sur le site pour cette annee :",
                          tableOutput(outputId = "cultures"),
                          "Assolement actuel :",
                          tableOutput(outputId = "assolement"),
                          "Image de l'assolement :",
                          imageOutput("image"),
                          "Texture du sol :",
                          plotOutput("texture"),
                          "Fertilite du sol",
                          plotOutput("fertilite"),
                          "Enjeux autour du site :",
                          tableOutput(outputId = "enjeux")
                          ),
                 tabPanel("Carte", 
                          leafletOutput("map", height=1000)
                          ),
                 tabPanel("Meteo", 
                            fluidRow(
                              # A column is defined necessarily
                              # with its argument "width"
                              column(width = 1, "Site", textOutput(outputId = "SITE")
                              ),
                              column(width = 3, "Altitude max (m)", textOutput(outputId = "altitude")
                              ),
                              column(width = 3, "ensoleillement (h/jour)", textOutput(outputId = "ensoleillement")
                              ),
                              column(width = 2, "gel (j/an)", textOutput(outputId = "gel")
                              ),
                              column(width = 10, "pluie (mm/an)", textOutput(outputId = "pluie"),
                              tableOutput(outputId = "meteo")
                              )
                            )
                 )
      ),
      downloadButton("report", "Generer le recap !")
    )
  )
    
))
