library(leaflet)
library(tidyverse)
library(lubridate)
library(RColorBrewer)

# server logic
server <- function(input, output, session) {

    # full data and color palette.
    data <- read_csv("world_earthquakes.csv")
    colorpal <- colorNumeric("YlOrRd", data$mag)

    # reactive data.
    filteredData <- reactive({
        data <- read_csv("world_earthquakes.csv") %>% filter(year(time) >= input$year_range[1] & year(time) <= input$year_range[2] & mag >= input$mag_range[1] & mag <= input$mag_range[2])
    })

    # draw and center view to north america
    output$map <- renderLeaflet({
        leaflet(data) %>% 
            setView(lng = -99, lat = 42, zoom = 3)  %>%
            addTiles() %>% 
            addCircles(
                lat = ~ latitude, 
                lng = ~ longitude, 
                color = "#777777",
                fillColor = ~colorpal(mag), 
                fillOpacity = 0.5,
                radius = ~ exp(sqrt(mag))*mag*1000, 
                weight = 1, 
                popup = ~as.character(sprintf("Magnitude: %s<br>Year: %s<br>Place: %s", mag, year(time), place)), 
                label = ~as.character(sprintf("Magnitude: %s, Year: %s, Place: %s", mag, year(time), place))
            )
    })

    # redraw based on controllers.
    observe({
        leafletProxy("map", data = filteredData()) %>%
            clearShapes() %>%
            addCircles(
                lat = ~ latitude, 
                lng = ~ longitude, 
                color = "#777777",
                fillColor = ~colorpal(mag), 
                fillOpacity = 0.5, 
                radius = ~ exp(sqrt(mag))*mag*1000, 
                weight = 1, 
                popup = ~as.character(sprintf("Magnitude: %s<br>Year: %s<br>Place: %s", mag, year(time), place)), 
                label = ~as.character(sprintf("Magnitude: %s, Year: %s, Place: %s", mag, year(time), place))
        )
    })
}
