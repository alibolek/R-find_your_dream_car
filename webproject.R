library(shiny)
library(leaflet)
library(ggmap)

server <- function(input, output) {
  
  output$map <- renderLeaflet({
    
    # Get latitude and longitude
    if(input$target_zone=="Ex: Bamako"){
      ZOOM=2
      LAT=0
      LONG=0
    }else{
      target_pos=geocode(input$target_zone)
      LAT=target_pos$lat
      LONG=target_pos$lon
      ZOOM=5
      
      leaflet() %>%
        setView(lng=LONG, lat=LAT, zoom=ZOOM ) %>%
        addTiles() %>% addMarkers(lng=32.85974, lat=39.93336, popup=paste("slm",'<br><a href="http://www.google.com">Web Site</a>'))
      
    }
    
    # Plot it!
    
  })
}


ui <- fluidPage(
  br(),
  leafletOutput("map", height="600px"),
  absolutePanel(top=20, left=70, textInput("target_zone", "" , "Your City")),
  
  
  absolutePanel(top=80, left=70,selectInput(selected = 1,"shortname", "Cars",
                                            cars.all$shortname))
  
)

shinyApp(ui = ui, server = server)