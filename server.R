#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(png)
library(leaflet)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    documentExcel <- read.csv2("fichier, remplacer le nom",)
    dateVar <- input$date
    exploitVar <- input$exploitation

    output$type <- renderText(
        #"Type de l'exploitation :"
        input$exploitation
        
    )
    
    output$assolement <- renderText(
        #"Assolement :"
        document[document$assolement,(document$annee==dateVar)&(document$exploitation==exploitVar)]
    
    )
    
    output$sdc <- renderText(
        #"sdc :"
        document[document$scd,(document$annee==dateVar)&(document$exploitation==exploitVar)]
        
    )
    
    output$travail <- renderText(
        #"travail :"
        document[document$travail,(document$annee==dateVar)&(document$exploitation==exploitVar)]
        
    )
    
    output$prod_a <- renderText(
        #"Production :"
        document[document$prod_a,(document$annee==dateVar)&(document$exploitation==exploitVar)]
        
    )
    
    output$map <- renderLeaflet(
        #code de la carte à mettre ici
        
    )
        
    output$cultures <- renderTable(
        #rend une table des cultures. A mettre à jour en fonction du tableau
        document[document$culture,(document$annee==dateVar)&(document$exploitation==exploitVar)]
    )
        
    output$image <- renderImage(
        #necessite l'installation du package png !!!
        image <- readPNG("nom de l'image, à voir si on peut en choisir 
                         une spécifique à l'exploit dans un dossier spécial?")
    )
    
    output$texture <- renderPlot(
        
    )
    
    output$fertilite <- renderPlot(
        
    )
    
    output$enjeux <- 

})
