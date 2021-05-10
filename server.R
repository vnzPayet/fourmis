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
    
    document <- read.csv2("DATA/PARCELLES.csv")
    
    # vraies variables a decommenter:
    #dateVar <- input$date
    #parcelleVar <- input$parcelle
    #exploitVar <- input$exploitation
    
    # variables pour le test
    dateVar <- 2018
    parcelleVar <- "Le Grand Domaine"
    exploitVar <- "03S"

    output$type <- renderText(
        #"Type de l'exploitation :"
        input$exploitation
        
    )
    
    output$assolement <- renderText(
        #"Assolement :"
        assolement <- paste("X",as.character(dateVar),sep=""),
        document[(document$NomParcelle==parcelleVar),assolement]
    
    )
    
    output$sdc <- renderText(
        #"sdc :"
        document[(document$NomParcelle==parcelleVar),document$scd]
        
    )
    
    output$travail <- renderText(
        #"travail :"
        document[(document$NomParcelle==parcelleVar),document$travail]
        
    )
    
    output$prod_a <- renderText(
        #"Production :"
        document[(document$NomParcelle==parcelleVar),document$prod_a]
        
    )
    
    output$map <- renderLeaflet(
        #code de la carte à mettre ici
        
    )
        
    output$cultures <- renderTable(
        #rend une table des cultures. A mettre a jour en fonction du tableau
        document[(document$Site==exploitVar),assolement]
        
    )
        
    output$image <- renderImage(
        #necessite l'installation du package png !!!
        image <- readPNG("nom de l'image, a voir si on peut en choisir 
                         une specifique a l'exploit dans un dossier special?")
    )
    
    output$texture <- renderPlot(
        
    )
    
    output$fertilite <- renderPlot(
        
    )
    
    output$enjeux <- renderTable(
        
    )
    
    output$report <- downloadHandler(
        filename = "report.html",
        content = function(file) {
            # Copy the report file to a temporary directory before processing it, in
            # case we don't have write permissions to the current working dir (which
            # can happen when deployed).
            tempReport <- file.path(tempdir(), "report.Rmd")
            file.copy("report.Rmd", tempReport, overwrite = TRUE)
            
            # Set up parameters to pass to Rmd document
            params <- list(dateVar,exploitVar,parcelleVar)
            
            # Knit the document, passing in the `params` list, and eval it in a
            # child of the global environment (this isolates the code in the document
            # from the code in this app).
            rmarkdown::render(tempReport, output_file = file,
                              params = params,
                              envir = new.env(parent = globalenv())
            )
        }
    )

})
