library(shiny)
setwd("C:/Users/ghalouan/Desktop/dossier_calib/OSMOSE-MAPS-APP")


# ui.R

shinyUI(fluidPage(
  titlePanel("Maps OSMOSE-GoG"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Graphical Interface to plot spatial outputs of OSMOSE Gulf of Gabes"),
      
      selectInput("sp", 
                  label = "Species",
                  choices = c("Octopus Vulgaris", "Melicertus Kerathurus", "Metapenaeus Monoceros",
                              "Trachurus Trachurus", "Sardina Pilchardus", "Sardinella Aurita", 
                              "Engraulis Encrasicolus", "Diplodus Annularis", "Mustelus Mustelus",
                              "Merluccius Merluccius", "Pagellus Erythrinus"),
                  selected = "Boops boops"),
      
      radioButtons("p", 
                  label = "Variable",
                  choices = c("Biomass", "Abundance", "Yield", "Mean size", "Trophic level"),
                  selected = "Biomass"),
      
      
      sliderInput("time", 
                  label = "Time (Month)",
                  min = 1, max = 600, 
                  value = 300, step=2, sep="", animate=animationOptions(interval=1000, loop=T))
      
      ),
    
    mainPanel(
      plotOutput("plot1")
      
    )
  )
))



