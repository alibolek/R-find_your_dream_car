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
      ZOOM=7
      
      
      cars.all <- cars.all[grep(input$cars, cars.all$`İlan Başlığı`,ignore.case = TRUE), ]
      cars.all <- cars.all[cars.all$lon <= (LONG+2) & cars.all$lon >= (LONG-2),]
      cars.all <- cars.all[cars.all$lat <= (LAT+2) & cars.all$lat >= (LAT-2),]
      cars.all <- cars.all[cars.all$Fiyat >= input$inputId[1] & cars.all$Fiyat <= input$inputId[2],]
      cars.all <- cars.all[cars.all$Yıl >= input$tarih[1] & cars.all$Yıl <= input$tarih[2],]
      cars.all <- cars.all[cars.all$Kilometre >= input$km[1] & cars.all$Kilometre <= input$km[2],]
      leaflet() %>% 
        setView(lng=LONG, lat=LAT, zoom=ZOOM ) %>%
        addTiles() %>% addMarkers(lng=cars.all$lon, lat=cars.all$lat, popup=paste(cars.all$shortname,'<br><a href=','https://www.arabam.com', cars.all$links ,'>Go WebSite</a>',sep=""),clusterOptions = markerClusterOptions())
      
      
      
    }
    
  })
}


ui <- fluidPage(
  br(),
  leafletOutput("map", height="600px"),
  absolutePanel(top=30, left=70, textInput("target_zone", "SEHİR GİRİNİZ" , "")),
  
  
  absolutePanel(top=100, left=70,textInput("cars","ARABA GİRİNİZ", "")),
  absolutePanel(top=170, left=70,sliderInput('inputId', label="FİYAT ARALIĞI",min=1,max=500000, value=c(1,500000), step = NULL, round = FALSE,
               dragRange = TRUE)),
  absolutePanel(top=260, left=70,sliderInput('tarih', label="MODEL YILI ARALIĞI",min=1950,max=2017, value=c(1950,2017), step = NULL, round = FALSE,
                                             dragRange = TRUE,timeFormat = "%Y")),
  absolutePanel(top=350, left=70,sliderInput('km', label="KM ARALIĞI",min=0,max=600000, value=c(0,600000), step = NULL, round = FALSE,
                                             dragRange = TRUE))
)

shinyApp(ui = ui, server = server)