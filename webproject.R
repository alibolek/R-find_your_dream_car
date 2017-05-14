library(shiny)
library(leaflet)
library(ggmap)
library(geosphere)


server <- function(input, output) {
  
  output$map <- renderLeaflet({
    
    # Get latitude and longitude
    if(input$target_zone=="ex. Muğla"){
      ZOOM=5
      LAT=37.21537
      LONG=28.36339
      
      leaflet() %>% 
        setView(lng=LONG, lat=LAT, zoom=ZOOM ) %>%
        addTiles() %>% addMarkers(lng=cars.all$lon, lat=cars.all$lat, popup=paste("slm",'<br><a href="http://www.google.com">Web Site</a>'))
      
      
    }else{
      target_pos=geocode(input$target_zone)
      LAT=target_pos$lat
      LONG=target_pos$lon
      ZOOM=5
      
      
      
      cars.all <- cars.all[cars.all$lon <= (LONG+1) & cars.all$lon >= (LONG-1),]
      cars.all <- cars.all[cars.all$lat <= (LAT+1) & cars.all$lat >= (LAT-1),]
      
      leaflet() %>% 
        setView(lng=LONG, lat=LAT, zoom=ZOOM ) %>%
        addTiles() %>% addMarkers(lng=cars.all$lon, lat=cars.all$lat, popup=paste(cars.all$shortname,'<br><a href="http://www.google.com">Web Site</a>'),clusterOptions = markerClusterOptions())
      
      
      
    }
    
    # Plot it!
    #cars.all <- cars.all[cars.all[,7] == input$target_zone]
    
    
    
  })
}


ui <- fluidPage(
  br(),
  leafletOutput("map", height="600px"),
  absolutePanel(top=20, left=70, textInput("target_zone", "" , "ex. Muğla")),
  
  
  absolutePanel(top=80, left=70,selectInput(selected = 1,"shortname", "Cars",
              cars.all$shortname))
  
)

shinyApp(ui = ui, server = server)