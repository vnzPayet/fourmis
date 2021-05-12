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
library(rgdal)
library(stringr)
library(rmapshaper)
library(dplyr)


shinyServer(function(input, output) {
    
    document <- read.csv2("DATA/PARCELLES2.csv", header=TRUE, dec=",", sep=";", 
                         encoding = "latin1")
    
    # vraies variables a decommenter:
    dateVar <- reactive(input$date)
    siteVar <- reactive(input$site)
    
    
    # variables pour le test
    #dateVar <- as.integer(2018)
    #siteVar <- "03S"

    output$type <- renderText(
        typeVar <- as.character(document[(document$Site==str_sub(input$site,start=1,end=3)),2][1])
    )
    
    output$assolement <- renderTable(
      assolement <- document[(document$Site==str_sub(input$site,start=1,end=3))
                           &(document$SousSite==as.character(document[(document$Site==str_sub(input$site,start=1,end=3)),2][1])),
                           10:18]
    )
    
    
    
#    output$sdc <- renderText(
#        #"sdc :"
#        #document[(document$Site==siteVar),document$scd]
#    )
    
#    output$travail <- renderText(
#        #"travail :"
#        #document[(document$Site==siteVar),document$travail]
#    )
    
#    output$prod_a <- renderText(
#        #"Production :"
#        #document[(document$Site==siteVar),document$prod_a]
#    )
   
    output$cultures <- renderTable(
      #Rend une table de l'ensemble des cultures presentes sur le site a la date demandee 
      cultures <- document[(document$Site==str_sub(input$site,start=1,end=3))
                           &(document$SousSite==as.character(document[(document$Site==str_sub(input$site,start=1,end=3)),2][1])),
                           paste("X",as.character(input$date),sep = "")]
        
    )

#    output$image <- renderImage(
#        ##necessite l'installation du package png !!!
#        #image <- readPNG("nom de l'image, a voir si on peut en choisir 
#        #                 une specifique a l'exploit dans un dossier special?")
#    )

    output$texture <- renderPlot(
      pie(c(document[(document$Site==str_sub(input$site,start=1,end=3))&(document$SousSite=="innovant"),
                     8:9][1,1],
            document[(document$Site==str_sub(input$site,start=1,end=3))&(document$SousSite=="innovant"),
                     8:9][1,2],
            100-document[(document$Site==str_sub(input$site,start=1,end=3))&(document$SousSite=="innovant"),
                         8:9][1,1]-document[(document$Site==str_sub(input$site,start=1,end=3))&(document$SousSite=="innovant"),
                                            8:9][1,2]),
          labels = c("argile","limons","reste"))
    )

#    output$fertilite <- renderPlot(
#    )

#    output$enjeux <- renderTable(
#    )    
    
    #THE carte
    output$map <- renderLeaflet({
      
      file <- paste("DATA/KML/", input$site, ".kml", sep = "") #création chemin d'accès
      shp <- rgdal::readOGR(file) #import
      
      leaflet(shp) %>%
        addTiles() %>%
          addPolygons(stroke = T,
                      color = "red", weight = 2, smoothFactor = 0.5,
                      opacity = 1.0, fillOpacity = 0.2,
                      fillColor = "red", 
                      highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = TRUE),
                      label = ~as.character(shp$Name)
          )
    })

       

    
    ### PARTIE SUR LA MÉTÉO ### ESSAI AVEC UNE VALEUR FIXE POUR LE SITE AVANT DE METTRE LE SITE EN VARIABLE
    datameteo <- read.csv2(file = "DATA/CLIMAT_resume.csv", sep = ";", header = TRUE, encoding = "latin1")
   
    #output$altitude <- renderText({
    #  test1 <- input$site
    #  paste(substr(test1,1,3))
    #  })
    
    ##on remplit la case du site
    output$SITE <- renderText({
      test1 <- input$site
      paste(substr(test1,1,3))
    })
  
    ##on remplit la case de l'altitude
    output$altitude <- renderText({
        test1 <- input$site
        test2 <- substr(test1,1,3)
        alti1 <- datameteo %>% filter(Site==test2)
        alti1$altitude.max..m.   
    })
    ##on remplit la case de l'ensoleillement
    output$ensoleillement <- renderText({
        test1 <- input$site
        test2 <- substr(test1,1,3)
        soleil1 <- datameteo %>% filter(Site==test2)
        soleil1$ensoleillement..h.jour. 
    })
    ##on remplit la case du gel
    output$gel <- renderText({
        test1 <- input$site
        test2 <- substr(test1,1,3)
        gel1 <- datameteo %>% filter(Site==test2)
        gel1$gel..j.an.
    })
    ##on remplit la case de pluviométrie
    output$pluie <- renderText({
        test1 <- input$site
        test2 <- substr(test1,1,3)
        pluie1 <- datameteo %>% filter(Site==test2)
        pluie1$pluviometrie..mm.an.
    })
    ##on affiche le tableau avec toutes les données météo
    output$meteo <- renderTable({datameteo})
    
    output$report <- downloadHandler(
        filename = "report.html",
        content = function(file) {
            # Copy the report file to a temporary directory before processing it, in
            # case we don't have write permissions to the current working dir (which
            # can happen when deployed).
            ##tempReport <- file.path(tempdir(), "report.Rmd")
            ##file.copy("report.Rmd", tempReport, overwrite = TRUE)
            
            # Set up parameters to pass to Rmd document
            params <- list(site = input$site,
                           date = input$date
                           )
            
            # Knit the document, passing in the `params` list, and eval it in a
            # child of the global environment (this isolates the code in the document
            # from the code in this app).
            rmarkdown::render("report.Rmd",
                              params = params,
                              output_dir = NULL,
                              envir = new.env(parent = globalenv())
            )
        }
    )

})
