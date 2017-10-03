# server.R
source("plot output maps FUNCTION.R")
library(shiny)
library(ggplot2)
library(reshape2)


shinyServer(
  function(input, output) {
    output$plot1 <- renderPlot({
      x <- switch(input$sp, 
                  "Octopus Vulgaris" = 1,
                  "Melicertus Kerathurus" = 2,
                  "Metapenaeus Monoceros" = 3,
                  "Trachurus Trachurus" = 4, 
                  "Sardina Pilchardus" = 5, 
                  "Sardinella Aurita" = 6, 
                  "Engraulis Encrasicolus" = 7, 
                  "Diplodus Annularis" = 8, 
                  "Mustelus Mustelus" = 9,
                  "Merluccius Merluccius" = 10, 
                  "Pagellus Erythrinus" =11)
      zz <-switch(input$p, 
                 "Biomass" = "biomass", 
                 "Abundance" = "abundance", 
                 "Yield" = "yield", 
                 "Mean size" = "mean_size", 
                 "Trophic level" = "trophic_level")
      
      SOO_Function(x,input$time, z=zz) 

    })
  }
)





               