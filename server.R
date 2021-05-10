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
    
    document <- read.csv2("PARCELLES.csv", 
                          header=TRUE, dec=".", sep=";", 
                          skip=7)
    
    # vraies variables a decommenter:
    #dateVar <- as.integer(input$date)
    #siteVar <- input$site
    
    # variables pour le test
    dateVar <- as.integer(2018)
    siteVar <- "03S"

    output$type <- renderText(
        #"Type de du site :"
        typeVar <- as.character(document[(document$Site==siteVar),document$SousSite][1,1])
    )
    
    output$assolement <- renderText(
        #"Assolement :"
        assolementVar <- paste("X",as.character(dateVar),sep="")
        #document[(document$Site==siteVar),assolementVar]
    
    )
    
    output$sdc <- renderText(
        #"sdc :"
        #document[(document$NomParcelle==parcelleVar),document$scd]
        
    )
    
    output$travail <- renderText(
        #"travail :"
        #document[(document$NomParcelle==parcelleVar),document$travail]
        
    )
    
    output$prod_a <- renderText(
        #"Production :"
        #document[(document$NomParcelle==parcelleVar),document$prod_a]
        
    )
    
    output$map <- renderLeaflet(
        #code de la carte Ã  mettre ici
        
    )
        
    output$cultures <- renderTable(
        #Rend une table de l'ensemble des cultures présentes sur le site à la date demandée 
        assolementVar <- paste("X",as.character(dateVar),sep="")
        document[(document$Site==siteVar),assolementVar]
        
    )
        
    output$image <- renderImage(
        ##necessite l'installation du package png !!!
        #image <- readPNG("nom de l'image, a voir si on peut en choisir 
        #                 une specifique a l'exploit dans un dossier special?")
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
            params <- list(dateVar,siteVar)
            
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
