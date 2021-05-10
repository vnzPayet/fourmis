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
    dateVar <- input$date
    exploitVar <- input$exploitation

    output$type <- renderText(
        #"Type de l'exploitation :"
        input$exploitation
        
    )
    
    output$assolement <- renderText(
        #"Assolement :"
        assolement <- paste("X",as.character(dateVar),sep=""),
        document[assolement,(document$exploitation==exploitVar)]
    
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
            params <- list(dateVar)
            
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
